import type { Database } from "@bookings/schema";
import { Kysely, PostgresDialect } from "kysely";
import { default as pg } from "pg";

const { Pool } = pg;
const dialect = new PostgresDialect({
	pool: new Pool({
		connectionString: process.env.DATABASE_URL,
		max: 20,
	}),
});

export const db = new Kysely<Database>({
	dialect,
});
