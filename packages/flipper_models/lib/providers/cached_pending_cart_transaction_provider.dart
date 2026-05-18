import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Last known pending POS cart for sales ([isExpense] false).
final cachedPendingSaleTransactionProvider = StateProvider<ITransaction?>(
  (ref) => null,
);

/// Last known pending POS cart for purchases ([isExpense] true).
final cachedPendingPurchaseTransactionProvider = StateProvider<ITransaction?>(
  (ref) => null,
);

StateProvider<ITransaction?> cachedPendingCartTransactionProvider(
  bool isExpense,
) => isExpense
    ? cachedPendingPurchaseTransactionProvider
    : cachedPendingSaleTransactionProvider;

/// Synchronous read for hot paths (grid tap → cart).
ITransaction? readCachedPendingCartTransaction(
  Ref ref, {
  required bool isExpense,
}) {
  return ref.read(cachedPendingCartTransactionProvider(isExpense));
}

void writeCachedPendingCartTransaction(
  Ref ref, {
  required bool isExpense,
  required ITransaction? transaction,
}) {
  if (transaction == null ||
      transaction.id.isEmpty ||
      transaction.status != PENDING) {
    return;
  }
  ref.read(cachedPendingCartTransactionProvider(isExpense).notifier).state =
      transaction;
}

void clearCachedPendingCartTransaction(Ref ref, {required bool isExpense}) {
  ref.read(cachedPendingCartTransactionProvider(isExpense).notifier).state =
      null;
}

/// Keeps [cachedPendingCartTransactionProvider] aligned with the Ditto stream.
void listenCachedPendingCartTransactionSync(
  Ref ref, {
  required bool isExpense,
}) {
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final initial = ref.read(pendingProv);
  if (initial.hasValue && initial.value != null) {
    writeCachedPendingCartTransaction(
      ref,
      isExpense: isExpense,
      transaction: initial.value,
    );
  }

  ref.listen(pendingProv, (_, next) {
    if (next.hasValue && next.value != null) {
      writeCachedPendingCartTransaction(
        ref,
        isExpense: isExpense,
        transaction: next.value,
      );
    }
  });
}

// WidgetRef and Ref are not assignable in this Riverpod version — thin widget wrappers.

ITransaction? readCachedPendingCartTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
}) =>
    ref.read(cachedPendingCartTransactionProvider(isExpense));

void writeCachedPendingCartTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
  required ITransaction? transaction,
}) {
  if (transaction == null ||
      transaction.id.isEmpty ||
      transaction.status != PENDING) {
    return;
  }
  ref.read(cachedPendingCartTransactionProvider(isExpense).notifier).state =
      transaction;
}

void clearCachedPendingCartTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
}) {
  ref.read(cachedPendingCartTransactionProvider(isExpense).notifier).state =
      null;
}

void listenCachedPendingCartTransactionSyncWidget(
  WidgetRef ref, {
  required bool isExpense,
}) {
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final initial = ref.read(pendingProv);
  if (initial.hasValue && initial.value != null) {
    writeCachedPendingCartTransactionWidget(
      ref,
      isExpense: isExpense,
      transaction: initial.value,
    );
  }

  ref.listen(pendingProv, (_, next) {
    if (next.hasValue && next.value != null) {
      writeCachedPendingCartTransactionWidget(
        ref,
        isExpense: isExpense,
        transaction: next.value,
      );
    }
  });
}
