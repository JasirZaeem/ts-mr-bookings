import type { UserId } from '../auth/User.js';
import type { ColumnType, Selectable, Insertable, Updateable } from 'kysely';

/** Identifier type for bookings.host */
export type HostId = number & { __brand: 'HostId' };

/** Represents the table bookings.host */
export default interface HostTable {
  id: ColumnType<HostId, never, never>;

  user_id: ColumnType<UserId, UserId, UserId>;

  name: ColumnType<string, string, string>;

  created_at: ColumnType<Date, Date | string | undefined, Date | string>;

  updated_at: ColumnType<Date, Date | string | undefined, Date | string>;
}

export type Host = Selectable<HostTable>;

export type NewHost = Insertable<HostTable>;

export type HostUpdate = Updateable<HostTable>;