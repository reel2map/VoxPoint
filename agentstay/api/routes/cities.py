from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from api.database import get_db
from api.models import Listing

router = APIRouter()


@router.get("/api/v1/cities")
async def list_cities(db: AsyncSession = Depends(get_db)):
    result = await db.execute(
        select(
            Listing.city,
            Listing.country,
            func.count(Listing.id).label("listing_count"),
            func.avg(Listing.base_price).label("avg_price")
        )
        .where(Listing.status == "active")
        .group_by(Listing.city, Listing.country)
        .order_by(func.count(Listing.id).desc())
    )
    rows = result.all()
    return [
        {
            "city": row.city,
            "country": row.country,
            "listing_count": row.listing_count,
            "avg_price": round(float(row.avg_price), 2) if row.avg_price else None
        }
        for row in rows
    ]
