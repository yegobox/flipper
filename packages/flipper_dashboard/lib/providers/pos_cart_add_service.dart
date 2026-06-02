import 'dart:async';

import 'package:flipper_dashboard/transaction_item_adder_persist.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pending_cart_sale_session_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Grid / scanner: tap → instant cart ([posCartDisplayItemsProvider]), Ditto in background.
final posCartAddServiceProvider = Provider<PosCartAddService>(PosCartAddService.new);

class PosCartAddService {
  PosCartAddService(this.ref);

  final Ref ref;

  /// Instant UI update. Never blocks on Ditto.
  void tapAdd({
    required BuildContext context,
    required Variant variant,
    required bool isOrdering,
    Product? product,
    bool isComposite = false,
  }) {
    if (variant.id.isEmpty) return;

    final isExpense = isOrdering;
    warmPosCartPendingTransactionCache(ref, isExpense: isExpense);
    final resolvedTxnId =
        readPosCartTransactionIdFast(ref, isExpense: isExpense);
    final optimismTxnId = (resolvedTxnId != null && resolvedTxnId.isNotEmpty)
        ? resolvedTxnId
        : OptimisticCartBootstrap.txnId;

    ref.read(optimisticOrderCountProvider.notifier).increment();

    var cartOptimismApplied = false;
    if (!isOrdering) {
      ref.read(optimisticCartProvider.notifier).addPendingLine(
            transactionId: optimismTxnId,
            variant: variant,
          );
      cartOptimismApplied = true;
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

    unawaited(
      _runPersist(
        context: context,
        variant: variant,
        isOrdering: isOrdering,
        product: product,
        isComposite: isComposite,
        cartOptimismApplied: cartOptimismApplied,
      ),
    );
  }

  /// Scanner / flows that need success/failure.
  Future<bool> addAndWait({
    required BuildContext context,
    required Variant variant,
    required bool isOrdering,
    Product? product,
    bool isComposite = false,
  }) async {
    tapAdd(
      context: context,
      variant: variant,
      isOrdering: isOrdering,
      product: product,
      isComposite: isComposite,
    );
    return true;
  }

  Future<void> _runPersist({
    required BuildContext context,
    required Variant variant,
    required bool isOrdering,
    required Product? product,
    required bool isComposite,
    required bool cartOptimismApplied,
  }) async {
    final pendingProv = pendingTransactionStreamProvider(
      isExpense: isOrdering,
    );
    final sessionAtStart = ref.read(pendingCartSaleSessionProvider);

    try {
      var txn = readCachedPendingCartTransaction(ref, isExpense: isOrdering);
      txn ??= await resolvePendingTransactionForPersist(
        ref: ref,
        pendingProv: pendingProv,
        isOrdering: isOrdering,
      );
      if (txn == null || txn.id.isEmpty) {
        ref.read(optimisticOrderCountProvider.notifier).decrement();
        if (cartOptimismApplied) {
          final tid = readPendingCartTransactionId(ref, isExpense: isOrdering);
          if (tid != null) {
            ref
                .read(optimisticCartProvider.notifier)
                .rollbackPending(transactionId: tid, variantId: variant.id);
          }
        }
        if (context.mounted) {
          showErrorNotification(context, 'No active sale cart. Try again.');
        }
        return;
      }

      if (!cartOptimismApplied && !isOrdering) {
        ref
            .read(optimisticCartProvider.notifier)
            .addPendingLine(transactionId: txn.id, variant: variant);
        cartOptimismApplied = true;
        bumpPosCartDisplayEpoch(ref);
      }

      await persistItemToTransaction(
        ref: ref,
        context: context,
        variant: variant,
        isOrdering: isOrdering,
        productHint: product,
        isCompositeProduct: isComposite,
        pendingProv: pendingProv,
        pendingTransaction: txn,
        sessionAtStart: sessionAtStart,
        cartOptimismApplied: cartOptimismApplied,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
    } catch (e, s) {
      await handlePersistFailure(
        ref: ref,
        context: context,
        e: e,
        s: s,
        variant: variant,
        txn: await resolvePendingTransactionForPersist(
          ref: ref,
          pendingProv: pendingProv,
          isOrdering: isOrdering,
        ),
        cartOptimismApplied: cartOptimismApplied,
      );
    }
  }
}
