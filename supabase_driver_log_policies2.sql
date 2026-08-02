-- Expose only client host names (not company/UID/cost centre) to anon,
-- so the driver quick-entry form can offer a Host Name dropdown.
GRANT SELECT ("hostName") ON clients TO anon;
CREATE POLICY "clients_anon_read_hostname" ON clients FOR SELECT TO anon USING (true);
