export * from "./types.js";
export type * from "./models/auth/User.js";
export type * from "./models/bookings/Booking.js";
export type * from "./models/bookings/Event.js";
export type * from "./models/bookings/Host.js";
export type * from "./models/bookings/Invitee.js";
export type * from "./models/Database.js";

import type UserTable from "./models/auth/User.js";
import type BookingTable from "./models/bookings/Booking.js";
import type EventTable from "./models/bookings/Event.js";
import type HostTable from "./models/bookings/Host.js";
import type InviteeTable from "./models/bookings/Invitee.js";
import type { default as GeneratedDatabase } from "./models/Database.js";

export interface Database extends GeneratedDatabase {
	"bookings.host": HostTable;
	"bookings.event": EventTable;
	"bookings.invitee": InviteeTable;
	"bookings.booking": BookingTable;
	"auth.user": UserTable;
}

export type Username = UserTable["username"];
