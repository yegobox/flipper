import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';

/// Whether EBM/RRA will actually sign a receipt for the current branch.
///
/// Mirrors the gate `finalizePayment` applies before calling
/// `handleReceiptGeneration`: VAT must be enabled on the branch EBM record, a
/// tax server must be configured, the device must have a `bhfId`, and the tax
/// service must not be stopped.
///
/// Callers use this to avoid asking for EBM-only input (a purchase code) from a
/// business whose sale will never reach RRA. On any failure this returns
/// `false` — the sale still completes, it just is not blocked on that input.
Future<bool> ebmWillSignReceipt() async {
  try {
    final businessId = ProxyService.box.getBusinessId();
    final branchId = ProxyService.box.getBranchId();
    if (businessId == null || branchId == null) return false;
    if (ProxyService.box.stopTaxService() ?? false) return false;
    if ((await ProxyService.box.bhfId()) == null) return false;

    final capella = ProxyService.getStrategy(Strategy.capella);
    final taxEnabled = await capella.isTaxEnabled(
      businessId: businessId,
      branchId: branchId,
    );
    if (!taxEnabled) return false;

    final ebm = await capella.ebm(branchId: branchId);
    return ebm?.taxServerUrl != null;
  } catch (e, s) {
    talker.error('Failed to resolve EBM receipt-signing state', e, s);
    return false;
  }
}
