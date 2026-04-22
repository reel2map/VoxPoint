import httpx
import logging
from typing import Optional
from api.config import get_settings

logger = logging.getLogger(__name__)


async def send_telegram_notification(chat_id: int, message: str) -> bool:
    """Send Telegram notification to host."""
    settings = get_settings()
    if not settings.TELEGRAM_BOT_TOKEN or not chat_id:
        logger.info("Telegram not configured, skipping notification")
        return False

    try:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.post(
                f"https://api.telegram.org/bot{settings.TELEGRAM_BOT_TOKEN}/sendMessage",
                json={"chat_id": chat_id, "text": message, "parse_mode": "HTML"}
            )
            resp.raise_for_status()
            return True
    except Exception as e:
        logger.error(f"Telegram notification failed: {e}")
        return False


async def notify_new_booking(host_chat_id: Optional[int], booking: dict, listing_name: str):
    """Notify host about new booking request."""
    if not host_chat_id:
        return
    msg = (
        f"🏠 <b>New booking request!</b>\n\n"
        f"Property: {listing_name}\n"
        f"Guest: {booking['guest_name']} ({booking['guest_email']})\n"
        f"Dates: {booking['check_in']} → {booking['check_out']}\n"
        f"Guests: {booking['num_guests']}\n"
        f"Total: €{booking.get('total_price', 'TBD')}\n\n"
        f"Booking ID: <code>{booking['id']}</code>"
    )
    await send_telegram_notification(host_chat_id, msg)
