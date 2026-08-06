-- Normalize existing payment status values to uppercase so "Paid"/"paid"/"PAID"
-- are treated as the same status everywhere (dropdowns, filters, summaries).
UPDATE jobs SET "paymentStatus" = UPPER("paymentStatus") WHERE "paymentStatus" IS NOT NULL;
UPDATE jobs_nonmaersk SET "paymentStatus" = UPPER("paymentStatus") WHERE "paymentStatus" IS NOT NULL;
