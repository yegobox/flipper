import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

/// Cart panel mode in QuickSellingView — independent of warehouse [isOrdering].
enum CheckoutCartMode { sale, transfer }

final checkoutCartModeProvider = StateProvider<CheckoutCartMode>(
  (ref) => CheckoutCartMode.sale,
);

/// Destination branch for outgoing POS transfer (Sale → Transfer).
final transferDestinationBranchProvider = StateProvider<Branch?>((ref) => null);

/// Business and branch the POS is signed into — the ids
/// [CheckoutTransferBranchRow] reads. Re-read each time checkout opens.
final checkoutTransferSessionProvider =
    Provider.autoDispose<({String? businessId, String? branchId})>(
      (ref) => (
        businessId: ProxyService.box.getBusinessId(),
        branchId: ProxyService.box.getBranchId(),
      ),
    );

/// Mobile checkout offers Sale → Transfer only when the business has another
/// branch to send to — exactly the destinations [CheckoutTransferBranchRow]
/// lists — and no till ticket is being collected (desktop disables it there
/// too). False while loading or on error, so the toggle never flashes in.
final canOfferBranchTransferProvider = Provider.autoDispose<bool>((ref) {
  if (ref.watch(effectiveSettlingTillTicketProvider) != null) return false;
  final session = ref.watch(checkoutTransferSessionProvider);
  final businessId = session.businessId;
  if (businessId == null || businessId.isEmpty) return false;
  final branches = ref
      .watch(branchesProvider(businessId: businessId))
      .asData
      ?.value;
  return branches?.any((b) => b.id != session.branchId) ?? false;
});
