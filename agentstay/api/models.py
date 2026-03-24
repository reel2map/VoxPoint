"""Simplified models for F1 Penthouse Florence — only reservations needed."""
import uuid
from datetime import datetime, date
from sqlalchemy import Column, String, Text, SmallInteger, Numeric, DateTime, Date
from sqlalchemy.dialects.postgresql import UUID, JSONB
from api.database import Base


def gen_uuid():
    return str(uuid.uuid4())


class Reservation(Base):
    __tablename__ = "reservations"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    status = Column(String(30), default="pending")  # pending | confirmed | cancelled
    check_in = Column(Date, nullable=False)
    check_out = Column(Date, nullable=False)
    guest_first_name = Column(String(100), nullable=False)
    guest_last_name = Column(String(100), nullable=False)
    guest_email = Column(String(255), nullable=False)
    guest_phone = Column(String(50))
    num_guests = Column(SmallInteger, default=2)
    special_requests = Column(Text)
    price_breakdown = Column(JSONB)
    total_price = Column(Numeric(10, 2))
    payment_url = Column(Text)
    payment_status = Column(String(20), default="unpaid")  # unpaid | paid
    agent_name = Column(String(100))
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)
    expires_at = Column(DateTime(timezone=True))


class BlockedDate(Base):
    __tablename__ = "blocked_dates"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    date = Column(Date, nullable=False, unique=True)
    reason = Column(String(50), default="blocked")  # blocked | reserved | maintenance
    reservation_id = Column(UUID(as_uuid=False), nullable=True)
    created_at = Column(DateTime(timezone=True), default=datetime.utcnow)
