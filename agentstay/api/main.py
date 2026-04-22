import time
import uuid
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
from api.database import create_tables
from api.routes import pages, api_v1, discovery, health

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)

AGENT_PATTERNS = {
    "chatgpt": ["chatgpt-user", "oai-searchbot", "gptbot"],
    "claude": ["claudebot", "anthropic-ai"],
    "perplexity": ["perplexitybot"],
    "google": ["googlebot", "google-extended"],
    "bytespider": ["bytespider"],
    "crawler": ["bot", "crawler", "spider", "scraper"],
}


def detect_agent(user_agent: str) -> str:
    ua = (user_agent or "").lower()
    for agent_type, patterns in AGENT_PATTERNS.items():
        if any(p in ua for p in patterns):
            return agent_type
    return "human"


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Starting F1 Penthouse Florence API...")
    await create_tables()
    logger.info("Database tables ready")
    yield
    logger.info("Shutting down")


app = FastAPI(
    title="F1 Penthouse Florence — Direct Booking API",
    description=(
        "Direct booking API for F1 Penthouse Florence — a Ferrari-themed penthouse "
        "for up to 7 guests in central Florence. Walk to Ponte Vecchio (8 min), "
        "Uffizi (9 min), SMN station (7 min). 3 bedrooms, 3 bathrooms, 2 terraces. "
        "Rated 4.94/5 from 48 reviews. "
        "GET /api/v1/property for full details, "
        "GET /api/v1/availability for pricing, "
        "POST /api/v1/quote for total price, "
        "POST /api/v1/reservations to book."
    ),
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/api/openapi.json",
    lifespan=lifespan,
    contact={"email": "info@f1penthouse.com"},
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.middleware("http")
async def logging_middleware(request: Request, call_next):
    request_id = str(uuid.uuid4())[:8]
    start = time.time()
    user_agent = request.headers.get("user-agent", "")
    agent_type = detect_agent(user_agent)

    response = await call_next(request)

    duration_ms = round((time.time() - start) * 1000, 2)
    response.headers["X-Request-ID"] = request_id
    response.headers["X-Powered-By"] = "F1Penthouse/1.0"

    logger.info(
        '{"method":"%s","path":"%s","status":%d,"duration_ms":%.2f,"agent_type":"%s","request_id":"%s"}',
        request.method, request.url.path, response.status_code,
        duration_ms, agent_type, request_id,
    )
    return response


app.mount("/static", StaticFiles(directory="api/static"), name="static")

app.include_router(pages.router)
app.include_router(api_v1.router)
app.include_router(discovery.router)
app.include_router(health.router)


@app.exception_handler(404)
async def not_found_handler(request: Request, exc):
    return JSONResponse(
        status_code=404,
        content={"detail": "Not found", "path": str(request.url.path)},
    )


@app.exception_handler(500)
async def server_error_handler(request: Request, exc):
    logger.error("Internal error: %s", exc)
    return JSONResponse(status_code=500, content={"detail": "Internal server error"})
