-- Link the confidently-matched bank transactions to their invoice/job,
-- detected by exact amount + payment-after-job-date proximity.
-- Matched via amount equality (income vs invoice total; driver payout vs job.driverPayout)
-- and a plausible payment lag (income: 0-150 days after job date; driver payout: 0-60 days).
-- This does not change category or amount -- only links invoice + workspace for traceability.
-- Safe to re-run.

update finance_transactions t
set invoice = v.invoice, workspace = v.workspace
from (values
  ('2026-03-05', 'INTERBANK GIRO M/S MAERSK SINGAPORE PTE LTD 8100068426 INVOICE PAYMENT', 990.0::numeric, 'MINV2026010003', 'maersk'),
  ('2026-04-08', 'INTERBANK GIRO MAERSK LOGISTICS & SERVICES S P LTD 8141000825 SUPP-260408161750GI203699', 630.0::numeric, 'MINV2026030001', 'maersk'),
  ('2026-06-17', 'INTERBANK GIRO MAERSK LOGISTICS & SERVICES S P LTD 8141001436 SUPP-260617161631GI204991', 810.0::numeric, 'MINV2026050001', 'maersk'),
  ('2026-07-01', 'INTERBANK GIRO M/S MAERSK SINGAPORE PTE LTD 8100190716 IVPT-260701161542GI200359', 3575.0::numeric, 'MINV2026050005', 'maersk'),
  ('2026-07-29', 'INTERBANK GIRO M/S MAERSK SINGAPORE PTE LTD 8100221283 IVPT-260729162204GI204647', 2510.0::numeric, 'MINV2026060001', 'maersk'),
  ('2026-07-29', 'INTERBANK GIRO M/S MAERSK SINGAPORE PTE LTD 8100221282 IVPT-260729162204GI204744', 1015.0::numeric, 'MINV2026060002', 'maersk'),
  ('2026-08-19', 'INTERBANK GIRO MAERSK LOGISTICS & SERVICES S P LTD 8141001976 SUPP-260819161822GI201411', 630.0::numeric, 'MINV2026070001', 'maersk'),
  ('2026-09-04', 'Inward PayNow Transfer 2026090419429994580020C120600910762 OTHER NG CAI LI 20260904SSPISGSGBRT0033237 SGD 80', 80.0::numeric, 'EINV2026080005', 'nonmaersk'),
  ('2026-01-27', 'FAST PAYMENT 7 HRS DSP MBA579 240.00 6,454.44 EBGPP60127691413000000C100000000000 M:+6596867568 OTHER 20260127DBSSSGSGBRT8891845 SGD 240', 240.0::numeric, 'MINV2026010002', 'maersk'),
  ('2026-01-27', 'FAST PAYMENT 11 HRS DSP VBO072 880.00 5,574.44 EBGPP60127691453000000C110487873656 M:+6596982827 OTHER 20260127DBSSSGSGBRT8898626 SGD 880', 880.0::numeric, 'MINV2026010003', 'maersk'),
  ('2026-02-11', 'REMITTANCE TRANSFER OF FUNDS RTF 6 HRS 480.00 3,262.67 DSP RNG019 0016RF3325037 YONG SIAK YIM ALAN SGD 480', 480.0::numeric, 'MINV2026020001', 'maersk'),
  ('2026-03-26', 'FAST PAYMENT 1 X TRF MAPPLE TREE HUB - SWISSOTEL EBGPP60326018933000000C110516277748 M:+6596982827 OTHER 20260326DBSSSGSGBRT5165094 SGD 170', 170.0::numeric, 'MINV2026030004/SRM2026030001', 'maersk'),
  ('2026-03-26', 'REMITTANCE TRANSFER OF FUNDS RTF  5 HRS DSP SSI465 0016RF5333201 YONG SIAK YIM ALAN                  SGD 300', 300.0::numeric, 'MINV2026030005', 'maersk'),
  ('2026-04-10', 'FAST PAYMENT 2 WAY TRSF MON008 EBGPP60410502042000000C100000000000 M:+6591392594 OTHER 20260410DBSSSGSGBRT7036997 SGD 300', 300.0::numeric, 'MINV2026030005', 'maersk'),
  ('2026-04-16', 'FAST PAYMENT 2 WAY TRSF LKO098 EBGPP60416647438000000C100000000000 M:+6596867568 OTHER 20260416DBSSSGSGBRT7138573 SGD 240', 240.0::numeric, 'MINV2026030003', 'maersk'),
  ('2026-05-04', 'REMITTANCE TRANSFER OF FUNDS RTF  9 HRS DSP JJZ104 0016RF7170174 YONG SIAK YIM ALAN (RONG XIXIAN) SGD 720', 720.0::numeric, 'MINV2026050001', 'maersk'),
  ('2026-05-18', 'REMITTANCE TRANSFER OF FUNDS RTF  7 HRS DSP KKL064 0016RF7848702 Yong Siak Yim Alan                                                                                                                           SGD 560', 560.0::numeric, 'MINV2026050005', 'maersk'),
  ('2026-05-19', 'REMITTANCE TRANSFER OF FUNDS RTF  10 HR DSP WWO026 0016RF7898816 Yong Siak Yim Alan                                                                                                                           SGD 800', 800.0::numeric, 'MINV2026050005', 'maersk'),
  ('2026-05-22', 'FAST PAYMENT MSR2026050002 EBGPP60522181974000000C100000000000 M:+6591392594 OTHER 20260522DBSSSGSGBRT7930501 SGD 200', 200.0::numeric, 'MINV2026050003/ MSR2026050002', 'maersk'),
  ('2026-05-22', 'REMITTANCE TRANSFER OF FUNDS RTF  7 HRS DSP 517 0016RF8057544 Yong Siak Yim Alan                                                                                                                           SGD 540', 540.0::numeric, 'MINV2026050004', 'maersk'),
  ('2026-05-26', 'FAST PAYMENT 2 x TRSF MYU045 EBGPP60526260521000000C100000000000 M:+6584811166 COMMISSION 20260526DBSSSGSGBRT6260281 SGD 240', 240.0::numeric, 'MINV2026040003', 'maersk'),
  ('2026-05-26', 'REMITTANCE TRANSFER OF FUNDS RTF  LISHAN PERSONAL 0016RF8202559 Yong Siak Yim Alan                                                                                                                           SGD 200', 200.0::numeric, 'MINV2026050003/ MSR2026050002', 'maersk'),
  ('2026-06-10', 'FAST PAYMENT 8 HRS DSP WWO026 EBGPP60610763757000000C120553817271 M:+6581621398 OTHER 20260610DBSSSGSGBRT5384483 SGD 640', 640.0::numeric, 'MINV2026060001', 'maersk'),
  ('2026-06-11', 'REMITTANCE TRANSFER OF FUNDS RTF  Combi trf DCH385 0016RF9066138 Yong Siak Yim Alan                                                                                                                           SGD 55', 55.0::numeric, 'MINV2026060001', 'maersk'),
  ('2026-06-18', 'REMITTANCE TRANSFER OF FUNDS RTF  2 X TRSF MON008 0016RF9406852 Yong Siak Yim Alan                                                                                                                           SGD 240', 240.0::numeric, 'MINV2026040003', 'maersk'),
  ('2026-06-18', 'REMITTANCE TRANSFER OF FUNDS RTF  11 HRS DSP 110 0016RF9406921 Yong Siak Yim Alan                                                                                                                           SGD 770', 770.0::numeric, 'MINV2026060004', 'maersk'),
  ('2026-06-27', 'REMITTANCE TRANSFER OF FUNDS RTF  13 HR DSP SKC010 0016RF9820179 Yong Siak Yim Alan                                                                                                                           SGD 780', 780.0::numeric, 'MINV2026060002', 'maersk'),
  ('2026-06-29', 'REMITTANCE TRANSFER OF FUNDS RTF  MFS TRF and2 MNC 0016RF9924420 Yong Siak Yim Alan                                                                                                                           SGD 780', 780.0::numeric, 'MINV2026060002', 'maersk'),
  ('2026-07-07', 'REMITTANCE TRANSFER OF FUNDS RTF  2 X TRSF LWO028 0016RF0367966 Yong Siak Yim Alan                                                                                                                           SGD 100', 100.0::numeric, 'MINV2026060005', 'maersk'),
  ('2026-07-07', 'FAST PAYMENT 1-way trf PLQ- Fairmont LWO028 EBGPP60707064849000000C100000000000 M:+6584811166 COMMISSION 20260707DBSSSGSGBRT8125432 SGD 90', 90.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-09', 'FAST PAYMENT WGII - SwissHotel LWO028 EBGPP60709146397000000C100000000000 M:+6584811166 COMMISSION 20260709DBSSSGSGBRT6340912 SGD 220', 220.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-09', 'FAST PAYMENT Full claim - LKH041 EBGPP60709155376000000C100000000000 M:+6591392594 COMMISSION 20260709DBSSSGSGBRT7072129 SGD 140', 140.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-14', 'FAST PAYMENT 10 HRS DSP KHC005 EBGPP60714305024000000C100572983096 M:+6580101880 OTHER 20260714DBSSSGSGBRT7687937 SGD 550', 550.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-14', 'FAST PAYMENT 8 HRS DSP LKH041 EBGPP60714305077000000C100572984560 M:+6581621398 OTHER 20260714DBSSSGSGBRT7698694 SGD 440', 440.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-15', 'FAST PAYMENT 9hr DSP KHC005 EBGPP60715343417000000C110573441673 M:+6580101880 COMMISSION 20260715DBSSSGSGBRT6550128 SGD 495', 495.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-22', 'FAST PAYMENT 1 WAY TRSF RNG019 EBGPP60722555361000000C130575772881 M:+6591709595 OTHER 20260722DBSSSGSGBRT9480925 SGD 150', 150.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-28', 'REMITTANCE TRANSFER OF FUNDS RTF  9hrs DSP KHC005 0016RF1397782 Yong Siak Yim Alan                                                                                                                           SGD 720', 720.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-28', 'REMITTANCE TRANSFER OF FUNDS RTF  12hrs DSP MYU045 0016RF1397809 Yong Siak Yim Alan                                                                                                                           SGD 840', 840.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-07-31', 'FAST PAYMENT Sharon Road show 13 Hrs 29-31 EBGPP60731042371000000C110582254674 M:+6597942250 OTHER 20260731DBSSSGSGBRT5789609 SGD 650', 650.0::numeric, 'MINV2026060005', 'maersk'),
  ('2026-07-31', 'REMITTANCE TRANSFER OF FUNDS RTF  22 23 31JulMAERS 0016RF1586558 Yong Siak Yim Alan                                                                                                                           SGD 720', 720.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-08-11', 'FAST PAYMENT 2xTRF PWL006 EBGPP60811419706000000C110588430035 M:+6580101880 COMMISSION 20260811DBSSSGSGBRT9719201 SGD 400', 400.0::numeric, 'EINV2026080001', 'nonmaersk'),
  ('2026-08-12', 'FAST PAYMENT 7 HRS DSP RNG019 EBGPP60812443951000000C100000000000 M:+6591392594 OTHER 20260812DBSSSGSGBRT7874537 SGD 280', 280.0::numeric, 'MINV2026080001', 'maersk'),
  ('2026-08-17', 'FAST PAYMENT 1 X MFS TRSF + 2 MNC EBGPP60817574632000000C100000000000 M:+6591065802 OTHER 20260817DBSSSGSGBRT6670273 SGD 470', 470.0::numeric, 'EINV2026080003', 'nonmaersk'),
  ('2026-08-21', 'REMITTANCE TRANSFER OF FUNDS RTF  MICHELLE LIM DSP 0016RF2655832 Yong Siak Yim Alan                                                                                                                           SGD 980', 980.0::numeric, 'MINV2026080001', 'maersk'),
  ('2026-08-24', 'FAST PAYMENT 1 x MnG EASTOOL 2 stops EBGPP60824008514000000C100000000000 M:+6591392594 OTHER 20260824DBSSSGSGBRT7663272 SGD 250', 250.0::numeric, 'EINV2026080008', 'nonmaersk'),
  ('2026-09-02', 'FAST PAYMENT 9hr DSP amazon EBGPP60902327916000000C100600690471 M:+6591266281 COMMISSION 20260902DBSSSGSGBRT7031743 SGD 720', 720.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-09-02', 'REMITTANCE TRANSFER OF FUNDS RTF  9hr DSP amazon 0016RF3281786 Yong Siak Yim Alan                                                                                                                           SGD 720', 720.0::numeric, 'MINV2026070002', 'maersk'),
  ('2026-09-04', 'REMITTANCE TRANSFER OF FUNDS RTF  13hr DSP MSF 0016RF3472670 Yong Siak Yim Alan                                                                                                                           SGD 1170', 1170.0::numeric, '', 'nonmaersk')
) as v(date, description, amount, invoice, workspace)
where t.date = v.date::date and t.description = v.description and t.amount = v.amount and t.source = 'manual';