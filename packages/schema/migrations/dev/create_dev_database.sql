CREATE DATABASE bookings;

-- Shadow database for graphile-migrate
CREATE DATABASE bookings_shadow;

CREATE ROLE bookings WITH LOGIN PASSWORD 'password';

ALTER DATABASE bookings OWNER TO bookings;

ALTER DATABASE bookings_shadow OWNER TO bookings;
