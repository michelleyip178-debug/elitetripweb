-- Manual "Payout to Alan" field for ELITE jobs only (not derived/calculated).
alter table jobs_nonmaersk add column if not exists "payoutAlan" numeric;
