// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/mpos_momo_phone_provider.dart';
import 'package:flipper_dashboard/screens/mpos_success_screen.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/utils/resume_transaction_helper.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_checkout_footer.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_checkout_header.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_customer_section.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_customer_sheet.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_item_line.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_payment_section.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_section_label.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_totals_card.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart' as tv_talk;
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/park_transaction_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldProvider;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_ui/dialogs/SharedTicketDialog.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:supabase_models/brick/models/customer.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

enum ChargeButtonState { initial, waitingForPayment, printingReceipt, failed }

/// Full-screen mobile checkout ([design_handoff_mobile_pos/mpos-checkout.jsx]).
class MobileCheckoutScreen extends ConsumerStatefulWidget {
  const MobileCheckoutScreen({
    super.key,
    required this.transaction,
    required this.doneDelete,
    required this.onCharge,
  });

  final ITransaction transaction;
  final Function doneDelete;
  final Function onCharge;

  @override
  ConsumerState<MobileCheckoutScreen> createState() =>
      _MobileCheckoutScreenState();
}

class _MobileCheckoutScreenState extends ConsumerState<MobileCheckoutScreen>
    with TransactionComputationMixin {
  ProviderContainer? _container;
  ChargeButtonState _chargeState = ChargeButtonState.initial;
  bool _isImmediateCompletion = false;
  String? _lastTransactionId;
  final Map<String, double> _optimisticQtyByItemId = {};
  final Set<String> _optimisticallyDeletedItemIds = {};
  bool _isClearingCustomer = false;
  double _cachedNonCreditPaid = 0.0;
  bool _sendToTillBusy = false;
  bool _backToNewSaleBusy = false;

  String get _transactionId => widget.transaction.id;

  String get _branchId {
    final fromTxn = widget.transaction.branchId?.trim();
    if (fromTxn != null && fromTxn.isNotEmpty) return fromTxn;
    return ProxyService.box.getBranchId() ?? '0';
  }

  @override
  void dispose() {
    final container = _container;
    if (container != null) {
      clearPinnedPosCartTransactionContainer(container);
      // Leaving the dedicated checkout ends any till-settling session so the
      // operator's next cart is not scoped to the collected ticket
      // (posCartDisplayItemsProvider keys off settlingTillTicketProvider).
      container.read(settlingTillTicketProvider.notifier).state = null;
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Riverpod [ref] is not available until after [initState] completes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _container = ref.container;
      primePosCartForTransactionWidget(
        ref,
        isExpense: false,
        transaction: widget.transaction,
      );
      unawaited(
        TransactionInitializationHelper.initializeSession(
          ref: ref,
          transaction: widget.transaction,
        ),
      );
    });
  }

  Future<void> _showParkDialog() async {
    var parked = false;
    final txn =
        ref.read(pendingTransactionStreamProvider(isExpense: false)).value ??
        widget.transaction;
    await showSharedTicketDialog(
      context: context,
      transaction: txn,
      onParked: () => parked = true,
    );
    if (!parked || !mounted) return;

    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) {
      await rootNav.maybePop();
    }
    await locator<RouterService>().navigateTo(
      TicketsListRoute(transaction: widget.transaction),
    );
  }

  String _ticketDisplayRef(ITransaction ticket) {
    final r = ticket.reference?.trim();
    if (r != null && r.isNotEmpty) return r.toUpperCase();
    final id = ticket.id;
    if (id.length >= 6) return id.substring(0, 6).toUpperCase();
    return id.toUpperCase();
  }

  Future<void> _sendCartToTill() async {
    if (_sendToTillBusy) return;
    final items = ref.read(posCartDisplayItemsProvider);
    if (items.isEmpty) return;

    final txn =
        ref.read(pendingTransactionStreamProvider(isExpense: false)).value ??
        widget.transaction;

    final hasCustomerId = (txn.customerId ?? '').trim().isNotEmpty;
    final hasCustomerName = (txn.customerName ?? '').trim().isNotEmpty;
    final hasCustomerPhone = (txn.customerPhone ?? '').trim().isNotEmpty;
    if (!hasCustomerId && !hasCustomerName && !hasCustomerPhone) {
      showErrorNotification(
        context,
        'Save a customer name or phone number on this ticket before sending it to the till.',
      );
      return;
    }

    setState(() => _sendToTillBusy = true);
    final displayRef = _ticketDisplayRef(txn);
    try {
      await ref
          .read(parkTransactionProvider.notifier)
          .park(
            ticketName: 'Till · $displayRef',
            ticketNote: 'Sent to till for payment',
            transaction: txn,
            customerId: txn.customerId,
          );

      // Clear every local representation before returning to the catalog so
      // the ticket that was just sent cannot flash as the next sale's cart.
      ref.read(suppressedCartTransactionIdProvider.notifier).state = txn.id;
      ref.read(optimisticCartProvider.notifier).clearForTransaction(txn.id);
      clearCachedPendingCartTransactionWidget(ref, isExpense: false);
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: txn.id,
          branchId: _branchId,
        ),
      );
      ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
      ref.read(customerPhoneNumberProvider.notifier).state = null;
      ref.read(mposMomoPhoneProvider.notifier).state = null;
      await ProxyService.box.writeString(key: 'customerName', value: '');
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: '',
      );

      if (!mounted) return;
      showSuccessNotification(context, 'Sent to till — Ticket #$displayRef');
      final rootNav = Navigator.of(context, rootNavigator: true);
      if (rootNav.canPop()) {
        await rootNav.maybePop();
      }
    } catch (e, st) {
      tv_talk.talker.error('Mobile send to till failed: $e', st);
      if (mounted) {
        showErrorNotification(context, 'Failed to send to till: $e');
      }
    } finally {
      if (mounted) setState(() => _sendToTillBusy = false);
    }
  }

  Future<void> _backToNewSaleFromSettling() async {
    if (_backToNewSaleBusy) return;
    final settling = ref.read(settlingTillTicketProvider);
    if (settling == null) return;

    setState(() => _backToNewSaleBusy = true);
    final branchId = settling.branchId ?? _branchId;
    try {
      try {
        final txn = await ProxyService.getStrategy(
          Strategy.capella,
        ).getTransaction(id: settling.transactionId, branchId: branchId);
        if (txn != null && (txn.status ?? '').toUpperCase() == 'PENDING') {
          await ref
              .read(parkTransactionProvider.notifier)
              .park(
                ticketName: (settling.ticketName ?? '').trim().isNotEmpty
                    ? settling.ticketName!
                    : 'Till · ${settling.displayRef}',
                ticketNote: settling.ticketNote ?? 'Sent to till for payment',
                transaction: txn,
                customerId: txn.customerId,
              );
        }
      } catch (e, st) {
        tv_talk.talker.error('Mobile back to new sale re-park failed: $e', st);
      }

      ref.read(settlingTillTicketProvider.notifier).state = null;
      clearPinnedPosCartTransactionWidget(ref);
      ref.invalidate(oldProvider.paymentMethodsProvider);
      ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _backToNewSaleBusy = false);
    }
  }

  Widget _buildSettlingBanner(SettlingTillTicket settling) {
    final minutes = DateTime.now()
        .difference(settling.createdAt)
        .inMinutes
        .clamp(0, 99999);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFEEF3FF),
          borderRadius: BorderRadius.circular(MposTokens.radiusMd),
          border: Border.all(color: const Color(0xFFC7D8FF)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collecting payment for #${settling.displayRef} · '
                'sent by ${settling.creatorName} · $minutes min ago',
                style: const TextStyle(
                  color: Color(0xFF1D4ED8),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: _backToNewSaleBusy
                    ? null
                    : () => unawaited(_backToNewSaleFromSettling()),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1D4ED8),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: _backToNewSaleBusy
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('Returning…'),
                        ],
                      )
                    : const Text(
                        'Back to new sale',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clearCustomer(ITransaction txn) async {
    if (_isClearingCustomer) return;
    HapticFeedback.lightImpact();

    final oldCustomerId = txn.customerId;
    setState(() => _isClearingCustomer = true);
    ref.read(customerPhoneNumberProvider.notifier).state = null;
    ref.read(mposMomoPhoneProvider.notifier).state = null;

    try {
      // Pending cart lives in Ditto (Capella); cloudSync brick-only clears do not
      // update what checkout UI watches.
      await ProxyService.getStrategy(
        Strategy.capella,
      ).removeCustomerFromTransaction(transaction: txn);
      if (oldCustomerId != null) {
        ref.invalidate(oldProvider.attachedCustomerProvider(oldCustomerId));
      }
      ref.invalidate(transactionByIdProvider(txn.id));
      ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
      await ProxyService.box.remove(key: 'customerTin');
      await ProxyService.box.remove(key: 'customerName');
      await ProxyService.box.remove(key: 'currentSaleCustomerPhoneNumber');
    } catch (e, s) {
      tv_talk.talker.error('Failed to remove customer from sale: $e', s);
      ref.invalidate(transactionByIdProvider(txn.id));
      ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
      if (mounted) {
        showErrorNotification(context, 'Could not remove customer');
      }
    } finally {
      if (mounted) {
        setState(() => _isClearingCustomer = false);
      }
    }
  }

  Future<void> _handleCharge(
    double total, {
    bool immediateCompletion = false,
  }) async {
    if (!ref.read(canCollectPosPaymentProvider)) {
      showErrorNotification(
        context,
        'Payments are collected at the till. Send this order to a manager.',
      );
      return;
    }
    HapticFeedback.lightImpact();

    final payments = ref.read(oldProvider.paymentMethodsProvider);
    final txn =
        ref.read(transactionByIdProvider(_transactionId)).value ??
        widget.transaction;
    final attached = txn.customerId == null
        ? null
        : ref.read(oldProvider.attachedCustomerProvider(txn.customerId)).value;
    final saleCustomerPhone = _resolveSaleCustomerPhone(
      txn,
      providerPhone: ref.read(customerPhoneNumberProvider),
      attached: attached,
    );
    if (!_hasCustomerForCharge(
      txn,
      saleCustomerPhone,
      momoPayment: _isMomoPayment(payments),
    )) {
      showErrorNotification(
        context,
        'Please add a customer to the sale before completing',
      );
      return;
    }

    final customerPhone = saleCustomerPhone;
    if (_isMomoPayment(payments)) {
      final momoPhone =
          ref.read(mposMomoPhoneProvider) ??
          ProxyService.box.currentSaleCustomerPhoneNumber() ??
          customerPhone;
      if (momoPhone == null ||
          momoPhone.replaceAll(RegExp(r'\D'), '').length < 9) {
        showErrorNotification(
          context,
          'Enter a valid MoMo phone number to request payment',
        );
        return;
      }
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: momoPhone.replaceAll(RegExp(r'\D'), ''),
      );
    }

    final hasCreditPayment = payments.any(
      (p) => p.method == 'CREDIT' && p.amount > 0,
    );
    if (hasCreditPayment) {
      if (!_hasCustomerForCharge(txn, saleCustomerPhone, momoPayment: false)) {
        showErrorNotification(
          context,
          'A customer name or phone is required for credit/loan payments.',
        );
        return;
      }
    }

    setState(() {
      _isImmediateCompletion = immediateCompletion;
      _chargeState = immediateCompletion
          ? ChargeButtonState.printingReceipt
          : ChargeButtonState.waitingForPayment;
    });
    ref.read(oldProvider.loadingProvider.notifier).startLoading();

    try {
      void onPaymentConfirmed() {
        if (mounted) {
          setState(() => _chargeState = ChargeButtonState.printingReceipt);
        }
      }

      void onPaymentFailed(String error) {
        if (mounted) {
          setState(() => _chargeState = ChargeButtonState.failed);
          ref.read(oldProvider.loadingProvider.notifier).stopLoading();
          showErrorNotification(context, error);
        }
      }

      final shouldWait = await widget.onCharge(
        _transactionId,
        total,
        onPaymentConfirmed,
        onPaymentFailed,
        immediateCompletion,
        _cachedNonCreditPaid,
      );

      if (mounted && (shouldWait != true || immediateCompletion)) {
        setState(() => _chargeState = ChargeButtonState.initial);
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        if (immediateCompletion && mounted) {
          await _navigateToSuccessScreen(total: total);
        }
      }
    } catch (e) {
      tv_talk.talker.error('Charge failed: $e');
      if (mounted) {
        setState(() => _chargeState = ChargeButtonState.failed);
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        showErrorNotification(context, 'Error occurred');
      }
    }
  }

  bool _isMomoPayment(List<oldProvider.Payment> payments) {
    if (payments.isEmpty) return false;
    final m = payments.first.method.toUpperCase();
    return m.contains('MOMO') || m.contains('MOBILE');
  }

  String _methodLabel(List<oldProvider.Payment> payments) {
    if (payments.isEmpty) return 'CASH';
    final m = payments.first.method.toUpperCase();
    if (m.contains('MOMO') || m.contains('MOBILE')) return 'MoMo';
    if (m.contains('CARD')) return 'Card';
    return 'Cash';
  }

  Future<void> _navigateToSuccessScreen({required double total}) async {
    final wasSettling = ref.read(settlingTillTicketProvider) != null;
    final items = await ref.read(
      transactionItemsStreamProvider(
        transactionId: _transactionId,
        branchId: _branchId,
      ).future,
    );
    final txn =
        ref.read(transactionByIdProvider(_transactionId)).value ??
        widget.transaction;
    final payments = ref.read(oldProvider.paymentMethodsProvider);
    final itemCount = items
        .fold<double>(0, (s, i) => s + i.qty.toDouble())
        .round();
    final isCash =
        payments.isNotEmpty && payments.first.method.toUpperCase() == 'CASH';
    final tender = isCash && payments.isNotEmpty
        ? double.tryParse(payments.first.controller.text) ?? total
        : total;
    final change = (tender - total).clamp(0.0, double.infinity);

    final attached = ref.read(
      oldProvider.attachedCustomerProvider(txn.customerId),
    );
    final customerName = attached.maybeWhen(
      data: (c) => c?.custNm ?? txn.customerName,
      orElse: () => txn.customerName,
    );

    if (!mounted) return;
    if (wasSettling) {
      ref.read(settlingTillTicketProvider.notifier).state = null;
      showSuccessNotification(
        context,
        'Payment collected · ${ProxyService.box.defaultCurrency()} '
        '${mposMoneyLabel(total)}',
      );
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (successContext) => MposSuccessScreen(
          data: MposSaleCompleteSnapshot(
            total: total,
            itemCount: itemCount,
            methodLabel: _methodLabel(payments),
            customerName: customerName,
            tendered: tender,
            change: change,
          ),
          onNewSale: () => Navigator.of(successContext).pop(),
        ),
      ),
    );
  }

  bool _canModifyItems(ITransaction transaction) =>
      (transaction.cashReceived ?? 0) <= 0;

  Future<void> _updateQuantity(
    TransactionItem item,
    double newQty,
    ITransaction transaction,
  ) async {
    if (item.partOfComposite ?? false) return;
    if (!_canModifyItems(transaction)) {
      showErrorNotification(
        context,
        'Cannot modify items in a transaction with partial payments',
      );
      return;
    }
    final previous = _displayQtyFor(item);
    setState(() => _optimisticQtyByItemId[item.id] = newQty);
    try {
      await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
        transactionItemId: item.id.toString(),
        ignoreForReport: false,
        qty: newQty,
      );
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: _transactionId,
          branchId: _branchId,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          if ((previous - item.qty.toDouble()).abs() < 0.0001) {
            _optimisticQtyByItemId.remove(item.id);
          } else {
            _optimisticQtyByItemId[item.id] = previous;
          }
        });
        showErrorNotification(context, 'Error updating quantity: $e');
      }
    }
  }

  Future<void> _deleteItem(TransactionItem item) async {
    final txn =
        ref.read(transactionByIdProvider(_transactionId)).value ??
        widget.transaction;
    if (!_canModifyItems(txn)) {
      showErrorNotification(
        context,
        'Cannot delete items from a transaction with partial payments',
      );
      return;
    }
    setState(() {
      _optimisticallyDeletedItemIds.add(item.id);
      _optimisticQtyByItemId.remove(item.id);
    });
    try {
      await ProxyService.getStrategy(Strategy.capella).deleteItemFromCart(
        transactionItemId: item,
        transactionId: _transactionId,
      );
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: _transactionId,
          branchId: _branchId,
        ),
      );
      widget.doneDelete();
    } catch (e) {
      if (mounted) {
        setState(() => _optimisticallyDeletedItemIds.remove(item.id));
        showErrorNotification(context, 'Error removing product: $e');
      }
    }
  }

  Future<void> _updatePrice(TransactionItem item, double price) async {
    final settings = locator<SettingsService>();
    final base = (item.retailPrice ?? item.price).toDouble();
    try {
      final isOverride =
          settings.enablePriceQuantityAdjustment &&
          base > 0 &&
          price > 0 &&
          (price - base).abs() > 0.001;
      if (isOverride) {
        await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
          qty: price / base,
          price: base,
          ignoreForReport: false,
          transactionItemId: item.id,
        );
      } else {
        await ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
          qty: _displayQtyFor(item),
          price: price,
          ignoreForReport: false,
          transactionItemId: item.id,
        );
      }
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: _transactionId,
          branchId: _branchId,
        ),
      );
    } catch (e) {
      showErrorNotification(context, 'Error updating price: $e');
    }
  }

  Future<void> _resetPrice(TransactionItem item) async {
    final base = (item.retailPrice ?? item.price).toDouble();
    await _updatePrice(item, base);
  }

  double _displayQtyFor(TransactionItem item) {
    final optimistic = _optimisticQtyByItemId[item.id];
    if (optimistic == null) return item.qty.toDouble();
    if ((item.qty.toDouble() - optimistic).abs() < 0.0001) {
      _optimisticQtyByItemId.remove(item.id);
      return item.qty.toDouble();
    }
    return optimistic;
  }

  String _phoneDigits(String? raw) => (raw ?? '').replaceAll(RegExp(r'\D'), '');

  /// Phone for charge gating — provider alone misses Ditto-only customer fields.
  String? _resolveSaleCustomerPhone(
    ITransaction txn, {
    String? providerPhone,
    Customer? attached,
  }) {
    for (final candidate in <String?>[
      providerPhone,
      attached?.telNo,
      txn.customerPhone,
      txn.currentSaleCustomerPhoneNumber,
      ProxyService.box.currentSaleCustomerPhoneNumber(),
    ]) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return null;
  }

  bool _hasCustomerForCharge(
    ITransaction txn,
    String? phone, {
    required bool momoPayment,
  }) {
    if (momoPayment) return _phoneDigits(phone).length >= 9;
    if (_phoneDigits(phone).length >= 9) return true;
    if (phone != null && phone.trim().isNotEmpty) return true;
    final id = txn.customerId?.trim();
    if (id != null && id.isNotEmpty) return true;
    final name = txn.customerName?.trim();
    return name != null && name.isNotEmpty;
  }

  double _cashTenderAmount(List<oldProvider.Payment> payments) {
    if (payments.isEmpty) return 0;
    final p = payments.first;
    final typed = double.tryParse(p.controller.text) ?? 0.0;
    return typed > p.amount ? typed : p.amount;
  }

  bool _canTapCharge({
    required bool itemsNotEmpty,
    required ITransaction txn,
    required String? saleCustomerPhone,
    required bool momoPayment,
  }) {
    if (!itemsNotEmpty) return false;
    if (_chargeState == ChargeButtonState.waitingForPayment ||
        _chargeState == ChargeButtonState.printingReceipt) {
      return false;
    }
    return _hasCustomerForCharge(
      txn,
      saleCustomerPhone,
      momoPayment: momoPayment,
    );
  }

  bool _shouldShowSpinner() =>
      _chargeState == ChargeButtonState.waitingForPayment ||
      _chargeState == ChargeButtonState.printingReceipt;

  String _primaryLabel(
    bool isEmpty,
    ITransaction txn,
    String? saleCustomerPhone,
    bool momoPayment,
    double remaining,
  ) {
    if (isEmpty) return 'Add items to charge';
    if (!_hasCustomerForCharge(
      txn,
      saleCustomerPhone,
      momoPayment: momoPayment,
    )) {
      return 'Add customer';
    }
    switch (_chargeState) {
      case ChargeButtonState.initial:
        return remaining > 0 ? 'Record Payment' : 'Complete';
      case ChargeButtonState.waitingForPayment:
        return 'Waiting for payment...';
      case ChargeButtonState.printingReceipt:
        return 'Printing receipt...';
      case ChargeButtonState.failed:
        return 'Payment Failed. Retry?';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(posCartStreamReconciliationProvider, (_, __) {});

    ref.listen(payButtonStateProvider, (previous, next) {
      final wasLoading = previous?[ButtonType.pay] == true;
      final isNowLoading = next[ButtonType.pay] == true;
      if (_chargeState == ChargeButtonState.printingReceipt &&
          wasLoading &&
          !isNowLoading) {
        if (mounted) {
          setState(() => _chargeState = ChargeButtonState.initial);
          final txn =
              ref.read(transactionByIdProvider(_transactionId)).value ??
              widget.transaction;
          // Use the live cart directly (same source as the on-screen list) so
          // the receipt total is not zeroed by the transactionId re-filter.
          var merged = ref
              .read(posCartDisplayItemsProvider)
              .where((i) => i.active != false)
              .toList();
          if (merged.isEmpty) {
            merged =
                (ref
                            .read(
                              transactionItemsStreamProvider(
                                transactionId: _transactionId,
                                branchId: _branchId,
                              ),
                            )
                            .asData
                            ?.value ??
                        const <TransactionItem>[])
                    .where((i) => i.active != false)
                    .toList();
          }
          final total = calculateTransactionTotal(
            items: merged,
            transaction: txn,
          );
          _navigateToSuccessScreen(total: total);
        }
      }
    });

    final streamAsync = ref.watch(
      transactionItemsStreamProvider(
        transactionId: _transactionId,
        branchId: _branchId,
      ),
    );
    final mergedAll = ref.watch(posCartDisplayItemsProvider);
    // Mirror the desktop QuickSellingView: render exactly what
    // posCartDisplayItemsProvider holds for the active cart. That provider is
    // pinned to this transaction when the checkout opens (primePosCartFor…) and
    // is settling-aware for till collection, so it is the single source of
    // truth for the cart — a regular sale AND a collected ticket alike. The
    // previous resolveMobileCheckoutLineItems path re-filtered by transactionId
    // and dropped rows whose stored transactionId did not byte-match
    // widget.transaction.id, leaving the mobile cart empty while the totals
    // were right. Fall back to the scoped stream only when the merged cart has
    // not resolved yet.
    final displayLines = mergedAll.where((i) => i.active != false).toList();
    final resolvedLines = displayLines.isNotEmpty
        ? displayLines
        : (streamAsync.asData?.value ?? const <TransactionItem>[])
              .where((i) => i.active != false)
              .toList();
    final items = List<TransactionItem>.from(resolvedLines)
      ..removeWhere((i) => _optimisticallyDeletedItemIds.contains(i.id))
      ..sort((a, b) {
        final ad = a.createdAt ?? DateTime(2000);
        final bd = b.createdAt ?? DateTime(2000);
        return bd.compareTo(ad);
      });

    final transactionAsync = ref.watch(transactionByIdProvider(_transactionId));
    final settling = ref.watch(settlingTillTicketProvider);
    final customerPhone = ref.watch(customerPhoneNumberProvider);
    final digitalEnabled =
        ref.watch(isDigitalPaymentEnabledProvider).asData?.value ?? false;

    final txn = transactionAsync.value ?? widget.transaction;

    final pendingOptimistic = ref
        .read(optimisticCartProvider.notifier)
        .hasPendingFor(_transactionId);

    if (streamAsync.hasError && items.isEmpty) {
      return Scaffold(
        backgroundColor: MposTokens.bg,
        body: SafeArea(
          child: Center(child: Text('Error: ${streamAsync.error}')),
        ),
      );
    }

    if (items.isEmpty && streamAsync.isLoading && !pendingOptimistic) {
      return const Scaffold(
        backgroundColor: MposTokens.bg,
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    return Scaffold(
      backgroundColor: MposTokens.bg,
      body: SafeArea(
        bottom: false,
        child: Builder(
          builder: (context) {
            final alreadyPaid = txn.cashReceived ?? 0.0;
            final paymentsList = ref.watch(oldProvider.paymentMethodsProvider);
            final pendingPayment = calculateTotalPaid(paymentsList);
            final totalPaid = alreadyPaid + pendingPayment;
            final total = calculateTransactionTotal(
              items: items,
              transaction: txn,
            );
            // Outstanding before this payment line (do not subtract tender being
            // edited — that caused totalPayable ↔ amount field oscillation).
            final saleOutstanding = calculateRemainingBalance(
              total: total,
              paid: alreadyPaid,
            );
            final remaining = calculateRemainingBalance(
              total: total,
              paid: totalPaid,
            );

            final currentId = txn.id;
            // Wait until the cart has resolved line items before initializing
            // payment (mirrors the desktop guard). Firing during the initial
            // route-push frame — while items are still empty — mutates
            // paymentMethodsProvider mid-transition and notifies a watcher whose
            // element is already defunct (markNeedsBuild assertion).
            if (transactionAsync.hasValue &&
                items.isNotEmpty &&
                _lastTransactionId != currentId) {
              _lastTransactionId = currentId;
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (!mounted) return;
                final nonCreditPaid = await fetchNonCreditPaid(txn.id);
                if (!mounted) return;
                setState(() => _cachedNonCreditPaid = nonCreditPaid);
                standardizedPaymentInitialization(
                  ref: ref,
                  transaction: txn,
                  total: total,
                  overrideAlreadyPaid: nonCreditPaid,
                );
              });
            }

            final attachedAsync = ref.watch(
              oldProvider.attachedCustomerProvider(txn.customerId),
            );
            final attachedCustomer = attachedAsync.asData?.value;
            final customerName = attachedCustomer?.custNm ?? txn.customerName;
            final saleCustomerPhone = _resolveSaleCustomerPhone(
              txn,
              providerPhone: customerPhone,
              attached: attachedCustomer,
            );
            final displayCustomerName = _isClearingCustomer
                ? null
                : customerName;
            final displaySaleCustomerPhone = _isClearingCustomer
                ? null
                : saleCustomerPhone;

            final canCollect = ref.watch(canCollectPosPaymentProvider);
            final isCash =
                paymentsList.isNotEmpty &&
                paymentsList.first.method.toUpperCase() == 'CASH';
            final isMomo = _isMomoPayment(paymentsList);
            final tender = isCash ? _cashTenderAmount(paymentsList) : 0.0;
            final change = isCash && tender > 0
                ? (tender - remaining).clamp(0.0, double.infinity)
                : null;
            final due = isCash && tender > 0 && tender < remaining
                ? remaining - tender
                : null;

            final cashOk = !isCash || tender >= saleOutstanding - 0.01;
            final momoPhone =
                ref.watch(mposMomoPhoneProvider) ??
                displaySaleCustomerPhone ??
                ProxyService.box.currentSaleCustomerPhoneNumber();
            final momoOk = !isMomo || _phoneDigits(momoPhone).length >= 9;
            final canCharge =
                canCollect &&
                _canTapCharge(
                  itemsNotEmpty: items.isNotEmpty,
                  txn: txn,
                  saleCustomerPhone: displaySaleCustomerPhone,
                  momoPayment: isMomo,
                );
            final ready = canCollect
                ? (total > 0 &&
                      canCharge &&
                      cashOk &&
                      momoOk &&
                      _chargeState == ChargeButtonState.initial)
                : (items.isNotEmpty && !_sendToTillBusy);

            final itemCount = items
                .fold<double>(0, (s, i) => s + _displayQtyFor(i))
                .round();

            var footerPrimaryLabel = !canCollect
                ? 'Send to Till →'
                : digitalEnabled && items.isNotEmpty
                ? (remaining > 0.01 ? 'Record Payment' : 'Complete Now')
                : _primaryLabel(
                    items.isEmpty,
                    txn,
                    displaySaleCustomerPhone,
                    isMomo,
                    remaining,
                  );
            if (canCollect && canCharge && !cashOk && isCash) {
              footerPrimaryLabel =
                  'Enter ${mposMoneyLabel(saleOutstanding)} received';
            }

            return MaestroSemantics(
              id: MaestroIds.mposCheckoutScreen,
              label: 'Mobile checkout',
              value: '$itemCount items, RWF ${mposMoneyLabel(total)}',
              child: Column(
                children: [
                  MposCheckoutHeader(
                    itemCount: itemCount,
                    timeLabel: mposCheckoutTimeLabel(txn.createdAt),
                    status: txn.status ?? 'PENDING',
                    onBack: () {
                      ref
                          .read(oldProvider.loadingProvider.notifier)
                          .stopLoading();
                      Navigator.of(context).pop();
                    },
                  ),
                  if (settling != null) _buildSettlingBanner(settling),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      children: [
                        if (settling == null) ...[
                          const MposSectionLabel('Customer'),
                          const SizedBox(height: 8),
                          MposCustomerSection(
                            customerName: displayCustomerName,
                            customerPhone: displaySaleCustomerPhone,
                            isClearing: _isClearingCustomer,
                            onAttach: () => MposCustomerSheet.show(
                              context: context,
                              ref: ref,
                              transaction: txn,
                            ),
                            onClear: () => _clearCustomer(txn),
                          ),
                          const SizedBox(height: 14),
                        ],
                        const MposSectionLabel('Items'),
                        const SizedBox(height: 8),
                        if (items.isEmpty)
                          const MposCard(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text(
                                'No items in cart',
                                style: TextStyle(color: PosTokens.ink3),
                              ),
                            ),
                          )
                        else
                          MposCard(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                for (var i = 0; i < items.length; i++) ...[
                                  if (i > 0)
                                    const Divider(
                                      height: 1,
                                      color: PosTokens.line,
                                    ),
                                  MposItemLine(
                                    semanticId:
                                        '${MaestroIds.mposItemLinePrefix}.${items[i].id}',
                                    name: items[i].name,
                                    unitPrice: items[i].price.toDouble(),
                                    baseUnitPrice:
                                        (items[i].retailPrice ?? items[i].price)
                                            .toDouble(),
                                    qty: _displayQtyFor(items[i]),
                                    canEdit:
                                        settling == null &&
                                        _canModifyItems(txn),
                                    onDecrement: () => _updateQuantity(
                                      items[i],
                                      _displayQtyFor(items[i]) - 1,
                                      txn,
                                    ),
                                    onIncrement: () => _updateQuantity(
                                      items[i],
                                      _displayQtyFor(items[i]) + 1,
                                      txn,
                                    ),
                                    onDelete: () => _deleteItem(items[i]),
                                    onPriceChanged: (p) =>
                                        _updatePrice(items[i], p),
                                    onPriceReset: () => _resetPrice(items[i]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        if (settling == null) ...[
                          const SizedBox(height: 10),
                          MaestroSemantics(
                            id: MaestroIds.mposAddMoreItems,
                            label: 'Add more items',
                            button: true,
                            enabled: true,
                            child: OutlinedButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                foregroundColor: PosTokens.blue,
                                side: const BorderSide(
                                  color: PosTokens.lineStrong,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    MposTokens.radiusMd,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.add_rounded, size: 17),
                              label: const Text(
                                'Add more items',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        if (canCollect) ...[
                          const MposSectionLabel('Payment method'),
                          const SizedBox(height: 8),
                          MposPaymentSection(
                            transactionId: _transactionId,
                            totalPayable: saleOutstanding > 0
                                ? saleOutstanding
                                : total,
                          ),
                          const SizedBox(height: 14),
                        ] else ...[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 14),
                            child: Text(
                              'Payments are collected at the till. Send this '
                              "order once it's ready — a manager will collect "
                              'payment.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: PosTokens.ink3,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                        const MposSectionLabel('Totals'),
                        const SizedBox(height: 8),
                        MposTotalsCard(
                          subtotal: total,
                          tax: 0,
                          total: total,
                          alreadyPaid: alreadyPaid,
                          pendingPayment: pendingPayment,
                          remainingBalance: remaining,
                          change: change != null && change > 0 ? change : null,
                          balanceDue: due != null && due > 0 ? due : null,
                        ),
                      ],
                    ),
                  ),
                  MposCheckoutFooter(
                    total: total,
                    ready: ready,
                    isLoading: canCollect
                        ? (_isImmediateCompletion && _shouldShowSpinner())
                        : _sendToTillBusy,
                    primaryLabel: footerPrimaryLabel,
                    onSaveTicket: items.isEmpty || settling != null
                        ? null
                        : _showParkDialog,
                    onPrimary: !canCollect
                        ? (items.isEmpty || _sendToTillBusy
                              ? null
                              : () => unawaited(_sendCartToTill()))
                        : canCharge
                        ? () => _handleCharge(
                            total,
                            immediateCompletion:
                                !digitalEnabled || remaining <= 0.01,
                          )
                        : null,
                    // Digital MoMo: split Charge (wait) vs Complete Now (handoff deviation).
                    secondaryLabel:
                        canCollect && digitalEnabled && items.isNotEmpty
                        ? _primaryLabel(
                            items.isEmpty,
                            txn,
                            displaySaleCustomerPhone,
                            isMomo,
                            remaining,
                          )
                        : null,
                    onSecondary:
                        canCollect &&
                            digitalEnabled &&
                            items.isNotEmpty &&
                            canCharge
                        ? () => _handleCharge(total, immediateCompletion: false)
                        : null,
                    secondaryLoading:
                        !_isImmediateCompletion && _shouldShowSpinner(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
