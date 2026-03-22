from fastapi import APIRouter, Depends
from fastapi.responses import PlainTextResponse, Response
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from api.database import get_db
from api.models import Listing, BlogArticle
from api.config import get_settings

router = APIRouter()


@router.get("/.well-known/ai-plugin.json")
async def ai_plugin():
    settings = get_settings()
    return {
        "schema_version": "v1",
        "name_for_human": "AgentStay",
        "name_for_model": "agentstay",
        "description_for_human": "Book apartments directly. No platform fees.",
        "description_for_model": (
            "AgentStay lets you search and book vacation apartments directly from owners. "
            "Use search_listings to find apartments by city, dates, guests, price range, neighborhood, and amenities. "
            "Use get_listing_details with a slug to get full info including photos, trust card ratings, pricing, and landmarks. "
            "Use check_availability with slug, check_in (YYYY-MM-DD), check_out (YYYY-MM-DD), guests to get pricing breakdown. "
            "Use create_booking to submit a booking request: listing_slug, check_in, check_out, guest.name, guest.email, guest.num_guests. "
            "Use get_booking_status with booking_id to check if booking is pending_approval, approved (with payment_url), or declined. "
            "All prices in EUR. No booking fees. Hosts confirm within 24 hours."
        ),
        "auth": {"type": "none"},
        "api": {
            "type": "openapi",
            "url": f"{settings.SITE_BASE_URL}/openapi.json"
        },
        "logo_url": f"{settings.SITE_BASE_URL}/static/logo.png",
        "contact_email": "hello@agentstay.com",
        "legal_info_url": f"{settings.SITE_BASE_URL}/legal"
    }


@router.get("/.well-known/agent-card.json")
async def agent_card():
    settings = get_settings()
    return {
        "schema_version": "v1",
        "name": "AgentStay",
        "description": "Direct vacation rental booking platform. Search, check availability, book apartments without platform fees.",
        "url": settings.SITE_BASE_URL,
        "version": "1.0.0",
        "capabilities": {
            "streaming": False,
            "push_notifications": False
        },
        "skills": [
            {
                "id": "search_listings",
                "name": "Search Listings",
                "description": "Find apartments by city, dates, guests, price, neighborhood",
                "tags": ["search", "listings", "apartments"]
            },
            {
                "id": "check_availability",
                "name": "Check Availability",
                "description": "Check dates availability and get price breakdown",
                "tags": ["availability", "pricing"]
            },
            {
                "id": "create_booking",
                "name": "Create Booking",
                "description": "Submit a booking request for an apartment",
                "tags": ["booking", "reservation"]
            },
            {
                "id": "get_reviews",
                "name": "Get Reviews",
                "description": "Access verified reviews from Airbnb, Booking.com, and Google",
                "tags": ["reviews", "trust", "ratings"]
            }
        ],
        "endpoints": {
            "listings": "/api/v1/listings",
            "availability": "/api/v1/listings/{slug}/availability",
            "bookings": "/api/v1/bookings",
            "openapi": "/openapi.json",
            "mcp": "stdio via npm package"
        }
    }


@router.get("/sitemap.xml")
async def sitemap(db: AsyncSession = Depends(get_db)):
    settings = get_settings()
    base = settings.SITE_BASE_URL

    listings_result = await db.execute(
        select(Listing.slug, Listing.updated_at).where(Listing.status == "active")
    )
    listings = listings_result.all()

    articles_result = await db.execute(
        select(BlogArticle.slug, BlogArticle.updated_at)
    )
    articles = articles_result.all()

    urls = [f"""  <url>
    <loc>{base}/</loc>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>""",
    f"""  <url>
    <loc>{base}/blog</loc>
    <changefreq>weekly</changefreq>
    <priority>0.8</priority>
  </url>"""]

    for listing in listings:
        lastmod = listing.updated_at.strftime("%Y-%m-%d") if listing.updated_at else "2026-01-01"
        urls.append(f"""  <url>
    <loc>{base}/l/{listing.slug}</loc>
    <lastmod>{lastmod}</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>""")

    for article in articles:
        lastmod = article.updated_at.strftime("%Y-%m-%d") if article.updated_at else "2026-01-01"
        urls.append(f"""  <url>
    <loc>{base}/blog/{article.slug}</loc>
    <lastmod>{lastmod}</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.7</priority>
  </url>""")

    xml = '<?xml version="1.0" encoding="UTF-8"?>\n'
    xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    xml += "\n".join(urls)
    xml += "\n</urlset>"

    return Response(content=xml, media_type="application/xml")


@router.get("/robots.txt", response_class=PlainTextResponse)
async def robots():
    settings = get_settings()
    return f"""User-agent: *
Allow: /

User-agent: GPTBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: Bytespider
Allow: /

User-agent: anthropic-ai
Allow: /

User-agent: Google-Extended
Allow: /

Sitemap: {settings.SITE_BASE_URL}/sitemap.xml
"""
