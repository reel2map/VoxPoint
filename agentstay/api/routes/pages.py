"""HTML page routes for F1 Penthouse Florence."""
from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from api.config import PROPERTY, BLOG_ARTICLES, get_settings

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
    return templates.TemplateResponse("blog/article.html", ctx(request, {
        "article": article,
        "content_html": content_html,
    }))
