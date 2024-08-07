CREATE SCHEMA IF NOT EXISTS extensions;

GRANT usage ON SCHEMA extensions TO public;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA extensions TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT EXECUTE ON FUNCTIONS TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT USAGE ON TYPES TO public;

-- Used to updated the updated_at columns on every update.
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
