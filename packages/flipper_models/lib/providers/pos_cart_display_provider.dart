import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

bool _posCartIsExpense() => ProxyService.box.isOrdering() ?? false;

/// Reconciles optimistic pending qty when Ditto line items stream updates.
///
/// Side effects are scheduled with [Future.microtask] so we never modify other
/// providers during this provider's build (Riverpod assertion).
final posCartStreamReconciliationProvider = Provider<void>((ref) {
  final isExpense = _posCartIsExpense();
  // Re-subscribe when bootstrap binds to the real pending sale id.
  ref.watch(optimisticCartProvider.select((s) => s.activeTransactionId));

  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);

  void syncPendingTransaction(ITransaction txn) {
    Future.microtask(() {
      writeCachedPendingCartTransaction(
        ref,
        isExpense: isExpense,
        transaction: txn,
      );
      ref.read(optimisticCartProvider.notifier).bindPendingTransaction(txn.id);
    });
  }

  ref.listen(pendingProv, (_, next) {
    if (next.hasValue && next.value != null) {
      syncPendingTransaction(next.value!);
    }
  }, fireImmediately: true);

  final mergeTxnId = _mergeTxnId(ref, isExpense: isExpense);
  if (mergeTxnId.isEmpty || OptimisticCartBootstrap.isBootstrap(mergeTxnId)) {
    return;
  }

  ref.listen(
    transactionItemsStreamProvider(
      transactionId: mergeTxnId,
      branchId: ProxyService.box.getBranchId() ?? '0',
    ),
    (_, next) {
      if (next.hasValue) {
        Future.microtask(() {
          ref.read(optimisticCartProvider.notifier).onStreamEmitted(
                transactionId: mergeTxnId,
                items: next.value!,
              );
        });
      }
    },
    fireImmediately: true,
  );
});

/// Single cart list for checkout UI: Ditto rows + unresolved optimistic qty.
final posCartDisplayItemsProvider = Provider<List<TransactionItem>>((ref) {
  ref.watch(posCartStreamReconciliationProvider);

  final isExpense = _posCartIsExpense();
  final optimistic = ref.watch(optimisticCartProvider);
  final mergeTxnId = _mergeTxnId(ref, isExpense: isExpense);
  if (mergeTxnId.isEmpty) return const [];

  if (OptimisticCartBootstrap.isBootstrap(mergeTxnId)) {
    return mergeTransactionItemsWithOptimisticCart(
      streamItems: const [],
      optimistic: optimistic,
      transactionId: mergeTxnId,
    );
  }

  final streamAsync = ref.watch(
    transactionItemsStreamProvider(
      transactionId: mergeTxnId,
      branchId: ProxyService.box.getBranchId() ?? '0',
    ),
  );

  List<TransactionItem> merge(List<TransactionItem> raw) =>
      mergeTransactionItemsWithOptimisticCart(
        streamItems: raw,
        optimistic: optimistic,
        transactionId: mergeTxnId,
      );

  return streamAsync.when(
    data: merge,
    loading: () => merge(const []),
    error: (_, __) => merge(const []),
  );
});

String _mergeTxnId(Ref ref, {required bool isExpense}) {
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final fromStream = ref.read(pendingProv).value?.id;
  final fromCache = readCachedPendingCartTransaction(ref, isExpense: isExpense)?.id;
  final optimistic = ref.read(optimisticCartProvider);
  return cartTransactionIdForMerge(
    pendingTransactionId: fromStream ?? fromCache,
    optimistic: optimistic,
  );
}
