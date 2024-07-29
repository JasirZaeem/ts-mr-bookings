import * as path from "node:path";
import type { Database } from "@bookings/schema";
import { migrate } from "graphile-migrate";
import { Kysely, PostgresDialect, sql } from "kysely";
import { default as pg } from "pg";

const { Pool } = pg;

type DatabaseConnectionParams = {
	user: string;
	password: string;
	host: string;
	port: number;
	database: string;
};

function createKysely(dbConnectionParams: DatabaseConnectionParams) {
	const dialect = new PostgresDialect({
		pool: new Pool({
			...dbConnectionParams,
			max: 20,
		}),
	});

	return new Kysely<Database>({
		dialect,
	});
}

const dirname = new URL(".", import.meta.url).pathname;

const templateDatabaseName = "bookings_test_template";

const migrationsFolder = path.resolve(dirname, "..", "migrations");

/**
 * Create a postgres database that will be used as a template database to
 * create test databases from.
 */
export const createTemplateTestDatabase = async (
	rootDatabaseConnectionParams: DatabaseConnectionParams,
) => {
	const startTime = performance.now();

	const rootDb = createKysely(rootDatabaseConnectionParams);
	await sql`DROP DATABASE IF EXISTS ${sql.raw(templateDatabaseName)};`.execute(
		rootDb,
	);
	await sql`CREATE DATABASE ${sql.raw(templateDatabaseName)};`.execute(rootDb);

	await rootDb.destroy();

	const templateDbConnectionString = `postgres://${rootDatabaseConnectionParams.user}:${rootDatabaseConnectionParams.password}@${rootDatabaseConnectionParams.host}:${rootDatabaseConnectionParams.port}/${templateDatabaseName}`;

	await migrate({
		connectionString: templateDbConnectionString,
		migrationsFolder: migrationsFolder,
		beforeAllMigrations: [
			{
				_: "sql",
				// This is relative to the migrations folder
				file: "dev/install_extensions.sql",
			},
		],
	});

	const endTime = performance.now();
	console.info(`Template test database created in ${endTime - startTime}ms`);
};
