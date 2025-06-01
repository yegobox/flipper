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
