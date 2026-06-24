# Plan for Full Accounting Feature Integration in Flipper

This document outlines a phased approach to build **native** accounting in Flipper: double-entry bookkeeping, chart of accounts, journals, and financial reports—**without** integrating external ERPs like Odoo. The design is **conceptually aligned** with how mature accounting systems (including Odoo’s `account` module) structure data, so the domain model stays familiar to accountants and future features (reconciliation, multi-currency) have a clear place to grow.

---

## Architecture (Ditto + Supabase + flipper-turbo)

| Layer | Role |
|-------|------|
| **Ditto (local mesh DB)** | **Primary event source for operational data** in Flipper—including **transactions** as they appear, update, and sync across devices. Accounting automation should **listen** to the relevant Ditto collection(s) (same pattern as elsewhere: `DittoService` / `registerObserver` / subscription queries on your transaction store). When a transaction reaches an **accounting-eligible** state (e.g. finalized, paid, closed—define explicitly), the listener triggers the posting pipeline. Ditto may fire **multiple times** for the same logical document (sync, retries, observer replays); **always** treat turbo as idempotent via `transaction_id`. |
| **Supabase (Postgres)** | System of record for **posted GL data**: migrations under `supabase/migrations`, RLS per `business_id`. **No Brick** for accounting tables—query via PostgREST. Transactions may also sync to Supabase via your existing pipelines; Ditto remains the **real-time listener surface** in the app even when Supabase is eventually consistent. |
| **flipper-turbo (Kotlin)** | **Authoritative backend** for rules that must not be bypassed: creating/posting `journal_entries` + `journal_lines` (balanced lines, idempotency, closed periods), seeding COA and settings, heavy reporting. Same stack as today: `SupabaseProvider.client` + PostgREST, plus HTTP resources (e.g. alongside `PlanResource.kt`). The Flutter side calls turbo when Ditto signals a row worth posting. |
| **Flutter app** | **(1)** Ditto observers → **request** journal creation from turbo for eligible transactions. **(2)** Direct Supabase reads for chart of accounts, GL browse, posted moves (where RLS allows). **(3)** HTTP to turbo for manual journals, init accounting, close period. Optional plain Dart DTOs for JSON—**not** Brick for GL. |

**Data flow (transaction → books):**  
`Ditto transaction change` → filter (business, branch, status, not already posted) → `POST flipper-turbo …/journal-entries/from-transaction` (payload includes stable transaction id + amounts) → turbo validates and writes to Supabase → optional: store `journal_entry_id` or posting flag back on the transaction in Ditto/Supabase for UI and deduplication.

**Offline / connectivity:** If turbo is unreachable, **queue** the intent (transaction id + version/hash) locally and retry with backoff; turbo’s `(business_id, transaction_id)` uniqueness prevents double posting when the device comes online or the observer fires again.

**Posting strategy:** **Server-side posting only** (turbo writes GL rows) so unbalanced or forged entries cannot be inserted via the client. Ditto listeners only **suggest** posts; turbo **decides** and persists.

---

## Implementation status (repository)

| Area | Status |
|------|--------|
| Supabase migrations (`chart_of_accounts`, `journal_entries`, `journal_lines`, …) | **Not started** |
| flipper-turbo: DTOs + `AccountingManager` / `AccountingResource` (or equivalent) | **Not started** |
| Flutter: Supabase reads + API client for accounting endpoints | **Not started** |
| Flutter: **Ditto observer / bridge** (transactions → turbo posting, retry queue) | **Not started** |
| Transaction → journal automation (Ditto-driven + turbo idempotency) | **Not started** |
| `packages/flipper_accounting` UI | **Not started** |
| Optional `packages/accounting_models` (plain Dart types only, if you want shared shapes) | **Not started** — package folder may exist; no requirement to use Brick |

When you implement a line item below, update this table so the doc stays truthful.

---

## Design alignment (Odoo-style concepts, Flipper names)

These are **analogues**, not a requirement to match Odoo’s table names.

| Concept (Odoo-style) | Purpose | Flipper entity (this plan) |
|----------------------|---------|----------------------------|
| Chart of accounts | Classify every balance (asset, liability, …) | `chart_of_accounts` |
| Journal | Groups entries (sales, purchases, bank, misc.) and default accounts / numbering | **`accounting_journals`** (recommended; see Phase 1.2) |
| Journal entry / move | One balanced posting event (header) | `journal_entries` |
| Move line | Debit or credit on an account | `journal_lines` |
| Partner on line | Sub-ledger (AR/AP per customer/vendor) | Optional `partner_id` on `journal_lines` (later) |
| Draft → Posted | Edit until posted; reports use posted only | `status` on `journal_entries` |
| Fiscal period | Close periods to block back-dating | `financial_periods` |
| Entry sequence | Human-readable refs (`SAL/2026/00042`) | Optional `reference` + sequence table or counter per journal (later) |

---

## Phase 1: Foundation — Supabase schema and Kotlin services

Establish tables and **flipper-turbo** logic that enforces **total debits = total credits** and **idempotency**.

### 1.1. Database schema (Supabase / Postgres)

Define enums as `text` + check constraints or Postgres enums—keep consistent with existing migrations.

**`chart_of_accounts`**

| Column | Notes |
|--------|--------|
| `id` | `uuid` PK |
| `business_id` | FK / tenant index |
| `account_name` | text |
| `account_code` | text, nullable |
| `account_type` | `asset` \| `liability` \| `equity` \| `revenue` \| `expense` |
| `description` | nullable |
| `parent_account_id` | nullable, self-FK |
| `is_active` | boolean, default true |
| `created_at`, `updated_at` | optional |

**`journal_entries`**

| Column | Notes |
|--------|--------|
| `id` | `uuid` PK |
| `business_id` | indexed |
| `accounting_journal_id` | nullable FK → `accounting_journals` |
| `date` | `date` or `timestamptz` |
| `reference` | nullable (sequence output) |
| `description` | text |
| `transaction_id` | nullable, unique per `business_id` where set (idempotency for automated moves) |
| `status` | `draft` \| `posted` \| `reversed` |
| `created_at`, `updated_at` | optional |

**`journal_lines`**

| Column | Notes |
|--------|--------|
| `id` | `uuid` PK |
| `journal_entry_id` | FK → `journal_entries` ON DELETE CASCADE |
| `account_id` | FK → `chart_of_accounts` |
| `side` | `debit` \| `credit` |
| `amount` | `numeric` (same currency as business v1) |
| `partner_id` | nullable (future AR/AP) |
| `memo` | nullable |

**`financial_periods`**

| Column | Notes |
|--------|--------|
| `id`, `business_id`, `start_date`, `end_date`, `status` (`open` \| `closed`) | |

**`accounting_settings`**

| Column | Notes |
|--------|--------|
| `id`, `business_id` | one row per business (unique on `business_id`) |
| `cash_account_id`, `accounts_receivable_account_id`, `inventory_account_id`, `accounts_payable_account_id`, `taxes_payable_account_id`, `owners_equity_account_id`, `sales_revenue_account_id`, `cost_of_goods_sold_account_id`, `sales_returns_account_id` | nullable UUIDs → `chart_of_accounts` |

Add **indexes** on `(business_id)`, line `(journal_entry_id)`, line `(account_id)`, entry `(transaction_id)` where used.

**RLS:** Mirror existing patterns (e.g. `business_id` in JWT / `auth.uid()` mapping). Prefer **select** for reporting tables from the app; **insert/update** on posted moves only through service role from turbo, or tightly scoped policies if you must allow drafts from the client.

### 1.2. Accounting journals (recommended, Odoo-style)

Table **`accounting_journals`**: `id`, `business_id`, `code`, `name`, `type` (`sales`, `purchase`, `cash`, `bank`, `misc`), optional `default_debit_account_id` / `default_credit_account_id`, `sequence_prefix`, etc.

- `journal_entries.accounting_journal_id` → `accounting_journals.id`
- Seed standard journals when initializing accounting for a business (turbo).

### 1.3. flipper-turbo (Kotlin)

Follow existing structure: data classes (like `Plan`, `Invoice`) for `decodeList` / insert payloads; a manager class for orchestration; optional REST resource for HTTP entrypoints.

**Responsibilities:**

- **Initialize accounting for business**: insert default COA rows, `accounting_journals`, and one `accounting_settings` row with FKs filled.
- **`createJournalEntry`**: accept header + lines; validate **Σ debits = Σ credits**; all `account_id` belong to same `business_id`; optional unique `(business_id, transaction_id)` for automation; reject posting if `date` falls in a **closed** `financial_period`.
- **CRUD** for chart and journals as needed (or expose only via turbo if you want a single API surface).
- **Period close / reopen** (reopen guarded).

**Integration with Supabase:** same as `PlanManager.kt`—`supabase.from("journal_entries").insert(...)`, etc. Use **RPC or a single DB transaction** (Postgres function) if you need atomic header+lines insert; otherwise implement careful ordering and compensating deletes on failure.

**HTTP:** e.g. `POST /accounting/journal-entries`, `POST /accounting/businesses/{id}/init`, `POST /accounting/periods/{id}/close`—match your routing style in flipper-turbo.

### 1.4. Flutter (types only, optional)

If helpful, add plain Dart classes (JSON from Supabase or turbo) **without** Brick. The app uses `Supabase.instance.client.from('chart_of_accounts').select()` (or your wrapper) for reads and `HttpApi` / `dio` to turbo for posts.

---

## Phase 2: Integrating with Existing Business Logic (Ditto-first)

### 2.1. Transaction-to-Journal-Entry Mapping

Translate **accounting-eligible** transactions into `journal_entries` + `journal_lines` (same rules as before):

- **On sale (cash, with tax)** — Debit Cash; Credit Sales revenue; Credit Taxes payable; optional COGS/Inventory lines.
- **On purchase** — Debit Inventory (or expense); Credit Cash or A/P.
- **On return / refund** — Debit Sales returns (or policy); Credit Cash.

Use **`transaction_id`** = stable transaction id (match Ditto document id / your canonical `ITransaction` id) for **idempotency** on turbo.

### 2.2. Listen on Ditto, post via turbo (primary pipeline)

Flipper already centers **Ditto** for live transaction data and cross-device sync (`DittoService`, `registerObserver`, coordinators). Accounting should plug into that:

1. **Subscription / observer** on the Ditto SQL or collection that backs **transactions** (scope by `businessId` / `branchId` like other observers).
2. **onChange** handler: inspect each affected document; proceed only when status (and any other fields) match your **“ready for GL”** predicate—e.g. completed sale, payment captured, not voided.
3. **Call turbo** with a compact payload (transaction id, business id, type, totals, tax lines as needed). Turbo loads authoritative detail from **Supabase** if the transaction is replicated there, or trusts signed fields if the transaction exists only in Ditto (document the rule).
4. **Dedup**: before calling turbo, optional local cache of “already submitted transaction ids for posting” to reduce chatter; turbo must still enforce uniqueness on `(business_id, transaction_id)`.
5. **Corrections**: if a transaction is **edited** after posting, define policy (reversing entry + new move, or block edits)—Ditto will emit updates; the observer must not blindly repost.

### 2.3. Secondary paths (avoid double posting)

- If **turbo** already creates a journal when it handles a payment webhook, **do not** also post from Ditto for the same transaction—or use a single **source of truth** flag (e.g. only Ditto listener, or only turbo).
- If transactions are mirrored to Supabase, you could alternatively use DB triggers or jobs; on Flipper product direction, **Ditto listener in the app** remains important for **mesh-local** and **offline** scenarios where Supabase lags.

Implement exactly **one** automatic posting path per transaction type unless they are strictly disjoint (different id spaces).

---

## Phase 3: User Interface — Management and Visualization

New package: `packages/flipper_accounting`.

- **Chart of accounts**: data from Supabase `.select()`, filtered by `business_id`.
- **General ledger**: query `journal_lines` joined to `journal_entries` (view or client-side join) with date filter; **running balance** computed in Flutter or returned from a turbo report endpoint for large datasets.
- **Manual journal entry**: form posts to **turbo**; turbo validates balance and period.

---

## Phase 4: Financial Reporting

### 4.1. Reporting logic

**Ditto listeners do not replace reporting.** Listening on Ditto is for **ingestion**: noticing that a **transaction** changed and asking turbo to create/update **journal entries**. A **trial balance** or **P&amp;L** is not “incoming Ditto data”—it is a **read-time aggregate** over **posted rows** in `journal_entries` / `journal_lines` (in Supabase). Ditto may hold live POS transactions; it typically does **not** hold the full GL history in a form you sum for statutory-style reports, and you should not try to rebuild the books by replaying every Ditto transaction from scratch on each report.

So reports are served by **querying the ledger in Postgres** (directly from Flutter with RLS, via SQL views, or via **turbo endpoints** that run those queries for heavy joins, pagination, or server-side export).

Implement aggregation in **Kotlin** (turbo) and/or SQL: trial balance, income statement, balance sheet, simplified cash flow. Options:

- SQL aggregates / views in Postgres, called from turbo; or  
- Kotlin reduction over query results for v1.

Respect **posted-only** and **closed periods**.

Expose as turbo endpoints (e.g. `GET /accounting/reports/trial-balance?...`) or read-only Supabase views / `.select()` from the app if RLS and performance allow.

### 4.2. Reporting UI

Flutter: date range, drill-down to GL, export CSV/PDF (generate in app or via turbo).

---

## Phase 5: Accounting Settings UI

- Fiscal year / period generation (turbo or migration job).
- Edit **default accounts** in `accounting_settings` (via turbo or restricted Supabase update).
- Close period action → turbo.

---

## Phase 6: Testing and Validation

- **Kotlin unit tests** in flipper-turbo: balance validation, idempotency key, closed period rejection.
- **Integration tests**: Supabase test project or Testcontainers + real migrations.
- **Flutter / Ditto**: observer fires twice for same transaction → still **one** journal; offline queue flush → no duplicate; status regression (posted then voided) matches policy.
- **Flutter/widget tests**: forms and navigation only where valuable.

---

## Phase 7: Future Enhancements (Odoo-parity style)

- Budgeting, bank reconciliation, multi-currency, tax reports.
- Sequences per journal, reconciliation of AR/AP, analytic dimensions on lines.

---

## Related Flipper code (today)

- **Ditto**: `DittoService` / `DittoSyncRegistry` / `DittoSyncCoordinator`; observers similar to `whatsapp_message_sync_service.dart` (`registerObserver`, `onChange`). Use the same patterns to watch **transaction** documents and forward eligible events to turbo.
- **flipper-turbo** uses the Kotlin Supabase client (e.g. `PlanResource.kt`, `PlanManager.kt`, `Invoice` flows)—extend the same way for accounting tables and posting endpoints.
- Subscription **`invoices`** in turbo are **billing** documents, not GL **journal entries**; decide whether plan charges also create `journal_entries` (separate id / link metadata). Ditto may not be the source for those—turbo-only posting may be enough.

---

## Document maintenance

When implementation lands, update the **Implementation status** table and keep the **Architecture** section in sync if you change posting rules (e.g. allow direct Supabase inserts for drafts).
