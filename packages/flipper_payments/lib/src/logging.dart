import 'package:flutter/foundation.dart';

/// Severity of a payments log line, so a host logger can route it.
enum PaymentsLogLevel { info, warning, error }

/// Where this package's log lines go.
///
/// The rails used to call `talker` from `flipper_models` directly, which is one
/// of the two things that tied them to the POS app. A payment that failed still
/// has to be traceable from a support ticket, so the lines themselves are kept —
/// only their destination is now the host's choice.
///
/// `flipper_services` points this at `talker`; apps that do not set it get
/// `debugPrint` in debug and silence in release.
typedef PaymentsLogSink = void Function(PaymentsLogLevel level, String message);

PaymentsLogSink _sink = _defaultSink;

/// Route this package's logs into the host's logger. Pass null to restore the
/// default.
void setPaymentsLogSink(PaymentsLogSink? sink) => _sink = sink ?? _defaultSink;

void _defaultSink(PaymentsLogLevel level, String message) {
  if (kDebugMode) debugPrint('[payments/${level.name}] $message');
}

void payLogInfo(String message) => _sink(PaymentsLogLevel.info, message);
void payLogWarning(String message) => _sink(PaymentsLogLevel.warning, message);
void payLogError(String message) => _sink(PaymentsLogLevel.error, message);
