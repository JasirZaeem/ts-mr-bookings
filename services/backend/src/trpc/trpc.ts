import { initTRPC } from "@trpc/server";
import SuperJSON from "superjson";
import { db } from "../db.js";

export function createInnerContext() {
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
