import kanel from "kanel";
import kanelKysely from "kanel-kysely";

const outputPath = "./src/models";

// Relative import paths need explicit file extensions in ECMAScript imports when '--moduleResolution' is 'node16' or 'nodenext'.
export function convertESMPaths(_path, lines, _instantiatedConfig) {
	return lines.map((line) =>
		line.replace(/^import\stype\s.*'(.*)';$/, (match, p1) => {
			if (p1 === "kysely" || p1 === "zod") return match;
			return match.replace(p1, `${p1}.js`);
		}),
	);
}

function snakeToPascalCase(snakeCase) {
	return snakeCase
		.split("_")
		.map((word) => word.charAt(0).toUpperCase() + word.slice(1))
		.join("");
}

function snakeToCamelCase(snakeCase) {
	return snakeCase.replace(/(_\w)/g, (match) => match[1].toUpperCase());
}

/** @type {import("kanel").Config} */
const config = {
	// Database connection URL provided by graphile-migrate, cannot use
	// `DATABASE_URL` here as it is overwritten by graphile-migrate.
	connection: process.env.GM_DBURL,
	outputPath,
	schemas: ["auth", "bookings"],
	resolveViews: true,
	preDeleteOutputFolder: true,
	enumStyle: "type",
	preRenderHooks: [kanelKysely.makeKyselyHook()],
	postRenderHooks: [convertESMPaths],
	generateIdentifierType: (column, details) => {
		const name =
			snakeToPascalCase(details.name) + snakeToPascalCase(column.name);
		const validatorName =
			snakeToCamelCase(details.name) + snakeToPascalCase(column.name);

		return {
			declarationType: "typeDeclaration",
			name,
			exportAs: "named",
			typeDefinition: [`z.infer<typeof ${validatorName}>`],
			comment: [`Identifier type for ${details.name}`],
			typeImports: [
				{
					name: "z",
					isDefault: false,
					isAbsolute: true,
					importAsType: true,
					path: "zod",
				},
				{
					name: validatorName,
					isDefault: false,
					isAbsolute: false,
					importAsType: true,
					path: "./src/types",
				},
			],
		};
	},
	customTypeMap: {
		"public.citext": {
			name: "Citext",
			typeImports: [
				{
					name: "Citext",
					isDefault: false,
					isAbsolute: false,
					importAsType: true,
					path: "./src/types",
				},
			],
		},
		"public.email": {
			name: "Email",
			typeImports: [
				{
					name: "Email",
					isDefault: false,
					isAbsolute: false,
					importAsType: true,
					path: "./src/types",
				},
			],
		},
	},
};

(async () => {
	await kanel.processDatabase(config);
})().catch((err) => {
	console.error(err);
	throw err;
});
