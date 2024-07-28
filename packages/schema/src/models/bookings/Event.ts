import type { z } from 'zod';
import type { eventId, Citext } from '../../types.js';
import type { HostId } from './Host.js';
import type { ColumnType, Selectable, Insertable, Updateable } from 'kysely';

/** Identifier type for event */
export type EventId = z.infer<typeof eventId>;

/** Represents the table bookings.event */
export default interface EventTable {
  id: ColumnType<EventId, never, never>;

  host_id: ColumnType<HostId, HostId, HostId>;

  /** A unique, case-insensitive identifier for the event. */
  slug: ColumnType<Citext, Citext, Citext>;

  name: ColumnType<string, string, string>;

  description: ColumnType<string, string, string>;

  created_at: ColumnType<Date, Date | string | undefined, Date | string>;

  updated_at: ColumnType<Date, Date | string | undefined, Date | string>;
}

export type Event = Selectable<EventTable>;

export type NewEvent = Insertable<EventTable>;

export type EventUpdate = Updateable<EventTable>;