-- Tracks whether a job's invoice request came from SINADM, so the MAERSK
-- Summary can be filtered/exported to only those records.
alter table jobs add column if not exists "sentFromSinadm" boolean default false;
alter table jobs_nonmaersk add column if not exists "sentFromSinadm" boolean default false;
