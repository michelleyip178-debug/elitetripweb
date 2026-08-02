-- Update RLS policies to require authentication

DROP POLICY "drivers_public" ON drivers;
CREATE POLICY "drivers_auth" ON drivers FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

DROP POLICY "clients_public" ON clients;
CREATE POLICY "clients_auth" ON clients FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

DROP POLICY "job_types_public" ON job_types;
CREATE POLICY "job_types_auth" ON job_types FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

DROP POLICY "rates_public" ON rates;
CREATE POLICY "rates_auth" ON rates FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');

DROP POLICY "jobs_public" ON jobs;
CREATE POLICY "jobs_auth" ON jobs FOR ALL USING (auth.role() = 'authenticated') WITH CHECK (auth.role() = 'authenticated');
