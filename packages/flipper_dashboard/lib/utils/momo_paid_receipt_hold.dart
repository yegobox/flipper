import 'dart:async';

/// A MoMo sale the customer has paid for whose receipt was not issued, because
/// the cashier cancelled the purchase-code dialog.
///
/// The money has arrived, so the ticket must not be charged again, and its
/// receipt must still be possible. The next Pay on the same ticket calls
/// [resume], which runs the held receipt step instead of sending a second
/// MoMo request.
class MomoPaidReceiptHold {
  String? _transactionId;
  Future<void> Function()? _issueReceipt;

  /// The ticket that is waiting for its receipt, if any.
  String? get transactionId => _transactionId;

  bool holds(String transactionId) => _transactionId == transactionId;

  /// Records that [transactionId] is paid and that [issueReceipt] completes
  /// it. A later hold replaces this one.
  void hold({
    required String transactionId,
    required Future<void> Function() issueReceipt,
  }) {
    _transactionId = transactionId;
    _issueReceipt = issueReceipt;
  }

  /// Starts the held receipt step for [transactionId] without waiting for it,
  /// as a payment confirmation would. Returns false when nothing is held for
  /// that ticket.
  ///
  /// The hold is released first. If the cashier cancels again, or the step
  /// fails before the sale is complete, the receipt step holds the ticket
  /// again, so the next Pay can retry.
  bool resume(
    String transactionId, {
    required void Function(Object error, StackTrace stack) onError,
  }) {
    final issueReceipt = _issueReceipt;
    if (issueReceipt == null || !holds(transactionId)) return false;
    clear();
    unawaited(Future.sync(issueReceipt).catchError(onError));
    return true;
  }

  void clear() {
    _transactionId = null;
    _issueReceipt = null;
  }
}
