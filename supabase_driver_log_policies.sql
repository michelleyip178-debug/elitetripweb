-- Allow the public quick-entry page (log.html) to work without a login.
-- Scope is intentionally narrow:
--   - anon can INSERT new rows into jobs (submit a trip) but cannot SELECT, UPDATE, or DELETE
--   - anon can only see driver NAMES (not phone/plate) via a column-level grant
--   - job_types has no sensitive data, so it's fully readable

-- Drivers: expose only id + name to anon (hide phone, plate, rateNote, driverId)
GRANT SELECT (id, name) ON drivers TO anon;
CREATE POLICY "drivers_anon_read_name" ON drivers FOR SELECT TO anon USING (true);

-- Jobs: anon can insert only, never read/update/delete
CREATE POLICY "jobs_anon_insert" ON jobs FOR INSERT TO anon WITH CHECK (true);
