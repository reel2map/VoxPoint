import re
from typing import Optional
from datetime import date
from fastapi import APIRouter, Depends, HTTPException, Request, Query
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload
from api.database import get_db
from api.models import Listing, BlogArticle, Photo
from api.config import get_settings

router = APIRouter()
templates = Jinja2Templates(directory="api/templates")

# Add urlencode filter
import urllib.parse
templates.env.filters["urlencode"] = urllib.parse.quote


def get_cover_photo(listing):
    for p in (listing.photos or []):
        if p.is_cover:
            return p
    if listing.photos:
        return listing.photos[0]
    return None


def listing_to_dict(listing):
    cover = get_cover_photo(listing)
    return {
        "id": listing.id,
        "slug": listing.slug,
        "name": listing.name,
        "description_short": listing.description_short,
        "description": listing.description,
        "city": listing.city,
        "country": listing.country,
        "neighborhood": listing.neighborhood,
        "bedrooms": listing.bedrooms,
        "bathrooms": listing.bathrooms,
        "max_guests": listing.max_guests,
        "size_sqm": listing.size_sqm,
        "base_price": listing.base_price,
        "cleaning_fee": listing.cleaning_fee or 0,
        "currency": listing.currency,
        "trust_card": listing.trust_card,
        "nearby_landmarks": listing.nearby_landmarks or [],
        "amenities": listing.amenities or [],
        "house_rules": listing.house_rules or {},
        "cancellation_policy": listing.cancellation_policy or {},
        "seasonal_pricing": listing.seasonal_pricing or [],
        "discounts": listing.discounts or [],
        "additional_services": listing.additional_services or [],
        "lat": listing.lat,
        "lng": listing.lng,
        "address": listing.address,
        "photos": [
            {"id": p.id, "url": p.url, "caption": p.caption,
             "sort_order": p.sort_order, "is_cover": p.is_cover}
            for p in (listing.photos or [])
        ],
        "host": {
            "id": listing.host.id,
            "name": listing.host.name,
            "languages": listing.host.languages
        } if listing.host else None,
        "cover_photo": {
            "id": cover.id, "url": cover.url, "caption": cover.caption,
            "sort_order": cover.sort_order, "is_cover": cover.is_cover
        } if cover else None
    }


async def render_article_content(content: str, db: AsyncSession) -> str:
    """Replace LISTINGS markers with actual listing cards HTML."""
    pattern = re.compile(r'<!--\s*LISTINGS:neighborhood=([^\s>]+)\s*-->')

    async def replace_marker(match):
        neighborhood = match.group(1).replace('-', ' ')
        result = await db.execute(
            select(Listing)
            .options(selectinload(Listing.photos))
            .where(
                Listing.status == "active",
                func.lower(Listing.neighborhood).contains(neighborhood.lower())
            )
            .limit(3)
        )
        listings = result.scalars().all()
        if not listings:
            return ""

        cards_html = '<div class="listing-grid" style="margin:24px 0;">'
        for listing in listings:
            cover = get_cover_photo(listing)
            cover_url = cover.url if cover else f"https://placehold.co/640x480/E8DDD0/7A7267?text={listing.name}"
            cover_alt = (cover.caption if cover else None) or listing.name
            rating_html = f'<div class="card-rating">★ {listing.trust_card["overall"]} ({listing.trust_card["total_reviews"]} reviews)</div>' if listing.trust_card else ""
            cards_html += f'''
<div class="listing-card">
  <div class="card-img">
    <a href="/l/{listing.slug}">
      <img src="{cover_url}" alt="{cover_alt}" loading="lazy">
    </a>
    <span class="card-tag">{listing.neighborhood or listing.city}</span>
  </div>
  <div class="card-body">
    {rating_html}
    <h3 class="card-title"><a href="/l/{listing.slug}">{listing.name}</a></h3>
    <p class="card-details">{listing.bedrooms} bed · {listing.max_guests} guests · {listing.size_sqm or ''}m²</p>
    <div class="card-price">From €{int(listing.base_price)}<span>/night</span></div>
    <a href="/l/{listing.slug}" class="card-cta">Check availability →</a>
  </div>
</div>'''
        cards_html += '</div>'
        return cards_html

    # Process all markers
    parts = pattern.split(content)
    result_parts = []
    marker_iter = pattern.finditer(content)

    last_end = 0
    result = content
    for match in pattern.finditer(content):
        replacement = await replace_marker(match)
        result = result.replace(match.group(0), replacement, 1)

    return result


async def get_cities_data(db: AsyncSession):
    result = await db.execute(
        select(Listing.city, Listing.country, func.count(Listing.id).label("listing_count"))
        .where(Listing.status == "active")
        .group_by(Listing.city, Listing.country)
    )
    return [{"city": r.city, "country": r.country, "listing_count": r.listing_count} for r in result.all()]


@router.get("/", response_class=HTMLResponse)
async def homepage(
    request: Request,
    city: Optional[str] = None,
    check_in: Optional[date] = None,
    check_out: Optional[date] = None,
    guests: int = 2,
    db: AsyncSession = Depends(get_db)
):
    settings = get_settings()
    query = select(Listing).options(
        selectinload(Listing.photos)
    ).where(Listing.status == "active")

    if city:
        query = query.where(func.lower(Listing.city) == city.lower())
    if guests:
        query = query.where(Listing.max_guests >= guests)

    result = await db.execute(query.limit(20))
    listings = result.scalars().all()
    cities = await get_cities_data(db)

    return templates.TemplateResponse("catalog.html", {
        "request": request,
        "listings": [listing_to_dict(l) for l in listings],
        "cities": cities,
        "selected_city": city or "",
        "selected_check_in": check_in.isoformat() if check_in else "",
        "selected_check_out": check_out.isoformat() if check_out else "",
        "selected_guests": guests,
        "base_url": settings.SITE_BASE_URL
    })


@router.get("/l/{slug}", response_class=HTMLResponse)
async def listing_page(slug: str, request: Request, db: AsyncSession = Depends(get_db)):
    settings = get_settings()
    result = await db.execute(
        select(Listing)
        .options(selectinload(Listing.photos), selectinload(Listing.host))
        .where(Listing.slug == slug, Listing.status == "active")
    )
    listing = result.scalar_one_or_none()
    if not listing:
        raise HTTPException(status_code=404, detail="Listing not found")

    return templates.TemplateResponse("listing.html", {
        "request": request,
        "listing": listing_to_dict(listing),
        "base_url": settings.SITE_BASE_URL
    })


@router.get("/blog", response_class=HTMLResponse)
async def blog_index(request: Request, db: AsyncSession = Depends(get_db)):
    settings = get_settings()
    result = await db.execute(
        select(BlogArticle).order_by(BlogArticle.published_at.desc())
    )
    articles = result.scalars().all()

    return templates.TemplateResponse("blog/index.html", {
        "request": request,
        "articles": articles,
        "base_url": settings.SITE_BASE_URL
    })


@router.get("/blog/{slug}", response_class=HTMLResponse)
async def blog_article(slug: str, request: Request, db: AsyncSession = Depends(get_db)):
    settings = get_settings()
    result = await db.execute(
        select(BlogArticle).where(BlogArticle.slug == slug)
    )
    article = result.scalar_one_or_none()
    if not article:
        raise HTTPException(status_code=404, detail="Article not found")

    rendered_content = await render_article_content(article.content, db)

    # Get related listings
    related_listings = []
    if article.related_listing_slugs:
        for lslug in article.related_listing_slugs[:3]:
            r = await db.execute(
                select(Listing)
                .options(selectinload(Listing.photos))
                .where(Listing.slug == lslug, Listing.status == "active")
            )
            listing = r.scalar_one_or_none()
            if listing:
                related_listings.append(listing_to_dict(listing))

    return templates.TemplateResponse("blog/article.html", {
        "request": request,
        "article": article,
        "rendered_content": rendered_content,
        "related_listings": related_listings,
        "base_url": settings.SITE_BASE_URL
    })
