import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/ebm_provider.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Ensures Ditto pending cart + catalog page exist before opening POS (mobile home).
void warmMobilePosForCheckout(WidgetRef ref) {
  warmPosCartPendingTransactionCacheWidget(ref, isExpense: false);

  final branchId = ProxyService.box.getBranchId();
  if (branchId == null || branchId.isEmpty) return;

  // Prefer future over stream `.future` — stream first emit waits on cart creation.
  unawaited(
    ProxyService.getStrategy(Strategy.capella)
        .pendingTransactionFuture(
          branchId: branchId,
          transactionType: TransactionType.sale,
          isExpense: false,
        )
        .then((txn) {
          if (txn == null) return;
          scheduleWriteCachedPendingCartTransactionWidget(
            ref,
            isExpense: false,
            transaction: txn,
          );
          Future.microtask(
            () => ref
                .read(optimisticCartProvider.notifier)
                .bindPendingTransaction(txn.id),
          );
        }),
  );

  unawaited(ref.read(ebmVatEnabledProvider.future));
  unawaited(ref.read(outerVariantsProvider(branchId).future));
}
