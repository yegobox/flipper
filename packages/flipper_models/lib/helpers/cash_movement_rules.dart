/// Pure rules for recording a cash book movement (Cash In / Cash Out) through
/// `collectPayment`. Kept dependency-free so they can be unit tested.
library;

/// `cashReceived` to persist on the transaction after a payment.
///
/// A sale can be paid in several collections, so it accumulates. A cash book
/// movement is a single amount: accumulating would add whatever a reused,
/// interrupted pending movement still held.
double cashMovementCashReceived({
  required double? previous,
  required double received,
  required bool isUtilityCashbookMovement,
}) {
  if (isUtilityCashbookMovement) return received;
  return (previous ?? 0.0) + received;
}

/// Payment type to persist on the transaction.
///
/// POS checkout keeps its selected method in the box, which wins for sales.
/// The cash book picks its own method on the form, so the box (last set by an
/// unrelated checkout) must not override it.
String resolveCollectPaymentType({
  required String requested,
  required String? boxPaymentType,
  required bool isUtilityCashbookMovement,
}) {
  if (isUtilityCashbookMovement) return requested;
  return boxPaymentType ?? requested;
}

/// Fields that classify a finished cash book movement, to write onto its
/// transaction row.
///
/// `collectPayment` sets these on the in-memory transaction only; nothing else
/// writes them to the store. Reports and the Cash Book read the category from
/// `transactionType`, so it holds the chosen category's name, or the
/// movement's own name ([movementName], "Cash In"/"Cash Out") when none was
/// picked. Older callers passed "" or "Sale" for "no category", and a cash
/// movement stored as a sale would be counted as one wherever
/// `transactionType` is read.
Map<String, Object?> cashMovementClassification({
  required String? categoryName,
  required String movementName,
  required String? categoryId,
  required String? paymentType,
  required String receiptType,
}) {
  final name = categoryName?.trim() ?? '';
  final id = categoryId?.trim() ?? '';
  return {
    'transactionType': name.isEmpty || name == 'Sale' ? movementName : name,
    'categoryId': id.isEmpty ? null : id,
    'paymentType': paymentType,
    'receiptType': receiptType,
  };
}

/// Cash Book categories Hotel Mode stamps on the movements around a guest's
/// booking advance. Fixed strings, never a user category: the data-connector
/// routes them to 2400 Customer Deposits (`semantics::is_booking_advance`), so
/// keep the two in step.
const String kBookingAdvance = 'Booking advance';

/// The advance used against the folio at checkout. No money moves.
const String kBookingAdvanceApplied = 'Booking advance applied';

/// The advance handed back to the guest (cancelled or overpaid booking).
const String kBookingAdvanceRefunded = 'Booking advance refunded';

/// Whether a Cash In / Cash Out row is a booking-advance movement.
///
/// These move money between the drawer and what the business owes its guests,
/// so they belong in the Cash Book and the drawer count but never in revenue,
/// expenses or profit: the stay is invoiced once, in full, at checkout.
bool isBookingAdvanceMovement({
  required String? transactionType,
  required String? receiptType,
}) {
  final kind = transactionType?.trim().toLowerCase();
  switch (receiptType?.trim()) {
    case 'Cash In':
      return kind == kBookingAdvance.toLowerCase();
    case 'Cash Out':
      return kind == kBookingAdvanceApplied.toLowerCase() ||
          kind == kBookingAdvanceRefunded.toLowerCase();
    default:
      return false;
  }
}
