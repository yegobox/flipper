# Handoff: Flipper Accounting ("Flipper Books")

## Overview
A full **SAP-style accounting module** added to **Flipper** (a business OS / POS app; primary market Rwanda, currency **RWF**). It is **double-entry under the hood but approachable on the surface** — usable by both a business **owner** (who reads the numbers and approves) and a **bookkeeper** (who records entries).

> **Updated June 2026.** Two changes since the previous handoff: (1) the desktop **sidebar was re-skinned from deep-navy to the light/white Flipper house style** (matching POS, Daily Reports, Income) — see *Shell layout* and *Design tokens*; (2) a **9-dot app launcher** was added to the topbar that opens an app-switcher grid linking to the other Flipper surfaces. All buttons across every view are wired.

It ships as **two linked surfaces**:

| Surface | File | Role |
|---|---|---|
| **Desktop workspace** | `Flipper Accounting.html` | The workhorse. 1440×912 canvas, sidebar + topbar, 10 modules. Where entries are recorded and reports are read. |
| **Mobile companion** | `Flipper Accounting Mobile.html` | ~412px phone. View the books on the go + **approve pending entries**. |

The desktop topbar has a **phone icon** that links to the mobile file; the mobile **More** tab links back to the desktop file.

---

## About the design files
The files are a **design reference built in HTML + React (via in-browser Babel) + plain CSS** — a runnable prototype showing look, motion, and behavior. **Not production code to copy verbatim.** Rebuild it in the target stack (React/Next for web; React Native for the mobile app) using that project's components, theming, routing, and data layer.

- **CSS files are the source of truth for tokens, spacing, type, color.**
- **JSX files are the source of truth for structure, state, derivation logic, and interaction.**
- **`accounting/data.jsx` is the most important file** — it defines the chart of accounts and the **pure functions that derive every statement**. Port this logic faithfully; the numbers are internally consistent and *must stay that way* (debits always equal credits).

## Fidelity
**High-fidelity.** Match colors, type, spacing, radii, motion, and copy. Exceptions:
- The **Flipper logo** is an approximate recreation of the brand ring mark — replace with the official asset.
- Icons are an inline 1.5px-stroke set (`onboarding/icons.jsx`); substitute your codebase's icon library (Lucide is a near-exact match).
- Demo data (numbers, account names, customer/supplier names) is realistic placeholder — swap for real data.

## Tech & how to run
Open either `.html` file in a browser. Dependencies (pinned in each HTML `<head>`): React 18.3.1, ReactDOM 18.3.1, Babel standalone 7.29.0, Google Fonts **Geist** + **Geist Mono**. All app code is loaded as `<script type="text/babel">`. Components are shared across files via `Object.assign(window, {...})` (in production, use real imports).

---

## Brand & type
- **Fonts:** `Geist` (UI sans) and `Geist Mono` (all numbers — always `font-variant-numeric: tabular-nums; letter-spacing: -.01em`). **Every monetary figure is monospace.**
- **Brand gradient:** `linear-gradient(135deg, #22D3EE 0%, #2563EB 52%, #4F46E5 100%)` (cyan→blue→indigo). Used on the logo, avatars, entity marks.
- **Primary accent:** `#2563EB` (blue). Tweakable.
- Tone: **calm, trustworthy, professional** (money matters) with light Flipper touches — the "Books" badge, an amber "needs approval" nudge, a celebratory "Entry posted & balanced" confirmation. No streaks/XP here.

---

# THE DATA MODEL (port this first)

Everything is derived from one array of accounts. See `accounting/data.jsx`.

## Account shape
```js
{ code: '1020', name: 'Bank · Bank of Kigali', type: 'asset',
  sub: 'Current assets', normal: 'D', bal: 4180000, contra?: true, note?: 'Opening' }
```
- `type`: `asset | liability | equity | income | expense`
- `normal`: `'D'` (debit-normal) or `'C'` (credit-normal). **`bal` is always stored positive in its normal direction.**
- `contra`: true for accounts that sit against their type's normal side (Accumulated Depreciation is a credit-normal asset; Sales Discounts is a debit-normal income account).

## Chart of accounts (exact demo values, RWF)
| Code | Account | Type | Category | Normal | Balance |
|---|---|---|---|---|---|
| 1010 | Cash on Hand | asset | Current assets | D | 1,240,000 |
| 1020 | Bank · Bank of Kigali | asset | Current assets | D | 4,180,000 |
| 1030 | Mobile Money (MoMo) | asset | Current assets | D | 860,000 |
| 1100 | Accounts Receivable | asset | Current assets | D | 2,360,000 |
| 1200 | Inventory | asset | Current assets | D | 5,900,000 |
| 1500 | Equipment & Fixtures | asset | Fixed assets | D | 3,200,000 |
| 1510 | Accumulated Depreciation | asset (contra) | Fixed assets | C | 900,000 |
| 2010 | Accounts Payable | liability | Current liabilities | C | 1,980,000 |
| 2100 | VAT Payable | liability | Current liabilities | C | 640,000 |
| 2300 | Wages Payable | liability | Current liabilities | C | 220,000 |
| 2200 | Bank Loan · Bank of Kigali | liability | Long-term liabilities | C | 4,000,000 |
| 3010 | Owner's Capital | equity | Equity | C | 6,000,000 |
| 3020 | Retained Earnings (opening) | equity | Equity | C | 2,080,000 |
| 4010 | Sales Revenue | income | Operating income | C | 7,240,000 |
| 4020 | Service Income | income | Operating income | C | 360,000 |
| 4090 | Sales Discounts | income (contra) | Operating income | D | 120,000 |
| 5010 | Cost of Goods Sold | expense | Cost of sales | D | 4,200,000 |
| 6010 | Rent | expense | Operating expenses | D | 350,000 |
| 6020 | Salaries & Wages | expense | Operating expenses | D | 520,000 |
| 6030 | Utilities | expense | Operating expenses | D | 95,000 |
| 6040 | Transport | expense | Operating expenses | D | 140,000 |
| 6050 | Marketing | expense | Operating expenses | D | 180,000 |
| 6900 | Depreciation Expense | expense | Operating expenses | D | 75,000 |

## Derivation rules (pure functions)
- **Debit column** of an account = `normal === 'D' ? bal : 0`. **Credit column** = `normal === 'C' ? bal : 0`.
- **Trial balance:** sum of all debit columns = sum of all credit columns. With the values above both totals = **23,420,000** (must stay equal — it's the integrity check shown in the UI).
- **Income statement:**
  - Net revenue = (Sales 7,240,000 + Service 360,000) − Discounts 120,000 = **7,480,000**
  - Gross profit = Net revenue − COGS 4,200,000 = **3,280,000**
  - Total opex = Rent+Salaries+Utilities+Transport+Marketing+Depreciation = **1,360,000**
  - **Net income = Gross profit − Total opex = 1,920,000**
  - Gross margin = grossProfit/netRevenue (43.9%); Net margin = netIncome/netRevenue (25.7%)
- **Balance sheet:** asset value = `contra ? −bal : bal`.
  - Total assets = 1,240,000+4,180,000+860,000+2,360,000+5,900,000+3,200,000−900,000 = **16,840,000**
  - Total liabilities = 1,980,000+640,000+220,000+4,000,000 = **6,840,000**
  - Retained earnings (closing) = opening 2,080,000 + net income 1,920,000 = **4,000,000**
  - Total equity = capital 6,000,000 + retained closing 4,000,000 = **10,000,000**
  - **Liabilities + equity = 16,840,000 = Total assets** ✓ (the "Balanced" check)
- **Cash flow** (illustrative, hard-coded deltas): Operating = netIncome + 75,000 depreciation add-back − 420,000 WC change; Investing = −600,000; Financing = −430,000; Net change = sum.

## Journal entries (the daybook)
```js
{ id:'JE-1046', date:'May 30', memo:'Cash sale — counter (incl. 18% VAT)',
  ref:'POS-8841', status:'posted', src:'POS',
  lines:[ {ac:'1010',dr:283200}, {ac:'4010',cr:240000}, {ac:'2100',cr:43200} ] }
```
- Each line is **either** `dr` **or** `cr` (a number). Every entry's lines balance: `sum(dr) === sum(cr)`.
- `status`: `posted | pending | draft`. `src`: `POS | Manual | Bill | Bank | Payroll`.
- 10 seed entries (JE-1038…1047). **2 are `pending`** (JE-1047 depreciation, JE-1041 salaries) — these drive the approval badge/count everywhere.

## Receivables / Payables aging
Rows of `{ name, inv, current, d30, d60, d90 }` (RWF per bucket). Buckets: **Current / 1–30 / 31–60 / 60+**. AR total = 2,360,000 (matches account 1100); AP total = 1,980,000 (matches account 2010).

## VAT
`rate: 0.18`, `outputVat: 1,280,000`, `inputVat: 640,000`, **netPayable = output − input = 640,000**, `dueDate: '15 Jun 2026'`.

## Trend (charts)
6 months `{ m, rev, exp }` Dec→May, ending May `{rev:7,480,000, exp:5,560,000}`.

## Formatting helpers
- `money(n)`: thousands-separated; **negatives render in parentheses** `(1,234)`.
- `compact(n)`: `1.36M`, `640K`, `3.9B`.

---

# DESKTOP WORKSPACE — `Flipper Accounting.html`

## Shell layout
```
┌────────────┬──────────────────────────────────────────────────────────┐
│            │ Daybook › Journal entries  [⌘K search] [📅May 2026] 🔔 ▦ 📱│  topbar 60px
│  SIDEBAR   ├──────────────────────────────────────────────────────────┤
│  248px     │                                                          │
│  (white)   │   ← scroll area, content max-width 1080px, centered →     │
│            │                                                          │
└────────────┴──────────────────────────────────────────────────────────┘
```
The whole thing is a fixed **1440×912** canvas, JS-scaled to fit the viewport (`scale = min(vw/1440, vh/912)`), letterboxed on `#060912`. (In a real app this is just a responsive desktop layout — drop the scaler.)

**Sidebar** — **light Flipper house style** (`--surface` white, right hairline `--line`; matches POS / Daily Reports / Income). Was deep-navy in the prior version; now:
- Brand row: logo + "Flipper" + a blue "BOOKS" pill (`--blue` on `--blue-tint`).
- **Entity switcher** card (`DS` gradient mark, "Demo Shop Ltd", "FY 2026 · RWF", chevron) on `--surface-2` with `--line` border; hover lifts with `--sh-1`.
- **Grouped nav** (section label uppercase `--ink-4`, then items). Default item text `--ink-2`; hover → `--surface-2` bg + `--ink-1`. **Active item = `--blue-tint` bg with `--blue` text** (no more solid-blue glow pill). Pending badge = amber pill (`--warn-tint`/`--warnamber`); on the active row it inverts to solid blue.
- Footer: user card ("Diane E. · Owner · Bookkeeper", gradient avatar) — hover → `--surface-2`.

Nav groups & items (icon from `onboarding/icons.jsx`):
| Group | Items (icon) |
|---|---|
| Overview | Dashboard (Home) |
| Daybook | Journal entries (Receipt, **badge 2**) · General ledger (Stack) · Bank reconciliation (Refresh) |
| Money | Receivables (ArrowUpRight) · Payables (ArrowDown) · Tax & VAT (ShieldCheck) |
| Reports | Financial statements (Chart) · Trial balance (Group) |
| Setup | Chart of accounts (Building) |

**Topbar:** breadcrumb (`section › view`), spacer, search field with `⌘K` kbd, period button "May 2026", bell with red dot, **9-dot app launcher**, **phone-icon link to the mobile file**.

**App launcher (▦):** the 9-dot grid icon opens a 284px dropdown — a 3-column grid of Flipper apps (Point of Sale, **Books = current/highlighted**, Dashboard, Daily Reports, Income, Commissions, Customers, Inventory, Settings). Each tile = a rounded color-chip icon + label. Tiles with a real screen in the bundle are `<a href>` links (POS, Dashboard, Daily Reports, Income, Commissions); the rest pop an "Opening …" toast as placeholders. Config is the `FLIPPER_APPS` array at the top of `accounting/app.jsx` — repoint `href`s at your real routes. Styles: `.acc-applaunch*` in `accounting.css`.

## Views (10)

### 1. Dashboard ("Books at a glance")
- Page header: eyebrow "FINANCIAL OVERVIEW", H1, subtitle, right actions **Export** (ghost) + **New journal entry** (primary → opens composer).
- **4 KPI cards:** Net income (green TrendUp, +18% delta), Cash & bank (blue Wallet), Receivable (amber, shows overdue 60+), Payable (red ArrowDown, "4 open bills").
- **Split row (1.4fr / 1fr):** "Revenue vs expenses" card with `TrendChart` (legend: blue Revenue, gray Expenses) + "Where money went" card with a `Donut` of operating expenses and a legend list.
- **Split row:** "Recent journal entries" table (5 rows: entry id+date, memo, status pill, amount) + "Profit & loss" mini summary ending in a green "Net income" band.

### 2. Journal entries
- Filter tabs: **All / Posted / Pending(2) / Drafts**. Right: "2 entries awaiting approval" note.
- Table cols: **Entry** (id + date + ref), **Memo & accounts** (memo + the `Dr/Cr account` line summary, Dr in `--dr-ink`, Cr in `--cr-ink`), **Source** tag, **Status** pill, **Amount** (right, mono).

### 3. General ledger
- Account `<select>` (top-right). Shows account header (code, name, type pill, normal side) + **closing balance**. Table with a running-balance column: opening row, then each posting touching that account with Debit/Credit/Balance. Running balance computed by walking `JOURNAL` lines for the selected account and back-solving the opening so the close equals the stored `bal`.

### 4. Bank reconciliation
- 3 KPIs: Statement balance (4,180,000), Matched (X of N), Needs attention (count + amount). Table of bank statement lines `{date, desc, amt, matched, je}`; matched rows show a green "Matched" pill + JE id, unmatched rows show a blue **Match** button. "Finish reconciliation" disabled while unmatched > 0.

### 5 & 6. Receivables / Payables (shared `AgingView`, prop `kind: 'ar' | 'ap'`)
- **Aging summary card:** a single stacked bar (bucket colors below) + 4 bucket tiles with left color border.
- Table: customer/supplier, reference, the 4 bucket columns (60+ in red ink, 31–60 in amber), total. Footer row totals each bucket.
- Bucket colors: **Current `#2563EB`**, **1–30 `#0EA5A4`**, **31–60 `#E89A2A`**, **60+ `#DC2626`**.

### 7. Tax & VAT
- 3 KPIs: Output VAT (green), Input VAT (blue), **Net VAT payable** (amber, gradient card, "Due 15 Jun 2026"). Below: a "VAT return summary" statement card. Primary action "File with RRA".

### 8. Financial statements
- Segmented tabs: **Income statement / Balance sheet / Cash flow**. Right: Print + PDF (ghost).
- Statement card uses the formal `.stmt-*` layout: centered company header, uppercase section heads, rows (`code | label | value`), subtotal rows (top border), a highlighted **total** band (net income = green), and a **"Balanced — assets equal liabilities plus equity"** check row on the balance sheet.

### 9. Trial balance
- "In balance" green pill in header. Table: code, account, **Debit** (blue ink), **Credit** (teal ink), with a bold footer totaling both columns to the same number (23,420,000).

### 10. Chart of accounts
- One table grouped by type (Assets/Liabilities/Equity/Income/Expenses). Each group has a shaded header row with the group's net total. Each account row: code (mono), name (+ "contra"/"Opening" tags), a colored **type pill**, category, balance (contra shown in parentheses, red).

## ⭐ The double-entry composer (signature feature) — `accounting/journal.jsx`
A right-side slide-in panel (720px, scrim `rgba(8,12,22,.55)`), opened by any "New journal entry" button.

```
┌─ New journal entry ─────────────────────────── ✕ ┐
│ Pick the accounts and enter amounts…            │
│ Quick start: [Record a sale][Pay an expense]    │  ← template chips
│              [Receive payment][Pay a bill]       │
│ Date [31 May 2026]   Reference [Auto · JE-1048] │
│ Memo [____________________________________]     │
│ Lines        ACCOUNT          DEBIT     CREDIT   │
│   [Select account ▾]         [   0 ]   [   0 ]  🗑│
│   [Select account ▾]         [   0 ]   [   0 ]  🗑│
│   + Add line                                     │
│   ⓘ Every entry has two sides. Money into an     │
│     account is a debit; money out is a credit…   │
├─────────────────────────────────────────────────┤
│ TOTAL DEBITS = TOTAL CREDITS    [✓ Balanced]    │  ← live meter (foot)
│ [ Save draft ]        [ ✓ Post entry ]          │
└─────────────────────────────────────────────────┘
```
Behavior:
- **Template chips** prefill the account rows (e.g. "Record a sale" → Dr Cash, Cr Sales, Cr VAT Payable — amounts blank) and set the memo.
- Each line: an **account picker** (click → searchable popover grouped by type, shows code + name + current balance) and two amount inputs. **Typing in Debit clears that line's Credit and vice-versa** (a line is one-sided). Amount inputs format with thousands separators as you type.
- **Add line** / delete line (minimum 2 lines kept).
- **Live balance meter:** sums all debits and credits. State = **`ok`** (green) when `totalDr === totalCr && totalDr > 0`, else **`off`** (amber) showing `Enter amounts` (when 0) or **`Off by {amount}`**. 
- **Post entry** is disabled until balanced (and at least one account chosen). On post → a full-panel success state: green check, **"Entry posted & balanced"**, "the ledger, trial balance and statements have all been updated."

---

# MOBILE COMPANION — `Flipper Accounting Mobile.html`

~412px phone shell (`Phone` from `onboarding/frame.jsx`: notch, status bar, home indicator). Flex column: header → (entity chip on home) → scroll body → **bottom tab bar**.

**Bottom tabs:** Snapshot (Home) · **Approvals (ShieldCheck, badge 2)** · Reports (Chart) · More (Grid).

### Snapshot (home)
- Header: logo + "Flipper" + "Books" badge; bell (red dot) + `DE` avatar. Entity chip ("Demo Shop Ltd · FY 2026 · RWF").
- **Net income hero** — blue radial-gradient card, "Net income · May 2026", `+18%` pill, big mono value, footer 3 cells (Revenue / Expenses / Margin).
- **2×2 KPI grid:** Cash & bank, Stock value, Receivable, Payable (compact values).
- **Approval nudge** (amber gradient card) → tap goes to Approvals.
- Revenue-vs-expenses `TrendChart` card; recent-entries list.

### Approvals
- Title + subtitle. One **JE card per pending entry**: header (id, pending pill, memo, meta), the **Dr/Cr line breakdown** (side chip, account name + code, amount color-coded), a green **"Balanced · X = X"** strip, then **Reject** (ghost) / **Approve** (primary) buttons. Acting on a card replaces the buttons with a faded **"Approved & posted"** / **"Sent back to drafts"** flag (local state only).

### Reports
- List rows (icon tile, name, sub) → tap opens a **mobile statement detail** (back chevron header): Income statement, Balance sheet (ends with a "Balanced with total assets" check), Trial balance (all accounts, Dr/Cr color-coded), Tax & VAT.

### More
- Module list (mirrors desktop modules) + a black **"Open desktop workspace"** button linking to `Flipper Accounting.html`.

---

## Interactions & motion
- **Composer panel:** slide-in `translateX(18px)→0` over `.32s cubic-bezier(.22,.9,.3,1)`; scrim fade `.18s`. **Both gated behind `@media (prefers-reduced-motion: no-preference)`** so the end-state (visible) shows under reduced motion / print / capture. Keep this pattern.
- Chart fills/bars animate via CSS width/dash transitions `.5s cubic-bezier(.22,.9,.3,1)`.
- Row hover on tables → `--surface-2` bg. Buttons → `transform: scale(.98)` on `:active`.
- Nav/tab switches are instant (no route transition needed).

## State management
- **Desktop (`AccountingApp`):** `view` (which module, default `'dashboard'`), `composer` (bool). Sub-state inside views: `StatementsView` tab; `GeneralLedgerView` selected account code; `JournalView` filter; `Composer` holds `{memo, lines:[{ac,dr,cr}], picker, posted}`.
- **Mobile (`MAccountingApp`):** `tab` (default `'home'`), `report` (selected statement key or null). `Approvals` holds a `{ [jeId]: 'approve'|'reject' }` map.
- All data is static/derived in this prototype. In production, replace `accounting/data.jsx` reads with your ledger API; the derive functions (`trialBalance`, `incomeStatement`, `balanceSheet`) should run server-side or against fetched accounts.

---

## Design tokens

Shared Flipper tokens live in `onboarding/styles.css` (`--ink-1..4`, `--line*`, `--surface*`, `--blue*`, radii `--r-sm..xl`, shadows `--sh-1..3`, `--sh-blue`, `--sans`, `--mono`). **Accounting-specific additions** (top of `accounting/accounting.css` and `accounting/mobile.css`):

| Token | Value | Use |
|---|---|---|
| `--acc-bg` | `#F1F4FA` | workspace background |
| ~~`--acc-side`~~ | ~~`#0E1626`~~ | **removed** — sidebar now uses `--surface` (white). Active nav uses `--blue-tint`/`--blue`. |
| `--gain` / `--gain-ink` / `--gain-tint` | `#16A34A` / `#15803D` / `#E7F6EE` | positive money, green |
| `--loss` / `--loss-ink` / `--loss-tint` | `#DC2626` / `#B42318` / `#FCECEC` | negative money, red |
| `--warnamber` / `--warn-tint` | `#B45309` / `#FEF3E2` | pending / due, amber |
| `--dr-ink` | `#1D4ED8` | **debit** amounts (blue) |
| `--cr-ink` | `#0F766E` | **credit** amounts (teal) |
| `--row-h` / `--cell-py` | 46px/13px (comfortable), 38px/9px (`.is-dense`) | table density |

**Type scale (key):** page H1 27px/800/−.025em; card title 15.5px/700; table body 13.5px; table head 11px/700 uppercase `.05em`; KPI value 26px/700; statement total 19px/800; all numbers mono + tabular.
**Radii:** cards `--r-lg 20px`; inputs/buttons 10–11px; pills 999px.
**Status pill colors:** posted=green tint, pending=amber tint, draft=neutral. **Type pills:** asset=blue, liability=amber, equity=violet `#7C3AED`, income=green, expense=red.

## Tweaks (prototype-only controls; not part of the product UI)
- **Chart style:** `bars | area | line` (passed to `TrendChart`).
- **Density:** `comfortable | compact` (toggles `.is-dense` → table row height).
- **Accent color:** rewrites `--blue` and derived tints/shadows at runtime.
- Mobile exposes Chart style + Accent.

## Accessibility & responsive notes
- Desktop is a fixed canvas here; rebuild as a fluid layout (sidebar can collapse to icons < ~1100px). Mobile hit targets ≥ 44px (tab bar, approve/reject buttons).
- Debit/credit are **not** distinguished by color alone — they always carry the "Dr"/"Cr" label and column position. Keep that.
- Numbers use tabular figures so columns align.

## Files in this bundle
```
Flipper Accounting.html          desktop entry (loads everything, scaler, Tweaks)
Flipper Accounting Mobile.html   mobile entry
accounting/
  data.jsx       ★ chart of accounts + derive functions + formatting (port first)
  charts.jsx     TrendChart (bars/area/line), Donut, MiniBar
  views.jsx      Dashboard, Chart of Accounts, Statements, Trial Balance, Aging (AR/AP), Tax, General Ledger
  journal.jsx    Journal list + AccountPicker + Composer (the double-entry composer)
  app.jsx        desktop shell: sidebar, topbar (+ 9-dot app launcher), view router, Bank reconciliation view
  interactions.jsx  Dropdown/Menu primitives, ToastHost, search \u2014 used by topbar menus & app launcher
  interactions.css  styles for the above (menus, toasts)
  mobile.jsx     mobile shell + Snapshot, Approvals, Reports, StatementDetail, More
  accounting.css desktop styles + tokens
  mobile.css     mobile styles + tokens
onboarding/      shared deps: styles.css (tokens), icons.jsx, frame.jsx (logo/Phone), tweaks-panel.jsx
```
