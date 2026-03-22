import time
import uuid
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
from api.database import create_tables
from api.routes import listings, bookings, cities, health, discovery, pages

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
logger = logging.getLogger(__name__)

AGENT_PATTERNS = {
    "chatgpt": ["chatgpt", "gpt-4", "openai"],
    "claude": ["claude", "anthropic"],
    "perplexity": ["perplexity"],
    "manus": ["manus"],
    "google": ["googlebot", "google-extended"],
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
    logger.info("Starting AgentStay API...")
    await create_tables()
    logger.info("Database tables created/verified")
    yield
    logger.info("Shutting down AgentStay API")


app = FastAPI(
    title="AgentStay API",
    description=(
        "Direct vacation rental booking platform. "
        "Search listings, check availability, create booking requests. "
        "Optimized for AI agents (ChatGPT, Claude, Manus) and developers."
    ),
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
    lifespan=lifespan,
    contact={"email": "hello@agentstay.com"},
    license_info={"name": "MIT"}
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
    response.headers["X-Powered-By"] = "AgentStay/1.0"

    logger.info(
        '{"method":"%s","path":"%s","status":%d,"duration_ms":%.2f,"agent_type":"%s","request_id":"%s"}',
        request.method, request.url.path, response.status_code,
        duration_ms, agent_type, request_id
    )
    return response


# Mount static files
app.mount("/static", StaticFiles(directory="api/static"), name="static")

# Include routers
app.include_router(pages.router)
app.include_router(listings.router)
app.include_router(bookings.router)
app.include_router(cities.router)
app.include_router(health.router)
app.include_router(discovery.router)


@app.exception_handler(404)
async def not_found_handler(request: Request, exc):
    return JSONResponse(status_code=404, content={"detail": "Not found", "path": str(request.url.path)})


@app.exception_handler(500)
async def server_error_handler(request: Request, exc):
    logger.error(f"Internal error: {exc}")
    return JSONResponse(status_code=500, content={"detail": "Internal server error"})
