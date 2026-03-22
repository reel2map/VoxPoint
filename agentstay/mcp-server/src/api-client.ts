const API_BASE_URL = process.env.API_BASE_URL || "http://localhost:8000";

async function apiFetch(path: string, options?: RequestInit): Promise<unknown> {
  const url = `${API_BASE_URL}${path}`;
  console.error(`[AgentStay MCP] ${options?.method || "GET"} ${url}`);

  const response = await fetch(url, {
    ...options,
    headers: {
      "Content-Type": "application/json",
      "User-Agent": "AgentStay-MCP/1.0",
      ...options?.headers,
    },
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`API error ${response.status}: ${errorText}`);
  }

  return response.json();
}

export interface SearchParams {
  city?: string;
  check_in?: string;
  check_out?: string;
  guests?: number;
  max_price?: number;
  neighborhood?: string;
  amenities?: string[];
  sort?: string;
  limit?: number;
}

export interface GuestInfo {
  name: string;
  email: string;
  phone?: string;
  num_guests: number;
  message?: string;
}

export interface BookingRequest {
  listing_slug: string;
  check_in: string;
  check_out: string;
  guest: GuestInfo;
  agent_name?: string;
}

export const apiClient = {
  async searchListings(params: SearchParams) {
    const query = new URLSearchParams();
    if (params.city) query.set("city", params.city);
    if (params.check_in) query.set("check_in", params.check_in);
    if (params.check_out) query.set("check_out", params.check_out);
    if (params.guests) query.set("guests", String(params.guests));
    if (params.max_price) query.set("max_price", String(params.max_price));
    if (params.neighborhood) query.set("neighborhood", params.neighborhood);
    if (params.amenities?.length) query.set("amenities", params.amenities.join(","));
    if (params.sort) query.set("sort", params.sort);
    if (params.limit) query.set("limit", String(params.limit));
    return apiFetch(`/api/v1/listings?${query.toString()}`);
  },

  async getListingDetails(slug: string) {
    return apiFetch(`/api/v1/listings/${slug}`);
  },

  async checkAvailability(slug: string, checkIn: string, checkOut: string, guests: number) {
    const query = new URLSearchParams({
      check_in: checkIn,
      check_out: checkOut,
      guests: String(guests),
    });
    return apiFetch(`/api/v1/listings/${slug}/availability?${query.toString()}`);
  },

  async createBooking(booking: BookingRequest) {
    return apiFetch("/api/v1/bookings", {
      method: "POST",
      body: JSON.stringify(booking),
    });
  },

  async getBookingStatus(bookingId: string) {
    return apiFetch(`/api/v1/bookings/${bookingId}`);
  },

  async listCities() {
    return apiFetch("/api/v1/cities");
  },
};
