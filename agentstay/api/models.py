import uuid
from datetime import datetime, date
from sqlalchemy import (
    Column, String, Text, Boolean, Integer, Numeric,
    DateTime, Date, SmallInteger, ForeignKey, BigInteger, UniqueConstraint
)
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSONB, CHAR
from sqlalchemy.orm import relationship
from api.database import Base


def gen_uuid():
    return str(uuid.uuid4())


class Host(Base):
    __tablename__ = "hosts"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    email = Column(String(255), unique=True, nullable=False)
    name = Column(String(255), nullable=False)
    phone = Column(String(50))
    languages = Column(ARRAY(Text), default=["en"])
    telegram_chat_id = Column(BigInteger)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)

    listings = relationship("Listing", back_populates="host")


class Listing(Base):
    __tablename__ = "listings"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    host_id = Column(UUID(as_uuid=False), ForeignKey("hosts.id"))
    slug = Column(String(255), unique=True, nullable=False)
    status = Column(String(20), default="active")
    name = Column(String(500), nullable=False)
    description = Column(Text)
    description_short = Column(String(500))
    property_type = Column(String(50), default="apartment")
    neighborhood = Column(String(100))
    address = Column(Text)
    city = Column(String(100), nullable=False)
    country = Column(CHAR(2), default="IT")
    lat = Column(Numeric(10, 7))
    lng = Column(Numeric(10, 7))
    bedrooms = Column(SmallInteger, default=1)
    bathrooms = Column(SmallInteger, default=1)
    max_guests = Column(SmallInteger, default=4)
    size_sqm = Column(SmallInteger)
    amenities = Column(ARRAY(Text), default=[])
    house_rules = Column(JSONB, default={
        "check_in": "15:00",
        "check_out": "11:00",
        "min_nights": 2,
        "smoking": False,
        "pets": False,
        "parties": False
    })
    cancellation_policy = Column(JSONB, default={
        "type": "flexible",
        "rules": [
            {"days_before": 14, "refund_percent": 100},
            {"days_before": 7, "refund_percent": 50},
            {"days_before": 0, "refund_percent": 0}
        ]
    })
    base_price = Column(Numeric(10, 2), nullable=False)
    cleaning_fee = Column(Numeric(10, 2), default=0)
    currency = Column(CHAR(3), default="EUR")
    seasonal_pricing = Column(JSONB, default=[])
    discounts = Column(JSONB, default=[
        {"min_nights": 7, "percent": 10},
        {"min_nights": 28, "percent": 20}
    ])
    additional_services = Column(JSONB, default=[])
    trust_card = Column(JSONB)
    nearby_landmarks = Column(JSONB, default=[])
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow, onupdate=datetime.utcnow)

    host = relationship("Host", back_populates="listings")
    photos = relationship("Photo", back_populates="listing", order_by="Photo.sort_order")
    blocked_dates = relationship("BlockedDate", back_populates="listing")
    booking_requests = relationship("BookingRequest", back_populates="listing")


class Photo(Base):
    __tablename__ = "photos"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    listing_id = Column(UUID(as_uuid=False), ForeignKey("listings.id", ondelete="CASCADE"))
    url = Column(Text, nullable=False)
    caption = Column(String(500))
    sort_order = Column(SmallInteger, default=0)
    is_cover = Column(Boolean, default=False)

    listing = relationship("Listing", back_populates="photos")


class BlockedDate(Base):
    __tablename__ = "blocked_dates"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    listing_id = Column(UUID(as_uuid=False), ForeignKey("listings.id", ondelete="CASCADE"))
    date = Column(Date, nullable=False)
    reason = Column(String(20), default="blocked")

    __table_args__ = (UniqueConstraint("listing_id", "date"),)

    listing = relationship("Listing", back_populates="blocked_dates")


class BookingRequest(Base):
    __tablename__ = "booking_requests"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    listing_id = Column(UUID(as_uuid=False), ForeignKey("listings.id"))
    status = Column(String(30), default="pending_approval")
    check_in = Column(Date, nullable=False)
    check_out = Column(Date, nullable=False)
    guest_name = Column(String(255), nullable=False)
    guest_email = Column(String(255), nullable=False)
    guest_phone = Column(String(50))
    num_guests = Column(SmallInteger, default=2)
    message = Column(Text)
    agent_name = Column(String(100))
    price_breakdown = Column(JSONB)
    total_price = Column(Numeric(10, 2))
    payment_url = Column(Text)
    decline_reason = Column(Text)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)
    expires_at = Column(DateTime(timezone=True))

    listing = relationship("Listing", back_populates="booking_requests")


class BlogArticle(Base):
    __tablename__ = "blog_articles"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    slug = Column(String(255), unique=True, nullable=False)
    title = Column(String(500), nullable=False)
    meta_description = Column(String(300))
    content = Column(Text, nullable=False)
    city = Column(String(100))
    faq = Column(JSONB, default=[])
    related_listing_slugs = Column(ARRAY(Text), default=[])
    published_at = Column(DateTime(timezone=True), default=datetime.utcnow)
    updated_at = Column(DateTime(timezone=True), default=datetime.utcnow)
