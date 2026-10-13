-- Public, view-only invoice links for customers.
--
-- Each invoice can get a long random "shareToken" (stored on invoice_meta).
-- Anonymous visitors can't read any table directly; they can only call
-- get_shared_invoice(token, ws), which returns that ONE invoice's customer-facing
-- data. Internal figures (driver payout, company fund, payout to Alan, payment
-- status, other customers' rows) are deliberately NOT included.
-- Revoke a link by clearing its shareToken (the dashboard's "Revoke Link" button).

alter table invoice_meta add column if not exists "shareToken" text;
alter table invoice_meta_nonmaersk add column if not exists "shareToken" text;

create unique index if not exists invoice_meta_share_token_idx
  on invoice_meta ("shareToken") where "shareToken" is not null;
create unique index if not exists invoice_meta_nonmaersk_share_token_idx
  on invoice_meta_nonmaersk ("shareToken") where "shareToken" is not null;

create or replace function get_shared_invoice(p_token text, p_ws text default 'maersk')
returns json
language plpgsql
security definer
set search_path = public
as $$
declare
  sfx text := case when p_ws = 'nonmaersk' then '_nonmaersk' else '' end;
  v_inv text;
  v_company text;
  v_host text;
  result json;
begin
  -- Tokens are 64 hex chars; reject anything short so a guess can't match.
  if p_token is null or length(p_token) < 32 then
    return null;
  end if;

  execute format('select invoice from %I where "shareToken" = $1', 'invoice_meta' || sfx)
    into v_inv using p_token;
  if v_inv is null then
    return null;
  end if;

  execute format('select company, "hostName" from %I where invoice = $1 order by date, id limit 1', 'jobs' || sfx)
    into v_company, v_host using v_inv;

  execute format($f$
    select json_build_object(
      'invoice', $1::text,
      'meta', (select json_build_object('dateSent', m."dateSent", 'dueDate', m."dueDate")
               from %1$I m where m.invoice = $1),
      'jobs', coalesce((select json_agg(json_build_object(
                  'id', j.id, 'date', j.date, 'invoice', j.invoice, 'driver', j.driver,
                  'jobType', j."jobType", 'details', j.details, 'startTime', j."startTime",
                  'endTime', j."endTime", 'qty', j.qty, 'unitCost', j."unitCost", 'cost', j.cost,
                  'hostName', j."hostName", 'company', j.company, 'uid', j.uid,
                  'costCentre', j."costCentre", 'vehicle', j.vehicle) order by j.date, j.id)
                from %2$I j where j.invoice = $1), '[]'::json),
      'options', coalesce((select json_agg(json_build_object(
                  'id', o.id, 'job_id', o.job_id, 'optionType', o."optionType",
                  'amount', o.amount, 'note', o.note) order by o.id)
                from %3$I o where o.job_id in (select id from %2$I where invoice = $1)), '[]'::json),
      'drivers', coalesce((select json_agg(json_build_object('name', d.name, 'plate', d.plate))
                from %4$I d where d.name in (select driver from %2$I where invoice = $1)), '[]'::json),
      'clients', coalesce((select json_agg(json_build_object(
                  'company', c.company, 'billingAddress', c."billingAddress", 'uen', c.uen))
                from %5$I c
                where case when trim(coalesce($2, '')) <> ''
                           then upper(trim(c.company)) = upper(trim($2))
                           else trim(coalesce($3, '')) <> ''
                                and upper(trim(c."hostName")) = upper(trim($3))
                      end), '[]'::json)
    )$f$,
    'invoice_meta' || sfx, 'jobs' || sfx, 'job_options' || sfx, 'drivers' || sfx, 'clients' || sfx)
  into result using v_inv, v_company, v_host;

  return result;
end;
$$;

revoke all on function get_shared_invoice(text, text) from public;
grant execute on function get_shared_invoice(text, text) to anon, authenticated;
