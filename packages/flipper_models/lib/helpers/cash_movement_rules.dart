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
