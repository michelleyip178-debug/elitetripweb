-- Adds a free-text "note" field to additional options, used to describe
-- what a MISCELLANEOUS line item actually is (e.g. "Museum tickets").
alter table job_options add column if not exists note text;
alter table job_options_nonmaersk add column if not exists note text;
