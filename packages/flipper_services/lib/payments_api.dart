import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';

/// Base URL for MTN MoMo payment endpoints.
///
/// MoMo moved from flipper-turbo to **data-connector**
/// (`data-connector/MOMO_BILLING.md`): subscriptions, pre-approval mandates, POS
/// and gig payments, and credit purchases. The `/v2/api/*` routes there are
/// wire-compatible with the flipper-turbo ones, so only the host changes.
///
/// Resolution order, matching `FloChatService`:
///
/// 1. `Ebm.dataConnectorUrl` for the active branch (per-branch override)
/// 2. `https://data-connector.yegobox.com` in release builds
/// 3. `http://127.0.0.1:8084` in debug builds
///
/// Never returns a trailing slash, so callers write `'$base/v2/api/payNow'`.
const String kPaymentsApiProdBaseUrl = 'https://data-connector.yegobox.com';
const String kPaymentsApiDebugBaseUrl = 'http://127.0.0.1:8084';

String? _overrideBaseUrl;
String? _cachedBaseUrl;

/// Force a base URL (tests, or pointing a build at a staging connector).
/// Pass `null` to clear.
void setPaymentsApiBaseUrlOverride(String? baseUrl) {
  _overrideBaseUrl = _normalize(baseUrl);
  _cachedBaseUrl = null;
}

/// Drop the cached branch lookup (call after the active branch changes).
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
  final branchId = ProxyService.box.getBranchId();
  if (branchId != null) {
    try {
      // Reads from the local replica: payments must not wait on a network call
      // just to learn where to POST.
      final ebm = await ProxyService.getStrategy(Strategy.capella)
          .ebm(branchId: branchId, fetchRemote: false);
      final configured = _normalize(ebm?.dataConnectorUrl);
      if (configured != null) {
        talker.info('Payments API: $configured (from EBM dataConnectorUrl)');
        return configured;
      }
    } catch (e) {
      talker.warning('Payments API: EBM lookup failed ($e); using the default');
    }
  }
  return kDebugMode ? kPaymentsApiDebugBaseUrl : kPaymentsApiProdBaseUrl;
}

String? _normalize(String? raw) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed.endsWith('/')
      ? trimmed.substring(0, trimmed.length - 1)
      : trimmed;
}
