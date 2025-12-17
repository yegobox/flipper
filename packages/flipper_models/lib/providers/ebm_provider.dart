import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ebm_provider.g.dart';

/// Provider that fetches the VAT enabled status from the EBM configuration
@riverpod
Future<bool> ebmVatEnabled(Ref ref) async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return false;

    // Try to get EBM from local cache first, but also attempt remote fetch
    // to ensure we have the latest data even if this is the first time on a device
    final ebm =
        await ProxyService.strategy.ebm(branchId: branchId, fetchRemote: true);
    // Return the VAT enabled status, default to false if ebm is null
    final logService = LogService();
    await logService.logException(
      "Logger ${ebm?.vatEnabled}",
      // stackTrace: "Logger",
      type: 'business_fetch',
      tags: {
        'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
        'method': 'businessesProvider',
      },
    );
    return ebm?.vatEnabled ?? false;
  } catch (e) {
    // If there's an error, default to false
    return false;
  }
}

/// Synchronous helper to get VAT enabled status from EBM configuration
/// This is used in non-widget contexts where providers can't be used
/// Returns a Future that resolves to the VAT enabled status
Future<bool> getVatEnabledFromEbm() async {
  try {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return false;

    // Try to get EBM from local cache first, but also attempt remote fetch
    // to ensure we have the latest data even if this is the first time on a device
    final ebm =
        await ProxyService.strategy.ebm(branchId: branchId, fetchRemote: true);
    final logService = LogService();
    await logService.logException(
      "Logger ${ebm?.vatEnabled}",
      // stackTrace: "Logger",
      type: 'business_fetch',
      tags: {
        'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
        'method': 'businessesProvider',
      },
    );
    return ebm?.vatEnabled ?? false;
  } catch (e) {
    return false;
  }
}
