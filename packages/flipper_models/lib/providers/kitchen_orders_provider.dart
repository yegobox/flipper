import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Orders on the Kitchen Display for the active branch, each with its ticket.
///
/// Reads `kitchen_orders` (Capella), not the Tickets query: a ticket shows here
/// only once it was sent to the kitchen, and stays until the kitchen serves it
/// even if it was paid in the meantime.
final kitchenOrdersStreamProvider =
    StreamProvider.autoDispose<List<KitchenOrderView>>((ref) {
      // Re-subscribe on branch switch only — not on every branch doc update,
      // which would tear down both observers.
      ref.watch(activeBranchProvider.select((b) => b.value?.id));
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null || branchId.isEmpty) {
        return Stream.value(const <KitchenOrderView>[]);
      }
      return ProxyService.getStrategy(
        Strategy.capella,
      ).kitchenOrdersStream(branchId: branchId);
    });

/// Kitchen stage per ticket id (in the kitchen, or served in the last day) —
/// one observer for the whole Tickets list, so cards can show "In kitchen" /
/// "Served · ready for payment" without one query each.
final kitchenOrderStagesProvider =
    StreamProvider.autoDispose<Map<String, KitchenStage>>((ref) {
      ref.watch(activeBranchProvider.select((b) => b.value?.id));
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null || branchId.isEmpty) {
        return Stream.value(const <String, KitchenStage>{});
      }
      return ProxyService.getStrategy(
        Strategy.capella,
      ).kitchenOrderStagesStream(branchId: branchId);
    });
