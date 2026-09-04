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

### Open item 2 — answered: completion was over budget, and why

Measured, not judged: 16.4s, then 29.3s, then a cart that never drained.
Chasing it down gave the root cause of the whole session's symptoms.

**Nothing but `_id` was indexed.** Ditto indexes `_id` and no other field
unless you create the index yourself, so every `WHERE …` walked the collection
at roughly **0.2ms a document**. (I first reported that Ditto has no indexes at
all — wrong, and the user caught it. Indexes exist from SDK 4.12.0; they are
created by *executing DQL*, `CREATE INDEX IF NOT EXISTS … ON … (field)`, not
through an SDK method, which is why grepping for an API found nothing.) The
device held 5,789 `transaction_items` and 9,984 `transactions`, so one pass
cost ~1.2s — and a single cart write made three of them:

```
[cart_write_store] lookup_ms=1565 seq_ms=1029 upsert_ms=15 subtotal_ms=2554 total_ms=5163
```

The INSERT was 15ms. Everything else was reading. That is why writes got
slower as history accumulated, why a 60-line cart left 23 writes outstanding
at the 60s ceiling, and why `update_transaction` cost 3.3s at completion.

Three fixes landed:

- `INDEXES` — `local_store_indexes.dart` creates single-field indexes on the
  fields the app filters on constantly (`transaction_items.transactionId` /
  `.variantId`, `transactions.branchId` / `.status` / `.createdAt`, plus
  `variants` and `stocks`), at Ditto setup, before sync starts. Local to the
  device, not replicated. Composite indexes would suit
  `(status, createdAt)` but need SDK 5.1.0; the project pins 5.0.3, and from
  4.13.0 a query can combine several single-field indexes anyway.

- `063f08a16` — the parent-row subtotal bump is gathered and written once per
  burst instead of once per line. It walked the *bigger* collection and then
  woke every branch-wide `SELECT * FROM transactions` observer to walk it
  again, per line. Nothing needs it per line: the on-screen total is computed
  from the items, park/send-to-till overwrite it with the live total, and
  completion recomputes it from the finished lines.
- `231c598b0` — 30-day retention (the user's call — but asked while the index
  claim above was still wrong, so it is worth revisiting: with indexes it caps
  storage and replication rather than query time). Both
  halves are required: subscriptions narrowed in `prepareDqlSyncSubscription`
  (eviction alone is futile — an active subscription pulls the document back)
  and eviction of history past the window (windowing alone does not remove
  what the device already holds).

### Open item 3 — unexplained: 17 × "Total changed from 880.0 to 0.0"

Still unexplained, still not chased. Note the sale that produced the 29.3s
breakdown never reached `rra_sign`, so it took one of the non-signing branches
in `finalizePayment`; the `branch=` note on the over-budget line now says which.

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

**Measure before theorising — the numbers overturned three theories in a row.**
The endOfFrame stall, the rebuild cost (`posCartDisplayItemsProvider` in the
top-level build over a non-lazy `Column`), and "the store is congested" were all
plausible, and all wrong. `store_ms=10373` on a *four-line* cart killed the
rebuild theory in one line; `upsert_ms=15` alongside `lookup_ms=1565` killed the
congestion theory. Each measurement cost one sale.

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
8. **The per-tap variant lookup is still a full scan** (~1.5s). It could be
   served from an in-memory cart line map the way `CartLineSeqCache` serves the
   seq, but a negative answer from that cache is only safe if no other device
   adds to the same open cart — get it wrong and a variant gets two rows.
   Retention shrinks this scan; it does not remove it.
9. **An old parked ticket's lines can be evicted** while the ticket itself is
   kept. Resuming it subscribes by `transactionId`, which is exempt from
   windowing, so the lines come back — but only online. Ditto has no subqueries
   (`reference_ditto_dql_limits`), so eviction cannot join items to open tickets.

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
- `[cart_write] store_ms=… wait_ms=… idle_ms=… queued=… lines=…` — one cart
  write. `store_ms` is the write, `idle_ms` is dead time no store call explains.
- `[cart_write_store] lookup_ms=… seq_ms=… upsert_ms=… subtotal_ms=…` — which
  store call a slow write spent its time in.
- `[local_store_scan] transaction_items=N rows in Xms; transactions=M rows` —
  once per session, on the first cart write: how much the queries have to walk.
- `[local_store_retention] evicted …` — the retention sweep.

The over-budget warning now carries its own breakdown (`name=took@at`, plus a
`branch=` note), so a slow sale explains itself on one line instead of needing
the scrollback. Stages that finish outside the flow are dropped, not attributed.

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
