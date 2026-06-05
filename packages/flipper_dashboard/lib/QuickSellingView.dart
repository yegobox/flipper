// ignore_for_file: unused_result
import 'dart:async';

import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_quick_cash_row.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/counter_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/posthog_service.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_ui/dialogs/SharedTicketDialog.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/digital_receipt_provider.dart';
import 'package:flipper_dashboard/widgets/checkout_error_recovery_screen.dart';
import 'package:flipper_dashboard/widgets/payment_methods_card.dart';
import 'package:flipper_dashboard/widgets/pos_cart_table_host.dart';
import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_models/helperModels/talker.dart' as tv_talk;

/// Compact label for correlating QuickSellingView with [pendingTransactionStream] logs.
String _qsvPendingLabel(AsyncValue<ITransaction> v) {
  if (v.isLoading) return 'loading';
  if (v.hasError) return 'error:${v.error}';
  if (!v.hasValue || v.value == null) return 'noValue';
  final t = v.value!;
  return 'id=${t.id} status=${t.status} invoiceNo=${t.invoiceNumber}';
}

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
        Refresh<QuickSellingView>,
        TransactionComputationMixin {
  double _amountToChange(double alreadyPaid) {
    return calculateAmountToChange(
      total: totalAfterDiscountAndShipping,
      paid: alreadyPaid + calculateTotalPaid(ref.watch(paymentMethodsProvider)),
    );
  }

  double _remainingBalance(double alreadyPaid) {
    return calculateRemainingBalance(
      total: totalAfterDiscountAndShipping,
      paid: alreadyPaid + calculateTotalPaid(ref.watch(paymentMethodsProvider)),
    );
  }

  /// Prior non-credit payments from payment records, when loaded; otherwise
  /// [ITransaction.cashReceived]. Must match [updatePaymentRemainder] /
  /// [standardizedPaymentInitialization] so change/balance are not double-counted.
  double _effectiveAlreadyPaid(ITransaction? transaction) {
    if (_cachedNonCreditPaid != null) return _cachedNonCreditPaid!;
    return transaction?.cashReceived ?? 0.0;
  }

  double get totalAfterDiscountAndShipping {
    return _calculateTotal();
  }

  double _calculateTotal({List<TransactionItem>? items}) {
    final isExpense = ProxyService.box.isOrdering() ?? false;
    final transaction = ref
        .read(pendingTransactionStreamProvider(isExpense: isExpense))
        .value;
    final discountPercent =
        double.tryParse(widget.discountController.text) ?? 0.0;

    return calculateTransactionTotal(
      items: items ?? internalTransactionItems,
      transaction: transaction,
      discountPercent: discountPercent,
    );
  }

  /// Skip hints while cart lines are still catching up to Ditto, and never pass
  /// client-only optimistic rows into sale completion.
  List<TransactionItem>? _transactionItemsHintForCompletion(
    String transactionId,
  ) {
    if (transactionId.isEmpty) return null;
    if (ref
        .read(optimisticCartProvider.notifier)
        .hasPendingFor(transactionId)) {
      return null;
    }
    final out = internalTransactionItems
        .where((i) => !OptimisticCartIds.isOptimistic(i.id))
        .toList();
    return out;
  }

  void _updateReceivedAmountIfNeeded(
    ITransaction transaction, {
    List<TransactionItem>? items,
  }) {
    if (!mounted) return;

    updatePaymentRemainder(
      ref: ref,
      transaction: transaction,
      total: _calculateTotal(items: items),
      overrideAlreadyPaid: _effectiveAlreadyPaid(transaction),
      receivedAmountController: widget.receivedAmountController,
      lastAutoSetAmount: _lastAutoSetAmount,
      onAutoSetAmountChanged: (amount) {
        _lastAutoSetAmount = amount;
      },
    );
  }

  Widget _buildInvoiceNumber() {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildInvoiceNumberRow(branchId: branchId)],
      ),
    );
  }

  /// Invoice number + current pending cart transaction id (mobile / desktop chip).
  ///
  /// **Note:** [highestCounterProvider] is the next invoice sequence, not the
  /// Ditto transaction `_id`. The **Txn ID** label is the live pending cart from
  /// [pendingTransactionStreamProvider].
  Widget _buildInvoiceNumberRow({required String branchId}) {
    final isExpense = ProxyService.box.isOrdering() ?? false;
    final pendingTxn = ref
        .watch(pendingTransactionStreamProvider(isExpense: isExpense))
        .value;
    final txnId = pendingTxn?.id;

    final highestInvoiceNumber = ref.watch(highestCounterProvider(branchId));
    final body = Theme.of(context).textTheme.bodyMedium;
    final bodyBold = body?.copyWith(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (txnId != null && txnId.isNotEmpty) ...[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: txnId));
              if (!mounted) return;
              showSuccessNotification(
                context,
                context.flipperL10n.transactionIdCopiedToClipboard,
                duration: const Duration(seconds: 2),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.flipperL10n.transactionIdShortLabel, style: body),
                Text(
                  txnId,
                  key: const Key('pending-transaction-id-text'),
                  style: bodyBold,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(context.flipperL10n.invoiceNumberLabel, style: body),
        Text(
          '$highestInvoiceNumber',
          key: const Key('invoice-number-text'),
          style: bodyBold,
        ),
      ],
    );
  }

  /// Desktop shared view: stays **above** the scrolling line items (not inside the list).
  /// Balance → Save ticket → Transaction ID → Invoice; toolbar styling + horizontal scroll if tight.
  Widget _buildTopBarCheckoutSummary({
    required double alreadyPaid,
    required AsyncValue<ITransaction> transactionAsyncValue,
    required CoreViewModel model,
  }) {
    final branchId = ProxyService.box.getBranchId();
    final transaction = transactionAsyncValue.asData?.value;

    final showSaveTicket =
        transaction != null &&
        ref.watch(posCartDisplayItemsProvider.select((l) => l.isNotEmpty));

    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: PosTokens.surface,
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          border: Border.all(color: PosTokens.line),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        ref.watch(posCartPaymentRefreshSignalProvider);
                        return _buildCompactAmountSummary(alreadyPaid);
                      },
                    ),
                    if (branchId != null) ...[
                      _checkoutToolbarDivider(),
                      _buildTopBarInvoiceChip(branchId: branchId),
                    ],
                    if (showSaveTicket) ...[
                      _checkoutToolbarDivider(),
                      _buildTopBarSaveTicketButton(
                        transaction: transaction,
                        model: model,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkoutToolbarDivider() {
    final outline = Theme.of(context).colorScheme.outline;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 22,
        child: VerticalDivider(
          width: 1,
          thickness: 1,
          color: outline.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  Widget _buildTopBarInvoiceChip({required String branchId}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: _buildInvoiceNumberRow(branchId: branchId),
    );
  }

  Widget _buildTopBarSaveTicketButton({
    required ITransaction transaction,
    required CoreViewModel model,
  }) {
    const accent = PosLayoutBreakpoints.posAccentBlue;

    return Tooltip(
      message: context.flipperL10n.parkSaleAsTicket,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showParkDialog(transaction, model),
          borderRadius: BorderRadius.circular(8),
          hoverColor: accent.withValues(alpha: 0.08),
          splashColor: accent.withValues(alpha: 0.14),
          highlightColor: accent.withValues(alpha: 0.06),
          child: Ink(
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.bookmark_16_filled, size: 15, color: accent),
                  const SizedBox(width: 6),
                  Text(
                    context.flipperL10n.saveTicketAction,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: accent,
                      letterSpacing: -0.1,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactAmountSummary(double alreadyPaid) {
    final remaining = _remainingBalance(alreadyPaid);
    final change = _amountToChange(alreadyPaid);
    final isRemaining = remaining > 0;
    final labelColor = isRemaining
        ? Colors.red.shade700
        : PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.9);
    final valueColor = isRemaining
        ? Colors.red.shade700
        : PosLayoutBreakpoints.posAccentBlue;

    return Container(
      height: PosTokens.chipHeight,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: isRemaining ? PosTokens.lossTint : PosTokens.blueTint,
        borderRadius: BorderRadius.circular(PosTokens.radiusSm),
        border: Border.all(
          color: isRemaining
              ? PosTokens.loss.withValues(alpha: 0.28)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isRemaining
                ? context.flipperL10n.remainingBalanceLabel
                : context.flipperL10n.amountToChangeLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            (isRemaining ? remaining : change).toCurrencyFormatted(
              symbol: ProxyService.box.defaultCurrency(),
            ),
            style: PosTokens.posMonoStyle(
              Theme.of(context).textTheme,
              fontSize: 13,
              color: valueColor,
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

    // Auto-focus on the received amount field after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _receivedAmountFocusNode.requestFocus();
    });

    // Listen for transaction completion flag
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    // Initial pre-fill for resumed transactions if they are already available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isExpense = ProxyService.box.isOrdering() ?? false;
      warmPosCartPendingTransactionCacheWidget(ref, isExpense: isExpense);
      // Warm pending cart so the first tap does not wait on Ditto txn resolution.
      ref.read(pendingTransactionStreamProvider(isExpense: isExpense).future);
      final transaction = ref
          .read(pendingTransactionStreamProvider(isExpense: isExpense))
          .value;
      if (transaction != null) {
        _prefillCustomerDetails(transaction);
        // Initial check for received amount update
        _updateReceivedAmountIfNeeded(transaction);
      }
    });

    // Listen to discount changes to trigger update
    widget.discountController.addListener(_onDiscountChanged);

    // Store initial branch ID to detect changes
    _currentBranchId = ProxyService.box.getBranchId();
  }

  void _onDiscountChanged() {
    final transaction = ref
        .read(
          pendingTransactionStreamProvider(
            isExpense: ProxyService.box.isOrdering() ?? false,
          ),
        )
        .value;
    if (transaction != null) {
      _updateReceivedAmountIfNeeded(transaction);
    }
  }

  /// Avoid redundant parent [updateTransaction] writes from customer fields
  /// while pay is loading or [startCompleteTransactionFlow] is active (same
  /// semantics as checkout via [CheckoutController]).
  bool _skipLiveCustomerCapellaPersistDuringSaleCompletion() {
    final payBusy = ref
        .read(payButtonStateProvider)
        .values
        .any((loading) => loading);
    final completing =
        ProxyService.box.readBool(key: 'transactionCompleting') ?? false;
    return payBusy || completing;
  }

  void _prefillCustomerDetails(ITransaction transaction) {
    if (transaction.customerName != null &&
        transaction.customerName!.isNotEmpty &&
        ref.read(customerNameControllerProvider).text.isEmpty) {
      talker.info('Pre-filling customer name: ${transaction.customerName}');
      ref.read(customerNameControllerProvider).text = transaction.customerName!;
      ProxyService.box.writeString(
        key: 'customerName',
        value: transaction.customerName!,
      );
    }

    if (transaction.customerPhone != null &&
        transaction.customerPhone!.isNotEmpty &&
        widget.customerPhoneNumberController.text.isEmpty) {
      talker.info('Pre-filling customer phone: ${transaction.customerPhone}');
      String phone = transaction.customerPhone!;
      // Handle country code if present (assuming +250 or 250)
      if (phone.startsWith('+')) {
        // Find dial code match if possible, or just strip commonly known ones
        if (phone.startsWith('+250')) {
          widget.countryCodeController.text = '+250';
          widget.customerPhoneNumberController.text = phone.substring(4);
        } else {
          // Fallback: strip + and first 3 digits as a guess or just put all in phone
          widget.customerPhoneNumberController.text = phone.substring(1);
        }
      } else if (phone.startsWith('250') && phone.length > 9) {
        widget.countryCodeController.text = '+250';
        widget.customerPhoneNumberController.text = phone.substring(3);
      } else {
        widget.customerPhoneNumberController.text = phone;
      }
      ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: widget.customerPhoneNumberController.text,
      );
    }

    // Payment initialization is deferred to the builder where items
    // are guaranteed to be loaded. Calling it here with an empty items
    // list would produce total=0 and zero-out the payment field.
  }

  // Controllers for quantity inputs per item (small device view)
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, double> _optimisticQtyByItemId = {};
  final Set<String> _optimisticallyDeletedItemIds = {};

  // _formKeyboardListenerFocusNode is non-late so KeyboardListener always has a node.
  late final FocusNode _receivedAmountFocusNode = FocusNode(
    onKeyEvent: _handleReceivedAmountKey,
  );
  late final FocusNode _customerNameFocusNode = FocusNode(
    onKeyEvent: _handleCustomerNameKey,
  );
  late final FocusNode _customerPhoneFocusNode = FocusNode(
    onKeyEvent: _handleCustomerPhoneKey,
  );
  late final FocusNode _deliveryNoteFocusNode = FocusNode(
    onKeyEvent: _handleDeliveryNoteKey,
  );

  /// Stable node for [KeyboardListener] — do not allocate a new [FocusNode] per build.
  final FocusNode _formKeyboardListenerFocusNode = FocusNode(
    debugLabel: 'quickSellFormShortcuts',
  );

  // Track last auto-set amount to detect manual changes
  double _lastAutoSetAmount = 0.0;

  // Track current branch ID to detect branch changes
  String? _currentBranchId;

  // Ensure payment initialization runs once when both transaction & items are ready
  String? _lastPaymentInitTransactionId;
  double? _cachedNonCreditPaid;

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
    widget.discountController.removeListener(_onDiscountChanged);
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    // Dispose FocusNodes
    _receivedAmountFocusNode.dispose();
    _customerNameFocusNode.dispose();
    _customerPhoneFocusNode.dispose();
    _deliveryNoteFocusNode.dispose();
    _formKeyboardListenerFocusNode.dispose();
    super.dispose();
  }

  Future<void> _onQuickSellComplete(ITransaction transaction) async {
    final startTime = transaction.createdAt ?? DateTime.now().toUtc();
    final endTime = DateTime.now().toUtc();
    final duration = endTime.difference(startTime).inSeconds;

    unawaited(
      PosthogService.instance.capture(
        'quick_sell_completed',
        properties: {
          'transaction_id': transaction.id,
          'branch_id': transaction.branchId!,
          'business_id': ProxyService.box.getBusinessId()!,
          'created_at': startTime.toIso8601String(),
          'completed_at': endTime.toIso8601String(),
          'duration_seconds': duration,
          'source': 'quick_selling_view',
        },
      ),
    );

    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    resetDigitalReceiptToggle(ref);

    if (!mounted) {
      return;
    }

    ref
        .read(optimisticCartProvider.notifier)
        .clearForTransaction(transaction.id);
    clearCachedPendingCartTransactionWidget(
      ref,
      isExpense: ProxyService.box.isOrdering() ?? false,
    );

    // Clear stale cart items for the completed transaction.
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transaction.id,
        branchId: ProxyService.box.getBranchId() ?? '0',
      ),
    );

    // Reset UI state for the next transaction to prevent stale data
    _lastAutoSetAmount = 0.0;
    _lastPaymentInitTransactionId = null;
    _cachedNonCreditPaid = null;
    ref.invalidate(paymentMethodsProvider);
    ref.read(optimisticOrderCountProvider.notifier).reset();
    widget.deliveryNoteCotroller.clear();
    widget.receivedAmountController.clear();
    widget.discountController.clear();
    widget.customerPhoneNumberController.clear();
    ref.read(customerNameControllerProvider).clear();

    ref.invalidate(
      pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false,
      ),
    );

    if (ref.read(previewingCart)) {
      ref.read(previewingCart.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOrdering = ProxyService.box.isOrdering() ?? false;
    // Cache sync lives on [CheckOut]; reconciliation is listen-only (no rebuild).
    ref.listen(posCartStreamReconciliationProvider, (_, __) {});

    // Listen for customer phone number changes from the provider and update the controller
    ref.listen<String?>(customerPhoneNumberProvider, (previous, next) {
      if (next != null && widget.customerPhoneNumberController.text != next) {
        widget.customerPhoneNumberController.text = next;
      }
    });

    // Listen to pending transaction for resumption pre-filling
    ref.listen<AsyncValue<ITransaction>>(
      pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false,
      ),
      (previous, next) {
        tv_talk.talker.info(
          'QuickSellingView.pendingTxn ref.listen '
          'prev=${previous == null ? 'null' : _qsvPendingLabel(previous)} '
          'next=${_qsvPendingLabel(next)}',
        );
        if (next.hasValue && next.value != null) {
          final isNewTransaction = previous?.value?.id != next.value!.id;
          _prefillCustomerDetails(next.value!);
          if (isNewTransaction) {
            resetDigitalReceiptToggle(ref);
            _cachedNonCreditPaid = null;
            _lastPaymentInitTransactionId = null;
            _updateReceivedAmountIfNeeded(next.value!);
          }
        }
      },
    );

    // Payment totals track [posCartDisplayItemsProvider] via [internalTransactionItems].
    ref.listen(posCartDisplayItemsProvider, (previous, next) {
      if (previous == next) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final transaction = ref
            .read(
              pendingTransactionStreamProvider(
                isExpense: ProxyService.box.isOrdering() ?? false,
              ),
            )
            .value;
        if (transaction != null) {
          _updateReceivedAmountIfNeeded(transaction, items: next);
        }
      });
    });

    // Check for branch changes and refresh transaction if needed
    final currentBranchId = ProxyService.box.getBranchId();
    if (_currentBranchId != currentBranchId && currentBranchId != null) {
      _currentBranchId = currentBranchId;
      // Invalidate pending transaction provider to fetch transaction for new branch
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.invalidate(pendingTransactionStreamProvider);
      });
    }

    // Listen to paymentMethodsProvider to update receivedAmountController for backward compatibility
    ref.listen(paymentMethodsProvider, (previous, next) {
      final totalPaid = next.fold<double>(0, (sum, p) => sum + p.amount);
      if (widget.receivedAmountController.text != totalPaid.toString()) {
        final textValue = totalPaid == 0.0 && next.isEmpty
            ? ""
            : totalPaid.toString();

        // Prevent infinite loops / conflicts if the update came from the controller
        if (double.tryParse(widget.receivedAmountController.text) !=
            totalPaid) {
          widget.receivedAmountController.text = textValue;
        }
      }
    });

    final transactionAsyncValue = ref.watch(
      pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false,
      ),
    );
    if (kDebugMode) {
      final readPending = ref.read(
        pendingTransactionStreamProvider(
          isExpense: ProxyService.box.isOrdering() ?? false,
        ),
      );
      tv_talk.talker.debug(
        'QuickSellingView.build pending '
        'watch=${_qsvPendingLabel(transactionAsyncValue)} '
        'read=${_qsvPendingLabel(readPending)}',
      );
    }

    if (transactionAsyncValue.hasError) {
      final error = transactionAsyncValue.error!;
      talker.error(
        'Error loading pending transaction',
        error,
        transactionAsyncValue.stackTrace,
      );
      final isExpense = ProxyService.box.isOrdering() ?? false;
      return CheckoutErrorRecoveryScreen(
        error: error,
        isExpense: isExpense,
        onRecovered: () async {
          ref.invalidate(
            pendingTransactionStreamProvider(isExpense: isExpense),
          );
        },
      );
    }

    final pendingTxnId = transactionAsyncValue.value?.id;
    if (pendingTxnId != null &&
        pendingTxnId.isNotEmpty &&
        ref.read(posCartDisplayItemsProvider).isNotEmpty &&
        _lastPaymentInitTransactionId != pendingTxnId) {
      _lastPaymentInitTransactionId = pendingTxnId;
      final txn = transactionAsyncValue.value!;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final nonCreditPaid = await fetchNonCreditPaid(txn.id);
        if (!mounted) return;
        setState(() => _cachedNonCreditPaid = nonCreditPaid);
        standardizedPaymentInitialization(
          ref: ref,
          transaction: txn,
          total: _calculateTotal(),
          overrideAlreadyPaid: nonCreditPaid,
        );
        _updateReceivedAmountIfNeeded(txn);
      });
    }

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        try {
          final alreadyPaidVal = _effectiveAlreadyPaid(
            transactionAsyncValue.value,
          );
          return context.isSmallDevice
              ? _buildSmallDeviceScaffold(
                  alreadyPaidVal,
                  isOrdering,
                  transactionAsyncValue,
                  model,
                )
              : _buildSharedView(
                  alreadyPaidVal,
                  transactionAsyncValue,
                  context.isSmallDevice,
                  isOrdering,
                  model,
                );
        } catch (e, stackTrace) {
          talker.error('Error in QuickSellingView builder', e, stackTrace);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text(context.flipperL10n.errorLoadingTransactionView),
                SizedBox(height: 8),
                Text(e.toString(), style: TextStyle(fontSize: 12)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Force refresh
                    ref.invalidate(pendingTransactionStreamProvider);
                  },
                  child: Text(context.flipperL10n.retry),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildSmallDeviceScaffold(
    double alreadyPaid,
    bool isOrdering,
    AsyncValue<ITransaction> transactionAsyncValue,
    CoreViewModel model,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildScrollableContent(
        alreadyPaid,
        isOrdering,
        transactionAsyncValue,
        model,
      ),
      bottomNavigationBar: _buildBottomActionBar(
        alreadyPaid,
        transactionAsyncValue,
        model,
      ),
    );
  }

  Widget _buildScrollableContent(
    double alreadyPaid,
    bool isOrdering,
    AsyncValue<ITransaction> transactionAsyncValue,
    CoreViewModel model,
  ) {
    return CustomScrollView(
      slivers: [
        // Transaction Summary Header
        SliverToBoxAdapter(
          child: _buildTransactionSummaryCard(transactionAsyncValue, model),
        ),

        SliverToBoxAdapter(child: _buildInvoiceNumber()),

        // Items Section
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            context.flipperL10n.items,
            Icons.shopping_basket_outlined,
            key: Key('items-section'),
          ),
        ),

        _buildMobileCartItemsSliver(transactionAsyncValue),

        // Customer & Payment Section
        if (!isOrdering) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context.flipperL10n.customer,
              Icons.person_outline,
            ),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context.flipperL10n.payment,
              Icons.payment_outlined,
            ),
          ),
        ],

        // Delivery Section for Orders
        if (isOrdering) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context.flipperL10n.delivery,
              Icons.local_shipping_outlined,
            ),
          ),
          SliverToBoxAdapter(child: _buildDeliverySection()),
        ],

        // Bottom spacing
        SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildTransactionSummaryCard(
    AsyncValue<ITransaction> transactionAsyncValue,
    CoreViewModel model,
  ) {
    return Semantics(
      label: context.flipperL10n.transactionSummary,
      hint: context.flipperL10n.transactionSummaryHint,
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
                  context.flipperL10n.totalAmount,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  getSumOfItems(
                    transactionId: transactionAsyncValue.value?.id,
                  ).toCurrencyFormatted(
                    symbol: ProxyService.box.defaultCurrency(),
                  ),
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
                  context.flipperL10n.transactionId,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  '#${transactionAsyncValue.value?.id.substring(0, 8) ?? "--------"}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            if (transactionAsyncValue.value?.isLoan == true) ...[
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.flipperL10n.amountPaid,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    (transactionAsyncValue.value?.cashReceived ?? 0.0)
                        .toCurrencyFormatted(
                          symbol: ProxyService.box.defaultCurrency(),
                        ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.flipperL10n.remainingBalance,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    (transactionAsyncValue.value?.remainingBalance ??
                            (transactionAsyncValue.value?.subTotal ?? 0.0))
                        .toCurrencyFormatted(
                          symbol: ProxyService.box.defaultCurrency(),
                        ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (transactionAsyncValue.value != null &&
                ref.watch(
                  posCartDisplayItemsProvider.select((l) => l.isNotEmpty),
                ))
              SaveTicketButton(
                onPressed: () =>
                    _showParkDialog(transactionAsyncValue.value!, model),
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

  Future<void> _deleteAllItems(
    AsyncValue<ITransaction> transactionAsyncValue,
  ) async {
    // Check if there's a partial payment
    if ((transactionAsyncValue.value?.cashReceived ?? 0) > 0) {
      showErrorNotification(
        context,
        context.flipperL10n.cannotDeletePartialPaymentItems,
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.flipperL10n.deleteAllItems),
        content: Text(context.flipperL10n.confirmRemoveAllTransactionItems),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.flipperL10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.flipperL10n.deleteAll),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      var items = <TransactionItem>[];
      try {
        items = await ref.read(
          transactionItemsStreamProvider(
            transactionId: transactionAsyncValue.value?.id ?? "",
            branchId: ProxyService.box.getBranchId()!,
          ).future,
        );

        setState(() {
          for (final item in items) {
            _optimisticallyDeletedItemIds.add(item.id);
            _optimisticQtyByItemId.remove(item.id);
          }
        });

        for (final item in items) {
          await ProxyService.getStrategy(
            Strategy.capella,
          ).updateTransactionItem(
            transactionItemId: item.id.toString(),
            active: false,
            ignoreForReport: false,
          );
        }

        if (mounted) {
          showSuccessNotification(
            context,
            context.flipperL10n.allItemsRemovedSuccessfully,
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            for (final item in items) {
              _optimisticallyDeletedItemIds.remove(item.id);
            }
          });
          showErrorNotification(
            context,
            context.flipperL10n.errorRemovingItems(e.toString()),
          );
        }
      }
    }
  }

  /// Phone scroll: cart lines inside [SliverToBoxAdapter] + [Consumer] so taps
  /// do not rebuild the whole [QuickSellingView] tree.
  Widget _buildMobileCartItemsSliver(
    AsyncValue<ITransaction> transactionAsyncValue,
  ) {
    return SliverToBoxAdapter(
      child: Consumer(
        builder: (context, ref, _) {
          final items = ref
              .watch(posCartDisplayItemsProvider)
              .where((item) => !_optimisticallyDeletedItemIds.contains(item.id))
              .toList();
          if (items.isEmpty) {
            return _buildEmptyStateCard(
              context.flipperL10n.noItemsAdded,
              context.flipperL10n.tapAddFirstItem,
              Icons.add_shopping_cart_outlined,
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.flipperL10n.cartItemCount(items.length),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton.icon(
                      onPressed:
                          (transactionAsyncValue.value?.cashReceived ?? 0) > 0
                          ? null
                          : () => _deleteAllItems(transactionAsyncValue),
                      icon: const Icon(Icons.delete_sweep, size: 18),
                      label: Text(context.flipperL10n.deleteAll),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        disabledForegroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              ...items.map(
                (item) => _buildModernItemCard(item, transactionAsyncValue),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModernItemCard(
    TransactionItem item,
    AsyncValue<ITransaction> transactionAsyncValue,
  ) {
    final displayQty = _displayQtyFor(item);
    final currency = ProxyService.box.defaultCurrency();
    final unitPrice = item.price.toCurrencyFormatted(symbol: currency);
    final subtotal = (item.price * displayQty).toCurrencyFormatted(
      symbol: currency,
    );
    return Semantics(
      label: context.flipperL10n.itemSemanticLabel(item.name),
      hint: context.flipperL10n.cartItemSemanticHint(
        _formatQty(displayQty),
        unitPrice,
        subtotal,
      ),
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
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.errorContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onErrorContainer,
                      minimumSize: Size(32, 32),
                    ),
                    tooltip: context.flipperL10n.removeItem,
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
                          context.flipperL10n.unitPrice,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                              ),
                        ),
                        Text(
                          item.price.toCurrencyFormatted(
                            symbol: ProxyService.box.defaultCurrency(),
                          ),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),

                  // Quantity controls
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          key: Key('quantity-remove-${item.id}'),
                          icon: Icon(Icons.remove, size: 16),
                          onPressed: displayQty > 1
                              ? () => _updateQuantity(
                                  item,
                                  (displayQty - 1).toInt(),
                                  transactionAsyncValue,
                                )
                              : null,
                          tooltip: context.flipperL10n.decreaseQuantityByOne,
                          style: IconButton.styleFrom(
                            minimumSize: Size(32, 32),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            _formatQty(displayQty),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          key: Key('quantity-add-${item.id}'),
                          icon: Icon(Icons.add, size: 16),
                          onPressed: () {
                            _updateQuantity(
                              item,
                              (displayQty + 1).toInt(),
                              transactionAsyncValue,
                            );
                          },
                          tooltip: context.flipperL10n.increaseQuantityByOne,
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
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.flipperL10n.subtotal,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      (item.price * displayQty).toCurrencyFormatted(
                        symbol: ProxyService.box.defaultCurrency(),
                      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                context.flipperL10n.deliveryDate,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Spacer(),
              Flexible(child: datePicker()),
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
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
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
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    double alreadyPaid,
    AsyncValue<ITransaction> transactionAsyncValue,
    CoreViewModel model,
  ) {
    if (ProxyService.box.isOrdering() ?? false) return SizedBox.shrink();

    return Builder(
      builder: (context) {
        final branchAsync = ref.watch(activeBranchProvider);
        return branchAsync.when(
          data: (branch) {
            return FutureBuilder<bool>(
              future:
                  ProxyService.strategy.isBranchEnableForPayment(
                        currentBranchId: branch.id,
                      )
                      as Future<bool>,
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
                        label: context
                            .flipperL10n
                            .transactionSummaryPaymentActions,
                        hint: context.flipperL10n.completeSaleTotalHint(
                          getSumOfItems(
                            transactionId: transactionAsyncValue.value?.id,
                          ).toCurrencyFormatted(
                            symbol: ProxyService.box.defaultCurrency(),
                          ),
                        ),
                        child: Consumer(
                          builder: (context, ref, _) {
                            ref.watch(posCartPaymentRefreshSignalProvider);
                            final paymentAmount = ref
                                .watch(paymentMethodsProvider)
                                .fold<double>(0, (sum, p) => sum + p.amount)
                                .toCurrencyFormatted(
                                  symbol: ProxyService.box.defaultCurrency(),
                                );
                            final dueAmount = (_calculateTotal() - alreadyPaid)
                                .toCurrencyFormatted(
                                  symbol: ProxyService.box.defaultCurrency(),
                                );
                            final payWording =
                                (_remainingBalance(alreadyPaid) > 0)
                                ? context.flipperL10n.recordPaymentWithAmount(
                                    paymentAmount,
                                  )
                                : context.flipperL10n.payWithAmount(dueAmount);
                            return PayableView(
                              transactionId:
                                  transactionAsyncValue.value?.id ?? "",
                              wording: payWording,
                              mode: SellingMode.forSelling,
                              completeTransaction:
                                  (
                                    immediateCompleteTransaction, [
                                    onPaymentConfirmed,
                                    onPaymentFailed,
                                  ]) async {
                                    talker.warning(
                                      "We are about to complete a sale",
                                    );
                                    return transactionAsyncValue.when(
                                      data: (ITransaction transaction) async {
                                        await ProxyService.box.writeBool(
                                          key: 'transactionCompleting',
                                          value: true,
                                        );
                                        try {
                                          await startCompleteTransactionFlow(
                                            immediateCompletion:
                                                immediateCompleteTransaction,
                                            completeTransaction: () async {
                                              await _onQuickSellComplete(
                                                transaction,
                                              );
                                            },
                                            transactionId: transaction.id,
                                            transactionHint: transaction,
                                            transactionItemsHint:
                                                _transactionItemsHintForCompletion(
                                                  transaction.id,
                                                ),
                                            paymentMethods: ref.watch(
                                              paymentMethodsProvider,
                                            ),
                                            onPaymentConfirmed:
                                                onPaymentConfirmed,
                                            onPaymentFailed: onPaymentFailed,
                                          );
                                        } catch (e) {
                                          await ProxyService.box.writeBool(
                                            key: 'transactionCompleting',
                                            value: false,
                                          );
                                          rethrow;
                                        }
                                        ref
                                                .read(previewingCart.notifier)
                                                .state =
                                            false;
                                        return true;
                                      },
                                      loading: () async => false,
                                      error: (error, stack) async => false,
                                    );
                                  },
                              model: model,
                              ticketHandler: () {
                                talker.warning(
                                  "We are about to complete a ticket",
                                );
                                transactionAsyncValue.whenData((
                                  ITransaction transaction,
                                ) {
                                  handleTicketNavigation(transaction);
                                });
                                ref.read(toggleProvider.notifier).state = false;
                              },
                              digitalPaymentEnabled: digitalPaymentEnabled,
                            );
                          },
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
            child: Center(
              child: Text(context.flipperL10n.errorWithValue(error.toString())),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(
    TransactionItem item,
    AsyncValue<ITransaction> transactionAsyncValue,
  ) {
    // Check if there's a partial payment
    if ((transactionAsyncValue.value?.cashReceived ?? 0) > 0) {
      showErrorNotification(
        context,
        context.flipperL10n.cannotDeletePartialPaymentItems,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.flipperL10n.removeItem),
        content: Text(
          context.flipperL10n.confirmRemoveItemFromTransaction(item.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.flipperL10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              setState(() {
                _optimisticallyDeletedItemIds.add(item.id);
                _optimisticQtyByItemId.remove(item.id);
              });
              try {
                await ProxyService.getStrategy(
                  Strategy.capella,
                ).updateTransactionItem(
                  transactionItemId: item.id.toString(),
                  active: false,
                  ignoreForReport: false,
                );
              } catch (e, stackTrace) {
                talker.error('Failed to remove item', e, stackTrace);
                if (mounted) {
                  setState(() => _optimisticallyDeletedItemIds.remove(item.id));
                  showErrorNotification(
                    context,
                    context.flipperL10n.failedToRemoveItem,
                  );
                }
              }
            },
            child: Text(context.flipperL10n.remove),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(
    TransactionItem item,
    int newQty,
    AsyncValue<ITransaction> transactionAsyncValue,
  ) async {
    // Check if there's a partial payment
    if ((transactionAsyncValue.value?.cashReceived ?? 0) > 0) {
      showErrorNotification(
        context,
        context.flipperL10n.cannotModifyPartialPaymentItems,
      );
      return;
    }

    final previousDisplayQty = _displayQtyFor(item);
    setState(() => _optimisticQtyByItemId[item.id] = newQty.toDouble());

    try {
      await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
        transactionItemId: item.id.toString(),
        ignoreForReport: false,
        qty: newQty.toDouble(),
      );
    } catch (e, stackTrace) {
      talker.error('Failed to update item quantity', e, stackTrace);
      if (mounted) {
        setState(() {
          if ((previousDisplayQty - item.qty.toDouble()).abs() < 0.0001) {
            _optimisticQtyByItemId.remove(item.id);
          } else {
            _optimisticQtyByItemId[item.id] = previousDisplayQty;
          }
        });
        showErrorNotification(
          context,
          context.flipperL10n.failedToUpdateItemQuantity,
        );
      }
    }
  }

  double _displayQtyFor(TransactionItem item) {
    final optimisticQty = _optimisticQtyByItemId[item.id];
    if (optimisticQty == null) return item.qty.toDouble();

    if ((item.qty.toDouble() - optimisticQty).abs() < 0.0001) {
      _optimisticQtyByItemId.remove(item.id);
      return item.qty.toDouble();
    }

    return optimisticQty;
  }

  String _formatQty(double qty) {
    return qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 2);
  }

  /// Cart column: checkout summary, items table, optional delivery.
  /// When [pinGrandTotal] is true, the table keeps Grand Total pinned at the
  /// bottom of this pane; parent must provide bounded height ([Expanded]).
  /// The top summary bar is outside the list [ListView] so it stays visible
  /// while line items scroll.
  Widget _buildSharedViewItemsPane({
    required double alreadyPaid,
    required AsyncValue<ITransaction> transactionAsyncValue,
    required CoreViewModel model,
    required bool isOrdering,
    required bool pinGrandTotal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopBarCheckoutSummary(
          alreadyPaid: alreadyPaid,
          transactionAsyncValue: transactionAsyncValue,
          model: model,
        ),
        const SizedBox(height: 6),
        if (!isOrdering) ...[
          const SearchInputWithDropdown(embeddedInCheckoutPane: true),
          const SizedBox(height: 8),
        ],
        if (pinGrandTotal)
          Expanded(
            child: Semantics(
              label: context.flipperL10n.transactionItemsList,
              hint: context.flipperL10n.transactionItemsListHint,
              child: PosCartTableHost(
                builder: (lines) => buildTransactionItemsTable(
                  isOrdering,
                  pinGrandTotal: true,
                  cartLines: lines,
                ),
              ),
            ),
          )
        else
          Semantics(
            label: context.flipperL10n.transactionItemsList,
            hint: context.flipperL10n.transactionItemsListHint,
            child: PosCartTableHost(
              builder: (lines) => buildTransactionItemsTable(
                isOrdering,
                pinGrandTotal: false,
                cartLines: lines,
              ),
            ),
          ),
        if (isOrdering) ...[
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(context.flipperL10n.deliveryDate),
                    datePicker(),
                  ],
                ),
                _deliveryNote(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSharedView(
    double alreadyPaid,
    AsyncValue<ITransaction> transactionAsyncValue,
    bool isSmallDevice,
    bool isOrdering,
    CoreViewModel model,
  ) {
    final pinnedBottomColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isOrdering) ...[
          _buildForm(
            isOrdering,
            transactionId: transactionAsyncValue.value?.id ?? "",
            alreadyPaid: alreadyPaid,
          ),
        ],
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Without a bounded height (e.g. some nested scroll contexts), keep a
        // single scrollable so layout does not assert on Expanded.
        if (!constraints.maxHeight.isFinite) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSharedViewItemsPane(
                  alreadyPaid: alreadyPaid,
                  transactionAsyncValue: transactionAsyncValue,
                  model: model,
                  isOrdering: isOrdering,
                  pinGrandTotal: false,
                ),
                if (!isOrdering) ...[
                  const SizedBox(height: 20),
                  _buildForm(
                    isOrdering,
                    transactionId: transactionAsyncValue.value?.id ?? "",
                    alreadyPaid: alreadyPaid,
                  ),
                ],
              ],
            ),
          );
        }

        // Phone landscape and other short panels: flex split leaves too little
        // height for toolbar + cart card (header, list, grand total) and form,
        // causing bottom overflow. One vertical scroll matches unbounded-height
        // behavior above.
        if (PosLayoutBreakpoints.useSingleScrollCheckoutPane(
          constraints.maxHeight,
        )) {
          if (isOrdering) {
            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(2.0),
                child: _buildSharedViewItemsPane(
                  alreadyPaid: alreadyPaid,
                  transactionAsyncValue: transactionAsyncValue,
                  model: model,
                  isOrdering: isOrdering,
                  pinGrandTotal: false,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSharedViewItemsPane(
                  alreadyPaid: alreadyPaid,
                  transactionAsyncValue: transactionAsyncValue,
                  model: model,
                  isOrdering: isOrdering,
                  pinGrandTotal: false,
                ),
                if (!isOrdering) ...[
                  const SizedBox(height: 12),
                  pinnedBottomColumn,
                ],
              ],
            ),
          );
        }

        // Split space so the items block never collapses when the form+footer
        // is tall (avoids flex overflow and keeps "No items yet" visible).
        // 3:2 gives the form + footer a bit more height than the old 2:1 split
        // so payment fields and customer inputs stay easier to see at once.
        // Upper pane: scrollable line items with Grand Total pinned above the
        // card bottom; lower pane: form scrolls independently.
        // Ordering mode has no payment form — use full height for cart + delivery.
        if (isOrdering) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: _buildSharedViewItemsPane(
                alreadyPaid: alreadyPaid,
                transactionAsyncValue: transactionAsyncValue,
                model: model,
                isOrdering: isOrdering,
                pinGrandTotal: true,
              ),
            ),
          );
        }

        final flex = PosLayoutBreakpoints.checkoutFlexForPaneHeight(
          constraints.maxHeight,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: flex.items,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: _buildSharedViewItemsPane(
                  alreadyPaid: alreadyPaid,
                  transactionAsyncValue: transactionAsyncValue,
                  model: model,
                  isOrdering: isOrdering,
                  pinGrandTotal: true,
                ),
              ),
            ),
            Expanded(
              flex: flex.form,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(2.0),
                child: pinnedBottomColumn,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildForm(
    bool isOrdering, {
    required String transactionId,
    required double alreadyPaid,
  }) {
    return KeyboardListener(
      focusNode: _formKeyboardListenerFocusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // Handle Ctrl+Enter or Cmd+Enter to complete sale
          if ((HardwareKeyboard.instance.isControlPressed ||
                  HardwareKeyboard.instance.isMetaPressed) &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            // Trigger complete sale action
            final transactionAsyncValue = ref.watch(
              pendingTransactionStreamProvider(
                isExpense: ProxyService.box.isOrdering() ?? false,
              ),
            );
            transactionAsyncValue.whenData((ITransaction transaction) {
              final branchId = ProxyService.box.getBranchId() ?? '0';
              final transactionItemsHint =
                  ref
                      .read(optimisticCartProvider.notifier)
                      .hasPendingFor(transaction.id)
                  ? null
                  : ref
                        .read(
                          transactionItemsStreamProvider(
                            transactionId: transaction.id,
                            branchId: branchId,
                          ),
                        )
                        .asData
                        ?.value;
              unawaited(() async {
                final loadingNotifier = ref.read(
                  payButtonStateProvider.notifier,
                );
                loadingNotifier.stopLoading();
                loadingNotifier.startLoading(ButtonType.pay);
                await ProxyService.box.writeBool(
                  key: 'transactionCompleting',
                  value: true,
                );
                try {
                  await startCompleteTransactionFlow(
                    immediateCompletion: false,
                    completeTransaction: () async {
                      await _onQuickSellComplete(transaction);
                    },
                    transactionId: transaction.id,
                    transactionHint: transaction,
                    transactionItemsHint: transactionItemsHint,
                    paymentMethods: ref.watch(paymentMethodsProvider),
                  );
                } catch (e, s) {
                  await ProxyService.box.writeBool(
                    key: 'transactionCompleting',
                    value: false,
                  );
                  if (mounted) {
                    loadingNotifier.stopLoading(ButtonType.pay);
                  }
                  tv_talk.talker.error(
                    'Keyboard-triggered sale completion failed',
                    e,
                    s,
                  );
                }
              }());
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
              _buildDigitalReceiptToggle(),
              _buildReceivedAmountField(
                transactionId: transactionId,
                alreadyPaid: alreadyPaid,
              ),
              const SizedBox(height: 10.0),
              Consumer(
                builder: (context, ref, _) {
                  ref.watch(posCartPaymentRefreshSignalProvider);
                  final total = _calculateTotal();
                  return PosQuickCashRow(
                    exactAmount: total,
                    enabled: total > 0,
                    onSelect: (amount) {
                      widget.receivedAmountController.text =
                          amount == amount.truncateToDouble()
                          ? amount.toStringAsFixed(0)
                          : amount.toStringAsFixed(2);
                      ProxyService.box.writeDouble(
                        key: 'getCashReceived',
                        value: amount,
                      );
                      setState(() {});
                    },
                  );
                },
              ),
              const SizedBox(height: 10.0),
              _customerNameField(),
              const SizedBox(height: 10.0),
            ],
            _buildCustomerPhoneField(),
            const SizedBox(height: 10.0),
            _buildPaymentRow(isOrdering, transactionId, alreadyPaid),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(
    bool isOrdering,
    String transactionId,
    double alreadyPaid,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(posCartPaymentRefreshSignalProvider);
        final finalPayable = (_calculateTotal() - alreadyPaid).clamp(
          0.0,
          double.infinity,
        );
        return Row(
          children: [
            Expanded(
              child: PaymentMethodsCard(
                transactionId: transactionId,
                totalPayable: finalPayable,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _deliveryNote() {
    return Semantics(
      label: context.flipperL10n.deliveryNoteSemantic,
      hint: context.flipperL10n.deliveryNoteHint,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: StyledTextFormField.create(
          context: context,
          labelText: context.flipperL10n.deliveryNote,
          hintText: context.flipperL10n.deliveryInstructionsHint,
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
        labelText: context.flipperL10n.discount,
        labelStyle: const TextStyle(color: Colors.black),
        suffixIcon: Icon(
          FluentIcons.shopping_bag_percent_24_regular,
          color: Colors.blue,
        ),
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
          return context.flipperL10n.pleaseEnterValidNumber;
        }

        /// this is a percentage not amount as this percenage will be applicable
        /// to the whole item on cart, currently we only support discount on whole total
        if (number < 0 || number > 100) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return context.flipperL10n.discountRangeError;
        }
        return null;
      },
    );
  }

  Widget _buildDigitalReceiptToggle() {
    final smsEnabledAsync = ref.watch(branchSmsNotificationsEnabledProvider);
    return smsEnabledAsync.when(
      data: (smsEnabled) {
        if (!smsEnabled) return const SizedBox.shrink();
        final useDigital = ref.watch(digitalReceiptToggleProvider);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: SwitchListTile.adaptive(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Text(
                context.flipperL10n.digitalReceiptTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              subtitle: Text(
                context.flipperL10n.digitalReceiptSmsSubtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              value: useDigital,
              activeTrackColor: PosLayoutBreakpoints.posAccentBlue,
              onChanged: (value) {
                ref.read(digitalReceiptToggleProvider.notifier).state = value;
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildReceivedAmountField({
    required String transactionId,
    required double alreadyPaid,
  }) {
    // Auto-update received amount when total changes (unless user manually changed it)
    // Auto-update logic moved to _updateReceivedAmountIfNeeded and triggered via listeners

    return Semantics(
      label: context.flipperL10n.receivedAmountInCurrency(
        ProxyService.box.defaultCurrency(),
      ),
      hint: context.flipperL10n.receivedAmountHint,
      child: StyledTextFormField.create(
        context: context,
        labelText: null,
        hintText: context.flipperL10n.receivedAmount,
        controller: widget.receivedAmountController,
        focusNode: _receivedAmountFocusNode,
        keyboardType: TextInputType.number,
        maxLines: 1,
        minLines: 1,
        key: const Key('received-amount-field'), // Add this line
        outlineColor: PosTokens.blue,
        borderRadius: PosTokens.radiusMd,
        fillColor: PosTokens.surface,
        style: PosTokens.posMonoStyle(
          Theme.of(context).textTheme,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: Container(
          margin: const EdgeInsetsDirectional.only(end: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            ProxyService.box.defaultCurrency(),
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        onChanged: (value) => setState(() {
          final receivedAmount = double.tryParse(value);
          ProxyService.box.writeDouble(
            key: 'getCashReceived',
            value: receivedAmount ?? 0.0,
          );

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
            return context.flipperL10n.pleaseEnterReceivedAmount;
          }
          final number = double.tryParse(value);
          if (number == null) {
            ref.read(payButtonStateProvider.notifier).stopLoading();
            return context.flipperL10n.pleaseEnterValidNumber;
          }
          // We allow partial payments, so this is valid.
          return null;
        },
      ),
    );
  }

  Widget _customerNameField() {
    final customerNameController = ref.watch(customerNameControllerProvider);
    return Semantics(
      label: context.flipperL10n.customerName,
      hint: context.flipperL10n.customerNameHint,
      child: StyledTextFormField.create(
        context: context,
        labelText: null,
        hintText: context.flipperL10n.customerName,
        controller: customerNameController,
        focusNode: _customerNameFocusNode,
        keyboardType: TextInputType.text,
        maxLines: 3,
        minLines: 1,
        outlineColor: PosLayoutBreakpoints.posAccentBlue,
        borderRadius: 8,
        fillColor: Colors.white,
        hintColor: PosLayoutBreakpoints.posAccentBlue.withValues(alpha: 0.82),
        suffixIcon: Icon(
          FluentIcons.person_20_regular,
          color: PosLayoutBreakpoints.posAccentBlue,
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            ref.read(payButtonStateProvider.notifier).stopLoading();
            return context.flipperL10n.pleaseEnterCustomerName;
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
            if (_skipLiveCustomerCapellaPersistDuringSaleCompletion()) {
              return;
            }
            final transactionAsync = ref.read(
              pendingTransactionStreamProvider(
                isExpense: ProxyService.box.isOrdering() ?? false,
              ),
            );
            final transaction = transactionAsync.asData?.value;
            if (transaction != null && transaction.id.isNotEmpty) {
              unawaited(
                ProxyService.getStrategy(Strategy.capella).updateTransaction(
                  transaction: transaction,
                  customerName: value,
                ),
              );
            }
          } catch (e, s) {
            talker.error(
              'Failed to update transaction with customer name',
              e,
              s,
            );
          }
        },
      ),
    );
  }

  Widget _buildCustomerPhoneField() {
    return Semantics(
      label: context.flipperL10n.customerPhoneNumber,
      hint: context.flipperL10n.customerPhoneNumberHint,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
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
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: PosLayoutBreakpoints.posAccentBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  child: CountryCodePicker(
                    onChanged: (countryCode) {
                      widget.countryCodeController.text = countryCode.dialCode!;
                    },
                    initialSelection: 'RW',
                    favorite: const ['+250', 'RW'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      color: PosLayoutBreakpoints.posAccentBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // No divider — we make it feel seamless
            Expanded(
              child: StyledTextFormField.create(
                context: context,
                labelText: null,
                hintText: context.flipperL10n.phoneNumber,
                controller: widget.customerPhoneNumberController,
                focusNode: _customerPhoneFocusNode,
                keyboardType: TextInputType.number,
                maxLines: 1,
                minLines: 1,
                outlineColor: PosLayoutBreakpoints.posAccentBlue,
                borderRadius: 8,
                outlineBorderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                fillColor: Colors.white,
                hintColor: const Color(0xFF6B7280),
                suffixIcon: Icon(
                  FluentIcons.call_20_regular,
                  color: PosLayoutBreakpoints.posAccentBlue,
                ),
                onChanged: (value) async {
                  // Store the customer phone number
                  ProxyService.box.writeString(
                    key: 'currentSaleCustomerPhoneNumber',
                    value: value,
                  );

                  // For debugging
                  talker.info('Customer phone set to: $value');

                  // Persist to the pending transaction if one exists. Avoid creating a
                  // new transaction by only updating when there is an existing pending
                  // transaction instance available from the provider.
                  try {
                    if (_skipLiveCustomerCapellaPersistDuringSaleCompletion()) {
                      return;
                    }
                    final transactionAsync = ref.read(
                      pendingTransactionStreamProvider(
                        isExpense: ProxyService.box.isOrdering() ?? false,
                      ),
                    );
                    final transaction = transactionAsync.asData?.value;
                    if (transaction != null && transaction.id.isNotEmpty) {
                      unawaited(
                        ProxyService.getStrategy(
                          Strategy.capella,
                        ).updateTransaction(
                          transaction: transaction,
                          customerPhone:
                              widget.countryCodeController.text + value,
                        ),
                      );
                    }
                  } catch (e, s) {
                    talker.error(
                      'Failed to update transaction with customer phone',
                      e,
                      s,
                    );
                  }
                },
                validator: (String? value) {
                  final customerTin = ProxyService.box.customerTin();

                  if ((customerTin == null || customerTin.isEmpty) &&
                      (value == null || value.isEmpty)) {
                    ref.read(payButtonStateProvider.notifier).stopLoading();
                    return context.flipperL10n.phoneRequiredWhenTinMissing;
                  }

                  if (value != null && value.isEmpty) {
                    final phoneExp = RegExp(r'^[1-9]\d{8}$');
                    if (!phoneExp.hasMatch(value)) {
                      ref.read(payButtonStateProvider.notifier).stopLoading();
                      return context.flipperL10n.invalidNumber;
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

  Future<void> _showParkDialog(
    ITransaction transaction,
    CoreViewModel model,
  ) async {
    await showSharedTicketDialog(context: context, transaction: transaction);
  }
}
