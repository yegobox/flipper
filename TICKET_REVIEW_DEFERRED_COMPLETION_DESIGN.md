# Ticket Review + Handover — Deferred Completion (design for review)

Status: **PROPOSAL — not yet implemented.** Awaiting sign-off before touching the
tax/receipt pipeline.

## Goal

Change *when* a sale is finalized, **only** when the per-business setting
`Setting.enableTicketReviewWorkflow` is ON. When OFF, behaviour is byte-identical
to today.

```
Workflow ON:
  Pay        → record payment + flag ticket PAID (status = pendingReview).
               NO tax signing, NO RRA receipt, NO fiscal counters, NO stock deduction.
  Reviewer   → marks reviewed (pendingReview → awaitingHandover). status write only.
  Stock Mgr  → Record handover → FINALIZE: RRA sign + receipt + fiscal counters +
               stock deduction (local + RRA), then status → completed.

Workflow OFF:
  Pay → sign + receipt + counters + stock + completed, exactly as today.
```

Decision taken: **stock deducts at handover** (matches "item physically left
stock"). Accepted trade-off: between Pay and handover the item still shows
in-stock and could be oversold on another till.

## Why this is needed / what it fixes

- Today, Pay runs the **entire** finalization and only relabels the status to
  `pendingReview` — the RRA receipt is already signed/printed at Pay. See the
  explicit comment at `packages/flipper_models/lib/helperModels/sale_completion_helpers.dart:47-60`.
- Observed bug: a sale "completed" by the manager did not appear for the reviewer.
  Under this design Pay no longer completes, so the ticket stays in
  `pendingReview` and the Review Queue shows it.

## Current pipeline (verified)

- **`collectPayment`** (`packages/flipper_models/lib/sync/capella_sync.dart:460-739`)
  records payment + sets status **only**. No tax/receipt/journal/stock. The
  `directlyHandleReceipt` param is inert in this path.
- **`finalizePayment`** (`packages/flipper_models/lib/view_models/mixins/_transaction.dart:36-314`)
  is the finalizer. The tax+receipt block is gated on
  `taxEnabled && ebm?.taxServerUrl != null && hasUser && !isTaxServiceStoped && !isLoan && shouldComplete && isFullyPaid`
  (`_transaction.dart:91-97`) — **gated on fully-paid, NOT on status**. So the
  redirect to `pendingReview` does not stop signing today.
  - Sign: `handleReceiptGeneration(signOnly: true)` `_transaction.dart:108` (quick-sell) / `:224` (non-defer)
    → `TaxController.handleReceipt` → `generateReceiptSignature` (`TaxController.dart:825`).
  - EBM fields (`sarNo`, `receiptNumber`, `totalReceiptNumber`, `invoiceNumber`) assigned `TaxController.dart:955-959`.
  - Fiscal counters + `createReceipt`: `scheduleDeferredSaleReceiptPersist` `_transaction.dart:216`
    → `deferred_sale_receipt_persist.dart:70-104` (`saveReceipt` + `updateCounters`).
  - Print: `_presentReceiptAfterSale` `_transaction.dart:199` / `printing()` `_transaction.dart:498` /
    non-fiscal `_transaction.dart:266-293`. Digital-receipt SMS queued `_transaction.dart:472`.
- **Stock** (`packages/flipper_dashboard/lib/mixins/previewCart.dart`): pre-sale
  snapshot `:717`; actual deduction `schedulePostSaleStockDeduction()` `:729-739`
  invoked `:851` → `runPostSaleStockDeductionAndRraSync` (`sale_stock_deduction.dart:233`).
  RRA stock movement is keyed off the **signed invoice number** (`rw_tax.dart:1163-1174`).
- **Status persist**: `markTransactionAsCompleted` (`previewCart.dart:840, 1006-1043`)
  applies `applyTicketReviewWorkflowRedirect`.
- **Handover mutation**: `recordTicketHandover` (`packages/flipper_models/lib/helpers/ticket_review_actions.dart:33-44`)
  is status + audit only.
- **Setting plumbing**: `Setting.enableTicketReviewWorkflow` → box key
  `ticketReviewWorkflowEnabled` (`setting_service.dart:87-93, 257-264`), read at
  `_transaction.dart:710-711` and `previewCart.dart:1008-1009`.

## Proposed changes (file-by-file)

### 1. Pay-time: record-only branch (workflow ON)
In the fully-paid completion path (`finalizePayment` `_transaction.dart:91-97`
and the `previewCart.dart` cash branch), when `ticketReviewWorkflowEnabled`:
- **Skip** signing (`:108`/`:224`), counters/createReceipt (`:216`), print/present
  (`:199`/`:498`/`:266-293`), SMS (`:472`), and stock deduction (`previewCart.dart:851`).
- **Keep** payment recording (`collectPayment` / `applySalePaymentFieldsInMemory`)
  and status persist (`markTransactionAsCompleted` → `pendingReview`).
- Loan / partial / parked outcomes are untouched (they never derive `completed`).

### 2. Extract a context-light `finalizeSale()` helper (the crux)
Today the finalize primitives live in `finalizePayment`/`previewCart` and depend on
the **live cart**, a `formKey`, and EBM config. For handover we must finalize from a
**persisted ticket** instead. New helper (e.g. `finalizeSaleForHandover`) that, given
a ticket id + `BuildContext`:
1. Re-loads the ticket + its line items from Ditto (branch-scoped).
2. Loads EBM config for the ticket's branch.
3. Runs: sign → assign EBM fields → `saveReceipt` + `updateCounters` → print/present
   (+ SMS) → `runPostSaleStockDeductionAndRraSync`.
4. Returns success/failure.
Reuses the existing primitives; the new work is reconstructing inputs from the
persisted ticket rather than the cart. **This is the largest and riskiest piece.**

### 3. Handover action wires finalize
`_recordHandover` (`tickets_list.dart:878`, has context + ref): when workflow ON →
`finalizeSaleForHandover(ticket, context)`; on success → `recordTicketHandover`
(status → COMPLETE); on failure → stay `awaitingHandover`, show error (no receipt lost).
Idempotency: if the ticket already has a `receiptNumber` (partial prior attempt), skip
re-signing; the `requireCurrentStatus` guard + `DeferredSaleReceiptPersist` dedup
(`transaction_mixin.dart:1034`) prevent double transitions.

### 4. Reporting / accounting / journal
- `accounting_transaction_semantics.dart:12-22` recognizes `pendingReview`/`awaitingHandover`
  as revenue. Cash is still collected at Pay, so cash/revenue recognition is fine, **but**
  these rows have **no receipt number until handover**.
- Completed-sale report queries fold in `pendingReview`/`awaitingHandover`
  (`transaction_mixin.dart:229-235, 886-890`). Proposal: **fiscal/EBM reports include only
  signed rows** (post-handover); cash/sales summaries may include paid rows.
- `financiallySettledSaleStatuses` comment "tax already signed"
  (`sale_completion_helpers.dart:65`) becomes false for `pendingReview`; update the comment;
  it is currently only test-referenced, so no live consumer breaks.
- Verify the data-connector journal poster triggers on **`completed`** (not `pendingReview`),
  so journals post at handover.

### 5. EBM sequence
Receipt numbers / `sarNo` are issued at **handover**, so in handover order rather than
sale order. Accepted; confirm RRA tolerates the sale→receipt time gap.

## Edge cases
- Non-EBM (non-tax-registered) branch: still print the non-fiscal receipt at handover.
- Ticket created before the workflow was enabled, or the toggle flipped mid-flight.
- Multiple partial payments / loan tickets never enter `pendingReview` (they park) — unaffected.
- App restart between Pay and handover: finalize must work purely from the persisted ticket.

## Testing
- Unit: record-only branch selection; `finalizeSale` happy path + RRA-failure path;
  `applyTicketReviewWorkflowRedirect` unchanged.
- Manual (workflow ON): Pay → no receipt, status `pendingReview`, stock unchanged →
  Reviewer marks reviewed → Stock Mgr handover → receipt prints, stock deducts, `completed`.
- Manual (workflow OFF): Pay → receipt + stock + completed, unchanged.
- RRA down at handover: ticket stays `awaitingHandover`, clear error, retry works, no double sign.

## Risk summary
- **High:** extracting a cart-independent `finalizeSale` (context/EBM/line-item reconstruction).
- **Medium:** reporting/EBM rows without fiscal fields during the pendingReview→handover window.
- **Medium:** oversell window (stock deducts at handover, by decision).
- **Low:** journal timing (server-side, keyed on `completed`).
