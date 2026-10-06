import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart'
    show pinnedPosCartTransactionIdProvider;
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

bool _isWritablePendingCart(ITransaction? transaction) {
  return transaction != null &&
      transaction.id.isNotEmpty &&
      transaction.status == PENDING;
}

/// Avoids Riverpod "modify during build" when stream already has a value.
void scheduleWriteCachedPendingCartTransaction(
  Ref ref, {
  required bool isExpense,
  required ITransaction? transaction,
}) {
  if (!_isWritablePendingCart(transaction)) return;
  final txn = transaction!;
  Future.microtask(() {
    writeCachedPendingCartTransaction(
      ref,
      isExpense: isExpense,
      transaction: txn,
    );
  });
}

/// Whether a pending-stream emission may become the cached cart.
///
/// A pinned cart (a resumed / collected ticket, mobile checkout) is the sale on
/// screen no matter what the stream says. The observer emits whichever PENDING
/// row was touched last — and mints a fresh one when the pinned row drops out
/// of its query — so caching every emission flipped the cart off a collected
/// ticket, and the customer's extra items landed on a new transaction.
/// Mirrors the pin guard in `posCartStreamReconciliationProvider`.
bool _emissionMayReplaceCache(String? pinnedId, ITransaction? emitted) {
  if (pinnedId == null || pinnedId.isEmpty) return true;
  return emitted != null && emitted.id == pinnedId;
}

/// Keeps [cachedPendingCartTransactionProvider] aligned with the Ditto stream.
void listenCachedPendingCartTransactionSync(
  Ref ref, {
  required bool isExpense,
}) {
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final initial = ref.read(pendingProv);
  if (initial.hasValue &&
      _emissionMayReplaceCache(
        ref.read(pinnedPosCartTransactionIdProvider),
        initial.value,
      )) {
    scheduleWriteCachedPendingCartTransaction(
      ref,
      isExpense: isExpense,
      transaction: initial.value,
    );
  }

  ref.listen(pendingProv, (_, next) {
    if (next.hasValue &&
        _emissionMayReplaceCache(
          ref.read(pinnedPosCartTransactionIdProvider),
          next.value,
        )) {
      scheduleWriteCachedPendingCartTransaction(
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
}) => ref.read(cachedPendingCartTransactionProvider(isExpense));

void writeCachedPendingCartTransactionContainer(
  ProviderContainer container, {
  required bool isExpense,
  required ITransaction? transaction,
}) {
  if (transaction == null ||
      transaction.id.isEmpty ||
      transaction.status != PENDING) {
    return;
  }
  container
          .read(cachedPendingCartTransactionProvider(isExpense).notifier)
          .state =
      transaction;
}

void writeCachedPendingCartTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
  required ITransaction? transaction,
}) {
  writeCachedPendingCartTransactionContainer(
    ref.container,
    isExpense: isExpense,
    transaction: transaction,
  );
}

void clearCachedPendingCartTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
}) {
  ref.read(cachedPendingCartTransactionProvider(isExpense).notifier).state =
      null;
}

void scheduleWriteCachedPendingCartTransactionWidget(
  WidgetRef ref, {
  required bool isExpense,
  required ITransaction? transaction,
}) {
  if (!_isWritablePendingCart(transaction)) return;
  final txn = transaction!;
  Future.microtask(() {
    writeCachedPendingCartTransactionWidget(
      ref,
      isExpense: isExpense,
      transaction: txn,
    );
  });
}

void listenCachedPendingCartTransactionSyncWidget(
  WidgetRef ref, {
  required bool isExpense,
}) {
  final pendingProv = pendingTransactionStreamProvider(isExpense: isExpense);
  final initial = ref.read(pendingProv);
  if (initial.hasValue &&
      _emissionMayReplaceCache(
        ref.read(pinnedPosCartTransactionIdProvider),
        initial.value,
      )) {
    scheduleWriteCachedPendingCartTransactionWidget(
      ref,
      isExpense: isExpense,
      transaction: initial.value,
    );
  }

  ref.listen(pendingProv, (_, next) {
    if (next.hasValue &&
        _emissionMayReplaceCache(
          ref.read(pinnedPosCartTransactionIdProvider),
          next.value,
        )) {
      scheduleWriteCachedPendingCartTransactionWidget(
        ref,
        isExpense: isExpense,
        transaction: next.value,
      );
    }
  });
}
