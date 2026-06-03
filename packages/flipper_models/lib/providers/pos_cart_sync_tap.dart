import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Wall-clock budget for tap → cart line visible in Riverpod (no Capella/Ditto I/O).
///
/// CI-safe upper bound; typical runs are tens–hundreds of µs. Persist runs later.
const int kPosCartTapDisplayMaxMicroseconds = 3000;

/// Iterations for the "every tap is fast" regression guard.
const int kPosCartTapDisplayIterations = 200;

/// Synchronous POS grid tap: optimistic ghost + display epoch only.
///
/// Capella/Ditto writes happen later via [PosCartAddService] post-frame persist.
void applyPosCartTapSync({
  required Ref ref,
  required Variant variant,
  required bool isOrdering,
  String? resolvedPendingTxnId,
}) {
  if (variant.id.isEmpty) return;

  final isExpense = isOrdering;
  if (isOrdering) return;

  var txnId = resolvedPendingTxnId ??
      readPosCartTransactionIdFast(ref, isExpense: isExpense);
  if (txnId == null || txnId.isEmpty) {
    txnId =
        readCachedPendingCartTransaction(ref, isExpense: isExpense)?.id ??
            ref
                .read(pendingTransactionStreamProvider(isExpense: isExpense))
                .value
                ?.id ??
            OptimisticCartBootstrap.txnId;
  }

  // Single notifier update — avoids bind + epoch double-invalidation.
  ref.read(optimisticCartProvider.notifier).addPendingLine(
        transactionId: txnId,
        variant: variant,
      );
}

