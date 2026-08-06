// Shared across dashboard.html, log.html, update.html, and workspace.html.
// MAERSK and Non-MAERSK live in the SAME Supabase project, in two separate sets
// of tables (Non-MAERSK tables are suffixed "_nonmaersk"). Which set is used is
// picked based on ?ws= in the URL. Same login works for both since it's one project.

const WORKSPACE = (new URLSearchParams(location.search).get('ws') === 'nonmaersk') ? 'nonmaersk' : 'maersk';
const WORKSPACE_LABEL = WORKSPACE === 'nonmaersk' ? 'Non-MAERSK' : 'MAERSK';

const SUPABASE_URL = 'https://ctdtmwoztughpagavrsp.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0ZHRtd296dHVnaHBhZ2F2cnNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU1MzE3MDcsImV4cCI6MjEwMTEwNzcwN30.Rktv2pV1gE9LUi3Hr69C3YpaWBLvzwwI1jksl-7LwiY';
const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Logical table name -> actual table name for the current workspace.
const TABLE_SUFFIX = WORKSPACE === 'nonmaersk' ? '_nonmaersk' : '';
const TBL = {
  drivers: 'drivers' + TABLE_SUFFIX,
  clients: 'clients' + TABLE_SUFFIX,
  job_types: 'job_types' + TABLE_SUFFIX,
  rates: 'rates' + TABLE_SUFFIX,
  jobs: 'jobs' + TABLE_SUFFIX,
  job_options: 'job_options' + TABLE_SUFFIX,
};

// Same job types across both workspaces (the job_types DB table is unused/empty —
// this hardcoded list is the real source of truth, shared by dashboard.html,
// log.html, and update.html).
const JOB_TYPES = ['ADDITIONAL CHARGE','ADDITIONAL STOP (LOCAL)','ADDITIONAL STOP (MALAYSIA)','ADDITIONAL STOP (WITHIN 3KM)(23/45 SEATER)','ADDITIONAL STOP (WITHIN 3KM)(SALOON/MPV/COMBI)','ARRIVAL (DRIVE WAY PICK UP)','ARRIVAL (MEET & GREET)','CANCELLATION (100%)','CANCELLATION (25%)','CANCELLATION (50%)','DEPARTURE','DISPOSAL','HOURLY (LOCAL)','HOURLY (MALAYSIA)','MIDNIGHT SURCHARGE (LOCAL)','MIDNIGHT SURCHARGE (MALAYSIA)','MISCELLANEOUS','TOUR GUIDE (MIN 2)','TRANSFER (CROSS BORDER)(MINI VAN)','TRANSFER (CROSS BORDER)(MPV)','TRANSFER (CROSS BORDER)(SALOON)','TRANSFER (LOCAL)','TRANSFER (TUAS)','WAITING CHARGE (15 MINS/BLOCK)','WAITING CHARGE (15 MINS/BLOCK) (MALAYSIA)'];

// Same job types across both workspaces, prices can differ per workspace.
const MAERSK_RATE_MAP = {
  'ADDITIONAL STOP (LOCAL)': { flat: 30 },
  'ADDITIONAL STOP (MALAYSIA)': { flat: 30 },
  'ADDITIONAL STOP (WITHIN 3KM)(23/45 SEATER)': { flat: 30 },
  'ADDITIONAL STOP (WITHIN 3KM)(SALOON/MPV/COMBI)': { flat: 15 },
  'ARRIVAL (MEET & GREET)': { byVehicle: { 'MINI VAN':90, 'MPV':90, 'SALOON':70 } },
  'CANCELLATION (100%)': { flat: 140 },
  'CANCELLATION (50%)': { flat: 70 },
  'DEPARTURE': { byVehicle: { 'MINI VAN':80, 'MPV':80, 'SALOON':60 } },
  'HOURLY (LOCAL)': { byVehicle: { 'LARGE BUS':100, 'MINI BUS':90, 'MINI VAN':70, 'MPV':70, 'SALOON':60 } },
  'HOURLY (MALAYSIA)': { byVehicle: { 'MINI VAN':80, 'MPV':90, 'SALOON':70 } },
  'MIDNIGHT SURCHARGE (LOCAL)': { flat: 15 },
  'MIDNIGHT SURCHARGE (MALAYSIA)': { flat: 20 },
  'TOUR GUIDE (MIN 2)': { flat: 50 },
  'TRANSFER (CROSS BORDER)(MINI VAN)': { flat: 160 },
  'TRANSFER (CROSS BORDER)(MPV)': { flat: 170 },
  'TRANSFER (CROSS BORDER)(SALOON)': { flat: 150 },
  'TRANSFER (LOCAL)': { byVehicle: { 'LARGE BUS':160, 'MINI BUS':130, 'MINI VAN':70, 'MPV':70, 'SALOON':55 } },
  'TRANSFER (TUAS)': { byVehicle: { 'LARGE BUS':185, 'MINI BUS':150, 'MINI VAN':90, 'MPV':90, 'SALOON':80 } },
  'WAITING CHARGE (15 MINS/BLOCK)': { flat: 20 },
  'WAITING CHARGE (15 MINS/BLOCK) (MALAYSIA)': { flat: 25 },
  'CREDIT CARD CHARGES': { percentOfCost: 10 },
  // ADDITIONAL CHARGE, ARRIVAL (DRIVE WAY PICK UP), CANCELLATION (25%), DISPOSAL, MISCELLANEOUS:
  // no fixed rate on file — unit cost stays manual for these.
};

// Starts as a copy of the MAERSK rate card — tell me the real non-MAERSK
// prices whenever you're ready and I'll update these values.
const NONMAERSK_RATE_MAP = JSON.parse(JSON.stringify(MAERSK_RATE_MAP));

const RATE_MAP_BY_WORKSPACE = { maersk: MAERSK_RATE_MAP, nonmaersk: NONMAERSK_RATE_MAP };
const RATE_MAP = RATE_MAP_BY_WORKSPACE[WORKSPACE];
