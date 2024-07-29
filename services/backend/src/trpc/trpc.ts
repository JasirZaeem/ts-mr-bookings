import type { Database } from "@bookings/schema";
import { initTRPC } from "@trpc/server";
import type { Kysely } from "kysely";
import SuperJSON from "superjson";

export function createInnerContext(db: Kysely<Database>) {
	return {
		db,
	};
}

export type InnerContext = ReturnType<typeof createInnerContext>;

const t = initTRPC.context<typeof createInnerContext>().create({
	transformer: SuperJSON,
});

export const router = t.router;
export const mergeRouters = t.mergeRouters;
export const publicProcedure = t.procedure;
export const middleware = t.middleware;
export const createCallerFactory = t.createCallerFactory;
