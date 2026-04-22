import { z } from "zod";
import { apiClient } from "./api-client.js";

export const tools = [
  {
    name: "search_listings",
    description:
      "Search vacation apartments on AgentStay. Filter by city, dates, guests, price, neighborhood. Returns listing cards with prices and ratings.",
    inputSchema: {
      type: "object",
      properties: {
        city: {
          type: "string",
          description: "City name (e.g. 'florence', 'rome', 'venice')",
        },
        check_in: {
          type: "string",
          description: "Check-in date in YYYY-MM-DD format",
        },
        check_out: {
          type: "string",
          description: "Check-out date in YYYY-MM-DD format",
        },
        guests: {
          type: "number",
          description: "Number of guests",
        },
        max_price: {
          type: "number",
          description: "Maximum price per night in EUR",
        },
        neighborhood: {
          type: "string",
          description: "Neighborhood name (e.g. 'Centro Storico', 'Oltrarno')",
        },
        amenities: {
          type: "array",
          items: { type: "string" },
          description: "Required amenities (e.g. ['wifi', 'terrace', 'kitchen'])",
        },
        sort: {
          type: "string",
          enum: ["rating", "price_asc", "price_desc"],
          description: "Sort order: rating (default), price_asc, price_desc",
        },
        limit: {
          type: "number",
          description: "Max results to return (default 10)",
        },
      },
    },
  },
  {
    name: "get_listing_details",
    description:
      "Get full details of a specific apartment by slug. Includes description, all photos, amenities, pricing, trust card with reviews, and nearby landmarks.",
    inputSchema: {
      type: "object",
      properties: {
        slug: {
          type: "string",
          description: "Listing slug (e.g. 'elegant-apartment-near-duomo')",
        },
      },
      required: ["slug"],
    },
  },
  {
    name: "check_availability",
    description:
      "Check if an apartment is available for specific dates and get a full price breakdown including nightly rates, discounts, cleaning fee, and total.",
    inputSchema: {
      type: "object",
      properties: {
        slug: {
          type: "string",
          description: "Listing slug",
        },
        check_in: {
          type: "string",
          description: "Check-in date YYYY-MM-DD",
        },
        check_out: {
          type: "string",
          description: "Check-out date YYYY-MM-DD",
        },
        guests: {
          type: "number",
          description: "Number of guests",
        },
      },
      required: ["slug", "check_in", "check_out"],
    },
  },
  {
    name: "create_booking_request",
    description:
      "Submit a booking request for an apartment. Host will confirm within 24 hours. Returns booking ID to track status.",
    inputSchema: {
      type: "object",
      properties: {
        listing_slug: {
          type: "string",
          description: "Listing slug to book",
        },
        check_in: {
          type: "string",
          description: "Check-in date YYYY-MM-DD",
        },
        check_out: {
          type: "string",
          description: "Check-out date YYYY-MM-DD",
        },
        guest_name: {
          type: "string",
          description: "Guest's full name",
        },
        guest_email: {
          type: "string",
          description: "Guest's email address",
        },
        guest_phone: {
          type: "string",
          description: "Guest's phone number (optional)",
        },
        num_guests: {
          type: "number",
          description: "Number of guests",
        },
        message: {
          type: "string",
          description: "Optional message to the host",
        },
      },
      required: ["listing_slug", "check_in", "check_out", "guest_name", "guest_email", "num_guests"],
    },
  },
  {
    name: "get_booking_status",
    description:
      "Check the status of a booking request by ID. Status can be: pending_approval, approved (includes payment_url), declined.",
    inputSchema: {
      type: "object",
      properties: {
        booking_id: {
          type: "string",
          description: "Booking ID (UUID) returned by create_booking_request",
        },
      },
      required: ["booking_id"],
    },
  },
  {
    name: "list_cities",
    description: "List all cities with available apartments, including listing counts and average prices.",
    inputSchema: {
      type: "object",
      properties: {},
    },
  },
];

const SearchSchema = z.object({
  city: z.string().optional(),
  check_in: z.string().optional(),
  check_out: z.string().optional(),
  guests: z.number().optional(),
  max_price: z.number().optional(),
  neighborhood: z.string().optional(),
  amenities: z.array(z.string()).optional(),
  sort: z.enum(["rating", "price_asc", "price_desc"]).optional(),
  limit: z.number().optional(),
});

const SlugSchema = z.object({ slug: z.string() });

const AvailabilitySchema = z.object({
  slug: z.string(),
  check_in: z.string(),
  check_out: z.string(),
  guests: z.number().optional().default(2),
});

const BookingSchema = z.object({
  listing_slug: z.string(),
  check_in: z.string(),
  check_out: z.string(),
  guest_name: z.string(),
  guest_email: z.string().email(),
  guest_phone: z.string().optional(),
  num_guests: z.number().int().positive(),
  message: z.string().optional(),
});

const BookingStatusSchema = z.object({ booking_id: z.string() });

export async function handleTool(name: string, args: unknown): Promise<string> {
  console.error(`[AgentStay MCP] Executing tool: ${name}`);

  switch (name) {
    case "search_listings": {
      const params = SearchSchema.parse(args);
      const result = await apiClient.searchListings(params);
      return JSON.stringify(result, null, 2);
    }

    case "get_listing_details": {
      const { slug } = SlugSchema.parse(args);
      const result = await apiClient.getListingDetails(slug);
      return JSON.stringify(result, null, 2);
    }

    case "check_availability": {
      const { slug, check_in, check_out, guests } = AvailabilitySchema.parse(args);
      const result = await apiClient.checkAvailability(slug, check_in, check_out, guests);
      return JSON.stringify(result, null, 2);
    }

    case "create_booking_request": {
      const params = BookingSchema.parse(args);
      const result = await apiClient.createBooking({
        listing_slug: params.listing_slug,
        check_in: params.check_in,
        check_out: params.check_out,
        agent_name: "Claude Desktop MCP",
        guest: {
          name: params.guest_name,
          email: params.guest_email,
          phone: params.guest_phone,
          num_guests: params.num_guests,
          message: params.message,
        },
      });
      return JSON.stringify(result, null, 2);
    }

    case "get_booking_status": {
      const { booking_id } = BookingStatusSchema.parse(args);
      const result = await apiClient.getBookingStatus(booking_id);
      return JSON.stringify(result, null, 2);
    }

    case "list_cities": {
      const result = await apiClient.listCities();
      return JSON.stringify(result, null, 2);
    }

    default:
      throw new Error(`Unknown tool: ${name}`);
  }
}
