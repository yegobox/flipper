import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that fetches transaction items for a specific transaction
final transactionItemsProvider =
    StreamProvider.family<List<TransactionItem>, String>(
  (ref, transactionId) {
    return ProxyService.strategy.transactionItemsStreams(
      transactionId: transactionId,
      active: true,
    );
  },
);
