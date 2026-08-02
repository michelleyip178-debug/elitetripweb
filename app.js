const SUPABASE_URL = 'https://ctdtmwoztughpagavrsp.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN0ZHRtd296dHVnaHBhZ2F2cnNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU1MzE3MDcsImV4cCI6MjEwMTEwNzcwN30.Rktv2pV1gE9LUi3Hr69C3YpaWBLvzwwI1jksl-7LwiY';
const sb = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

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
  const [drivers, clients, jobTypes, rates, jobs] = await Promise.all([
    sb.from('drivers').select('*'),
    sb.from('clients').select('*'),
    sb.from('job_types').select('*'),
    sb.from('rates').select('*'),
    sb.from('jobs').select('*'),
  ]);
  if(drivers.error || clients.error || jobTypes.error || rates.error || jobs.error){
    console.error('Supabase load failed, falling back to seed data');
    return JSON.parse(JSON.stringify(window.SEED));
  }
  return {
    drivers: drivers.data,
    clients: clients.data,
    jobTypes: jobTypes.data.map(jt => jt.name),
    rates: rates.data,
    jobs: jobs.data,
  };
}

let DATA = { drivers:[], clients:[], jobTypes:[], rates:[], jobs:[] };
let editingId = null;
let editingDriverId = null;
let editingClientId = null;

function escHtml(s){ return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

// ---------- Pagination ----------
const PAGE_SIZE = 15;
const pageState = {};
function paginate(key, items){
  const totalPages = Math.max(1, Math.ceil(items.length / PAGE_SIZE));
  pageState[key] = Math.min(Math.max(1, pageState[key] || 1), totalPages);
  const page = pageState[key];
  const start = (page-1)*PAGE_SIZE;
  return { items: items.slice(start, start+PAGE_SIZE), page, totalPages };
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
 'c_hostName','c_uid','c_costCentre','c_company','c_code'
].forEach(id=>{
  const el = document.getElementById(id);
  if(el) wireUppercase(el);
});

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
function renderDashboard(){
  const jobs = DATA.jobs;
  const totalSales = jobs.reduce((s,j)=>s+(Number(j.cost)||0),0);
  const totalPayout = jobs.reduce((s,j)=>s+(Number(j.driverPayout)||0),0);
  const totalCoy = jobs.reduce((s,j)=>s+(Number(j.coyFund)||0),0);
  document.getElementById('headerSub').textContent = `${jobs.length} jobs logged · ${fmtMoney(totalSales)} total sales YTD`;

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
    const s = j.paymentStatus || 'Unpaid';
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

// ---------- Jobs table ----------
function populateFilterOptions(){
  const fMonth = document.getElementById('fMonth');
  if(fMonth.options.length<=1){
    MONTHS.forEach(m=>{const o=document.createElement('option');o.value=m;o.textContent=m+' 2026';fMonth.appendChild(o);});
  }
  const fDriver = document.getElementById('fDriver');
  if(fDriver.options.length<=1){
    DATA.drivers.map(d=>d.name).sort().forEach(n=>{const o=document.createElement('option');o.value=n;o.textContent=n;fDriver.appendChild(o);});
  }
}

function renderJobs(){
  populateFilterOptions();
  const month = document.getElementById('fMonth').value;
  const driver = document.getElementById('fDriver').value;
  const status = document.getElementById('fStatus').value;
  const search = document.getElementById('fSearch').value.toLowerCase();

  let jobs = DATA.jobs.slice().sort((a,b)=> new Date(b.date) - new Date(a.date) || (b.id-a.id));
  if(month) jobs = jobs.filter(j=>monthKey(j.date)===month);
  if(driver) jobs = jobs.filter(j=>j.driver===driver);
  if(status) jobs = jobs.filter(j=> statusClass(j.paymentStatus) === status.toLowerCase());
  if(search){
    jobs = jobs.filter(j=>[j.invoice,j.hostName,j.company,j.details,j.jobType].some(v=>(v||'').toLowerCase().includes(search)));
  }

  document.getElementById('jobsCount').textContent = `${jobs.length} job${jobs.length===1?'':'s'}`;

  const {items:pageJobs, page, totalPages} = paginate('jobs', jobs);
  const tbody = document.querySelector('#jobsTable tbody');
  tbody.innerHTML = pageJobs.length ? pageJobs.map(j=>`
    <tr>
      <td>${j.date||''}</td>
      <td>${j.invoice||''}</td>
      <td>${j.driver||''}</td>
      <td>${j.jobType||''}</td>
      <td>${j.hostName||''}${j.company?`<div class="small muted">${j.company}</div>`:''}</td>
      <td>${j.details ? `<details class="route"><summary>View</summary><div class="details-text">${escHtml(j.details)}</div></details>` : ''}</td>
      <td class="num">${fmtMoney(j.cost)}</td>
      <td class="num">${fmtMoney(j.driverPayout)}</td>
      <td class="num">${fmtMoney(j.coyFund)}</td>
      <td><span class="pill ${statusClass(j.paymentStatus)}">${j.paymentStatus||'Unpaid'}</span></td>
      <td class="row-actions"><button onclick="openJobModal(${j.id})">Edit</button></td>
    </tr>
  `).join('') : `<tr><td colspan="11" class="empty">No jobs match these filters</td></tr>`;
  renderPagination('jobsPagination', 'jobs', page, totalPages, renderJobs);
}

['fMonth','fDriver','fStatus'].forEach(id=>document.getElementById(id).addEventListener('change', ()=>{ pageState.jobs=1; renderJobs(); }));
document.getElementById('fSearch').addEventListener('input', ()=>{ pageState.jobs=1; renderJobs(); });

// ---------- Invoices ----------
const selectedInvoices = new Set();
function updateExportCount(){
  document.getElementById('exportInvoicesBtn').textContent = `Export to QuickBooks (${selectedInvoices.size})`;
}

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

  const year = fYear.value;
  const month = fMonth.value;
  const fDate = document.getElementById('fInvDate');
  const prevDate = fDate.value;
  let dates = [...new Set(DATA.jobs.map(j=>j.date).filter(Boolean))];
  if(year) dates = dates.filter(d=>d.slice(0,4)===year);
  if(month) dates = dates.filter(d=>d.slice(5,7)===month);
  dates.sort();
  fDate.innerHTML = '<option value="">All Dates</option>' + dates.map(d=>`<option value="${d}">${d}</option>`).join('');
  fDate.value = dates.includes(prevDate) ? prevDate : '';
}

function renderInvoices(){
  populateInvoiceFilterOptions();
  const search = document.getElementById('fInvSearch').value.toLowerCase();
  const year = document.getElementById('fInvYear').value;
  const month = document.getElementById('fInvMonth').value;
  const date = document.getElementById('fInvDate').value;
  const groups = {};
  DATA.jobs.forEach(j=>{
    const key = j.invoice || '(no invoice #)';
    groups[key] = groups[key] || {jobs:[], sales:0};
    groups[key].jobs.push(j);
    groups[key].sales += Number(j.cost)||0;
  });
  let rows = Object.entries(groups).map(([inv,g])=>{
    const dates = [...new Set(g.jobs.map(j=>j.date))].sort();
    const host = g.jobs[0].hostName || '';
    const company = g.jobs[0].company || '';
    const statuses = [...new Set(g.jobs.map(j=>j.paymentStatus||'Unpaid'))];
    return {inv, dates, host, company, count:g.jobs.length, sales:g.sales, statuses};
  });
  if(search){
    rows = rows.filter(r=>[r.inv,r.host,r.company].some(v=>(v||'').toLowerCase().includes(search)));
  }
  if(year){
    rows = rows.filter(r=>r.dates.some(d=>d.slice(0,4)===year));
  }
  if(month){
    rows = rows.filter(r=>r.dates.some(d=>d.slice(5,7)===month));
  }
  if(date){
    rows = rows.filter(r=>r.dates.includes(date));
  }
  rows.sort((a,b)=> (b.dates[0]||'').localeCompare(a.dates[0]||''));
  document.getElementById('invCount').textContent = `${rows.length} invoice${rows.length===1?'':'s'}`;
  const {items:pageRows, page, totalPages} = paginate('invoices', rows);
  document.querySelector('#invoicesTable tbody').innerHTML = pageRows.length ? pageRows.map(r=>{
    const exportable = r.inv !== '(no invoice #)';
    const checked = selectedInvoices.has(r.inv) ? 'checked' : '';
    return `
    <tr>
      <td>${exportable ? `<input type="checkbox" class="inv-check" data-inv="${encodeURIComponent(r.inv)}" ${checked}>` : ''}</td>
      <td>${r.dates.join(', ')}</td>
      <td>${r.inv}</td>
      <td>${r.host}${r.company?`<div class="small muted">${r.company}</div>`:''}</td>
      <td class="num">${r.count}</td>
      <td class="num">${fmtMoney(r.sales)}</td>
      <td>${r.statuses.map(s=>`<span class="pill ${statusClass(s)}">${s}</span>`).join(' ')}</td>
    </tr>`;
  }).join('') : `<tr><td colspan="7" class="empty">No invoices found</td></tr>`;
  renderPagination('invoicesPagination', 'invoices', page, totalPages, renderInvoices);
  const allChecked = pageRows.length>0 && pageRows.every(r=> r.inv==='(no invoice #)' || selectedInvoices.has(r.inv));
  document.getElementById('invSelectAll').checked = allChecked;
  updateExportCount();

  renderInvoiceItems(month, year, date, rows.map(r=>r.inv));
}
document.getElementById('fInvSearch').addEventListener('input', ()=>{ pageState.invoices=1; pageState.invItems=1; renderInvoices(); });
document.getElementById('fInvDate').addEventListener('change', ()=>{ pageState.invoices=1; pageState.invItems=1; renderInvoices(); });

function renderInvoiceItems(month, year, date, filteredInvNums){
  const panel = document.getElementById('invItemsPanel');
  if(!month && !date){
    panel.style.display = 'none';
    return;
  }
  const invSet = new Set(filteredInvNums);
  let items = DATA.jobs.filter(j=> invSet.has(j.invoice || '(no invoice #)'));
  if(date){
    items = items.filter(j=>j.date===date);
  }
  items = items.slice().sort((a,b)=> (a.date||'').localeCompare(b.date||'') || (a.id-b.id));

  const label = date ? date : (MONTHS[Number(month)-1] + (year ? ' '+year : ''));
  document.getElementById('invItemsTitle').textContent = `Line Items — ${label} (${items.length} item${items.length===1?'':'s'})`;
  const {items:pageItems, page, totalPages} = paginate('invItems', items);
  document.querySelector('#invItemsTable tbody').innerHTML = pageItems.length ? pageItems.map(j=>`
    <tr>
      <td>${j.date||''}</td>
      <td>${j.invoice||''}</td>
      <td>${j.driver||''}</td>
      <td>${j.jobType||''}</td>
      <td>${j.hostName||''}${j.company?`<div class="small muted">${j.company}</div>`:''}</td>
      <td>${j.details ? `<details class="route"><summary>View</summary><div class="details-text">${escHtml(j.details)}</div></details>` : ''}</td>
      <td class="num">${j.qty ?? ''}</td>
      <td class="num">${fmtMoney(j.unitCost)}</td>
      <td class="num">${fmtMoney(j.cost)}</td>
      <td><span class="pill ${statusClass(j.paymentStatus)}">${j.paymentStatus||'Unpaid'}</span></td>
      <td class="row-actions"><button onclick="openJobModal(${j.id})">Edit</button></td>
    </tr>`).join('') : `<tr><td colspan="11" class="empty">No line items</td></tr>`;
  renderPagination('invItemsPagination', 'invItems', page, totalPages, ()=>renderInvoiceItems(month, year, date, filteredInvNums));
  panel.style.display = '';
}
document.getElementById('fInvYear').addEventListener('change', ()=>{ pageState.invoices=1; pageState.invItems=1; renderInvoices(); });
document.getElementById('fInvMonth').addEventListener('change', ()=>{ pageState.invoices=1; pageState.invItems=1; renderInvoices(); });

document.querySelector('#invoicesTable tbody').addEventListener('change', e=>{
  if(e.target.matches('.inv-check')){
    const inv = decodeURIComponent(e.target.dataset.inv);
    if(e.target.checked) selectedInvoices.add(inv); else selectedInvoices.delete(inv);
    updateExportCount();
    document.getElementById('invSelectAll').checked = [...document.querySelectorAll('.inv-check')].every(c=>c.checked);
  }
});
document.getElementById('invSelectAll').addEventListener('change', e=>{
  document.querySelectorAll('.inv-check').forEach(c=>{
    const inv = decodeURIComponent(c.dataset.inv);
    c.checked = e.target.checked;
    if(e.target.checked) selectedInvoices.add(inv); else selectedInvoices.delete(inv);
  });
  updateExportCount();
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
    const {error} = await sb.from('jobs').update({invoice:a.invNum}).in('id', ids);
    if(error){ alert('Failed to assign invoice '+a.invNum+': '+error.message); return; }
    a.jobs.forEach(j=>{ j.invoice = a.invNum; });
  }
  renderAll();
  alert(`Assigned ${assignments.length} invoice number(s).`);
}
document.getElementById('autoAssignBtn').addEventListener('click', autoAssignInvoiceNumbers);

// ---------- QuickBooks CSV export ----------
const QB_MONTH_NAMES = ['JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY','AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'];
function pad2(n){ return String(n).padStart(2,'0'); }
function toMDY(dateStr){
  if(!dateStr) return '';
  const [y,m,d] = dateStr.split('-');
  return `${m}/${d}/${y}`;
}
function addDaysMDY(dateStr, days){
  const d = new Date(dateStr+'T00:00:00');
  d.setDate(d.getDate()+days);
  return `${pad2(d.getMonth()+1)}/${pad2(d.getDate())}/${d.getFullYear()}`;
}
function extractRoute(text){
  if(!text) return '';
  return text.split('\n').filter(l=>!/^\s*(REQUESTOR|UID|COST CENTRE|DRIVER|PAX|TIME)\s*:/i.test(l)).join('\n').trim();
}
function extractPax(text){
  const m = (text||'').match(/^\s*PAX\s*:\s*(.+)$/im);
  return m ? m[1].trim() : null;
}
function buildItemDescription(job){
  const lines = [];
  if(job.hostName) lines.push(`REQUESTOR: ${job.hostName}`);
  if(job.uid) lines.push(`UID: ${job.uid}`);
  if(job.costCentre) lines.push(`COST CENTRE: ${job.costCentre}`);
  const route = extractRoute(job.details);
  if(route) lines.push(route);
  const pax = extractPax(job.details);
  if(pax) lines.push(`PAX: ${pax}`);
  if(job.driver){
    const d = DATA.drivers.find(x=>x.name===job.driver);
    const plate = job.vehicle && !d ? job.vehicle : (d?.plate || '');
    lines.push(`DRIVER: ${job.driver}${plate?` (${plate})`:''}`);
  }
  if(job.startTime){
    const s = job.startTime.replace(':','');
    const e = job.endTime ? job.endTime.replace(':','') : '';
    lines.push(`TIME: ${s}${e?` - ${e}`:''}`);
  }
  return lines.join('\n');
}
function csvField(v){
  v = v==null ? '' : String(v);
  if(/[",\n]/.test(v)) return '"'+v.replace(/"/g,'""')+'"';
  return v;
}
function buildQuickbooksCSV(invoiceSet){
  const HEADER = ['*InvoiceNo','*Customer','*InvoiceDate','*DueDate','Terms','Location','Memo','Item(Product/Service)','ItemDescription','ItemQuantity','ItemRate','*ItemAmount','*ItemTaxCode','ItemTaxAmount','Service Date'];
  const rows = [HEADER];
  const invNums = [...invoiceSet].filter(inv=>inv!=='(no invoice #)').sort();
  invNums.forEach(inv=>{
    const jobs = DATA.jobs.filter(j=>j.invoice===inv).slice().sort((a,b)=> (a.date||'').localeCompare(b.date||'') || (a.id-b.id));
    if(!jobs.length) return;
    const company = jobs[0].company || '';
    const dates = jobs.map(j=>j.date).filter(Boolean);
    const invDate = dates.length ? dates.reduce((a,b)=>a<b?a:b) : '';
    const invDateFmt = toMDY(invDate);
    const dueDateFmt = invDate ? addDaysMDY(invDate,30) : '';
    let memo = '';
    if(invDate){
      const [y,m] = invDate.split('-');
      memo = `MAERSK TRANSPORT — ${QB_MONTH_NAMES[Number(m)-1]} ${y}`;
    }
    jobs.forEach((j,idx)=>{
      rows.push([
        inv,
        idx===0?company:'',
        idx===0?invDateFmt:'',
        idx===0?dueDateFmt:'',
        idx===0?'NET 30':'',
        '',
        idx===0?memo:'',
        'TRANSPORT SERVICE',
        buildItemDescription(j),
        j.qty ?? '',
        Number(j.unitCost||0).toFixed(2),
        Number(j.cost||0).toFixed(2),
        '0% OS',
        '0',
        toMDY(j.date)
      ]);
    });
  });
  return rows.map(r=>r.map(csvField).join(',')).join('\n');
}
document.getElementById('exportInvoicesBtn').addEventListener('click', ()=>{
  if(selectedInvoices.size===0){ alert('Select at least one invoice to export.'); return; }
  const csv = buildQuickbooksCSV(selectedInvoices);
  const blob = new Blob(['﻿'+csv], {type:'text/csv;charset=utf-8'});
  const a = document.createElement('a');
  a.href = URL.createObjectURL(blob);
  const stamp = new Date().toISOString().slice(0,10);
  a.download = `QB_Invoice_Import_${stamp}.csv`;
  a.click();
});

// ---------- Drivers ----------
function renderDrivers(){
  const byDriver = {};
  DATA.jobs.forEach(j=>{
    if(!j.driver) return;
    byDriver[j.driver] = byDriver[j.driver] || {jobs:0, payout:0};
    byDriver[j.driver].jobs++;
    byDriver[j.driver].payout += Number(j.driverPayout)||0;
  });
  const rows = DATA.drivers.slice().sort((a,b)=>a.name.localeCompare(b.name));
  const {items:pageRows, page, totalPages} = paginate('drivers', rows);
  document.querySelector('#driversTable tbody').innerHTML = pageRows.length ? pageRows.map(d=>{
    const stat = byDriver[d.name] || {jobs:0,payout:0};
    return `<tr>
      <td>${d.name}</td>
      <td>${d.vehicle||''}</td>
      <td>${d.plate||''}</td>
      <td>${d.phone||''}</td>
      <td>${d.rateNote!=null?d.rateNote:''}</td>
      <td class="num">${stat.jobs}</td>
      <td class="num">${fmtMoney(stat.payout)}</td>
      <td class="row-actions"><button onclick="openDriverModal(${d.id})">Edit</button></td>
    </tr>`;
  }).join('') : `<tr><td colspan="8" class="empty">No drivers yet</td></tr>`;
  renderPagination('driversPagination', 'drivers', page, totalPages, renderDrivers);
}

function openDriverModal(id){
  editingDriverId = id || null;
  const d = id ? DATA.drivers.find(x=>x.id===id) : null;
  document.getElementById('driverModalTitle').textContent = d ? 'Edit Driver' : 'New Driver';
  document.getElementById('deleteDriverBtn').style.display = d ? '' : 'none';
  document.getElementById('d_name').value = d?.name || '';
  document.getElementById('d_vehicle').value = d?.vehicle || '';
  document.getElementById('d_plate').value = d?.plate || '';
  document.getElementById('d_phone').value = d?.phone || '';
  document.getElementById('d_rateNote').value = d?.rateNote ?? '';
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
  };
  if(!driver.name){ alert('Please enter a driver name.'); return; }
  if(editingDriverId){
    const {error} = await sb.from('drivers').update(driver).eq('id', editingDriverId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.drivers.findIndex(d=>d.id===editingDriverId);
    DATA.drivers[idx] = {...driver, id: editingDriverId};
  } else {
    const {data, error} = await sb.from('drivers').insert(driver).select();
    if(error){ alert('Save failed: '+error.message); return; }
    DATA.drivers.push(data[0]);
  }
  closeDriverModal();
  renderAll();
});
document.getElementById('deleteDriverBtn').addEventListener('click', async ()=>{
  if(!editingDriverId) return;
  if(!confirm('Delete this driver?')) return;
  const {error} = await sb.from('drivers').delete().eq('id', editingDriverId);
  if(error){ alert('Delete failed: '+error.message); return; }
  DATA.drivers = DATA.drivers.filter(d=>d.id!==editingDriverId);
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
  };
  if(!client.hostName){ alert('Please enter a host name.'); return; }
  if(editingClientId){
    const {error} = await sb.from('clients').update(client).eq('id', editingClientId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.clients.findIndex(c=>c.id===editingClientId);
    DATA.clients[idx] = {...client, id: editingClientId};
  } else {
    const {data, error} = await sb.from('clients').insert(client).select();
    if(error){ alert('Save failed: '+error.message); return; }
    DATA.clients.push(data[0]);
  }
  closeClientModal();
  renderAll();
});
document.getElementById('deleteClientBtn').addEventListener('click', async ()=>{
  if(!editingClientId) return;
  if(!confirm('Delete this client?')) return;
  const {error} = await sb.from('clients').delete().eq('id', editingClientId);
  if(error){ alert('Delete failed: '+error.message); return; }
  DATA.clients = DATA.clients.filter(c=>c.id!==editingClientId);
  closeClientModal();
  renderAll();
});

// ---------- Job types / rates ----------
function renderRates(){
  const {items:pageRows, page, totalPages} = paginate('rates', DATA.rates);
  document.querySelector('#ratesTable tbody').innerHTML = pageRows.map(r=>`
    <tr><td>${r.jobType}</td><td class="num">${r.unitPrice}</td><td>${r.billingUnit||''}</td></tr>
  `).join('');
  renderPagination('ratesPagination', 'rates', page, totalPages, renderRates);
}

// ---------- Modal / form ----------
function fillSelect(sel, values, placeholder){
  sel.innerHTML = (placeholder?`<option value="">${placeholder}</option>`:'') + values.map(v=>`<option value="${v.replace(/"/g,'&quot;')}">${v}</option>`).join('');
}

function setupModalOptions(){
  fillSelect(document.getElementById('f_driver'), DATA.drivers.map(d=>d.name).sort(), '— select driver —');
  fillSelect(document.getElementById('f_jobType'), DATA.jobTypes, '— select job type —');
  fillSelect(document.getElementById('f_client'), DATA.clients.map(c=>c.hostName).sort(), '— select or leave blank —');
}

document.getElementById('f_client').addEventListener('change', (e)=>{
  const c = DATA.clients.find(c=>c.hostName===e.target.value);
  if(c){
    document.getElementById('f_company').value = c.company||'';
    document.getElementById('f_costCentre').value = c.costCentre||'';
    document.getElementById('f_uid').value = c.uid||'';
  }
});

// Driver keeps $10 deducted per billed unit (hour/trip/stop) as the company fund cut.
const PAYOUT_DEDUCTION_PER_UNIT = 10;

function recalc(){
  const qty = Number(document.getElementById('f_qty').value)||0;
  const unitCost = Number(document.getElementById('f_unitCost').value)||0;
  const cost = qty*unitCost;
  document.getElementById('f_cost').value = cost || '';
  const payout = Math.max(0, cost - (qty*PAYOUT_DEDUCTION_PER_UNIT));
  document.getElementById('f_payout').value = cost ? payout.toFixed(2) : '';
  const coyFund = cost - (cost ? payout : 0);
  document.getElementById('f_coyFund').value = coyFund.toFixed(2);
}
['f_qty','f_unitCost'].forEach(id=>document.getElementById(id).addEventListener('input', recalc));

// For HOURLY job types, derive Qty from Start/End time (billed in whole-hour blocks, rounded up)
function isHourlyJobType(jt){
  return !!jt && jt.toUpperCase().includes('HOURLY');
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
// Built from the "QB Job Types" rate sheet, mapped onto the generic Job Type list used for entry.
const RATE_MAP = {
  'ADDITIONAL STOP (LOCAL)': { flat: 30 },
  'ADDITIONAL STOP (MALAYSIA)': { flat: 30 },
  'ADDITIONAL STOP (WITHIN 3KM)(23/45 SEATER)': { flat: 30 },
  'ADDITIONAL STOP (WITHIN 3KM)(SALOON/MPV/COMBI)': { flat: 15 },
  'ARRIVAL (MEET & GREET)': { byVehicle: { 'MINI VAN':90, 'MPV/ALPHARD':90, 'SALOON':70 } },
  'CANCELLATION (100%)': { flat: 140 },
  'CANCELLATION (50%)': { flat: 70 },
  'DEPARTURE': { byVehicle: { 'MINI VAN':80, 'MPV/ALPHARD':80, 'SALOON':60 } },
  'HOURLY (LOCAL)': { byVehicle: { 'LARGE BUS':100, 'MINI BUS':90, 'MINI VAN':70, 'MPV/ALPHARD':70, 'SALOON':60 } },
  'HOURLY (MALAYSIA)': { byVehicle: { 'MINI VAN':80, 'MPV/ALPHARD':90, 'SALOON':70 } },
  'MIDNIGHT SURCHARGE (LOCAL)': { flat: 15 },
  'MIDNIGHT SURCHARGE (MALAYSIA)': { flat: 20 },
  'TOUR GUIDE (MIN 2)': { flat: 50 },
  'TRANSFER (CROSS BORDER)(MINI VAN)': { flat: 160 },
  'TRANSFER (CROSS BORDER)(MPV)': { flat: 170 },
  'TRANSFER (CROSS BORDER)(SALOON)': { flat: 150 },
  'TRANSFER (LOCAL)': { byVehicle: { 'LARGE BUS':160, 'MINI BUS':130, 'MINI VAN':70, 'MPV/ALPHARD':70, 'SALOON':55 } },
  'TRANSFER (TUAS)': { byVehicle: { 'LARGE BUS':185, 'MINI BUS':150, 'MINI VAN':90, 'MPV/ALPHARD':90, 'SALOON':80 } },
  'WAITING CHARGE (15 MINS/BLOCK)': { flat: 20 },
  'WAITING CHARGE (15 MINS/BLOCK) (MALAYSIA)': { flat: 25 },
  // ADDITIONAL CHARGE, ARRIVAL (DRIVE WAY PICK UP), CANCELLATION (25%), DISPOSAL, MISCELLANEOUS:
  // no fixed rate on file — unit cost stays manual for these.
};
function getRateMapping(jobType){
  return RATE_MAP[(jobType||'').trim()] || null;
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
function applyRateToUnitCost(){
  const jobType = document.getElementById('f_jobType').value;
  const map = getRateMapping(jobType);
  if(!map){ setUnitCostHint(false); return; }
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
document.getElementById('f_jobType').addEventListener('change', ()=>{
  refreshVehicleField(document.getElementById('f_jobType').value);
  applyRateToUnitCost();
});
document.getElementById('f_vehicle').addEventListener('change', applyRateToUnitCost);

function openJobModal(id){
  editingId = id || null;
  const job = id ? DATA.jobs.find(j=>j.id===id) : null;
  document.getElementById('jobModalTitle').textContent = job ? 'Edit Job' : 'New Job';
  document.getElementById('deleteJobBtn').style.display = job ? '' : 'none';
  setupModalOptions();

  document.getElementById('f_date').value = job?.date || '';
  document.getElementById('f_invoice').value = job?.invoice || '';
  document.getElementById('f_driver').value = job?.driver || '';
  document.getElementById('f_jobType').value = job?.jobType || '';
  refreshVehicleField(job?.jobType);
  document.getElementById('f_vehicle').value = job?.vehicle || '';
  setUnitCostHint(!!getRateMapping(job?.jobType));
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
  document.getElementById('f_coyFund').value = job?.coyFund ?? 0;
  document.getElementById('f_status').value = job?.paymentStatus || 'Unpaid';
  document.getElementById('f_remarks').value = job?.remarks || '';
  toggleQtyHint();

  document.getElementById('jobModalBg').classList.add('active');
}
function closeJobModal(){
  document.getElementById('jobModalBg').classList.remove('active');
  editingId = null;
}
document.getElementById('addJobBtn').addEventListener('click', ()=>openJobModal(null));
document.getElementById('cancelJobBtn').addEventListener('click', closeJobModal);
document.getElementById('jobModalBg').addEventListener('click', (e)=>{ if(e.target.id==='jobModalBg') closeJobModal(); });

function buildTripDetails({hostName, uid, costCentre, pax, itinerary, driver, startTime, endTime}){
  const lines = [];
  lines.push(`REQUESTOR: ${hostName||''}`);
  lines.push(`UID: ${uid||''}`);
  lines.push(`COST CENTRE: ${costCentre||''}`);
  lines.push(`PAX: ${pax||''}`);
  if(itinerary) lines.push(itinerary);
  const d = DATA.drivers.find(x=>x.name===driver);
  const plate = d?.plate || '';
  lines.push(`DRIVER: ${driver||''}${plate?` (${plate})`:''}`);
  if(startTime){
    const s = startTime.replace(':','');
    const e = endTime ? endTime.replace(':','') : '';
    lines.push(`TIME: ${s}${e?` - ${e}`:''}`);
  } else {
    lines.push('TIME: ');
  }
  return lines.join('\n');
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
    date: document.getElementById('f_date').value,
    invoice: document.getElementById('f_invoice').value,
    driver,
    jobType: document.getElementById('f_jobType').value,
    vehicle: document.getElementById('f_vehicle').value,
    hostName,
    company: document.getElementById('f_company').value,
    costCentre: document.getElementById('f_costCentre').value,
    uid,
    details: buildTripDetails({hostName, uid, costCentre: document.getElementById('f_costCentre').value, pax, itinerary, driver, startTime, endTime}),
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
  if(!job.date){ alert('Please set a date.'); return; }
  if(editingId){
    job.id = editingId;
    const {error} = await sb.from('jobs').update(job).eq('id', editingId);
    if(error){ alert('Save failed: '+error.message); return; }
    const idx = DATA.jobs.findIndex(j=>j.id===editingId);
    DATA.jobs[idx] = job;
  } else {
    const {data, error} = await sb.from('jobs').insert(job).select();
    if(error){ alert('Save failed: '+error.message); return; }
    job.id = data[0].id;
    DATA.jobs.push(job);
  }
  closeJobModal();
  renderAll();
});
document.getElementById('deleteJobBtn').addEventListener('click', async ()=>{
  if(!editingId) return;
  if(!confirm('Delete this job entry?')) return;
  const {error} = await sb.from('jobs').delete().eq('id', editingId);
  if(error){ alert('Delete failed: '+error.message); return; }
  DATA.jobs = DATA.jobs.filter(j=>j.id!==editingId);
  closeJobModal();
  renderAll();
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

// ---------- Render all ----------
function renderAll(){
  renderDashboard();
  renderJobs();
  renderInvoices();
  renderDrivers();
  renderClients();
  renderRates();
}
// Initial render handled by initApp() after auth check
