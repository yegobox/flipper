// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/mobile_checkout_screen.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/controllers/checkout_controller.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_dashboard/utils/resume_transaction_helper.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Opens full-screen mobile checkout ([MobileCheckoutScreen]) without the POS catalog.
Future<void> openMobileCheckoutForTransaction(
  BuildContext context,
  WidgetRef ref,
  ITransaction transaction,
) async {
  primePosCartForTransactionWidget(
    ref,
    isExpense: false,
    transaction: transaction,
  );
  try {
    await Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _MobileCheckoutLauncherHost(transaction: transaction),
      ),
    );
  } finally {
    clearPinnedPosCartTransactionContainer(ref.container);
  }
}

class _MobileCheckoutLauncherHost extends ConsumerStatefulWidget {
  const _MobileCheckoutLauncherHost({required this.transaction});

  final ITransaction transaction;

  @override
  ConsumerState<_MobileCheckoutLauncherHost> createState() =>
      _MobileCheckoutLauncherHostState();
}

class _MobileCheckoutLauncherHostState
    extends ConsumerState<_MobileCheckoutLauncherHost>
    with TextEditingControllersMixin, TransactionMixinOld, PreviewCartMixin, Refresh {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        TransactionInitializationHelper.initializeSession(
          ref: ref,
          transaction: widget.transaction,
        ),
      );
    });
  }

  Future<void> _afterCheckoutSaleCleanup(ITransaction transaction) async {
    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    final branchId = ProxyService.box.getBranchId() ?? '0';
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transaction.id,
        branchId: branchId,
      ),
    );
    ref.invalidate(
      pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false,
      ),
    );
    ref
        .read(optimisticCartProvider.notifier)
        .clearForTransaction(transaction.id);
  }

  Future<bool> _handleCompleteTransaction(
    ITransaction transaction,
    bool immediateCompletion, [
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  ]) async {
    final controller = CheckoutController(ref: ref, context: context);

    final transactionItemsHint =
        ref.read(optimisticCartProvider.notifier).hasPendingFor(transaction.id)
        ? null
        : ref
              .read(posCartDisplayItemsProvider)
              .where((i) => !OptimisticCartIds.isOptimistic(i.id))
              .toList();

    return controller.handleCompleteTransaction(
      transaction: transaction,
      immediateCompletion: immediateCompletion,
      startCompleteTransactionFlow: startCompleteTransactionFlow,
      applyDiscount: applyDiscount,
      refreshTransactionItems: refreshTransactionItems,
      discountController: discountController,
      afterCheckoutSaleCleanup: _afterCheckoutSaleCleanup,
      transactionItemsHint: transactionItemsHint,
      onPaymentConfirmed: onPaymentConfirmed,
      onPaymentFailed: onPaymentFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final txn = widget.transaction;
    return MobileCheckoutScreen(
      transaction: txn,
      doneDelete: () {
        final branchId = ProxyService.box.getBranchId();
        if (branchId == null || branchId.isEmpty) return;
        ref.invalidate(
          transactionItemsStreamProvider(
            transactionId: txn.id,
            branchId: branchId,
          ),
        );
      },
      onCharge:
          (
            transactionId,
            total,
            onPaymentConfirmed,
            onPaymentFailed, [
            bool immediateCompletion = false,
          ]) async {
            return _handleCompleteTransaction(
              txn,
              immediateCompletion,
              onPaymentConfirmed,
              onPaymentFailed,
            );
          },
    );
  }
}
