from typing import Optional, List, Any
from datetime import date, datetime
from decimal import Decimal
from pydantic import BaseModel, EmailStr, field_validator
import uuid


class PhotoOut(BaseModel):
    id: str
    url: str
    caption: Optional[str]
    sort_order: int
    is_cover: bool

    class Config:
        from_attributes = True


class HostOut(BaseModel):
    id: str
    name: str
    languages: Optional[List[str]] = ["en"]

    class Config:
        from_attributes = True


class ListingCard(BaseModel):
    id: str
    slug: str
    name: str
    description_short: Optional[str]
    city: str
    neighborhood: Optional[str]
    country: str
    bedrooms: int
    bathrooms: int
    max_guests: int
    size_sqm: Optional[int]
    base_price: Decimal
    cleaning_fee: Decimal
    currency: str
    trust_card: Optional[Any]
    cover_photo: Optional[PhotoOut]

    class Config:
        from_attributes = True


class ListingDetail(BaseModel):
    id: str
    slug: str
    name: str
    description: Optional[str]
    description_short: Optional[str]
    property_type: str
    city: str
    neighborhood: Optional[str]
    address: Optional[str]
    country: str
    lat: Optional[Decimal]
    lng: Optional[Decimal]
    bedrooms: int
    bathrooms: int
    max_guests: int
    size_sqm: Optional[int]
    amenities: List[str]
    house_rules: Any
    cancellation_policy: Any
    base_price: Decimal
    cleaning_fee: Decimal
    currency: str
    seasonal_pricing: Any
    discounts: Any
    additional_services: Any
    trust_card: Optional[Any]
    nearby_landmarks: Any
    photos: List[PhotoOut]
    host: Optional[HostOut]

    class Config:
        from_attributes = True


class ListingsResponse(BaseModel):
    total: int
    listings: List[ListingCard]


class GuestInfo(BaseModel):
    name: str
    email: str
    phone: Optional[str] = None
    num_guests: int = 2
    message: Optional[str] = None


class BookingCreate(BaseModel):
    listing_slug: str
    check_in: date
    check_out: date
    guest: GuestInfo
    agent_name: Optional[str] = None

    @field_validator("check_out")
    @classmethod
    def check_out_after_check_in(cls, v, info):
        if "check_in" in info.data and v <= info.data["check_in"]:
            raise ValueError("check_out must be after check_in")
        return v


class BookingOut(BaseModel):
    id: str
    listing_id: str
    status: str
    check_in: date
    check_out: date
    guest_name: str
    guest_email: str
    num_guests: int
    agent_name: Optional[str]
    price_breakdown: Optional[Any]
    total_price: Optional[Decimal]
    payment_url: Optional[str]
    decline_reason: Optional[str]
    created_at: datetime

    class Config:
        from_attributes = True


class AvailabilityResponse(BaseModel):
    slug: str
    check_in: date
    check_out: date
    guests: int
    available: bool
    nights: int
    price_breakdown: Any
    total_price: Optional[Decimal]


class CityOut(BaseModel):
    city: str
    country: str
    listing_count: int
    avg_price: Optional[Decimal]


class HealthResponse(BaseModel):
    status: str
    database: str
    version: str
    uptime_seconds: float


class BlogArticleCard(BaseModel):
    id: str
    slug: str
    title: str
    meta_description: Optional[str]
    city: Optional[str]
    published_at: datetime

    class Config:
        from_attributes = True


class BlogArticleDetail(BaseModel):
    id: str
    slug: str
    title: str
    meta_description: Optional[str]
    content: str
    city: Optional[str]
    faq: Any
    related_listing_slugs: List[str]
    published_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
