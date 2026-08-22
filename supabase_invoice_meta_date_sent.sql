-- Tracks when an invoice was actually sent to the client. The due date on
-- Invoice Tracking is now computed as 30 working days from this date, instead
-- of 30 calendar days from the job date.
alter table invoice_meta add column if not exists "dateSent" date;
alter table invoice_meta_nonmaersk add column if not exists "dateSent" date;
