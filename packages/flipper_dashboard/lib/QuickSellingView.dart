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
import 'package:country_code_picker/country_code_picker.dart';

import 'package:flipper_dashboard/providers/customer_provider.dart';

class QuickSellingView extends StatefulHookConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController discountController;
  final TextEditingController deliveryNoteCotroller;
  final TextEditingController receivedAmountController;
  final TextEditingController customerPhoneNumberController;
  final TextEditingController paymentTypeController;
  final TextEditingController countryCodeController;

  const QuickSellingView({
    Key? key,
    required this.formKey,
    required this.discountController,
    required this.receivedAmountController,
    required this.deliveryNoteCotroller,
    required this.customerPhoneNumberController,
    required this.paymentTypeController,
    required this.countryCodeController,
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

  @override
  void initState() {
    super.initState();
    final initialCode = CountryCode.fromCountryCode("RW");
    widget.countryCodeController.text = initialCode.dialCode!;
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
      body: _buildScrollableContent(isOrdering, transactionAsyncValue, model),
      bottomNavigationBar: _buildBottomActionBar(transactionAsyncValue, model),
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
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
                          .withValues(alpha: 0.7),
                    ),
              ),
              Text(
                '#${transactionAsyncValue.value?.id.substring(0, 8) ?? "--------"}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withValues(alpha: 0.7),
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
    final transactionItemsAsync = ref.watch(transactionItemsStreamProvider(
        transactionId: transactionAsyncValue.value?.id ?? ""));
    return transactionItemsAsync.when(
      data: (items) {
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
      loading: () => SliverToBoxAdapter(
        child: Container(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: _buildErrorCard('Failed to load items', error.toString()),
      ),
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
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
                                  ?.withValues(alpha: 0.7),
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
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                    .withValues(alpha: 0.5),
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

  Widget _buildPaymentSection(AsyncValue<ITransaction> transactionAsyncValue) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Phone Number Field
          Text(
            'Customer Phone number',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 8),

          // Payment Methods Header
          Text(
            'Payment Methods',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 8),
          Text(
            '${ref.read(paymentMethodsProvider).length} method${ref.read(paymentMethodsProvider).length != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
          ),
          SizedBox(height: 16),

          // Payment Methods List
          if (ref.read(paymentMethodsProvider).isNotEmpty)
            Column(
              children: [
                // Header Row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Amount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Payment Method Rows
                for (int i = 0;
                    i < ref.read(paymentMethodsProvider).length;
                    i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _buildPaymentMethodRow(i,
                        transactionId: transactionAsyncValue.value?.id ?? ""),
                  ),
              ],
            ),

          // Add Payment Method Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _addPaymentMethod(
                  transactionId: transactionAsyncValue.value?.id ?? ""),
              icon: Icon(Icons.add, size: 18),
              label: Text('Add Payment Method'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
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
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.7),
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
                        .withValues(alpha: 0.8),
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
                        color: Colors.black.withValues(alpha: 0.08),
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
                              transactionId: transaction.id,
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
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          buildTransactionItemsTable(isOrdering),
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

  Widget _buildForm(bool isOrdering, {required String transactionId}) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Customer Information Section (only shown when not ordering)
          if (!isOrdering) ...[
            _buildReceivedAmountField(transactionId: transactionId),
            const SizedBox(height: 6.0),
            _customerNameField(),
            const SizedBox(height: 6.0),
          ],
          IntrinsicWidth(
            child: Row(
              children: [
                const SizedBox(height: 6.0),
                Expanded(
                    child: SizedBox(
                        width: 850, child: _buildCustomerPhoneField())),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          _buildPaymentRow(isOrdering, transactionId),
        ],
      ),
    );
  }

// Payment row with country code, phone field, and payment method
  Widget _buildPaymentRow(bool isOrdering, String transactionId) {
    return Row(
      children: [
        // Payment Method Field
        Expanded(
          child: _buildPaymentMethodField(transactionId: transactionId),
        ),
      ],
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
        labelText: null,
        hintText: 'Received Amount',
        controller: widget.receivedAmountController,
        keyboardType: TextInputType.number,
        maxLines: 1,
        minLines: 1,
        suffixIcon: Text(ProxyService.box.defaultCurrency(),
            style: const TextStyle(color: Colors.blue)),
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
    final customerNameController = ref.watch(customerNameControllerProvider);
    return StyledTextFormField.create(
      context: context,
      labelText: 'Customer  Name',
      hintText: 'Customer  Name',
      controller: customerNameController,
      keyboardType: TextInputType.text,
      maxLines: 3,
      minLines: 1,
      suffixIcon: Icon(FluentIcons.person_20_regular, color: Colors.blue),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return 'Please enter customer name';
        }
        return null;
      },
      onChanged: (value) {
        // Store the customer name with the exact key expected by rw_tax.dart
        ProxyService.box.writeString(key: 'customerName', value: value);

        // For debugging
        talker.info('Customer name set to: $value');
      },
    );
  }

  Widget _buildCustomerPhoneField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white,
      ),
      child: Row(
        children: [
          // Country code picker with consistent padding and height
          Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
            child: Center(
              child: CountryCodePicker(
                onChanged: (countryCode) {
                  widget.countryCodeController.text = countryCode.dialCode!;
                },
                initialSelection: 'RW',
                favorite: ['+250', 'RW'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                padding: EdgeInsets.zero,
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // No divider — we make it feel seamless
          Expanded(
            child: StyledTextFormField.create(
              context: context,
              labelText: null,
              hintText: 'Phone number',
              controller: widget.customerPhoneNumberController,
              keyboardType: TextInputType.number,
              maxLines: 1,
              minLines: 1,
              suffixIcon: Icon(FluentIcons.call_20_regular, color: Colors.blue),
              onChanged: (value) {
                ProxyService.box.writeString(
                  key: 'currentSaleCustomerPhoneNumber',
                  value: value,
                );
                if (ProxyService.box.customerTin() == null) {
                  ProxyService.box
                      .writeString(key: 'customerTin', value: value);
                }
              },
              validator: (String? value) {
                final customerTin = ProxyService.box.customerTin();

                if ((customerTin == null || customerTin.isEmpty) &&
                    (value == null || value.isEmpty)) {
                  ref.read(payButtonStateProvider.notifier).stopLoading();
                  return 'Phone number is required when customer TIN is not available';
                }

                if (value != null && value.isEmpty) {
                  final phoneExp = RegExp(r'^[1-9]\d{8}$');
                  if (!phoneExp.hasMatch(value)) {
                    ref.read(payButtonStateProvider.notifier).stopLoading();
                    return 'Please enter a valid 9-digit phone number without a leading zero';
                  }
                }

                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodField({required String transactionId}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            children: [
              Icon(
                Icons.payment,
                color: Colors.blue[600],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Payment Methods',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              // Summary badge
              if (ref.read(paymentMethodsProvider).isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${ref.read(paymentMethodsProvider).length} method${ref.read(paymentMethodsProvider).length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          if (ref.read(paymentMethodsProvider).isNotEmpty) ...[
            SizedBox(height: 16),
            // Payment methods list
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Column(
                children: [
                  // Header row
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 48), // Space for action button
                      ],
                    ),
                  ),
                  // Payment method rows
                  for (int i = 0;
                      i < ref.read(paymentMethodsProvider).length;
                      i++)
                    _buildPaymentMethodRow(i, transactionId: transactionId),
                ],
              ),
            ),
          ],

          SizedBox(height: 16),

          // Add button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () => _addPaymentMethod(transactionId: transactionId),
              icon: Icon(
                Icons.add,
                size: 18,
                color: Colors.blue[600],
              ),
              label: Text(
                'Add Payment Method',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[600],
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue[300]!, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blue[50],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(int index, {required String transactionId}) {
    final isLast = index == ref.read(paymentMethodsProvider).length - 1;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment method dropdown
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: ref.read(paymentMethodsProvider)[index].method,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                        items: paymentTypes.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                _getPaymentMethodIcon(value),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
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
                              ProxyService.box.writeString(
                                  key: 'paymentType', value: newValue);

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
                ],
              ),
            ),

            SizedBox(width: 16),

            // Amount field
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller:
                          ref.read(paymentMethodsProvider)[index].controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefix: Text(
                          '${ProxyService.box.defaultCurrency()} ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        ref.read(paymentMethodsProvider)[index].amount = amount;

                        if (index <
                            ref.read(paymentMethodsProvider).length - 1) {
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
                ],
              ),
            ),

            SizedBox(width: 12),

            // Remove button
            Container(
              width: 36,
              height: 36,
              child: index == 0
                  ? SizedBox() // Empty space for first item
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _removePaymentMethod(index,
                            transactionId: transactionId),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.red[300]!, width: 1),
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.red[50],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red[600],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

// Helper method to get payment method icons
  Widget _getPaymentMethodIcon(String paymentMethod) {
    IconData icon;
    Color color;

    switch (paymentMethod.toUpperCase()) {
      case 'CASH':
        icon = Icons.money;
        color = Colors.green[600]!;
        break;
      case 'CREDIT CARD':
        icon = Icons.credit_card;
        color = Colors.blue[600]!;
        break;
      case 'DEBIT&CREDIT CARD':
        icon = Icons.payment;
        color = Colors.purple[600]!;
        break;
      case 'MOBILE MONEY':
        icon = Icons.phone_android;
        color = Colors.orange[600]!;
        break;
      case 'BANK CHECK':
        icon = Icons.account_balance;
        color = Colors.indigo[600]!;
        break;
      default:
        icon = Icons.payment;
        color = Colors.grey[600]!;
    }

    return Icon(
      icon,
      size: 16,
      color: color,
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 8.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Total Amount Section
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  totalAfterDiscountAndShipping.toCurrencyFormatted(
                    symbol: ProxyService.box.defaultCurrency(),
                  ),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Transaction ID Section
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_outlined,
                  size: 18.0,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Transaction ID',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    displayId,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: displayId));
                      ProxyService.strategy.notify(
                        notification: AppNotification(
                          identifier: ProxyService.box.getBranchId(),
                          type: "internal",
                          completed: false,
                          message: "Transaction ID copied to clipboard",
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(6.0),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.content_copy_outlined,
                            size: 16.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'Copy',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
