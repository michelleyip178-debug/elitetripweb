-- Soft-delete support for drivers: deactivating a driver hides them from
-- new-entry dropdowns and the default Drivers list, but keeps their name
-- intact on every past job/invoice record (driver is stored as free text,
-- not a foreign key, so nothing else is affected).
ALTER TABLE drivers ADD COLUMN active BOOLEAN NOT NULL DEFAULT true;

-- The public quick-entry pages (log.html, update.html) only had column-level
-- access to id+name on drivers; widen that to include active so they can
-- filter dropdowns to active drivers only.
GRANT SELECT (id, name, active) ON drivers TO anon;
