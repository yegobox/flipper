import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_services/proxy.dart';

// Provider to cache transaction items for each request
final transactionItemsProvider =
    FutureProvider.family<List<TransactionItem>, String>(
  (ref, requestId) =>
      ProxyService.strategy.transactionItems(requestId: requestId),
);
