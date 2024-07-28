import type { z } from 'zod';
import type { bookingId } from '../../types.js';
import type { HostId } from './Host.js';
import type { EventId } from './Event.js';
import type { InviteeId } from './Invitee.js';
import type { ColumnType, Selectable, Insertable, Updateable } from 'kysely';

/** Identifier type for booking */
export type BookingId = z.infer<typeof bookingId>;

/** Represents the table bookings.booking */
export default interface BookingTable {
  id: ColumnType<BookingId, never, never>;

  host_id: ColumnType<HostId, HostId, HostId>;

  event_id: ColumnType<EventId, EventId, EventId>;

  invitee_id: ColumnType<InviteeId, InviteeId, InviteeId>;

  invitee_note: ColumnType<string | null, string | null, string | null>;

  /** The time range for the booking, mutually exclusive for the host. */
  duration: ColumnType<string, string, string>;

  created_at: ColumnType<Date, Date | string | undefined, Date | string>;

  updated_at: ColumnType<Date, Date | string | undefined, Date | string>;
}

export type Booking = Selectable<BookingTable>;

export type NewBooking = Insertable<BookingTable>;

export type BookingUpdate = Updateable<BookingTable>;