# Hotel Mode: advances, credit, extending a stay, printing

Customer feedback (2026-11-08): a guest pays an advance (*avance*) when booking, but at the
stay there was no way to deduct it. The desk had to record it as paid on the stay day, which
put the wrong figures on both days. Guests also wanted to print room invoices, to get one
invoice for a multi-night stay, and to leave on credit (*ideni*).

## Advances

- Advances are recorded on `HotelStay.advances` as `HotelAdvance`: amount, method, `paidAt`, and
  a status of `held`, `applied` or `refunded`.
- They are written **only** by `saveHotelAdvance`, which runs `UPDATE hotel_stays SET advances`
  after a fresh read. `HotelStay.toJson` never carries them, so a stale copy of the stay saved
  through the upsert (checkout, an edit, an older build) cannot wipe them.
- Every advance is a pair of Cash Book movements around the folio sale. Each movement has a
  fixed `transactionType` (`cash_movement_rules.dart`). The data-connector routes them by
  `semantics::is_booking_advance`, so **keep the strings in step**.

| Event | Movement | Cash Book | Ledger |
|---|---|---|---|
| Advance taken (booking, arrival dialog or folio) | Cash In `Booking advance`, in the method it was paid with | +A that day | Dr money / Cr **2400 Customer Deposits** |
| Checkout | Folio sale for the full total, with a payment row for the **balance only** | +Total | Dr tender (single-debit fallback) / Cr revenue + tax |
| Checkout | Cash Out `Booking advance applied` under the sale's tender, `updateShift: false` | −A | Dr 2400 / Cr tender |
| Advance above the folio | Cash Out `Booking advance refunded` for the surplus | −surplus | Dr 2400 / Cr money |
| Cancel | `Booking advance refunded` for each held advance (refund-only policy) | −A | Dr 2400 / Cr money |

- Checkout day therefore shows exactly the balance received. Revenue is the whole stay, counted
  once, on checkout day. The RRA receipt is unchanged: full total, primary tender.
- These movements are excluded from the dashboard gauge, the Transaction Report KPIs and the
  Excel Cash In and Expense sheets (`isBookingAdvanceMovement`). They stay in the Cash Book.
- If applying the advance fails after the sale went through, the stay is checked out with
  advances still held. **Billing → Apply advance** heals it: `settleHeldAdvances` only touches
  held advances, so it can safely run again.

## Credit (ideni)

- The checkout dialog's **Credit** rail calls `checkOutOnCredit`. It is Bar's loan: the folio is
  receipted now, then goes PARKED + `isLoan`, using `parkBarTabAsLoan` with a `Hotel · Room …` note.
  `releaseHotelStay` then closes the stay.
- A held advance becomes the first payment row (in its own method), with
  `alreadyPaid` → `remainingBalance = Total − A`. Its "applied" movement is booked per method.
  In the ledger that nets to Dr 2400 / Cr AR.
- Collection happens in **Billing**, which lists every branch loan and reuses Bar's collect sheet.
  Bar's toasts are forwarded to the desk.
- Caveat (existing loan behaviour): the Cash Book counts a credit sale only on its final
  installment.

## Extending a stay, and one invoice

- Tapping the folio's departure date calls `changeHotelStayDeparture`. It re-checks availability
  (half-open nights) and resizes and renames the `Room <n> · N nights` line.
- "+ Room charge" now bills only nights not yet billed, on every branch. It used to add the nights
  again, or a second plain line on non-EBM branches.
- **Print** on the folio produces an A4 **pro-forma** while the stay is open, and an **invoice**
  once settled or on credit, quoting the RRA receipt number (`hotel_folio_pdf.dart`, with the
  quotation letterhead and stamp). **Billing → Checked out (30 days)** reprints after the guest
  has left.
