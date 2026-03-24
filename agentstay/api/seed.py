#!/usr/bin/env python3
"""Seed script (legacy)."""
import asyncio
import sys
import os

# Add the parent dir to path so imports work (works both locally and in docker)
script_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(script_dir)
if parent_dir not in sys.path:
    sys.path.insert(0, parent_dir)

from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy import select, text

DATABASE_URL = os.environ.get(
    "DATABASE_URL",
    "postgresql+asyncpg://agentstay:agentstay@localhost:5432/agentstay"
)

engine = create_async_engine(DATABASE_URL, echo=False)
AsyncSessionLocal = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def seed():
    from api.database import Base
    from api.models import Host, Listing, Photo, BlogArticle
    from api.blog_content import ARTICLES

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with AsyncSessionLocal() as db:
        # Check if already seeded
        existing = await db.execute(select(Host).where(Host.email == "marco@agentstay.com"))
        if existing.scalar_one_or_none():
            print("✓ Database already seeded. Use --force to reseed.")
            if "--force" not in sys.argv:
                return

            # Clear existing data
            await db.execute(text("DELETE FROM blog_articles"))
            await db.execute(text("DELETE FROM booking_requests"))
            await db.execute(text("DELETE FROM blocked_dates"))
            await db.execute(text("DELETE FROM photos"))
            await db.execute(text("DELETE FROM listings"))
            await db.execute(text("DELETE FROM hosts"))
            await db.commit()

        # Create host
        host = Host(
            email="marco@agentstay.com",
            name="Marco",
            phone="+39 055 123456",
            languages=["it", "en", "ru"],
            telegram_chat_id=None
        )
        db.add(host)
        await db.flush()

        # ── LISTING 1: Elegant Apartment near Duomo ──
        listing1 = Listing(
            host_id=host.id,
            slug="elegant-apartment-near-duomo",
            status="active",
            name="Elegant Apartment near Duomo — Frescoed Ceilings & Terrace",
            description="""Step into this stunning 85m² apartment in the heart of Florence's historic center, just 200 meters from the magnificent Duomo. The apartment features original 18th-century frescoed ceilings, Venetian plasterwork, and period furniture carefully selected by the owner.

The spacious living room opens onto a private terrace with breathtaking views of the cathedral's iconic dome — a rare privilege in this part of the city. Wake up to the bells of the Duomo and enjoy your morning coffee with one of Florence's most iconic views.

The apartment has been fully renovated with modern comforts: high-speed WiFi, air conditioning, a fully equipped kitchen with espresso machine, and a large washer-dryer. Two separate bedrooms accommodate up to 4 guests comfortably.

Location is unbeatable: the Uffizi Gallery is a 7-minute walk, Ponte Vecchio 10 minutes, and dozens of the city's best restaurants and wine bars are within a short stroll. Self check-in via smart lock means you can arrive at any time.""",
            description_short="Historic apartment with frescoed ceilings, private Duomo-view terrace, 200m from the cathedral. 2 bedrooms, 85m², for 4 guests.",
            property_type="apartment",
            neighborhood="Centro Storico",
            address="Via dei Calzaiuoli, Firenze",
            city="Florence",
            country="IT",
            lat=43.7731,
            lng=11.2560,
            bedrooms=2,
            bathrooms=1,
            max_guests=4,
            size_sqm=85,
            amenities=[
                "wifi", "ac", "heating", "kitchen", "washer", "dryer", "tv",
                "netflix", "coffee_machine", "dishwasher", "terrace", "city_view",
                "elevator", "self_check_in", "iron", "hair_dryer", "workspace"
            ],
            house_rules={
                "check_in": "15:00",
                "check_out": "11:00",
                "min_nights": 2,
                "smoking": False,
                "pets": False,
                "parties": False
            },
            cancellation_policy={
                "type": "flexible",
                "rules": [
                    {"days_before": 14, "refund_percent": 100},
                    {"days_before": 7, "refund_percent": 50},
                    {"days_before": 0, "refund_percent": 0}
                ]
            },
            base_price=150,
            cleaning_fee=80,
            currency="EUR",
            seasonal_pricing=[
                {"label": "Winter", "start": "2026-01-01", "end": "2026-03-31", "price": 120},
                {"label": "Spring", "start": "2026-04-01", "end": "2026-06-30", "price": 180},
                {"label": "Summer", "start": "2026-07-01", "end": "2026-08-31", "price": 200},
                {"label": "Autumn", "start": "2026-09-01", "end": "2026-10-31", "price": 180},
                {"label": "Low Season", "start": "2026-11-01", "end": "2026-12-31", "price": 130},
            ],
            discounts=[
                {"min_nights": 7, "percent": 10},
                {"min_nights": 28, "percent": 20}
            ],
            additional_services=[
                {"name": "airport_transfer", "price": 50, "currency": "EUR"},
                {"name": "early_checkin", "price": 30, "currency": "EUR"},
                {"name": "late_checkout", "price": 30, "currency": "EUR"},
                {"name": "grocery_delivery", "price": 45, "currency": "EUR"}
            ],
            trust_card={
                "overall": 4.9,
                "total_reviews": 127,
                "summary": "Guests consistently praise the stunning frescoed ceilings and unbeatable location just steps from the Duomo. The terrace view is described as breathtaking. Cleanliness rated exceptionally high across all platforms.",
                "airbnb": {
                    "rating": 4.9,
                    "count": 89,
                    "url": "https://www.airbnb.com/rooms/12345"
                },
                "booking": {
                    "rating": 9.4,
                    "count": 28,
                    "url": "https://www.booking.com/hotel/it/elegant-apartment-duomo.html"
                },
                "google": {
                    "rating": 4.8,
                    "count": 10,
                    "url": "https://maps.google.com/?cid=12345"
                },
                "top_reviews": [
                    {
                        "author": "Sarah M.",
                        "source": "Airbnb",
                        "rating": 5,
                        "text": "Absolutely stunning apartment! The frescoed ceilings took our breath away. Location is unbeatable — we walked to the Duomo in 2 minutes. Marco was incredibly helpful.",
                        "date": "2026-01"
                    },
                    {
                        "author": "Thomas K.",
                        "source": "Booking.com",
                        "rating": 5,
                        "text": "The terrace view of the Duomo at sunrise is something you cannot put a price on. Marco was incredibly responsive and helpful throughout our stay.",
                        "date": "2025-11"
                    },
                    {
                        "author": "Yuki T.",
                        "source": "Google",
                        "rating": 5,
                        "text": "Best apartment we stayed in during our 2-week Italy trip. Spotlessly clean, fully equipped kitchen, and the location is perfect for seeing all of Florence.",
                        "date": "2025-09"
                    }
                ]
            },
            nearby_landmarks=[
                {"name": "Duomo (Santa Maria del Fiore)", "distance_meters": 200},
                {"name": "Piazza della Signoria", "distance_meters": 300},
                {"name": "Uffizi Gallery", "distance_meters": 400},
                {"name": "Ponte Vecchio", "distance_meters": 600},
                {"name": "Mercato Nuovo", "distance_meters": 350}
            ]
        )
        db.add(listing1)
        await db.flush()

        # Photos for listing 1
        for i in range(1, 6):
            captions = [
                "Frescoed ceiling and elegant living room",
                "Private terrace with Duomo view",
                "Master bedroom with period furniture",
                "Fully equipped modern kitchen",
                "Second bedroom"
            ]
            colors = ["D4C5B0/6B5B45", "C8D8E8/4A6080", "E8D5C0/8B6545", "D0E8D0/4A7A4A", "E0D0E8/6A4A7A"]
            photo = Photo(
                listing_id=listing1.id,
                url=f"https://placehold.co/800x600/{colors[i-1]}?text=Apartment+Photo+{i}",
                caption=captions[i-1],
                sort_order=i - 1,
                is_cover=(i == 1)
            )
            db.add(photo)

        # ── LISTING 2: Cozy Studio in Oltrarno ──
        listing2 = Listing(
            host_id=host.id,
            slug="cozy-studio-oltrarno",
            status="active",
            name="Cozy Studio in Oltrarno — Artisan Quarter, near Palazzo Pitti",
            description="""A charming 35m² studio in Florence's most authentic neighborhood. Oltrarno is where the real Florence lives — artisan leather workshops, wine bars, neighborhood restaurants untouched by tourism.

The studio is a 3-minute walk from Palazzo Pitti and its magnificent Boboli Gardens. Cross Ponte Vecchio to reach the Uffizi in 10 minutes. The space is compact but thoughtfully designed: a comfortable queen bed, a working desk, a kitchenette with espresso machine, and a large rain shower.

Perfect for a couple seeking an authentic Florentine experience without paying tourist-trap prices. The building has a lovely courtyard shared with local residents.

Neighborhood highlights: Enoteca Pitti Gola e Cantina (50m away), Trattoria dell'Orto, morning coffee at Bar Ricchi in Piazza Santo Spirito.""",
            description_short="Charming studio in the heart of Oltrarno, 300m from Palazzo Pitti. Authentic neighborhood, artisan workshops, the real Florence.",
            property_type="apartment",
            neighborhood="Oltrarno",
            address="Via dei Serragli, Firenze",
            city="Florence",
            country="IT",
            lat=43.7654,
            lng=11.2476,
            bedrooms=0,
            bathrooms=1,
            max_guests=2,
            size_sqm=35,
            amenities=[
                "wifi", "ac", "heating", "kitchenette", "coffee_machine",
                "tv", "iron", "hair_dryer", "self_check_in"
            ],
            house_rules={
                "check_in": "15:00",
                "check_out": "11:00",
                "min_nights": 2,
                "smoking": False,
                "pets": False,
                "parties": False
            },
            cancellation_policy={
                "type": "flexible",
                "rules": [
                    {"days_before": 14, "refund_percent": 100},
                    {"days_before": 7, "refund_percent": 50},
                    {"days_before": 0, "refund_percent": 0}
                ]
            },
            base_price=90,
            cleaning_fee=50,
            currency="EUR",
            seasonal_pricing=[
                {"label": "Winter", "start": "2026-01-01", "end": "2026-03-31", "price": 75},
                {"label": "Spring", "start": "2026-04-01", "end": "2026-06-30", "price": 105},
                {"label": "Summer", "start": "2026-07-01", "end": "2026-08-31", "price": 120},
                {"label": "Autumn", "start": "2026-09-01", "end": "2026-10-31", "price": 105},
                {"label": "Low Season", "start": "2026-11-01", "end": "2026-12-31", "price": 80},
            ],
            discounts=[
                {"min_nights": 7, "percent": 10},
                {"min_nights": 28, "percent": 20}
            ],
            additional_services=[
                {"name": "airport_transfer", "price": 50, "currency": "EUR"},
                {"name": "late_checkout", "price": 25, "currency": "EUR"}
            ],
            trust_card={
                "overall": 4.7,
                "total_reviews": 89,
                "summary": "Guests love the authentic neighborhood feel and proximity to Palazzo Pitti. The studio is praised for its cozy atmosphere and thoughtful design. Marco's local tips for restaurants and bars are consistently highlighted.",
                "airbnb": {
                    "rating": 4.7,
                    "count": 62,
                    "url": "https://www.airbnb.com/rooms/67890"
                },
                "booking": {
                    "rating": 9.1,
                    "count": 20,
                    "url": "https://www.booking.com/hotel/it/cozy-studio-oltrarno.html"
                },
                "google": {
                    "rating": 4.6,
                    "count": 7,
                    "url": "https://maps.google.com/?cid=67890"
                },
                "top_reviews": [
                    {
                        "author": "Marie L.",
                        "source": "Airbnb",
                        "rating": 5,
                        "text": "The most charming little studio! We fell in love with Oltrarno. Marco's restaurant recommendations were spot-on — we had the best dinner of our trip at a place only locals know.",
                        "date": "2026-02"
                    },
                    {
                        "author": "James R.",
                        "source": "Booking.com",
                        "rating": 5,
                        "text": "Perfect location for exploring the 'real' Florence. Palazzo Pitti is 3 minutes away, Ponte Vecchio 10 minutes. The studio was clean, cozy, and had everything we needed.",
                        "date": "2025-10"
                    }
                ]
            },
            nearby_landmarks=[
                {"name": "Palazzo Pitti", "distance_meters": 300},
                {"name": "Ponte Vecchio", "distance_meters": 500},
                {"name": "Piazza Santo Spirito", "distance_meters": 200},
                {"name": "Boboli Gardens", "distance_meters": 400},
                {"name": "Ponte Santa Trinità", "distance_meters": 350}
            ]
        )
        db.add(listing2)
        await db.flush()

        # Photos for listing 2
        colors2 = ["C8E8C8/3A6A3A", "E8C8A0/7A5A30", "A8C8E8/3A5A7A", "E8E8C8/6A6A3A"]
        captions2 = ["Cozy studio living area", "Kitchenette and dining nook", "Queen bed with garden view", "Courtyard view"]
        for i in range(1, 5):
            photo = Photo(
                listing_id=listing2.id,
                url=f"https://placehold.co/800x600/{colors2[i-1]}?text=Oltrarno+Studio+{i}",
                caption=captions2[i-1],
                sort_order=i - 1,
                is_cover=(i == 1)
            )
            db.add(photo)

        # ── LISTING 3: Luxury Penthouse with Terrace ──
        listing3 = Listing(
            host_id=host.id,
            slug="luxury-penthouse-terrace",
            status="active",
            name="Luxury Penthouse with Rooftop Terrace — Santa Croce, 6 guests",
            description="""Florence from above. This stunning 140m² penthouse occupies the entire top floor of a historic palazzo in Santa Croce, with a 50m² rooftop terrace offering 360° views of the city skyline, the hills of Fiesole, and the terracotta domes of Florence's greatest churches.

Three generous bedrooms accommodate up to 6 guests in exceptional comfort. The master bedroom has a king-size bed and an en-suite bathroom with a deep soaking tub. Two twin bedrooms share a well-appointed second bathroom. The living room features 18th-century ceiling moldings, a fully equipped open-plan kitchen, and direct terrace access.

The terrace is the apartment's crown jewel: dining al fresco with Florence at your feet, watching sunsets over the Arno, or morning yoga with panoramic views. We provide quality outdoor furniture, a BBQ grill, and ambient lighting.

Location: Santa Croce basilica is 200m away. The neighborhood's Sant'Ambrogio market (perfect for morning shopping) is a 5-minute walk. The Duomo is reachable in 20 minutes on foot through charming medieval streets.""",
            description_short="Top-floor penthouse with 360° rooftop terrace. 3 bedrooms, 140m², panoramic Florence views. Perfect for groups and special occasions.",
            property_type="penthouse",
            neighborhood="Santa Croce",
            address="Via dei Pepi, Firenze",
            city="Florence",
            country="IT",
            lat=43.7683,
            lng=11.2627,
            bedrooms=3,
            bathrooms=2,
            max_guests=6,
            size_sqm=140,
            amenities=[
                "wifi", "ac", "heating", "kitchen", "washer", "dryer", "tv",
                "netflix", "coffee_machine", "dishwasher", "rooftop_terrace",
                "city_view", "bbq", "elevator", "self_check_in", "iron",
                "hair_dryer", "workspace", "baby_crib_available"
            ],
            house_rules={
                "check_in": "15:00",
                "check_out": "11:00",
                "min_nights": 3,
                "smoking": False,
                "pets": False,
                "parties": False
            },
            cancellation_policy={
                "type": "moderate",
                "rules": [
                    {"days_before": 21, "refund_percent": 100},
                    {"days_before": 14, "refund_percent": 50},
                    {"days_before": 0, "refund_percent": 0}
                ]
            },
            base_price=280,
            cleaning_fee=120,
            currency="EUR",
            seasonal_pricing=[
                {"label": "Winter", "start": "2026-01-01", "end": "2026-03-31", "price": 220},
                {"label": "Spring", "start": "2026-04-01", "end": "2026-06-30", "price": 320},
                {"label": "Summer", "start": "2026-07-01", "end": "2026-08-31", "price": 380},
                {"label": "Autumn", "start": "2026-09-01", "end": "2026-10-31", "price": 320},
                {"label": "Low Season", "start": "2026-11-01", "end": "2026-12-31", "price": 240},
            ],
            discounts=[
                {"min_nights": 7, "percent": 10},
                {"min_nights": 28, "percent": 20}
            ],
            additional_services=[
                {"name": "airport_transfer", "price": 50, "currency": "EUR"},
                {"name": "chef_dinner", "price": 150, "currency": "EUR"},
                {"name": "grocery_delivery", "price": 45, "currency": "EUR"},
                {"name": "late_checkout", "price": 50, "currency": "EUR"}
            ],
            trust_card={
                "overall": 4.8,
                "total_reviews": 64,
                "summary": "The rooftop terrace is universally described as the highlight of Florence stays. Guests consistently mention the terrace sunsets, the spaciousness for groups, and the perfect Santa Croce location near the market.",
                "airbnb": {
                    "rating": 4.8,
                    "count": 45,
                    "url": "https://www.airbnb.com/rooms/11111"
                },
                "booking": {
                    "rating": 9.6,
                    "count": 14,
                    "url": "https://www.booking.com/hotel/it/luxury-penthouse-terrace.html"
                },
                "google": {
                    "rating": 4.9,
                    "count": 5,
                    "url": "https://maps.google.com/?cid=11111"
                },
                "top_reviews": [
                    {
                        "author": "Catherine B.",
                        "source": "Airbnb",
                        "rating": 5,
                        "text": "Our anniversary trip was made perfect by this penthouse. The rooftop at sunset with a bottle of Chianti — unforgettable. We had 4 people and the space felt palatial.",
                        "date": "2026-01"
                    },
                    {
                        "author": "Antonio M.",
                        "source": "Booking.com",
                        "rating": 5,
                        "text": "We brought our extended family (6 people) and everyone had their own space. The terrace BBQ was a highlight — we cooked dinner up there twice. Sant'Ambrogio market is a 5-minute walk.",
                        "date": "2025-12"
                    }
                ]
            },
            nearby_landmarks=[
                {"name": "Santa Croce Basilica", "distance_meters": 200},
                {"name": "Sant'Ambrogio Market", "distance_meters": 400},
                {"name": "Piazzale Michelangelo", "distance_meters": 1000},
                {"name": "Bargello Museum", "distance_meters": 600},
                {"name": "Duomo", "distance_meters": 900}
            ]
        )
        db.add(listing3)
        await db.flush()

        # Photos for listing 3
        colors3 = ["E8C0A0/8B4A20", "A0C0E8/2A5A8A", "C0E8A0/4A8A2A", "E8E0C0/8A7A3A", "C0A0E8/6A3A8A"]
        captions3 = ["Panoramic rooftop terrace at sunset", "Spacious living room with terrace access", "Master bedroom with en-suite bath", "Open-plan kitchen", "Rooftop dining al fresco"]
        for i in range(1, 6):
            photo = Photo(
                listing_id=listing3.id,
                url=f"https://placehold.co/800x600/{colors3[i-1]}?text=Penthouse+{i}",
                caption=captions3[i-1],
                sort_order=i - 1,
                is_cover=(i == 1)
            )
            db.add(photo)

        # ── BLOG ARTICLES ──
        for article_data in ARTICLES:
            article = BlogArticle(
                slug=article_data["slug"],
                title=article_data["title"],
                meta_description=article_data["meta_description"],
                content=article_data["content"],
                city=article_data["city"],
                faq=article_data["faq"],
                related_listing_slugs=article_data["related_listing_slugs"]
            )
            db.add(article)

        await db.commit()
        print("✓ Seeded: 1 host (Marco)")
        print("✓ Seeded: 3 listings (Elegant Apartment, Cozy Studio, Luxury Penthouse)")
        print("✓ Seeded: 14 photos")
        print("✓ Seeded: 2 blog articles")
        print("")
        print("🌐 Open http://localhost:8000 to see the site")
        print("📖 API docs: http://localhost:8000/docs")
        print("🤖 AI Plugin: http://localhost:8000/.well-known/ai-plugin.json")


if __name__ == "__main__":
    asyncio.run(seed())
