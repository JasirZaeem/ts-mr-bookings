--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Postgres.app)
-- Dumped by pg_dump version 16.3 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: bookings; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA bookings;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: moddatetime; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS moddatetime WITH SCHEMA extensions;


--
-- Name: EXTENSION moddatetime; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION moddatetime IS 'functions for tracking last modification time';


--
-- Name: email; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.email AS public.citext
	CONSTRAINT email_check CHECK ((VALUE OPERATOR(public.~) '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::public.citext));


--
-- Name: DOMAIN email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON DOMAIN public.email IS 'Email address, case-insensitive, and based on the HTML5 spec';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: user; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth."user" (
    id integer NOT NULL,
    username public.citext NOT NULL,
    email public.email NOT NULL,
    password text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: COLUMN "user".username; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth."user".username IS 'A unique, case-insensitive identifier for the user.';


--
-- Name: COLUMN "user".email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth."user".email IS 'Email address for the user, case-insensitive, based on the HTML5 spec, and unique.';


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

ALTER TABLE auth."user" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME auth.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: booking; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.booking (
    id integer NOT NULL,
    host_id integer NOT NULL,
    event_id integer NOT NULL,
    invitee_id integer NOT NULL,
    invitee_note text,
    duration tstzrange NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: COLUMN booking.duration; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.booking.duration IS 'The time range for the booking, mutually exclusive for the host.';


--
-- Name: booking_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

ALTER TABLE bookings.booking ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bookings.booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: event; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.event (
    id integer NOT NULL,
    host_id integer NOT NULL,
    slug public.citext NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: COLUMN event.slug; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON COLUMN bookings.event.slug IS 'A unique, case-insensitive identifier for the event.';


--
-- Name: event_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

ALTER TABLE bookings.event ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bookings.event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: host; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.host (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: host_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

ALTER TABLE bookings.host ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bookings.host_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: invitee; Type: TABLE; Schema: bookings; Owner: -
--

CREATE TABLE bookings.invitee (
    id integer NOT NULL,
    event_id integer NOT NULL,
    name text NOT NULL,
    email public.email NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: invitee_id_seq; Type: SEQUENCE; Schema: bookings; Owner: -
--

ALTER TABLE bookings.invitee ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bookings.invitee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: booking booking_host_id_duration_excl; Type: CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.booking
    ADD CONSTRAINT booking_host_id_duration_excl EXCLUDE USING gist (host_id WITH =, duration WITH &&);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (id);


--
-- Name: event event_host_id_slug_key; Type: CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.event
    ADD CONSTRAINT event_host_id_slug_key UNIQUE (host_id, slug);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: host host_pkey; Type: CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.host
    ADD CONSTRAINT host_pkey PRIMARY KEY (id);


--
-- Name: invitee invitee_pkey; Type: CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.invitee
    ADD CONSTRAINT invitee_pkey PRIMARY KEY (id);


--
-- Name: booking_event_id_idx; Type: INDEX; Schema: bookings; Owner: -
--

CREATE INDEX booking_event_id_idx ON bookings.booking USING btree (event_id);


--
-- Name: INDEX booking_event_id_idx; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON INDEX bookings.booking_event_id_idx IS 'Index for the event_id column to search for bookings by event.';


--
-- Name: booking_host_id_idx; Type: INDEX; Schema: bookings; Owner: -
--

CREATE INDEX booking_host_id_idx ON bookings.booking USING btree (host_id);


--
-- Name: INDEX booking_host_id_idx; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON INDEX bookings.booking_host_id_idx IS 'Index for the host_id column to search for bookings by host.';


--
-- Name: booking_invitee_id_idx; Type: INDEX; Schema: bookings; Owner: -
--

CREATE INDEX booking_invitee_id_idx ON bookings.booking USING btree (invitee_id);


--
-- Name: INDEX booking_invitee_id_idx; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON INDEX bookings.booking_invitee_id_idx IS 'Index for the invitee_id column to search for bookings by invitee.';


--
-- Name: event_host_id_idx; Type: INDEX; Schema: bookings; Owner: -
--

CREATE INDEX event_host_id_idx ON bookings.event USING btree (host_id);


--
-- Name: INDEX event_host_id_idx; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON INDEX bookings.event_host_id_idx IS 'Index for the host_id column to search for events by host.';


--
-- Name: invitee_event_id_idx; Type: INDEX; Schema: bookings; Owner: -
--

CREATE INDEX invitee_event_id_idx ON bookings.invitee USING btree (event_id);


--
-- Name: INDEX invitee_event_id_idx; Type: COMMENT; Schema: bookings; Owner: -
--

COMMENT ON INDEX bookings.invitee_event_id_idx IS 'Index for the event_id column to search for invitees by event.';


--
-- Name: user user_updated_at; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER user_updated_at BEFORE UPDATE ON auth."user" FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');


--
-- Name: booking booking_updated_at; Type: TRIGGER; Schema: bookings; Owner: -
--

CREATE TRIGGER booking_updated_at BEFORE UPDATE ON bookings.booking FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');


--
-- Name: event event_updated_at; Type: TRIGGER; Schema: bookings; Owner: -
--

CREATE TRIGGER event_updated_at BEFORE UPDATE ON bookings.event FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');


--
-- Name: host host_updated_at; Type: TRIGGER; Schema: bookings; Owner: -
--

CREATE TRIGGER host_updated_at BEFORE UPDATE ON bookings.host FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');


--
-- Name: invitee invitee_updated_at; Type: TRIGGER; Schema: bookings; Owner: -
--

CREATE TRIGGER invitee_updated_at BEFORE UPDATE ON bookings.invitee FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updated_at');


--
-- Name: booking booking_event_id_fkey; Type: FK CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.booking
    ADD CONSTRAINT booking_event_id_fkey FOREIGN KEY (event_id) REFERENCES bookings.event(id);


--
-- Name: booking booking_host_id_fkey; Type: FK CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.booking
    ADD CONSTRAINT booking_host_id_fkey FOREIGN KEY (host_id) REFERENCES bookings.host(id);


--
-- Name: booking booking_invitee_id_fkey; Type: FK CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.booking
    ADD CONSTRAINT booking_invitee_id_fkey FOREIGN KEY (invitee_id) REFERENCES bookings.invitee(id);


--
-- Name: event event_host_id_fkey; Type: FK CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.event
    ADD CONSTRAINT event_host_id_fkey FOREIGN KEY (host_id) REFERENCES bookings.host(id);


--
-- Name: host host_user_id_fkey; Type: FK CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.host
    ADD CONSTRAINT host_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth."user"(id);


--
-- Name: invitee invitee_event_id_fkey; Type: FK CONSTRAINT; Schema: bookings; Owner: -
--

ALTER TABLE ONLY bookings.invitee
    ADD CONSTRAINT invitee_event_id_fkey FOREIGN KEY (event_id) REFERENCES bookings.event(id);


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA extensions TO PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: extensions; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA extensions GRANT ALL ON TYPES TO PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO PUBLIC;


--
-- PostgreSQL database dump complete
--

