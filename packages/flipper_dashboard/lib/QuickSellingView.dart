// ignore_for_file: unused_result
import 'dart:async';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/counter_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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
import 'package:flipper_dashboard/widgets/payment_methods_card.dart';

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
        DateCoreWidget,
        Refresh<QuickSellingView> {
  /// Returns the amount to change to the customer (received - totalAfterDiscountAndShipping), or 0 if negative/invalid.
  double _amountToChange() {
    final received =
        double.tryParse(widget.receivedAmountController.text) ?? 0.0;
    final change = received - totalAfterDiscountAndShipping;
    return change > 0 ? change : 0.0;
  }

  double get totalAfterDiscountAndShipping {
    final discountPercent =
        double.tryParse(widget.discountController.text) ?? 0.0;
    final discountAmount = (grandTotal * discountPercent) / 100;
    return grandTotal - discountAmount;
  }

  Widget _buildInvoiceNumber() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return SizedBox.shrink();
    }
    final highestInvoiceNumber = ref.watch(highestCounterProvider(branchId));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Invoice No: ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '${highestInvoiceNumber}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final initialCode = CountryCode.fromCountryCode("RW");
    widget.countryCodeController.text = initialCode.dialCode!;

    // Initialize FocusNodes with Enter-key handlers for precise traversal
    _receivedAmountFocusNode = FocusNode(onKeyEvent: _handleReceivedAmountKey);
    _customerNameFocusNode = FocusNode(onKeyEvent: _handleCustomerNameKey);
    _customerPhoneFocusNode = FocusNode(onKeyEvent: _handleCustomerPhoneKey);
    _deliveryNoteFocusNode = FocusNode(onKeyEvent: _handleDeliveryNoteKey);

    // Auto-focus on the received amount field after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _receivedAmountFocusNode.requestFocus();
    });

    // Listen for transaction completion flag
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    // Store initial branch ID to detect changes
    _currentBranchId = ProxyService.box.getBranchId();
  }

  // Controllers for quantity inputs per item (small device view)
  final Map<String, TextEditingController> _quantityControllers = {};

  // FocusNodes for accessibility and keyboard navigation
  late final FocusNode _receivedAmountFocusNode;
  late final FocusNode _customerNameFocusNode;
  late final FocusNode _customerPhoneFocusNode;
  late final FocusNode _deliveryNoteFocusNode;

  // Track last auto-set amount to detect manual changes
  double _lastAutoSetAmount = 0.0;

  // Track current branch ID to detect branch changes
  int? _currentBranchId;

  bool _isPlainEnter(KeyEvent event) {
    if (event is! KeyDownEvent) {
      return false;
    }
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter &&
        key != LogicalKeyboardKey.numpadEnter) {
      return false;
    }
    final hardware = HardwareKeyboard.instance;
    return !hardware.isControlPressed &&
        !hardware.isMetaPressed &&
        !hardware.isAltPressed &&
        !hardware.isShiftPressed;
  }

  KeyEventResult _handleReceivedAmountKey(FocusNode node, KeyEvent event) {
    if (_isPlainEnter(event)) {
      _customerNameFocusNode.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleCustomerNameKey(FocusNode node, KeyEvent event) {
    if (_isPlainEnter(event)) {
      _customerPhoneFocusNode.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleCustomerPhoneKey(FocusNode node, KeyEvent event) {
    // Tab: move to payment method
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.tab) {
      // Find the first focusable payment method field and request focus
      // This assumes PaymentMethodsCard exposes a static method or global key for focus
      // For now, try to move focus to the next focusable widget
      FocusScope.of(context).nextFocus();
      return KeyEventResult.handled;
    }
    if (_isPlainEnter(event)) {
      final isOrdering = ProxyService.box.isOrdering() ?? false;
      if (isOrdering) {
        _deliveryNoteFocusNode.requestFocus();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleDeliveryNoteKey(FocusNode node, KeyEvent event) {
    if (_isPlainEnter(event)) {
      // Keep focus here; do not propagate to prevent unintended navigation
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    // Dispose FocusNodes
    _receivedAmountFocusNode.dispose();
    _customerNameFocusNode.dispose();
    _customerPhoneFocusNode.dispose();
    _deliveryNoteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onQuickSellComplete(ITransaction transaction) async {
    final startTime = transaction.createdAt ?? DateTime.now().toUtc();
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

    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    if (!mounted) {
      return;
    }

    ref.read(payButtonStateProvider.notifier).stopLoading();

    // Clear stale cart items for the completed transaction.
    ref.refresh(
      transactionItemsStreamProvider(transactionId: transaction.id),
    );

    await newTransaction(
        typeOfThisTransactionIsExpense: ProxyService.box.isOrdering() ?? false);

    // Refresh the pending transaction provider to pick up the new transaction
    ref.refresh(pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false));

    if (ref.read(previewingCart)) {
      ref.read(previewingCart.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;

    // Check for branch changes and refresh transaction if needed
    final currentBranchId = ProxyService.box.getBranchId();
    if (_currentBranchId != currentBranchId && currentBranchId != null) {
      _currentBranchId = currentBranchId;
      // Invalidate pending transaction provider to fetch transaction for new branch
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(pendingTransactionStreamProvider);
      });
    }

    final transactionAsyncValue = ref.watch(pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false));

    // Handle transaction async value error state early
    if (transactionAsyncValue.hasError) {
      final errorMessage =
          transactionAsyncValue.error?.toString() ?? 'Unknown error';

      // If it's a branch selection error, just show loading while we wait for branch to be set
      if (errorMessage.contains('No default branch selected')) {
        // Auto-retry after a short delay
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            ref.invalidate(pendingTransactionStreamProvider);
          }
        });

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      talker.error('Error loading pending transaction',
          transactionAsyncValue.error, transactionAsyncValue.stackTrace);

      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text('Error loading transaction'),
              SizedBox(height: 8),
              Text(
                errorMessage,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(pendingTransactionStreamProvider);
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return ViewModelBuilder.reactive(
        viewModelBuilder: () => CoreViewModel(),
        builder: (context, model, child) {
          try {
            if (transactionAsyncValue.hasValue &&
                transactionAsyncValue.value != null &&
                transactionAsyncValue.value!.id.isNotEmpty) {
              final transactionId = transactionAsyncValue.value!.id;
              final transactionItemsAsync = ref.watch(
                  transactionItemsStreamProvider(transactionId: transactionId));

              // Properly handle AsyncValue states instead of accessing .value directly
              internalTransactionItems = transactionItemsAsync.when(
                data: (items) => items,
                loading: () => [],
                error: (err, stack) {
                  talker.error('Error loading transaction items', err, stack);
                  return [];
                },
              );
            } else {
              internalTransactionItems = [];
            }
            return context.isSmallDevice
                ? _buildSmallDeviceScaffold(
                    isOrdering, transactionAsyncValue, model)
                : _buildSharedView(
                    transactionAsyncValue, context.isSmallDevice, isOrdering);
          } catch (e, stackTrace) {
            talker.error('Error in QuickSellingView builder', e, stackTrace);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading transaction view'),
                  SizedBox(height: 8),
                  Text(e.toString(), style: TextStyle(fontSize: 12)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Force refresh
                      ref.invalidate(pendingTransactionStreamProvider);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
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

        SliverToBoxAdapter(
          child: _buildInvoiceNumber(),
        ),

        // Items Section
        SliverToBoxAdapter(
          child: _buildSectionHeader('Items', Icons.shopping_basket_outlined,
              key: Key('items-section')),
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
    return Semantics(
      label: 'Transaction summary',
      hint: 'Shows the total amount and transaction ID for the current sale',
      child: Container(
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
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {Key? key}) {
    return Container(
      key: key, // Add this
      padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(
            icon,
            key: Key('${title.toLowerCase()}-section-icon'), // Add key to icon
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 8),
          Text(
            title,
            key: Key('${title.toLowerCase()}-section-text'), // Add key to text
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
    return Semantics(
      label: 'Item: ${item.name}',
      hint:
          'Quantity: ${item.qty}, Unit price: ${item.price.toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}, Subtotal: ${(item.price * item.qty).toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
      child: Container(
        key: Key('item-card-${item.id}'), // Add a key to the item card
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
                    key: Key('delete-item-${item.id}'), // Add this key
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
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                          key: Key('quantity-remove-${item.id}'),
                          icon: Icon(Icons.remove, size: 16),
                          onPressed: item.qty > 1
                              ? () => _updateQuantity(item,
                                  (item.qty - 1).toInt(), transactionAsyncValue)
                              : null,
                          tooltip: 'Decrease quantity by 1',
                          style: IconButton.styleFrom(
                            minimumSize: Size(32, 32),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.qty}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        IconButton(
                          key: Key('quantity-add-${item.id}'),
                          icon: Icon(Icons.add, size: 16),
                          onPressed: () {
                            _updateQuantity(item, (item.qty + 1).toInt(),
                                transactionAsyncValue);
                          },
                          tooltip: 'Increase quantity by 1',
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
                      child: Semantics(
                        label: 'Transaction summary and payment actions',
                        hint:
                            'Complete sale with total amount ${getSumOfItems(transactionId: transactionAsyncValue.value?.id).toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}',
                        child: PayableView(
                          transactionId: transactionAsyncValue.value?.id ?? "",
                          wording:
                              "Complete Sale • ${getSumOfItems(transactionId: transactionAsyncValue.value?.id).toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency())}",
                          mode: SellingMode.forSelling,
                          completeTransaction: (immediateCompleteTransaction,
                              [onPaymentConfirmed, onPaymentFailed]) async {
                            talker.warning("We are about to complete a sale");
                            return transactionAsyncValue.when(
                              data: (ITransaction transaction) async {
                                await startCompleteTransactionFlow(
                                  immediateCompletion:
                                      immediateCompleteTransaction,
                                  completeTransaction: () async {
                                    await _onQuickSellComplete(transaction);
                                  },
                                  transactionId: transaction.id,
                                  paymentMethods:
                                      ref.watch(paymentMethodsProvider),
                                  onPaymentConfirmed: onPaymentConfirmed,
                                  onPaymentFailed: onPaymentFailed,
                                );
                                ref.read(previewingCart.notifier).state = false;
                                return true;
                              },
                              loading: () async => false,
                              error: (error, stack) async => false,
                            );
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
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          _buildInvoiceNumber(),
          SizedBox(height: 20),
          Semantics(
            label: 'Transaction items list',
            hint:
                'List of items in the current transaction with quantities and prices',
            child: buildTransactionItemsTable(isOrdering),
          ),
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
    ));
  }

  Widget _buildForm(bool isOrdering, {required String transactionId}) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // Handle Ctrl+Enter or Cmd+Enter to complete sale
          if ((HardwareKeyboard.instance.isControlPressed ||
                  HardwareKeyboard.instance.isMetaPressed) &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Trigger complete sale action
            final transactionAsyncValue = ref.watch(
                pendingTransactionStreamProvider(
                    isExpense: ProxyService.box.isOrdering() ?? false));
            transactionAsyncValue.whenData((ITransaction transaction) {
              startCompleteTransactionFlow(
                immediateCompletion: false,
                completeTransaction: () async {
                  await _onQuickSellComplete(transaction);
                },
                transactionId: transaction.id,
                paymentMethods: ref.watch(paymentMethodsProvider),
              );
            });
          }
          // Handle Enter key for focus traversal (without Ctrl/Cmd modifiers)
          else if (event.logicalKey == LogicalKeyboardKey.enter &&
              !HardwareKeyboard.instance.isControlPressed &&
              !HardwareKeyboard.instance.isMetaPressed) {
            // Determine which field currently has focus and move to the next one
            if (_receivedAmountFocusNode.hasFocus && !isOrdering) {
              _customerNameFocusNode.requestFocus();
            } else if (_customerNameFocusNode.hasFocus && !isOrdering) {
              _customerPhoneFocusNode.requestFocus();
            } else if (_customerPhoneFocusNode.hasFocus) {
              if (isOrdering) {
                _deliveryNoteFocusNode.requestFocus();
              }
              // If not ordering, stay on phone field or move to payment section
            } else if (_deliveryNoteFocusNode.hasFocus && isOrdering) {
              // Stay on delivery note field or move to complete sale
            }
          }
        }
      },
      child: Form(
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
      ),
    );
  }

// Payment row with country code, phone field, and payment method
  Widget _buildPaymentRow(bool isOrdering, String transactionId) {
    return Row(
      children: [
        // Payment Method Field
        Expanded(
          child: PaymentMethodsCard(
            transactionId: transactionId,
            totalPayable: totalAfterDiscountAndShipping,
          ),
        ),
      ],
    );
  }

  Widget _deliveryNote() {
    return Semantics(
      label: 'Delivery note',
      hint: 'Add any special instructions for delivery',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: StyledTextFormField.create(
          context: context,
          labelText: 'Delivery Note',
          hintText: 'Enter any special instructions for delivery',
          controller: widget.deliveryNoteCotroller,
          focusNode: _deliveryNoteFocusNode,
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
    // Auto-update received amount when total changes (unless user manually changed it)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.receivedAmountController.text.isEmpty ||
          widget.receivedAmountController.text ==
              _lastAutoSetAmount.toString()) {
        widget.receivedAmountController.text =
            totalAfterDiscountAndShipping.toString();
        _lastAutoSetAmount = totalAfterDiscountAndShipping;
      }
    });

    return Semantics(
      label: 'Received amount in ${ProxyService.box.defaultCurrency()}',
      hint: 'Enter the amount received from the customer',
      child: StyledTextFormField.create(
          context: context,
          labelText: null,
          hintText: 'Received Amount',
          controller: widget.receivedAmountController,
          focusNode: _receivedAmountFocusNode,
          keyboardType: TextInputType.number,
          maxLines: 1,
          minLines: 1,
          key: const Key('received-amount-field'), // Add this line
          suffixIcon: Text(ProxyService.box.defaultCurrency(),
              style: const TextStyle(color: Colors.blue)),
          onChanged: (value) => setState(() {
                final receivedAmount = double.tryParse(value);
                ProxyService.box.writeDouble(
                    key: 'getCashReceived', value: receivedAmount ?? 0.0);

                if (receivedAmount != null) {
                  final payments = ref.read(paymentMethodsProvider);
                  if (payments.isNotEmpty) {
                    // Update the first payment method using the notifier
                    ref
                        .read(paymentMethodsProvider.notifier)
                        .updatePaymentMethod(
                          0,
                          Payment(
                            amount: receivedAmount,
                            method: payments[0].method,
                            id: payments[0].id,
                            controller: payments[0].controller,
                          ),
                          transactionId: transactionId,
                        );
                    // Also update the controller text
                    payments[0].controller.text = receivedAmount.toString();
                  }
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
          }),
    );
  }

  Widget _customerNameField() {
    final customerNameController = ref.watch(customerNameControllerProvider);
    return Semantics(
      label: 'Customer name',
      hint: 'Enter the full name of the customer',
      child: StyledTextFormField.create(
        context: context,
        labelText: 'Customer  Name',
        hintText: 'Customer  Name',
        controller: customerNameController,
        focusNode: _customerNameFocusNode,
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
        onChanged: (value) async {
          // Store the customer name with the exact key expected by rw_tax.dart
          ProxyService.box.writeString(key: 'customerName', value: value);

          // For debugging
          talker.info('Customer name set to: $value');

          // Persist to the pending transaction if one exists. Avoid creating a
          // new transaction by only updating when there is an existing pending
          // transaction instance available from the provider.
          try {
            final transactionAsync = ref.read(pendingTransactionStreamProvider(
                isExpense: ProxyService.box.isOrdering() ?? false));
            final transaction = transactionAsync.asData?.value;
            if (transaction != null && transaction.id.isNotEmpty) {
              unawaited(ProxyService.strategy.updateTransaction(
                transaction: transaction,
                customerName: value,
              ));
            }
          } catch (e, s) {
            talker.error(
                'Failed to update transaction with customer name', e, s);
          }
        },
      ),
    );
  }

  Widget _buildCustomerPhoneField() {
    return Semantics(
      label: 'Customer phone number',
      hint:
          'Enter the customer\'s phone number for contact and billing purposes',
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(6),
          color:
              Theme.of(context).inputDecorationTheme.fillColor ?? Colors.white,
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
                focusNode: _customerPhoneFocusNode,
                keyboardType: TextInputType.number,
                maxLines: 1,
                minLines: 1,
                suffixIcon:
                    Icon(FluentIcons.call_20_regular, color: Colors.blue),
                onChanged: (value) async {
                  ProxyService.box.writeString(
                    key: 'currentSaleCustomerPhoneNumber',
                    value: value,
                  );
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
                      return 'Invalid Number';
                    }
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
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
                  'Amount to Change',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  _amountToChange().toCurrencyFormatted(
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
                      child: Tooltip(
                        message: 'Copy transaction ID to clipboard',
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
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
