import type { EventId } from './Event.js';
import type { Email } from '../../types.js';
import type { ColumnType, Selectable, Insertable, Updateable } from 'kysely';

/** Identifier type for bookings.invitee */
export type InviteeId = number & { __brand: 'InviteeId' };

/** Represents the table bookings.invitee */
export default interface InviteeTable {
  id: ColumnType<InviteeId, never, never>;

  event_id: ColumnType<EventId, EventId, EventId>;

  name: ColumnType<string, string, string>;

  email: ColumnType<Email, Email, Email>;

  created_at: ColumnType<Date, Date | string | undefined, Date | string>;

  updated_at: ColumnType<Date, Date | string | undefined, Date | string>;
}

export type Invitee = Selectable<InviteeTable>;

export type NewInvitee = Insertable<InviteeTable>;

export type InviteeUpdate = Updateable<InviteeTable>;