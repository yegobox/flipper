import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// Resolves the data-connector base URL for WhatsApp / OpenWA proxy calls.
///
/// **Only** [Ebm.dataConnectorUrl] (column `data_connector_url`) is used.
/// Never [Ebm.taxServerUrl] / `getServerUrl` — those are the RRA tax host.
Future<String?> resolveEbmDataConnectorUrl() async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null && branchId.isNotEmpty) {
      final ebm = await ProxyService.strategy.ebm(branchId: branchId);
      // Explicit: dataConnectorUrl only — do not use taxServerUrl / remoteServerUrl.
      final url = ebm?.dataConnectorUrl?.trim();
      if (url != null && url.isNotEmpty) {
        talker.info(
          'data-connector URL from Ebm.dataConnectorUrl: $url '
          '(taxServerUrl ignored)',
        );
        return url;
      }
      talker.warning(
        'EBM for branch $branchId has no dataConnectorUrl '
        '(taxServerUrl=${ebm?.taxServerUrl ?? "null"} is not used for WhatsApp)',
      );
    }
  } catch (e, s) {
    talker.warning('resolveEbmDataConnectorUrl EBM lookup failed: $e', e, s);
  }

  final cached = ProxyService.box.readString(key: 'dataConnectorUrl')?.trim();
  if (cached != null && cached.isNotEmpty) {
    talker.info('data-connector URL from box dataConnectorUrl: $cached');
    return cached;
  }
  return null;
}
