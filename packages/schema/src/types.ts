import { z } from "zod";

/**
 * Case-insensitive text
 */
export const citext = z.string().brand<"Citext">();

/**
 * Case-insensitive text
 */
export type Citext = z.infer<typeof citext>;

/**
 * Email address, case-insensitive, and based on the HTML5 spec
 */
export const email = z.string().email().brand<"Email">();

/**
 * Email address, case-insensitive, and based on the HTML5 spec
 */
export type Email = z.infer<typeof email>;

export const id = z.number();

// Auth
export const userId = id.brand<"UserId">();

// Bookings
export const hostId = id.brand<"HostId">();
export const eventId = id.brand<"EventId">();
export const inviteeId = id.brand<"InviteeId">();
export const bookingId = id.brand<"BookingId">();
