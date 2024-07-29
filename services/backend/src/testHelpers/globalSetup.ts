import { createTemplateTestDatabase } from "@bookings/schema";
import { getTestRootDatabaseConfig } from "../config.js";

export async function setup() {
	await createTemplateTestDatabase(getTestRootDatabaseConfig());
}
