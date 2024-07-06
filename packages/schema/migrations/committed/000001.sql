--! Previous: -
--! Hash: sha1:f427eafc0cb9e13ef25f40ea5d3eea2f20bca5cb

-- Initial migration

-- To store email addresses in a case-insensitive manner.
CREATE EXTENSION IF NOT EXISTS citext SCHEMA public;

DROP DOMAIN IF EXISTS public.email CASCADE;

-- https://html.spec.whatwg.org/multipage/input.html#email-state-(type=email)
CREATE DOMAIN email AS citext CHECK (
	value ~
	'^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
	);

COMMENT ON DOMAIN email IS 'Email address, case-insensitive, and based on the HTML5 spec';

-- The schema for auth.
DROP SCHEMA IF EXISTS auth CASCADE;

CREATE SCHEMA auth;

DROP TABLE IF EXISTS auth.user CASCADE;

CREATE TABLE auth.user
(
	id         int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

	username   citext UNIQUE NOT NULL,
	email      email UNIQUE  NOT NULL,
	password   TEXT          NOT NULL,

	created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON COLUMN auth.user.username IS 'A unique, case-insensitive identifier for the user.';
COMMENT ON COLUMN auth.user.email IS 'Email address for the user, case-insensitive, based on the HTML5 spec, and unique.';

CREATE OR REPLACE TRIGGER user_updated_at
	BEFORE UPDATE
	ON auth.user
	FOR EACH ROW
EXECUTE PROCEDURE extensions.moddatetime(updated_at);

-- The schema for bookings (domain-specific) data.
DROP SCHEMA IF EXISTS bookings CASCADE;

CREATE SCHEMA bookings;

-- Host table
DROP TABLE IF EXISTS bookings.host CASCADE;

CREATE TABLE bookings.host
(
	id         int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id    int         NOT NULL REFERENCES auth.user (id),

	name       TEXT        NOT NULL,

	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE TRIGGER host_updated_at
	BEFORE UPDATE
	ON bookings.host
	FOR EACH ROW
EXECUTE PROCEDURE extensions.moddatetime(updated_at);

-- Event table
DROP TABLE IF EXISTS bookings.event CASCADE;

CREATE TABLE bookings.event
(
	id          int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	host_id     int         NOT NULL REFERENCES bookings.host (id),

	slug        citext      NOT NULL,
	name        TEXT        NOT NULL,
	description TEXT        NOT NULL,

	created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	UNIQUE (host_id, slug)
);

COMMENT ON COLUMN bookings.event.slug IS 'A unique, case-insensitive identifier for the event.';

CREATE INDEX event_host_id_idx ON bookings.event (host_id);
COMMENT ON INDEX bookings.event_host_id_idx IS 'Index for the host_id column to search for events by host.';

CREATE OR REPLACE TRIGGER event_updated_at
	BEFORE UPDATE
	ON bookings.event
	FOR EACH ROW
EXECUTE PROCEDURE extensions.moddatetime(updated_at);

-- Invitee table
DROP TABLE IF EXISTS bookings.invitee CASCADE;

CREATE TABLE bookings.invitee
(
	id         int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	event_id   int         NOT NULL REFERENCES bookings.event (id),

	name       TEXT        NOT NULL,
	email      email       NOT NULL,

	created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX invitee_event_id_idx ON bookings.invitee (event_id);
COMMENT ON INDEX bookings.invitee_event_id_idx IS 'Index for the event_id column to search for invitees by event.';

CREATE OR REPLACE TRIGGER invitee_updated_at
	BEFORE UPDATE
	ON bookings.invitee
	FOR EACH ROW
EXECUTE PROCEDURE extensions.moddatetime(updated_at);

-- Booking table
CREATE EXTENSION IF NOT EXISTS btree_gist SCHEMA public;

DROP TABLE IF EXISTS bookings.booking CASCADE;

CREATE TABLE bookings.booking
(
	id           int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	host_id      int         NOT NULL REFERENCES bookings.host (id),
	event_id     int         NOT NULL REFERENCES bookings.event (id),
	invitee_id   int         NOT NULL REFERENCES bookings.invitee (id),

	invitee_note TEXT,

	duration     tstzrange   NOT NULL,

	created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
	updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),

	-- Ensure that a host has mutually exclusive bookings.
	EXCLUDE USING gist (host_id WITH =, duration WITH &&)
);

COMMENT ON COLUMN booking.duration IS 'The time range for the booking, mutually exclusive for the host.';

CREATE INDEX booking_host_id_idx ON bookings.booking (host_id);
COMMENT ON INDEX bookings.booking_host_id_idx IS 'Index for the host_id column to search for bookings by host.';
CREATE INDEX booking_event_id_idx ON bookings.booking (event_id);
COMMENT ON INDEX bookings.booking_event_id_idx IS 'Index for the event_id column to search for bookings by event.';
CREATE INDEX booking_invitee_id_idx ON bookings.booking (invitee_id);
COMMENT ON INDEX bookings.booking_invitee_id_idx IS 'Index for the invitee_id column to search for bookings by invitee.';

CREATE OR REPLACE TRIGGER booking_updated_at
	BEFORE UPDATE
	ON bookings.booking
	FOR EACH ROW
EXECUTE PROCEDURE extensions.moddatetime(updated_at);
