import type { default as AuthSchema } from './auth/AuthSchema.js';
import type { default as BookingsSchema } from './bookings/BookingsSchema.js';

type Database = AuthSchema & BookingsSchema;

export default Database;