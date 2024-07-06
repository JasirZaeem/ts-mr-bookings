import type { default as HostTable } from './Host.js';
import type { default as EventTable } from './Event.js';
import type { default as InviteeTable } from './Invitee.js';
import type { default as BookingTable } from './Booking.js';

export default interface BookingsSchema {
  host: HostTable;

  event: EventTable;

  invitee: InviteeTable;

  booking: BookingTable;
}