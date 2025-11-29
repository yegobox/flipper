// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/dialog_status.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';

class OrderingViewModel extends ProductViewModel
    with TextEditingControllersMixin, SnackBarMixin {
  final _dialogService = locator<DialogService>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> handlePreviewCart(
    WidgetRef ref,
    int orderCount,
    ITransaction transaction,
    bool isOrdering,
    BuildContext context,
  ) async {
    final supplier = ref.read(selectedSupplierProvider);
    if (supplier == null) {
      _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description: 'Please select a supplier first.',
        data: {'status': InfoDialogStatus.error},
      );
      return;
    }

    // Check if serverId is null or invalid before comparing
    if (supplier.serverId == null) {
      _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description:
            'Selected supplier has invalid ID. Please select a different supplier.',
        data: {'status': InfoDialogStatus.error},
      );
      return;
    }

    if (supplier.serverId == ProxyService.box.getBranchId()) {
      _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description: 'You can not order from yourself.',
        data: {'status': InfoDialogStatus.error},
      );
      return;
    }
    if (orderCount > 0) {
      final isPreviewing = ref.read(previewingCart.notifier).state;
      if (!isPreviewing) {
        ref.read(previewingCart.notifier).state = true;
      }
    } else {
      showCustomSnackBar(context, "The cart is empty");
    }
  }

  Future<void> handleOrderPlacement(
    WidgetRef ref,
    ITransaction transaction,
    bool isOrdering,
    FinanceProvider financeOption,
    BuildContext context,
  ) async {
    try {
      setLoading(true);

      // Place the order
      await placeFinalOrder(
        ref: ref,
        transaction: transaction,
        financeOption: financeOption,
      );

      // Send SMS notification
      final items = await ProxyService.strategy.transactionItems(
        transactionId: transaction.id,
      );
      final itemCount = items.length;
      final totalAmount = items.fold(
        0.0,
        (sum, item) => sum + (item.qty * item.price),
      );

      final orderDetails =
          'New order with $itemCount items, total: \$${totalAmount.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}';

      final supplier = ref.read(selectedSupplierProvider);
      if (supplier == null || supplier.serverId == null) {
        setLoading(false);
        _dialogService.showCustomDialog(
          variant: DialogType.info,
          title: 'Error',
          description: 'Please select a supplier first.',
          data: {'status': InfoDialogStatus.error},
        );
        return;
      }

      transaction.supplierId = supplier.serverId!;
      ProxyService.strategy.updateTransaction(
        transaction: transaction,
        supplierId: supplier.serverId!,
      );
      final requesterBranchId = ProxyService.box.getBranchId()!;

      // Get requester's phone number from their branch config
      final requesterConfig = await SmsNotificationService.getBranchSmsConfig(
        requesterBranchId,
      );
      final requesterPhone = requesterConfig?.smsPhoneNumber ?? '';

      // Send SMS to both requester and receiver
      await SmsNotificationService.sendOrderRequestNotification(
        receiverBranchId: supplier.serverId!,
        orderDetails: orderDetails,
        requesterPhone: requesterPhone,
      );

      // Refresh the transaction state
      // ignore:
      ref.refresh(pendingTransactionStreamProvider(isExpense: isOrdering));
      await _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Order Placed Successfully',
        description: 'Your order has been processed and confirmed.',
        data: {'status': InfoDialogStatus.success},
      );

      // Switch back to product list AFTER success modal is closed
      ref.read(previewingCart.notifier).state = false;

      showCustomSnackBar(context, 'Order Placed successfully');
    } catch (e) {
      setLoading(false);
      _dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Error',
        description: e.toString(),
        data: {'status': InfoDialogStatus.error},
      );
      talker.error(e);
    }
  }

  /// Copied and adapted from PreviewCartMixin
  Future<void> placeFinalOrder({
    required WidgetRef ref,
    bool isShoppingFromWareHouse = true,
    required ITransaction transaction,
    required FinanceProvider financeOption,
  }) async {
    if (!isShoppingFromWareHouse) {
      return;
    }

    try {
      String deliveryNote = deliveryNoteCotroller.text;

      final items = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
            branchId: (await ProxyService.strategy.activeBranch()).id,
            transactionId: transaction.id,
            doneWithTransaction: false,
            active: true,
          );

      if (items.isEmpty) {
        return;
      }

      final supplier = ref.read(selectedSupplierProvider);
      if (supplier == null || supplier.serverId == null) {
        throw Exception('Please select a supplier first.');
      }

      // ignore: unused_local_variable
      String orderId = await ProxyService.strategy.createStockRequest(
        items,
        mainBranchId: supplier.serverId!,
        subBranchId: ProxyService.box.getBranchId()!,
        deliveryNote: deliveryNote,
        orderNote: null,
        financingId: financeOption.id,
      );
      await _markItemsAsDone(items, transaction);
      _changeTransactionStatus(transaction: transaction);
      await _refreshTransactionItems(ref: ref, transactionId: transaction.id);
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  FutureOr<void> _changeTransactionStatus({
    required ITransaction transaction,
  }) async {
    await ProxyService.strategy.updateTransaction(
      transaction: transaction,
      status: ORDERING,
    );
  }

  Future<void> _markItemsAsDone(
    List<TransactionItem> items,
    dynamic pendingTransaction,
  ) async {
    ProxyService.strategy.markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      ignoreForReport: false,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _refreshTransactionItems({
    required WidgetRef ref,
    required String transactionId,
  }) async {
    ref.refresh(transactionItemsProvider(transactionId: transactionId));

    ref.refresh(pendingTransactionStreamProvider(isExpense: false));

    /// get new transaction id
    ref.refresh(pendingTransactionStreamProvider(isExpense: false));

    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }

  /// Copied and adapted from Refresh mixin
  Future<void> refreshTransactionItems({
    required WidgetRef ref,
    required String transactionId,
  }) async {
    try {
      /// clear the current cart
      ref.refresh(transactionItemsProvider(transactionId: transactionId));

      ref.read(loadingProvider.notifier).stopLoading();
    } catch (e) {}
  }
}
