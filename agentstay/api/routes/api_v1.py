"""F1 Penthouse Florence — REST API v1 endpoints."""
from datetime import datetime, timedelta
from decimal import Decimal
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, and_
from api.database import get_db
from api.models import Reservation, BlockedDate
from api.schemas import ReservationCreate, QuoteRequest, CheckoutSessionCreate
from api.config import PROPERTY, MONTH_SEASON
import uuid

router = APIRouter(prefix="/api/v1", tags=["API v1"])


# ── Pricing helpers ────────────────────────────────────────────────────────────

def nightly_rate(d) -> int:
    """Return nightly rate for a given date."""
    return MONTH_SEASON[d.month]["per_night"]


def calculate_price(check_in, check_out, guests: int = 2) -> dict:
    """Calculate full price breakdown for a stay."""
    from datetime import date as date_type
    nights = (check_out - check_in).days
    if nights <= 0:
        raise ValueError("check_out must be after check_in")

    # Build nightly breakdown
    nightly_total = 0
    current = check_in
    from datetime import timedelta
    while current < check_out:
        nightly_total += nightly_rate(current)
        current += timedelta(days=1)

    base = nightly_total
    cleaning = PROPERTY["pricing"]["cleaning_fee"]
    discount_pct = 0
    discount_label = None
    for d in sorted(PROPERTY["pricing"]["discounts"], key=lambda x: -x["min_nights"]):
        if nights >= d["min_nights"]:
            discount_pct = d["percent"]
            discount_label = d["label"]
            break

    discount_amount = round(base * discount_pct / 100)
    subtotal = base - discount_amount + cleaning
    # Italian tourist tax ~€3.50/person/night (indicative)
    city_tax = round(3.5 * guests * min(nights, 7))

    return {
        "nights": nights,
        "nightly_avg": round(base / nights) if nights > 0 else 0,
        "accommodation": base,
        "discount_label": discount_label,
        "discount_percent": discount_pct,
        "discount_amount": -discount_amount if discount_amount else 0,
        "cleaning_fee": cleaning,
        "city_tax": city_tax,
        "city_tax_note": "Approx. €3.50/person/night, max 7 nights (payable on arrival)",
        "total": subtotal + city_tax,
        "currency": "EUR",
    }


# ── Availability helper ────────────────────────────────────────────────────────

async def get_blocked_dates(db: AsyncSession, check_in, check_out) -> list:
    from datetime import timedelta
    result = await db.execute(
        select(BlockedDate.date).where(
            BlockedDate.date >= check_in,
            BlockedDate.date < check_out,
        )
    )
    return [r[0] for r in result.all()]


# ── Endpoints ─────────────────────────────────────────────────────────────────

@router.get("/property", summary="Full property data")
async def get_property():
    """Return complete property details for F1 Penthouse Florence."""
    return PROPERTY


@router.get("/availability", summary="Check availability and pricing")
async def check_availability(
    check_in: str = Query(..., description="Check-in date YYYY-MM-DD"),
    check_out: str = Query(..., description="Check-out date YYYY-MM-DD"),
    guests: int = Query(2, ge=1, le=7),
    db: AsyncSession = Depends(get_db),
):
    from datetime import date
    try:
        ci = date.fromisoformat(check_in)
        co = date.fromisoformat(check_out)
    except ValueError:
        raise HTTPException(status_code=422, detail="Dates must be YYYY-MM-DD")

    nights = (co - ci).days
    if nights < PROPERTY["policies"]["min_nights"]:
        return {
            "check_in": check_in,
            "check_out": check_out,
            "guests": guests,
            "available": False,
            "reason": f"Minimum stay is {PROPERTY['policies']['min_nights']} nights",
            "nights": nights,
        }
    if guests > PROPERTY["policies"]["max_guests"]:
        return {
            "check_in": check_in,
            "check_out": check_out,
            "guests": guests,
            "available": False,
            "reason": f"Maximum {PROPERTY['policies']['max_guests']} guests",
            "nights": nights,
        }

    blocked = await get_blocked_dates(db, ci, co)
    if blocked:
        return {
            "check_in": check_in,
            "check_out": check_out,
            "guests": guests,
            "available": False,
            "reason": "Some dates in the requested period are not available",
            "nights": nights,
        }

    breakdown = calculate_price(ci, co, guests)
    return {
        "check_in": check_in,
        "check_out": check_out,
        "guests": guests,
        "available": True,
        "nights": nights,
        "price_breakdown": breakdown,
        "total": breakdown["total"],
        "currency": "EUR",
    }


@router.post("/quote", summary="Get price quote", status_code=200)
async def get_quote(payload: QuoteRequest, db: AsyncSession = Depends(get_db)):
    """Return full price breakdown for the requested dates."""
    nights = (payload.check_out - payload.check_in).days
    if nights < PROPERTY["policies"]["min_nights"]:
        raise HTTPException(
            status_code=422,
            detail=f"Minimum {PROPERTY['policies']['min_nights']} nights required",
        )
    blocked = await get_blocked_dates(db, payload.check_in, payload.check_out)
    if blocked:
        raise HTTPException(status_code=409, detail="Dates not available")

    breakdown = calculate_price(payload.check_in, payload.check_out, payload.guests)
    return {
        "quote_id": str(uuid.uuid4()),
        "property": "f1-penthouse-florence",
        "check_in": payload.check_in.isoformat(),
        "check_out": payload.check_out.isoformat(),
        "guests": payload.guests,
        "price_breakdown": breakdown,
        "valid_minutes": 30,
        "note": "Submit this quote_id with POST /api/v1/reservations to hold the dates.",
    }


@router.post("/reservations", summary="Create reservation hold", status_code=201)
async def create_reservation(payload: ReservationCreate, db: AsyncSession = Depends(get_db)):
    """Create a reservation hold. Dates are blocked; payment link returned."""
    nights = (payload.check_out - payload.check_in).days
    if nights < PROPERTY["policies"]["min_nights"]:
        raise HTTPException(
            status_code=422,
            detail=f"Minimum {PROPERTY['policies']['min_nights']} nights required",
        )

    blocked = await get_blocked_dates(db, payload.check_in, payload.check_out)
    if blocked:
        raise HTTPException(status_code=409, detail="Dates not available — please choose different dates")

    breakdown = calculate_price(payload.check_in, payload.check_out, payload.guests)

    reservation = Reservation(
        check_in=payload.check_in,
        check_out=payload.check_out,
        num_guests=payload.guests,
        guest_first_name=payload.guest.first_name,
        guest_last_name=payload.guest.last_name,
        guest_email=payload.guest.email,
        guest_phone=payload.guest.phone,
        special_requests=payload.special_requests,
        agent_name=payload.agent_name,
        price_breakdown=breakdown,
        total_price=breakdown["total"],
        status="pending",
        expires_at=datetime.utcnow() + timedelta(hours=24),
    )
    db.add(reservation)

    # Block dates
    from datetime import timedelta
    current = payload.check_in
    while current < payload.check_out:
        existing = await db.execute(select(BlockedDate).where(BlockedDate.date == current))
        if not existing.scalar_one_or_none():
            db.add(BlockedDate(date=current, reason="reserved"))
        current += timedelta(days=1)

    await db.commit()
    await db.refresh(reservation)

    return {
        "id": reservation.id,
        "status": reservation.status,
        "check_in": reservation.check_in.isoformat(),
        "check_out": reservation.check_out.isoformat(),
        "guests": reservation.num_guests,
        "guest_name": f"{reservation.guest_first_name} {reservation.guest_last_name}",
        "guest_email": reservation.guest_email,
        "price_breakdown": reservation.price_breakdown,
        "total": float(reservation.total_price),
        "currency": "EUR",
        "payment_status": reservation.payment_status,
        "expires_at": reservation.expires_at.isoformat(),
        "message": (
            "Reservation hold created. Contact info@f1penthouse.com "
            "or call +39 3311385266 to confirm and pay."
        ),
    }


@router.get("/reservations/{reservation_id}", summary="Get reservation status")
async def get_reservation(reservation_id: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Reservation).where(Reservation.id == reservation_id)
    )
    r = result.scalar_one_or_none()
    if not r:
        raise HTTPException(status_code=404, detail="Reservation not found")
    return {
        "id": r.id,
        "status": r.status,
        "check_in": r.check_in.isoformat(),
        "check_out": r.check_out.isoformat(),
        "guests": r.num_guests,
        "guest_email": r.guest_email,
        "price_breakdown": r.price_breakdown,
        "total": float(r.total_price) if r.total_price else None,
        "payment_status": r.payment_status,
        "payment_url": r.payment_url,
        "created_at": r.created_at.isoformat(),
    }


@router.post("/payments/checkout-session", summary="Create Stripe checkout session")
async def create_checkout_session(
    payload: CheckoutSessionCreate,
    db: AsyncSession = Depends(get_db),
):
    """Create a Stripe checkout session for the reservation."""
    result = await db.execute(
        select(Reservation).where(Reservation.id == payload.reservation_id)
    )
    r = result.scalar_one_or_none()
    if not r:
        raise HTTPException(status_code=404, detail="Reservation not found")
    if r.payment_status == "paid":
        raise HTTPException(status_code=409, detail="Already paid")

    # In production: create real Stripe session here
    # For now return a placeholder
    mock_url = f"https://checkout.stripe.com/pay/placeholder_{r.id}"
    r.payment_url = mock_url
    await db.commit()

    return {
        "reservation_id": r.id,
        "checkout_url": mock_url,
        "total": float(r.total_price) if r.total_price else None,
        "currency": "EUR",
        "note": "Stripe integration requires STRIPE_SECRET_KEY environment variable",
    }


@router.post("/webhooks/stripe", include_in_schema=False)
async def stripe_webhook(request, db: AsyncSession = Depends(get_db)):
    """Stripe payment confirmation webhook."""
    return {"received": True}
