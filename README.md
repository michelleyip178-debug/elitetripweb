# EliteSkyline — Job Log

A single-page web app for logging chauffeur/transport jobs (drivers, clients, invoices, payouts). Built as a static site — no backend, no build step, no login. Data persists in the browser's `localStorage`.

Originally built from `Job Log 2026.xlsx`, a spreadsheet used to track ~140 chauffeur jobs/month across drivers, clients, job types, and a rate card.

## Running it

Open `index.html` directly in a browser (double-click works — no server required). To develop with a local server instead:

```
python3 -m http.server 8000
# then visit http://localhost:8000
```

## File structure

- `index.html` — page structure/markup only
- `style.css` — all styling
- `data.js` — sets `window.SEED`, the seed dataset (drivers, clients, job types, rate card, and the original ~139 historical jobs imported from the spreadsheet)
- `app.js` — all application logic (rendering, filtering, the job form, rate/payout calculations, CSV export)

`app.js` reads `window.SEED` once on first load. All subsequent reads/writes go through `localStorage` under the key `eliteskyline_joblog_v1` — editing `data.js` after first load has no effect unless the user clears that storage key.

## Data model

Each **job** record (`DATA.jobs[]`) has:

```
id, date, invoice, driver, jobType, vehicle, hostName, company, costCentre,
details, startTime, endTime, qty, unitCost, cost, driverPayout, coyFund,
paymentStatus, remarks
```

Reference lists loaded from the spreadsheet, also in `DATA`:
- `drivers[]` — name, vehicle, plate, phone, payout rate note
- `clients[]` — host name, UID, cost centre, company, code
- `jobTypes[]` — the 25 generic job type labels used in the entry form dropdown
- `rates[]` — the 51-row rate card from the "QB Job Types" sheet (vehicle-specific pricing), shown read-only under the "Job Types & Rates" tab

## Business logic worth knowing

**Rate lookup (`RATE_MAP` in `app.js`).** The job-type dropdown (generic, e.g. "TRANSFER (LOCAL)") doesn't map 1:1 onto the rate card (vehicle-specific, e.g. "TRANSFER (LOCAL) - SALOON" vs "- MPV/ALPHARD"). `RATE_MAP` is a hand-built lookup translating each of the 25 job types into either a flat rate or a `{vehicle: price}` table. When a job type needing a vehicle-specific rate is selected, a Vehicle Type field appears; picking a vehicle fills in Unit Cost. A handful of job types (Additional Charge, Arrival - Drive Way Pick Up, Cancellation 25%, Disposal, Miscellaneous) have no rate on file in the original spreadsheet, so Unit Cost stays manual for those — this is the most likely place to need updates if the rate card changes.

**Hourly auto-quantity.** If the selected job type contains "HOURLY", entering Start/End time auto-computes Qty as the number of full hour-blocks, rounding up (e.g. 6h32m → 7). This matches how the original spreadsheet billed hourly jobs. Logic lives in `updateQtyFromTime()`.

**Auto-calculated totals.**
```
Total Cost     = Qty × Unit Cost
Driver Payout  = Total Cost − (Qty × S$10)   // company keeps $10 per billed unit
Company Fund   = Total Cost − Driver Payout
```
These three fields are read-only in the form; only Qty and Unit Cost are directly editable (`recalc()` in `app.js`). Note the $10-per-unit deduction is applied uniformly regardless of job type — for non-hourly jobs (e.g. per-stop, per-trip), "unit" means the Qty value for that job, not necessarily an hour. Worth revisiting if that's not the intended commission structure across all job types.

## Known limitations / natural next steps

- **No cross-device sync.** Data lives in one browser's localStorage. Exporting via the "Export CSV" button is the only backup path today. A real backend (or even just IndexedDB + manual export/import of JSON) would be the natural next step if this needs to work across devices.
- **No auth.** Fine for single-user local use; would need addressing before sharing with a team.
- **`RATE_MAP` is hand-authored**, not derived programmatically from the `rates[]` data — if the rate card changes, `RATE_MAP` in `app.js` needs manual updates to match.
- **No automated tests.** Sanity was verified manually (jsdom smoke tests during development) against the original spreadsheet totals (139 jobs / S$40,260 sales / S$33,007 payout / S$7,253 company fund) — worth re-checking after any change to the calculation logic.
- Driver payout rate notes (e.g. "0.9" or "120, 40/hr" in the Drivers list) are stored but not currently used in any calculation — the $10/unit deduction is applied uniformly instead. Left as-is per explicit request; flagging in case per-driver payout rates should eventually apply.
