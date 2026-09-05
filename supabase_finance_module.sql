-- Finance module: accounts, transactions (income/expense/transfer), and
-- simple liabilities, feeding a computed balance sheet. Shared across BOTH
-- MAERSK and ELITE workspaces (one business, one set of bank accounts) — so
-- unlike jobs/invoices these tables have no "_nonmaersk" counterpart.

create table if not exists finance_accounts (
  id serial primary key,
  name text not null,
  type text not null default 'bank',
  "openingBalance" numeric not null default 0
);
alter table finance_accounts enable row level security;
create policy "finance_accounts_auth" on finance_accounts for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create table if not exists finance_transactions (
  id serial primary key,
  date date not null,
  "accountId" integer references finance_accounts(id) on delete set null,
  type text not null, -- income | expense | transfer
  category text,
  description text,
  amount numeric not null default 0,
  source text not null default 'manual', -- manual | invoice (auto-booked)
  invoice text,
  workspace text,
  "transferToAccountId" integer references finance_accounts(id) on delete set null
);
alter table finance_transactions enable row level security;
create policy "finance_transactions_auth" on finance_transactions for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');

create table if not exists finance_liabilities (
  id serial primary key,
  name text not null,
  amount numeric not null default 0,
  notes text
);
alter table finance_liabilities enable row level security;
create policy "finance_liabilities_auth" on finance_liabilities for all
  using (auth.role() = 'authenticated') with check (auth.role() = 'authenticated');
