import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_payments/flipper_payments.dart';
import 'package:flipper_services/proxy.dart';

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
  setDefaultPaymentsHttpClient(ProxyService.http);
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
