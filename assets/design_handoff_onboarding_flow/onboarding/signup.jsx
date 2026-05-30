const { useState: useStateS, useRef: useRefS, useEffect: useEffectS } = React;

const STEPS = [
  { key: 'who',     title: 'Who are you?',            desc: 'This is how you’ll sign in and how teammates find you.', label: 'Identity' },
  { key: 'contact', title: 'How do we reach you?',     desc: 'We’ll send a one-time code to verify it’s really you.',   label: 'Verify' },
  { key: 'about',   title: 'Tell us about your shop',  desc: 'We’ll tailor Flipper to how you sell.',                  label: 'Business' },
];

const TOTAL_XP = 150;        // earned across signup
const WELCOME_PTS = 500;     // unlocked on completion

function XPChip({ xp, bump }) {
  return (
    <div className={`xp-chip ${bump ? 'bump' : ''}`}>
      <span className="xp-coin"><Icons.Bolt size={11} /></span>
      {xp} XP
    </div>
  );
}

function Field({ icon, label, value, onChange, placeholder, type = 'text', done, action }) {
  const Ico = Icons[icon];
  return (
    <div className="field" style={{ position: 'relative' }}>
      <label className="field-label">{label}</label>
      <div className={`field-box ${done ? 'is-done' : ''} ${action ? 'has-action' : ''}`}>
        <span className="field-ico"><Ico size={19} /></span>
        <input type={type} value={value} placeholder={placeholder}
          onChange={(e) => onChange(e.target.value)} />
        {done && !action && <span className="field-check"><Icons.Check size={13} /></span>}
        {action}
      </div>
    </div>
  );
}

function Signup({ onBack, onDone, intensity }) {
  const [step, setStep] = useStateS(0);
  const [xp, setXp] = useStateS(0);
  const [bump, setBump] = useStateS(false);
  const [pop, setPop] = useStateS(null); // {amount}
  const playful = intensity === 'playful';
  const subtle = intensity === 'subtle';

  // step 1
  const [username, setUsername] = useStateS('');
  const [fullname, setFullname] = useStateS('');
  // step 2
  const [contact, setContact] = useStateS('');
  const [codeSent, setCodeSent] = useStateS(false);
  const [code, setCode] = useStateS('');
  // step 3
  const [usage, setUsage] = useStateS('individual');

  const awarded = useRefS(new Set());
  const award = (key, amt) => {
    if (awarded.current.has(key)) return;
    awarded.current.add(key);
    setXp((x) => x + amt);
    setBump(true); setTimeout(() => setBump(false), 500);
    if (!subtle) { setPop({ amount: amt, id: Date.now() }); setTimeout(() => setPop(null), 1000); }
  };

  // award XP as fields complete
  useEffectS(() => { if (username.trim().length >= 3) award('username', 25); }, [username]);
  useEffectS(() => { if (fullname.trim().length >= 3) award('fullname', 25); }, [fullname]);
  useEffectS(() => { if (contact.trim().length >= 5) award('contact', 25); }, [contact]);
  const otpFull = code.length === 4;
  useEffectS(() => { if (otpFull) award('otp', 50); }, [otpFull]);
  useEffectS(() => { if (step === 2) award('usage', 25); }, [step]);

  const stepValid = [
    username.trim().length >= 3 && fullname.trim().length >= 3,
    contact.trim().length >= 5 && otpFull,
    true,
  ][step];

  const progress = (step + (stepValid ? 1 : 0.45)) / STEPS.length;
  const rewardPct = Math.min(100, Math.round((xp / TOTAL_XP) * 100));

  const next = () => {
    if (step < STEPS.length - 1) setStep(step + 1);
    else onDone({ xp: xp, welcomePts: WELCOME_PTS, name: fullname || username || 'there' });
  };
  const back = () => { if (step === 0) onBack(); else setStep(step - 1); };

  const cur = STEPS[step];

  return (
    <div className="signup fade-screen">
      {/* header */}
      <div className="su-head">
        <button className="icon-circle" onClick={back}><Icons.ChevLeft size={20} /></button>
        <div className="su-progress-wrap">
          <div className="su-steplabel">
            <span className="su-step-t">{cur.label}</span>
            <span className="su-step-n">Step {step + 1} of {STEPS.length}</span>
          </div>
          <div className="su-track">
            <i style={{ width: `${progress * 100}%` }} />
          </div>
        </div>
        <XPChip xp={xp} bump={bump} />
      </div>

      {/* reward banner */}
      {!subtle && (
        <div className="reward-banner">
          <span className="reward-gift"><Icons.Gift size={20} /></span>
          <div className="reward-txt">
            <div className="reward-h">Finish setup to unlock {WELCOME_PTS} points {playful ? '🎁' : ''}</div>
            <div className="reward-p">Spend points on lower fees & premium reports</div>
            <div className="reward-mini-track"><i style={{ width: `${rewardPct}%` }} /></div>
          </div>
          <span className="reward-pts">{xp}/{TOTAL_XP}</span>
        </div>
      )}

      {/* body */}
      <div className="su-body">
        <h2 className="su-title">{cur.title}</h2>
        <p className="su-desc">{cur.desc}</p>

        {pop && (
          <div className="field-xp-pop" key={pop.id} style={{ top: 96, right: 30 }}>+{pop.amount} XP</div>
        )}

        {step === 0 && (
          <>
            <Field icon="User" label="Username" value={username} onChange={setUsername}
              placeholder="e.g. murangwa_eric" done={username.trim().length >= 3} />
            <Field icon="IdCard" label="Full name" value={fullname} onChange={setFullname}
              placeholder="Your full name" done={fullname.trim().length >= 3} />
          </>
        )}

        {step === 1 && (
          <>
            <Field icon="AtSign" label="Phone number or email" value={contact} onChange={setContact}
              placeholder="Phone number or email"
              done={contact.trim().length >= 5 && codeSent}
              action={
                <button className={`send-code ${codeSent ? 'sent' : ''}`}
                  onClick={() => contact.trim().length >= 5 && setCodeSent(true)}>
                  {codeSent ? 'Sent ✓' : 'Send code'}
                </button>
              } />
            {!codeSent && (
              <p className="field-hint">
                <Icons.Info size={13} />
                Enter <b>either one</b> — we’ll send your code by SMS or email, whichever you use.
              </p>
            )}
            {codeSent && (
              <div className="field" style={{ marginTop: 8 }}>
                <label className="field-label">
                  Enter the 4-digit code
                  <span style={{ color: 'var(--ink-3)', fontWeight: 500 }}>· sent to {contact.slice(0, 22)}</span>
                </label>
                <input
                  className={`otp-single ${code.length === 4 ? 'filled' : ''}`}
                  inputMode="numeric" maxLength={4} value={code}
                  placeholder="0000" autoFocus
                  onChange={(e) => setCode(e.target.value.replace(/\D/g, '').slice(0, 4))} />
                <div style={{ fontSize: 12.5, color: 'var(--ink-3)', marginTop: 10, textAlign: 'center' }}>
                  Didn’t get it? <b style={{ color: 'var(--blue)' }}>Resend in 0:28</b>
                </div>
              </div>
            )}
          </>
        )}

        {step === 2 && (
          <>
            <div className="field">
              <label className="field-label">How will you use Flipper?</label>
              <div className="seg2">
                <button className={`seg2-opt ${usage === 'individual' ? 'is-on' : ''}`} onClick={() => setUsage('individual')}>
                  <span className="seg2-ico"><Icons.User size={20} /></span>
                  <span className="seg2-t">Individual</span>
                  <span className="seg2-d">Just me running my sales</span>
                </button>
                <button className={`seg2-opt ${usage === 'business' ? 'is-on' : ''}`} onClick={() => setUsage('business')}>
                  <span className="seg2-ico"><Icons.Building size={20} /></span>
                  <span className="seg2-t">Business</span>
                  <span className="seg2-d">A shop with a team & branches</span>
                </button>
              </div>
            </div>
            <div className="field">
              <label className="field-label">Country</label>
              <div className="select-box">
                <span className="select-flag">🇷🇼</span>
                <span className="sel-val">Rwanda</span>
                <span className="sel-chev"><Icons.ChevDown size={18} /></span>
              </div>
            </div>
            <div className="reward-banner" style={{ marginLeft: 0, marginRight: 0, marginTop: 6, background: 'linear-gradient(120deg,#ECFBF3,#E1F7EA)', borderColor: '#BFE6CF' }}>
              <span className="reward-gift" style={{ background: 'linear-gradient(135deg,#34D399,#10B981)', boxShadow: '0 10px 24px -8px rgba(16,185,129,.5)' }}><Icons.Coins size={20} /></span>
              <div className="reward-txt">
                <div className="reward-h">You’re one tap from {WELCOME_PTS} points</div>
                <div className="reward-p">Plus your first daily streak starts today</div>
              </div>
            </div>
          </>
        )}
      </div>

      {/* footer */}
      <div className="su-foot">
        <button className="btn btn-primary" disabled={!stepValid} onClick={next}>
          {step < STEPS.length - 1 ? 'Continue' : `Create account · claim ${WELCOME_PTS} pts`}
          {step < STEPS.length - 1 ? <Icons.ChevRight size={18} /> : <Icons.Trophy size={18} />}
        </button>
        <div className="su-foot-hint">
          By continuing you agree to Flipper’s <b>Terms</b> & <b>Privacy</b>
        </div>
      </div>
    </div>
  );
}

window.Signup = Signup;
