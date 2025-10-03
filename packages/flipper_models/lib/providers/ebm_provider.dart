import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider that fetches the VAT enabled status from the EBM configuration
final ebmVatEnabledProvider = FutureProvider<bool>((ref) async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return false;

    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    // Return the VAT enabled status, default to false if ebm is null
    return ebm?.vatEnabled ?? false;
  } catch (e) {
    // If there's an error, default to false
    return false;
  }
});

/// Synchronous helper to get VAT enabled status from EBM configuration
/// This is used in non-widget contexts where providers can't be used
/// Returns a Future that resolves to the VAT enabled status
Future<bool> getVatEnabledFromEbm() async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return false;

    final ebm = await ProxyService.strategy.ebm(branchId: branchId);
    return ebm?.vatEnabled ?? false;
  } catch (e) {
    return false;
  }
}
