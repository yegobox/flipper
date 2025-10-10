typedef PreviewCart = void Function()?;
typedef CompleteTransaction = Future<bool> Function(bool immediateCompletion, [Function? onPaymentConfirmed, Function(String)? onPaymentFailed]);
typedef Function onClick();
