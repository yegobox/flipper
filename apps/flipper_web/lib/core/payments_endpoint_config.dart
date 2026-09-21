import 'package:flipper_payments/flipper_payments.dart';
import 'package:flutter/foundation.dart';

/// Which data-connector the payment rails talk to.
///
/// `flipper_payments` deliberately does **not** fall back to localhost in
/// debug (see `kPaymentsApiBaseUrl`): a dev build hits the shared connector
/// like a release one. That is right for everyday work and wrong for testing
/// the negotiated-price page, which must never reach a live MTN or Dodo
/// account. This is the explicit opt-in.
///
/// ```bash
/// # Default — the shared connector
/// flutter run -d chrome
///
/// # A dry-run connector on this machine
/// flutter run -d chrome --dart-define=PAYMENTS_BASE_URL=http://127.0.0.1:8085
/// ```
abstract final class PaymentsEndpointConfig {
  static const _raw = String.fromEnvironment('PAYMENTS_BASE_URL');

  /// Applies the override, if one was given. Call before `runApp`.
  static void apply() {
    final configured = _raw.trim();
    if (configured.isEmpty) {
      debugPrint('[Payments] PAYMENTS_BASE_URL unset — using the shared connector');
      return;
    }
    setPaymentsApiBaseUrlOverride(configured);
    debugPrint('[Payments] PAYMENTS_BASE_URL=$configured (override active)');
  }
}
