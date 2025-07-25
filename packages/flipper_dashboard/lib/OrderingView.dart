// OrderingView
import 'dart:io';

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:flipper_dashboard/PaymentModeModal.dart';
import 'package:flipper_dashboard/PreviewSaleButton.dart';
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/dataMixer.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_dashboard/dialog_status.dart';

class OrderingView extends StatefulHookConsumerWidget {
  const OrderingView(this.transaction, {Key? key}) : super(key: key);
  final ITransaction transaction;
  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<OrderingView>
    with
        Datamixer,
        TransactionMixinOld,
        TextEditingControllersMixin,
        PreviewCartMixin,
        Refresh,
        SnackBarMixin {
  // Add loading state
  bool _isLoading = false;

  Future<void> _showLoadingModal({String message = 'Processing...'}) async {
    if (_isLoading) return; // Prevent multiple modals

    _isLoading = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false, // Prevent back button from closing
          child: Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _hideLoadingModal() async {
    if (_isLoading) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoading = false;
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Order Placed Successfully',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Your order has been processed and confirmed.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // ignore: unused_result
                ref.refresh(pendingTransactionStreamProvider(isExpense: true));
                Navigator.of(context).pop();
                showCustomSnackBar(context, 'Order Placed successfully');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(String errorMessage) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(
            'Failed to place order: ${errorMessage.length > 100 ? errorMessage.substring(0, 100) + '...' : errorMessage}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering()!;

    // Watch the transaction items directly without intermediate state
    final transactionItems = ref
        .watch(transactionItemsProvider(transactionId: widget.transaction.id));
    final orderCount = transactionItems.value?.length ?? 0;

    return ViewModelBuilder.nonReactive(
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: (Platform.isAndroid || Platform.isIOS)
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  title: Text(
                    isOrdering ? 'New Order' : 'Point of Sale',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  actions: [
                    if (!isOrdering)
                      IconButton(
                        icon: Icon(Icons.receipt_long_outlined),
                        onPressed: () => null,
                        tooltip: 'Transaction History',
                      ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () => null,
                      tooltip: 'More Options',
                    ),
                  ],
                )
              : null,
          body: _buildBody(ref, model: model),
          floatingActionButton: _buildFloatingActionButton(ref, isOrdering,
              orderCount: orderCount),
        );
      },
    );
  }

  Widget _buildBody(WidgetRef ref, {required ProductViewModel model}) {
    final items = ref.watch(productFromSupplier);
    final isPreviewing = ref.watch(previewingCart);

    return items.when(
      data: (variants) => variants.isEmpty
          ? _buildEmptyProductList()
          : _buildProductView(variants, isPreviewing, model: model),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('$error')),
    );
  }

  Widget _buildEmptyProductList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_rounded,
            size: 48,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Select a supplier to view products',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductView(List<Variant> variants, bool isPreviewing,
      {required ProductViewModel model}) {
    return isPreviewing
        ? _buildQuickSellingView()
        : _buildProductGrid(variants, model: model);
  }

  Widget _buildProductGrid(List<Variant> variants,
      {required ProductViewModel model}) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 2.0,
      ),
      itemCount: variants.length,
      itemBuilder: (context, index) {
        return buildVariantRow(
          forceRemoteUrl: true,
          context: context,
          model: model,
          variant: variants[index],
          isOrdering: true,
        );
      },
      shrinkWrap: true,
    );
  }

  Widget _buildQuickSellingView() {
    return QuickSellingView(
      deliveryNoteCotroller: deliveryNoteCotroller,
      formKey: formKey,
      discountController: discountController,
      receivedAmountController: receivedAmountController,
      customerPhoneNumberController: customerPhoneNumberController,
      customerNameController: customerNameController,
      paymentTypeController: paymentTypeController,
      countryCodeController: countryCodeController,
    );
  }

  Widget _buildFloatingActionButton(WidgetRef ref, bool isOrdering,
      {required int orderCount}) {
    return Consumer(
      builder: (context, ref, _) {
        final digitalPaymentEnabled =
            ref.watch(isDigialPaymentEnabledProvider).valueOrNull ?? false;

        return _buildPreviewSaleButton(
          ref,
          widget.transaction,
          orderCount,
          isOrdering,
          digitalPaymentEnabled,
        );
      },
    );
  }

  Widget _buildPreviewSaleButton(WidgetRef ref, ITransaction transaction,
      int orderCount, bool isOrdering, bool digitalPaymentEnabled) {
    final isPreviewing = ref.watch(previewingCart);
    final buttonText = isPreviewing
        ? "Place order"
        : orderCount > 0
            ? "Preview Cart ($orderCount)"
            : "Preview Cart";

    return Container(
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PreviewSaleButton(
        digitalPaymentEnabled: digitalPaymentEnabled,
        transactionId: transaction.id,
        wording: buttonText,
        mode: SellingMode.forOrdering,
        previewCart: () =>
            _handlePreviewCart(ref, orderCount, transaction, isOrdering),
      ),
    );
  }

  Future<void> _handlePreviewCart(WidgetRef ref, int orderCount,
      ITransaction transaction, bool isOrdering) async {
    if (ref.read(selectedSupplierProvider)!.serverId! ==
        ProxyService.box.getBranchId()!) {
      final dialogService = locator<DialogService>();
      dialogService.showCustomDialog(
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
      } else {
        await _showPaymentModeModal(ref, transaction, isOrdering);
      }
    } else {
      toast("The cart is empty");
    }
  }

  Future<void> _showPaymentModeModal(
      WidgetRef ref, ITransaction transaction, bool isOrdering) async {
    showPaymentModeModal(context, (provider) async {
      // NOTE: Do NOT pop the payment mode modal here!
      await _handleOrderPlacement(ref, transaction, isOrdering, provider);
    });
  }

  Future<void> _handleOrderPlacement(WidgetRef ref, ITransaction transaction,
      bool isOrdering, FinanceProvider financeOption) async {
    try {
      Navigator.of(context, rootNavigator: true).pop();
      // Show loading modal
      _showLoadingModal(message: 'Placing your order...');

      // Place the order
      await placeFinalOrder(
          transaction: transaction, financeOption: financeOption);

      // Send SMS notification
      final items = await ProxyService.strategy
          .transactionItems(transactionId: transaction.id);
      final itemCount = items.length;
      final totalAmount =
          items.fold(0.0, (sum, item) => sum + (item.qty * item.price));

      final orderDetails =
          'New order with $itemCount items, total: \$${totalAmount.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}';

      transaction.supplierId = ref.read(selectedSupplierProvider)!.serverId!;
      ProxyService.strategy.updateTransaction(
          transaction: transaction,
          supplierId: ref.read(selectedSupplierProvider)!.serverId!);
      final requesterBranchId = ProxyService.box.getBranchId()!;

      // Get requester's phone number from their branch config
      final requesterConfig =
          await SmsNotificationService.getBranchSmsConfig(requesterBranchId);
      final requesterPhone = requesterConfig?.smsPhoneNumber ?? '';

      // Send SMS to both requester and receiver
      await SmsNotificationService.sendOrderRequestNotification(
        receiverBranchId: ref.read(selectedSupplierProvider)!.serverId!,
        orderDetails: orderDetails,
        requesterPhone: requesterPhone,
      );

      // Refresh the transaction state
      // ignore: unused_result
      ref.refresh(pendingTransactionStreamProvider(isExpense: isOrdering));
      ref.read(previewingCart.notifier).state = false;

      // Create new transaction
      ITransaction? newTransaction = await ProxyService.strategy
          .manageTransaction(
              transactionType: TransactionType.purchase,
              isExpense: isOrdering,
              branchId: ProxyService.box.getBranchId()!);

      await refreshTransactionItems(transactionId: newTransaction!.id);
      // Hide loading modal and show success
      await _hideLoadingModal();
      await _showSuccessDialog();
    } catch (e) {
      // Hide loading modal and show error
      await _hideLoadingModal();
      await _showErrorDialog(e.toString());
      talker.error(e);
    }
  }
}
