from datetime import date, timedelta
from typing import Any, List, Set
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from api.models import BlockedDate, BookingRequest


async def get_blocked_dates(db: AsyncSession, listing_id: str) -> Set[date]:
    """Get all blocked dates for a listing."""
    result = await db.execute(
        select(BlockedDate).where(BlockedDate.listing_id == listing_id)
    )
    blocked = result.scalars().all()
    return {bd.date for bd in blocked}


async def get_booked_dates(db: AsyncSession, listing_id: str) -> Set[date]:
    """Get all dates covered by approved bookings."""
    result = await db.execute(
        select(BookingRequest).where(
            BookingRequest.listing_id == listing_id,
            BookingRequest.status.in_(["approved", "paid"])
        )
    )
    bookings = result.scalars().all()
    booked = set()
    for booking in bookings:
        current = booking.check_in
        while current < booking.check_out:
            booked.add(current)
            current += timedelta(days=1)
    return booked


async def check_availability(
    db: AsyncSession,
    listing: Any,
    check_in: date,
    check_out: date,
    guests: int
) -> dict:
    """Check if listing is available for given dates."""
    if guests > listing.max_guests:
        return {"available": False, "reason": f"Max guests is {listing.max_guests}"}

    min_nights = (listing.house_rules or {}).get("min_nights", 1)
    nights = (check_out - check_in).days
    if nights < min_nights:
        return {"available": False, "reason": f"Minimum stay is {min_nights} nights"}

    blocked = await get_blocked_dates(db, listing.id)
    booked = await get_booked_dates(db, listing.id)
    unavailable = blocked | booked

    current = check_in
    while current < check_out:
        if current in unavailable:
            return {"available": False, "reason": f"Date {current} is not available"}
        current += timedelta(days=1)

    return {"available": True, "reason": None}
