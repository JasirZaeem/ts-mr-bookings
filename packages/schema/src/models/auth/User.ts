import type { z } from 'zod';
import type { userId, Citext, Email } from '../../types.js';
import type { ColumnType, Selectable, Insertable, Updateable } from 'kysely';

/** Identifier type for user */
export type UserId = z.infer<typeof userId>;

/** Represents the table auth.user */
export default interface UserTable {
  id: ColumnType<UserId, never, never>;

  /** A unique, case-insensitive identifier for the user. */
  username: ColumnType<Citext, Citext, Citext>;

  /** Email address for the user, case-insensitive, based on the HTML5 spec, and unique. */
  email: ColumnType<Email, Email, Email>;

  password: ColumnType<string, string, string>;

  created_at: ColumnType<Date, Date | string | undefined, Date | string>;

  updated_at: ColumnType<Date, Date | string | undefined, Date | string>;
}

export type User = Selectable<UserTable>;

export type NewUser = Insertable<UserTable>;

export type UserUpdate = Updateable<UserTable>;