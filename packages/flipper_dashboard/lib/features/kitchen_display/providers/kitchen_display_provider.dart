import 'package:flipper_models/models/kitchen_order.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Stages the kitchen has just dropped orders into, keyed by ticket id, held
/// until the `kitchen_orders` stream reflects the write (or it fails).
///
/// Replaces the old notifier that mutated the stream's own ticket objects and
/// wrote kitchen columns onto `transactions.status`.
class KitchenStageOverridesNotifier
    extends StateNotifier<Map<String, KitchenStage>> {
  KitchenStageOverridesNotifier() : super(const {});

  void set(String transactionId, KitchenStage stage) {
    state = {...state, transactionId: stage};
  }

  void remove(String transactionId) {
    if (!state.containsKey(transactionId)) return;
    state = Map.of(state)..remove(transactionId);
  }

  void removeAll(Set<String> transactionIds) {
    if (transactionIds.isEmpty) return;
    state = Map.of(state)..removeWhere((id, _) => transactionIds.contains(id));
  }
}

final kitchenStageOverridesProvider =
    StateNotifierProvider.autoDispose<
      KitchenStageOverridesNotifier,
      Map<String, KitchenStage>
    >((ref) => KitchenStageOverridesNotifier());
