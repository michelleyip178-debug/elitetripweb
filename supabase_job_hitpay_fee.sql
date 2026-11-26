-- Manual "Hitpay Admin Fee" field for ELITE jobs only. Deducted from Company Fund.
alter table jobs_nonmaersk add column if not exists "hitpayFee" numeric;
