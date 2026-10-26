# Bar Mode credit (tabs the guest pays later)

A guest who leaves without paying no longer pins their table. Bar Mode can
put a tab on credit and collect it later without the cashier leaving Bar
Mode.

## Putting a tab on credit

There are two ways in, and both ask for a customer and then a due date:

- **Put on credit**: a button on the tab footer (desktop) or the tab sheet
  (phone). It is shown only to cashiers who can settle. If **Settle needs a
  manager PIN** is on, a non-manager uses Settle → Credit after the PIN.
- **Credit**: a tender tile on the Settle screen, next to Cash, MoMo, Card and
  Room charge. It needs no receipt phone because the customer's phone is
  used, and it cannot be part of a split payment.

The full bill goes on credit. A part payment is taken later, as an
installment.

## Model

A tab on credit is the same loan the POS parks with **Mark as loan**:

- `status` stays **PARKED**
- `isLoan: true`, with `dueDate`, `customerId`, `customerName` and
  `customerPhone`
- `paymentType: CREDIT`
- `originalLoanAmount` and `remainingBalance` are set to the total, and
  `cashReceived` is 0
- `ticketName` is the customer's name
- `note` is `Bar · <table> · Opened by …`, which is how the Credit list labels
  a loan as coming from the Bar
- **`tableId` is cleared**, so the table frees up at once

So POS Tickets → Loans lists it too, and either till can collect it.

As with a POS credit sale, **the RRA receipt is filed and stock leaves when the
tab goes on credit**. This goes through `finalizeServiceModeSale` with a single
`CREDIT` payment row. `taxAmount` is set before the write, because
data-connector books the receivable as soon as it sees a parked loan and splits
VAT out of revenue by `taxAmount`.

Code: `parkBarTabAsLoan` in `flipper_models/lib/sync/capella/mixins/bar_mixin.dart`
and `BarCredit` in `flipper_dashboard/lib/features/bar_mode/bar_credit.dart`.

## Collecting

The tables screen shows a **Credit · N** button whenever any loan is open. It
gets a red dot once a loan is overdue, and it is gated by the same manager-PIN
rule as Settle.

The Credit screen lists **every open loan in the branch, from the Bar and the
POS alike**, overdue first. Tapping a loan opens the collect sheet. The amount
starts at the full balance; the cashier can lower it for a part payment but
never raise it above the balance. Tenders are Cash, MoMo and Card.

`collectBarCreditPayment` uses the POS installment maths
(`deriveSaleCompletionState`). Each installment:

- adds to `cashReceived`
- lowers `remainingBalance`
- appends a payment row (`replacePriorRows: false`)
- files no receipt and moves no stock

The last installment completes the sale: it becomes `COMPLETE` with
`isLoan: false`, and its `paymentType` becomes that installment's tender. The
sale and its lines are re-dated to that day, as a POS loan is, so the sale
appears in that day's reports.
