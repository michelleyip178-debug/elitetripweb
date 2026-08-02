-- Allow the public "Update Trip" page to let drivers find and edit an
-- existing job without logging in. Accepted trade-off: any driver with the
-- link can read and edit ANY job's data (including cost/payout figures),
-- since there is no per-driver authentication. Delete stays admin-only.

CREATE POLICY "jobs_anon_select" ON jobs FOR SELECT TO anon USING (true);
CREATE POLICY "jobs_anon_update" ON jobs FOR UPDATE TO anon USING (true) WITH CHECK (true);
