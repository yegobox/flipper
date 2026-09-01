import 'package:flipper_payments/src/dodo/dodo_client.dart';
import 'package:flipper_payments/src/dodo/dodo_models.dart';
import 'package:flipper_payments/src/http/payments_http_client.dart';

/// Whether the card rail is sellable, cached for the session.
///
/// Every payment screen needs this answer before it can decide whether to offer
/// a Card option, and the answer only changes when the connector is
/// reconfigured — so probing once and remembering keeps a screen from making a
/// network call on every rebuild.
///
/// The cache is short enough (15 minutes) that turning `DODO_ENABLED` on does
/// not require a restart to be noticed, and [resetDodoHealthCache] exists for
/// the case where it should be noticed immediately.

const Duration _cacheTtl = Duration(minutes: 15);

DodoHealth? _cached;
DateTime? _cachedAt;
Future<DodoHealth>? _inFlight;

/// Test seam: pretend the connector said this, without a network call.
void setDodoHealthOverride(DodoHealth? health) {
  _cached = health;
  _cachedAt = health == null ? null : DateTime.now();
  _inFlight = null;
}

void resetDodoHealthCache() {
  _cached = null;
  _cachedAt = null;
  _inFlight = null;
}

/// Reads the connector's Dodo health, at most once per [_cacheTtl].
///
/// Never throws — an unreachable connector reports
/// [DodoHealth.unavailable], which simply hides the card option and leaves the
/// Mobile Money flow untouched.
Future<DodoHealth> dodoRailHealth({bool refresh = false}) {
  if (!refresh) {
    final cached = _cached;
    final at = _cachedAt;
    if (cached != null &&
        at != null &&
        DateTime.now().difference(at) < _cacheTtl) {
      return Future.value(cached);
    }
    // Two screens opening at once should share one probe.
    final pending = _inFlight;
    if (pending != null) return pending;
  }

  final future = DodoClient(defaultPaymentsHttpClient).health().then((health) {
    _cached = health;
    _cachedAt = DateTime.now();
    _inFlight = null;
    return health;
  });
  _inFlight = future;
  return future;
}

/// The single question a payment screen asks: offer a Card option or not?
/// Whether *this build* can sell a card subscription — see
/// [DodoHealth.readyForThisBuild].
Future<bool> isCardPaymentAvailable() async =>
    (await dodoRailHealth()).readyForThisBuild;
