import type { Database } from "@bookings/schema";
import { Kysely, PostgresDialect } from "kysely";
import { default as pg } from "pg";

const { Pool } = pg;

type ConnectionOptions = {
	host: string;
	port: number;
	user: string;
	password: string;
	database: string;
};

export function connectionOptionsToConnectionString(
	options: ConnectionOptions,
) {
	return `postgres://${options.user}:${options.password}@${options.host}:${options.port}/${options.database}`;
}

export function createKyselyDatabase(
	connectionString: string,
	maxConnections = 20,
) {
	const dialect = new PostgresDialect({
		pool: new Pool({
			connectionString,
			max: maxConnections,
		}),
	});

	return new Kysely<Database>({
		dialect,
	});
}

let _db: Kysely<Database> | undefined = undefined;

export function getServiceDatabase(connectionString: string) {
	if (_db) {
		return _db;
	}

	_db = createKyselyDatabase(connectionString);

	return _db;
}

export function changeServiceDatabase(database: Kysely<Database>) {
	_db = database;
}
