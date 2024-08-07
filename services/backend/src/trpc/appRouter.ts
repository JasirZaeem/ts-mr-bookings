import { citext } from "@bookings/schema";
import { z } from "zod";
import { getEventsByUsername } from "../services/event.js";
import { createCallerFactory, publicProcedure, router } from "./trpc.js";

export const appRouter = router({
	ping: publicProcedure.output(String).query(() => "pong"),
	getEvents: publicProcedure
		.input(
			z.object({
				username: citext,
			}),
		)
		.query(async ({ ctx, input }) => {
			return await getEventsByUsername(ctx, input.username);
		}),
});

export const createAppRouterCaller = createCallerFactory(appRouter);

export type AppRouter = typeof appRouter;
