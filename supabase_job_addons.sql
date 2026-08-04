-- Additional Options tied to a job — a repeatable list where each row picks
-- one of the existing Job Type entries (e.g. Additional Stop, Waiting Charge,
-- Miscellaneous) plus an amount, and rolls into the job's Total Cost.

CREATE TABLE job_options (
  id SERIAL PRIMARY KEY,
  job_id INTEGER NOT NULL REFERENCES jobs(id) ON DELETE CASCADE,
  "optionType" TEXT,
  amount NUMERIC
);

ALTER TABLE job_options ENABLE ROW LEVEL SECURITY;

-- Dashboard (logged-in admin): full CRUD.
CREATE POLICY "job_options_auth" ON job_options FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

-- log.html (public quick-entry, no login): can add options when submitting a new trip.
CREATE POLICY "job_options_anon_insert" ON job_options FOR INSERT TO anon WITH CHECK (true);

-- update.html (public find-and-edit, no login): can view/add/edit/remove options
-- on any job, matching the same trade-off already accepted for the jobs table there.
CREATE POLICY "job_options_anon_select" ON job_options FOR SELECT TO anon USING (true);
CREATE POLICY "job_options_anon_update" ON job_options FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "job_options_anon_delete" ON job_options FOR DELETE TO anon USING (true);
