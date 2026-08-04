-- ============ NON-MAERSK TABLES ============
-- Mirrors the existing MAERSK schema (drivers, clients, job_types, rates, jobs,
-- job_options) but as a separate set of tables, suffixed "_nonmaersk", in the
-- SAME Supabase project. No seed data — these start empty.

CREATE TABLE drivers_nonmaersk (
  id SERIAL PRIMARY KEY,
  name TEXT,
  plate TEXT,
  "rateNote" TEXT,
  vehicle TEXT,
  phone TEXT,
  "driverId" BIGINT,
  active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE clients_nonmaersk (
  id SERIAL PRIMARY KEY,
  "hostName" TEXT,
  uid TEXT,
  "costCentre" TEXT,
  company TEXT,
  code TEXT
);

CREATE TABLE job_types_nonmaersk (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE rates_nonmaersk (
  id SERIAL PRIMARY KEY,
  "jobType" TEXT,
  "unitPrice" TEXT,
  "billingUnit" TEXT
);

CREATE TABLE jobs_nonmaersk (
  id SERIAL PRIMARY KEY,
  date DATE,
  invoice TEXT,
  driver TEXT,
  "jobType" TEXT,
  details TEXT,
  "startTime" TEXT,
  "endTime" TEXT,
  duration TEXT,
  qty INTEGER,
  "unitCost" NUMERIC,
  cost NUMERIC,
  "driverPayout" NUMERIC,
  "coyFund" NUMERIC,
  remarks TEXT,
  "paymentStatus" TEXT,
  "hostName" TEXT,
  company TEXT,
  uid TEXT,
  "costCentre" TEXT,
  vehicle TEXT
);

CREATE TABLE job_options_nonmaersk (
  id SERIAL PRIMARY KEY,
  job_id INTEGER NOT NULL REFERENCES jobs_nonmaersk(id) ON DELETE CASCADE,
  "optionType" TEXT,
  amount NUMERIC
);

-- ============ RLS ============
-- Same rules as the MAERSK tables: admin (authenticated) gets full CRUD;
-- the public quick-entry page (log.html) can insert jobs/options only;
-- the public find-and-edit page (update.html) can select/insert/update jobs
-- and options (delete on jobs stays admin-only; options can be removed).

ALTER TABLE drivers_nonmaersk ENABLE ROW LEVEL SECURITY;
CREATE POLICY "drivers_nonmaersk_auth" ON drivers_nonmaersk FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
GRANT SELECT (id, name, active) ON drivers_nonmaersk TO anon;
CREATE POLICY "drivers_nonmaersk_anon_read_name" ON drivers_nonmaersk FOR SELECT TO anon USING (true);

ALTER TABLE clients_nonmaersk ENABLE ROW LEVEL SECURITY;
CREATE POLICY "clients_nonmaersk_auth" ON clients_nonmaersk FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
GRANT SELECT (id, "hostName", "costCentre", company, uid, code) ON clients_nonmaersk TO anon;
CREATE POLICY "clients_nonmaersk_anon_read_hostname" ON clients_nonmaersk FOR SELECT TO anon USING (true);

ALTER TABLE job_types_nonmaersk ENABLE ROW LEVEL SECURITY;
CREATE POLICY "job_types_nonmaersk_auth" ON job_types_nonmaersk FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

ALTER TABLE rates_nonmaersk ENABLE ROW LEVEL SECURITY;
CREATE POLICY "rates_nonmaersk_auth" ON rates_nonmaersk FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

ALTER TABLE jobs_nonmaersk ENABLE ROW LEVEL SECURITY;
CREATE POLICY "jobs_nonmaersk_auth" ON jobs_nonmaersk FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "jobs_nonmaersk_anon_insert" ON jobs_nonmaersk FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "jobs_nonmaersk_anon_select" ON jobs_nonmaersk FOR SELECT TO anon USING (true);
CREATE POLICY "jobs_nonmaersk_anon_update" ON jobs_nonmaersk FOR UPDATE TO anon USING (true) WITH CHECK (true);

ALTER TABLE job_options_nonmaersk ENABLE ROW LEVEL SECURITY;
CREATE POLICY "job_options_nonmaersk_auth" ON job_options_nonmaersk FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "job_options_nonmaersk_anon_insert" ON job_options_nonmaersk FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "job_options_nonmaersk_anon_select" ON job_options_nonmaersk FOR SELECT TO anon USING (true);
CREATE POLICY "job_options_nonmaersk_anon_update" ON job_options_nonmaersk FOR UPDATE TO anon USING (true) WITH CHECK (true);
CREATE POLICY "job_options_nonmaersk_anon_delete" ON job_options_nonmaersk FOR DELETE TO anon USING (true);
GRANT SELECT, INSERT, UPDATE, DELETE ON job_options_nonmaersk TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON job_options_nonmaersk TO anon;
GRANT USAGE, SELECT ON SEQUENCE job_options_nonmaersk_id_seq TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE job_options_nonmaersk_id_seq TO anon;
