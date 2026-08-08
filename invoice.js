// Standalone invoice document page, opened from the Invoices tab in dashboard.html
// (see the generateInvoiceBtn handler in app.js) as invoice.html?ws=...&inv=INV1,INV2.
// WORKSPACE, TBL, and COMPANY_LETTERHEAD come from workspace-config.js, loaded before this file.

const loginOverlay = document.getElementById('loginOverlay');
const loginBtn = document.getElementById('loginBtn');
const loginEmail = document.getElementById('loginEmail');
const loginPassword = document.getElementById('loginPassword');
const loginError = document.getElementById('loginError');
const preview = document.getElementById('invoicePreview');

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
  init();
});
loginPassword.addEventListener('keydown', e=>{ if(e.key==='Enter') loginBtn.click(); });

document.getElementById('printBtn').addEventListener('click', ()=>window.print());

sb.auth.getSession().then(({data:{session}})=>{
  if(session){ init(); } else { loginOverlay.classList.remove('hidden'); }
});

// ---------- Formatting helpers (ported from app.js — pages here are self-contained) ----------
function fmtMoney(n){ n = Number(n)||0; return 'S$' + n.toLocaleString('en-SG', {minimumFractionDigits:2, maximumFractionDigits:2}); }
function pad2(n){ return String(n).padStart(2,'0'); }
function toDMY(dateStr){
  if(!dateStr) return '';
  const [y,m,d] = dateStr.split('-');
  return `${d}/${m}/${y}`;
}
function addDaysDMY(dateStr, days){
  const d = new Date(dateStr+'T00:00:00');
  d.setDate(d.getDate()+days);
  return `${pad2(d.getDate())}/${pad2(d.getMonth()+1)}/${d.getFullYear()}`;
}
function extractRoute(text){
  if(!text) return '';
  return text.split('\n').filter(l=>!/^\s*(REQUESTOR|UID|COST CENTRE|DRIVER|PAX|TIME)\s*:/i.test(l)).join('\n').trim();
}
function extractPax(text){
  const m = (text||'').match(/^\s*PAX\s*:\s*(.+)$/im);
  return m ? m[1].trim() : null;
}
function isHourlyJobType(jobType){ return /HOURLY/i.test(jobType||''); }
function escHtml(s){ return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

// Same line-item description logic as buildItemDescription() in app.js.
function buildItemDescription(job, drivers){
  const lines = [];
  if(job.hostName) lines.push(`REQUESTOR: ${job.hostName}`);
  if(job.uid) lines.push(`UID: ${job.uid}`);
  if(job.costCentre) lines.push(`COST CENTRE: ${job.costCentre}`);
  const route = extractRoute(job.details);
  if(route) lines.push(route);
  const pax = extractPax(job.details);
  if(pax) lines.push(`PAX: ${pax}`);
  if(job.driver){
    const d = (drivers||[]).find(x=>x.name===job.driver);
    const plate = job.vehicle && !d ? job.vehicle : (d?.plate || '');
    lines.push(`DRIVER: ${job.driver}${plate?` (${plate})`:''}`);
  }
  if(job.startTime && isHourlyJobType(job.jobType)){
    const s = job.startTime.replace(':','');
    const e = job.endTime ? job.endTime.replace(':','') : '';
    lines.push(`TIME: ${s}${e?` - ${e}`:''}`);
  }
  return lines.join('\n');
}

// ---------- Load + render ----------
async function init(){
  loginOverlay.classList.add('hidden');
  const invoiceNumbers = [...new Set((new URLSearchParams(location.search).get('inv')||'').split(',').map(s=>s.trim()).filter(Boolean))];
  if(!invoiceNumbers.length){
    preview.innerHTML = '<div class="invoice-empty">No invoice numbers given. Go back to the Invoices tab and select at least one invoice.</div>';
    return;
  }

  const [jobsRes, clientsRes, driversRes] = await Promise.all([
    sb.from(TBL.jobs).select('*').in('invoice', invoiceNumbers),
    sb.from(TBL.clients).select('*'),
    sb.from(TBL.drivers).select('*'),
  ]);
  if(jobsRes.error || clientsRes.error || driversRes.error){
    preview.innerHTML = `<div class="invoice-empty">Failed to load invoice data: ${escHtml((jobsRes.error||clientsRes.error||driversRes.error).message)}</div>`;
    return;
  }
  const jobs = jobsRes.data;
  const clients = clientsRes.data;
  const drivers = driversRes.data;
  if(!jobs.length){
    preview.innerHTML = '<div class="invoice-empty">No job records found for the selected invoice number(s).</div>';
    return;
  }

  const jobIds = jobs.map(j=>j.id);
  const optionsRes = await sb.from(TBL.job_options).select('*').in('job_id', jobIds);
  const jobOptions = optionsRes.error ? [] : optionsRes.data;
  const optionsByJob = jobId => jobOptions.filter(o=>o.job_id===jobId);

  function findBillingClient(company){
    if(!company) return null;
    const norm = company.trim().toUpperCase();
    const matches = clients.filter(c=>(c.company||'').trim().toUpperCase()===norm);
    return matches.find(c=>c.billingAddress) || matches[0] || null;
  }

  preview.innerHTML = invoiceNumbers.map(inv=>{
    const invJobs = jobs.filter(j=>j.invoice===inv).sort((a,b)=> (a.date||'').localeCompare(b.date||'') || (a.id-b.id));
    if(!invJobs.length) return `<div class="invoice-doc"><div class="invoice-empty">No records found for invoice ${escHtml(inv)}.</div></div>`;

    const company = invJobs[0].company || '';
    const client = findBillingClient(company);
    const dates = invJobs.map(j=>j.date).filter(Boolean);
    const invDate = dates.length ? dates.reduce((a,b)=>a<b?a:b) : '';
    const dueDateDMY = invDate ? addDaysDMY(invDate, 30) : '';

    let subtotal = 0;
    const rows = invJobs.map(j=>{
      const cost = (Number(j.qty)||0) * (Number(j.unitCost)||0);
      subtotal += cost;
      const addonRows = optionsByJob(j.id).map(o=>{
        subtotal += Number(o.amount)||0;
        return `<tr><td></td><td>${escHtml(o.optionType||'')}</td><td></td><td class="num">1</td><td class="num">${fmtMoney(o.amount)}</td><td class="num">${fmtMoney(o.amount)}</td></tr>`;
      }).join('');
      return `<tr>
        <td>${j.date ? toDMY(j.date) : ''}</td>
        <td>${escHtml(j.jobType||'')}</td>
        <td>${escHtml(buildItemDescription(j, drivers))}</td>
        <td class="num">${j.qty ?? ''}</td>
        <td class="num">${Number(j.unitCost||0).toFixed(2)}</td>
        <td class="num">${Number(cost).toFixed(2)}</td>
      </tr>${addonRows}`;
    }).join('');

    const billToLines = [company];
    if(client?.billingAddress) billToLines.push(client.billingAddress);
    if(invJobs[0].hostName) billToLines.push(`Attn: ${invJobs[0].hostName}`);
    if(invJobs[0].costCentre) billToLines.push(`Cost Centre: ${invJobs[0].costCentre}`);
    if(client?.uen) billToLines.push(`UEN: ${client.uen}`);

    const letterheadLines = [
      ...(COMPANY_LETTERHEAD.addressLines||[]),
      COMPANY_LETTERHEAD.phone,
      COMPANY_LETTERHEAD.email,
      COMPANY_LETTERHEAD.website,
      COMPANY_LETTERHEAD.regNo ? `Company Registration No. ${COMPANY_LETTERHEAD.regNo}` : '',
    ].filter(Boolean);

    return `
    <div class="invoice-doc">
      <div class="invoice-head">
        <div>
          <div class="name">${escHtml(COMPANY_LETTERHEAD.name)}</div>
          <div class="invoice-from">${escHtml(letterheadLines.join('\n'))}</div>
        </div>
        <img class="invoice-logo" src="${COMPANY_LETTERHEAD.logoUrl||''}" alt="" onerror="this.style.display='none'">
      </div>
      <h1 class="invoice-title">INVOICE</h1>
      <div class="invoice-billmeta">
        <div class="invoice-billto">
          <div class="label">Bill To</div>
          <div>${escHtml(billToLines.filter(Boolean).join('\n'))}</div>
        </div>
        <div class="invoice-meta">
          <div>INVOICE <b>${escHtml(inv)}</b></div>
          <div>DATE <b>${invDate ? toDMY(invDate) : ''}</b></div>
          <div>DUE DATE <b>${dueDateDMY}</b></div>
        </div>
      </div>
      <table>
        <thead><tr><th>Date</th><th>Service</th><th>Description</th><th class="num">Qty</th><th class="num">Rate</th><th class="num">Amount</th></tr></thead>
        <tbody>${rows}</tbody>
      </table>
      <div class="invoice-footer">
        <div class="thanks">This is a computer generated invoice. No signature is required.<br>Thank you for your business.</div>
        <div class="invoice-balance"><span class="label">Balance Due</span>${fmtMoney(subtotal)}</div>
      </div>
      ${(COMPANY_LETTERHEAD.paymentMethods||[]).length ? `
      <div class="invoice-payment">
        <div class="label">Payment Methods:</div>
        <div>${COMPANY_LETTERHEAD.paymentMethods.map((m,i)=>`${i+1}. ${escHtml(m)}`).join('<br>')}</div>
      </div>` : ''}
    </div>`;
  }).join('');
}
