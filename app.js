// sb, TBL (table names), and RATE_MAP are defined in workspace-config.js, which is loaded
// before this file and picks MAERSK vs Non-MAERSK based on ?ws= in the URL. Both workspaces
// share the same Supabase project but use separate "_nonmaersk"-suffixed tables.
document.title = document.title.replace('EliteSkyline', `EliteSkyline (${WORKSPACE_LABEL})`);
document.querySelector('header h1').textContent = `EliteSkyline — Job Log (${WORKSPACE_LABEL})`;
document.querySelector('.login-box .sub').textContent = `Sign in to access the ${WORKSPACE_LABEL} Job Log`;

// ELITE jobs don't need Host Name / Company / UID / Cost Centre on the job form,
// and the MAERSK Summary tab (filters by MAERSK SINGAPORE PTE LTD + SG51 cost
// centre) is irrelevant for ELITE.
if(WORKSPACE === 'nonmaersk'){
  ['uidFieldWrap','costCentreFieldWrap','maerskNavBtn'].forEach(id=>{
    const el = document.getElementById(id);
    if(el) el.style.display = 'none';
  });
} else {
  // Payout to Alan is a manual field specific to ELITE jobs.
  const el = document.getElementById('payoutAlanFieldWrap');
  if(el) el.style.display = 'none';
}
// .payoutAlan-col (th and dynamically-rendered td cells alike) is hidden by
// default in CSS and only shown for ELITE via this body class.
if(WORKSPACE === 'nonmaersk') document.body.classList.add('ws-nonmaersk');

// ---------- Auth ----------
const loginOverlay = document.getElementById('loginOverlay');
const loginBtn = document.getElementById('loginBtn');
const loginEmail = document.getElementById('loginEmail');
const loginPassword = document.getElementById('loginPassword');
const loginError = document.getElementById('loginError');

loginBtn.addEventListener('click', async ()=>{
  const email = loginEmail.value.trim();
  const pass = loginPassword.value;
  if(!email||!pass){ loginError.textContent='Please enter email and password.'; return; }
  loginBtn.disabled = true;
  loginBtn.textContent = 'Loading…';
  loginError.textContent = '';
  const {error} = await sb.auth.signInWithPassword({email, password:pass});
  loginBtn.disabled = false;
  loginBtn.textContent = 'Sign In';
  if(error){ loginError.textContent = error.message; return; }
  initApp();
});

loginPassword.addEventListener('keydown', e=>{ if(e.key==='Enter') loginBtn.click(); });

document.getElementById('logoutBtn').addEventListener('click', async ()=>{
  await sb.auth.signOut();
  loginOverlay.classList.remove('hidden');
  document.getElementById('headerSub').textContent = '';
});

async function initApp(){
  loginOverlay.classList.add('hidden');
  DATA = await loadData();
  renderAll();
}

sb.auth.getSession().then(({data:{session}})=>{
  if(session) initApp();
});

const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const MONTH_FULL = {Jan:0,Feb:1,Mar:2,Apr:3,May:4,Jun:5,Jul:6,Aug:7,Sep:8,Oct:9,Nov:10,Dec:11};

async function loadData(){
  const [drivers, clients, jobTypes, rates, jobs, jobOptions] = await Promise.all([
    sb.from(TBL.drivers).select('*'),
    sb.from(TBL.clients).select('*'),
    sb.from(TBL.job_types).select('*'),
    sb.from(TBL.rates).select('*'),
    sb.from(TBL.jobs).select('*'),
    sb.from(TBL.job_options).select('*'),
  ]);
  if(drivers.error || clients.error || jobTypes.error || rates.error || jobs.error || jobOptions.error){
    console.error('Supabase load failed, falling back to seed data');
    return JSON.parse(JSON.stringify(window.SEED));
  }
  return {
    drivers: drivers.data,
    clients: clients.data,
    jobTypes: jobTypes.data.map(jt => jt.name),
    rates: rates.data,
    jobs: jobs.data,
    jobOptions: jobOptions.data,
  };
}

let DATA = { drivers:[], clients:[], jobTypes:[], rates:[], jobs:[], jobOptions:[] };
function optionsByJob(jobId){
  return (DATA.jobOptions||[]).filter(o=>o.job_id===jobId);
}
let editingId = null;
let editingDriverId = null;
let editingClientId = null;
let editingRateId = null;

function escHtml(s){ return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

// ---------- Pagination ----------
const PAGE_SIZE = 10;
const pageState = {};
// Job Log & Invoices adjust their page size to fit the panel height (no
// scrolling needed to see a full page), capped at PAGE_SIZE; every other
// view (Drivers, Clients, Job Types & Rates) uses the fixed PAGE_SIZE too.
const DYNAMIC_PAGE_SIZE = { jobs: PAGE_SIZE, invoices: PAGE_SIZE };
function paginate(key, items){
  const size = DYNAMIC_PAGE_SIZE[key] || PAGE_SIZE;
  const totalPages = Math.max(1, Math.ceil(items.length / size));
  pageState[key] = Math.min(Math.max(1, pageState[key] || 1), totalPages);
  const page = pageState[key];
  const start = (page-1)*size;
  return { items: items.slice(start, start+size), page, totalPages };
}
// Measures how many rows actually fit in a table's panel without scrolling,
// based on the currently-rendered rows' real (possibly multi-line) height.
function fitRowsToPanel(tableId){
  const table = document.getElementById(tableId);
  if(!table) return null;
  const panel = table.closest('.panel');
  const thead = table.querySelector('thead');
  const tbody = table.querySelector('tbody');
  if(!panel || !tbody) return null;
  const rows = [...tbody.children].filter(r=>!r.querySelector('.empty'));
  if(!rows.length) return null;
  const theadH = thead ? thead.offsetHeight : 0;
  const avgRowH = rows.reduce((s,r)=>s+r.offsetHeight, 0) / rows.length;
  if(!avgRowH) return null;
  const availableH = panel.clientHeight - theadH;
  return Math.min(PAGE_SIZE, Math.max(5, Math.floor(availableH / avgRowH)));
}
function renderPagination(containerId, key, page, totalPages, onChange){
  const el = document.getElementById(containerId);
  if(!el) return;
  if(totalPages<=1){ el.innerHTML=''; return; }
  el.innerHTML = `<button ${page<=1?'disabled':''} data-dir="-1">‹ Prev</button><span>Page ${page} of ${totalPages}</span><button ${page>=totalPages?'disabled':''} data-dir="1">Next ›</button>`;
  el.querySelectorAll('button').forEach(b=>b.addEventListener('click', ()=>{
    pageState[key] += Number(b.dataset.dir);
    onChange();
  }));
}
// Re-measure Job Log / Invoices row-fit on resize (debounced) so the page size
// keeps matching the available panel height.
let resizeFitTimer = null;
window.addEventListener('resize', ()=>{
  clearTimeout(resizeFitTimer);
  resizeFitTimer = setTimeout(()=>{
    if(document.getElementById('view-jobs')?.classList.contains('active')) renderJobs();
    if(document.getElementById('view-invoices')?.classList.contains('active')) renderInvoices();
  }, 250);
});

// Force free-text data entry fields to uppercase, matching the ALL-CAPS convention used throughout the data.
// Skips while an IME composition is active (e.g. typing Chinese via pinyin) so the candidate popup isn't disrupted;
// toUpperCase() is a harmless no-op on CJK characters once composition commits.
function wireUppercase(el){
  el.addEventListener('input', (e)=>{
    if(e.isComposing) return;
    const start = el.selectionStart, end = el.selectionEnd;
    el.value = el.value.toUpperCase();
    if(start !== null) el.setSelectionRange(start, end);
  });
}
['f_invoice','f_company','f_uid','f_costCentre','f_pax','f_details','f_remarks',
 'd_name','d_vehicle','d_plate','d_phone','d_rateNote',
 'c_hostName','c_uid','c_costCentre','c_company','c_code',
 'r_jobType'
].forEach(id=>{
  const el = document.getElementById(id);
  if(el) wireUppercase(el);
});

// Calendar popover for the Date field — click a day and it's selected immediately,
// no separate confirm/"Done" tap needed.
const CAL_MONTH_NAMES = ['January','February','March','April','May','June','July','August','September','October','November','December'];
const calState = {};
function initDatePicker(prefix, initialValue){
  calState[prefix] = { view: initialValue ? new Date(initialValue+'T00:00:00') : new Date(), value: initialValue || '' };
  updateDateDisplay(prefix);
  document.getElementById(prefix+'_display').addEventListener('click', (e)=>{
    e.stopPropagation();
    toggleCalPopover(prefix);
  });
  document.getElementById(prefix+'_popover').addEventListener('click', (e)=>{
    e.stopPropagation();
    if(e.target.classList.contains('calNav')){
      const dir = Number(e.target.dataset.dir);
      const v = calState[prefix].view;
      calState[prefix].view = new Date(v.getFullYear(), v.getMonth()+dir, 1);
      renderCalGrid(prefix);
    } else if(e.target.classList.contains('day') && e.target.dataset.date){
      calState[prefix].value = e.target.dataset.date;
      calState[prefix].view = new Date(e.target.dataset.date+'T00:00:00');
      updateDateDisplay(prefix);
      document.getElementById(prefix+'_popover').style.display = 'none';
    }
  });
}
function renderCalGrid(prefix){
  const st = calState[prefix];
  const y = st.view.getFullYear(), m = st.view.getMonth();
  document.getElementById(prefix+'_label').textContent = `${CAL_MONTH_NAMES[m]} ${y}`;
  const firstDay = new Date(y,m,1).getDay();
  const daysInMonth = new Date(y,m+1,0).getDate();
  const todayStr = new Date().toISOString().slice(0,10);
  let html = ['Su','Mo','Tu','We','Th','Fr','Sa'].map(d=>`<div class="dow">${d}</div>`).join('');
  for(let i=0;i<firstDay;i++) html += '<div class="empty">.</div>';
  for(let d=1; d<=daysInMonth; d++){
    const dateStr = `${y}-${String(m+1).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
    const cls = ['day'];
    if(dateStr === st.value) cls.push('selected');
    if(dateStr === todayStr) cls.push('today');
    html += `<div class="${cls.join(' ')}" data-date="${dateStr}">${d}</div>`;
  }
  document.getElementById(prefix+'_grid').innerHTML = html;
}
function updateDateDisplay(prefix){
  const st = calState[prefix];
  document.getElementById(prefix+'_display').textContent = st.value ? fmtDMY(st.value) : 'Select date';
}
function fmtDMY(value){
  const [y,m,d] = value.split('-');
  return `${d}/${m}/${y}`;
}
function toggleCalPopover(prefix){
  const pop = document.getElementById(prefix+'_popover');
  const isOpen = pop.style.display === 'block';
  document.querySelectorAll('.calendarPopover').forEach(p=>p.style.display='none');
  if(!isOpen){
    pop.style.display = 'block';
    renderCalGrid(prefix);
  }
}
document.addEventListener('click', ()=>{
  document.querySelectorAll('.calendarPopover').forEach(p=>p.style.display='none');
});
function getDate(prefix){ return calState[prefix]?.value || ''; }
function setDate(prefix, value){
  if(!calState[prefix]){ initDatePicker(prefix, value); return; }
  calState[prefix].value = value || '';
  if(value) calState[prefix].view = new Date(value+'T00:00:00');
  updateDateDisplay(prefix);
}
initDatePicker('f_date', '');

// Plain-text 24h HH:MM mask — avoids native <input type=time> showing AM/PM on some devices.
function wireTimeMask(el){
  el.addEventListener('input', ()=>{
    const digits = el.value.replace(/\D/g,'').slice(0,4);
    el.value = digits.length > 2 ? digits.slice(0,2)+':'+digits.slice(2) : digits;
  });
  el.addEventListener('blur', ()=>{
    const m = el.value.match(/^(\d{1,2}):?(\d{0,2})$/);
    if(!m || el.value.trim()===''){ return; }
    const hh = Math.min(23, parseInt(m[1]||'0',10));
    const mm = Math.min(59, parseInt(m[2]||'0',10));
    const formatted = String(hh).padStart(2,'0')+':'+String(mm).padStart(2,'0');
    if(formatted !== el.value){
      el.value = formatted;
      el.dispatchEvent(new Event('change'));
    }
  });
}
function fmtDate(d){
  if(!d) return '';
  const m = String(d).match(/^(\d{4})-(\d{2})-(\d{2})/);
  return m ? `${m[3]}-${m[2]}-${m[1]}` : d;
}
function fmtMoney(n){
  n = Number(n)||0;
  return 'S$' + n.toLocaleString('en-SG',{minimumFractionDigits:2,maximumFractionDigits:2});
}
function monthKey(dateStr){
  if(!dateStr) return null;
  const d = new Date(dateStr);
  if(isNaN(d)) return null;
  return MONTHS[d.getMonth()];
}
function statusClass(s){
  if(!s) return 'unpaid';
  s = s.toLowerCase();
  if(s.includes('paid') && !s.includes('unpaid')) return 'paid';
  if(s.includes('pend')) return 'pending';
  return 'unpaid';
}

// ---------- Nav ----------
document.querySelectorAll('nav button').forEach(btn=>{
  btn.addEventListener('click', ()=>{
    document.querySelectorAll('nav button').forEach(b=>b.classList.remove('active'));
    document.querySelectorAll('.view').forEach(v=>v.classList.remove('active'));
    btn.classList.add('active');
    document.getElementById('view-'+btn.dataset.view).classList.add('active');
    renderAll();
  });
});

// ---------- Dashboard ----------
let dashFiltersDefaulted = false;
function populateDashFilterOptions(){
  const fYear = document.getElementById('fDashYear');
  const years = [...new Set(DATA.jobs.map(j=>j.date).filter(Boolean).map(d=>d.slice(0,4)))].sort();
  if(fYear.options.length<=1){
    years.forEach(y=>{const o=document.createElement('option');o.value=y;o.textContent=y;fYear.appendChild(o);});
  }
  if(!dashFiltersDefaulted && DATA.jobs.length){
    const latestDate = DATA.jobs.map(j=>j.date).filter(Boolean).sort().slice(-1)[0];
    if(latestDate) fYear.value = latestDate.slice(0,4);
    dashFiltersDefaulted = true;
  }
}

function renderDashboard(){
  populateDashFilterOptions();
  const year = document.getElementById('fDashYear').value;
  const jobs = year ? DATA.jobs.filter(j=>(j.date||'').slice(0,4)===year) : DATA.jobs;
  document.getElementById('monthlyTableTitle').textContent = `Monthly Totals${year?' ('+year+')':''}`;
  const totalSales = jobs.reduce((s,j)=>s+(Number(j.cost)||0),0);
  const totalPayout = jobs.reduce((s,j)=>s+(Number(j.driverPayout)||0),0);
  const totalCoy = jobs.reduce((s,j)=>s+(Number(j.coyFund)||0),0);
  document.getElementById('headerSub').textContent = `${jobs.length} jobs logged · ${fmtMoney(totalSales)} total sales${year?' in '+year:' YTD'}`;

  document.getElementById('dashCards').innerHTML = `
    <div class="card"><div class="label">Total Jobs</div><div class="value">${jobs.length}</div></div>
    <div class="card"><div class="label">Total Sales</div><div class="value">${fmtMoney(totalSales)}</div></div>
    <div class="card"><div class="label">Driver Payout</div><div class="value">${fmtMoney(totalPayout)}</div></div>
    <div class="card"><div class="label">Company Fund</div><div class="value">${fmtMoney(totalCoy)}</div></div>
  `;

  const byMonth = {};
  MONTHS.forEach(m=>byMonth[m]={jobs:0,sales:0,payout:0,coy:0});
  jobs.forEach(j=>{
    const m = monthKey(j.date);
    if(!m) return;
    byMonth[m].jobs++;
    byMonth[m].sales += Number(j.cost)||0;
    byMonth[m].payout += Number(j.driverPayout)||0;
    byMonth[m].coy += Number(j.coyFund)||0;
  });
  const tbody = document.querySelector('#monthlyTable tbody');
  tbody.innerHTML = MONTHS.map(m=>{
    const r = byMonth[m];
    return `<tr><td>${m}</td><td class="num">${r.jobs}</td><td class="num">${fmtMoney(r.sales)}</td><td class="num">${fmtMoney(r.payout)}</td><td class="num">${fmtMoney(r.coy)}</td></tr>`;
  }).join('') + `<tr style="font-weight:700;"><td>Total</td><td class="num">${jobs.length}</td><td class="num">${fmtMoney(totalSales)}</td><td class="num">${fmtMoney(totalPayout)}</td><td class="num">${fmtMoney(totalCoy)}</td></tr>`;

  const byStatus = {};
  jobs.forEach(j=>{
    const s = (j.paymentStatus || 'UNPAID').toUpperCase();
    byStatus[s] = byStatus[s] || {jobs:0,sales:0};
    byStatus[s].jobs++;
    byStatus[s].sales += Number(j.cost)||0;
  });
  const ptbody = document.querySelector('#paymentTable tbody');
  const entries = Object.entries(byStatus);
  ptbody.innerHTML = entries.length ? entries.map(([s,r])=>
    `<tr><td><span class="pill ${statusClass(s)}">${s}</span></td><td class="num">${r.jobs}</td><td class="num">${fmtMoney(r.sales)}</td></tr>`
  ).join('') : `<tr><td colspan="3" class="empty">No jobs yet</td></tr>`;
}
document.getElementById('fDashYear').addEventListener('change', renderDashboard);

// ---------- Jobs table ----------
let jobFiltersDefaulted = false;
function populateFilterOptions(){
  const fMonth = document.getElementById('fMonth');
  if(fMonth.options.length<=1){
    MONTHS.forEach(m=>{const o=document.createElement('option');o.value=m;o.textContent=m+' 2026';fMonth.appendChild(o);});
  }
  const fDriver = document.getElementById('fDriver');
  if(fDriver.options.length<=1){
    DATA.drivers.map(d=>d.name).sort().forEach(n=>{const o=document.createElement('option');o.value=n;o.textContent=n;fDriver.appendChild(o);});
  }

  // Default the view to the latest month present in the data, once.
  if(!jobFiltersDefaulted && DATA.jobs.length){
    const latestDate = DATA.jobs.map(j=>j.date).filter(Boolean).sort().slice(-1)[0];
    if(latestDate) fMonth.value = monthKey(latestDate);
    jobFiltersDefaulted = true;
  }
}

// ---------- Sortable column headers (Job Log & Invoices) ----------
const sortState = { jobs: null, invoices: null };
function compareValues(a, b){
  if(typeof a === 'number' && typeof b === 'number') return a - b;
  return String(a).localeCompare(String(b));
}
function wireSortableHeaders(tableId, stateKey, renderFn){
  document.querySelectorAll(`#${tableId} th.sortable`).forEach(th=>{
    th.addEventListener('click', ()=>{
      const key = th.dataset.key;
      const cur = sortState[stateKey];
      sortState[stateKey] = (cur && cur.key === key)
        ? { key, dir: cur.dir === 'asc' ? 'desc' : 'asc' }
        : { key, dir: 'asc' };
      renderFn();
    });
  });
}
function updateSortArrows(tableId, stateKey){
  const st = sortState[stateKey];
  document.querySelectorAll(`#${tableId} th.sortable`).forEach(th=>{
    const arrow = th.querySelector('.sortArrow');
    if(st && st.key === th.dataset.key){
      arrow.textContent = st.dir === 'asc' ? '▲' : '▼';
      arrow.classList.add('active');
    } else {
      arrow.textContent = '⇅';
      arrow.classList.remove('active');
    }
  });
}
const JOBS_SORT_ACCESSORS = {
  date: j=>j.date||'',
  invoice: j=>j.invoice||'',
  driver: j=>j.driver||'',
  jobType: j=>j.jobType||'',
  startTime: j=>j.startTime||'',
  endTime: j=>j.endTime||'',
  hostName: j=>j.hostName||'',
  cost: j=>(Number(j.qty)||0)*(Number(j.unitCost)||0),
  driverPayout: j=>Number(j.driverPayout)||0,
  coyFund: j=>Number(j.coyFund)||0,
  payoutAlan: j=>Number(j.payoutAlan)||0,
  paymentStatus: j=>j.paymentStatus||'',
};
const INVOICES_SORT_ACCESSORS = {
  date: j=>j.date||'',
  invoice: j=>j.invoice||'',
  driver: j=>j.driver||'',
  jobType: j=>j.jobType||'',
  hostName: j=>j.hostName||'',
  qty: j=>Number(j.qty)||0,
  unitCost: j=>Number(j.unitCost)||0,
  cost: j=>(Number(j.qty)||0)*(Number(j.unitCost)||0),
  payoutAlan: j=>Number(j.payoutAlan)||0,
  paymentStatus: j=>j.paymentStatus||'',
};
wireSortableHeaders('jobsTable', 'jobs', ()=>renderJobs());
wireSortableHeaders('invoicesTable', 'invoices', ()=>renderInvoices());
document.getElementById('jobsClearSortBtn').addEventListener('click', ()=>{ sortState.jobs = null; renderJobs(); });
document.getElementById('invoicesClearSortBtn').addEventListener('click', ()=>{ sortState.invoices = null; renderInvoices(); });

function renderJobs(_skipFit){
  populateFilterOptions();
  const month = document.getElementById('fMonth').value;
  const driver = document.getElementById('fDriver').value;
  const status = document.getElementById('fStatus').value;
  const search = document.getElementById('fSearch').value.toLowerCase();

  let jobs = DATA.jobs.slice();
  if(month) jobs = jobs.filter(j=>monthKey(j.date)===month);
  if(driver) jobs = jobs.filter(j=>j.driver===driver);
  if(status) jobs = jobs.filter(j=> statusClass(j.paymentStatus) === status.toLowerCase());
  if(search){
    jobs = jobs.filter(j=>[j.invoice,j.hostName,j.company,j.details,j.jobType].some(v=>(v||'').toLowerCase().includes(search)));
  }

  if(sortState.jobs){
    const acc = JOBS_SORT_ACCESSORS[sortState.jobs.key];
    const dir = sortState.jobs.dir === 'asc' ? 1 : -1;
    jobs.sort((a,b)=> dir * compareValues(acc(a), acc(b)));
  } else {
    jobs.sort((a,b)=> new Date(a.date) - new Date(b.date) || (a.id-b.id));
  }
  updateSortArrows('jobsTable', 'jobs');

  document.getElementById('jobsCount').textContent = `${jobs.length} job${jobs.length===1?'':'s'}`;

  const totalCost = jobs.reduce((s,j)=>s+(Number(j.cost)||0),0);
  const totalDriverPayout = jobs.reduce((s,j)=>s+(Number(j.driverPayout)||0),0);
  const totalCoyFund = jobs.reduce((s,j)=>s+(Number(j.coyFund)||0),0);
  document.getElementById('jobsCards').innerHTML = `
    <div class="card"><div class="label">Total Jobs</div><div class="value">${jobs.length}</div></div>
    <div class="card"><div class="label">Total Cost</div><div class="value">${fmtMoney(totalCost)}</div></div>
    <div class="card"><div class="label">Total Driver Payout</div><div class="value">${fmtMoney(totalDriverPayout)}</div></div>
    <div class="card"><div class="label">Total Coy Fund</div><div class="value">${fmtMoney(totalCoyFund)}</div></div>
  `;

  const {items:pageJobs, page, totalPages} = paginate('jobs', jobs);
  const tbody = document.querySelector('#jobsTable tbody');
  tbody.innerHTML = pageJobs.length ? pageJobs.map(j=>`
    <tr>
      <td>${fmtDate(j.date)}</td>
      <td>${j.invoice||''}</td>
      <td class="driver-cell">${j.driver||''}</td>
      <td class="jobtype-cell">${j.jobType||''}</td>
      <td class="time-col">${j.startTime||''}</td>
      <td class="time-col">${j.endTime||''}</td>
      <td class="host-cell">${j.hostName||''}${j.company?`<div class="small muted">${j.company}</div>`:''}</td>
      <td class="details-cell">${renderTripDetailsCell(j)}</td>
      <td class="num">${fmtMoney((Number(j.qty)||0)*(Number(j.unitCost)||0))}</td>
      <td class="num">${fmtMoney(j.driverPayout)}</td>
      <td class="num fit-col">${fmtMoney(j.coyFund)}</td>
      <td class="num payoutAlan-col fit-col">${fmtMoney(j.payoutAlan)}</td>
      <td><span class="pill ${statusClass(j.paymentStatus)}">${(j.paymentStatus||'UNPAID').toUpperCase()}</span></td>
      <td class="row-actions"><button onclick="openJobModal(${j.id})">Edit</button></td>
    </tr>
    ${optionsByJob(j.id).map(o=>`
    <tr>
      <td>${fmtDate(j.date)}</td>
      <td>${j.invoice||''}</td>
      <td class="driver-cell">${j.driver||''}</td>
      <td class="jobtype-cell">${fmtOptionLabel(o)}</td>
      <td class="time-col">${j.startTime||''}</td>
      <td class="time-col">${j.endTime||''}</td>
      <td class="host-cell">${j.hostName||''}${j.company?`<div class="small muted">${j.company}</div>`:''}</td>
      <td class="details-cell">${renderTripDetailsCell(j)}</td>
      <td class="num">${fmtMoney(o.amount)}</td>
      <td class="num">${fmtMoney(j.driverPayout)}</td>
      <td class="num fit-col">${fmtMoney(j.coyFund)}</td>
      <td class="num payoutAlan-col fit-col">${fmtMoney(j.payoutAlan)}</td>
      <td><span class="pill ${statusClass(j.paymentStatus)}">${(j.paymentStatus||'UNPAID').toUpperCase()}</span></td>
      <td class="row-actions"><button onclick="openJobModal(${j.id})">Edit</button></td>
    </tr>`).join('')}
  `).join('') : `<tr><td colspan="14" class="empty">No jobs match these filters</td></tr>`;
  renderPagination('jobsPagination', 'jobs', page, totalPages, renderJobs);

  if(!_skipFit){
    requestAnimationFrame(()=>{
      const fit = fitRowsToPanel('jobsTable');
      if(fit && fit !== DYNAMIC_PAGE_SIZE.jobs){
        DYNAMIC_PAGE_SIZE.jobs = fit;
        renderJobs(true);
      }
    });
  }
}

['fMonth','fDriver','fStatus'].forEach(id=>document.getElementById(id).addEventListener('change', ()=>{ pageState.jobs=1; renderJobs(); }));
document.getElementById('fSearch').addEventListener('input', ()=>{ pageState.jobs=1; renderJobs(); });

// ---------- Invoices ----------
const selectedInvoices = new Set();

let invoiceFiltersDefaulted = false;
function populateInvoiceFilterOptions(){
  const fYear = document.getElementById('fInvYear');
  const years = [...new Set(DATA.jobs.map(j=>j.date).filter(Boolean).map(d=>d.slice(0,4)))].sort();
  if(fYear.options.length<=1){
    years.forEach(y=>{const o=document.createElement('option');o.value=y;o.textContent=y;fYear.appendChild(o);});
  }
  const fMonth = document.getElementById('fInvMonth');
  if(fMonth.options.length<=1){
    MONTHS.forEach((m,i)=>{const o=document.createElement('option');o.value=String(i+1).padStart(2,'0');o.textContent=m;fMonth.appendChild(o);});
  }

  // Default the view to the latest month present in the data, once.
  if(!invoiceFiltersDefaulted && DATA.jobs.length){
    const latestDate = DATA.jobs.map(j=>j.date).filter(Boolean).sort().slice(-1)[0];
    if(latestDate){
      fYear.value = latestDate.slice(0,4);
      fMonth.value = latestDate.slice(5,7);
    }
    invoiceFiltersDefaulted = true;
  }

  const year = fYear.value;
  const month = fMonth.value;
  const fDate = document.getElementById('fInvDate');
  const prevDate = fDate.value;
  let dates = [...new Set(DATA.jobs.map(j=>j.date).filter(Boolean))];
  if(year) dates = dates.filter(d=>d.slice(0,4)===year);
  if(month) dates = dates.filter(d=>d.slice(5,7)===month);
  dates.sort();
  fDate.innerHTML = '<option value="">All Dates</option>' + dates.map(d=>`<option value="${d}">${fmtDate(d)}</option>`).join('');
  fDate.value = dates.includes(prevDate) ? prevDate : '';
}

function renderInvoices(_skipFit){
  populateInvoiceFilterOptions();
  const search = document.getElementById('fInvSearch').value.toLowerCase();
  const year = document.getElementById('fInvYear').value;
  const month = document.getElementById('fInvMonth').value;
  const date = document.getElementById('fInvDate').value;

  let rows = DATA.jobs.slice();
  if(search){
    rows = rows.filter(j=>[j.invoice,j.hostName,j.company,j.details,j.jobType].some(v=>(v||'').toLowerCase().includes(search)));
  }
  if(year) rows = rows.filter(j=>(j.date||'').slice(0,4)===year);
  if(month) rows = rows.filter(j=>(j.date||'').slice(5,7)===month);
  if(date) rows = rows.filter(j=>j.date===date);

  if(sortState.invoices){
    const acc = INVOICES_SORT_ACCESSORS[sortState.invoices.key];
    const dir = sortState.invoices.dir === 'asc' ? 1 : -1;
    rows.sort((a,b)=> dir * compareValues(acc(a), acc(b)));
  } else {
    rows.sort((a,b)=> (a.date||'').localeCompare(b.date||'') || (a.id-b.id));
  }
  updateSortArrows('invoicesTable', 'invoices');

  document.getElementById('invCount').textContent = `${rows.length} record${rows.length===1?'':'s'}`;
  const {items:pageRows, page, totalPages} = paginate('invoices', rows);
  document.querySelector('#invoicesTable tbody').innerHTML = pageRows.length ? pageRows.map(j=>{
    const inv = j.invoice || '(no invoice #)';
    const exportable = !!j.invoice;
    const checked = selectedInvoices.has(inv) ? 'checked' : '';
    return `
    <tr>
      <td>${exportable ? `<input type="checkbox" class="inv-check" data-inv="${encodeURIComponent(inv)}" ${checked}>` : ''}</td>
      <td>${fmtDate(j.date)}</td>
      <td>${inv}</td>
      <td class="driver-cell">${j.driver||''}</td>
      <td class="jobtype-cell">${j.jobType||''}</td>
      <td class="host-cell">${j.hostName||''}${j.company?`<div class="small muted">${j.company}</div>`:''}</td>
      <td class="details-cell">${renderTripDetailsCell(j)}</td>
      <td class="num">${j.qty ?? ''}</td>
      <td class="num">${fmtMoney(j.unitCost)}</td>
      <td class="num">${fmtMoney((Number(j.qty)||0)*(Number(j.unitCost)||0))}</td>
      <td class="num payoutAlan-col fit-col">${fmtMoney(j.payoutAlan)}</td>
      <td><span class="pill ${statusClass(j.paymentStatus)}">${(j.paymentStatus||'UNPAID').toUpperCase()}</span></td>
      <td class="row-actions"><button onclick="openJobModal(${j.id})">Edit</button></td>
    </tr>
    ${optionsByJob(j.id).map(o=>`
    <tr>
      <td></td>
      <td>${fmtDate(j.date)}</td>
      <td>${inv}</td>
      <td class="driver-cell">${j.driver||''}</td>
      <td class="jobtype-cell">${fmtOptionLabel(o)}</td>
      <td class="host-cell">${j.hostName||''}${j.company?`<div class="small muted">${j.company}</div>`:''}</td>
      <td class="details-cell">${renderTripDetailsCell(j)}</td>
      <td class="num">1</td>
      <td class="num">${fmtMoney(o.amount)}</td>
      <td class="num">${fmtMoney(o.amount)}</td>
      <td class="num payoutAlan-col fit-col"></td>
      <td><span class="pill ${statusClass(j.paymentStatus)}">${(j.paymentStatus||'UNPAID').toUpperCase()}</span></td>
      <td class="row-actions"><button onclick="openJobModal(${j.id})">Edit</button></td>
    </tr>`).join('')}`;
  }).join('') : `<tr><td colspan="13" class="empty">No records found</td></tr>`;
  renderPagination('invoicesPagination', 'invoices', page, totalPages, renderInvoices);
  const checkable = [...document.querySelectorAll('.inv-check')];
  document.getElementById('invSelectAll').checked = checkable.length>0 && checkable.every(c=>c.checked);
  updateMarkPaidBtnLabel();

  if(!_skipFit){
    requestAnimationFrame(()=>{
      const fit = fitRowsToPanel('invoicesTable');
      if(fit && fit !== DYNAMIC_PAGE_SIZE.invoices){
        DYNAMIC_PAGE_SIZE.invoices = fit;
        renderInvoices(true);
      }
    });
  }
}
document.getElementById('fInvSearch').addEventListener('input', ()=>{ pageState.invoices=1; renderInvoices(); });
document.getElementById('fInvDate').addEventListener('change', ()=>{ pageState.invoices=1; renderInvoices(); });
document.getElementById('fInvYear').addEventListener('change', ()=>{ pageState.invoices=1; renderInvoices(); });
document.getElementById('fInvMonth').addEventListener('change', ()=>{ pageState.invoices=1; renderInvoices(); });

// "Mark as Paid" toggles to "Mark as Unpaid" once every job under the
// selected invoice(s) is already PAID — a smart toggle, not two buttons.
function updateMarkPaidBtnLabel(){
  const btn = document.getElementById('markPaidBtn');
  if(!btn) return;
  const jobs = DATA.jobs.filter(j=>selectedInvoices.has(j.invoice));
  const allPaid = jobs.length>0 && jobs.every(j=>(j.paymentStatus||'').toUpperCase()==='PAID');
  btn.textContent = allPaid ? 'Mark as Unpaid' : 'Mark as Paid';
}
document.querySelector('#invoicesTable tbody').addEventListener('change', e=>{
  if(e.target.matches('.inv-check')){
    const inv = decodeURIComponent(e.target.dataset.inv);
    if(e.target.checked) selectedInvoices.add(inv); else selectedInvoices.delete(inv);
    // Sync other rows sharing the same invoice # on this page.
    document.querySelectorAll(`.inv-check[data-inv="${e.target.dataset.inv}"]`).forEach(c=>c.checked = e.target.checked);
    document.getElementById('invSelectAll').checked = [...document.querySelectorAll('.inv-check')].every(c=>c.checked);
    updateMarkPaidBtnLabel();
  }
});
document.getElementById('invSelectAll').addEventListener('change', e=>{
  document.querySelectorAll('.inv-check').forEach(c=>{
    const inv = decodeURIComponent(c.dataset.inv);
    c.checked = e.target.checked;
    if(e.target.checked) selectedInvoices.add(inv); else selectedInvoices.delete(inv);
  });
  updateMarkPaidBtnLabel();
});

// ---------- Auto-assign invoice numbers ----------
// Rule: MAERSK SINGAPORE PTE LTD bills all trips for a calendar month on one invoice.
// Every other company gets one invoice per date.
const MAERSK_MONTHLY_COMPANY = 'MAERSK SINGAPORE PTE LTD';
function nextInvoiceSeqForMonth(yyyymm){
  let max = 0;
  const re = new RegExp('^MINV'+yyyymm+'(\\d{4})');
  DATA.jobs.forEach(j=>{
    if(j.invoice){
      const m = j.invoice.match(re);
      if(m) max = Math.max(max, parseInt(m[1],10));
    }
  });
  return max+1;
}
async function autoAssignInvoiceNumbers(){
  const ungrouped = DATA.jobs.filter(j=>!j.invoice && j.date);
  if(ungrouped.length===0){ alert('All jobs already have invoice numbers.'); return; }

  const groups = {};
  ungrouped.forEach(j=>{
    const [y,m] = j.date.split('-');
    const yyyymm = y+m;
    const isMaersk = (j.company||'').trim().toUpperCase() === MAERSK_MONTHLY_COMPANY;
    const key = isMaersk ? `${j.company}|${yyyymm}` : `${j.company}|${j.date}`;
    groups[key] = groups[key] || {jobs:[], yyyymm};
    groups[key].jobs.push(j);
  });

  const seqByMonth = {};
  const assignments = Object.values(groups).map(g=>{
    if(seqByMonth[g.yyyymm] == null) seqByMonth[g.yyyymm] = nextInvoiceSeqForMonth(g.yyyymm);
    const seq = seqByMonth[g.yyyymm]++;
    return { invNum: `MINV${g.yyyymm}${String(seq).padStart(4,'0')}`, jobs: g.jobs };
  });

  const skipped = DATA.jobs.filter(j=>!j.invoice && !j.date).length;
  const msg = `Assign invoice numbers to ${ungrouped.length} job(s) across ${assignments.length} new invoice(s)?`
    + (skipped ? `\n(${skipped} job(s) skipped — missing date.)` : '');
  if(!confirm(msg)) return;

  for(const a of assignments){
    const ids = a.jobs.map(j=>j.id);
    const {error} = await sb.from(TBL.jobs).update({invoice:a.invNum}).in('id', ids);
    if(error){ alert('Failed to assign invoice '+a.invNum+': '+error.message); return; }
    a.jobs.forEach(j=>{ j.invoice = a.invNum; });
  }
  renderAll();
  alert(`Assigned ${assignments.length} invoice number(s).`);
}
document.getElementById('autoAssignBtn').addEventListener('click', autoAssignInvoiceNumbers);

function extractRoute(text){
  if(!text) return '';
  return text.split('\n').filter(l=>!/^\s*(REQUESTOR|UID|COST CENTRE|DRIVER|PAX|TIME)\s*:/i.test(l)).join('\n').trim();
}
function extractPax(text){
  const m = (text||'').match(/^[ \t]*PAX[ \t]*:[ \t]*(.+)$/im);
  return m ? m[1].trim() : null;
}
// ELITE jobs don't carry Host/UID/Cost Centre, so their Trip Details cell just
// shows Itinerary, PAX, and Driver instead of the full MAERSK-style detail block.
function renderTripDetailsCell(j){
  if(WORKSPACE === 'nonmaersk'){
    const itinerary = extractRoute(j.details);
    const pax = extractPax(j.details);
    const lines = [];
    if(itinerary) lines.push(escHtml(itinerary));
    if(pax) lines.push(`PAX: ${escHtml(pax)}`);
    if(j.driver && !isTourGuideJobType(j.jobType)) lines.push(`DRIVER: ${escHtml(j.driver)}`);
    return lines.length ? `<div class="small" style="white-space:pre-line;">${lines.join('\n')}</div>` : '';
  }
  return j.details ? `<div class="small" style="white-space:pre-line;">${escHtml(j.details)}</div>` : '';
}
function csvField(v){
  v = v==null ? '' : String(v);
  if(/[",\n]/.test(v)) return '"'+v.replace(/"/g,'""')+'"';
  return v;
}
document.getElementById('markPaidBtn').addEventListener('click', async ()=>{
  if(selectedInvoices.size===0){ alert('Select at least one invoice.'); return; }
  const invNums = [...selectedInvoices];
  const jobs = DATA.jobs.filter(j=>invNums.includes(j.invoice));
  if(jobs.length===0){ alert('No jobs found for the selected invoice(s).'); return; }

  const allPaid = jobs.every(j=>(j.paymentStatus||'').toUpperCase()==='PAID');
  const target = allPaid ? 'UNPAID' : 'PAID';
  if(!confirm(`Mark ${jobs.length} job(s) across ${invNums.length} invoice(s) as ${target}?`)) return;

  const ids = jobs.map(j=>j.id);
  const {error} = await sb.from(TBL.jobs).update({paymentStatus:target}).in('id', ids);
  if(error){ alert('Failed to update status: '+error.message); return; }
  jobs.forEach(j=>{ j.paymentStatus = target; });
  renderAll();
  alert(`Marked ${jobs.length} job(s) as ${target}.`);
});
document.getElementById('generateInvoiceBtn').addEventListener('click', ()=>{
  if(selectedInvoices.size===0){ alert('Select at least one invoice to generate.'); return; }
  const params = new URLSearchParams({ ws: WORKSPACE, inv: [...selectedInvoices].join(',') });
  window.open(`invoice.html?${params}`, '_blank');
});

// ---------- Drivers ----------
const KEY_DRIVERS = ['ALAN YONG','ELVIN SAI','SEAN SEAH','ALAN TOH'];
function computeDriverStats(){
  const byDriver = {};
  DATA.jobs.forEach(j=>{
    if(!j.driver) return;
    const key = j.driver.trim().toUpperCase();
    byDriver[key] = byDriver[key] || {jobs:0, payout:0};
    byDriver[key].jobs++;
    byDriver[key].payout += Number(j.driverPayout)||0;
  });
  return byDriver;
}
function renderPinnedDrivers(byDriver){
  const rows = KEY_DRIVERS.map(name=>{
    const d = DATA.drivers.find(x=>(x.name||'').trim().toUpperCase()===name);
    const stat = byDriver[name] || {jobs:0,payout:0};
    return {name, d, stat};
  });
  document.querySelector('#pinnedDriversTable tbody').innerHTML = rows.map(({name,d,stat})=>`
    <tr>
      <td>${d?.name || name}</td>
      <td>${d?.vehicle||''}</td>
      <td>${d?.plate||''}</td>
      <td>${d?.phone||''}</td>
      <td>${d?.rateNote!=null?d.rateNote:''}</td>
      <td class="num">${stat.jobs}</td>
      <td class="num">${fmtMoney(stat.payout)}</td>
    </tr>`).join('');
}

function renderDrivers(){
  const search = document.getElementById('fDriverSearch').value.toLowerCase();
  const showDeactivated = document.getElementById('fShowDeactivated').checked;
  const byDriver = computeDriverStats();
  renderPinnedDrivers(byDriver);
  let rows = DATA.drivers.slice().sort((a,b)=>a.name.localeCompare(b.name));
  if(!showDeactivated){
    rows = rows.filter(d=>d.active !== false);
  }
  if(search){
    rows = rows.filter(d=>[d.name,d.vehicle,d.plate,d.phone].some(v=>(v||'').toLowerCase().includes(search)));
  }
  const {items:pageRows, page, totalPages} = paginate('drivers', rows);
  document.querySelector('#driversTable tbody').innerHTML = pageRows.length ? pageRows.map(d=>{
    const stat = byDriver[(d.name||'').trim().toUpperCase()] || {jobs:0,payout:0};
    const isActive = d.active !== false;
    return `<tr>
      <td>${d.name}</td>
      <td>${d.vehicle||''}</td>
      <td>${d.plate||''}</td>
      <td>${d.phone||''}</td>
      <td>${d.rateNote!=null?d.rateNote:''}</td>
      <td class="num">${stat.jobs}</td>
      <td class="num">${fmtMoney(stat.payout)}</td>
      <td><span class="pill ${isActive?'paid':'unpaid'}">${isActive?'Active':'Inactive'}</span></td>
      <td class="row-actions"><button onclick="openDriverModal(${d.id})">Edit</button></td>
    </tr>`;
  }).join('') : `<tr><td colspan="9" class="empty">No drivers found</td></tr>`;
  renderPagination('driversPagination', 'drivers', page, totalPages, renderDrivers);
}
document.getElementById('fDriverSearch').addEventListener('input', ()=>{ pageState.drivers=1; renderDrivers(); });
document.getElementById('fShowDeactivated').addEventListener('change', ()=>{ pageState.drivers=1; renderDrivers(); });

function openDriverModal(id){
  editingDriverId = id || null;
  const d = id ? DATA.drivers.find(x=>x.id===id) : null;
  document.getElementById('driverModalTitle').textContent = d ? 'Edit Driver' : 'New Driver';
  const deactivateBtn = document.getElementById('deactivateDriverBtn');
  deactivateBtn.style.display = d ? '' : 'none';
  deactivateBtn.textContent = (d && d.active === false) ? 'Activate' : 'Deactivate';
  document.getElementById('d_name').value = d?.name || '';
  document.getElementById('d_vehicle').value = d?.vehicle || '';
  document.getElementById('d_plate').value = d?.plate || '';
  document.getElementById('d_phone').value = d?.phone || '';
  document.getElementById('d_rateNote').value = d?.rateNote ?? '';
  document.getElementById('d_active').checked = d ? d.active !== false : true;
  document.getElementById('driverModalBg').classList.add('active');
}
function closeDriverModal(){
  document.getElementById('driverModalBg').classList.remove('active');
  editingDriverId = null;
}
document.getElementById('addDriverBtn').addEventListener('click', ()=>openDriverModal(null));
document.getElementById('cancelDriverBtn').addEventListener('click', closeDriverModal);
document.getElementById('driverModalBg').addEventListener('click', (e)=>{ if(e.target.id==='driverModalBg') closeDriverModal(); });

document.getElementById('saveDriverBtn').addEventListener('click', async ()=>{
  const driver = {
    name: document.getElementById('d_name').value.trim(),
    vehicle: document.getElementById('d_vehicle').value.trim(),
    plate: document.getElementById('d_plate').value.trim(),
    phone: document.getElementById('d_phone').value.trim(),
    rateNote: document.getElementById('d_rateNote').value.trim(),
    active: document.getElementById('d_active').checked,
  };
  if(!driver.name){ alert('Please enter a driver name.'); return; }
  if(editingDriverId){
    const {error} = await sb.from(TBL.drivers).update(driver).eq('id', editingDriverId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.drivers.findIndex(d=>d.id===editingDriverId);
    DATA.drivers[idx] = {...driver, id: editingDriverId};
  } else {
    const {data, error} = await sb.from(TBL.drivers).insert(driver).select();
    if(error){ alert('Save failed: '+error.message); return; }
    DATA.drivers.push(data[0]);
  }
  closeDriverModal();
  renderAll();
});
document.getElementById('deactivateDriverBtn').addEventListener('click', async ()=>{
  if(!editingDriverId) return;
  const d = DATA.drivers.find(x=>x.id===editingDriverId);
  const nextActive = d.active === false;
  const {error} = await sb.from(TBL.drivers).update({active: nextActive}).eq('id', editingDriverId);
  if(error){ alert('Update failed: '+error.message); return; }
  d.active = nextActive;
  closeDriverModal();
  renderAll();
});

// ---------- Clients ----------
function renderClients(){
  const search = document.getElementById('fClientSearch').value.toLowerCase();
  let rows = DATA.clients.slice();
  if(search){
    rows = rows.filter(c=>[c.hostName,c.company,c.uid,c.code].some(v=>(v||'').toString().toLowerCase().includes(search)));
  }
  rows.sort((a,b)=>(a.hostName||'').localeCompare(b.hostName||''));
  const {items:pageRows, page, totalPages} = paginate('clients', rows);
  document.querySelector('#clientsTable tbody').innerHTML = pageRows.length ? pageRows.map(c=>`
    <tr><td>${c.hostName||''}</td><td>${c.uid||''}</td><td>${c.costCentre||''}</td><td>${c.company||''}</td><td>${c.code||''}</td>
    <td class="row-actions"><button onclick="openClientModal(${c.id})">Edit</button></td></tr>
  `).join('') : `<tr><td colspan="6" class="empty">No clients found</td></tr>`;
  renderPagination('clientsPagination', 'clients', page, totalPages, renderClients);
}
document.getElementById('fClientSearch').addEventListener('input', ()=>{ pageState.clients=1; renderClients(); });

function openClientModal(id){
  editingClientId = id || null;
  const c = id ? DATA.clients.find(x=>x.id===id) : null;
  document.getElementById('clientModalTitle').textContent = c ? 'Edit Client' : 'New Client';
  document.getElementById('deleteClientBtn').style.display = c ? '' : 'none';
  document.getElementById('c_hostName').value = c?.hostName || '';
  document.getElementById('c_uid').value = c?.uid || '';
  document.getElementById('c_costCentre').value = c?.costCentre || '';
  document.getElementById('c_company').value = c?.company || '';
  document.getElementById('c_code').value = c?.code || '';
  document.getElementById('c_billingAddress').value = c?.billingAddress || '';
  document.getElementById('c_uen').value = c?.uen || '';
  document.getElementById('clientModalBg').classList.add('active');
}
function closeClientModal(){
  document.getElementById('clientModalBg').classList.remove('active');
  editingClientId = null;
}
document.getElementById('addClientBtn').addEventListener('click', ()=>openClientModal(null));
document.getElementById('cancelClientBtn').addEventListener('click', closeClientModal);
document.getElementById('clientModalBg').addEventListener('click', (e)=>{ if(e.target.id==='clientModalBg') closeClientModal(); });

document.getElementById('saveClientBtn').addEventListener('click', async ()=>{
  const client = {
    hostName: document.getElementById('c_hostName').value.trim(),
    uid: document.getElementById('c_uid').value.trim(),
    costCentre: document.getElementById('c_costCentre').value.trim(),
    company: document.getElementById('c_company').value.trim(),
    code: document.getElementById('c_code').value.trim(),
    billingAddress: document.getElementById('c_billingAddress').value.trim(),
    uen: document.getElementById('c_uen').value.trim(),
  };
  if(!client.hostName){ alert('Please enter a host name.'); return; }
  if(editingClientId){
    const {error} = await sb.from(TBL.clients).update(client).eq('id', editingClientId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.clients.findIndex(c=>c.id===editingClientId);
    DATA.clients[idx] = {...client, id: editingClientId};
  } else {
    const {data, error} = await sb.from(TBL.clients).insert(client).select();
    if(error){ alert('Save failed: '+error.message); return; }
    DATA.clients.push(data[0]);
  }
  closeClientModal();
  renderAll();
});
document.getElementById('deleteClientBtn').addEventListener('click', async ()=>{
  if(!editingClientId) return;
  if(!confirm('Delete this client?')) return;
  const {error} = await sb.from(TBL.clients).delete().eq('id', editingClientId);
  if(error){ alert('Delete failed: '+error.message); return; }
  DATA.clients = DATA.clients.filter(c=>c.id!==editingClientId);
  closeClientModal();
  renderAll();
});

// ---------- Job types / rates ----------
function renderRates(){
  const search = document.getElementById('fRatesSearch').value.toLowerCase();
  let rows = DATA.rates.slice();
  if(search){
    rows = rows.filter(r=>(r.jobType||'').toLowerCase().includes(search));
  }
  const {items:pageRows, page, totalPages} = paginate('rates', rows);
  document.querySelector('#ratesTable tbody').innerHTML = pageRows.length ? pageRows.map(r=>`
    <tr><td>${r.jobType}</td><td class="num">${r.unitPrice}</td><td>${r.billingUnit||''}</td>
    <td class="row-actions"><button onclick="openRateModal(${r.id})">Edit</button></td></tr>
  `).join('') : `<tr><td colspan="4" class="empty">No job types found</td></tr>`;
  renderPagination('ratesPagination', 'rates', page, totalPages, renderRates);
}
document.getElementById('fRatesSearch').addEventListener('input', ()=>{ pageState.rates=1; renderRates(); });

function openRateModal(id){
  editingRateId = id || null;
  const r = id ? DATA.rates.find(x=>x.id===id) : null;
  document.getElementById('rateModalTitle').textContent = r ? 'Edit Job Type' : 'New Job Type';
  document.getElementById('deleteRateBtn').style.display = r ? '' : 'none';
  document.getElementById('r_jobType').value = r?.jobType || '';
  document.getElementById('r_unitPrice').value = r?.unitPrice ?? '';
  document.getElementById('r_billingUnit').value = r?.billingUnit || '';
  document.getElementById('rateModalBg').classList.add('active');
}
function closeRateModal(){
  document.getElementById('rateModalBg').classList.remove('active');
  editingRateId = null;
}
document.getElementById('addRateBtn').addEventListener('click', ()=>openRateModal(null));
document.getElementById('cancelRateBtn').addEventListener('click', closeRateModal);
document.getElementById('rateModalBg').addEventListener('click', (e)=>{ if(e.target.id==='rateModalBg') closeRateModal(); });

document.getElementById('saveRateBtn').addEventListener('click', async ()=>{
  const rate = {
    jobType: document.getElementById('r_jobType').value.trim(),
    unitPrice: document.getElementById('r_unitPrice').value.trim(),
    billingUnit: document.getElementById('r_billingUnit').value.trim(),
  };
  if(!rate.jobType){ alert('Please enter a job type.'); return; }
  if(editingRateId){
    const {error} = await sb.from(TBL.rates).update(rate).eq('id', editingRateId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.rates.findIndex(r=>r.id===editingRateId);
    DATA.rates[idx] = {...rate, id: editingRateId};
  } else {
    const {data, error} = await sb.from(TBL.rates).insert(rate).select();
    if(error){ alert('Save failed: '+error.message); return; }
    DATA.rates.push(data[0]);
  }
  closeRateModal();
  renderAll();
});
document.getElementById('deleteRateBtn').addEventListener('click', async ()=>{
  if(!editingRateId) return;
  if(!confirm('Delete this job type?')) return;
  const {error} = await sb.from(TBL.rates).delete().eq('id', editingRateId);
  if(error){ alert('Delete failed: '+error.message); return; }
  DATA.rates = DATA.rates.filter(r=>r.id!==editingRateId);
  closeRateModal();
  renderAll();
});

// ---------- Modal / form ----------
function fillSelect(sel, values, placeholder){
  const sorted = [...values].sort((a,b)=>String(a).localeCompare(String(b)));
  sel.innerHTML = (placeholder?`<option value="">${placeholder}</option>`:'') + sorted.map(v=>`<option value="${v.replace(/"/g,'&quot;')}">${v}</option>`).join('');
}

// Job Type dropdown includes both the built-in JOB_TYPES list and any custom
// types added via the Job Types & Rates tab (DATA.rates), so a newly added
// rate shows up immediately without editing code.
function allJobTypes(){
  return [...new Set([...JOB_TYPES, ...DATA.rates.map(r=>r.jobType).filter(Boolean)])];
}
function hasChineseText(s){
  return /[一-鿿]/.test(s||'');
}
// Sharon's trips are Chinese-language tour groups — default the Job Type
// dropdown to Chinese-named types for her (falls back to the full list if
// none exist yet, so the dropdown is never left empty).
function filterJobTypesForHost(types, hostName){
  if((hostName||'').trim().toUpperCase() !== 'SHARON') return types;
  const chinese = types.filter(hasChineseText);
  return chinese.length ? chinese : types;
}
function setupModalOptions(currentDriverName, currentHostName){
  const driverNames = DATA.drivers.filter(d=>d.active !== false).map(d=>d.name);
  if(currentDriverName && !driverNames.includes(currentDriverName)) driverNames.push(currentDriverName);
  fillSelect(document.getElementById('f_driver'), driverNames, '— select driver —');
  fillSelect(document.getElementById('f_jobType'), filterJobTypesForHost(allJobTypes(), currentHostName), '— select job type —');
  fillSelect(document.getElementById('f_client'), DATA.clients.map(c=>c.hostName), '— select or leave blank —');
}

document.getElementById('f_client').addEventListener('change', (e)=>{
  const c = DATA.clients.find(c=>c.hostName===e.target.value);
  if(c){
    document.getElementById('f_company').value = c.company||'';
    document.getElementById('f_costCentre').value = c.costCentre||'';
    document.getElementById('f_uid').value = c.uid||'';
  }
  const jobTypeSel = document.getElementById('f_jobType');
  const current = jobTypeSel.value;
  fillSelect(jobTypeSel, filterJobTypesForHost(allJobTypes(), e.target.value), '— select job type —');
  jobTypeSel.value = current;
});

// Additional Options: a repeatable list where each row picks one of the
// non-hourly, non-transfer Job Types (e.g. Additional Stop, Waiting Charge)
// plus an amount, rolling into the job's Total Cost.
const ADDITIONAL_OPTIONS = ['ADDITIONAL CHARGE','ADDITIONAL STOP (LOCAL)','ADDITIONAL STOP (MALAYSIA)','ADDITIONAL STOP (WITHIN 3KM)(23/45 SEATER)','ADDITIONAL STOP (WITHIN 3KM)(SALOON/MPV/COMBI)','ARRIVAL (DRIVE WAY PICK UP)','ARRIVAL (MEET & GREET)','CANCELLATION (100%)','CANCELLATION (25%)','CANCELLATION (50%)','DEPARTURE','MIDNIGHT SURCHARGE (LOCAL)','MIDNIGHT SURCHARGE (MALAYSIA)','MISCELLANEOUS','TOUR GUIDE (MIN 2)','WAITING CHARGE (15 MINS/BLOCK)','WAITING CHARGE (15 MINS/BLOCK) (MALAYSIA)','CREDIT CARD CHARGES'];
function sumExtras(){
  return [...document.querySelectorAll('#optionsList .optionAmount')].reduce((s,el)=>s+(Number(el.value)||0),0);
}
function sumExtrasExcluding(row){
  const own = row.querySelector('.optionAmount');
  return [...document.querySelectorAll('#optionsList .optionAmount')]
    .filter(el=>el!==own)
    .reduce((s,el)=>s+(Number(el.value)||0),0);
}
function applyOptionRate(row){
  const optionType = row.querySelector('.optionType').value;
  const map = getRateMapping(optionType);
  if(!map) return;
  if(map.flat != null){
    row.querySelector('.optionAmount').value = map.flat;
  } else if(map.byVehicle){
    const vehicle = document.getElementById('f_vehicle').value;
    if(vehicle && map.byVehicle[vehicle] != null) row.querySelector('.optionAmount').value = map.byVehicle[vehicle];
  } else if(map.percentOfCost != null){
    const qty = Number(document.getElementById('f_qty').value)||0;
    const unitCost = Number(document.getElementById('f_unitCost').value)||0;
    const baseCost = qty*unitCost + sumExtrasExcluding(row);
    row.querySelector('.optionAmount').value = (baseCost * map.percentOfCost/100).toFixed(2);
  }
  recalc();
}
function fmtOptionLabel(o){
  return o.note ? `${o.optionType||''} — ${o.note}` : (o.optionType||'');
}
function updateOptionNoteVisibility(row){
  const noteEl = row.querySelector('.optionNote');
  noteEl.style.display = row.querySelector('.optionType').value === 'MISCELLANEOUS' ? '' : 'none';
}
function addOptionRow(optionType, amount, note){
  const list = document.getElementById('optionsList');
  const row = document.createElement('div');
  row.className = 'optionRow';
  row.style.cssText = 'display:flex;gap:8px;margin-bottom:6px;';
  row.innerHTML = `<select class="optionType" style="flex:2;"><option value="">— select option —</option>${[...ADDITIONAL_OPTIONS].sort((a,b)=>a.localeCompare(b)).map(o=>`<option value="${o.replace(/"/g,'&quot;')}">${o}</option>`).join('')}</select>
    <input type="number" class="optionAmount" value="${amount ?? ''}" placeholder="Amount (S$)" step="any" style="flex:1;">
    <input type="text" class="optionNote" value="${(note ?? '').replace(/"/g,'&quot;')}" placeholder="Describe item…" style="flex:2;">
    <button type="button" class="btn secondary removeRowBtn" style="padding:6px 10px;flex:0 0 auto;">✕</button>`;
  row.querySelector('.optionType').value = optionType || '';
  row.querySelector('.removeRowBtn').addEventListener('click', ()=>{ row.remove(); recalc(); });
  row.querySelector('.optionAmount').addEventListener('input', recalc);
  row.querySelector('.optionType').addEventListener('change', ()=>{ applyOptionRate(row); updateOptionNoteVisibility(row); });
  updateOptionNoteVisibility(row);
  list.appendChild(row);
}
document.getElementById('addOptionBtn').addEventListener('click', ()=>addOptionRow('',''));

// Company Fund defaults to Total Cost − Driver Payout, but is editable —
// once the user types into it directly, stop overwriting their value.
let coyFundEdited = false;
function recalc(){
  const qty = Number(document.getElementById('f_qty').value)||0;
  const unitCost = Number(document.getElementById('f_unitCost').value)||0;
  const cost = qty*unitCost + sumExtras();
  document.getElementById('f_cost').value = cost || '';

  const payout = Number(document.getElementById('f_payout').value)||0;
  if(!coyFundEdited) document.getElementById('f_coyFund').value = cost ? (cost - payout).toFixed(2) : '';
}
['f_qty','f_unitCost','f_payout'].forEach(id=>document.getElementById(id).addEventListener('input', recalc));
document.getElementById('f_coyFund').addEventListener('input', ()=>{ coyFundEdited = true; });

// For HOURLY job types, derive Qty from Start/End time (billed in whole-hour blocks, rounded up)
function isHourlyJobType(jt){
  return !!jt && jt.toUpperCase().includes('HOURLY');
}
// TOUR GUIDE assignees are guides, not drivers — don't label them as DRIVER in trip details.
function isTourGuideJobType(jt){
  return !!jt && jt.toUpperCase().includes('TOUR GUIDE');
}
function toggleQtyHint(){
  const hint = document.getElementById('qtyHint');
  if(hint) hint.style.display = isHourlyJobType(document.getElementById('f_jobType').value) ? '' : 'none';
}
function updateQtyFromTime(){
  const jt = document.getElementById('f_jobType').value;
  const qtyField = document.getElementById('f_qty');
  toggleQtyHint();
  if(!isHourlyJobType(jt)) return;
  const start = document.getElementById('f_start').value;
  const end = document.getElementById('f_end').value;
  if(!start || !end) return;
  const [sh,sm] = start.split(':').map(Number);
  const [eh,em] = end.split(':').map(Number);
  let diff = (eh*60+em) - (sh*60+sm);
  if(diff <= 0) diff += 24*60; // job runs past midnight
  const hours = diff/60;
  const qty = Math.max(1, Math.ceil(hours - 1e-9)); // round up to next full hour block
  qtyField.value = qty;
  recalc();
}
wireTimeMask(document.getElementById('f_start'));
wireTimeMask(document.getElementById('f_end'));
['f_start','f_end','f_jobType'].forEach(id=>document.getElementById(id).addEventListener('change', updateQtyFromTime));

// ---------- Rate card: Job Type (+ Vehicle Type where the rate varies by vehicle) -> Unit Cost ----------
// RATE_MAP comes from workspace-config.js (picks MAERSK vs Non-MAERSK pricing based on ?ws=).
function getRateMapping(jobType){
  const key = (jobType||'').trim();
  if(RATE_MAP[key]) return RATE_MAP[key];
  const custom = DATA.rates.find(r=>r.jobType===key);
  return custom && custom.unitPrice != null ? {flat: Number(custom.unitPrice)} : null;
}
function setUnitCostHint(show){
  const hint = document.getElementById('unitCostHint');
  if(hint) hint.style.display = show ? '' : 'none';
}
function refreshVehicleField(jobType){
  const wrap = document.getElementById('vehicleFieldWrap');
  const sel = document.getElementById('f_vehicle');
  const map = getRateMapping(jobType);
  if(map && map.byVehicle){
    fillSelect(sel, Object.keys(map.byVehicle), '— select vehicle —');
    wrap.style.display = '';
  } else {
    sel.innerHTML = '';
    wrap.style.display = 'none';
  }
}
// ELITE lets drivers/staff override Unit Cost from the rate card once they've
// typed into it directly; MAERSK keeps the rate card authoritative.
let unitCostEdited = false;
function applyRateToUnitCost(){
  const jobType = document.getElementById('f_jobType').value;
  const map = getRateMapping(jobType);
  if(!map){ setUnitCostHint(false); return; }
  if(WORKSPACE === 'nonmaersk' && unitCostEdited){ setUnitCostHint(true); return; }
  if(map.flat != null){
    document.getElementById('f_unitCost').value = map.flat;
    setUnitCostHint(true);
    recalc();
  } else if(map.byVehicle){
    const vehicle = document.getElementById('f_vehicle').value;
    if(vehicle && map.byVehicle[vehicle] != null){
      document.getElementById('f_unitCost').value = map.byVehicle[vehicle];
      setUnitCostHint(true);
      recalc();
    } else {
      setUnitCostHint(false);
    }
  }
}
document.getElementById('f_unitCost').addEventListener('input', ()=>{ unitCostEdited = true; });
document.getElementById('f_jobType').addEventListener('change', ()=>{
  refreshVehicleField(document.getElementById('f_jobType').value);
  applyRateToUnitCost();
});
document.getElementById('f_vehicle').addEventListener('change', applyRateToUnitCost);

async function openJobModal(id){
  editingId = id || null;
  coyFundEdited = false;
  const job = id ? DATA.jobs.find(j=>j.id===id) : null;
  document.getElementById('jobModalTitle').textContent = job ? 'Edit Job' : 'New Job';
  document.getElementById('deleteJobBtn').style.display = job ? '' : 'none';
  setupModalOptions(job?.driver, job?.hostName);

  setDate('f_date', job?.date || '');
  document.getElementById('f_invoice').value = job?.invoice || '';
  document.getElementById('f_driver').value = job?.driver || '';
  document.getElementById('f_jobType').value = job?.jobType || '';
  refreshVehicleField(job?.jobType);
  document.getElementById('f_vehicle').value = job?.vehicle || '';
  setUnitCostHint(!!getRateMapping(job?.jobType));
  {
    const rateMap = getRateMapping(job?.jobType);
    const defaultUnitCost = rateMap ? (rateMap.flat ?? (rateMap.byVehicle ? rateMap.byVehicle[job?.vehicle] : null)) : null;
    unitCostEdited = !!job && defaultUnitCost != null && Number(job.unitCost) !== Number(defaultUnitCost);
  }
  document.getElementById('f_client').value = job?.hostName || '';
  document.getElementById('f_company').value = job?.company || '';
  document.getElementById('f_costCentre').value = job?.costCentre || '';
  document.getElementById('f_uid').value = job?.uid || '';
  document.getElementById('f_pax').value = job ? (extractPax(job.details) || '') : '';
  document.getElementById('f_details').value = job ? extractRoute(job.details) : '';
  document.getElementById('f_start').value = job?.startTime || '';
  document.getElementById('f_end').value = job?.endTime || '';
  document.getElementById('f_qty').value = job?.qty ?? 1;
  document.getElementById('f_unitCost').value = job?.unitCost ?? '';
  document.getElementById('f_cost').value = job?.cost ?? '';
  document.getElementById('f_payout').value = job?.driverPayout ?? '';
  document.getElementById('f_coyFund').value = job?.coyFund ?? '';
  const expectedCoyFund = (Number(job?.cost)||0) - (Number(job?.driverPayout)||0);
  coyFundEdited = !!job && Math.abs((Number(job.coyFund)||0) - expectedCoyFund) > 0.005;
  if(WORKSPACE === 'nonmaersk') document.getElementById('f_payoutAlan').value = job?.payoutAlan ?? '';
  document.getElementById('f_status').value = (job?.paymentStatus || 'UNPAID').toUpperCase();
  document.getElementById('f_remarks').value = job?.remarks || '';
  toggleQtyHint();

  document.getElementById('optionsList').innerHTML = '';
  if(id){
    const {data: options} = await sb.from(TBL.job_options).select('*').eq('job_id', id).order('id');
    (options||[]).forEach(o=>addOptionRow(o.optionType, o.amount, o.note));
  }
  recalc();

  document.getElementById('jobModalBg').classList.add('active');
}
function closeJobModal(){
  document.getElementById('jobModalBg').classList.remove('active');
  editingId = null;
}
document.getElementById('addJobBtn').addEventListener('click', ()=>openJobModal(null));
document.getElementById('cancelJobBtn').addEventListener('click', closeJobModal);
document.getElementById('jobModalBg').addEventListener('click', (e)=>{ if(e.target.id==='jobModalBg') closeJobModal(); });

function buildTripDetails({hostName, uid, costCentre, pax, itinerary, driver, startTime, endTime, jobType}){
  const lines = [];
  lines.push(`REQUESTOR: ${hostName||''}`);
  lines.push(`UID: ${uid||''}`);
  lines.push(`COST CENTRE: ${costCentre||''}`);
  lines.push(`PAX: ${pax||''}`);
  if(itinerary) lines.push(itinerary);
  const d = DATA.drivers.find(x=>x.name===driver);
  const plate = d?.plate || '';
  if(!isTourGuideJobType(jobType)) lines.push(`DRIVER: ${driver||''}${plate?` (${plate})`:''}`);
  if(isHourlyJobType(jobType)){
    if(startTime){
      const s = startTime.replace(':','');
      const e = endTime ? endTime.replace(':','') : '';
      lines.push(`TIME: ${s}${e?` - ${e}`:''}`);
    } else {
      lines.push('TIME: ');
    }
  }
  return lines.join('\n');
}

async function syncStopsAndExtras(jobId){
  const options = [...document.querySelectorAll('#optionsList .optionRow')]
    .map(row=>({
      job_id: jobId,
      optionType: row.querySelector('.optionType').value,
      amount: Number(row.querySelector('.optionAmount').value)||0,
      note: row.querySelector('.optionNote').value.trim() || null,
    }))
    .filter(o=>o.optionType);

  await sb.from(TBL.job_options).delete().eq('job_id', jobId);
  if(options.length) await sb.from(TBL.job_options).insert(options);
}

document.getElementById('saveJobBtn').addEventListener('click', async ()=>{
  const uid = document.getElementById('f_uid').value;
  const pax = document.getElementById('f_pax').value;
  const itinerary = document.getElementById('f_details').value;
  const hostName = document.getElementById('f_client').value;
  const driver = document.getElementById('f_driver').value;
  const startTime = document.getElementById('f_start').value;
  const endTime = document.getElementById('f_end').value;
  const job = {
    date: getDate('f_date'),
    invoice: document.getElementById('f_invoice').value,
    driver,
    jobType: document.getElementById('f_jobType').value,
    vehicle: document.getElementById('f_vehicle').value,
    hostName,
    company: document.getElementById('f_company').value,
    costCentre: document.getElementById('f_costCentre').value,
    uid,
    details: buildTripDetails({hostName, uid, costCentre: document.getElementById('f_costCentre').value, pax, itinerary, driver, startTime, endTime, jobType: document.getElementById('f_jobType').value}),
    startTime,
    endTime,
    qty: Number(document.getElementById('f_qty').value)||0,
    unitCost: Number(document.getElementById('f_unitCost').value)||0,
    cost: Number(document.getElementById('f_cost').value)||0,
    driverPayout: Number(document.getElementById('f_payout').value)||0,
    coyFund: Number(document.getElementById('f_coyFund').value)||0,
    paymentStatus: document.getElementById('f_status').value,
    remarks: document.getElementById('f_remarks').value,
  };
  if(WORKSPACE === 'nonmaersk') job.payoutAlan = Number(document.getElementById('f_payoutAlan').value)||0;
  if(!job.date){ alert('Please set a date.'); return; }
  if(editingId){
    job.id = editingId;
    const {error} = await sb.from(TBL.jobs).update(job).eq('id', editingId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.jobs.findIndex(j=>j.id===editingId);
    DATA.jobs[idx] = job;
  } else {
    const {data, error} = await sb.from(TBL.jobs).insert(job).select();
    if(error){ alert('Save failed: '+error.message); return; }
    job.id = data[0].id;
    DATA.jobs.push(job);
  }
  await syncStopsAndExtras(job.id);
  closeJobModal();
  renderAll();
});
document.getElementById('deleteJobBtn').addEventListener('click', async ()=>{
  if(!editingId) return;
  if(!confirm('Delete this job entry?')) return;
  try{
    const {error: optErr} = await sb.from(TBL.job_options).delete().eq('job_id', editingId);
    if(optErr){ alert('Delete failed (removing options): '+optErr.message); return; }
    const {error} = await sb.from(TBL.jobs).delete().eq('id', editingId);
    if(error){ alert('Delete failed: '+error.message); return; }
    DATA.jobs = DATA.jobs.filter(j=>j.id!==editingId);
    closeJobModal();
    renderAll();
  } catch(err){
    alert('Delete failed (unexpected error): '+(err?.message || err));
  }
});

// ---------- Export CSV ----------
document.getElementById('exportBtn').addEventListener('click', ()=>{
  const cols = ['date','invoice','driver','jobType','vehicle','details','startTime','endTime','duration','qty','unitCost','cost','driverPayout','coyFund','remarks','paymentStatus','hostName','company','uid','costCentre'];
  const header = cols.join(',');
  const esc = v => `"${String(v==null?'':v).replace(/"/g,'""')}"`;
  const rows = DATA.jobs.slice().sort((a,b)=>new Date(a.date)-new Date(b.date)).map(j=>cols.map(c=>esc(j[c])).join(','));
  const csv = [header, ...rows].join('\n');
  const blob = new Blob(['﻿'+csv], {type:'text/csv;charset=utf-8'});
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  a.download = 'eliteskyline_job_log.csv';
  a.click();
});

// ---------- MAERSK Summary ----------
const MAERSK_SUMMARY_COMPANY = 'MAERSK SINGAPORE PTE LTD';
let maerskFiltersDefaulted = false;

function getMaerskJobs(){
  return DATA.jobs.filter(j=>(j.company||'').trim().toUpperCase() === MAERSK_SUMMARY_COMPANY
    && (j.costCentre||'').trim().toUpperCase().startsWith('SG51'));
}

function populateMaerskFilterOptions(){
  const maerskJobs = getMaerskJobs();
  const fYear = document.getElementById('fMaerskYear');
  const years = [...new Set(maerskJobs.map(j=>j.date).filter(Boolean).map(d=>d.slice(0,4)))].sort();
  if(fYear.options.length<=1){
    years.forEach(y=>{const o=document.createElement('option');o.value=y;o.textContent=y;fYear.appendChild(o);});
  }
  const fMonth = document.getElementById('fMaerskMonth');
  if(fMonth.options.length<=1){
    MONTHS.forEach((m,i)=>{const o=document.createElement('option');o.value=String(i+1).padStart(2,'0');o.textContent=m;fMonth.appendChild(o);});
  }
  if(!maerskFiltersDefaulted && maerskJobs.length){
    const latestDate = maerskJobs.map(j=>j.date).filter(Boolean).sort().slice(-1)[0];
    if(latestDate){
      fYear.value = latestDate.slice(0,4);
      fMonth.value = latestDate.slice(5,7);
    }
    maerskFiltersDefaulted = true;
  }
}

function renderMaerskSummary(){
  populateMaerskFilterOptions();
  const year = document.getElementById('fMaerskYear').value;
  const month = document.getElementById('fMaerskMonth').value;

  let rows = getMaerskJobs();
  if(year) rows = rows.filter(j=>(j.date||'').slice(0,4)===year);
  if(month) rows = rows.filter(j=>(j.date||'').slice(5,7)===month);
  rows.sort((a,b)=> (a.date||'').localeCompare(b.date||'') || (a.id-b.id));

  const totalSales = rows.reduce((s,j)=>s+(Number(j.cost)||0),0);
  const totalPayout = rows.reduce((s,j)=>s+(Number(j.driverPayout)||0),0);
  const totalCoy = rows.reduce((s,j)=>s+(Number(j.coyFund)||0),0);
  document.getElementById('maerskCards').innerHTML = `
    <div class="card"><div class="label">MAERSK Jobs</div><div class="value">${rows.length}</div></div>
    <div class="card"><div class="label">Total Sales</div><div class="value">${fmtMoney(totalSales)}</div></div>
    <div class="card"><div class="label">Driver Payout</div><div class="value">${fmtMoney(totalPayout)}</div></div>
    <div class="card"><div class="label">Company Fund</div><div class="value">${fmtMoney(totalCoy)}</div></div>
  `;

  document.getElementById('maerskCount').textContent = `${rows.length} job${rows.length===1?'':'s'}`;
  const {items:pageRows, page, totalPages} = paginate('maersk', rows);
  document.querySelector('#maerskTable tbody').innerHTML = pageRows.length ? pageRows.map(j=>`
    <tr>
      <td>${fmtDate(j.date)}</td>
      <td>${j.invoice||''}</td>
      <td class="driver-cell">${j.driver||''}</td>
      <td class="jobtype-cell">${j.jobType||''}</td>
      <td class="host-cell">${j.hostName||''}</td>
      <td>${j.uid||''}</td>
      <td>${j.costCentre||''}</td>
      <td class="details-cell">${j.details ? `<details class="route"><summary>View</summary><div class="details-text">${escHtml(j.details)}</div></details>` : ''}</td>
      <td class="num">${j.qty ?? ''}</td>
      <td class="num">${fmtMoney(j.unitCost)}</td>
      <td class="num">${fmtMoney(j.cost)}</td>
    </tr>`).join('') : `<tr><td colspan="11" class="empty">No MAERSK SINGAPORE PTE LTD jobs found</td></tr>`;
  renderPagination('maerskPagination', 'maersk', page, totalPages, renderMaerskSummary);
}
document.getElementById('fMaerskYear').addEventListener('change', ()=>{ pageState.maersk=1; renderMaerskSummary(); });
document.getElementById('fMaerskMonth').addEventListener('change', ()=>{ pageState.maersk=1; renderMaerskSummary(); });

document.getElementById('exportMaerskBtn').addEventListener('click', ()=>{
  const year = document.getElementById('fMaerskYear').value;
  const month = document.getElementById('fMaerskMonth').value;
  let rows = getMaerskJobs();
  if(year) rows = rows.filter(j=>(j.date||'').slice(0,4)===year);
  if(month) rows = rows.filter(j=>(j.date||'').slice(5,7)===month);
  rows.sort((a,b)=> (a.date||'').localeCompare(b.date||'') || (a.id-b.id));

  if(!rows.length){ alert('No MAERSK SINGAPORE PTE LTD jobs match the current filter.'); return; }

  const cols = ['date','invoice','driver','jobType','hostName','uid','costCentre','details','qty','unitCost','cost','driverPayout','coyFund','paymentStatus','remarks'];
  const headerLabels = ['Date','Invoice #','Driver','Job Type','Host','UID','Cost Centre','Trip Details','Qty','Unit Cost','Cost','Driver Payout','Company Fund','Payment Status','Remarks'];
  const header = headerLabels.map(csvField).join(',');
  const dataRows = rows.map(j=>cols.map(c=>csvField(c==='date'?fmtDate(j[c]):j[c])).join(','));
  const csv = [header, ...dataRows].join('\n');
  const blob = new Blob(['﻿'+csv], {type:'text/csv;charset=utf-8'});
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  const label = month ? `${year||''}${month}` : (year||'ALL');
  a.download = `MAERSK_SINGAPORE_Summary_${label}.csv`;
  a.click();
});

// ---------- Render all ----------
function renderAll(){
  renderDashboard();
  renderJobs();
  renderInvoices();
  renderDrivers();
  renderClients();
  renderRates();
  renderMaerskSummary();
}
// Initial render handled by initApp() after auth check
