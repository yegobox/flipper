# Manual Purchase Recording — Design

**Status:** Proposed
**Date:** 2026-06-11
**Owner:** Richard

## 1. Problem

Purchases currently enter Flipper only by being fetched from RRA
(`selectTrnsPurchaseSales` in `purchase_mixin.dart`). A merchant who buys from a
supplier without an EBM device (market vendor, informal supplier, paper
invoice) has no way to record that purchase, so stock, purchase history, and
EBM purchase reporting are all incomplete.

## 2. Goal / Non-goals

**Goal:** Let users record a purchase manually — supplier, invoice, line items,
quantities, prices — and have it flow through the *exact same* approval
pipeline as RRA-fetched purchases (stock increment, StockIO/StockMaster, EBM
`savePurchases` reporting).

**Non-goals:**
- No changes to the RRA fetch/sync behavior.
- No purchase GL/journal posting (none exists today for purchases; tracked
  separately — see §9).
- No mobile/phone layout in v1 (the Import/Purchase dialog is already
  desktop/tablet-only).

## 3. Key design decision: reuse the existing pipeline

A manual purchase is saved locally as a normal `Purchase` row with its variants
in `pchsSttsCd = '01'` (Waiting). It then appears in the existing
`PurchaseTable` and is approved/declined through the existing
`coreViewModel.acceptPurchase()` flow. This gives us, for free and with zero
behavioral divergence:

- Variant mapping to existing catalog items (`_handleVariantMappings`)
- New-variant creation with itemCd generation (`_processNewVariant`)
- Stock increment + `StockIOUtil.saveStockIO` / `saveStockMaster`
- EBM reporting via `_reportPurchaseToTaxService` → `RwTax.savePurchases`

The only pipeline change required is one parameter (§6.3).

## 4. UX design

### 4.1 Entry points

1. **Primary:** a `Record Purchase` button in the header of
   `ImportPurchasePage` when the toggle is in **PURCHASE** mode (next to the
   existing Export icon in `import_purchase_dialog.dart`). Icon:
   `Icons.post_add` (material), label "Record Purchase".
2. The button is hidden in IMPORT mode (imports can only come from RRA).

### 4.2 The Record Purchase dialog

A modal dialog matching `ImportPurchaseDialog`'s visual language: 16px rounded
corners, white surface, header row (icon + title + close), `Divider`, content,
sticky footer with actions. Width clamped to ~900px, height ~80% viewport.

**Section A — Supplier & invoice (top row, 2-column grid)**

| Field | Widget | Validation |
|---|---|---|
| Supplier | `Autocomplete` over `suppliers` table (`supplierListProvider`), free-text allowed for new supplier | required |
| Supplier TIN | TextFormField, numeric | optional; 9 digits if present |
| Invoice No. | TextFormField, numeric | required; warn (non-blocking) if same TIN+invoice already exists |
| Purchase date | Date picker, default today | required, not in future |
| Payment type | Dropdown (`pmtTyCd`: 01 Cash, 02 Credit, 03 Cash/Credit, 04 Bank check, 05 Debit/credit card, 06 Mobile money, 07 Other) | required, default 01 |

If the typed supplier doesn't exist, on save we upsert a `Supplier` row
(separate `suppliers` table — never `customers`, per the model's isolation
rule).

**Section B — Line items (SfDataGrid, same grid styling as `PurchaseTable`)**

- "Add item" opens a search field over `outerVariantsProvider` (existing
  variant search). Selecting a variant pre-fills name, itemCd, taxTyCd, and
  last supply price.
- "New item" adds a blank row (name + tax type B default); on approval the
  existing `_processNewVariant` path creates the catalog entry.
- Editable cells: **Qty** (double > 0), **Unit supply price** (>= 0), **Tax**
  (A/B/C/D dropdown). Read-only: line total.
- Row delete via trailing icon. Minimum 1 row to save.

**Section C — Totals footer (read-only, computed live)**

Taxable amount and tax per bracket (A exempt, B 18% inclusive, C 0%, D),
`totTaxblAmt`, `totTaxAmt`, `totAmt`, `totItemCnt`. Reuse the same
tax-inclusive math used elsewhere (B: `tax = amount * 18 / 118`); do not
re-derive new formulas.

**Footer actions**

- `Cancel` (flat)
- `Save as Waiting` (secondary) — persists with `pchsSttsCd '01'`; appears in
  the Waiting filter of `PurchaseTable` for later review.
- `Save & Approve` (primary, brand cyan `0xFF09D4D9`) — persists, then invokes
  the existing `coreViewModel.acceptPurchase(pchsSttsCd: '02')`. Button shows
  inline `CircularProgressIndicator` while busy; errors surface via the
  existing toast pattern and leave the purchase in Waiting (never lost).

### 4.3 List integration

- Manual purchases render in `PurchaseTable` exactly like RRA ones, plus a
  small neutral "Manual" chip next to the supplier name (driven by
  `regTyCd == 'M'`). No other changes to `PurchaseTable`.

### 4.4 Reporting: how users see all purchases

Because manual purchases are stored as normal `Purchase`/`Variant` rows, the
two existing surfaces include them automatically, with no code changes:

1. **Operational list** — `PurchaseTable` in the Import & Purchase dialog:
   status filter (Waiting/Approved/Declined), pagination, expandable line
   items. This answers "what needs action," not "what did I buy."
2. **Excel export** — the dialog's Export button →
   `ImportPurchaseViewModel.exportPurchase()` → `allPurchasesToDate()` →
   `ExportPurchase().export()` at line-item level (`PurchaseReportItem` =
   variant + purchase header). Manual rows flow in for free.

Neither is a real report (no date range, no supplier grouping, no totals), so
this design adds a **Purchases report** to the Reports area:

- **Where:** new "Purchases" section reachable from `ReportsDashboard`
  (`Reports.dart`) alongside Business Analytics, following the layout patterns
  of `transaction_reports_desktop_screen.dart`.
- **Filters:** date range (reuse `dateRangeProvider` + the existing
  `showDateRangePicker` pattern), supplier (autocomplete), source (All /
  RRA / Manual via `regTyCd`), status (`pchsSttsCd`).
- **Summary cards** (metric-card row): total purchase amount, total VAT
  (input VAT), purchase count, distinct suppliers.
- **Table:** one row per purchase — date, supplier, invoice no., source chip,
  status, item count, taxable amount, VAT, total. Row expands (or drills into)
  line items, same SfDataGrid idiom as `PurchaseTable`.
- **Supplier rollup toggle:** group rows by supplier with subtotals — the
  most-asked "how much did I buy from X this month" view.
- **Export:** reuse `ExportPurchase`, passing the filtered set instead of
  `allPurchasesToDate()` (add an optional filtered overload; existing callers
  unchanged).
- **Data source:** a `purchaseReportProvider(branchId, range, filters)` that
  queries local Brick (offline-first, no RRA calls) — read-only, so zero risk
  to the sync/approval pipeline.

The report ships as phase 7 (after the entry feature), since it is additive
and read-only.

## 5. Data model changes

`packages/supabase_models/lib/brick/models/purchase.model.dart`:

- Add `String? regTyCd;` — `'A'` (automatic/RRA, default) | `'M'` (manual).
  Nullable with null meaning `'A'`, so existing rows and existing RRA fetch
  code need no backfill and no behavior change.
- Brick: regenerate adapters + new SQLite migration via `melos`/build_runner;
  add the column to the Supabase `purchases` table (nullable text).

No `Variant` or `Stock` model changes — manual purchase variants use the same
fields RRA variants already use (`purchaseId`, `pchsSttsCd`, `supplyPrice`,
`retailPrice`, `taxTyCd`, nested `Stock`).

## 6. Service-layer changes

### 6.1 New method: `saveManualPurchase` (purchase_mixin.dart + DatabaseSyncInterface)

```dart
Future<Purchase> saveManualPurchase({
  required Purchase purchase,        // regTyCd: 'M', totals precomputed
  required List<ManualPurchaseLine> lines,
  required String branchId,
});
```

Responsibilities (all local, offline-first via Brick repository):
1. Upsert `Supplier` if new.
2. Upsert `Purchase` (uuid id, `regTyCd 'M'`, bracket totals).
3. For each line: build `Variant` (`pchsSttsCd '01'`, `purchaseId`, qty in
   nested `Stock.currentStock`) mirroring what `selectPurchases()` builds for
   RRA lines, so downstream approval code sees an identical shape.
4. Return the saved purchase for immediate display.

Important: model the variant construction on the existing code path in
`selectPurchases()` (purchase_mixin.dart ~lines 197–418) rather than inventing
a new shape — that is the no-regression guarantee for the approval pipeline.

### 6.2 RRA dedupe guard

`selectPurchases()` must not duplicate a manual purchase if the same invoice
later arrives from RRA: when saving fetched purchases, skip (or merge-tag) any
incoming purchase whose `spplrTin + spplrInvcNo` matches an existing local row.
Verify current dedupe behavior during implementation; add the guard if absent.

### 6.3 `RwTax.savePurchases` — one new parameter

`rw_tax.dart:1652` currently hardcodes `data['regTyCd'] = 'A'`. Add
`String regTyCd = 'A'` to the signature (interface `tax_api.dart:23` too) and
pass it through. `_reportPurchaseToTaxService` (coreViewModel.dart:1326)
forwards `purchase.regTyCd ?? 'A'`. Default preserves existing behavior for
every current caller — this is the only touch to shared pipeline code.

## 7. State management

New `manualPurchaseProvider` —
`StateNotifierProvider.autoDispose<ManualPurchaseNotifier, ManualPurchaseState>`
in `flipper_dashboard` (same pattern as `importPurchaseViewModelProvider`):

- State: supplier fields, invoice meta, `List<ManualPurchaseLine>`, computed
  bracket totals, `isSaving`, `error`.
- All totals computed in the notifier (pure, unit-testable), never in widgets.
- On successful save, invalidate the purchase list state used by
  `ImportPurchasePage` so the new purchase appears without manual refresh.

## 8. No-regression checklist

- [ ] `regTyCd` nullable + defaulted; RRA fetch path writes nothing new.
- [ ] `savePurchases` new param defaulted to `'A'`; all existing call sites
      compile unchanged and send identical payloads.
- [ ] `PurchaseTable` change limited to an additive chip; status filters,
      pagination, accept/decline flows untouched.
- [ ] `acceptPurchase` / `_handleVariantMappings` / `_processNewVariant` /
      `StockIOUtil` not modified.
- [ ] Existing tests pass: `rra_stock_io_payload_test.dart`, dashboard tests.
- [ ] New tests:
  - unit: bracket totals math (A/B/C/D, rounding), dedupe guard,
    `saveManualPurchase` produces variants identical in shape to RRA path
    (golden compare of key fields).
  - widget: form validation (required fields, qty > 0, future date blocked),
    Save & Approve busy/error states.
  - integration: manual purchase → approve → stock incremented + StockIO row
    + `savePurchases` called with `regTyCd 'M'` (mock tax API).

## 9. Follow-ups (out of scope, noted)

- **Purchase GL posting:** sales post journals via `PosJournalPoster`; no
  purchase journals exist (manual or RRA). A `PurchaseJournalPoster`
  (Dr Inventory / Cr Cash-or-AP, deterministic `je_<biz>_<purchase>_purchase`
  id) would complete POS-first accounting — for both purchase sources, so it
  belongs in its own change.
- Attachment of a photo/scan of the paper invoice.
- Phone-layout entry form.

## 10. Implementation order

1. Model + migration (`regTyCd`), adapter regen.
2. `savePurchases` param + `_reportPurchaseToTaxService` forwarding.
3. `saveManualPurchase` + dedupe guard + unit tests.
4. Provider/notifier + totals math + tests.
5. Dialog UI + entry button + chip + widget tests.
6. Integration test, then manual verify of the untouched RRA flow.
7. Purchases report in Reports area (§4.4) — additive, read-only.
