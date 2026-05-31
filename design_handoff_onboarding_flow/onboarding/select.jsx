const { useState: useStateSel } = React;

// ---- mock data ----
// Model:  User → Business (a shop) → Branch (a location)
const PROFILES = [
  { id: 'p1', name: 'Demo Shop',       sub: 'Owner · 5 branches',   icon: 'Store', tone: 'blue' },
  { id: 'p2', name: 'Murangwa Retail', sub: 'Manager · 1 branch',   icon: 'Store', tone: 'violet' },
];

const BRANCHES = [
  { id: 'b1', name: 'Kigali — Main', sub: 'Nyarugenge', tag: 'Default' },
  { id: 'b2', name: 'Kicukiro',      sub: 'KK 15 Rd' },
  { id: 'b3', name: 'Remera',        sub: 'Gasabo' },
  { id: 'b4', name: 'Musanze',       sub: 'Northern Province' },
];

// ============================================================ Choose a profile
function ChooseProfile({ data, onPick, onLogout }) {
  return (
    <div className="sel fade-screen">
      <div className="sel-head">
        <div className="sel-toprow">
          <div className="welcome-brand">
            <FlipperLogo size={30} />
            <span className="wordmark">Flipper</span>
          </div>
          <button className="sel-greet" onClick={onLogout}>
            <span className="sel-greet-av">{(data?.name || 'F').slice(0,1).toUpperCase()}</span>
            <Icons.ChevDown size={15} />
          </button>
        </div>
        <h1 className="sel-h">Choose a business</h1>
        <p className="sel-sub">Select the business you want to manage</p>
      </div>

      <div className="sel-list screen-scroll">
        {PROFILES.map((p) => {
          const Ico = Icons[p.icon];
          return (
            <button key={p.id} className="sel-card" onClick={() => onPick(p)}>
              <span className={`sel-ico tone-${p.tone}`}><Ico size={22} /></span>
              <div className="sel-card-txt">
                <div className="sel-card-name">{p.name}</div>
                <div className="sel-card-sub">{p.sub}</div>
              </div>
              <span className="sel-chev"><Icons.ChevRight size={20} /></span>
            </button>
          );
        })}
        <button className="sel-add"><Icons.Plus size={18} /> Add a business</button>
      </div>
    </div>
  );
}

// ============================================================ Choose a branch
function ChooseBranch({ profile, onBack, onPick }) {
  const [sel, setSel] = useStateSel('b1');
  const chosen = BRANCHES.find((b) => b.id === sel);
  return (
    <div className="sel fade-screen">
      <div className="sel-head">
        <div className="sel-toprow">
          <button className="icon-circle" onClick={onBack}><Icons.ChevLeft size={20} /></button>
          <div className="sel-org-pill">
            <span className="sel-org-ico"><Icons.Store size={15} /></span>
            {profile?.name || 'Demo Shop'}
          </div>
          <span style={{ width: 44 }} />
        </div>
        <h1 className="sel-h">Choose a branch</h1>
        <p className="sel-sub">Select the branch you want to access</p>
      </div>

      <div className="sel-list screen-scroll">
        {BRANCHES.map((b) => {
          const on = b.id === sel;
          return (
            <button key={b.id} className={`sel-card ${on ? 'is-on' : ''}`} onClick={() => setSel(b.id)}>
              <span className={`sel-ico ${on ? 'tone-blue' : 'tone-mute'}`}><Icons.MapPin size={21} /></span>
              <div className="sel-card-txt">
                <div className="sel-card-name">
                  {b.name}
                  {b.tag && <span className="sel-tag">{b.tag}</span>}
                </div>
                <div className="sel-card-sub">{b.sub}</div>
              </div>
              {on
                ? <span className="sel-check"><Icons.Check size={15} /></span>
                : <span className="sel-radio" />}
            </button>
          );
        })}
      </div>

      <div className="sel-foot">
        <button className="btn btn-primary" onClick={() => onPick(chosen)}>
          Continue to {chosen?.name?.split(' — ')[0] || 'branch'}
          <Icons.ArrowUpRight size={18} />
        </button>
      </div>
    </div>
  );
}

Object.assign(window, { ChooseProfile, ChooseBranch });
