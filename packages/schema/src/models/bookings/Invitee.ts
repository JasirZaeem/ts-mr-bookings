import type { z } from 'zod';
import type { inviteeId, Email } from '../../types.js';
import type { EventId } from './Event.js';
import type { ColumnType, Selectable, Insertable, Updateable } from 'kysely';

/** Identifier type for invitee */
export type InviteeId = z.infer<typeof inviteeId>;

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