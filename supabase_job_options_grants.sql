-- Explicit table-level grants for job_options, in case the DELETE on jobs is
-- silently failing to cascade because authenticated/anon lack DELETE grant
-- on this newer table (RLS policies alone aren't enough without the grant).

GRANT SELECT, INSERT, UPDATE, DELETE ON job_options TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON job_options TO anon;
GRANT USAGE, SELECT ON SEQUENCE job_options_id_seq TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE job_options_id_seq TO anon;
