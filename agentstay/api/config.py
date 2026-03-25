"""F1 Penthouse Florence – configuration and property data."""
from functools import lru_cache
from pydantic_settings import BaseSettings
from typing import Any


class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql+asyncpg://f1:f1@db:5432/f1penthouse"
    SITE_BASE_URL: str = "http://localhost:8000"
    SECRET_KEY: str = "f1penthouse-secret-key-change-in-production"
    STRIPE_SECRET_KEY: str = ""
    DEBUG: bool = False

    class Config:
        env_file = ".env"


@lru_cache()
def get_settings() -> Settings:
    return Settings()


# ── Property data ─────────────────────────────────────────────────────────────
PROPERTY: dict[str, Any] = {
    "id": "la-corsa-suite-firenze",
    "name": "La Corsa Suite Firenze",
    "tagline": "Private Cultural Residence in the Heart of Florence — Up to 7 Guests",
    "subtitle": (
        "An architectural experience near Ponte Vecchio and the Uffizi. "
        "Three bedrooms, two terraces, the spirit of F1 — as a cultural undertone."
    ),
    "type": "entire_penthouse",
    "url": "https://f1penthouse.com",
    "address": {
        "street": "Via dei Federighi 1",
        "city": "Florence",
        "postal_code": "50123",
        "country": "Italy",
        "country_code": "IT",
        "region": "Tuscany",
        "neighborhood": "Centro Storico",
    },
    "coordinates": {"lat": 43.7712, "lng": 11.2489},
    "capacity": {
        "max_guests": 7,
        "bedrooms": 3,
        "beds": 8,
        "bathrooms": 3,
    },
    "host": {
        "name": "Host",
        "email": "pent.house.f1.florence@gmail.com",
        "phone": "+39 3311385266",
        "languages": ["en", "it", "ru"],
        "cin": "[CIN number]",
        "check_in": "16:00–19:00",
        "check_out": "Before 10:00",
    },
    "landmarks": [
        {"name": "Arno River", "walk_minutes": 1},
        {"name": "Goldoni Square", "walk_minutes": 1},
        {"name": "Ponte Vecchio", "walk_minutes": 8},
        {"name": "Uffizi Gallery", "walk_minutes": 9},
        {"name": "Santa Maria Novella Station", "walk_minutes": 7},
        {"name": "Duomo", "walk_minutes": 10},
    ],
    "bedrooms": [
        {
            "name": "Master Bedroom",
            "bed": "King size bed",
            "bathroom": "Ensuite bathroom with walk-in shower",
            "extras": ["Television", "Safe"],
        },
        {
            "name": "Bedroom 2",
            "bed": "Double bed",
            "bathroom": "Ensuite bathroom with walk-in shower",
            "extras": ["Television"],
        },
        {
            "name": "Bedroom 3",
            "bed": "Double bed",
            "bathroom": "Shared bathroom with tropical rain shower",
            "extras": ["Television"],
        },
    ],
    "features": [
        "Ferrari heritage interior with authentic memorabilia",
        "Two terraces with BBQ and views of the Florentine hills",
        "Private hot tub — seasonal, available on request",
        "75-inch HDTV with Netflix",
        "Outdoor kitchen with oven, sink, and BBQ grill",
        "Fully equipped indoor kitchen",
        "High-speed Wi-Fi",
        "Central air conditioning & heating",
        "Washer & dryer in unit",
        "Luggage porter included (no lift — building protected by Belle Arti)",
        "Personal host check-in",
        "Italian chef available on request (culinary tradition since 1875)",
        "Weekly housekeeping included",
        "Carbon monoxide alarm & smoke alarm",
        "Fire extinguisher & first aid kit",
    ],
    "services": {
        "included": [
            "Personal host check-in — host greets you in person",
            "Luggage porter (building has no lift — protected by Belle Arti)",
            "Weekly housekeeping",
            "Bed linen & towels",
            "Exterior security cameras on property",
        ],
        "on_request": [
            "Private chef (Italian culinary tradition since 1875)",
            "Private cooking classes",
            "House pre-stocking (groceries & wine)",
            "Airport transfers",
            "Private driver",
            "Activities & excursions",
            "Additional housekeeping",
            "Laundry services",
            "Spa services",
            "Jacuzzi (seasonal, price on request)",
        ],
    },
    "amenities": {
        "Bedroom & Bathroom": [
            "Bedroom 1 — King size bed, ensuite with walk-in shower, TV, safe",
            "Bedroom 2 — Double bed, ensuite with walk-in shower, TV",
            "Bedroom 3 — Double bed, bathroom with tropical rain shower, TV",
            "Bed linen & towels",
            "Room-darkening blinds",
            "Wardrobe / clothes storage",
            "Hair dryer",
            "Iron & ironing board",
        ],
        "Living & Entertainment": [
            "75-inch HDTV with Netflix",
            "Books and reading material",
            "High-speed Wi-Fi",
            "Central air conditioning",
            "Central heating",
        ],
        "Kitchen": [
            "Fully equipped kitchen",
            "Refrigerator & freezer",
            "Dishwasher",
            "Cooker & oven",
            "Pod espresso machine & kettle",
            "Coffee maker",
            "Wine glasses",
            "Dishes and cutlery",
            "Cooking basics",
            "Dining table",
            "Waste compactor",
        ],
        "Outdoor": [
            "Two private terraces with views of Florentine hills",
            "Outdoor dining area & furniture",
            "Outdoor kitchen with oven and sink",
            "BBQ grill & barbecue utensils",
            "Private hot tub — seasonal, available on request",
        ],
        "Laundry & Convenience": [
            "Free washer — in unit",
            "Free dryer — in unit",
            "Essentials & hangers",
            "Safe",
            "Paid car park off premises",
        ],
        "Children": [
            "Cot",
            "Children's books and toys (ages 0–2 and 2–5)",
            "Baby bath — always at the listing",
            "Changing table — always at the listing",
        ],
        "Safety": [
            "Smoke alarm",
            "Carbon monoxide alarm",
            "Fire extinguisher",
            "First aid kit",
            "Exterior security cameras on property",
        ],
    },
    "photos": [
        {
            "category": "living",
            "url": "https://placehold.co/1200x800/2A2A2A/FFFFFF?text=F1+Penthouse+Hero",
            "alt": "F1 Penthouse Florence – hero view",
        },
        {
            "category": "living",
            "url": "https://placehold.co/800x600/3A3A3A/FFFFFF?text=Living+Room",
            "alt": "Ferrari-themed living room",
        },
        {
            "category": "bedroom",
            "url": "https://placehold.co/800x600/4A4A4A/FFFFFF?text=Master+Bedroom",
            "alt": "Master bedroom",
        },
        {
            "category": "terrace",
            "url": "https://placehold.co/800x600/5A5A5A/FFFFFF?text=Terrace+View",
            "alt": "Terrace with city view",
        },
        {
            "category": "kitchen",
            "url": "https://placehold.co/800x600/6A6A6A/FFFFFF?text=Kitchen",
            "alt": "Fully equipped kitchen",
        },
        {
            "category": "bathroom",
            "url": "https://placehold.co/800x600/7A7A7A/FFFFFF?text=Bathroom",
            "alt": "Luxury bathroom",
        },
        {
            "category": "living",
            "url": "https://placehold.co/800x600/3A3A3A/FFFFFF?text=Ferrari+Interior",
            "alt": "Ferrari memorabilia interior",
        },
        {
            "category": "terrace",
            "url": "https://placehold.co/800x600/4A4A4A/FFFFFF?text=Second+Terrace",
            "alt": "Second terrace",
        },
        {
            "category": "bedroom",
            "url": "https://placehold.co/800x600/5A5A5A/FFFFFF?text=Bedroom+2",
            "alt": "Second bedroom",
        },
        {
            "category": "neighborhood",
            "url": "https://placehold.co/800x600/6A6A6A/FFFFFF?text=Neighborhood",
            "alt": "Centro Storico neighborhood",
        },
    ],
    "trust": {
        "overall": 4.94,
        "total_reviews": 48,
        "scores": {
            "accuracy": 5.0,
            "checkin": 5.0,
            "communication": 5.0,
            "location": 5.0,
            "cleanliness": 4.9,
            "value": 4.8,
        },
        "sources": [
            {
                "platform": "Airbnb",
                "rating": 4.94,
                "count": 48,
                "url": "https://www.airbnb.it/rooms/813661997448757341",
            }
        ],
        "summary": (
            "Guests consistently praise the unique Ferrari-themed interior, "
            "exceptional walkable location just minutes from Ponte Vecchio and the Uffizi, "
            "and the stunning terrace views. "
            "Check-in, communication, and location all rated 5.0."
        ),
        "reviews": [
            {
                "author": "James R.",
                "source": "Airbnb",
                "rating": 5,
                "text": (
                    "Absolutely stunning penthouse. The Ferrari theme is done with real taste — "
                    "not kitschy at all. The terrace views over Florence are breathtaking. "
                    "Walked to Ponte Vecchio in 8 minutes. Already planning our return."
                ),
                "date": "Feb 2026",
            },
            {
                "author": "Sofia M.",
                "source": "Airbnb",
                "rating": 5,
                "text": (
                    "Perfect for our group of 6. Spacious, beautifully designed, and the location "
                    "is unbeatable. The host was incredibly responsive and helpful throughout. "
                    "The terrace with Florentine rooftops at sunrise — unforgettable."
                ),
                "date": "Jan 2026",
            },
            {
                "author": "Marco L.",
                "source": "Airbnb",
                "rating": 5,
                "text": (
                    "We came for a Ferrari fan pilgrimage and the apartment exceeded all expectations. "
                    "The memorabilia is authentic and the whole place feels like a private gallery. "
                    "Three full bathrooms for 5 people — never a queue. 10/10."
                ),
                "date": "Dec 2025",
            },
        ],
    },
    "pricing": {
        "currency": "EUR",
        "currency_symbol": "€",
        "cleaning_fee": 150,
        "min_nights": 2,
        "seasons": [
            {"label": "Low season",  "months": "Jan–Mar", "per_night": 250},
            {"label": "High season", "months": "Apr–Jun", "per_night": 350},
            {"label": "Peak season", "months": "Jul–Aug", "per_night": 400},
            {"label": "High season", "months": "Sep–Oct", "per_night": 350},
            {"label": "Low season",  "months": "Nov–Dec", "per_night": 280},
        ],
        "discounts": [
            {"min_nights": 7,  "percent": 10, "label": "Weekly discount"},
            {"min_nights": 28, "percent": 20, "label": "Monthly discount"},
        ],
    },
    "best_for": [
        "Families or groups of up to 7 guests",
        "Motorsport and Ferrari enthusiasts",
        "Couples seeking a design-led city break",
        "Birthday, anniversary, and milestone trips",
        "Art lovers — Uffizi 9 min, Duomo 10 min",
        "Guests who want personal, concierge-style service",
        "Families with young children (cot, baby bath, toys provided)",
        "Food lovers — private chef available on request",
    ],
    "not_for": [
        "Guests who prefer anonymous self check-in (check-in is personal, 4–7 PM)",
        "Guests who need a lift — building is protected by Belle Arti (luggage porter included)",
        "Party groups",
    ],
    "policies": {
        "check_in": "4:00 PM – 7:00 PM (in-person)",
        "check_out": "Before 10:00 AM",
        "min_nights": 2,
        "max_guests": 7,
        "cancellation": (
            "Free cancellation up to 14 days before check-in. "
            "50% refund 7–14 days before. No refund within 7 days."
        ),
        "smoking": False,
        "pets": False,
        "parties": False,
        "damage_deposit": "Please inquire when booking.",
        "jacuzzi": "Available seasonally; please confirm availability when booking.",
    },
    "faqs": [
        {
            "q": "Is the penthouse suitable for families or groups?",
            "a": (
                "Yes. The penthouse sleeps up to 7 guests across 3 bedrooms with 8 beds "
                "and 3 full bathrooms. The layout is spacious and genuinely comfortable "
                "for groups — no bottlenecks, no compromises."
            ),
        },
        {
            "q": "How far is it from Ponte Vecchio and the Uffizi?",
            "a": (
                "Ponte Vecchio is an 8-minute walk. The Uffizi Gallery is a 9-minute walk. "
                "The Arno River is literally 1 minute away. "
                "You're placed in the absolute centre of historic Florence."
            ),
        },
        {
            "q": "Is the area noisy at night?",
            "a": (
                "Via dei Federighi is a residential street in the historic centre — central but "
                "not on a main tourist route. Most guests report a quiet, pleasant stay. "
                "The apartment is on an upper floor, which helps significantly."
            ),
        },
        {
            "q": "Is there self check-in?",
            "a": (
                "Check-in is in-person, between 4:00 PM and 7:00 PM. "
                "The host or a representative will meet you at the property. "
                "If you require flexibility, please contact us in advance."
            ),
        },
        {
            "q": "Is the jacuzzi available all year?",
            "a": (
                "The jacuzzi is available seasonally. Please confirm availability "
                "when making your booking — we'll give you accurate information "
                "for your specific dates."
            ),
        },
        {
            "q": "Can I book directly online?",
            "a": (
                "Yes. This site offers secure direct booking with online payment via Stripe. "
                "Booking direct means no platform surcharges — "
                "you pay the real price, and we handle everything personally."
            ),
        },
        {
            "q": "Can AI agents or travel systems book through an API?",
            "a": (
                "Yes. This property exposes a documented REST API at /api/v1/ with availability, "
                "pricing, and reservation endpoints. Full OpenAPI spec at /api/openapi.json. "
                "AI discovery files are at /.well-known/ai-plugin.json and /.well-known/agent-card.json."
            ),
        },
    ],
    "airbnb_url": "https://www.airbnb.it/rooms/813661997448757341",
}

# Seasonal price lookup by month (1-12)
MONTH_SEASON: dict[int, dict] = {
    1:  {"label": "Low season",  "per_night": 250},
    2:  {"label": "Low season",  "per_night": 250},
    3:  {"label": "Low season",  "per_night": 250},
    4:  {"label": "High season", "per_night": 350},
    5:  {"label": "High season", "per_night": 350},
    6:  {"label": "High season", "per_night": 350},
    7:  {"label": "Peak season", "per_night": 400},
    8:  {"label": "Peak season", "per_night": 400},
    9:  {"label": "High season", "per_night": 350},
    10: {"label": "High season", "per_night": 350},
    11: {"label": "Low season",  "per_night": 280},
    12: {"label": "Low season",  "per_night": 280},
}

BLOG_ARTICLES = [
    {
        "slug": "where-to-stay-florence-neighborhoods-2026",
        "title": "Where to Stay in Florence: Best Neighborhoods for Every Traveler (2026)",
        "meta_description": (
            "Centro Storico, Oltrarno, Santa Croce, San Lorenzo — "
            "a practical guide to Florence's best neighborhoods for your 2026 trip."
        ),
        "date": "2026-03-10",
        "date_display": "March 10, 2026",
        "read_minutes": 8,
        "hero_image": "https://placehold.co/1200x600/3A3A3A/FFFFFF?text=Florence+Neighborhoods+Guide",
        "excerpt": (
            "Choosing where to stay in Florence shapes your entire trip. "
            "Here's a neighborhood-by-neighborhood breakdown for 2026 travelers."
        ),
        "content_key": "neighborhoods",
    },
    {
        "slug": "florence-apartment-vs-hotel-cost-2026",
        "title": "Florence Apartment vs Hotel: The Real Cost Comparison (2026)",
        "meta_description": (
            "Comparing total costs for a 5-night Florence trip: hotel vs apartment rental "
            "for groups of 2–7. The numbers may surprise you."
        ),
        "date": "2026-03-05",
        "date_display": "March 5, 2026",
        "read_minutes": 5,
        "hero_image": "https://placehold.co/1200x600/4A4A4A/FFFFFF?text=Apartment+vs+Hotel+Florence",
        "excerpt": (
            "A hotel room feels logical until you do the maths for a group. "
            "Here's the full cost breakdown — Florence apartment vs hotel, 2026."
        ),
        "content_key": "cost_comparison",
    },
]
