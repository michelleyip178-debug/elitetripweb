-- Manual "Hitpay Admin Fee" field on jobs (ELITE and MAERSK). Deducted from Company Fund.
alter table jobs_nonmaersk add column if not exists "hitpayFee" numeric;
alter table jobs add column if not exists "hitpayFee" numeric;
