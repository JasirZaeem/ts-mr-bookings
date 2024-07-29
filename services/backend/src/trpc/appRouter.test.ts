import { describe, expect, it } from "vitest";

import { testDatabaseHook } from "../testHelpers/testDatabaseHook.js";
import { createAppRouterCaller } from "./appRouter.js";
import { createInnerContext } from "./trpc.js";

describe("appRouter", () => {
	const getDb = testDatabaseHook(true);
	const createCaller = () => createAppRouterCaller(createInnerContext(getDb()));

	it("should return 'pong' when calling ping", async () => {
		const caller = createCaller();

		const result = await caller.ping();
		expect(result).toBe("pong");
	});

	it("should return the events for a user", async () => {
		const caller = createCaller();

		const result = await caller.getEvents({ username: "test_user" });
		expect(result).toMatchObject([]);
	});
});
