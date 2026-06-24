// ===========================================================
//  Flipper Accounting · Admin & controls
//  Recurring schedules · Period close + audit trail · Users & roles
//  These turn "view your books" into "trust & operate your books".
// ===========================================================
const { useState: useAd } = React;

// ───────────────────────────── Recurring schedules ─────────────────────────
function RecurringView({ onNewEntry }) {
  const [rows, setRows] = useAd(RECURRING);
  const activeCount = rows.filter((r) => r.active).length;
  const monthlyTotal = rows.filter((r) => r.active && r.freq === 'Monthly').reduce((s, r) => s + r.amount, 0);

  const toggle = (id) => setRows((rs) => rs.map((r) => {
    if (r.id !== id) return r;
    const next = !r.active;
    toast(next ? 'Schedule resumed' : 'Schedule paused', { sub: r.name, icon: next ? 'Check' : 'Clock', tone: next ? 'success' : 'info' });
    return { ...r, active: next };
  }));
  const runNow = (r) => toast('Entry posted', { sub: `${r.name} · RWF ${money(r.amount)}`, icon: 'Check', tone: 'success' });

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Daybook</div>
          <h1 className="acc-h1">Recurring entries</h1>
          <div className="acc-sub">Rent, salaries and other repeating entries post themselves · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-primary" onClick={() => (onNewEntry ? onNewEntry() : toast('New schedule', { sub: 'Set up a repeating entry', icon: 'Plus', tone: 'info' }))}><Icons.Plus size={17} />New schedule</button>
        </div>
      </div>

      <div className="acc-grid cols-3 mb16">
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic blue"><Icons.Refresh size={20} /></span><span className="acc-kpi-lbl">Active schedules</span></div><div className="acc-kpi-val">{activeCount}<small> of {rows.length}</small></div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic amber"><Icons.Wallet size={20} /></span><span className="acc-kpi-lbl">Monthly committed</span></div><div className="acc-kpi-val"><small>RWF</small> {money(monthlyTotal)}</div></div>
        <div className="acc-card acc-kpi"><div className="acc-kpi-top"><span className="acc-kpi-ic green"><Icons.Calendar size={20} /></span><span className="acc-kpi-lbl">Next run</span></div><div className="acc-kpi-val" style={{ fontSize: 20 }}>01 Jun 2026</div></div>
      </div>

      <div className="acc-card">
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>Schedule</th><th>Frequency</th><th>Next run</th><th>Posts to</th><th className="r">Amount</th><th>Status</th><th></th></tr></thead>
            <tbody>
              {rows.map((r) => {
                const Ico = Icons[r.icon] || Icons.Receipt;
                return (
                  <tr key={r.id} className={r.active ? '' : 'is-muted'}>
                    <td><div className="contact-cell"><span className="rec-ic"><Ico size={17} /></span><span className="je-memo">{r.name}</span></div></td>
                    <td><span className="tag">{r.freq} · {r.day}</span></td>
                    <td className="muted">{r.active ? r.next : '— paused —'}</td>
                    <td className="muted" style={{ fontSize: 12.5 }}>{r.accounts}</td>
                    <td className="r num" style={{ fontWeight: 700 }}>{money(r.amount)}</td>
                    <td>
                      <button className={`acc-switch ${r.active ? 'on' : ''}`} onClick={() => toggle(r.id)} title={r.active ? 'Pause' : 'Resume'}><span className="knob" /></button>
                    </td>
                    <td className="r">
                      <button className="acc-btn acc-btn-ghost acc-btn-sm" disabled={!r.active} style={!r.active ? { opacity: .4 } : {}} onClick={() => runNow(r)}>Run now</button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Period close ────────────────────────────────
function PeriodCloseView({ onView }) {
  const [tasks, setTasks] = useAd(CLOSE_TASKS);
  const [locked, setLocked] = useAd(false);
  const done = tasks.filter((t) => t.done).length;
  const ready = done === tasks.length;

  const check = (id) => setTasks((ts) => ts.map((t) => (t.id === id ? { ...t, done: !t.done } : t)));
  const lock = () => { setLocked(true); toast('Period closed', { sub: 'May 2026 locked · entries are now read-only', icon: 'ShieldCheck', tone: 'success' }); };

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Setup</div>
          <h1 className="acc-h1">Period close</h1>
          <div className="acc-sub">Lock May 2026 once the books are final · RWF</div>
        </div>
        <div className="acc-pagehead-r">
          {locked
            ? <span className="pill posted" style={{ height: 34, fontSize: 13 }}><Icons.ShieldCheck size={14} />May 2026 locked</span>
            : <button className="acc-btn acc-btn-primary" disabled={!ready} style={!ready ? { opacity: .5 } : {}} onClick={lock}><Icons.ShieldCheck size={16} />Close period</button>}
        </div>
      </div>

      <div className="acc-grid split-7-5">
        <div className="acc-card">
          <div className="acc-card-head"><div><div className="acc-card-title">Close checklist</div><div className="acc-card-sub">{done} of {tasks.length} steps complete</div></div></div>
          <div style={{ padding: '4px 8px 12px' }}>
            <div className="close-prog"><i style={{ width: `${(done / tasks.length) * 100}%` }} /></div>
            {tasks.map((t) => {
              const Ico = Icons[t.icon] || Icons.Check;
              return (
                <div key={t.id} className={`close-task ${t.done ? 'done' : ''}`}>
                  <button className={`close-check ${t.done ? 'on' : ''}`} onClick={() => check(t.id)} disabled={locked}>{t.done && <Icons.Check size={14} />}</button>
                  <span className="close-ic"><Ico size={17} /></span>
                  <div className="close-meta"><div className="close-lbl">{t.label}</div><div className="close-detail">{t.detail}</div></div>
                  {!t.done && <button className="acc-card-link" onClick={() => onView(t.go)}>Review <Icons.ChevRight size={13} /></button>}
                </div>
              );
            })}
          </div>
        </div>

        <div className="acc-card">
          <div className="acc-card-head"><div className="acc-card-title">What closing does</div></div>
          <div style={{ padding: '6px 22px 20px' }}>
            <div className="close-note"><span className="ic"><Icons.ShieldCheck size={16} /></span><div><b>Locks the period.</b> Posted entries for May become read-only — no edits without re-opening.</div></div>
            <div className="close-note"><span className="ic"><Icons.Stack size={16} /></span><div><b>Rolls forward.</b> Net income is moved into retained earnings and balances carry into June.</div></div>
            <div className="close-note"><span className="ic"><Icons.Receipt size={16} /></span><div><b>Creates an audit point.</b> A snapshot is logged in the audit trail with your name and time.</div></div>
            <div className="close-foot">
              {ready ? <span style={{ color: 'var(--gain-ink)', fontWeight: 700, display: 'flex', alignItems: 'center', gap: 7 }}><Icons.Check size={16} />All checks passed — ready to close.</span>
                     : <span style={{ color: 'var(--warnamber)', fontWeight: 700, display: 'flex', alignItems: 'center', gap: 7 }}><Icons.Warn size={16} />Finish every checklist step to enable closing.</span>}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Audit trail ─────────────────────────────────
function AuditView() {
  const [who, setWho] = useAd('all');
  const users = ['all', ...Array.from(new Set(AUDIT_LOG.map((a) => a.user)))];
  const rows = AUDIT_LOG.filter((a) => who === 'all' || a.user === who);
  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Setup</div>
          <h1 className="acc-h1">Audit trail</h1>
          <div className="acc-sub">Every change, who made it, and when · immutable</div>
        </div>
        <div className="acc-pagehead-r">
          <Dropdown align="right" width={190}
            trigger={({ toggle }) => (<button className="acc-btn acc-btn-ghost acc-btn-sm" onClick={toggle}><Icons.Filter size={15} />{who === 'all' ? 'All users' : who}</button>)}>
            {({ close }) => (<>
              <MenuLabel>Filter by user</MenuLabel>
              {users.map((u) => <MenuItem key={u} label={u === 'all' ? 'All users' : u} active={u === who} onClick={() => { setWho(u); close(); }} />)}
            </>)}
          </Dropdown>
          <button className="acc-btn acc-btn-ghost acc-btn-sm" onClick={() => toast('Exporting audit log', { sub: `${rows.length} events · CSV`, icon: 'Download', tone: 'success' })}><Icons.Download size={15} />Export</button>
        </div>
      </div>

      <div className="acc-card">
        <div className="acc-timeline">
          {rows.map((a) => {
            const Ico = Icons[a.icon] || Icons.Dot;
            return (
              <div key={a.id} className="tl-row">
                <div className={`tl-ic t-${a.tone}`}><Ico size={16} /></div>
                <div className="tl-body">
                  <div className="tl-top"><b>{a.user}</b><span className="tl-act">{a.action}</span><span className="je-id">{a.target}</span></div>
                  <div className="tl-detail">{a.detail}</div>
                </div>
                <div className="tl-meta"><div className="tl-ts">{a.ts}</div><span className="tag" style={{ height: 20, fontSize: 10.5 }}>{a.role}</span></div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// ───────────────────────────── Users & roles ───────────────────────────────
function RolesView() {
  const [team, setTeam] = useAd(TEAM);
  const [inviting, setInviting] = useAd(false);
  const roleColor = (r) => (ROLES.find((x) => x.role === r) || {}).color || '#64748B';

  return (
    <div className="acc-page">
      <div className="acc-pagehead">
        <div className="acc-pagehead-l">
          <div className="acc-eyebrow">Setup</div>
          <h1 className="acc-h1">Users &amp; roles</h1>
          <div className="acc-sub">Control who can see and change the books</div>
        </div>
        <div className="acc-pagehead-r">
          <button className="acc-btn acc-btn-primary" onClick={() => setInviting(true)}><Icons.Plus size={17} />Invite teammate</button>
        </div>
      </div>

      <div className="acc-card mb16">
        <div className="acc-card-head"><div className="acc-card-title">Team ({team.length})</div></div>
        <div className="acc-tablewrap">
          <table className="acc-table">
            <thead><tr><th>Member</th><th>Email</th><th>Role</th><th>Last active</th><th></th></tr></thead>
            <tbody>
              {team.map((u) => (
                <tr key={u.id}>
                  <td><div className="contact-cell"><span className="contact-av" style={{ background: u.color }}>{u.initials}</span><div className="je-memo">{u.name}{u.you && <span className="tag" style={{ marginLeft: 8 }}>You</span>}</div></div></td>
                  <td className="muted">{u.email}</td>
                  <td>
                    <Dropdown align="left" width={200}
                      trigger={({ toggle }) => (<button className="role-chip" style={{ '--rc': roleColor(u.role) }} onClick={toggle}>{u.role}<Icons.ChevDown size={14} /></button>)}>
                      {({ close }) => (<>
                        <MenuLabel>Change role</MenuLabel>
                        {ROLES.map((r) => <MenuItem key={r.role} label={r.role} sub={r.desc} active={r.role === u.role} onClick={() => { setTeam((ts) => ts.map((x) => (x.id === u.id ? { ...x, role: r.role } : x))); close(); toast('Role updated', { sub: `${u.name} → ${r.role}`, icon: 'ShieldCheck', tone: 'success' }); }} />)}
                      </>)}
                    </Dropdown>
                  </td>
                  <td className="muted">{u.last}</td>
                  <td className="r">
                    <Dropdown align="right" width={170}
                      trigger={({ toggle }) => (<button className="acc-iconbtn sm" onClick={toggle}><Icons.More size={18} /></button>)}>
                      {({ close }) => (<>
                        <MenuItem icon="Mail" label="Resend invite" onClick={() => { close(); toast('Invite resent', { sub: u.email, icon: 'Mail', tone: 'info' }); }} />
                        <MenuItem icon="Trash" label="Remove" danger onClick={() => { close(); setTeam((ts) => ts.filter((x) => x.id !== u.id)); toast('Member removed', { sub: u.name, icon: 'Trash', tone: 'info' }); }} />
                      </>)}
                    </Dropdown>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      <div className="acc-card">
        <div className="acc-card-head"><div><div className="acc-card-title">What each role can do</div><div className="acc-card-sub">Permissions by capability</div></div></div>
        <div className="acc-tablewrap">
          <table className="acc-table perm">
            <thead><tr><th>Capability</th>{ROLES.map((r) => <th key={r.role} className="c"><span className="role-dot" style={{ background: r.color }} />{r.role}</th>)}</tr></thead>
            <tbody>
              {PERMISSIONS.map((p) => (
                <tr key={p.cap}>
                  <td className="je-memo">{p.cap}</td>
                  {ROLES.map((r) => (
                    <td key={r.role} className="c">{p[r.role]
                      ? <span className="perm-yes"><Icons.Check size={15} /></span>
                      : <span className="perm-no"><Icons.Minus size={15} /></span>}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {inviting && <InviteForm onClose={() => setInviting(false)} onSave={(u) => { setTeam((ts) => [...ts, { ...u, id: 'U-' + (ts.length + 1), initials: u.name.split(' ').map((w) => w[0]).join('').slice(0, 2).toUpperCase(), color: '#0891B2', last: 'Invited' }]); setInviting(false); toast('Invite sent', { sub: `${u.email} · ${u.role}`, icon: 'Mail', tone: 'success' }); }} />}
    </div>
  );
}

function InviteForm({ onClose, onSave }) {
  const [f, setF] = useAd({ name: '', email: '', role: 'Bookkeeper' });
  const set = (k, v) => setF((x) => ({ ...x, [k]: v }));
  const ok = f.name.trim() && f.email.trim();
  return (
    <div className="acc-modal-scrim" onClick={onClose}>
      <div className="acc-modal" onClick={(e) => e.stopPropagation()}>
        <div className="acc-modal-head">
          <div><div className="acc-modal-title">Invite teammate</div><div className="acc-modal-sub">They'll get an email to join the books</div></div>
          <button className="acc-comp-close" onClick={onClose}><Icons.X size={18} /></button>
        </div>
        <div className="acc-modal-body">
          <div className="acc-mform">
            <div className="acc-mfield"><div className="acc-field-lbl">Full name</div><div className="acc-input"><span className="ic"><Icons.User size={16} /></span><input autoFocus placeholder="e.g. Aline Mutoni" value={f.name} onChange={(e) => set('name', e.target.value)} /></div></div>
            <div className="acc-mfield"><div className="acc-field-lbl">Email</div><div className="acc-input"><span className="ic"><Icons.Mail size={16} /></span><input placeholder="name@email.rw" value={f.email} onChange={(e) => set('email', e.target.value)} /></div></div>
            <div className="acc-mfield"><div className="acc-field-lbl">Role</div>
              <div className="acc-seg col">{ROLES.map((r) => <button key={r.role} className={f.role === r.role ? 'on' : ''} onClick={() => set('role', r.role)}><b style={{ marginRight: 8 }}>{r.role}</b><span style={{ fontWeight: 500, fontSize: 11.5, opacity: .8 }}>{r.desc}</span></button>)}</div>
            </div>
          </div>
        </div>
        <div className="acc-modal-foot">
          <button className="acc-btn acc-btn-ghost" onClick={onClose}>Cancel</button>
          <button className="acc-btn acc-btn-primary" disabled={!ok} style={!ok ? { opacity: .5 } : {}} onClick={() => onSave(f)}><Icons.Mail size={16} />Send invite</button>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { RecurringView, PeriodCloseView, AuditView, RolesView });
