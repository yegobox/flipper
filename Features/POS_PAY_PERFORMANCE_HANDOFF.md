# POS Pay — performance & completion handoff

Branch: `fix/payment_improvements`. Written 2026-09-04, end of a long debugging
session. Everything below is committed; nothing is pushed.

## Where things stand

Reported symptom at the start: clicking Pay could take 5+ minutes or never
complete. Current state after the work below: **Pay is fast, the receipt appears
immediately, the cart clears.** One symptom was open when the session ended and
one question is unanswered.

### Open item 1 — Pay button kept spinning after a completed sale

Last fix for this (`fcc053a7e`) was committed but **not yet confirmed on device**.
The theory: both completion paths awaited `WidgetsBinding.instance.endOfFrame`
between clearing the cart and releasing the spinner, and that future only
completes when a frame is actually produced. The operator alt-tabs to a terminal
to watch logs, macOS stops painting the window, and everything after the await
stalls — toast, `stopLoading()`, the completion-lock release, and the return
value `PreviewSaleButton` waits on. Both awaits are now bounded by
`awaitFrameOrSkip` (`flipper_dashboard/lib/utils/frame_sync.dart`).

**Confirm this first.** If the spinner still sticks with the window focused, the
theory is wrong and the cause is elsewhere.

### Open item 2 — is completion still inside the 5s budget?

Unresolved, and it must be answered with the timing log, not by eyeballing log
volume. Ask for one sale's worth of:

```
[sale_completion_timing] cart_settle_ms=… persisted_lines=… settled=… unsaved_lines=…
[sale_completion_timing] rra_sign_ms=…
[sale_completion_timing] flow_total_sync_completion_ms=…
[sale_completion_timing] over_budget_ms=… target_ms=5000     ← only present when over
```

`persisted_lines` should match the cart's line count. `over_budget_ms` absent
means you are inside budget (`kSaleCompletionTargetMs`, 5000ms, in
`flipper_dashboard/lib/utils/sale_completion_budget.dart`).

### Open item 3 — unexplained: 17 × "Total changed from 880.0 to 0.0"

There is exactly one `PaymentMethodsCard` (constructed at
`QuickSellingView.dart:3335`), so after the first `didUpdateWidget` its
`oldWidget.totalPayable` should be 0 and the line should not repeat. Seventeen
repeats with the same `880 → 0` means either the parent is alternating
880/0/880/0 (the `0 → 880` direction would also log, so the pasted excerpt may
have been filtered), or that card is being built in more than one place.

Not chased. Worth chasing only if the timing log shows completion over budget.

## Architecture decisions that must not be undone

These were each arrived at by breaking something first. Two are recorded in
memory (`project_pos_pay_write_ledger`, `project_pos_cart_identity`).

**Pay waits on the write ledger, never on the item stream.**
`_settlePersistedCartForCompletion` (`previewCart.dart`) awaits
`OptimisticCart.whenQueuedAddsSettle()` plus a turn behind the FIFO persist lock,
then reads Ditto once. `transactionItemsStreamProvider` is a *report* of what
Ditto replayed back to us — it is what makes a tapped item appear instantly, and
it is not evidence that a sale is safe to complete. The original code polled it
every 100ms for 8s and refused Pay on carts that were fully saved.

**Wait on progress, not on a deadline.** The bound is "the queued-add backlog
stopped shrinking for 8s" (`awaitQueuedCartWritesWhileProgressing`), with a 60s
ceiling. Three separate flat deadlines were tried and each one refused Pay on
large carts that were draining normally. If you find yourself picking a number
for how long a healthy cart takes, that is the mistake repeating.

**A settled ledger beats a stale ghost.** If every queued write has run, Ditto is
the cart, whatever `pendingQtyByVariantId` still claims — ghosts are dropped and
the sale proceeds. A ghost only retires when the persisted qty for *its* variant
id increases, so a composite (tap creates a ghost for the tapped variant; the
persist writes rows for the component variants) leaves one forever. Blocking on
that refused Pay on fully saved carts.

**Presentation never decides whether a sale finishes.** RRA has already signed by
the time a receipt is printed, so a printer fault must not throw (rollback to
PENDING with a fiscal receipt live at RRA) or hang (a frozen till). `printing()`
bounds `listPrinters` at 10s and `directPrintPdf` at 30s per copy, and the call
is wrapped so it cannot fail a signed sale.

**Never sell what Ditto does not back.** Completion reads the persisted rows, not
the display. See `project_pos_cart_display_truth` in memory.

## What was actually wrong (root causes found)

| Cause | Fix |
|---|---|
| Leaked dashboard observers: `dashboardGaugeSnapshotProvider` / `dashboardPreviousGaugeSnapshotProvider` were non-autoDispose and open a **branch-wide** `transaction_items` observer (no `transactionId`). Visiting the dashboard once left them live, waking on every cart write to re-materialise every item in the branch. Writes dropped to ~1 row per 3-6s. | `33bc5a2f2` |
| `saveTransactionItem` selected every line in the cart to compute the next `itemSeq` — O(n²) to build a cart | `cde1e6273`, then `937b7b84b` (O(1) via `CartLineSeqCache`) |
| `applyDiscount` triggered `_recalculateTransactionSubTotal` per line (full SELECT + txn write, per line), and its intermediate values were wrong anyway | `0db7a0f51` |
| Five sequential per-line round trips on the Pay path | `0db7a0f51` (`forEachBounded`, window 8) |
| Idempotent reconciles still notified (no value equality on `OptimisticCartState`) → full checkout rebuild ~10×/s during the old poll | `0db7a0f51` |
| A freshly minted PENDING cart could steal a cart full of lines (observer emits `items.first ORDER BY lastTouched DESC`; an empty query result was treated as proof the cart was gone) | `c400f828d` |
| Pay spinner leaked: release was gated on host `mounted`/`context.mounted`; digital-payment timeout had no `onPaymentFailed` | `cfbf8beed` |
| RRA `saveSales` could hold the till up to 3 × 120s | `dc9f21f9f` |

## Known gaps, deliberately not fixed

1. **Cart identity is still derived from a stream.** `c400f828d` only makes the
   two observed failures impossible. The real fix is pinning the cart for the
   life of the sale — `pinnedPosCartTransactionIdProvider` already exists and is
   honoured, but only mobile checkout and ticket resume set it. Not done because
   a pin that outlives its sale previously produced an unpayable checkout; it
   needs a disciplined release plus a self-heal when the pinned row leaves
   PENDING.
2. **A second pending cart was still minted** at 20:41:13 in the 2026-09-03 logs,
   from a path the observer settle in `c400f828d` does not cover.
3. **Composite ghosts** are still created and now vanish at Pay rather than
   blocking it — so a composite line inflates the on-screen total until then.
   Clearing at add time touches the path built to stop the cart flashing empty.
4. **`waitReportPluLinesFromStream`** (`transactions_provider.dart:46`) uses
   `.first.timeout(15s)`; the timeout abandons the future without cancelling the
   subscription — same leak class as gap in `33bc5a2f2`, on a failure path.
5. **QuickSellingView rebuild cost.** `ref.watch(posCartDisplayItemsProvider)` in
   the top-level `build` (line ~1510) rebuilds the entire view on every cart
   emission, and the cart body is a `Column`, not a lazy builder (line ~2020), so
   all N rows are laid out every time. `_onQuickSellComplete` performs ~18
   provider mutations in a row, which is the ~4ms-apart rebuild burst seen in the
   logs. This is a real refactor, not a patch.
6. **Purchase-code path prints before completing.** `finalizePayment`'s
   non-deferred branch prints, *then* completes; the deferred quick-sell branch
   completes first. Reordering it would make the cart clear instantly regardless
   of the printer, but it also moves `_completeTransactionAfterTaxValidation`.
7. **Receipt printer has no UI.** The first time a till sees exactly one printer
   it is silently adopted as the permanent default, and nothing outside the
   ticket reprint can change it. Product decision pending — see `5080778b7`.

## Diagnostics added this session

Grep these first; they were built for exactly this problem.

- `[sale_completion_timing]` — per-stage timings + `over_budget_ms`.
- `[receipt_presentation]` — names which of the six presentation branches ran and
  why nothing printed.
- `Cart settle: dropping N stale ghost line(s) … variants=[…] names=[…]` — which
  products leave unretireable ghosts (composites are the prime suspect).
- `Cart settle: N queued write(s) stopped making progress after Xms` — the
  backlog stalled; N writes never finished.
- `posCartStreamReconciliation: refusing to swap the active cart …` — a mint tried
  to steal the cart.
- `pendingTransaction: empty result was transient … re-emitting` — the settle
  prevented a mint.

Log levels were corrected twice: routine events (`ghost settled`, `0 rows this
frame`, `is still loading`, `Total changed`) are now `debug`. What remains at
`warning` is meant to be read — especially `OptimisticCart: active transaction
switched … discarding them`, the fingerprint of a stolen cart.

## Tests worth knowing about

- `flipper_dashboard/test/cart_write_backlog_test.dart` — a 12-write backlog
  draining over ~18s **must** complete, asserting it waited past 15s so the
  flat-deadline regression cannot return quietly.
- `flipper_dashboard/test/preview_sale_button_spinner_test.dart` — spinner
  released on completion/throw, held only for a pending out-of-band payment.
- `flipper_dashboard/test/frame_sync_test.dart` — completion is not gated on a
  frame ever being produced.
- `flipper_models/test/cart_line_seq_cache_test.dart` — O(1) seq, LRU eviction,
  never lowers a high-water mark.
- `flipper_models/test/pos_cart_pending_swap_test.dart` — a cart with lines is
  never swapped for an empty one; the completion hand-off always hands over.
- `flipper_models/test/optimistic_cart_reconcile_test.dart` — idempotent
  reconciliation; the settle ledger, including a cancelled add still settling.

Known-flaky under parallel load: `pos_cart_tap_sync_perf_test.dart` (timing
budget) and occasionally a suite failing at "loading". Both pass in isolation.
Pre-existing and unrelated: `payable_view_layout_test.dart` and
`pos_cart_display_suppression_test.dart` fail in `setUpAll` on the sqflite
factory.

## Working agreement that mattered

The user has unrelated work in flight in the same tree (RRA `bcd` length fixes,
transaction report/export changes). **Commit by pathspec** (`git commit -- <paths>`)
so their staged index survives. A pre-commit hook bumps
`apps/flipper/pubspec.yaml` on every commit; that is expected.
