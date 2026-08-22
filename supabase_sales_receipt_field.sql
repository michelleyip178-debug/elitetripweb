-- Sales receipt number, assigned on demand after payment (separate numbering
-- series from "invoice" — ESR/MSR prefix, resets monthly). Nullable: most jobs
-- never get one unless the customer specifically asks for a receipt.
alter table jobs add column if not exists "salesReceipt" text;
alter table jobs_nonmaersk add column if not exists "salesReceipt" text;
