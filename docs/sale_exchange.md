# Item exchange on a completed sale

Admin setting **Item exchange** (`Setting.enableSaleExchange`, default off).
When it is on, a completed sale shows **Exchange item**. The customer brings
items back and takes others, and the price difference is either paid by the
customer or given back.

## Model

The original sale is **never edited**. Its journal entry and its RRA invoice
can't change. An exchange writes two new transactions that share one
`exchangeId`:

| | receiptType | lines | subTotal | links |
|---|---|---|---|---|
| Return | `NR` | only the returned units | value of those units (positive) | `originalTransactionId` = the sale |
| New sale | `NS` | the items taken | their value | `exchangeId` only |

- **Exchange return** means `exchangeId` is set and the receipt type is NR, CR
  or TR. In Flutter this is `isExchangeReturn` (`flipper_models/lib/helpers/sale_exchange.dart`);
  in data-connector it is `semantics::is_exchange_return`.
- Every reader that totals sales counts an exchange return **negative**. This
  covers:
  - the report KPIs and PLU;
  - the report grid and the Excel and PDF exports;
  - the end-of-shift summary;
  - the dashboard gauge;
  - the Cash Book, where the return is listed as *cash out*;
  - in the connector: Flo, the daily XLSX and the Spice export.
- A plain NR refund has no `exchangeId`, so every reader treats it exactly as
  before.
- Return lines copy the sale line's money and cost **pro-rata**
  (`buildReturnLine`). They never use today's price or cost, so the return
  reverses exactly what the sale booked.
- Return lines carry `isRefunded: true`. Inventory movement counts them as
  refunded units, and the end-of-shift item count skips them.
- Both transactions use the **settlement method**, the payment method chosen
  for the difference. Only that account moves, and it moves by exactly the
  difference.

## Flow (`SaleExchangeService.execute`)

1. **Draft the new sale.** Its status is `exchangeDraft`, never `pending`,
   because the POS adopts the newest pending row as its cart. Lines are added
   with `saveTransactionItem(updatePendingTransactionSubtotal: false)`, whose
   `amountTotal` is the **unit** price (the line total is unit × qty).
2. **EBM branches: RRA signs the return.** This is a line-level NR carrying the
   sale's `orgInvcNo`. If RRA refuses it, the draft is deleted and nothing is
   kept. The moment RRA answers `000`, `rw_tax` stamps the return
   (`markExchangeReturnSigned`). If a local step after that throws (receipt
   record, counters, PDF), the exchange still goes on: the return is fiscal
   and must be recorded. Only its receipt PDF is missing.
   - In `TaxController`, NR with `exchangeId` only stamps the signed numbers on
     the return. It doesn't copy the original's lines.
   - Exchanges sign on this device and never go through delegation.
3. **Write the return.** Its lines are written first. Then stock goes back
   and the shift is credited with `isRefund`. The transaction row is written
   last, so a return row always means a complete return.
4. **Complete the new sale.** `collectPayment` runs (it also adds the sale to
   the shift) and the draft is saved with `lastPaymentDate` set. Then come
   the lines, one payment record (`singlePaymentOnly`), and the stock
   deduction. The `COMPLETE` status is written last, so a sale still in
   `exchangeDraft` is an unfinished one.
5. **EBM branches: sign the new sale** as NS. If RRA is unreachable here, the
   sale detail offers **Finish exchange**.

A failure in step 3 or 4 is reported as "partly saved", never as "nothing
changed". The flow then offers only **Finish exchange**
(`SaleExchangeService.resumeExchange`), because confirming again would make a
second exchange. Every step checks what is already done, so a retry repeats
nothing. In the same session the retry works from memory. Later, the original
sale and the return show **Finish exchange** (`unfinishedExchangeId`), and the
retry rebuilds the exchange from the return row and the draft sale.

A failure before anything is written (reading the sale, the shift or the EBM
setting) reports "nothing changed".

## Books

The connector posts an exchange return as a **reversal** under
`je_<biz>_<txn>_sale`:

- Dr 4010 / Dr 2100 / Cr liquid account
- Dr 1200 / Cr 5010

Returns are kept away from `heal_existing`. Its COGS check expects a 5010
debit, and it would "fix" the reversal back into a sale. There is no new
account: returns debit 4010 directly.

Original sale plus return plus new sale nets to the same figures as selling
the final items directly. See the worked-example test in
`data-connector/src/accounting/entry.rs`.

## Blocked

- A refund of a sale that has exchanges. The exchanged items were already
  credited. If the exchange lookup fails, the refund is blocked too.
- Exchanging anything other than a normal completed and fully paid sale. That
  rules out loans, training and proforma sales, cash movements, and the
  exchange's own return.

## Known gaps (follow-ups)

- **Plain refunds still count as positive sales** in KPIs, the ledger and Flo.
  The NR copy's `subTotal` is also doubled when its lines are re-added.
- The `TransactionItem` constructor drops `ignoreForReport`. Flutter readers
  therefore see `false` on every line they read back.
- The Spice `transaction_items` export still lists returned lines as positive.
- If a return fails part-way through step 3 and the app is then restarted,
  that return cannot be finished. Its row is missing, so nothing points back
  to the planned lines. Finishing it needs a persisted exchange intent.
