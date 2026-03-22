from datetime import datetime, timedelta
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from api.database import get_db
from api.models import Listing, BookingRequest
from api.schemas import BookingCreate
from api.services.pricing import calculate_price_breakdown
from api.services.availability import check_availability
from api.services.notifications import notify_new_booking
from api.config import get_settings

router = APIRouter()


@router.post("/api/v1/bookings", status_code=201)
async def create_booking(payload: BookingCreate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Listing)
        .options(selectinload(Listing.host))
        .where(Listing.slug == payload.listing_slug, Listing.status == "active")
    )
    listing = result.scalar_one_or_none()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    avail = await check_availability(db, listing, payload.check_in, payload.check_out, payload.guest.num_guests)
    if not avail["available"]:
        raise HTTPException(status_code=409, detail=avail["reason"])

    breakdown = calculate_price_breakdown(listing, payload.check_in, payload.check_out)

    booking = BookingRequest(
        listing_id=listing.id,
        check_in=payload.check_in,
        check_out=payload.check_out,
        guest_name=payload.guest.name,
        guest_email=payload.guest.email,
        guest_phone=payload.guest.phone,
        num_guests=payload.guest.num_guests,
        message=payload.guest.message,
        agent_name=payload.agent_name,
        price_breakdown=breakdown,
        total_price=breakdown["total"],
        expires_at=datetime.utcnow() + timedelta(hours=24)
    )
    db.add(booking)
    await db.commit()
    await db.refresh(booking)

    host_chat_id = listing.host.telegram_chat_id if listing.host else None
    await notify_new_booking(host_chat_id, {
        "id": booking.id,
        "guest_name": booking.guest_name,
        "guest_email": booking.guest_email,
        "check_in": str(booking.check_in),
        "check_out": str(booking.check_out),
        "num_guests": booking.num_guests,
        "total_price": float(booking.total_price) if booking.total_price else None
    }, listing.name)

    return {
        "id": booking.id,
        "listing_id": booking.listing_id,
        "status": booking.status,
        "check_in": booking.check_in.isoformat(),
        "check_out": booking.check_out.isoformat(),
        "guest_name": booking.guest_name,
        "guest_email": booking.guest_email,
        "num_guests": booking.num_guests,
        "agent_name": booking.agent_name,
        "price_breakdown": booking.price_breakdown,
        "total_price": float(booking.total_price) if booking.total_price else None,
        "created_at": booking.created_at.isoformat(),
        "message": "Booking request submitted. Host will confirm within 24 hours."
    }


@router.get("/api/v1/bookings/{booking_id}")
async def get_booking(booking_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(BookingRequest).where(BookingRequest.id == booking_id)
    )
    booking = result.scalar_one_or_none()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    return {
        "id": booking.id,
        "listing_id": booking.listing_id,
        "status": booking.status,
        "check_in": booking.check_in.isoformat(),
        "check_out": booking.check_out.isoformat(),
        "guest_name": booking.guest_name,
        "guest_email": booking.guest_email,
        "num_guests": booking.num_guests,
        "agent_name": booking.agent_name,
        "price_breakdown": booking.price_breakdown,
        "total_price": float(booking.total_price) if booking.total_price else None,
        "payment_url": booking.payment_url,
        "decline_reason": booking.decline_reason,
        "created_at": booking.created_at.isoformat()
    }


@router.post("/api/v1/bookings/{booking_id}/approve")
async def approve_booking(booking_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(BookingRequest).where(BookingRequest.id == booking_id)
    )
    booking = result.scalar_one_or_none()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    settings = get_settings()
    booking.status = "approved"
    booking.payment_url = f"{settings.SITE_BASE_URL}/pay/{booking.id}"
    await db.commit()

    return {"id": booking.id, "status": "approved", "payment_url": booking.payment_url}


@router.post("/api/v1/bookings/{booking_id}/decline")
async def decline_booking(booking_id: str, reason: str = "Not available", db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(BookingRequest).where(BookingRequest.id == booking_id)
    )
    booking = result.scalar_one_or_none()
    if not booking:
        raise HTTPException(status_code=404, detail="Booking not found")

    booking.status = "declined"
    booking.decline_reason = reason
    await db.commit()

    return {"id": booking.id, "status": "declined", "decline_reason": reason}
