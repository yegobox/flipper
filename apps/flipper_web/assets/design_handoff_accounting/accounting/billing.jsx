// ===========================================================
//  Flipper Accounting · Sales invoices, purchase bills, payments
//  Documents that auto-post balanced double entries:
//   • Invoice sent → Dr Accounts Receivable / Cr Sales + VAT Payable
//   • Bill entered → Dr Expense or Inventory + Input VAT / Cr Accounts Payable
//   • Payment      → Dr Bank / Cr AR  (or)  Dr AP / Cr Bank
// ===========================================================
const { useState: useB } = React;

const DOC_TABS = [['all', 'All'], ['draft', 'Draft'], ['sent', 'Sent'], ['overdue', 'Overdue'], ['paid', 'Paid']];

function StatusPill({ status }) {
  const m = DOC_STATUS[status] || DOC_STATUS.draft;
  return <span className={`pill ${m.cls}`}><span className="pdot" />{m.label}</span>;
}

// ─────────────────────── shared document list (invoices / bills) ───────────
function DocListView({ kind }) {
  const isInv = kind === 'invoice';
  const seed = isInv ? INVOICES : BILLS;
  const [docs, setDocs] = useB(seed);
  const [tab, setTab] = useB('all');
  const [editing, setEditing] = useB(null);   // doc being edited, or 'new'
  const [paying, setPaying] = useB(null);      // doc being paid
  const [preview, setPreview] = useB(null);    // doc being previewed

  const list = docs.filter((d) => tab === 'all' || d.status === tab);
  const outstanding = docs.filter((d) => d.status === 'sent' || d.status === 'overdue')
    .reduce((s, d) => s + docTotals(d.lines).total, 0);
  const overdue = docs.filter((d) => d.status === 'overdue').reduce((s, d) => s + docTotals(d.lines).total, 0);
  const draftCount = docs.filter((d) => d.status === 'draft').length;

  const partyLabel = isInv ? 'Customer' : 'Supplier';
  const nextId = () => {
    const prefix = isInv ? 'INV-' : 'BILL-';
    const max = docs.reduce((m, d) => Math.max(m, parseInt(d.id.replace(/\D/g, ''), 10) || 0), 0);
    return prefix + (max + 1);
  };

  const saveDoc = (doc, mode) => {
    setDocs((ds) => {
      const exists = ds.some((d) => d.id === doc.id);
      return exists ? ds.map((d) => (d.id === doc.id ? doc : d)) : [doc, ...ds];
    });
    setEditing(null);
    const t = docTotals(doc.lines).total;
    if (mode === 'draft') toast('Draft saved', { sub: `${doc.id} · ${doc.who}`, icon: 'Receipt', tone: 'info' });
    else if (isInv) toast('Invoice sent & posted', { sub: `${doc.id} → ${doc.who} · RWF ${money(t)}`, icon: 'Mail', tone: 'success' });
    else toast('Bill recorded & posted', { sub: `${doc.id} · ${doc.who} · RWF ${money(t)}`, icon: 'Check', tone: 'success' });
  };
  const markPaid = (doc) => {
    setDocs((ds) => ds.map((d) => (d.id === doc.id ? { ...d, status: 'paid' } : d)));
    setPaying(null);
  };

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">{isInv ? 'Sales' : 'Purchases'}</div>
          <h1 className="acc-h1">{isInv ? 'Invoices' : 'Bills'}</h1>
          <div className="acc-sub">{isInv ? 'Bill your customers and get paid' : 'Track what you owe your suppliers'} · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <Dropdown align="right" width={200}
            trigger={({ toggle }) => (<button className="acc-btn acc-btn-ghost" onClick={toggle}><Icons.Download size={16} />Export</button>)}>
            {({ close }) => (
              <>
                <MenuLabel>Export {isInv ? 'invoices' : 'bills'}</MenuLabel>
                <MenuItem icon="Download" label="Excel workbook (.xlsx)" onClick={() => { close(); toast('Exporting to Excel', { sub: `${docs.length} ${isInv ? 'invoices' : 'bills'}`, icon: 'Download', tone: 'success' }); }} />
                <MenuItem icon="Print" label="PDF summary" onClick={() => { close(); toast('Generating PDF', { sub: isInv ? 'Sales register' : 'Purchase register', icon: 'Print', tone: 'info' }); }} />
              </>
            )}
          </Dropdown>
          <button className="acc-btn acc-btn-primary" onClick={() => setEditing('new')}><Icons.Plus size={17} />{isInv ? 'New invoice' : 'New bill'}</button>
        </div>
      </div>

      {/* summary KPIs */}
      <div className="acc-grid cols-3 mb16">
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.Receipt size={20} /></span><span className="acc-kpi-lbl">{isInv ? 'Outstanding' : 'Owed to suppliers'}</span></div><div className="acc-kpi-val"><small>RWF</small> {money(outstanding)}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic red"><Icons.Clock size={20} /></span><span className="acc-kpi-lbl">Overdue</span></div><div className="acc-kpi-val"><small>RWF</small> {money(overdue)}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.Receipt size={20} /></span><span className="acc-kpi-lbl">Drafts</span></div><div className="acc-kpi-val">{draftCount}</div></div>
      </div>

      <div className="acc-tabs" style={{ marginBottom: 16 }}>
        {DOC_TABS.map(([k, lbl]) => (
          <button key={k} className={`acc-tab ${tab === k ? 'is-on' : ''}`} onClick={() => setTab(k)}>{lbl}</button>
        ))}
      </div>

      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th style={{ width: 120 }}>{isInv ? 'Invoice' : 'Bill'}</th><th>{partyLabel}</th><th>Date</th><th>Due</th><th>Status</th><th className="r">Amount</th><th></th></tr></thead>
            <tbody>
              {list.map((d) => {
                const t = docTotals(d.lines);
                return (
                  <tr key={d.id} className="acc-row-click" onClick={() => setPreview(d)}>
                    <td><span className="je-id">{d.id}</span></td>
                    <td className="je-memo">{d.who}</td>
                    <td className="muted">{d.date}</td>
                    <td className="muted">{d.due}</td>
                    <td><StatusPill status={d.status} /></td>
                    <td className="r num" style={{ fontWeight: 700 }}>{money(t.total)}</td>
                    <td className="r" onClick={(e) => e.stopPropagation()}>
                      <Dropdown align="right" width={196}
                        trigger={({ toggle }) => (<button className="acc-iconbtn sm" onClick={toggle}><Icons.More size={18} /></button>)}>
                        {({ close }) => (
                          <>
                            <MenuItem icon="Eye" label="Open & preview" onClick={() => { close(); setPreview(d); }} />
                            <MenuItem icon="Receipt" label="Edit" onClick={() => { close(); setEditing(d); }} />
                            {d.status !== 'paid' && <MenuItem icon="Wallet" label={isInv ? 'Record payment' : 'Pay this bill'} onClick={() => { close(); setPaying(d); }} />}
                            {isInv && d.status !== 'paid' && <MenuItem icon="Mail" label="Send reminder" onClick={() => { close(); toast('Reminder sent', { sub: `${d.who} · ${d.id}`, icon: 'Mail', tone: 'success' }); }} />}
                            <MenuSep />
                            <MenuItem icon="Trash" label="Delete" danger onClick={() => { close(); setDocs((ds) => ds.filter((x) => x.id !== d.id)); toast('Deleted', { sub: d.id, icon: 'Trash', tone: 'info' }); }} />
                          </>
                        )}
                      </Dropdown>
                    </td>
                  </tr>
                );
              })}
              {list.length === 0 && <tr><td colSpan={7}><div className="acc-empty-note">No {isInv ? 'invoices' : 'bills'} in “{tab}”.</div></td></tr>}
            </tbody>
          </table>
        </div>
      </div>

      {editing && <DocEditor kind={kind} doc={editing === 'new' ? null : editing} newId={nextId()} onClose={() => setEditing(null)} onSave={saveDoc} />}
      {paying && <PaymentModal kind={kind} doc={paying} onClose={() => setPaying(null)} onPaid={markPaid} />}
      {preview && <DocPreview kind={kind} doc={preview} onClose={() => setPreview(null)} onEdit={() => { setEditing(preview); setPreview(null); }} onPay={() => { setPaying(preview); setPreview(null); }} />}
    </div>
  );
}

// ───────────────────────────── document editor ─────────────────────────────
const fmtNum = (s) => { const d = String(s).replace(/[^\d]/g, ''); return d ? Number(d).toLocaleString('en-US') : ''; };
const parseNum = (s) => Number(String(s).replace(/[^\d]/g, '')) || 0;

function DocEditor({ kind, doc, newId, onClose, onSave }) {
  const isInv = kind === 'invoice';
  const parties = isInv ? CUSTOMERS : SUPPLIERS;
  const [who, setWho] = useB(doc ? doc.who : '');
  const [date, setDate] = useB(doc ? doc.date : '31 May 2026');
  const [due, setDue] = useB(doc ? doc.due : '30 Jun 2026');
  const [lines, setLines] = useB(doc ? doc.lines.map((l) => ({ ...l })) : [{ desc: '', qty: 1, price: 0 }]);
  const [sending, setSending] = useB(false);
  const id = doc ? doc.id : newId;

  const t = docTotals(lines);
  const setLine = (i, patch) => setLines((ls) => ls.map((l, j) => (j === i ? { ...l, ...patch } : l)));
  const addLine = () => setLines((ls) => [...ls, { desc: '', qty: 1, price: 0 }]);
  const delLine = (i) => setLines((ls) => (ls.length > 1 ? ls.filter((_, j) => j !== i) : ls));
  const valid = who && lines.some((l) => l.desc && parseNum(l.price) > 0);

  const build = (status) => ({ id, who, date, due, status, lines: lines.filter((l) => l.desc || parseNum(l.price) > 0) });

  // posting preview (the double entry this document will create)
  const arap = isInv ? ACCT['1100'] : ACCT['2010'];
  const postLines = isInv
    ? [{ side: 'dr', ac: '1100', amt: t.total }, { side: 'cr', ac: '4010', amt: t.subtotal }, { side: 'cr', ac: '2100', amt: t.vat }]
    : [{ side: 'dr', ac: '1200', amt: t.subtotal }, { side: 'dr', ac: '2100', amt: t.vat }, { side: 'cr', ac: '2010', amt: t.total }];

  return (
    <div className="acc-composer-scrim" onClick={onClose}>
      <div className="acc-composer wide" onClick={(e) => e.stopPropagation()}>
        <div className="acc-comp-head">
          <div>
            <div className="acc-comp-title">{doc ? 'Edit' : 'New'} {isInv ? 'invoice' : 'bill'} · <span className="je-id" style={{ fontSize: 16 }}>{id}</span></div>
            <div className="acc-comp-sub">{isInv ? 'Bill a customer — Flipper posts the sale and VAT automatically.' : 'Record a supplier bill — Flipper posts the expense and input VAT.'}</div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>

        <div className="acc-comp-body">
          <div className="acc-fieldrow" style={{ gridTemplateColumns: '1.4fr 1fr 1fr' }}>
            <div>
              <div className="acc-field-lbl">{isInv ? 'Customer' : 'Supplier'}</div>
              <Dropdown align="left" block width={300}
                trigger={({ toggle }) => (
                  <button className="acc-input as-btn" onClick={toggle}>
                    <span className="ic"><Icons.Building size={17} /></span>
                    <span style={{ flex: 1, textAlign: 'left', color: who ? 'var(--ink-1)' : 'var(--ink-4)', fontWeight: who ? 600 : 500 }}>{who || `Select ${isInv ? 'customer' : 'supplier'}…`}</span>
                    <span className="chev"><Icons.ChevDown size={16} /></span>
                  </button>
                )}>
                {({ close }) => (
                  <>
                    <MenuLabel>{isInv ? 'Customers' : 'Suppliers'}</MenuLabel>
                    <div style={{ maxHeight: 240, overflowY: 'auto' }}>
                      {parties.map((p) => <MenuItem key={p.id} mark={p.id.slice(0, 1)} label={p.name} sub={`${p.terms} · TIN ${p.tin}`} active={p.name === who} onClick={() => { setWho(p.name); close(); }} />)}
                    </div>
                  </>
                )}
              </Dropdown>
            </div>
            <div>
              <div className="acc-field-lbl">{isInv ? 'Issue date' : 'Bill date'}</div>
              <div className="acc-input"><span className="ic"><Icons.Calendar size={17} /></span><input value={date} onChange={(e) => setDate(e.target.value)} /></div>
            </div>
            <div>
              <div className="acc-field-lbl">Due date</div>
              <div className="acc-input"><span className="ic"><Icons.Clock size={17} /></span><input value={due} onChange={(e) => setDue(e.target.value)} /></div>
            </div>
          </div>

          {/* line items */}
          <div className="acc-field-lbl" style={{ marginBottom: 10 }}>Line items</div>
          <div className="doc-lines-head"><span>Description</span><span className="r">Qty</span><span className="r">Unit price</span><span className="r">Amount</span><span /></div>
          {lines.map((l, i) => (
            <div className="doc-line" key={i}>
              <div className="acc-input sm"><input placeholder="Item or service…" value={l.desc} onChange={(e) => setLine(i, { desc: e.target.value })} /></div>
              <div className="acc-input sm qty"><input inputMode="numeric" value={l.qty} onChange={(e) => setLine(i, { qty: parseNum(e.target.value) })} /></div>
              <div className="acc-input sm"><input inputMode="numeric" placeholder="0" value={l.price ? Number(l.price).toLocaleString('en-US') : ''} onChange={(e) => setLine(i, { price: parseNum(e.target.value) })} /></div>
              <div className="doc-line-amt num">{money((Number(l.qty) || 0) * (Number(l.price) || 0))}</div>
              <button className="acc-line-del" onClick={() => delLine(i)} title="Remove line"><Icons.Trash size={16} /></button>
            </div>
          ))}
          <button className="acc-addline" onClick={addLine}><Icons.Plus size={15} />Add line</button>

          {/* totals + posting preview */}
          <div className="doc-foot-grid">
            <div className="doc-postbox">
              <div className="doc-postbox-h"><Icons.Stack size={15} />This {isInv ? 'invoice' : 'bill'} will post</div>
              {postLines.map((p, i) => (
                <div className="doc-postline" key={i}>
                  <span className={`side ${p.side}`}>{p.side.toUpperCase()}</span>
                  <span className="nm">{acctName(p.ac)}</span>
                  <span className="amt num">{money(p.amt)}</span>
                </div>
              ))}
              <div className="doc-postchk"><Icons.Check size={13} />Balanced · {money(t.total)} = {money(t.total)}</div>
            </div>
            <div className="doc-totals">
              <div className="doc-trow"><span>Subtotal</span><span className="num">{money(t.subtotal)}</span></div>
              <div className="doc-trow"><span>VAT (18%)</span><span className="num">{money(t.vat)}</span></div>
              <div className="doc-trow total"><span>Total</span><span className="num">RWF {money(t.total)}</span></div>
            </div>
          </div>
        </div>

        <div className="acc-comp-foot simple">
          <button className="acc-btn acc-btn-ghost" onClick={() => onSave(build('draft'), 'draft')} disabled={!who} style={!who ? { opacity: .5 } : {}}>Save draft</button>
          <div className="acc-comp-actions">
            {isInv ? (
              <Dropdown align="right" up width={210}
                trigger={({ toggle }) => (<button className="acc-btn acc-btn-primary" disabled={!valid} style={!valid ? { opacity: .5 } : {}} onClick={toggle}><Icons.Mail size={17} />Save &amp; send</button>)}>
                {({ close }) => (
                  <>
                    <MenuLabel>Send invoice via</MenuLabel>
                    <MenuItem icon="Mail" label="Email" sub="To customer's address" onClick={() => { close(); onSave(build('sent'), 'send'); }} />
                    <MenuItem icon="Phone" label="WhatsApp" sub="Send a payment link" onClick={() => { close(); onSave(build('sent'), 'send'); }} />
                    <MenuItem icon="Download" label="Download PDF only" onClick={() => { close(); onSave(build('sent'), 'send'); }} />
                  </>
                )}
              </Dropdown>
            ) : (
              <button className="acc-btn acc-btn-primary" disabled={!valid} style={!valid ? { opacity: .5 } : {}} onClick={() => onSave(build('sent'), 'send')}><Icons.Check size={17} />Record bill</button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── payment modal ───────────────────────────────
const PAY_METHODS = [['1020', 'Bank · Bank of Kigali'], ['1010', 'Cash on Hand'], ['1030', 'Mobile Money (MoMo)']];
function PaymentModal({ kind, doc, onClose, onPaid }) {
  const isInv = kind === 'invoice';
  const t = docTotals(doc.lines);
  const [method, setMethod] = useB('1020');
  const [amount, setAmount] = useB(t.total);
  const [done, setDone] = useB(false);

  const post = isInv
    ? [{ side: 'dr', ac: method }, { side: 'cr', ac: '1100' }]
    : [{ side: 'dr', ac: '2010' }, { side: 'cr', ac: method }];

  if (done) {
    return (
      <div className="acc-modal-scrim" onClick={onClose}>
        <div className="acc-modal sm" onClick={(e) => e.stopPropagation()} style={{ textAlign: 'center' }}>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 13, padding: 38 }}>
            <div style={{ width: 76, height: 76, borderRadius: 24, background: 'var(--gain)', color: '#fff', display: 'grid', placeItems: 'center', boxShadow: '0 16px 34px -10px rgba(22,163,74,.5)' }}><Icons.Check size={36} /></div>
            <div style={{ fontSize: 21, fontWeight: 800 }}>Payment recorded</div>
            <div style={{ fontSize: 13.5, color: 'var(--ink-3)', maxWidth: 300 }}>{isInv ? `${doc.who} paid RWF ${money(amount)}. The invoice is marked paid and the receipt posted to ${acctName(method)}.` : `Paid RWF ${money(amount)} to ${doc.who} from ${acctName(method)}. The bill is settled.`}</div>
            <button className="acc-btn acc-btn-primary" style={{ marginTop: 8 }} onClick={() => onPaid(doc)}>Done</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="acc-modal-scrim" onClick={onClose}>
      <div className="acc-modal" onClick={(e) => e.stopPropagation()}>
        <div className="acc-modal-head">
          <div>
            <div className="acc-modal-title">{isInv ? 'Record payment' : 'Pay bill'}</div>
            <div className="acc-modal-sub">{doc.id} · {doc.who} · {money(t.total)} due</div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-modal-body">
          <div className="acc-mfield">
            <div className="acc-field-lbl">{isInv ? 'Deposit to' : 'Pay from'}</div>
            <div className="acc-seg col">
              {PAY_METHODS.map(([code, label]) => <button key={code} className={method === code ? 'on' : ''} onClick={() => setMethod(code)}>{label}</button>)}
            </div>
          </div>
          <div className="acc-mfield">
            <div className="acc-field-lbl">Amount received</div>
            <div className="acc-input"><span className="ic" style={{ fontWeight: 700, fontSize: 12, color: 'var(--ink-3)' }}>RWF</span><input inputMode="numeric" value={Number(amount).toLocaleString('en-US')} onChange={(e) => setAmount(parseNum(e.target.value))} /></div>
          </div>
          <div className="doc-postbox" style={{ marginTop: 4 }}>
            <div className="doc-postbox-h"><Icons.Stack size={15} />Posts as</div>
            {post.map((p, i) => (
              <div className="doc-postline" key={i}>
                <span className={`side ${p.side}`}>{p.side.toUpperCase()}</span>
                <span className="nm">{acctName(p.ac)}</span>
                <span className="amt num">{money(amount)}</span>
              </div>
            ))}
          </div>
        </div>
        <div className="acc-modal-foot">
          <button className="acc-btn acc-btn-ghost" onClick={onClose}>Cancel</button>
          <button className="acc-btn acc-btn-primary" disabled={amount <= 0} style={amount <= 0 ? { opacity: .5 } : {}} onClick={() => setDone(true)}><Icons.Check size={16} />{isInv ? 'Record payment' : 'Pay bill'}</button>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── document preview ────────────────────────────
function DocPreview({ kind, doc, onClose, onEdit, onPay }) {
  const isInv = kind === 'invoice';
  const t = docTotals(doc.lines);
  const party = (isInv ? CUSTOMERS : SUPPLIERS).find((p) => p.name === doc.who);
  return (
    <div className="acc-modal-scrim" onClick={onClose}>
      <div className="acc-modal doc" onClick={(e) => e.stopPropagation()}>
        <div className="acc-modal-head">
          <div className="flex gap8" style={{ alignItems: 'center' }}>
            <span className="je-id" style={{ fontSize: 15 }}>{doc.id}</span>
            <StatusPill status={doc.status} />
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-modal-body">
          <div className="doc-paper">
            <div className="doc-paper-top">
              <div>
                <div className="doc-paper-co">Demo Shop Ltd</div>
                <div className="doc-paper-meta">Kigali · Rwanda<br />TIN 100928374 · VAT registered</div>
              </div>
              <div className="doc-paper-kind">{isInv ? 'INVOICE' : 'BILL'}</div>
            </div>
            <div className="doc-paper-parties">
              <div>
                <div className="doc-paper-lbl">{isInv ? 'Bill to' : 'From'}</div>
                <div className="doc-paper-party">{doc.who}</div>
                {party && <div className="doc-paper-meta">{party.contact}<br />{party.email}<br />TIN {party.tin}</div>}
              </div>
              <div style={{ textAlign: 'right' }}>
                <div className="doc-paper-row"><span>{isInv ? 'Issued' : 'Bill date'}</span><b>{doc.date}</b></div>
                <div className="doc-paper-row"><span>Due</span><b>{doc.due}</b></div>
                <div className="doc-paper-row"><span>Terms</span><b>{party ? party.terms : 'Net 30'}</b></div>
              </div>
            </div>
            <table className="doc-paper-table">
              <thead><tr><th>Description</th><th className="r">Qty</th><th className="r">Unit price</th><th className="r">Amount</th></tr></thead>
              <tbody>
                {doc.lines.map((l, i) => (
                  <tr key={i}><td>{l.desc}</td><td className="r num">{l.qty}</td><td className="r num">{money(l.price)}</td><td className="r num">{money(l.qty * l.price)}</td></tr>
                ))}
              </tbody>
            </table>
            <div className="doc-paper-totals">
              <div className="doc-trow"><span>Subtotal</span><span className="num">{money(t.subtotal)}</span></div>
              <div className="doc-trow"><span>VAT (18%)</span><span className="num">{money(t.vat)}</span></div>
              <div className="doc-trow total"><span>Total due</span><span className="num">RWF {money(t.total)}</span></div>
            </div>
          </div>
        </div>
        <div className="acc-modal-foot">
          <button className="acc-btn acc-btn-ghost" onClick={() => toast('Generating PDF', { sub: `${doc.id} · ${doc.who}`, icon: 'Download', tone: 'info' })}><Icons.Download size={16} />PDF</button>
          <button className="acc-btn acc-btn-ghost" onClick={onEdit}><Icons.Receipt size={16} />Edit</button>
          {doc.status !== 'paid' && <button className="acc-btn acc-btn-primary" onClick={onPay}><Icons.Wallet size={16} />{isInv ? 'Record payment' : 'Pay bill'}</button>}
        </div>
      </div>
    </div>
  );
}

function InvoicesView() { return <DocListView kind="invoice" />; }
function BillsView() { return <DocListView kind="bill" />; }

Object.assign(window, { InvoicesView, BillsView, DocEditor, PaymentModal, DocPreview, StatusPill });
