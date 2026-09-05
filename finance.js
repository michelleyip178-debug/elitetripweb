// Finance module: accounts, transactions (income/expense/transfer), simple
// liabilities, and a computed balance sheet. Shared across BOTH workspaces —
// unlike jobs/invoices, there is one business, one set of bank accounts, and
// one balance sheet, so these tables have no "_nonmaersk" counterpart (see
// TBL.finance_* in workspace-config.js, which point at unsuffixed tables).
//
// Paid invoices auto-book two linked transactions (income = invoice total,
// expense = driver payout) into a default "Operating Account" — see
// syncInvoiceFinanceEntries(), called from setJobsPaymentStatus() in app.js.
// These are computed, not hand-entered, so unmarking an invoice as paid
// removes them again rather than leaving stale numbers behind.

let FINANCE = { accounts: [], transactions: [], liabilities: [] };
const DEFAULT_ACCOUNT_NAME = 'Operating Account';
const FINANCE_CATEGORIES = [
  'Trip Revenue','Driver Payout','Bank Fees','Other Income','Office & Admin','Miscellaneous',
];

async function loadFinanceData(){
  const [accounts, transactions, liabilities] = await Promise.all([
    sb.from(TBL.finance_accounts).select('*'),
    sb.from(TBL.finance_transactions).select('*'),
    sb.from(TBL.finance_liabilities).select('*'),
  ]);
  if(accounts.error || transactions.error || liabilities.error){
    console.error('Finance tables not ready yet:', (accounts.error||transactions.error||liabilities.error).message);
    return { accounts: [], transactions: [], liabilities: [] };
  }
  return { accounts: accounts.data, transactions: transactions.data, liabilities: liabilities.data };
}

async function initFinance(){
  FINANCE = await loadFinanceData();
  renderFinance();
}

async function getOrCreateDefaultAccount(){
  let acc = FINANCE.accounts.find(a=>a.name===DEFAULT_ACCOUNT_NAME);
  if(acc) return acc;
  const {data, error} = await sb.from(TBL.finance_accounts).insert({name:DEFAULT_ACCOUNT_NAME, type:'bank', openingBalance:0}).select();
  if(error){ console.error('Failed to create default account:', error.message); return null; }
  acc = data[0];
  FINANCE.accounts.push(acc);
  return acc;
}

// Books (or reverses) the two auto entries for an invoice becoming PAID/UNPAID.
// Idempotent: always clears any prior auto rows for this invoice first, so
// re-running (e.g. re-marking paid) never duplicates.
async function syncInvoiceFinanceEntries(invoice, jobs, status){
  await sb.from(TBL.finance_transactions).delete().eq('invoice', invoice).eq('source', 'invoice');
  FINANCE.transactions = FINANCE.transactions.filter(t=>!(t.invoice===invoice && t.source==='invoice'));
  if(status !== 'PAID') return;

  const account = await getOrCreateDefaultAccount();
  if(!account) return;
  const amount = jobs.reduce((s,j)=>s+(Number(j.qty)||0)*(Number(j.unitCost)||0)+optionsByJob(j.id).reduce((os,o)=>os+(Number(o.amount)||0),0), 0);
  const payout = jobs.reduce((s,j)=>s+(Number(j.driverPayout)||0),0);
  const dates = jobs.map(j=>j.date).filter(Boolean).sort();
  const date = dates.length ? dates[dates.length-1] : new Date().toISOString().slice(0,10);

  const rows = [{
    date, accountId: account.id, type: 'income', category: 'Trip Revenue',
    description: `Invoice ${invoice}`, amount, source: 'invoice', invoice, workspace: WORKSPACE,
  }];
  if(payout > 0){
    rows.push({
      date, accountId: account.id, type: 'expense', category: 'Driver Payout',
      description: `Invoice ${invoice}`, amount: payout, source: 'invoice', invoice, workspace: WORKSPACE,
    });
  }
  const {data, error} = await sb.from(TBL.finance_transactions).insert(rows).select();
  if(error){ console.error('Failed to book finance entries for', invoice, error.message); return; }
  FINANCE.transactions.push(...data);
}

function accountBalance(accountId){
  const acc = FINANCE.accounts.find(a=>a.id===accountId);
  if(!acc) return 0;
  let bal = Number(acc.openingBalance)||0;
  FINANCE.transactions.forEach(t=>{
    const amt = Number(t.amount)||0;
    if(t.type==='income' && t.accountId===accountId) bal += amt;
    else if(t.type==='expense' && t.accountId===accountId) bal -= amt;
    else if(t.type==='transfer'){
      if(t.accountId===accountId) bal -= amt;
      if(t.transferToAccountId===accountId) bal += amt;
    }
  });
  return bal;
}

function accountName(id){ return FINANCE.accounts.find(a=>a.id===id)?.name || '—'; }

sortState.finance = null;
const FINANCE_SORT_ACCESSORS = {
  date: t=>t.date||'',
  type: t=>t.type||'',
  category: t=>t.category||'',
  amount: t=>Number(t.amount)||0,
};

function renderFinance(){
  // ---------- Accounts ----------
  document.getElementById('financeAccountCards').innerHTML = FINANCE.accounts.length
    ? FINANCE.accounts.map(a=>`
      <div class="card" style="cursor:pointer;" onclick="openFinAccountModal(${a.id})">
        <div class="label">${escHtml(a.name)} (${a.type==='cash'?'Cash':'Bank'})</div>
        <div class="value">${fmtMoney(accountBalance(a.id))}</div>
      </div>`).join('')
    : `<div class="card"><div class="label">No accounts yet</div></div>`;

  // ---------- Transactions ----------
  const type = document.getElementById('fFinType').value;
  const category = document.getElementById('fFinCategory').value;
  const search = document.getElementById('fFinSearch').value.toLowerCase();
  populateFinCategoryFilter();
  let rows = FINANCE.transactions.slice();
  if(type) rows = rows.filter(t=>t.type===type);
  if(category) rows = rows.filter(t=> category==='__uncategorized__' ? !t.category : t.category===category);
  if(search) rows = rows.filter(t=>[t.description,t.invoice].some(v=>(v||'').toLowerCase().includes(search)));

  if(sortState.finance){
    const acc = FINANCE_SORT_ACCESSORS[sortState.finance.key];
    const dir = sortState.finance.dir==='asc' ? 1 : -1;
    rows.sort((a,b)=> dir * compareValues(acc(a), acc(b)));
  } else {
    rows.sort((a,b)=> (b.date||'').localeCompare(a.date||'') || (b.id-a.id));
  }
  updateSortArrows('financeTransactionsTable', 'finance');
  document.getElementById('finTxnCount').textContent = `${rows.length} transaction${rows.length===1?'':'s'}`;

  document.querySelector('#financeTransactionsTable tbody').innerHTML = rows.length ? rows.map(t=>{
    const typeLabel = t.type.charAt(0).toUpperCase()+t.type.slice(1);
    const pillClass = t.type==='income' ? 'paid' : t.type==='expense' ? 'unpaid' : 'pending';
    const descFull = `${t.description||''}${t.source==='invoice' ? ` (Invoice ${t.invoice||''})` : ''}`;
    return `
    <tr>
      <td>${fmtDate(t.date)}</td>
      <td><span class="pill ${pillClass}">${typeLabel}</span></td>
      <td>${escHtml(t.category||'')}</td>
      <td class="fin-desc-cell" title="${escHtml(descFull)}">${escHtml(descFull)}</td>
      <td class="num">${fmtMoney(t.amount)}</td>
      <td class="row-actions">${t.source==='invoice' ? '' : `<button onclick="openFinTxnModal(${t.id})">Edit</button>`}</td>
    </tr>`;
  }).join('') : `<tr><td colspan="6" class="empty">No transactions match these filters</td></tr>`;

  renderBalanceSheet();
}
function populateFinCategoryFilter(){
  const sel = document.getElementById('fFinCategory');
  if(sel.options.length>1) return;
  const used = [...new Set(FINANCE.transactions.map(t=>t.category).filter(Boolean))];
  const all = [...new Set([...FINANCE_CATEGORIES, ...used])].sort();
  sel.innerHTML = '<option value="">All Categories</option>'
    + all.map(c=>`<option value="${c}">${c}</option>`).join('')
    + '<option value="__uncategorized__">Uncategorized</option>';
}
document.getElementById('fFinType').addEventListener('change', renderFinance);
document.getElementById('fFinCategory').addEventListener('change', renderFinance);
document.getElementById('fFinSearch').addEventListener('input', renderFinance);
wireSortableHeaders('financeTransactionsTable', 'finance', renderFinance);

// ---------- Balance Sheet ----------
function renderBalanceSheet(){
  const cashTotal = FINANCE.accounts.reduce((s,a)=>s+accountBalance(a.id),0);

  // Accounts Receivable: invoices not yet PAID in the CURRENT workspace —
  // money already invoiced but not collected is still an asset. Accounts,
  // transactions and liabilities are shared across workspaces; receivable
  // isn't, since job data itself is workspace-scoped — switch workspaces
  // (top-right toggle) to see the other side's receivables.
  const receivableRows = groupInvoices().filter(g=>statusClass(g.status)!=='paid');
  const receivable = receivableRows.reduce((s,g)=>s+g.amount,0);

  const totalAssets = cashTotal + receivable;
  const totalLiabilities = FINANCE.liabilities.reduce((s,l)=>s+(Number(l.amount)||0),0);
  const equity = totalAssets - totalLiabilities;

  const totalIncome = FINANCE.transactions.filter(t=>t.type==='income').reduce((s,t)=>s+(Number(t.amount)||0),0);
  const totalExpense = FINANCE.transactions.filter(t=>t.type==='expense').reduce((s,t)=>s+(Number(t.amount)||0),0);

  document.getElementById('balanceSheetPanel').innerHTML = `
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;">
      <div>
        <h2 style="margin:0 0 10px;font-size:13px;">Assets</h2>
        <table style="width:100%;border-collapse:collapse;font-size:13px;">
          <tr><td style="padding:5px 0;">Cash &amp; Bank</td><td class="num" style="padding:5px 0;">${fmtMoney(cashTotal)}</td></tr>
          <tr><td style="padding:5px 0;">Accounts Receivable (unpaid invoices)</td><td class="num" style="padding:5px 0;">${fmtMoney(receivable)}</td></tr>
          <tr style="font-weight:700;border-top:1px solid var(--line);"><td style="padding:7px 0;">Total Assets</td><td class="num" style="padding:7px 0;">${fmtMoney(totalAssets)}</td></tr>
        </table>

        <h2 style="margin:18px 0 10px;font-size:13px;">Liabilities</h2>
        <table style="width:100%;border-collapse:collapse;font-size:13px;">
          ${FINANCE.liabilities.length ? FINANCE.liabilities.map(l=>`
          <tr><td style="padding:5px 0;cursor:pointer;color:var(--accent);" onclick="openFinLiabilityModal(${l.id})">${escHtml(l.name)}</td><td class="num" style="padding:5px 0;">${fmtMoney(l.amount)}</td></tr>
          `).join('') : `<tr><td style="padding:5px 0;color:var(--muted);">No liabilities recorded</td><td></td></tr>`}
          <tr style="font-weight:700;border-top:1px solid var(--line);"><td style="padding:7px 0;">Total Liabilities</td><td class="num" style="padding:7px 0;">${fmtMoney(totalLiabilities)}</td></tr>
        </table>

        <table style="width:100%;border-collapse:collapse;font-size:13px;margin-top:10px;">
          <tr style="font-weight:700;"><td style="padding:7px 0;">Owner's Equity (Assets − Liabilities)</td><td class="num" style="padding:7px 0;">${fmtMoney(equity)}</td></tr>
        </table>
      </div>
      <div>
        <h2 style="margin:0 0 10px;font-size:13px;">Income &amp; Expense (all-time, from booked transactions)</h2>
        <table style="width:100%;border-collapse:collapse;font-size:13px;">
          <tr><td style="padding:5px 0;">Total Income</td><td class="num" style="padding:5px 0;">${fmtMoney(totalIncome)}</td></tr>
          <tr><td style="padding:5px 0;">Total Expense</td><td class="num" style="padding:5px 0;">${fmtMoney(totalExpense)}</td></tr>
          <tr style="font-weight:700;border-top:1px solid var(--line);"><td style="padding:7px 0;">Net Income</td><td class="num" style="padding:7px 0;">${fmtMoney(totalIncome-totalExpense)}</td></tr>
        </table>
        <div class="small muted" style="margin-top:10px;">Trip Revenue and Driver Payout entries are booked automatically when an invoice is marked Paid (or its Payment Date is set). Everything else — fuel, maintenance, salaries, etc. — add manually via "+ Add Transaction".</div>
      </div>
    </div>
  `;
}

// ---------- Account modal ----------
let editingFinAccountId = null;
function openFinAccountModal(id){
  editingFinAccountId = id ?? null;
  const acc = id ? FINANCE.accounts.find(a=>a.id===id) : null;
  document.getElementById('finAccountModalTitle').textContent = acc ? 'Edit Account' : 'New Account';
  document.getElementById('fa_name').value = acc?.name || '';
  document.getElementById('fa_type').value = acc?.type || 'bank';
  document.getElementById('fa_opening').value = acc?.openingBalance ?? 0;
  document.getElementById('deleteAccountBtn').style.display = acc ? '' : 'none';
  document.getElementById('finAccountModalBg').classList.add('active');
}
document.getElementById('cancelAccountBtn').addEventListener('click', ()=>document.getElementById('finAccountModalBg').classList.remove('active'));
document.getElementById('saveAccountBtn').addEventListener('click', async ()=>{
  const name = document.getElementById('fa_name').value.trim();
  if(!name){ alert('Account name is required.'); return; }
  const payload = { name, type: document.getElementById('fa_type').value, openingBalance: Number(document.getElementById('fa_opening').value)||0 };
  if(editingFinAccountId){
    const {error} = await sb.from(TBL.finance_accounts).update(payload).eq('id', editingFinAccountId);
    if(error){ alert('Save failed: '+error.message); return; }
    Object.assign(FINANCE.accounts.find(a=>a.id===editingFinAccountId), payload);
  } else {
    const {data, error} = await sb.from(TBL.finance_accounts).insert(payload).select();
    if(error){ alert('Save failed: '+error.message); return; }
    FINANCE.accounts.push(data[0]);
  }
  document.getElementById('finAccountModalBg').classList.remove('active');
  renderFinance();
});
document.getElementById('deleteAccountBtn').addEventListener('click', async ()=>{
  if(!editingFinAccountId) return;
  if(!confirm('Delete this account? Transactions posted to it will keep the account name but show a blank balance link.')) return;
  const {error} = await sb.from(TBL.finance_accounts).delete().eq('id', editingFinAccountId);
  if(error){ alert('Delete failed: '+error.message); return; }
  FINANCE.accounts = FINANCE.accounts.filter(a=>a.id!==editingFinAccountId);
  document.getElementById('finAccountModalBg').classList.remove('active');
  renderFinance();
});

// ---------- Transaction modal ----------
let editingFinTxnId = null;
function populateFinAccountSelects(){
  const opts = FINANCE.accounts.map(a=>`<option value="${a.id}">${escHtml(a.name)}</option>`).join('');
  document.getElementById('ft_account').innerHTML = opts;
  document.getElementById('ft_transferTo').innerHTML = opts;
}
function openFinTxnModal(id){
  if(FINANCE.accounts.length===0){ alert('Add an account first before recording a transaction.'); return; }
  editingFinTxnId = id ?? null;
  const t = id ? FINANCE.transactions.find(x=>x.id===id) : null;
  populateFinAccountSelects();
  document.getElementById('finTxnModalTitle').textContent = t ? 'Edit Transaction' : 'New Transaction';
  document.getElementById('ft_date').value = t?.date || new Date().toISOString().slice(0,10);
  document.getElementById('ft_type').value = t?.type || 'expense';
  document.getElementById('ft_account').value = t?.accountId || FINANCE.accounts[0].id;
  document.getElementById('ft_transferTo').value = t?.transferToAccountId || FINANCE.accounts[0].id;
  const categoryOptions = [...new Set([...FINANCE_CATEGORIES, ...(t?.category ? [t.category] : [])])];
  document.getElementById('ft_category').innerHTML = categoryOptions.map(c=>`<option value="${c}">${c}</option>`).join('');
  document.getElementById('ft_category').value = t?.category || FINANCE_CATEGORIES[0];
  document.getElementById('ft_amount').value = t?.amount ?? '';
  document.getElementById('ft_description').value = t?.description || '';
  document.getElementById('ft_transferToWrap').style.display = document.getElementById('ft_type').value==='transfer' ? '' : 'none';
  document.getElementById('deleteTxnBtn').style.display = t ? '' : 'none';
  document.getElementById('finTxnModalBg').classList.add('active');
}
document.getElementById('ft_type').addEventListener('change', ()=>{
  document.getElementById('ft_transferToWrap').style.display = document.getElementById('ft_type').value==='transfer' ? '' : 'none';
});
document.getElementById('addTransactionBtn').addEventListener('click', ()=>openFinTxnModal(null));
document.getElementById('cancelTxnBtn').addEventListener('click', ()=>document.getElementById('finTxnModalBg').classList.remove('active'));
document.getElementById('saveTxnBtn').addEventListener('click', async ()=>{
  const type = document.getElementById('ft_type').value;
  const amount = Number(document.getElementById('ft_amount').value)||0;
  if(amount<=0){ alert('Amount must be greater than 0.'); return; }
  const accountId = Number(document.getElementById('ft_account').value);
  const transferToAccountId = type==='transfer' ? Number(document.getElementById('ft_transferTo').value) : null;
  if(type==='transfer' && transferToAccountId===accountId){ alert('Transfer From and To must be different accounts.'); return; }
  const payload = {
    date: document.getElementById('ft_date').value,
    accountId, type,
    transferToAccountId,
    category: document.getElementById('ft_category').value.trim(),
    description: document.getElementById('ft_description').value.trim(),
    amount, source: 'manual', invoice: null, workspace: null,
  };
  if(editingFinTxnId){
    const {error} = await sb.from(TBL.finance_transactions).update(payload).eq('id', editingFinTxnId);
    if(error){ alert('Save failed: '+error.message); return; }
    Object.assign(FINANCE.transactions.find(t=>t.id===editingFinTxnId), payload);
  } else {
    const {data, error} = await sb.from(TBL.finance_transactions).insert(payload).select();
    if(error){ alert('Save failed: '+error.message); return; }
    FINANCE.transactions.push(data[0]);
  }
  document.getElementById('finTxnModalBg').classList.remove('active');
  renderFinance();
});
document.getElementById('deleteTxnBtn').addEventListener('click', async ()=>{
  if(!editingFinTxnId) return;
  if(!confirm('Delete this transaction?')) return;
  const {error} = await sb.from(TBL.finance_transactions).delete().eq('id', editingFinTxnId);
  if(error){ alert('Delete failed: '+error.message); return; }
  FINANCE.transactions = FINANCE.transactions.filter(t=>t.id!==editingFinTxnId);
  document.getElementById('finTxnModalBg').classList.remove('active');
  renderFinance();
});

// ---------- Liability modal ----------
let editingFinLiabilityId = null;
function openFinLiabilityModal(id){
  editingFinLiabilityId = id ?? null;
  const l = id ? FINANCE.liabilities.find(x=>x.id===id) : null;
  document.getElementById('finLiabilityModalTitle').textContent = l ? 'Edit Liability' : 'New Liability';
  document.getElementById('fl_name').value = l?.name || '';
  document.getElementById('fl_amount').value = l?.amount ?? '';
  document.getElementById('fl_notes').value = l?.notes || '';
  document.getElementById('deleteLiabilityBtn').style.display = l ? '' : 'none';
  document.getElementById('finLiabilityModalBg').classList.add('active');
}
document.getElementById('addLiabilityBtn').addEventListener('click', ()=>openFinLiabilityModal(null));
document.getElementById('cancelLiabilityBtn').addEventListener('click', ()=>document.getElementById('finLiabilityModalBg').classList.remove('active'));
document.getElementById('saveLiabilityBtn').addEventListener('click', async ()=>{
  const name = document.getElementById('fl_name').value.trim();
  if(!name){ alert('Name is required.'); return; }
  const payload = { name, amount: Number(document.getElementById('fl_amount').value)||0, notes: document.getElementById('fl_notes').value.trim() };
  if(editingFinLiabilityId){
    const {error} = await sb.from(TBL.finance_liabilities).update(payload).eq('id', editingFinLiabilityId);
    if(error){ alert('Save failed: '+error.message); return; }
    Object.assign(FINANCE.liabilities.find(l=>l.id===editingFinLiabilityId), payload);
  } else {
    const {data, error} = await sb.from(TBL.finance_liabilities).insert(payload).select();
    if(error){ alert('Save failed: '+error.message); return; }
    FINANCE.liabilities.push(data[0]);
  }
  document.getElementById('finLiabilityModalBg').classList.remove('active');
  renderFinance();
});
document.getElementById('deleteLiabilityBtn').addEventListener('click', async ()=>{
  if(!editingFinLiabilityId) return;
  if(!confirm('Delete this liability?')) return;
  const {error} = await sb.from(TBL.finance_liabilities).delete().eq('id', editingFinLiabilityId);
  if(error){ alert('Delete failed: '+error.message); return; }
  FINANCE.liabilities = FINANCE.liabilities.filter(l=>l.id!==editingFinLiabilityId);
  document.getElementById('finLiabilityModalBg').classList.remove('active');
  renderFinance();
});
