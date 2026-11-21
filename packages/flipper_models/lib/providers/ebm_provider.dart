import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show FutureProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/ebm.model.dart';

part 'ebm_provider.g.dart';

/// Thrown by [_loadBranchEbm] when no branch is chosen yet.
class _NoBranch implements Exception {
  const _NoBranch();
}

/// The current branch's EBM row, fetched remotely when possible so a device
/// sees an EBM support enabled on the server. Also keeps the `vatEnabled`
/// box key (read synchronously by the tax-code pickers) in step.
///
/// Throws [_NoBranch] before a branch is chosen; `null` means "no EBM row".
Future<Ebm?> _loadBranchEbm() async {
  final branchId = ProxyService.box.getBranchId();
  if (branchId == null) throw const _NoBranch();

  final ebm = await ProxyService.strategy.ebm(
    branchId: branchId,
    fetchRemote: true,
  );
  await ProxyService.box.writeBool(
    key: 'vatEnabled',
    value: ebm?.vatEnabled ?? false,
  );
  if (ProxyService.box.getUserLoggingEnabled() ?? false) {
    await LogService().logException(
      "Logger ${ebm?.vatEnabled}",
      type: 'business_fetch',
      tags: {
        'userId': ProxyService.box.getUserId()?.toString() ?? 'unknown',
        'method': 'businessesProvider',
      },
    );
  }
  return ebm;
}

/// Whether the branch is VAT-registered. Picks tax codes (A/B/C vs D) and VAT
/// display. This is **not** "EBM on": a branch can fiscalise through EBM
/// without VAT registration. Use [ebmOnProvider] for that.
@riverpod
Future<bool> ebmVatEnabled(Ref ref) async {
  ref.keepAlive();
  try {
    return (await _loadBranchEbm())?.vatEnabled ?? false;
  } catch (e) {
    // No branch, or the read failed: default to no VAT.
    return false;
  }
}

/// Whether the branch fiscalises through RRA EBM (`Ebm.isEbmOn`), without
/// the `false` fallback of [ebmOnProvider]: throws when there is no branch or
/// the EBM row cannot be read. For paths where a wrong "off" would skip RRA,
/// such as refunds.
Future<bool> loadEbmOn() async => (await _loadBranchEbm())?.isEbmOn ?? false;

/// Whether the branch fiscalises through RRA EBM (`Ebm.isEbmOn`): the same
/// switch Pay, refunds and stock movements read through `isTaxEnabled`.
/// An unreadable status reads as off; use [loadEbmOn] where that is unsafe.
///
/// It reads the box's branch, so a branch switch or user switch must
/// invalidate it.
final ebmOnProvider = FutureProvider<bool>((ref) async {
  try {
    return await loadEbmOn();
  } catch (e) {
    return false;
  }
});

/// Synchronous helper to get VAT enabled status from EBM configuration
/// This is used in non-widget contexts where providers can't be used
/// Returns a Future that resolves to the VAT enabled status
Future<bool> getVatEnabledFromEbm() async =>
    (await tryVatEnabledFromEbm()) ?? false;

/// [getVatEnabledFromEbm], but `null` when the EBM could not be read, so a
/// caller can keep its old behaviour instead of assuming "no VAT".
Future<bool?> tryVatEnabledFromEbm() async {
  try {
    return (await _loadBranchEbm())?.vatEnabled ?? false;
  } catch (e) {
    return null;
  }
}
