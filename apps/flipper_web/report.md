# Accounting Module Verification Report

**Scope:** `apps/flipper_web/lib/modules/accounting`
**Reviewer:** Claude (code audit against double-entry / GAAP-IFRS principles)
**Date:** 2026-06-10
**Backends in scope:** Ditto (primary) and Supabase ledger repositories

---

## 1. Method

I read the full data layer (models, derivation, balances, mappers, posters, repositories, providers), surveyed every view and widget, and ran the existing test suite (`flutter test test/modules/accounting`: **50/50 passing**). I traced each posting path end to end and checked it against core accounting principles: double-entry balancing (debits = credits), normal balances, the accounting equation (Assets = Liabilities + Equity), accrual and matching, and standard report construction (trial balance, income statement, balance sheet, general ledger, aging, VAT).

Two posting paths exist and both feed one ledger:
- **POS path** — `TransactionToAccounts.toJournal` + `TransactionJournalPoster` auto-posts completed/parked POS sales and expenses.
- **Document path** — `DocumentJournalPoster` posts invoices, bills, and payments.

Financial statements are computed from **posted journal entries** via `accountsWithBalances` (`accounting_balances.dart`), not from aggregate estimates. This is the correct architecture.

---

## 2. Verdict

The module is **substantially implemented and architecturally sound**. Double-entry mechanics, normal balances, the trial balance, income statement, balance sheet, general ledger with running balances, accrual revenue recognition, VAT output/input, and AR/AP aging are all present and correct in their math.

However, there are **two correctness gaps that violate accounting principles** and would produce materially wrong financial statements in production, plus several features that are UI-only or seeded with demo data. These are detailed below and must be addressed before the module can be called complete.

---

## 3. What is correctly implemented

| Area | Status | Notes |
|------|--------|-------|
| Account model & normal balances | Correct | `AccountType`, `AccountNormal`, contra flag (`accounting_models.dart`). |
| Double-entry on sales | Correct | `_saleLines`: Dr cash/AR = Cr revenue + Cr VAT; balances for cash, partial-loan, and credit-only sales. |
| Accrual recognition | Correct | Revenue and VAT recognized at sale time; collected portion to liquid accounts, open balance to AR (`accounting_transaction_semantics.dart`). |
| Trial balance | Correct | `trialBalance` places each balance on its normal side; contra accounts handled. |
| Income statement | Correct | Gross revenue, contra discounts, net revenue, COGS, gross profit, opex, net income, margins (`incomeStatement`). Uses IAS 1 profit/loss label. |
| Balance sheet | Correct | Current/fixed assets (contra-aware), current/long-term liabilities, capital, retained earnings = opening + net income, `totalLiabEquity`. |
| General ledger | Correct | `generalLedgerPostings` derives opening balance and computes running balance per normal side. |
| Document postings | Correct & balanced | Invoice (Dr AR / Cr revenue / Cr VAT), bill (Dr inventory or opex + Dr VAT / Cr AP), invoice payment, bill payment (`accounting_document_poster.dart`). |
| Idempotent posting | Correct | Posters dedupe by `transactionId` before creating entries. |
| VAT | Correct | Output/input VAT, net payable, due-date logic (`accountingVatProvider`). |
| AR/AP aging | Mostly correct | `deriveArAging` / `deriveApAging` bucket open balances (see finding 4.6). |
| Money formatting | Correct | Parentheses for negatives per GAAP/IFRS convention. |

---

## 4. Findings (severity-ranked)

### 4.1 HIGH — Cost of sales is never posted; inventory is never relieved
**Files:** `mapper/transaction_to_accounts.dart`, `accounting_document_poster.dart`, `default_chart_of_accounts_seed.dart`

No posting path ever debits **COGS (5010)**. The POS sale entry (`_saleLines`) records only the revenue side. The bill entry increases **Inventory (1200)** on purchase, but nothing ever credits inventory / debits COGS when goods are sold.

Consequences in the live, ledger-derived statements:
- COGS is always **0**, so **gross profit = net revenue** and **net income is overstated**.
- Inventory accumulates indefinitely and is **overstated** on the balance sheet.
- This violates the **matching principle** (cost of a sale must be recognized in the same period as the revenue).

Note: `deriveAccounts` does compute a COGS figure from item `sply_amt`, but that function is **test-only** (not used by any runtime provider) and is itself unbalanced (see 4.3). The production statements get no COGS at all.

**Fix:** On sale, post `Dr COGS (5010) / Cr Inventory (1200)` for the cost of goods (perpetual), or implement a periodic COGS adjustment at period close. Add the COGS lines to `_saleLines`/the POS poster using item cost (`sply_amt`).

---

### 4.2 HIGH — POS cash expenses post to account `6000`, which does not exist in the chart of accounts
**Files:** `mapper/transaction_to_accounts.dart:24` (`_opexCode = '6000'`), `default_chart_of_accounts_seed.dart`

The POS expense entry is `Dr 6000 / Cr liquid`. But the seeded chart of accounts has **no account 6000** (only 6010–6900). When `accountsWithBalances` applies entries, any line whose account code is not in the COA is **silently skipped** (`accounting_balances.dart:16`, `if (acct == null) continue;`).

Result: for every POS cash expense, the **credit to cash is applied but the debit to expense is dropped**. This:
- Breaks double-entry: the **trial balance no longer balances** (debits short by the expense total).
- **Understates operating expenses** and overstates net income.

Confirmed for the **Ditto** seed (`defaultChartOfAccountsSeed` has no 6000). The Supabase seed is a server-side RPC (`seed_default_chart_of_accounts`) not present in this repo, so it is unverified there; the safe assumption is the same gap.

**Fix:** Either add account `6000 Operating Expenses` (sub `Operating expenses`) to the seed, or change `_opexCode` to an existing code (e.g. `6010`) / route through `ChartAccountResolver.operatingExpense`. Also harden `accountsWithBalances` to log/reject lines that reference an unknown account instead of silently discarding one leg of an entry.

---

### 4.3 MEDIUM — `deriveAccounts` produces an unbalanced trial balance and duplicates ledger logic
**File:** `mapper/transaction_to_accounts.dart:31-158`

`deriveAccounts` adds a COGS debit with no offsetting inventory credit, so its account set does not balance whenever COGS > 0. It is currently used only by tests, so it does not affect production, but it is a misleading parallel implementation of balances that the real path (`accountsWithBalances`) already handles.

**Fix:** Either delete `deriveAccounts` (and its tests) in favour of the ledger-derived path, or make it balanced and clearly mark it as a non-authoritative estimate.

---

### 4.4 MEDIUM — Bank reconciliation uses demo seed data and fabricated journal references
**File:** `views/desktop/other_desktop_views.dart` (bank-rec section), `data/accounting_bank_seed.dart`

When the bank-lines stream is empty, the view loads `accountingBankSeedLines` (design-handoff demo data), and matching assigns hardcoded references `JE-${1048 + index}` rather than looking up real journal entries. There is no real bank-statement import.

**Fix:** Wire to a real bank-statement import/source and match against actual posted entries; gate the seed behind a debug/demo flag only.

---

### 4.5 MEDIUM — No test asserts the ledger-level balancing invariants
**File:** `test/modules/accounting/`

The 50 tests cover mappers, semantics, and providers, but none assert, from posted ledger entries: (a) trial balance balanced (totDr == totCr), (b) the accounting equation Assets = Liabilities + Equity, or (c) COGS/inventory behaviour. These would have caught findings 4.1 and 4.2.

**Fix:** Add tests that post representative sales/expenses/bills and assert `trialBalance(...).balanced == true` and `balanceSheet(...).totalAssets == totalLiabEquity`.

---

### 4.6 LOW — Aging buckets use transaction date, not due date, and "current" is same-day only
**File:** `mapper/transaction_aging.dart:65-70`

`_bucketAmount` classifies by days since `created_at`: `current` only when `days <= 0`, then 1-30, 31-60, >60. Standard aging buckets from an **invoice due date** and treat 0-30 days as current. As written, anything one day old falls into the "30-day" bucket.

**Fix:** Age from the document due date and use conventional 0-30 / 31-60 / 61-90 / 90+ ranges.

---

### 4.7 LOW — Several actions are UI-only (toasts) or placeholders
**Files:** various views

Not accounting-logic defects, but incomplete features to track:
- Export to PDF/print (dashboard, financial statements, documents): toast only.
- "File with RRA" VAT return: shows a mock reference, no submission.
- "Add account" (chart of accounts): toast only; no account creation.
- "Invite teammate" / "Team invitations coming soon" (admin roles & users): placeholder.
- Recurring entries "Run now": toast only; recurring entries are not actually posted.
- Send statement / send reminders (contacts, aging): toast only.
- Mobile "More" tab and "Open desktop workspace": navigation stubs.

---

### 4.8 LOW — Missing standard period-end accounting mechanisms
Observed gaps relative to a complete double-entry system:
- **Depreciation:** accounts exist (1510 accumulated depreciation, 6900 depreciation expense) but nothing posts depreciation.
- **Closing entries:** retained earnings is computed live as opening + net income rather than via a period-close closing entry; acceptable for an interim view but not a formal close.
- **Sales discounts (4090):** the contra-revenue account exists but the POS path never posts to it.
- **Multi-currency:** single currency assumed; no FX handling.

---

## 5. Accounting-principle checklist

| Principle | Result |
|-----------|--------|
| Every entry balances (Dr = Cr) at creation | Pass (both posters build balanced entries) |
| Posted ledger trial balance balances | **Fail** — broken by 4.2 (dropped expense debit); also no test guards it |
| Normal balances / contra handling | Pass |
| Accrual revenue recognition | Pass |
| Matching (cost recognized with revenue) | **Fail** — COGS never posted (4.1) |
| Accounting equation A = L + E holds in statements | **At risk** — depends on a balanced ledger; not enforced or tested |
| VAT output/input tracking | Pass |
| AR/AP subsidiary aging | Pass (with 4.6 caveats) |
| General ledger running balances | Pass |
| Idempotent / no double posting | Pass |
| Period close & closing entries | Partial (interim only; no depreciation/closing postings) |

---

## 6. Recommendations (priority order)

1. **Implement COGS / inventory relief on sale** (4.1) — required for correct gross profit and inventory.
2. **Fix the expense account code mismatch** (4.2) — required for a balanced ledger and correct opex; add 6000 to the seed or repoint the poster, and make `accountsWithBalances` fail loudly on unknown account codes.
3. **Add ledger-level invariant tests** (4.5) — trial balance balanced and A = L + E from posted entries.
4. Replace bank-rec demo seed with a real import (4.4).
5. Correct aging to due-date basis and standard buckets (4.6).
6. Complete the UI-only actions (4.7) and period-end mechanisms (4.8) as product scope allows.

---

## 7. What I did

- Audited the accounting data layer file by file and traced both posting paths to the statement-rendering providers.
- Verified double-entry, normal-balance, trial-balance, income-statement, balance-sheet, general-ledger, VAT, and aging logic against accounting principles.
- Surveyed all desktop and mobile views and widgets for stubs, placeholders, and demo/seed data.
- Ran `flutter test test/modules/accounting` (50/50 passing) and noted the coverage gap around ledger-level balancing.
- Identified two high-severity correctness gaps (COGS/inventory relief; expense account mismatch), three medium and several low-severity items, with file/line references and concrete fixes.
- Recorded everything in this report.

**Bottom line:** the engine and reports are well built, but it is **not yet complete or fully correct**. Findings 4.1 and 4.2 must be fixed before the financial statements can be trusted in production.

---

## 8. Fixes applied (this session)

The two high-severity correctness gaps and the ledger-test coverage gap have been resolved:

| Finding | Status | Change |
|---------|--------|--------|
| 4.1 COGS / inventory relief | **Fixed** | POS sale entries now post the matching cost: `Dr COGS (5010) / Cr Inventory (1200)`, summed from line-item supply cost. The cost legs are self-balancing so entries stay balanced. (`mapper/transaction_to_accounts.dart`) |
| 4.2 Expense account `6000` missing | **Fixed** | Added `6000 Operating Expenses` (sub `Operating expenses`) to the seed chart of accounts. (`default_chart_of_accounts_seed.dart`) |
| 4.2 silent line dropping | **Hardened** | `accountsWithBalances` now emits a debug warning when a journal line references an account absent from the COA, instead of silently dropping one leg. (`accounting_balances.dart`) |
| 4.5 missing balancing tests | **Fixed** | Added `test/modules/accounting/data/ledger_balancing_test.dart`: asserts trial balance balances, the accounting equation (Assets = Liabilities + Equity) holds, COGS and cash expenses flow to the income statement, every posted line maps to a seeded account, and that a line to an unknown account is detectable as an imbalance. |
| Supabase seed RPC missing 6000 | **Fixed** | Added migration `supabase/migrations/20260610130000_add_operating_expenses_account.sql`: replaces `seed_default_chart_of_accounts` to include `6000` and backfills it for already-seeded businesses (idempotent). Apply via the normal migration step. |
| Poster transaction/entry index misalignment | **Fixed** | `TransactionJournalPoster.syncTransactions` paired entries to transactions by index, but the entry list is filtered to recognized transactions only, so a non-recognized row shifted the alignment and misattributed transaction ids. Now both sides iterate the same filtered+ordered list. Regression test added in `test/modules/accounting/data/transaction_journal_poster_test.dart`. |

**Verification:** `flutter test test/modules/accounting` now passes **63/63** (was 50). `flutter analyze` on the changed files: no issues.

**Still open (need product/business decisions, not addressed this session):**
- **Bank reconciliation (4.4):** uses demo seed data; needs a decision on the real bank-statement source (file import vs bank API vs manual) before the matching can be wired.
- **Aging due-date basis (4.6):** POS transactions carry no due-date field, only `created_at`. A proper aging fix needs either a due-date/payment-terms field on POS sales or an agreed convention. (Document/invoice aging in the v3 layer already uses a due date.)
- **UI-only actions (4.7):** PDF/print export, RRA VAT filing integration, add-account form, team invitations, recurring "Run now", send statement/reminders, mobile navigation. Each is independent feature work; triage by launch priority.
- **Period-end mechanisms (4.8):** depreciation posting and formal closing entries need business rules (depreciation method, asset lives, whether to lock periods with closing journals).



# Something to note
Aging due-date basis: POS sales have no due-date field, only created_at — needs a due-date/payment-terms field or an agreed convention.

UI-only actions: PDF export, RRA filing integration, add-account form, etc. — triage by launch priority.
Depreciation & closing entries: need business rules (method, asset lives, period-locking).
