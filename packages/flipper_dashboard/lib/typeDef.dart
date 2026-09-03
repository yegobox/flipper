typedef PreviewCart = void Function()?;

/// Runs a sale completion.
///
/// Returns `true` **only** while an out-of-band payment is still pending (the
/// digital/MoMo path returns before the customer has confirmed on their phone).
/// Every other outcome — completed, aborted on a guard, failed — returns
/// `false`, which is what tells [PreviewSaleButton] it may release the Pay
/// spinner. Do not return `true` to mean "handled".
typedef CompleteTransaction = Future<bool> Function(bool immediateCompletion, [Function? onPaymentConfirmed, Function(String)? onPaymentFailed]);
typedef Function onClick();
