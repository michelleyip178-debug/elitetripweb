-- Widen the public quick-entry pages' client data access beyond just hostName,
-- so selecting a host can also autofill/save Cost Centre, Company, and UID.
-- (RLS row policy "clients_anon_read_hostname" already allows all rows; this
-- just grants the additional columns.)
GRANT SELECT (id, "hostName", "costCentre", company, uid, code) ON clients TO anon;
