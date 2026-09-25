import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The Capella (Ditto) strategy the kitchen flow reads and writes through.
///
/// The single service-locator lookup for the Kitchen Display and the Tickets
/// "Send to kitchen" action: everything else takes it from Riverpod, so tests
/// can override it instead of booting the app.
final kitchenCapellaProvider = Provider<DatabaseSyncInterface>(
  (ref) => ProxyService.getStrategy(Strategy.capella),
);

/// Session branch id for the kitchen flow, re-read on branch switch only —
/// not on every branch doc update, which would tear down the observers.
///
/// The session box stays the source of truth (as for the Tickets stream):
/// [activeBranchProvider] resolves the branch *document*, which can lag or
/// time out, and the Kitchen Display must not wait on it.
final kitchenBranchIdProvider = Provider.autoDispose<String?>((ref) {
  ref.watch(activeBranchProvider.select((b) => b.value?.id));
  final branchId = ProxyService.box.getBranchId();
  return (branchId == null || branchId.isEmpty) ? null : branchId;
});

/// Orders on the Kitchen Display for the active branch, each with its ticket.
///
/// Reads `kitchen_orders` (Capella), not the Tickets query: a ticket shows here
/// only once it was sent to the kitchen, and stays until the kitchen serves it
/// even if it was paid in the meantime.
final kitchenOrdersStreamProvider =
    StreamProvider.autoDispose<List<KitchenOrderView>>((ref) {
      final branchId = ref.watch(kitchenBranchIdProvider);
      if (branchId == null) {
        return Stream.value(const <KitchenOrderView>[]);
      }
      return ref
          .watch(kitchenCapellaProvider)
          .kitchenOrdersStream(branchId: branchId);
    });

/// Kitchen stage per ticket id (in the kitchen, or served in the last day) —
/// one observer for the whole Tickets list, so cards can show "In kitchen" /
/// "Served · ready for payment" without one query each.
final kitchenOrderStagesProvider =
    StreamProvider.autoDispose<Map<String, KitchenStage>>((ref) {
      final branchId = ref.watch(kitchenBranchIdProvider);
      if (branchId == null) {
        return Stream.value(const <String, KitchenStage>{});
      }
      return ref
          .watch(kitchenCapellaProvider)
          .kitchenOrderStagesStream(branchId: branchId);
    });
