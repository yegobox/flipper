/// The report date a bar tab or hotel folio carries in `createdAt`.
///
/// Stamped when the ticket opens (so an open tab lists under today as a parked
/// row) and again when it settles, so the sale lands on the day it was paid —
/// the same moment a POS sale is dated (`posSettlementCreatedAtStamp`). A
/// folio checked in on the 1st and settled on the 5th is revenue on the 5th.
///
/// Always local time: report windows are built from local wall clock with no
/// `Z` suffix and Ditto compares them as strings, so a UTC stamp shifts sales
/// out of their own day (−2h in Rwanda).
DateTime serviceModeReportDate(DateTime at) => at.isUtc ? at.toLocal() : at;

/// Moves every line of [transactionId] onto [saleDate].
///
/// The report's line grid and PLU totals window lines by their own
/// `createdAt`, so a folio's earlier nights, or bar lines charged to the room,
/// would otherwise fall outside the day the folio is reported on.
///
/// [txn] is the Ditto write transaction that also completes the sale, so a
/// settled ticket never lands with its lines still on the old dates.
Future<void> restampServiceModeSaleLines(
  dynamic txn, {
  required String transactionId,
  required DateTime saleDate,
}) async {
  final nowIso = DateTime.now().toUtc().toIso8601String();
  await txn.execute(
    'UPDATE transaction_items SET createdAt = :createdAt, '
    'updatedAt = :updatedAt, lastTouched = :lastTouched '
    'WHERE transactionId = :transactionId',
    arguments: {
      'createdAt': serviceModeReportDate(saleDate).toIso8601String(),
      'updatedAt': nowIso,
      'lastTouched': nowIso,
      'transactionId': transactionId,
    },
  );
}
