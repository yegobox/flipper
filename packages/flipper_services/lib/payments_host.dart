import 'dart:convert';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_services/data_connector_session_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

/// Lends `flipper_payments` the things only this app can supply.
///
/// The package is deliberately a leaf — it cannot see `ProxyService`, the sync
/// strategies or `talker`, which is what lets `flipper_web` and `flipper_hr`
/// depend on it. The three registrations below hand it back what it lost, so
/// POS keeps behaving exactly as it did:
///
/// * its own HTTP client, so payment calls carry the app's retry and auth setup;
/// * the per-branch connector URL from `Ebm.dataConnectorUrl`;
/// * `talker`, so a failed payment is still traceable from a support ticket.
///
/// Idempotent, and safe to call before the user has a branch: the resolver is
/// only consulted when a payment is actually made.
///
/// Apps that never call this — `flipper_hr`, `flipper_web` — get a plain
/// `package:http` client and [kPaymentsApiBaseUrl], which is the correct answer
/// for them and finally puts all three apps on one host.
void registerFlipperPaymentsHost() {
  setDefaultPaymentsHttpClient(_ConnectorAuthedPaymentsClient());
  setPaymentsBaseUrlResolver(_branchConnectorUrl);
  setPaymentsLogSink(_talkerSink);
}

/// The connector configured for the active branch, or null to use the default.
///
/// Reads from the local replica: payments must not wait on a network call just
/// to learn where to POST.
Future<String?> _branchConnectorUrl() async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) return null;
  final ebm = await ProxyService.getStrategy(Strategy.capella)
      .ebm(branchId: branchId, fetchRemote: false);
  return ebm?.dataConnectorUrl;
}

void _talkerSink(PaymentsLogLevel level, String message) {
  switch (level) {
    case PaymentsLogLevel.info:
      talker.info(message);
    case PaymentsLogLevel.warning:
      talker.warning(message);
    case PaymentsLogLevel.error:
      talker.error(message);
  }
}


/// `ProxyService.http`, with the data-connector bearer swapped in.
///
/// Every payment rail posts to the connector (`/v2/api/*`, `/api/billing/*`,
/// `/api/dodo/*`), and `ProxyService.http` unconditionally sets
/// `Authorization: Basic …` for the apihub. The connector reads only
/// `Bearer`, so leaving the Basic header in place would read as "no
/// credentials" and 401 once enforcement is on.
///
/// A caller that sets its own `Authorization` keeps it —
/// `CustomPaymentClient` sends a staff token, which is a stronger claim than
/// the device token and must not be overwritten.
class _ConnectorAuthedPaymentsClient implements PaymentsHttpClient {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async =>
      ProxyService.http.get(url, headers: await _headers(url, headers));

  @override
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async =>
      ProxyService.http.post(
        url,
        headers: await _headers(url, headers),
        body: body,
        encoding: encoding,
      );

  Future<Map<String, String>> _headers(
    Uri url,
    Map<String, String>? provided,
  ) async {
    final merged = <String, String>{...?provided};
    final callerSetAuth = merged.keys
        .any((k) => k.toLowerCase() == 'authorization');
    if (callerSetAuth) return merged;

    final base = '${url.scheme}://${url.authority}';
    final auth = await DataConnectorSessionService.authHeaders(baseUrl: base);
    // Empty while unenrolled or offline. The request still goes out, which is
    // what keeps payments working during the warn-mode rollout.
    merged.addAll(auth);
    return merged;
  }
}
