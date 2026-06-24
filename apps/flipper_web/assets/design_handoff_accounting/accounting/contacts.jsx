// ===========================================================
//  Flipper Accounting · Contacts — customers & suppliers
//  Master records with contact details, balances and a detail
//  drawer that pulls the contact's invoices/bills + activity.
// ===========================================================
const { useState: useC } = React;

function ContactsView({ kind }) {
  const isCust = kind === 'customers';
  const seed = isCust ? CUSTOMERS : SUPPLIERS;
  const [people, setPeople] = useC(seed);
  const [q, setQ] = useC('');
  const [open, setOpen] = useC(null);   // contact detail
  const [adding, setAdding] = useC(false);

  const ql = q.trim().toLowerCase();
  const list = people.filter((p) => !ql || `${p.name} ${p.contact} ${p.email}`.toLowerCase().includes(ql));
  const totalBal = people.reduce((s, p) => s + p.balance, 0);
  const owing = people.filter((p) => p.balance > 0).length;

  const docsFor = (name) => (isCust ? INVOICES : BILLS).filter((d) => d.who === name);

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">{isCust ? 'Sales' : 'Purchases'}</div>
          <h1 className="acc-h1">{isCust ? 'Customers' : 'Suppliers'}</h1>
          <div className="acc-sub">{isCust ? 'People and businesses you sell to' : 'Vendors you buy from'} · {people.length} records</div>
        </div>
        <div className="acc-pagehead-r">
          <div className="acc-inlsearch">
            <Icons.Search size={16} />
            <input placeholder={`Search ${isCust ? 'customers' : 'suppliers'}…`} value={q} onChange={(e) => setQ(e.target.value)} />
          </div>
          <button className="acc-btn acc-btn-primary" onClick={() => setAdding(true)}><Icons.Plus size={17} />{isCust ? 'New customer' : 'New supplier'}</button>
        </div>
      </div>

      <div className="acc-grid cols-3 mb16">
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.Users size={20} /></span><span className="acc-kpi-lbl">Total {isCust ? 'customers' : 'suppliers'}</span></div><div className="acc-kpi-val">{people.length}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.Receipt size={20} /></span><span className="acc-kpi-lbl">{isCust ? 'With open balance' : 'With bills due'}</span></div><div className="acc-kpi-val">{owing}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic green"><Icons.Wallet size={20} /></span><span className="acc-kpi-lbl">{isCust ? 'Total receivable' : 'Total payable'}</span></div><div className="acc-kpi-val"><small>RWF</small> {money(totalBal)}</div></div>
      </div>

      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>{isCust ? 'Customer' : 'Supplier'}</th><th>Contact</th><th>Phone</th><th>Terms</th><th className="r">{isCust ? 'Owes you' : 'You owe'}</th><th></th></tr></thead>
            <tbody>
              {list.map((p) => (
                <tr key={p.id} className="acc-row-click" onClick={() => setOpen(p)}>
                  <td>
                    <div className="contact-cell">
                      <span className="contact-av" style={{ background: isCust ? 'var(--grad-brand)' : 'linear-gradient(135deg,#0D9488,#0F766E)' }}>{p.name.slice(0, 2).toUpperCase()}</span>
                      <div><div className="je-memo">{p.name}</div><div className="muted" style={{ fontSize: 11.5 }}>Customer since {p.since}</div></div>
                    </div>
                  </td>
                  <td><div style={{ fontSize: 13 }}>{p.contact}</div><div className="muted" style={{ fontSize: 11.5 }}>{p.email}</div></td>
                  <td className="muted num">{p.phone}</td>
                  <td><span className="tag">{p.terms}</span></td>
                  <td className="r num" style={{ fontWeight: 700, color: p.balance > 0 ? 'var(--ink-1)' : 'var(--ink-4)' }}>{p.balance > 0 ? money(p.balance) : '—'}</td>
                  <td className="r" onClick={(e) => e.stopPropagation()}>
                    <Dropdown align="right" width={190}
                      trigger={({ toggle }) => (<button className="acc-iconbtn sm" onClick={toggle}><Icons.More size={18} /></button>)}>
                      {({ close }) => (
                        <>
                          <MenuItem icon="Eye" label="View record" onClick={() => { close(); setOpen(p); }} />
                          <MenuItem icon="Mail" label="Send statement" onClick={() => { close(); toast('Statement sent', { sub: `${p.name} · ${p.email}`, icon: 'Mail', tone: 'success' }); }} />
                          <MenuItem icon="Phone" label="Call contact" onClick={() => { close(); toast(p.contact, { sub: p.phone, icon: 'Phone', tone: 'info' }); }} />
                          <MenuSep />
                          <MenuItem icon="Trash" label="Delete" danger onClick={() => { close(); setPeople((xs) => xs.filter((x) => x.id !== p.id)); toast('Deleted', { sub: p.name, icon: 'Trash', tone: 'info' }); }} />
                        </>
                      )}
                    </Dropdown>
                  </td>
                </tr>
              ))}
              {list.length === 0 && <tr><td colSpan={6}><div className="acc-empty-note">No matches for “{q}”.</div></td></tr>}
            </tbody>
          </table>
        </div>
      </div>

      {open && <ContactDetail kind={kind} person={open} docs={docsFor(open.name)} onClose={() => setOpen(null)} />}
      {adding && <ContactForm kind={kind} onClose={() => setAdding(false)} onSave={(p) => { setPeople((xs) => [{ ...p, id: (isCust ? 'C-' : 'S-') + (xs.length + 1), balance: 0 }, ...xs]); setAdding(false); toast(`${isCust ? 'Customer' : 'Supplier'} added`, { sub: p.name, icon: 'Check', tone: 'success' }); }} />}
    </div>
  );
}

// ───────────────────────────── contact detail drawer ───────────────────────
function ContactDetail({ kind, person, docs, onClose }) {
  const isCust = kind === 'customers';
  return (
    <div className="acc-drawer-scrim" onClick={onClose}>
      <div className="acc-drawer" onClick={(e) => e.stopPropagation()}>
        <div className="acc-drawer-head">
          <div className="flex gap12" style={{ alignItems: 'center' }}>
            <span className="contact-av lg" style={{ background: isCust ? 'var(--grad-brand)' : 'linear-gradient(135deg,#0D9488,#0F766E)' }}>{person.name.slice(0, 2).toUpperCase()}</span>
            <div>
              <div className="acc-drawer-title">{person.name}</div>
              <div className="acc-drawer-sub">{isCust ? 'Customer' : 'Supplier'} · since {person.since} · {person.terms}</div>
            </div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-drawer-body">
          <div className="acc-grid cols-2" style={{ marginBottom: 18 }}>
            <div className="acc-mini-stat"><div className="lbl">{isCust ? 'Outstanding balance' : 'Amount payable'}</div><div className="val num">RWF {money(person.balance)}</div></div>
            <div className="acc-mini-stat"><div className="lbl">{isCust ? 'Lifetime billed' : 'Lifetime purchased'}</div><div className="val num">RWF {money(docs.reduce((s, d) => s + docTotals(d.lines).total, 0))}</div></div>
          </div>

          <div className="acc-detail-sec">Contact details</div>
          <div className="acc-detail-list">
            <div className="acc-detail-row"><span className="ic"><Icons.User size={16} /></span><span className="k">Primary contact</span><span className="v">{person.contact}</span></div>
            <div className="acc-detail-row"><span className="ic"><Icons.Mail size={16} /></span><span className="k">Email</span><span className="v">{person.email}</span></div>
            <div className="acc-detail-row"><span className="ic"><Icons.Phone size={16} /></span><span className="k">Phone</span><span className="v num">{person.phone}</span></div>
            <div className="acc-detail-row"><span className="ic"><Icons.ShieldCheck size={16} /></span><span className="k">TIN</span><span className="v num">{person.tin}</span></div>
          </div>

          <div className="acc-detail-sec" style={{ marginTop: 22 }}>{isCust ? 'Invoices' : 'Bills'} ({docs.length})</div>
          {docs.length ? (
            <table className="acc-table compact">
              <thead><tr><th>{isCust ? 'Invoice' : 'Bill'}</th><th>Date</th><th>Status</th><th className="r">Amount</th></tr></thead>
              <tbody>
                {docs.map((d) => (
                  <tr key={d.id}><td><span className="je-id">{d.id}</span></td><td className="muted">{d.date}</td><td><StatusPill status={d.status} /></td><td className="r num" style={{ fontWeight: 700 }}>{money(docTotals(d.lines).total)}</td></tr>
                ))}
              </tbody>
            </table>
          ) : <div className="acc-empty-note" style={{ padding: 18 }}>No documents yet.</div>}
        </div>
        <div className="acc-drawer-foot">
          <button className="acc-btn acc-btn-ghost" onClick={() => toast('Statement sent', { sub: `${person.name} · ${person.email}`, icon: 'Mail', tone: 'success' })}><Icons.Mail size={16} />Send statement</button>
          <button className="acc-btn acc-btn-primary" onClick={() => toast(isCust ? 'New invoice' : 'New bill', { sub: `For ${person.name}`, icon: 'Plus', tone: 'info' })}><Icons.Plus size={16} />{isCust ? 'New invoice' : 'New bill'}</button>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── add contact form ────────────────────────────
function ContactForm({ kind, onClose, onSave }) {
  const isCust = kind === 'customers';
  const [f, setF] = useC({ name: '', contact: '', email: '', phone: '', tin: '', terms: 'Net 30', since: 'Jun 2026' });
  const set = (k, v) => setF((x) => ({ ...x, [k]: v }));
  const ok = f.name.trim() && f.contact.trim();
  return (
    <div className="acc-modal-scrim" onClick={onClose}>
      <div className="acc-modal" onClick={(e) => e.stopPropagation()}>
        <div className="acc-modal-head">
          <div>
            <div className="acc-modal-title">New {isCust ? 'customer' : 'supplier'}</div>
            <div className="acc-modal-sub">Add a {isCust ? 'customer' : 'supplier'} to your contacts</div>
          </div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-modal-body">
          <div className="acc-mform">
            <div className="acc-mfield"><div className="acc-field-lbl">{isCust ? 'Business / customer name' : 'Supplier name'}</div><div className="acc-input"><span className="ic"><Icons.Building size={16} /></span><input autoFocus placeholder="e.g. Karake Retail Group" value={f.name} onChange={(e) => set('name', e.target.value)} /></div></div>
            <div className="acc-fieldrow" style={{ marginBottom: 0 }}>
              <div className="acc-mfield"><div className="acc-field-lbl">Primary contact</div><div className="acc-input"><span className="ic"><Icons.User size={16} /></span><input placeholder="Full name" value={f.contact} onChange={(e) => set('contact', e.target.value)} /></div></div>
              <div className="acc-mfield"><div className="acc-field-lbl">Phone</div><div className="acc-input"><span className="ic"><Icons.Phone size={16} /></span><input placeholder="+250 …" value={f.phone} onChange={(e) => set('phone', e.target.value)} /></div></div>
            </div>
            <div className="acc-fieldrow" style={{ marginBottom: 0 }}>
              <div className="acc-mfield"><div className="acc-field-lbl">Email</div><div className="acc-input"><span className="ic"><Icons.Mail size={16} /></span><input placeholder="name@email.rw" value={f.email} onChange={(e) => set('email', e.target.value)} /></div></div>
              <div className="acc-mfield"><div className="acc-field-lbl">TIN</div><div className="acc-input"><span className="ic"><Icons.Hash size={16} /></span><input placeholder="Tax ID" value={f.tin} onChange={(e) => set('tin', e.target.value)} /></div></div>
            </div>
            <div className="acc-mfield"><div className="acc-field-lbl">Payment terms</div>
              <div className="acc-seg">{['Net 15', 'Net 30', 'Net 45'].map((t) => <button key={t} className={f.terms === t ? 'on' : ''} onClick={() => set('terms', t)}>{t}</button>)}</div>
            </div>
          </div>
        </div>
        <div className="acc-modal-foot">
          <button className="acc-btn acc-btn-ghost" onClick={onClose}>Cancel</button>
          <button className="acc-btn acc-btn-primary" disabled={!ok} style={!ok ? { opacity: .5 } : {}} onClick={() => onSave(f)}><Icons.Plus size={16} />Add {isCust ? 'customer' : 'supplier'}</button>
        </div>
      </div>
    </div>
  );
}

function CustomersView() { return <ContactsView kind="customers" />; }
function SuppliersView() { return <ContactsView kind="suppliers" />; }

Object.assign(window, { CustomersView, SuppliersView, ContactDetail, ContactForm });
