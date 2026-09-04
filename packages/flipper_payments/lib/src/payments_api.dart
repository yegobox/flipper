import 'package:flipper_payments/src/logging.dart';

/// Base URL for the data-connector payment endpoints.
///
/// MoMo lives in **data-connector** (`data-connector/MOMO_BILLING.md`):
/// subscriptions, pre-approval mandates, POS and gig payments, and credit
/// purchases. The card rail (Dodo Payments) shares this base URL — `/api/dodo/*`
/// is served by the same connector, so a wrong host breaks both rails at once.
///
/// Resolution order:
///
/// 1. [setPaymentsApiBaseUrlOverride] (tests, or a build aimed at staging)
/// 2. [setPaymentsBaseUrlResolver] — the host app's per-branch lookup, if it
///    registered one (`flipper_services` resolves `Ebm.dataConnectorUrl`)
/// 3. [kPaymentsApiBaseUrl] — the same host in debug and release
///
/// **Debug does not fall back to localhost.** It used to default to
/// `http://127.0.0.1:8084`, which silently swallowed every payment call on any
/// machine without a connector running locally: the request simply never
/// resolved, so the UI sat on a spinner with nothing in the log. Pointing debug
/// at the real connector means a dev build behaves like a release one by
/// default. To work against a local connector, opt in explicitly:
///
/// ```dart
/// setPaymentsApiBaseUrlOverride(kPaymentsApiLocalBaseUrl);
/// ```
///
/// Never returns a trailing slash, so callers write `'$base/v2/api/payNow'`.
const String kPaymentsApiBaseUrl = 'https://prod.api.yegobox.com';

/// A local connector, for [setPaymentsApiBaseUrlOverride]. Not a default —
/// see [kPaymentsApiBaseUrl].
const String kPaymentsApiLocalBaseUrl = 'http://127.0.0.1:8084';

/// A host-supplied lookup for the connector serving the active branch.
///
/// This is the seam that used to be a direct `ProxyService.getStrategy(...).ebm(...)`
/// call. Returning null (or throwing) falls through to [kPaymentsApiBaseUrl],
/// so an app that never registers a resolver — `flipper_hr`, `flipper_web` —
/// simply uses the shared host. That is also what finally makes the three apps
/// agree: `flipper_hr` used to point at a different one.
typedef PaymentsBaseUrlResolver = Future<String?> Function();

String? _overrideBaseUrl;
String? _cachedBaseUrl;
PaymentsBaseUrlResolver? _resolver;

/// Force a base URL (tests, or pointing a build at a staging connector).
/// Pass `null` to clear.
void setPaymentsApiBaseUrlOverride(String? baseUrl) {
  _overrideBaseUrl = normalizePaymentsBaseUrl(baseUrl);
  _cachedBaseUrl = null;
}

/// Register the host's per-branch lookup. Pass `null` to remove it.
void setPaymentsBaseUrlResolver(PaymentsBaseUrlResolver? resolver) {
  _resolver = resolver;
  _cachedBaseUrl = null;
}

/// Drop the cached lookup (call after the active branch changes).
void resetPaymentsApiBaseUrlCache() => _cachedBaseUrl = null;

Future<String> paymentsApiBaseUrl() async {
  final override = _overrideBaseUrl;
  if (override != null) return override;

  final cached = _cachedBaseUrl;
  if (cached != null) return cached;

  final resolved = await _resolve();
  _cachedBaseUrl = resolved;
  return resolved;
}

Future<String> _resolve() async {
  final resolver = _resolver;
  if (resolver != null) {
    try {
      final configured = normalizePaymentsBaseUrl(await resolver());
      if (configured != null) {
        payLogInfo('Payments API: $configured (from the host resolver)');
        return configured;
      }
    } catch (e) {
      payLogWarning('Payments API: host resolver failed ($e); using the default');
    }
  }
  return kPaymentsApiBaseUrl;
}

/// Trims whitespace and any trailing slash; empty becomes null.
String? normalizePaymentsBaseUrl(String? raw) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed.endsWith('/')
      ? trimmed.substring(0, trimmed.length - 1)
      : trimmed;
}
