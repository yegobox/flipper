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
  final resolved = resolvedPendingTxnId ??
      readPosCartTransactionIdFast(ref, isExpense: isExpense);
  final optimismTxnId = (resolved != null && resolved.isNotEmpty)
      ? resolved
      : OptimisticCartBootstrap.txnId;

  if (isOrdering) return;

  ref.read(optimisticCartProvider.notifier).addPendingLine(
        transactionId: optimismTxnId,
        variant: variant,
      );
  bumpPosCartDisplayEpoch(ref);

  if (OptimisticCartBootstrap.isBootstrap(optimismTxnId)) {
    final realId =
        readCachedPendingCartTransaction(ref, isExpense: isExpense)?.id ??
            ref
                .read(pendingTransactionStreamProvider(isExpense: isExpense))
                .value
                ?.id;
    if (realId != null && realId.isNotEmpty) {
      ref
          .read(optimisticCartProvider.notifier)
          .bindPendingTransaction(realId);
    }
  }
}

