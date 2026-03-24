"""Pydantic schemas for F1 Penthouse Florence API."""
from typing import Optional, Any
from datetime import date, datetime
from decimal import Decimal
from pydantic import BaseModel, EmailStr, field_validator


class GuestInfo(BaseModel):
    first_name: str
    last_name: str
    email: str
    phone: Optional[str] = None


class ReservationCreate(BaseModel):
    check_in: date
    check_out: date
    guests: int = 2
    guest: GuestInfo
    special_requests: Optional[str] = None
    agent_name: Optional[str] = None

    @field_validator("check_out")
    @classmethod
    def check_out_after_check_in(cls, v, info):
        if "check_in" in info.data and v <= info.data["check_in"]:
            raise ValueError("check_out must be after check_in")
        return v

    @field_validator("guests")
    @classmethod
    def guests_in_range(cls, v):
        if not 1 <= v <= 7:
            raise ValueError("guests must be between 1 and 7")
        return v


class ReservationOut(BaseModel):
    id: str
    status: str
    check_in: date
    check_out: date
    guest_first_name: str
    guest_last_name: str
    guest_email: str
    num_guests: int
    price_breakdown: Optional[Any]
    total_price: Optional[Decimal]
    payment_url: Optional[str]
    payment_status: str
    created_at: datetime

    class Config:
        from_attributes = True


class QuoteRequest(BaseModel):
    check_in: date
    check_out: date
    guests: int = 2
    currency: str = "EUR"

    @field_validator("check_out")
    @classmethod
    def check_out_after_check_in(cls, v, info):
        if "check_in" in info.data and v <= info.data["check_in"]:
            raise ValueError("check_out must be after check_in")
        return v


class AvailabilityResponse(BaseModel):
    check_in: date
    check_out: date
    guests: int
    available: bool
    reason: Optional[str] = None
    nights: int
    price_breakdown: Optional[Any] = None
    total: Optional[Decimal] = None


class CheckoutSessionCreate(BaseModel):
    reservation_id: str
    success_url: str
    cancel_url: str
