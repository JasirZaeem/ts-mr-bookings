import type { Database } from "@bookings/schema";
import { type Kysely, sql } from "kysely";
import { assert, type Suite, afterAll, beforeAll } from "vitest";
import { getTestRootDatabaseConfig } from "../config.js";
import {
	changeServiceDatabase,
	connectionOptionsToConnectionString,
	createKyselyDatabase,
} from "../db.js";

function getFullSuiteName(suite: Suite): string {
	if (!suite.suite) {
		return suite.name;
	}

	return `${getFullSuiteName(suite.suite)} ${suite.name}`;
}

/**
 * Creates a new test database for a test suite.
 * @param keepAfterTest Whether to keep the test database after the test suite
 * has run. Defaults to `false`.
 */
export function testDatabaseHook(
	keepAfterTest = false,
): () => Kysely<Database> {
	let db: Kysely<Database> | undefined = undefined;
	let templateDb: Kysely<Database> | undefined = undefined;
	let testDbName: string | undefined = undefined;

	beforeAll(async (suite) => {
		const startTime = performance.now();

		const templateDbName = "bookings_test_template";
		const templateDbConnectionString = connectionOptionsToConnectionString({
			...getTestRootDatabaseConfig(),
			database: templateDbName,
		});
		templateDb = createKyselyDatabase(templateDbConnectionString);

		const fullSuiteName = getFullSuiteName(suite);
		testDbName =
			`bookings_test_${fullSuiteName.replace(/\s/g, "_")}`.toLowerCase();

		await sql`DROP DATABASE IF EXISTS ${sql.raw(testDbName)}`.execute(
			templateDb,
		);
		await sql`CREATE DATABASE ${sql.raw(testDbName)} TEMPLATE ${sql.raw(
			templateDbName,
		)}`.execute(templateDb);

		const testDbConnectionString = connectionOptionsToConnectionString({
			...getTestRootDatabaseConfig(),
			database: testDbName,
		});

		const testDb = createKyselyDatabase(testDbConnectionString);

		const endTime = performance.now();
		console.log(
			`Created test database ${testDbName} in ${endTime - startTime}ms`,
		);

		changeServiceDatabase(testDb);

		db = testDb;
	});

	afterAll(async () => {
		assert(db !== undefined);
		assert(testDbName !== undefined);
		assert(templateDb !== undefined);
		await db.destroy();

		if (keepAfterTest) {
			console.info(`Keeping test database ${testDbName}`);
		} else {
			await sql`DROP DATABASE ${sql.raw(testDbName)}`.execute(templateDb);
		}

		await templateDb?.destroy();
	});

	return () => {
		assert(db !== undefined);
		return db;
	};
}
