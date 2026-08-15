-- Billing details needed on the client-facing invoice document (invoice.html),
-- which the original clients table (hostName/uid/costCentre/company/code) doesn't carry.

ALTER TABLE clients ADD COLUMN "billingAddress" TEXT;
ALTER TABLE clients ADD COLUMN uen TEXT;

ALTER TABLE clients_nonmaersk ADD COLUMN "billingAddress" TEXT;
ALTER TABLE clients_nonmaersk ADD COLUMN uen TEXT;
