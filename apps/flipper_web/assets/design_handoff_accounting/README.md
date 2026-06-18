# Handoff: Flipper Accounting ("Flipper Books")

## Overview
A full **SAP-style accounting module** added to **Flipper** (a business OS / POS app; primary market Rwanda, currency **RWF**). It is **double-entry under the hood but approachable on the surface** — usable by both a business **owner** (who reads the numbers and approves) and a **bookkeeper** (who records entries).

> **Updated June 2026 (v3).** Major expansion — the module went from "view your books" to **"run your books".** Added **Invoices**, **Bills**, **Customers**, **Suppliers**, **Recurring entries**, **Period close**, **Audit trail**, and **Users & roles** (18 desktop views total, reorganized into Sales / Purchases / Daybook / Reports / Setup). New money documents (invoices, bills, payments) **auto-post balanced double entries** through the same engine. Earlier v2 changes retained: light/white sidebar (Flipper house style) and the 9-dot app launcher. Every button across every view is wired.
>
> **New source files since v2:** `accounting/billing.jsx` (invoices, bills, payment, document preview), `accounting/contacts.jsx` (customers, suppliers, detail drawer), `accounting/admin.jsx` (recurring, period close, audit, roles). `accounting/data.jsx` gained the contact/document/admin datasets. CSS for all new components is appended to `accounting/accounting.css`.

It ships as **two linked surfaces**:

| Surface | File | Role |
|---|---|---|
| **Desktop workspace** | `Flipper Accounting.html` | The workhorse. 1440×912 canvas, sidebar + topbar, **18 modules**. Where entries/invoices/bills are recorded and reports are read. |
| **Mobile companion** | `Flipper Accounting Mobile.html` | ~412px phone. View the books on the go + **approve pending entries**. *(Note: the v3 modules — invoices, bills, contacts, admin — are desktop-only so far; the mobile app still mirrors the original read/approve scope.)* |

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

## v3 datasets (contacts, documents, admin) — `accounting/data.jsx`
These power the new modules. All are plain arrays exported on `window`; in production back them with your API.

**Contacts** — `CUSTOMERS` (6) and `SUPPLIERS` (4), shape:
```js
{ id:'C-01', name:'Karake Retail Group', contact:'Jean-Paul Karake',
  phone:'+250 788 120 440', email:'accounts@karake.rw', tin:'102938471',
  since:'Mar 2024', terms:'Net 30', balance:640000 }
```
Customer `balance` = what they owe (ties to AR); supplier `balance` = what you owe (ties to AP).

**Sales invoices / purchase bills** — `INVOICES` (8) and `BILLS` (5), shape:
```js
{ id:'INV-2210', who:'Umutara Traders', date:'30 May 2026', due:'14 Jun 2026',
  status:'sent', lines:[ {desc:'Wholesale carton · cooking oil 20L', qty:8, price:52000}, … ] }
```
- `who` is the contact name (link by name). `status`: `draft | sent | paid | overdue`.
- **`docTotals(lines, rate=0.18)` → `{subtotal, vat, total}`** — prices are **VAT-exclusive**; subtotal = Σ(qty×price), vat = round(subtotal×0.18). Port this exactly.
- `DOC_STATUS` maps each status → `{label, cls}` where `cls` is the pill class (`draft|sent|posted|overdue`; note `paid`→`posted` reuses the green pill).

**Auto-posting rules (the double entry each document creates):**
| Action | Debit | Credit |
|---|---|---|
| Invoice **sent** | 1100 Accounts Receivable = total | 4010 Sales Revenue = subtotal · 2100 VAT Payable = vat |
| Bill **recorded** | 1200 Inventory = subtotal · 2100 VAT Payable = vat | 2010 Accounts Payable = total |
| Invoice **payment** | chosen cash/bank acct (1010/1020/1030) = amount | 1100 Accounts Receivable = amount |
| Bill **payment** | 2010 Accounts Payable = amount | chosen cash/bank acct = amount |

The editors render this as a live "This invoice will post" preview with a Balanced check — same visual language as the journal composer. In the prototype, posting updates local component state + a toast; wire to your ledger API in production.

**Recurring** — `RECURRING` (5) `{ id, name, freq:'Monthly'|'Quarterly', day, next, amount, accounts, icon, active }`. Drives the schedule table + active/paused toggles + "Run now".

**Audit trail** — `AUDIT_LOG` (8, newest first) `{ id, ts, user, role, action, target, detail, icon, tone }`. `tone`: `green|blue|amber|slate` (timeline icon color). Immutable in concept.

**Team & roles** — `TEAM` (4 members) `{ id, name, initials, color, email, role, last, you? }`; `ROLES` (4) `{ role, desc, color }` = Owner / Bookkeeper / Cashier / Viewer; `PERMISSIONS` (7 capability rows) `{ cap, Owner, Bookkeeper, Cashier, Viewer }` booleans → the permission matrix.

**Period close** — `CLOSE_TASKS` (6) `{ id, label, detail, done, go, icon }`. `go` = the view key to jump to for an incomplete step. Closing is enabled only when all `done`.

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

Nav groups & items (icon from `onboarding/icons.jsx`). Defined as the `NAV` array in `accounting/app.jsx`; each item has a `k` (view key) used by the router and search.
| Group | Items (icon · view key) |
|---|---|
| Overview | Dashboard (Home · `dashboard`) |
| Sales | Invoices (Receipt · `invoices`) · Customers (Users · `customers`) · Receivables (ArrowUpRight · `ar`) |
| Purchases | Bills (Receipt · `bills`) · Suppliers (Truck · `suppliers`) · Payables (ArrowDown · `ap`) |
| Daybook | Journal entries (Stack · `journal`, **badge 2**) · General ledger (Group · `ledger`) · Recurring (Refresh · `recurring`) · Bank reconciliation (Wallet · `bankrec`) |
| Reports | Financial statements (Chart · `statements`) · Trial balance (Group · `trial`) · Tax & VAT (ShieldCheck · `tax`) |
| Setup | Chart of accounts (Building · `coa`) · Period close (Clock · `close`) · Audit trail (Eye · `audit`) · Users & roles (User · `roles`) |

**Topbar:** breadcrumb (`section › view`), spacer, search field with `⌘K` kbd, period button "May 2026", bell with red dot, **9-dot app launcher**, **phone-icon link to the mobile file**.

**App launcher (▦):** the 9-dot grid icon opens a 284px dropdown — a 3-column grid of Flipper apps (Point of Sale, **Books = current/highlighted**, Dashboard, Daily Reports, Income, Commissions, Customers, Inventory, Settings). Each tile = a rounded color-chip icon + label. Tiles with a real screen in the bundle are `<a href>` links (POS, Dashboard, Daily Reports, Income, Commissions); the rest pop an "Opening …" toast as placeholders. Config is the `FLIPPER_APPS` array at the top of `accounting/app.jsx` — repoint `href`s at your real routes. Styles: `.acc-applaunch*` in `accounting.css`.

## Views (18)

Router lives in `AccountingApp` (`accounting/app.jsx`): a `view` state string switches the rendered component. The 10 original views are below; the 8 v3 views follow.

### Original 10

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

### v3 views (Sales / Purchases / Setup)

Components live in `billing.jsx` (invoices, bills), `contacts.jsx` (customers, suppliers), `admin.jsx` (recurring, close, audit, roles). All reuse the existing page header, `.acc-card`, `.acc-table`, KPI, pill, modal and segmented-control patterns.

### 11 & 12. Invoices / Bills (shared `DocListView`, `kind: 'invoice' | 'bill'`)
- 3 KPIs (Outstanding / Overdue / Drafts), status tabs (All / Draft / Sent / Overdue / Paid), and a table: id, party, date, due, **status pill**, amount, and a row `⋯` menu (Open & preview · Edit · Record payment / Pay bill · Send reminder · Delete).
- Row click → **document preview** (`DocPreview`): a formatted invoice/bill "paper" (company block, bill-to, line table, subtotal/VAT/total) with PDF / Edit / Record-payment actions.
- **New invoice/bill** → `DocEditor` (wide right slide-in, 860px): customer/supplier dropdown, date/due, **line-item editor** (description, qty, unit price, computed amount, add/remove rows), and a two-column footer — left = **live posting preview** (the double entry + Balanced check), right = Subtotal / VAT (18%) / Total. Footer: **Save draft** + **Save & send** (invoices show an Email / WhatsApp / PDF menu; bills show **Record bill**). All amounts format with separators as you type; validation requires a party + at least one priced line.
- **`PaymentModal`** (from a row menu or preview): choose deposit/pay account (Bank / Cash / MoMo segmented), amount (auto-filled to total), a posting preview, then a success state; marks the document **paid**.

### 13 & 14. Customers / Suppliers (shared `ContactsView`, `kind: 'customers' | 'suppliers'`)
- Header has an inline search; 3 KPIs (count / with-open-balance / total receivable-or-payable). Table: avatar + name (+ "since"), contact + email, phone, terms tag, balance, row `⋯` menu (View record · Send statement · Call · Delete).
- Row click → **`ContactDetail`** drawer (540px slide-in): avatar header, two mini-stats (outstanding / lifetime), contact detail list, and the contact's documents table. Footer: Send statement + New invoice/bill.
- **New customer/supplier** → `ContactForm` modal (name, contact, phone, email, TIN, payment-terms segmented).

### 15. Recurring entries (`RecurringView`)
- 3 KPIs (active schedules / monthly committed / next run). Table: schedule (icon tile + name), frequency tag, next run, posts-to, amount, an **on/off switch** (`.acc-switch`), and **Run now**. Paused rows render muted with a disabled "Run now".

### 16. Period close (`PeriodCloseView`)
- Split layout. Left: **close checklist** — a progress bar + 6 tasks each with a checkbox, icon, label/detail, and a "Review" link (jumps to the relevant view) when incomplete; checked tasks strike through. Right: "What closing does" explainer + readiness banner. **Close period** button enabled only when all tasks are checked; closing swaps it for a green "May 2026 locked" pill.

### 17. Audit trail (`AuditView`)
- User filter dropdown + Export. A **timeline** (`.acc-timeline`): each row = a toned icon, `<b>user</b> action target`, detail line, and right-aligned timestamp + role tag. Newest first.

### 18. Users & roles (`RolesView`)
- **Team table**: avatar + name (+ "You"), email, an inline **role chip** dropdown (change role), last-active, row menu (Resend invite · Remove). **Invite teammate** → `InviteForm` modal (name, email, role).
- **Permission matrix** (`.acc-table.perm`): capability rows × four role columns, each cell a green check or a neutral dash. Driven by `PERMISSIONS`.

---


---

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
- **Desktop (`AccountingApp`):** `view` (which module, default `'dashboard'`), `composer` (bool), plus `ledgerCode`, `period`, `entity`, `bellUnread`, `jeDetail`. Sub-state inside views: `StatementsView` tab; `GeneralLedgerView` account code; `JournalView` filter; `Composer` `{memo, lines, picker, posted}`.
  - **v3 views hold their own list state** seeded from the data arrays so created/edited/paid records appear live: `DocListView` `{docs, tab, editing, paying, preview}`; `ContactsView` `{people, q, open, adding}`; `RecurringView` `{rows}`; `PeriodCloseView` `{tasks, locked}`; `AuditView` `{who}`; `RolesView` `{team, inviting}`. `DocEditor` holds `{who, date, due, lines, ...}`; `PaymentModal` holds `{method, amount, done}`. These reset on reload (front-end mock).
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
**Status pill colors:** posted=green tint, pending=amber tint, draft=neutral, **sent=blue tint**, **overdue=red tint** (added in v3; `paid` reuses the `posted` green pill). **Type pills:** asset=blue, liability=amber, equity=violet `#7C3AED`, income=green, expense=red.

**v3 component classes** (appended to `accounting/accounting.css`): `.doc-lines-head/.doc-line/.doc-line-amt` (invoice/bill line editor grid), `.doc-postbox/.doc-postline/.doc-postchk` (live posting preview), `.doc-totals/.doc-trow` (subtotal/VAT/total), `.doc-paper*` (printable document preview), `.contact-cell/.contact-av` (avatars), `.acc-drawer*` (contact detail drawer, mirrors composer slide-in), `.acc-mini-stat`, `.acc-detail-row`, `.rec-ic`, `.acc-switch` (toggle), `.close-prog/.close-task/.close-check/.close-note` (period close), `.acc-timeline/.tl-*` (audit), `.role-chip/.acc-table.perm/.perm-yes/.perm-no` (roles). `.acc-iconbtn.sm` = row-action menu trigger; `.acc-inlsearch` = header inline search; `.acc-seg.col` = vertical segmented control; `.acc-composer.wide` = 860px editor.

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
  data.jsx       ★ chart of accounts + derive functions + v3 datasets (contacts/docs/admin) + formatting (port first)
  charts.jsx     TrendChart (bars/area/line), Donut, MiniBar
  views.jsx      Dashboard, Chart of Accounts, Statements, Trial Balance, Aging (AR/AP), Tax, General Ledger
  journal.jsx    Journal list + AccountPicker + Composer (the double-entry composer)
  billing.jsx    ★ v3 — Invoices, Bills (DocListView), DocEditor, PaymentModal, DocPreview, StatusPill
  contacts.jsx   ★ v3 — Customers, Suppliers (ContactsView), ContactDetail drawer, ContactForm
  admin.jsx      ★ v3 — RecurringView, PeriodCloseView, AuditView, RolesView, InviteForm
  app.jsx        desktop shell: sidebar, topbar (+ 9-dot app launcher), view router, Bank reconciliation view
  interactions.jsx  Dropdown/Menu primitives, ToastHost, search \u2014 used by topbar menus & app launcher
  interactions.css  styles for the above (menus, toasts)
  mobile.jsx     mobile shell + Snapshot, Approvals, Reports, StatementDetail, More
  accounting.css desktop styles + tokens (+ all v3 component styles)
  mobile.css     mobile styles + tokens
onboarding/      shared deps: styles.css (tokens), icons.jsx, frame.jsx (logo/Phone), tweaks-panel.jsx
```
