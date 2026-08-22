-- Per-invoice tracking (due date, payment date), separate from the
-- per-job "jobs" tables since many jobs can share one invoice number.
create table if not exists invoice_meta (
  id serial primary key,
  invoice text unique not null,
  "dueDate" date,
  "paymentDate" date
);
alter table invoice_meta enable row level security;
create policy "invoice_meta_auth" on invoice_meta for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create table if not exists invoice_meta_nonmaersk (
  id serial primary key,
  invoice text unique not null,
  "dueDate" date,
  "paymentDate" date
);
alter table invoice_meta_nonmaersk enable row level security;
create policy "invoice_meta_nonmaersk_auth" on invoice_meta_nonmaersk for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
