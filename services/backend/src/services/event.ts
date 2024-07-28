import type { Citext } from "@bookings/schema";
import type { InnerContext } from "../trpc/trpc.js";

export async function getEventsByUsername(ctx: InnerContext, username: Citext) {
	return await ctx.db
		.selectFrom("bookings.event")
		.innerJoin("bookings.host", "bookings.host.id", "bookings.event.host_id")
		.innerJoin("auth.user", "auth.user.id", "bookings.host.user_id")
		.select([
			"bookings.event.id",
			"bookings.event.name",
			"bookings.event.description",
			"bookings.event.slug",
		])
		.where("auth.user.username", "=", username)
		.execute();
}
