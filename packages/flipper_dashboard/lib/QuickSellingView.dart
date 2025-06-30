// ignore_for_file: unused_result
import 'dart:async';
import 'package:feather_icons/feather_icons.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:stacked/stacked.dart';

class QuickSellingView extends StatefulHookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController discountController;
  final TextEditingController deliveryNoteCotroller;
  final TextEditingController receivedAmountController;
  final TextEditingController customerPhoneNumberController;
  final TextEditingController customerNameController;
  final TextEditingController paymentTypeController;

  const QuickSellingView({
    Key? key,
    required this.formKey,
    required this.discountController,
    required this.receivedAmountController,
    required this.deliveryNoteCotroller,
    required this.customerPhoneNumberController,
    required this.customerNameController,
    required this.paymentTypeController,
  }) : super(key: key);

  @override
  _QuickSellingViewState createState() => _QuickSellingViewState();
}

class _QuickSellingViewState extends ConsumerState<QuickSellingView>
    with
        TransactionMixinOld,
        TextEditingControllersMixin,
        PreviewCartMixin,
        TransactionItemTable,
        DateCoreWidget {
  double get totalAfterDiscountAndShipping {
    final discountPercent =
        double.tryParse(widget.discountController.text) ?? 0.0;
    final discountAmount = (grandTotal * discountPercent) / 100;
    return grandTotal - discountAmount;
  }

  bool _transactionCompleting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        updatePaymentAmounts(transactionId: "");
      } catch (e) {}
    });

    // Listen for transaction completion flag
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);
  }

  // Controllers for quantity inputs per item (small device view)
  final Map<String, TextEditingController> _quantityControllers = {};

  @override
  void dispose() {
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void updatePaymentAmounts({required String transactionId}) {
    if (ref.read(paymentMethodsProvider).isEmpty) return;

    double remainingAmount = totalAfterDiscountAndShipping;
    final payments = ref.read(paymentMethodsProvider);

    // Handle the first payment method
    if (payments.isNotEmpty) {
      double firstAmount = double.tryParse(payments[0].controller.text) ?? 0.0;
      remainingAmount -= firstAmount;
      payments[0].amount = firstAmount;
    }

    // Distribute remaining amount among other payment methods
    for (int i = 1; i < payments.length; i++) {
      if (i == payments.length - 1) {
        // Last payment method gets the remaining amount
        payments[i].amount = remainingAmount;
        if (remainingAmount > 0) {
          payments[i].controller.text = remainingAmount.toStringAsFixed(2);
        }
      } else {
        // Keep the entered amount for middle payment methods
        double enteredAmount =
            double.tryParse(payments[i].controller.text) ?? 0.0;
        payments[i].amount = enteredAmount;
        remainingAmount -= enteredAmount;
      }

      // Update the payment method in the provider
      ref.read(paymentMethodsProvider.notifier).updatePaymentMethod(
            transactionId: transactionId,
            i,
            Payment(
              amount: payments[i].amount,
              method: payments[i].method,
            ),
          );
    }
  }

  Future<void> _onQuickSellComplete(ITransaction transaction) async {
    final startTime = transaction.createdAt!;
    final endTime = DateTime.now().toUtc();
    final duration = endTime.difference(startTime).inSeconds;
    PosthogService.instance.capture('quick_sell_completed', properties: {
      'transaction_id': transaction.id,
      'branch_id': transaction.branchId!,
      'business_id': ProxyService.box.getBusinessId()!,
      'created_at': startTime.toIso8601String(),
      'completed_at': endTime.toIso8601String(),
      'duration_seconds': duration,
      'source': 'quick_selling_view',
    });
    // Place your existing completion logic here...
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;

    final transactionAsyncValue = ref.watch(pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false));

    Future.microtask(() {
      ref.refresh(pendingTransactionStreamProvider(
          isExpense: ProxyService.box.isOrdering() ?? false));
    });

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          if (transactionAsyncValue.hasValue &&
              transactionAsyncValue.value != null) {
            final transactionId = transactionAsyncValue.value!.id;
            Future.microtask(() {
              ref.refresh(
                  transactionItemsStreamProvider(transactionId: transactionId));
            });
            final transactionItemsAsync = ref.watch(
                transactionItemsStreamProvider(transactionId: transactionId));
            internalTransactionItems = transactionItemsAsync.value ?? [];
          } else {
            internalTransactionItems = [];
          }
          return context.isSmallDevice
              ? _buildSmallDeviceScaffold(
                  isOrdering, transactionAsyncValue, model)
              : _buildSharedView(
                  transactionAsyncValue, context.isSmallDevice, isOrdering);
        });
  }

  Widget _buildSmallDeviceScaffold(bool isOrdering,
      AsyncValue<ITransaction> transactionAsyncValue, CoreViewModel model) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildCompactAppBar(isOrdering),
      body: _buildScrollableContent(isOrdering, transactionAsyncValue, model),
      bottomNavigationBar: _buildBottomActionBar(transactionAsyncValue, model),
    );
  }

  PreferredSizeWidget _buildCompactAppBar(bool isOrdering) {
    return AppBar(
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
            onPressed: () => _showTransactionHistory(),
            tooltip: 'Transaction History',
          ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () => _showOptionsMenu(),
          tooltip: 'More Options',
        ),
      ],
    );
  }

  Widget _buildScrollableContent(bool isOrdering,
      AsyncValue<ITransaction> transactionAsyncValue, CoreViewModel model) {
    return CustomScrollView(
      slivers: [
        // Transaction Summary Header
        SliverToBoxAdapter(
          child: _buildTransactionSummaryCard(transactionAsyncValue),
        ),

        // Items Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Items', Icons.shopping_basket_outlined),
        ),

        _buildItemsList(transactionAsyncValue),

        // Customer & Payment Section
        if (!isOrdering) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader('Customer', Icons.person_outline),
          ),
          SliverToBoxAdapter(
            child: _buildCustomerSection(),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Payment', Icons.payment_outlined),
          ),
          SliverToBoxAdapter(
            child: _buildPaymentSection(transactionAsyncValue),
          ),
        ],

        // Delivery Section for Orders
        if (isOrdering) ...[
          SliverToBoxAdapter(
            child:
                _buildSectionHeader('Delivery', Icons.local_shipping_outlined),
          ),
          SliverToBoxAdapter(
            child: _buildDeliverySection(),
          ),
        ],

        // Bottom spacing
        SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildTransactionSummaryCard(
      AsyncValue<ITransaction> transactionAsyncValue) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
              Text(
                getSumOfItems(transactionId: transactionAsyncValue.value?.id)
                    .toCurrencyFormatted(
                        symbol: ProxyService.box.defaultCurrency()),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transaction ID',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.7),
                    ),
              ),
              Text(
                '#${transactionAsyncValue.value?.id?.substring(0, 8) ?? "--------"}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(AsyncValue<ITransaction> transactionAsyncValue) {
    return StreamBuilder<List<TransactionItem>>(
      stream: ref.watch(transactionItemsStreamProvider(
              transactionId: transactionAsyncValue.value?.id ?? "")
          .stream),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: _buildErrorCard(
                'Failed to load items', snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Container(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final items = snapshot.data!;

        if (items.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyStateCard(
              'No items added',
              'Tap the + button to add your first item',
              Icons.add_shopping_cart_outlined,
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                _buildModernItemCard(items[index], transactionAsyncValue),
            childCount: items.length,
          ),
        );
      },
    );
  }

  Widget _buildModernItemCard(
      TransactionItem item, AsyncValue<ITransaction> transactionAsyncValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item header with name and delete
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 20),
                  onPressed: () =>
                      _showDeleteConfirmation(item, transactionAsyncValue),
                  style: IconButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onErrorContainer,
                    minimumSize: Size(32, 32),
                  ),
                  tooltip: 'Remove item',
                ),
              ],
            ),

            SizedBox(height: 12),

            // Price and quantity controls
            Row(
              children: [
                // Price info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit Price',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withOpacity(0.7),
                            ),
                      ),
                      Text(
                        item.price.toCurrencyFormatted(
                            symbol: ProxyService.box.defaultCurrency()),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),

                // Quantity controls
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, size: 16),
                        onPressed: item.qty > 1
                            ? () => _updateQuantity(item,
                                (item.qty - 1).toInt(), transactionAsyncValue)
                            : null,
                        style: IconButton.styleFrom(
                          minimumSize: Size(32, 32),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.qty}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, size: 16),
                        onPressed: () => _updateQuantity(item,
                            (item.qty + 1).toInt(), transactionAsyncValue),
                        style: IconButton.styleFrom(
                          minimumSize: Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            // Total for this item
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    (item.price * item.qty).toCurrencyFormatted(
                        symbol: ProxyService.box.defaultCurrency()),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _customerNameField(),
          SizedBox(height: 16),
          _buildCustomerPhoneField(),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(AsyncValue<ITransaction> transactionAsyncValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _buildReceivedAmountField(
              transactionId: transactionAsyncValue.value?.id ?? ""),
          SizedBox(height: 16),
          _buildPaymentMethodField(
              transactionId: transactionAsyncValue.value?.id ?? ""),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                "Delivery Date",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              Expanded(child: datePicker()),
            ],
          ),
          SizedBox(height: 16),
          _deliveryNote(),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String title, String error) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
          ),
          if (error.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onErrorContainer
                        .withOpacity(0.8),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
      AsyncValue<ITransaction> transactionAsyncValue, CoreViewModel model) {
    if (ProxyService.box.isOrdering() ?? false) return SizedBox.shrink();

    return Builder(
      builder: (context) {
        final branchAsync = ref.watch(activeBranchProvider);
        return branchAsync.when(
          data: (branch) {
            return FutureBuilder<bool>(
              future: ProxyService.strategy.isBranchEnableForPayment(
                  currentBranchId: branch.id) as Future<bool>,
              builder: (context, snapshot) {
                final digitalPaymentEnabled = snapshot.data ?? false;
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: PayableView(
                        transactionId: transactionAsyncValue.value?.id ?? "",
                        wording:
                            "Complete Sale • ${getSumOfItems(transactionId: transactionAsyncValue.value?.id).toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}",
                        mode: SellingMode.forSelling,
                        completeTransaction: (immediateCompleteTransaction) {
                          talker.warning("We are about to complete a sale");
                          transactionAsyncValue
                              .whenData((ITransaction transaction) {
                            startCompleteTransactionFlow(
                              immediateCompletion: immediateCompleteTransaction,
                              completeTransaction: () async {
                                await _onQuickSellComplete(transaction);
                              },
                              transaction: transaction,
                              paymentMethods: ref.watch(paymentMethodsProvider),
                            );
                          });
                          ref.read(previewingCart.notifier).state = false;
                        },
                        model: model,
                        ticketHandler: () {
                          talker.warning("We are about to complete a ticket");
                          transactionAsyncValue
                              .whenData((ITransaction transaction) {
                            handleTicketNavigation(transaction);
                          });
                          ref.read(toggleProvider.notifier).state = false;
                        },
                        digitalPaymentEnabled: digitalPaymentEnabled,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => Container(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Container(
            height: 80,
            child: Center(child: Text('Error: $error')),
          ),
        );
      },
    );
  }

// Helper methods that would need implementation
  void _showTransactionHistory() {
    // Implementation for showing transaction history
  }

  void _showOptionsMenu() {
    // Implementation for showing options menu
  }

  void _showDeleteConfirmation(
      TransactionItem item, AsyncValue<ITransaction> transactionAsyncValue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Item'),
        content: Text(
            'Are you sure you want to remove "${item.name}" from this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ProxyService.strategy.updateTransactionItem(
                transactionItemId: item.id.toString(),
                active: false,
                ignoreForReport: false,
              );
              ref.invalidate(
                transactionItemsStreamProvider(
                  transactionId: transactionAsyncValue.value?.id ?? "",
                ),
              );
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(TransactionItem item, int newQty,
      AsyncValue<ITransaction> transactionAsyncValue) async {
    await ProxyService.strategy.updateTransactionItem(
      transactionItemId: item.id.toString(),
      ignoreForReport: false,
      qty: newQty.toDouble(),
    );
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transactionAsyncValue.value?.id ?? "",
      ),
    );
  }

  Widget _buildSharedView(AsyncValue<ITransaction> transactionAsyncValue,
      bool isSmallDevice, bool isOrdering) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildTransactionItemsTable(isOrdering),
          SizedBox(height: 20),
          _buildTotalRow(),
          SizedBox(height: 20),
          if (!isOrdering)
            _buildForm(isOrdering,
                transactionId: transactionAsyncValue.value?.id ?? ""),
          SizedBox(height: 20),
          if (isOrdering) ...[
            Column(
              children: [
                Row(
                  children: [
                    Text("Delivery Date"),
                    datePicker(),
                  ],
                ),
                _deliveryNote()
              ],
            ),
          ],
          _buildFooter(transactionAsyncValue),
        ],
      ),
    );
  }

  Widget _buildTotalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Grand Total: ${grandTotal.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildForm(bool isOrdering, {required String transactionId}) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            children: [
              if (!isOrdering) ...[
                Expanded(
                    child: _buildReceivedAmountField(
                        transactionId: transactionId)),
              ],
            ],
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              if (!isOrdering) Expanded(child: _customerNameField()),
            ],
          ),
          SizedBox(height: 6.0),
          Row(
            children: [
              if (!isOrdering) Expanded(child: _buildCustomerPhoneField()),
              SizedBox(width: 16.0),
              Expanded(
                  child:
                      _buildPaymentMethodField(transactionId: transactionId)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deliveryNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: StyledTextFormField.create(
        context: context,
        labelText: 'Delivery Note',
        hintText: 'Enter any special instructions for delivery',
        controller: widget.deliveryNoteCotroller,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        minLines: 1,
        prefixIcon: Icons.local_shipping,
        onChanged: (value) {
          setState(() {});
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }
          return null;
        },
      ),
    );
  }

  // ignore: unused_element
  Widget _buildDiscountField() {
    return TextFormField(
      controller: widget.discountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Discount',
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(FluentIcons.shopping_bag_percent_24_regular,
            color: Colors.blue),
        border: OutlineInputBorder(),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),
      onChanged: (value) async =>
          await ProxyService.box.writeString(key: 'discountRate', value: value),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return null;
        }
        final number = double.tryParse(value);
        if (number == null) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return 'Please enter a valid number';
        }

        /// this is a percentage not amount as this percenage will be applicable
        /// to the whole item on cart, currently we only support discount on whole total
        if (number < 0 || number > 100) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return 'Discount must be between 0 and 100';
        }
        return null;
      },
    );
  }

  Widget _buildReceivedAmountField({required String transactionId}) {
    return StyledTextFormField.create(
        context: context,
        labelText: 'Received Amount',
        hintText: 'Received Amount',
        controller: widget.receivedAmountController,
        keyboardType: TextInputType.number,
        maxLines: 3,
        minLines: 1,
        suffixIcon: Icon(FeatherIcons.dollarSign, color: Colors.blue),
        onChanged: (value) => setState(() {
              final receivedAmount = double.tryParse(value);
              ProxyService.box.writeDouble(
                  key: 'getCashReceived', value: receivedAmount ?? 0.0);

              if (receivedAmount != null) {
                ref.read(paymentMethodsProvider)[0].controller.text = value;
                if (ref.read(paymentMethodsProvider).length == 1) {
                  /// if it is one payment method just swap
                  ref.read(paymentMethodsProvider.notifier).addPaymentMethod(
                      Payment(
                          amount: receivedAmount,
                          method: ref.read(paymentMethodsProvider)[0].method));

                  talker.warning(ref.read(paymentMethodsProvider).first.amount);
                  talker.warning(ref.read(paymentMethodsProvider).first.method);
                  return;
                }
                for (Payment payment in ref.read(paymentMethodsProvider)) {
                  ref.read(paymentMethodsProvider.notifier).addPaymentMethod(
                      Payment(amount: receivedAmount, method: payment.method));
                }
                updatePaymentAmounts(transactionId: transactionId);
              } // Update payment amounts after received amount changes
            }),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            ref.read(payButtonStateProvider.notifier).stopLoading();
            return 'Please enter received amount';
          }
          final number = double.tryParse(value);
          if (number == null) {
            ref.read(payButtonStateProvider.notifier).stopLoading();
            return 'Please enter a valid number';
          }
          if (number < totalAfterDiscountAndShipping) {
            ref.read(payButtonStateProvider.notifier).stopLoading();
            return 'You are receiving less than the total due';
          }
          return null;
        });
  }

  Widget _customerNameField() {
    return StyledTextFormField.create(
      context: context,
      labelText: 'Customer  Name',
      hintText: 'Customer  Name',
      controller: widget.customerNameController,
      keyboardType: TextInputType.text,
      maxLines: 3,
      minLines: 1,
      suffixIcon: Icon(FluentIcons.person_20_regular, color: Colors.blue),
      onChanged: (value) {
        // Store the customer name with the exact key expected by rw_tax.dart
        ProxyService.box.writeString(key: 'customerName', value: value);

        // For debugging
        talker.info('Customer name set to: $value');
      },
    );
  }

  Widget _buildCustomerPhoneField() {
    return StyledTextFormField.create(
      context: context,
      labelText: 'Customer Phone number',
      hintText: 'Customer Phone number',
      controller: widget.customerPhoneNumberController,
      keyboardType: TextInputType.number,
      maxLines: 3,
      minLines: 1,
      suffixIcon: Icon(FluentIcons.call_20_regular, color: Colors.blue),
      onChanged: (value) {
        ProxyService.box
            .writeString(key: 'currentSaleCustomerPhoneNumber', value: value);
        // Only update customerTin if it's not already set
        if (ProxyService.box.customerTin() == null) {
          ProxyService.box.writeString(key: 'customerTin', value: value);
        }
      },
      validator: (String? value) {
        final customerTin = ProxyService.box.customerTin();

        // If customer TIN is not set, phone number becomes mandatory
        if ((customerTin == null || customerTin.isEmpty) &&
            (value == null || value.isEmpty)) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return 'Phone number is required when customer TIN is not available';
        }

        // If phone number is provided, validate its format
        if (value != null && value.isNotEmpty) {
          final phoneExp = RegExp(r'^[1-9]\d{8}$');
          if (!phoneExp.hasMatch(value)) {
            ref.read(payButtonStateProvider.notifier).stopLoading();
            return 'Please enter a valid 9-digit phone number without a leading zero';
          }
        }

        return null;
      },
    );
  }

  Widget _buildPaymentMethodField({required String transactionId}) {
    return Column(
      children: [
        for (int i = 0; i < ref.read(paymentMethodsProvider).length; i++)
          _buildPaymentMethodRow(i, transactionId: transactionId),
        SizedBox(height: 10),
        FlipperButton(
          height: 30,
          onPressed: () => _addPaymentMethod(transactionId: transactionId),
          textColor: Colors.black,
          text: 'Add Payment Method',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodRow(int index, {required String transactionId}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRect(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: ref.read(paymentMethodsProvider)[index].method,
                    items: paymentTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          final payment =
                              ref.read(paymentMethodsProvider)[index];
                          payment.method = newValue;
                          ref
                              .read(paymentMethodsProvider.notifier)
                              .updatePaymentMethod(
                                  index,
                                  Payment(
                                    amount: payment.amount,
                                    method: newValue,
                                  ),
                                  transactionId: transactionId);

                          // Save the payment method in ProxyService.box
                          ProxyService.box
                              .writeString(key: 'paymentType', value: newValue);

                          // Map payment methods to their corresponding codes for reference:
                          // Cash: 01
                          // Credit Card: 02
                          // CASH/CREDIT: 03
                          // BANK CHECK: 04
                          // DEBIT&CREDIT CARD: 05
                          // MOBILE MONEY: 06
                          // OTHER: 07
                          final paymentMethodCode =
                              ProxyService.box.paymentMethodCode(newValue);
                          ProxyService.box.writeString(
                              key: 'pmtTyCd', value: paymentMethodCode);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 10, height: 5),
            Expanded(
              flex: 3,
              child: StyledTextFormField.create(
                context: context,
                labelText: 'Amount',
                hintText: 'Enter Amount',
                controller: ref.read(paymentMethodsProvider)[index].controller,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
                onChanged: (value) {
                  final amount = double.tryParse(value) ?? 0.0;
                  ref.read(paymentMethodsProvider)[index].amount = amount;

                  // Only update other amounts if this isn't the last payment method
                  if (index < ref.read(paymentMethodsProvider).length - 1) {
                    updatePaymentAmounts(transactionId: transactionId);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: index == 0
                  ? null
                  : () =>
                      _removePaymentMethod(index, transactionId: transactionId),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void _addPaymentMethod({required String transactionId}) {
    setState(() {
      ref
          .read(paymentMethodsProvider)
          .add(Payment(amount: 0.0, method: 'CASH'));
      ref.read(paymentMethodsProvider).last.controller.addListener(
          () => updatePaymentAmounts(transactionId: transactionId));

      updatePaymentAmounts(transactionId: transactionId);
    });
  }

  void _removePaymentMethod(int index, {required String transactionId}) {
    setState(() {
      ref.read(paymentMethodsProvider)[index];
      ref.read(paymentMethodsProvider.notifier).removePaymentMethod(index);
      updatePaymentAmounts(transactionId: transactionId);
    });
  }

  String? validatePaymentMethods() {
    double total = ref
        .read(paymentMethodsProvider)
        .fold(0, (sum, method) => sum + method.amount);
    if ((total - totalAfterDiscountAndShipping).abs() > 0.01) {
      return 'Total received amount does not match the total due';
    }
    return null;
  }

  Widget _buildFooter(AsyncValue<ITransaction> transactionAsyncValue) {
    final transaction = transactionAsyncValue.asData?.value;
    final displayId =
        (transaction != null) ? transaction.id.toString() : 'Invalid';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        children: [
          Text(
            'Total - Discount: ${totalAfterDiscountAndShipping.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            softWrap: true,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: displayId));
                  ProxyService.strategy.notify(
                    notification: AppNotification(
                      identifier: ProxyService.box.getBranchId(),
                      type: "internal",
                      completed: false,
                      message: "TransactionId copied to keypad",
                    ),
                  );
                },
                constraints: BoxConstraints.tightFor(width: 40),
              ),
              Flexible(
                child: Text(
                  "ID: $displayId",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
