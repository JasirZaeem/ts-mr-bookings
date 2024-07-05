import kanelKysely from "kanel-kysely";
import kanel from "kanel";

const outputPath = "./src/models";

// Relative import paths need explicit file extensions in ECMAScript imports when '--moduleResolution' is 'node16' or 'nodenext'.
export function convertESMPaths(_path, lines, _instantiatedConfig) {
	return lines.map((line) =>
		line.replace(/^import\stype\s.*'(.*)';$/, (match, p1) => {
			return /\sfrom\s'kysely';$/.test(match)
				? match
				: // Add explicit file extension to relative import paths.
					match.replace(p1, `${p1}.js`);
		}),
	);
}

/** @type {import("kanel").Config} */
const config = {
	// Database connection URL provided by graphile-migrate, cannot use
	// `DATABASE_URL` here as it is overwritten by graphile-migrate.
	connection: process.env.GM_DBURL,
	outputPath,
	schemas: ["auth"],
	resolveViews: true,
	preDeleteOutputFolder: true,
	enumStyle: "type",
	preRenderHooks: [kanelKysely.makeKyselyHook()],
	postRenderHooks: [convertESMPaths],
	customTypeMap: {
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
