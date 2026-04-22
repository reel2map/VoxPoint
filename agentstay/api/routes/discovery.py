"""Discovery files: sitemap, robots.txt, ai-plugin.json, agent-card.json."""
from fastapi import APIRouter
from fastapi.responses import PlainTextResponse, Response
from api.config import PROPERTY, BLOG_ARTICLES, get_settings

router = APIRouter()


@router.get("/.well-known/ai-plugin.json")
async def ai_plugin():
    settings = get_settings()
    base = settings.SITE_BASE_URL
    return {
        "schema_version": "v1",
        "name_for_human": "F1 Penthouse Florence — Direct Booking",
        "name_for_model": "f1_penthouse_booking",
        "description_for_human": (
            "Book a unique Ferrari-themed penthouse in central Florence directly. "
            "No platform fees. Up to 7 guests."
        ),
        "description_for_model": (
            "Direct booking API for F1 Penthouse Florence — a Ferrari-themed penthouse "
            "for up to 7 guests in central Florence, walkable to Ponte Vecchio (8 min), "
            "Uffizi (9 min), and SMN station (7 min). 3 bedrooms, 3 bathrooms, 2 terraces, "
            "city views. Rated 4.94/5 from 48 Airbnb reviews. "
            "Endpoints: "
            "GET /api/v1/property (full details), "
            "GET /api/v1/availability?check_in=YYYY-MM-DD&check_out=YYYY-MM-DD&guests=N (pricing), "
            "POST /api/v1/quote (total price breakdown), "
            "POST /api/v1/reservations (create booking hold), "
            "POST /api/v1/payments/checkout-session (Stripe payment link). "
            "Price range €250-400/night by season. Cleaning fee €150. Min 2 nights."
        ),
        "auth": {"type": "none"},
        "api": {"type": "openapi", "url": f"{base}/api/openapi.json"},
        "logo_url": f"{base}/static/logo.png",
        "contact_email": "info@f1penthouse.com",
    }


@router.get("/.well-known/agent-card.json")
async def agent_card():
    settings = get_settings()
    base = settings.SITE_BASE_URL
    return {
        "schema_version": "v1",
        "name": "F1 Penthouse Florence",
        "description": (
            "Ferrari-themed penthouse for up to 7 guests in central Florence. "
            "Direct booking, no platform fees. Rated 4.94/5 from 48 reviews."
        ),
        "url": base,
        "version": "1.0.0",
        "provider": {
            "name": "F1 Penthouse Florence",
            "email": "info@f1penthouse.com",
            "phone": "+39 3311385266",
        },
        "capabilities": {"streaming": False, "push_notifications": False},
        "skills": [
            {
                "id": "check_availability",
                "name": "Check Availability",
                "description": "Check dates and get full price breakdown",
                "tags": ["availability", "pricing", "dates"],
            },
            {
                "id": "get_quote",
                "name": "Get Quote",
                "description": "Get total price with all fees for specific dates",
                "tags": ["quote", "pricing"],
            },
            {
                "id": "create_reservation",
                "name": "Create Reservation",
                "description": "Create a reservation hold for the penthouse",
                "tags": ["booking", "reservation"],
            },
            {
                "id": "get_property",
                "name": "Get Property Details",
                "description": "Full property data including amenities, photos, policies",
                "tags": ["property", "details"],
            },
        ],
        "endpoints": {
            "property": "/api/v1/property",
            "availability": "/api/v1/availability",
            "quote": "/api/v1/quote",
            "reservations": "/api/v1/reservations",
            "openapi": "/api/openapi.json",
            "mcp": "stdio via npm package (see /mcp)",
        },
        "property": {
            "type": "penthouse",
            "city": "Florence",
            "country": "IT",
            "guests_max": 7,
            "bedrooms": 3,
            "bathrooms": 3,
            "rating": 4.94,
            "reviews": 48,
            "price_from": 250,
            "currency": "EUR",
        },
    }


@router.get("/sitemap.xml")
async def sitemap():
    settings = get_settings()
    base = settings.SITE_BASE_URL
    today = "2026-03-22"

    static_urls = [
        ("", "1.0", "daily"),
        ("/penthouse-florence", "0.95", "weekly"),
        ("/availability", "0.8", "daily"),
        ("/reviews", "0.8", "monthly"),
        ("/location", "0.8", "monthly"),
        ("/faq", "0.85", "monthly"),
        ("/booking-policies", "0.7", "monthly"),
        ("/book", "0.9", "weekly"),
        ("/contact", "0.6", "monthly"),
        ("/blog", "0.8", "weekly"),
        ("/api", "0.6", "monthly"),
        ("/mcp", "0.5", "monthly"),
    ]

    urls = []
    for path, priority, freq in static_urls:
        urls.append(f"""  <url>
    <loc>{base}{path}</loc>
    <lastmod>{today}</lastmod>
    <changefreq>{freq}</changefreq>
    <priority>{priority}</priority>
  </url>""")

    for article in BLOG_ARTICLES:
        urls.append(f"""  <url>
    <loc>{base}/blog/{article["slug"]}</loc>
    <lastmod>{article["date"]}</lastmod>
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

User-agent: ChatGPT-User
Allow: /

User-agent: OAI-SearchBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: anthropic-ai
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: Bytespider
Allow: /

User-agent: Google-Extended
Allow: /

Sitemap: {settings.SITE_BASE_URL}/sitemap.xml
"""
