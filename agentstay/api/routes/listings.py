from typing import Optional, List
from datetime import date
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, and_, or_
from sqlalchemy.orm import selectinload
from api.database import get_db
from api.models import Listing, Photo
from api.services.pricing import calculate_price_breakdown
from api.services.availability import check_availability

router = APIRouter()


def listing_to_card(listing, cover_photo=None):
    photos = listing.photos if hasattr(listing, "photos") and listing.photos else []
    if cover_photo is None:
        for p in photos:
            if p.is_cover:
                cover_photo = p
                break
        if cover_photo is None and photos:
            cover_photo = photos[0]

    return {
        "id": listing.id,
        "slug": listing.slug,
        "name": listing.name,
        "description_short": listing.description_short,
        "city": listing.city,
        "neighborhood": listing.neighborhood,
        "country": listing.country,
        "bedrooms": listing.bedrooms,
        "bathrooms": listing.bathrooms,
        "max_guests": listing.max_guests,
        "size_sqm": listing.size_sqm,
        "base_price": float(listing.base_price),
        "cleaning_fee": float(listing.cleaning_fee or 0),
        "currency": listing.currency,
        "trust_card": listing.trust_card,
        "cover_photo": {
            "id": cover_photo.id,
            "url": cover_photo.url,
            "caption": cover_photo.caption,
            "sort_order": cover_photo.sort_order,
            "is_cover": cover_photo.is_cover
        } if cover_photo else None
    }


@router.get("/api/v1/listings")
async def search_listings(
    city: Optional[str] = None,
    check_in: Optional[date] = None,
    check_out: Optional[date] = None,
    guests: Optional[int] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    bedrooms_min: Optional[int] = None,
    neighborhood: Optional[str] = None,
    amenities: Optional[str] = Query(None, description="Comma-separated amenities"),
    sort: Optional[str] = Query("rating", description="rating|price_asc|price_desc"),
    limit: int = Query(20, le=100),
    offset: int = 0,
    db: AsyncSession = Depends(get_db)
):
    query = select(Listing).options(
        selectinload(Listing.photos)
    ).where(Listing.status == "active")

    if city:
        query = query.where(func.lower(Listing.city) == city.lower())
    if guests:
        query = query.where(Listing.max_guests >= guests)
    if min_price:
        query = query.where(Listing.base_price >= min_price)
    if max_price:
        query = query.where(Listing.base_price <= max_price)
    if bedrooms_min:
        query = query.where(Listing.bedrooms >= bedrooms_min)
    if neighborhood:
        query = query.where(func.lower(Listing.neighborhood).contains(neighborhood.lower()))

    if sort == "price_asc":
        query = query.order_by(Listing.base_price.asc())
    elif sort == "price_desc":
        query = query.order_by(Listing.base_price.desc())
    else:
        query = query.order_by(Listing.created_at.asc())

    count_query = select(func.count()).select_from(query.subquery())
    total_result = await db.execute(count_query)
    total = total_result.scalar()

    query = query.limit(limit).offset(offset)
    result = await db.execute(query)
    listings = result.scalars().all()

    # Filter by amenities post-query
    if amenities:
        amenity_list = [a.strip().lower() for a in amenities.split(",")]
        listings = [
            l for l in listings
            if all(a in [x.lower() for x in (l.amenities or [])] for a in amenity_list)
        ]

    return {
        "total": total,
        "listings": [listing_to_card(l) for l in listings]
    }


@router.get("/api/v1/listings/{slug}")
async def get_listing(slug: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(Listing)
        .options(selectinload(Listing.photos), selectinload(Listing.host))
        .where(Listing.slug == slug, Listing.status == "active")
    )
    listing = result.scalar_one_or_none()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    photos = [
        {"id": p.id, "url": p.url, "caption": p.caption,
         "sort_order": p.sort_order, "is_cover": p.is_cover}
        for p in listing.photos
    ]
    host = None
    if listing.host:
        host = {"id": listing.host.id, "name": listing.host.name, "languages": listing.host.languages}

    return {
        "id": listing.id,
        "slug": listing.slug,
        "name": listing.name,
        "description": listing.description,
        "description_short": listing.description_short,
        "property_type": listing.property_type,
        "city": listing.city,
        "neighborhood": listing.neighborhood,
        "address": listing.address,
        "country": listing.country,
        "lat": float(listing.lat) if listing.lat else None,
        "lng": float(listing.lng) if listing.lng else None,
        "bedrooms": listing.bedrooms,
        "bathrooms": listing.bathrooms,
        "max_guests": listing.max_guests,
        "size_sqm": listing.size_sqm,
        "amenities": listing.amenities or [],
        "house_rules": listing.house_rules,
        "cancellation_policy": listing.cancellation_policy,
        "base_price": float(listing.base_price),
        "cleaning_fee": float(listing.cleaning_fee or 0),
        "currency": listing.currency,
        "seasonal_pricing": listing.seasonal_pricing or [],
        "discounts": listing.discounts or [],
        "additional_services": listing.additional_services or [],
        "trust_card": listing.trust_card,
        "nearby_landmarks": listing.nearby_landmarks or [],
        "photos": photos,
        "host": host
    }


@router.get("/api/v1/listings/{slug}/availability")
async def get_availability(
    slug: str,
    check_in: date,
    check_out: date,
    guests: int = 2,
    db: AsyncSession = Depends(get_db)
):
    result = await db.execute(
        select(Listing).where(Listing.slug == slug, Listing.status == "active")
    )
    listing = result.scalar_one_or_none()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    avail = await check_availability(db, listing, check_in, check_out, guests)
    nights = (check_out - check_in).days
    breakdown = calculate_price_breakdown(listing, check_in, check_out) if avail["available"] else None

    return {
        "slug": slug,
        "check_in": check_in.isoformat(),
        "check_out": check_out.isoformat(),
        "guests": guests,
        "available": avail["available"],
        "reason": avail.get("reason"),
        "nights": nights,
        "price_breakdown": breakdown,
        "total_price": breakdown["total"] if breakdown else None
    }
