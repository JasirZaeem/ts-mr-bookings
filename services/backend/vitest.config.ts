import { defineConfig } from "vitest/config";

export default defineConfig({
	test: {
		sequence: { hooks: "stack" },
		globalSetup: ["src/testHelpers/globalSetup.ts"],
	},
});
