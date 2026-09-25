import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/kitchen_orders_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that fetches transaction items for a specific transaction
///
/// Uses FutureProvider with ref.keepAlive() to cache results and prevent
/// duplicate Ditto subscriptions when multiple widgets watch the same transaction.
final transactionItemsProvider = FutureProvider.family
    .autoDispose<List<TransactionItem>, String>((ref, transactionId) async {
      // Fetch once and cache - Riverpod will manage the cache
      return await ProxyService.strategy.transactionItems(
        transactionId: transactionId,
        active: true,
      );
    });

/// Lines for a Kitchen Display card, read from Capella (Ditto) — the store
/// tickets are written to. [transactionItemsProvider] reads the default
/// strategy, which off-web is not Capella, so kitchen cards came up with
/// "No items found". Kept separate so [transactionItemsProvider]'s other
/// caller (the sale indicator) is unaffected.
final kitchenTicketItemsProvider = FutureProvider.family
    .autoDispose<List<TransactionItem>, String>((ref, transactionId) {
      return ref
          .watch(kitchenCapellaProvider)
          .transactionItems(transactionId: transactionId, active: true);
    });
