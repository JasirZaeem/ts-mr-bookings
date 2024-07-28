import Router from "@koa/router";
import Koa from "koa";
import KoaLogger from "koa-logger";
import { createKoaMiddleware } from "trpc-koa-adapter";
import { appRouter } from "./trpc/appRouter.js";
import { createInnerContext } from "./trpc/trpc.js";

const app = new Koa();
app.use(KoaLogger());

const router = new Router();
router.get("/ping", async (ctx) => {
	ctx.body = "pong";
});

app.use(router.routes());
app.use(router.allowedMethods());

const adapter = createKoaMiddleware({
	router: appRouter,
	createContext: createInnerContext,
	prefix: "/trpc",
});

app.use(adapter);

app.listen(3000, () => console.log("Server is running on port 3000"));
