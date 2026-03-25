"""HTML page routes for La Corsa Suite Firenze."""
import re
from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from api.config import PROPERTY, BLOG_ARTICLES, DEMO_LISTINGS, get_settings

router = APIRouter()
templates = Jinja2Templates(directory="api/templates")


def ctx(request: Request, extra: dict = None) -> dict:
    settings = get_settings()
    base = {
        "request": request,
        "property": PROPERTY,
        "base_url": settings.SITE_BASE_URL,
    }
    if extra:
        base.update(extra)
    return base


def get_article(slug: str) -> dict:
    for a in BLOG_ARTICLES:
        if a["slug"] == slug:
            return a
    return None


def render_listing_card(listing: dict) -> str:
    featured_badge = (
        '<span class="lc-badge">Featured</span>' if listing.get("is_featured") else ""
    )
    return f"""<div class="listing-card">
  {featured_badge}
  <div class="lc-photo">
    <img src="{listing['photo']}" alt="{listing['name']}" loading="lazy">
  </div>
  <div class="lc-body">
    <div class="lc-neighborhood">{listing['neighborhood_label']}</div>
    <h3 class="lc-name">{listing['name']}</h3>
    <p class="lc-tagline">{listing['tagline']}</p>
    <div class="lc-meta">
      <span class="lc-rating">★ {listing['rating']}</span>
      <span class="lc-reviews">({listing['reviews']} reviews)</span>
      <span class="lc-sep">·</span>
      <span class="lc-capacity">{listing['bedrooms']} bed · {listing['guests']} guests</span>
    </div>
    <p class="lc-highlight">{listing['highlight']}</p>
    <div class="lc-footer">
      <div class="lc-price">From <strong>€{listing['price_from']}</strong>/night</div>
      <a href="{listing['book_url']}" class="lc-btn">Check availability</a>
    </div>
  </div>
</div>"""


def inject_listing_cards(html: str) -> str:
    """Replace <!-- LISTINGS:neighborhood=X --> markers with rendered cards."""
    def replace_marker(m: re.Match) -> str:
        neighborhood = m.group(1)
        matches = [l for l in DEMO_LISTINGS if l["neighborhood"] == neighborhood]
        if not matches:
            return ""
        cards = "".join(render_listing_card(l) for l in matches)
        return f'<div class="listing-cards-grid">{cards}</div>'

    return re.sub(r"<!-- LISTINGS:neighborhood=([\w-]+) -->", replace_marker, html)


@router.get("/", response_class=HTMLResponse)
async def homepage(request: Request):
    return templates.TemplateResponse("home.html", ctx(request, {"articles": BLOG_ARTICLES[:3]}))


@router.get("/penthouse-florence", response_class=HTMLResponse)
async def property_page(request: Request):
    return templates.TemplateResponse("property.html", ctx(request))


@router.get("/availability", response_class=HTMLResponse)
async def availability_page(request: Request):
    return templates.TemplateResponse("availability.html", ctx(request))


@router.get("/reviews", response_class=HTMLResponse)
async def reviews_page(request: Request):
    return templates.TemplateResponse("reviews.html", ctx(request))


@router.get("/location", response_class=HTMLResponse)
async def location_page(request: Request):
    return templates.TemplateResponse("location.html", ctx(request))


@router.get("/faq", response_class=HTMLResponse)
async def faq_page(request: Request):
    return templates.TemplateResponse("faq.html", ctx(request))


@router.get("/booking-policies", response_class=HTMLResponse)
async def policies_page(request: Request):
    return templates.TemplateResponse("booking_policies.html", ctx(request))


@router.get("/book", response_class=HTMLResponse)
async def book_page(request: Request):
    return templates.TemplateResponse("book.html", ctx(request))


@router.get("/contact", response_class=HTMLResponse)
async def contact_page(request: Request):
    return templates.TemplateResponse("contact.html", ctx(request))


@router.get("/api", response_class=HTMLResponse)
async def api_landing(request: Request):
    return templates.TemplateResponse("api_landing.html", ctx(request))


@router.get("/mcp", response_class=HTMLResponse)
async def mcp_page(request: Request):
    return templates.TemplateResponse("mcp.html", ctx(request))


@router.get("/blog", response_class=HTMLResponse)
async def blog_index(request: Request):
    return templates.TemplateResponse("blog/index.html", ctx(request, {"articles": BLOG_ARTICLES}))


@router.get("/blog/{slug}", response_class=HTMLResponse)
async def blog_article(slug: str, request: Request):
    article = get_article(slug)
    if not article:
        raise HTTPException(status_code=404, detail="Article not found")
    from api.blog_content import BLOG_CONTENT
    content_html = BLOG_CONTENT.get(article["content_key"], "<p>Content coming soon.</p>")
    content_html = inject_listing_cards(content_html)
    # Build FAQPage schema if article has FAQs embedded
    faq_schema = ""
    return templates.TemplateResponse("blog/article.html", ctx(request, {
        "article": article,
        "content_html": content_html,
        "faq_schema": faq_schema,
        "related_articles": [a for a in BLOG_ARTICLES if a["slug"] != article["slug"]][:3],
    }))
