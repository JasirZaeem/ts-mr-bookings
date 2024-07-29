import process from "node:process";
import { z } from "zod";

export const databaseConnectionString = z
	.string()
	.parse(process.env.DATABASE_URL);

export function getTestRootDatabaseConfig() {
	return z
		.object({
			TEST_ROOT_DATABASE_USER: z.string(),
			TEST_ROOT_DATABASE_PASSWORD: z.string(),
			TEST_DATABASE_HOST: z.string(),
			TEST_DATABASE_PORT: z.string().transform((v) => Number.parseInt(v, 10)),
			TEST_ROOT_DATABASE_NAME: z.string(),
		})
		.transform((v) => ({
			user: v.TEST_ROOT_DATABASE_USER,
			password: v.TEST_ROOT_DATABASE_PASSWORD,
			host: v.TEST_DATABASE_HOST,
			port: v.TEST_DATABASE_PORT,
			database: v.TEST_ROOT_DATABASE_NAME,
		}))
		.parse(process.env);
}
