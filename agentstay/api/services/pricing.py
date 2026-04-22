from datetime import date, timedelta
from decimal import Decimal
from typing import Optional, Any


def get_nightly_price(listing: Any, night_date: date) -> Decimal:
    """Get price for a specific night based on seasonal pricing."""
    base_price = Decimal(str(listing.base_price))
    seasonal_pricing = listing.seasonal_pricing or []

    for season in seasonal_pricing:
        try:
            start = date.fromisoformat(season["start"])
            end = date.fromisoformat(season["end"])
            if start <= night_date <= end:
                return Decimal(str(season["price"]))
        except (KeyError, ValueError):
            continue

    return base_price


def calculate_discount(nights: int, discounts: list) -> Decimal:
    """Calculate discount percentage based on length of stay."""
    best_discount = Decimal("0")
    for disc in sorted(discounts or [], key=lambda d: d.get("min_nights", 0), reverse=True):
        min_nights = disc.get("min_nights", 0)
        percent = disc.get("percent", 0)
        if nights >= min_nights:
            best_discount = Decimal(str(percent))
            break
    return best_discount


def calculate_price_breakdown(listing: Any, check_in: date, check_out: date) -> dict:
    """Calculate full price breakdown for a booking."""
    nights = (check_out - check_in).days
    if nights <= 0:
        return {"error": "Invalid dates", "nights": 0, "total": 0}

    nightly_prices = []
    total_nightly = Decimal("0")
    current = check_in
    while current < check_out:
        price = get_nightly_price(listing, current)
        nightly_prices.append({"date": current.isoformat(), "price": float(price)})
        total_nightly += price
        current += timedelta(days=1)

    discount_percent = calculate_discount(nights, listing.discounts or [])
    discount_amount = total_nightly * discount_percent / 100
    subtotal = total_nightly - discount_amount
    cleaning_fee = Decimal(str(listing.cleaning_fee or 0))
    total = subtotal + cleaning_fee

    return {
        "nights": nights,
        "nightly_prices": nightly_prices,
        "subtotal_nightly": float(total_nightly),
        "discount_percent": float(discount_percent),
        "discount_amount": float(discount_amount),
        "cleaning_fee": float(cleaning_fee),
        "total": float(total),
        "currency": listing.currency or "EUR"
    }
