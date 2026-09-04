// ignore_for_file: unused_result
import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/features/tickets/widgets/review_queue_banner.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/TransactionItemTable.dart';
import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/utils/frame_sync.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_models/providers/counter_provider.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/optimistic_order_count_provider.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pending_cart_sale_session_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/park_transaction_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/pending_sale_cart_cleanup.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
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
import 'package:flipper_dashboard/utils/customer_pay_gate.dart';
import 'package:flipper_dashboard/widgets/checkout_error_recovery_screen.dart';
import 'package:flipper_dashboard/widgets/payment_methods_card.dart';
import 'package:flipper_dashboard/widgets/pos_cart_table_host.dart';
import 'package:flipper_dashboard/widgets/checkout_mode_bar.dart';
import 'package:flipper_dashboard/widgets/checkout_transfer_branch_row.dart';
import 'package:flipper_dashboard/widgets/checkout_transfer_footer.dart';
import 'package:flipper_dashboard/widgets/whatsapp_meta_opt_in_dialog.dart';
import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_dashboard/services/branch_transfer_service.dart';
import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_models/helperModels/talker.dart' as tv_talk;
import 'package:flipper_services/digital_receipt_service.dart';

/// Compact label for correlating QuickSellingView with [pendingTransactionStream] logs.
String _qsvPendingLabel(AsyncValue<ITransaction> v) {
  if (v.isLoading) return 'loading';
  if (v.hasError) return 'error:${v.error}';
  if (!v.hasValue || v.value == null) return 'noValue';
  final t = v.value!;
  return 'id=${t.id} status=${t.status} invoiceNo=${t.invoiceNumber}';
}

const _kShortTransactionIdLength = 5;

String _shortTransactionId(String id) {
  if (id.isEmpty) return '-----';
  final short = id.length <= _kShortTransactionIdLength
      ? id
      : id.substring(0, _kShortTransactionIdLength);
  return short.toUpperCase();
}

String _ticketDisplayRef(ITransaction ticket) {
  final r = ticket.reference?.trim();
  if (r != null && r.isNotEmpty) return r.toUpperCase();
  final id = ticket.id;
  if (id.length >= 6) return id.substring(0, 6).toUpperCase();
  return id.toUpperCase();
}

int _minutesAgo(DateTime? createdAt) {
  if (createdAt == null) return 0;
  final diff = DateTime.now().difference(createdAt);
  return diff.inMinutes.clamp(0, 99999);
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
        TransactionComputationMixin,
        AnalyticsTrackingMixin {
  @override
  ProductAnalytics get analytics => ProxyService.productAnalytics;

  /// Current tender from the received-amount field, falling back to payment methods.
  /// Treat field "0" as unset so we do not prefer a cleared field over payments.
  double _currentTenderAmount(List<Payment> payments) {
    final fieldAmount =
        double.tryParse(widget.receivedAmountController.text.trim());
    if (fieldAmount != null && fieldAmount > 0.01) return fieldAmount;
    return calculateTotalPaid(payments);
  }

  /// Prior paid for change/balance math. Drops a stale cache that only mirrors
  /// the in-progress exact-pay tender (cashReceived / getCashReceived), which
  /// otherwise yields change = tender when tender == total (e.g. 500+500-500).
  double _priorPaidForTenderMath({
    required double alreadyPaid,
    required double tender,
    required double total,
  }) {
    if (alreadyPaid <= 0.01) return 0.0;

    // Exact-pay mirror: prior == tender == sale total → not a real prior payment.
    if ((alreadyPaid - tender).abs() <= 0.01 &&
        (alreadyPaid - total).abs() <= 0.01) {
      _clearStaleNonCreditCache(alreadyPaid);
      return 0.0;
    }
    if ((tender - total).abs() <= 0.01 &&
        (alreadyPaid - total).abs() <= 0.01) {
      _clearStaleNonCreditCache(alreadyPaid);
      return 0.0;
    }

    // Resumed ticket: field auto-filled to the remainder still owed.
    final remainderDue = total - alreadyPaid;
    if (remainderDue > 0.01 && (tender - remainderDue).abs() <= 0.01) {
      return alreadyPaid;
    }

    // Cashier typed less than the sale total after auto-fill to exact total —
    // field is amount tendered now, not cumulative on stale cache/cashReceived.
    if (tender < total - 0.01 &&
        _lastAutoSetAmount > tender + 0.01 &&
        (_lastAutoSetAmount - total).abs() <= 0.01) {
      _clearStaleNonCreditCache(alreadyPaid);
      return 0.0;
    }

    // Additional installment on a resumed sale (real records).
    if (tender + alreadyPaid < total - 0.01) {
      return alreadyPaid;
    }

    _clearStaleNonCreditCache(alreadyPaid);
    return 0.0;
  }

  void _clearStaleNonCreditCache(double alreadyPaid) {
    if (_cachedNonCreditPaid != null &&
        (_cachedNonCreditPaid! - alreadyPaid).abs() <= 0.01) {
      _cachedNonCreditPaid = 0.0;
    }
  }

  Future<void> _refetchNonCreditPaidForPendingSale() async {
    final isExpense = ProxyService.box.isOrdering() ?? false;
    final txnId = ref
        .read(pendingTransactionStreamProvider(isExpense: isExpense))
        .value
        ?.id;
    if (txnId == null || txnId.isEmpty) return;
    final gen = ++_nonCreditPaidFetchGen;
    final paid = await fetchNonCreditPaid(txnId);
    if (!mounted || gen != _nonCreditPaidFetchGen) return;
    // Apply even during optimistic qty drift — prior paid comes from payment
    // records, not line totals.
    setState(() => _cachedNonCreditPaid = paid);
  }

  double _amountToChange(double alreadyPaid, List<Payment> payments) {
    final total = totalAfterDiscountAndShipping;
    final tender = _currentTenderAmount(payments);
    final prior = _priorPaidForTenderMath(
      alreadyPaid: alreadyPaid,
      tender: tender,
      total: total,
    );
    return calculateAmountToChange(total: total, paid: prior + tender);
  }

  double _remainingBalance(double alreadyPaid, List<Payment> payments) {
    final total = totalAfterDiscountAndShipping;
    final tender = _currentTenderAmount(payments);
    final prior = _priorPaidForTenderMath(
      alreadyPaid: alreadyPaid,
      tender: tender,
      total: total,
    );
    return calculateRemainingBalance(total: total, paid: prior + tender);
  }

  /// Prior non-credit payments from payment records, when loaded.
  ///
  /// Do not fall back to [ITransaction.cashReceived] for normal sales: item-add
  /// updates mirror [ProxyService.box.getCashReceived] into that field, so it
  /// often holds the current tender and would be double-counted with
  /// [paymentMethodsProvider]. Loans may still use cashReceived until fetch completes.
  double _effectiveAlreadyPaid(ITransaction? transaction) {
    // Ditto stream / async fetch can hold a stale prior while qty +/- is optimistic.
    if (hasOptimisticLineQtyDrift()) return 0.0;
    // [transaction.cashReceived] is written synchronously as part of sale
    // completion, while the payment-records fetch behind [_cachedNonCreditPaid]
    // is persisted in a deferred/fire-and-forget write (see
    // `_persistSalePaymentLines`) and can resolve to a stale/low value shortly
    // after a prior installment. Floor the fetched value with cashReceived on a
    // resumed loan so a lagging fetch never makes a fully-paid ticket look
    // underpaid and get re-parked. Never used for non-loan sales, where
    // cashReceived may just mirror the in-progress tender.
    final loanFloor = transaction?.isLoan == true
        ? (transaction?.cashReceived ?? 0.0)
        : 0.0;
    final cached = _cachedNonCreditPaid;
    if (cached == null) return loanFloor;
    return math.max(cached, loanFloor);
  }

  double get totalAfterDiscountAndShipping {
    return _checkoutSaleTotal();
  }

  /// Sale total for payment auto-fill — never regress below [grandTotal] while
  /// cart +/- optimistic qty is ahead of the Ditto stream.
  double _checkoutSaleTotal({List<TransactionItem>? items}) {
    final computed = _calculateTotal(items: items);
    if (!hasOptimisticLineQtyDrift()) return computed;
    return math.max(computed, grandTotal.toDouble());
  }

  /// Transaction the checkout is acting on: the till ticket being settled (once
  /// its row has loaded), else the pending cart that owns the on-screen lines.
  ITransaction? _activeCheckoutTransaction() {
    final isExpense = ProxyService.box.isOrdering() ?? false;
    final settling = ref.read(effectiveSettlingTillTicketProvider);
    if (settling != null && settling.transactionId.isNotEmpty) {
      final ticket =
          ref.read(transactionByIdProvider(settling.transactionId)).value ??
          settling.ticketSnapshot;
      if (ticket != null) return ticket;
    }
    return _pendingCartMatchingDisplay(
      isExpense: isExpense,
      streamed: ref
          .read(pendingTransactionStreamProvider(isExpense: isExpense))
          .value,
      cached: readCachedPendingCartTransactionWidget(ref, isExpense: isExpense),
      listen: false,
    );
  }

  /// True while [status] is a row the checkout may still act on (i.e. not
  /// already completed / sent for review / awaiting handover).
  bool _isPayableCheckoutStatus(String? status) {
    final s = status?.toLowerCase();
    return s == PENDING.toLowerCase() || s == PARKED.toLowerCase();
  }

  /// Resolves [transactionId] to a row the checkout can complete, else null.
  ///
  /// [listen] must be true only on build paths — [ref.watch] outside build
  /// leaves a stray subscription behind.
  ITransaction? _payableCheckoutTransactionById(
    String transactionId, {
    required bool listen,
  }) {
    if (transactionId.isEmpty) return null;
    final async = listen
        ? ref.watch(transactionByIdProvider(transactionId))
        : ref.read(transactionByIdProvider(transactionId));
    final txn = async.value;
    if (txn == null || txn.id.isEmpty) return null;
    return _isPayableCheckoutStatus(txn.status) ? txn : null;
  }

  /// Prefer the pending row that owns [posCartDisplayItemsProvider] lines so
  /// Send-for-Review never targets a freshly minted empty twin (see log
  /// displayTxnIds ≠ completion txn).
  ITransaction? _pendingCartMatchingDisplay({
    required bool isExpense,
    required ITransaction? streamed,
    required ITransaction? cached,
    required bool listen,
  }) {
    final displayTxnIds = ref
        .read(posCartDisplayItemsProvider)
        .map((i) => i.transactionId)
        .whereType<String>()
        .where(
          (id) =>
              id.isNotEmpty && !OptimisticCartBootstrap.isBootstrap(id),
        )
        .toSet();
    if (displayTxnIds.length == 1) {
      final id = displayTxnIds.single;
      if (streamed != null && streamed.id == id) return streamed;
      if (cached != null && cached.id == id) return cached;
      // The visible lines belong to a transaction that is neither the streamed
      // nor the cached pending cart — normally the *pinned* cart of a resumed
      // ticket whose settling session has already been cleared.
      // [posCartPendingTransactionIdProvider] resolves that pin before the
      // cache/stream, so the cart shows those lines while completion used to be
      // handed the (empty) pending cart instead and died in the persisted-cart
      // poll: "Sale completion blocked: cart not fully persisted txn=<pending>
      // … displayTxnIds={<pinned>}". Pay must act on the rows on screen.
      final owner = _payableCheckoutTransactionById(id, listen: listen);
      if (owner != null) return owner;
    }
    // Empty cart: prefer primed cache so Txn ID flips with "Sent for review"
    // before the Ditto stream drops the just-sent ticket.
    if (cached != null &&
        cached.id.isNotEmpty &&
        cached.status == PENDING) {
      return cached;
    }
    if (streamed != null &&
        streamed.id.isNotEmpty &&
        streamed.status == PENDING) {
      return streamed;
    }
    return null;
  }

  double _calculateTotal({List<TransactionItem>? items}) {
    final transaction = _activeCheckoutTransaction();
    final discountPercent =
        double.tryParse(widget.discountController.text) ?? 0.0;

    return calculateTransactionTotal(
      items: itemsForCheckoutTotals(items ?? internalTransactionItems),
      transaction: transaction,
      discountPercent: discountPercent,
    );
  }

  @override
  void onLineQtyOptimisticChange() {
    // Keep [_cachedNonCreditPaid] — payment records are independent of qty drift.
    // Zeroing here unlocked delete-all / wrong remainder on partial-paid tickets.
    unawaited(_refetchNonCreditPaidForPendingSale());
    _scheduleReceivedAmountSync();
  }

  Timer? _receivedAmountSyncTimer;
  static const Duration _receivedAmountSyncDebounce =
      Duration(milliseconds: 48);

  void _scheduleReceivedAmountSync() {
    _receivedAmountSyncTimer?.cancel();
    _receivedAmountSyncTimer = Timer(_receivedAmountSyncDebounce, () {
      if (!mounted) return;
      final transaction = _activeCheckoutTransaction();
      if (transaction == null) return;
      _updateReceivedAmountIfNeeded(
        transaction,
        items: ref.read(posCartDisplayItemsProvider),
      );
    });
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

    final total = _checkoutSaleTotal(items: items);

    updatePaymentRemainder(
      ref: ref,
      transaction: transaction,
      total: total,
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
      child: _buildCheckoutHeaderMeta(branchId: branchId),
    );
  }

  /// Eyebrow label + value column for invoice / txn id in the checkout header.
  Widget _buildCheckoutMetaColumn({
    required String label,
    required String value,
    Key? valueKey,
    String? tooltip,
    VoidCallback? onTap,
  }) {
    const labelStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.55,
      color: PosTokens.ink3,
    );
    final valueStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: PosTokens.ink1,
      letterSpacing: -0.2,
      height: 1.15,
    );

    Widget valueWidget = Text(value, key: valueKey, style: valueStyle);
    if (tooltip != null) {
      valueWidget = Tooltip(message: tooltip, child: valueWidget);
    }

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: labelStyle),
        const SizedBox(height: 2),
        valueWidget,
      ],
    );

    if (onTap == null) return column;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: column,
    );
  }

  /// Invoice number + current pending cart transaction id.
  ///
  /// **Note:** [highestCounterProvider] is the next invoice sequence, not the
  /// Ditto transaction `_id`. The **Txn ID** label matches the cart / Pay target.
  Widget _buildCheckoutHeaderMeta({required String branchId}) {
    final isExpense = ProxyService.box.isOrdering() ?? false;
    // Prefer the till ticket being settled so the header matches the settling
    // banner; otherwise show the operator's own pending cart.
    final settling = ref.watch(effectiveSettlingTillTicketProvider);
    final cachedPending =
        ref.watch(cachedPendingCartTransactionProvider(isExpense));
    final streamedPending = ref
        .watch(pendingTransactionStreamProvider(isExpense: isExpense))
        .value;
    final pendingTxn = (settling != null && settling.transactionId.isNotEmpty)
        ? (ref.watch(transactionByIdProvider(settling.transactionId)).value ??
            settling.ticketSnapshot)
        : _pendingCartMatchingDisplay(
            isExpense: isExpense,
            streamed: streamedPending,
            cached: cachedPending,
            listen: true,
          );
    final txnId = pendingTxn?.id;
    final highestInvoiceNumber = ref.watch(highestCounterProvider(branchId));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCheckoutMetaColumn(
          label: context.flipperL10n.invoice,
          value: context.flipperL10n.invoiceNumberValue(highestInvoiceNumber.toString()),
          valueKey: const Key('invoice-number-text'),
        ),
        if (txnId != null && txnId.isNotEmpty) ...[
          const SizedBox(width: 24),
          _buildCheckoutMetaColumn(
            label: context.flipperL10n.txnId,
            value: _shortTransactionId(txnId),
            valueKey: const Key('pending-transaction-id-text'),
            tooltip: txnId,
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: txnId));
              if (!mounted) return;
              showSuccessNotification(
                context,
                context.flipperL10n.transactionIdCopiedToClipboard,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ],
    );
  }

  /// Desktop shared view: stays **above** the scrolling line items (not inside the list).
  /// Invoice / Txn ID columns + Save ticket; balance due lives above payment input.
  /// Appearance must stay stable — pin via layout, do not restyle for stickiness.
  Widget _buildTopBarCheckoutSummary({
    required AsyncValue<ITransaction> transactionAsyncValue,
    required CoreViewModel model,
  }) {
    final branchId = ProxyService.box.getBranchId();
    final transaction = transactionAsyncValue.asData?.value;

    final showSaveTicket =
        transaction != null &&
        ref.watch(effectiveSettlingTillTicketProvider) == null &&
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (branchId != null)
                Expanded(child: _buildCheckoutHeaderMeta(branchId: branchId))
              else
                const Spacer(),
              if (showSaveTicket) ...[
                const SizedBox(width: 12),
                _buildTopBarSaveTicketButton(
                  transaction: transaction,
                  model: model,
                ),
              ],
            ],
          ),
        ),
      ),
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
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          hoverColor: PosTokens.ink4.withValues(alpha: 0.12),
          splashColor: PosTokens.ink4.withValues(alpha: 0.18),
          highlightColor: PosTokens.ink4.withValues(alpha: 0.08),
          child: Ink(
            decoration: BoxDecoration(
              color: PosTokens.surface,
              borderRadius: BorderRadius.circular(PosTokens.radiusSm),
              border: Border.all(color: PosTokens.lineStrong),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(FluentIcons.bookmark_16_filled, size: 15, color: accent),
                  const SizedBox(width: 6),
                  Text(
                    context.flipperL10n.saveTicketAction,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: PosTokens.ink1,
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

  /// Full-width balance / change banner between Grand Total and payment input.
  Widget _buildBalanceDueBanner(double alreadyPaid) {
    return Consumer(
      builder: (context, ref, _) {
        ref.watch(posCartPaymentRefreshSignalProvider);
        final total = _calculateTotal();
        if (total <= 0) return const SizedBox.shrink();

        final payments = ref.watch(paymentMethodsProvider);
        final tendered = _currentTenderAmount(payments);
        final remaining = _remainingBalance(alreadyPaid, payments);
        final change = _amountToChange(alreadyPaid, payments);
        final currency = ProxyService.box.defaultCurrency();

        final isRemaining = remaining > 0;
        if (!isRemaining && change <= 0) return const SizedBox.shrink();

        final inkColor = isRemaining ? PosTokens.lossInk : PosTokens.gainInk;
        final accentColor = isRemaining ? PosTokens.loss : PosTokens.gain;
        final bgColor = isRemaining ? PosTokens.lossTint : PosTokens.blueTint;
        final headline = isRemaining ? 'BALANCE DUE' : 'CHANGE';
        final amount = isRemaining ? remaining : change;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Semantics(
            label: isRemaining
                ? context.flipperL10n.remainingBalanceLabel
                : context.flipperL10n.amountToChangeLabel,
            value: amount.toCurrencyFormatted(symbol: currency),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                border: Border.all(color: accentColor.withValues(alpha: 0.22)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headline,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.45,
                            color: inkColor,
                          ),
                        ),
                        if (tendered > 0) ...[
                          const SizedBox(height: 3),
                          Text(
                            context.flipperL10n.tenderedAmount(
                  tendered.toCurrencyFormatted(symbol: currency),
                ),
                            style: const TextStyle(
                              fontSize: 12,
                              color: PosTokens.ink3,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    amount.toCurrencyFormatted(symbol: currency),
                    style: PosTokens.posPriceStyle(
                      Theme.of(context).textTheme,
                      fontSize: 22,
                      color: inkColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Material(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _receivedAmountFocusNode.requestFocus(),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: inkColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

    // Meta WhatsApp: when receipt is queued outside 24h window, show opt-in QR.
    _whatsAppOptInSub = DigitalReceiptService.optInPromptStream.listen((prompt) {
      if (!mounted || _whatsAppOptInDialogShowing) return;
      _whatsAppOptInDialogShowing = true;
      showWhatsAppMetaOptInDialog(context, prompt).whenComplete(() {
        _whatsAppOptInDialogShowing = false;
      });
    });
  }

  void _onDiscountChanged() {
    _scheduleReceivedAmountSync();
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

  Customer? _attachedCustomerHintFor(ITransaction transaction) {
    final customerId = transaction.customerId;
    if (customerId == null || customerId.isEmpty) return null;
    return ref.read(attachedCustomerProvider(customerId)).asData?.value;
  }

  /// Customer details that gate sale completion.
  ///
  /// The customer capture panel is collapsible, so its field validators are not
  /// mounted while collapsed and [formKey] validation alone can be bypassed —
  /// this enforces the same rules as [missingCustomerDetailsForPay] (name
  /// always; phone unless a TIN is on file) regardless of the panel state.
  String? _missingCustomerForPay(ITransaction? transaction) {
    final attached =
        transaction == null ? null : _attachedCustomerHintFor(transaction);
    return missingCustomerDetailsForPay(
      transaction: transaction,
      attachedCustomer: attached,
      typedName: ref.read(customerNameControllerProvider).text,
      typedPhone: widget.customerPhoneNumberController.text,
      pleaseEnterCustomerName: context.flipperL10n.pleaseEnterCustomerName,
      phoneRequiredWhenTinMissing:
          context.flipperL10n.phoneRequiredWhenTinMissing,
    );
  }

  /// Guards the Pay action. When customer details are missing it stops the pay
  /// spinner, surfaces the reason, expands the customer panel (for a normal
  /// sale) so the cashier can type them, and returns false so completion aborts.
  bool _ensureCustomerBeforePay(ITransaction? transaction) {
    final error = _missingCustomerForPay(transaction);
    if (error == null) return true;

    ref.read(payButtonStateProvider.notifier).stopLoading();

    // Customer details come from the queued ticket while settling; don't pop the
    // operator's own capture panel open in that case.
    final settling = ref.read(effectiveSettlingTillTicketProvider) != null;
    if (!settling && !_customerFieldsExpanded && mounted) {
      setState(() => _customerFieldsExpanded = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _customerNameFocusNode.requestFocus();
      });
    }

    if (mounted) showErrorNotification(context, error);
    return false;
  }

  void _prefillCustomerDetails(
    ITransaction transaction, {
    bool force = false,
  }) {
    final name = transaction.customerName?.trim();
    final nameController = ref.read(customerNameControllerProvider);
    if (name != null && name.isNotEmpty) {
      if (force || nameController.text.isEmpty) {
        talker.info('Pre-filling customer name: $name (force=$force)');
        nameController.text = name;
        ProxyService.box.writeString(key: 'customerName', value: name);
      }
    } else if (force) {
      // Settling a ticket with no name must not keep the prior sale's name.
      nameController.clear();
      ProxyService.box.writeString(key: 'customerName', value: '');
    }

    // Never overwrite the field while the cashier is actively typing into it,
    // and never derive a phone via a blind substring (a half-entered "+2507"
    // would otherwise collapse to a single "7" on the printed receipt).
    final phone = transaction.customerPhone?.trim();
    if (phone != null && phone.isNotEmpty) {
      if (!_customerPhoneFocusNode.hasFocus &&
          (force || widget.customerPhoneNumberController.text.isEmpty)) {
        talker.info('Pre-filling customer phone: $phone (force=$force)');
        final local = _localPhoneFromStored(phone);
        widget.customerPhoneNumberController.text = local;
        ProxyService.box.writeString(
          key: 'currentSaleCustomerPhoneNumber',
          value: local,
        );
        ref.read(customerPhoneNumberProvider.notifier).state = local;
      }
    } else if (force) {
      // Forced settling prefill: clear controller + persisted phone so Pay /
      // receipts cannot reuse the previous sale's number.
      widget.customerPhoneNumberController.clear();
      unawaited(
        ProxyService.box.remove(key: 'currentSaleCustomerPhoneNumber'),
      );
      ref.read(customerPhoneNumberProvider.notifier).state = null;
    }

    // Payment initialization is deferred to the builder where items
    // are guaranteed to be loaded. Calling it here with an empty items
    // list would produce total=0 and zero-out the payment field.
  }

  /// Extracts the local subscriber number from a stored customer phone.
  ///
  /// Strips a leading Rwanda country code only when the full code + 9-digit
  /// local number is present (>= 12 digits). Anything shorter is returned as-is
  /// so a partially-entered value such as "+2507" yields "2507" rather than the
  /// single "7" a blind `substring(4)` would produce. This is what previously
  /// printed `TEL: 7` on receipts.
  String _localPhoneFromStored(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 12 && digits.startsWith('250')) {
      widget.countryCodeController.text = '+250';
      return digits.substring(3);
    }
    return digits;
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

  // Cached branch digital-payment lookup for the small-device Pay bar, so the
  // query is not re-issued on every rebuild. Keyed by branch; also dropped after
  // each completed sale so a settings change is still picked up promptly.
  String? _digitalPaymentBranchId;
  Future<bool>? _digitalPaymentEnabledFuture;

  StreamSubscription<WhatsAppOptInPrompt>? _whatsAppOptInSub;
  bool _whatsAppOptInDialogShowing = false;

  /// Collapsed = Search Customer; expanded = Name + Phone (swap, not stack).
  bool _customerFieldsExpanded = false;

  bool _transferBusy = false;
  bool _sendToTillBusy = false;
  bool _backToNewSaleBusy = false;

  // Ensure payment initialization runs once when both transaction & items are ready
  String? _lastPaymentInitTransactionId;
  double? _cachedNonCreditPaid;
  int _nonCreditPaidFetchGen = 0;
  Timer? _customerNamePersistTimer;
  Timer? _customerPhonePersistTimer;
  static const Duration _customerFieldPersistDebounce =
      Duration(milliseconds: 450);

  Future<bool> _digitalPaymentEnabledFor(String branchId) {
    final cached = _digitalPaymentEnabledFuture;
    if (cached != null && _digitalPaymentBranchId == branchId) return cached;
    // [isBranchEnableForPayment] is declared FutureOr<bool>; Future.value accepts
    // either, unlike the previous `as Future<bool>` cast (which would throw on a
    // synchronous implementation).
    final future = Future<bool>.value(
      ProxyService.getStrategy(
        Strategy.capella,
      ).isBranchEnableForPayment(currentBranchId: branchId),
    );
    _digitalPaymentBranchId = branchId;
    _digitalPaymentEnabledFuture = future;
    return future;
  }

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
      _focusCustomerNameAfterAmount();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _handleCustomerNameKey(FocusNode node, KeyEvent event) {
    if (_isPlainEnter(event)) {
      _focusCustomerPhoneAfterName();
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

  /// Enter on the amount field lands on customer name.
  void _focusCustomerNameAfterAmount() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _customerNameFocusNode.requestFocus();
      }
    });
  }

  /// Enter on customer name must skip country picker and land on phone digits.
  void _focusCustomerPhoneAfterName() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _customerPhoneFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    widget.discountController.removeListener(_onDiscountChanged);
    _whatsAppOptInSub?.cancel();
    _customerNamePersistTimer?.cancel();
    _customerPhonePersistTimer?.cancel();
    _receivedAmountSyncTimer?.cancel();
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

    final settling = ref.read(effectiveSettlingTillTicketProvider);
    // Prefer the settling ticket id when present — Pay may have been bound to a
    // stale pending-cart closure before ticketSnapshot loaded.
    final soldId =
        (settling != null && settling.transactionId.isNotEmpty)
            ? settling.transactionId
            : transaction.id;

    if (settling != null) {
      ref.read(settlingTillTicketProvider.notifier).state = null;
      if (soldId.isNotEmpty) {
        ref.read(suppressedCartTransactionIdProvider.notifier).state = soldId;
        clearPinnedPosCartTransactionWidget(ref);
        // Only drop the cache when it still points at the ticket just settled.
        // [markTransactionAsCompleted] has already primed the *next* pending cart
        // into it, and clearing that unconditionally opened exactly the gap the
        // comment below warns about — the header falling back to the stale stream
        // row (old Txn ID).
        final isExpense = ProxyService.box.isOrdering() ?? false;
        final cachedPending = readCachedPendingCartTransactionWidget(
          ref,
          isExpense: isExpense,
        );
        if (cachedPending != null && cachedPending.id == soldId) {
          clearCachedPendingCartTransactionWidget(ref, isExpense: isExpense);
        }
      }
      final total = (transaction.subTotal ?? 0).toCurrencyFormatted(
        symbol: ProxyService.box.defaultCurrency(),
      );
      if (mounted) {
        showSuccessNotification(
          context,
          context.flipperL10n.paymentCollectedTotal(total),
        );
      }
    }

    // No `!` on branchId / businessId: the argument list is evaluated eagerly
    // (only the call is unawaited), so a null here used to throw *after* the
    // sale was marked complete and abort the rest of this cleanup — suppression
    // release and next-pending priming included. `properties` is
    // Map<String, Object?>, so a null value is carried through safely.
    unawaited(
      analytics.track(
        AnalyticsEvents.quickSellCompleted,
        properties: {
          'transaction_id': soldId,
          'branch_id': transaction.branchId,
          'business_id': ProxyService.box.getBusinessId(),
          'created_at': startTime.toIso8601String(),
          'completed_at': endTime.toIso8601String(),
          'duration_seconds': duration,
          'source': 'quick_selling_view',
        },
      ),
    );

    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);

    resetDigitalReceiptToggle(ref);

    if (!mounted) {
      ProxyService.box.writeBool(key: 'transactionCompleting', value: false);
      return;
    }

    final isExpense = ProxyService.box.isOrdering() ?? false;
    final branchId = ProxyService.box.getBranchId() ?? '0';

    // Empty the cart *before* clearing [transactionCompleting] so grid taps
    // stay blocked until the old ticket is suppressed.
    //
    // Do NOT clear the pending-cart cache first — markTransactionAsCompleted
    // already wrote the next pending id there. Clearing creates a gap where the
    // header falls back to the stale stream row (old Txn ID).
    ref.read(suppressedCartTransactionIdProvider.notifier).state = soldId;
    // Resuming a parked ticket pins the cart to it (primePosCartForTransaction),
    // and that pin outranks the pending-cart cache. Left set, the cart resolves
    // straight back to this now-completed sale's still-active lines as soon as
    // suppression is released below — and stays that way until the app restarts,
    // since the pin provider is never disposed. The settling branch above clears
    // its own pin; this covers a plain resume (no till-settling session).
    clearPinnedPosCartTransactionIfWidget(ref, transactionId: soldId);
    clearCartLinesOptimistically();

    ref.read(optimisticCartProvider.notifier).clearForTransaction(soldId);

    // Clear stale cart items for the completed transaction.
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: soldId,
        branchId: branchId,
      ),
    );

    // Reset UI state for the next transaction to prevent stale data
    _lastAutoSetAmount = 0.0;
    _lastPaymentInitTransactionId = null;
    _cachedNonCreditPaid = null;
    // Re-check branch digital-payment config on the next sale (see memo above).
    _digitalPaymentEnabledFuture = null;
    ref.invalidate(paymentMethodsProvider);
    ref.read(optimisticOrderCountProvider.notifier).reset();
    widget.deliveryNoteCotroller.clear();
    widget.receivedAmountController.clear();
    widget.discountController.clear();
    widget.customerPhoneNumberController.clear();
    ref.read(customerNameControllerProvider).clear();

    // Reuse the next pending already primed during mark when present;
    // otherwise mint/resolve one so Txn ID still updates before unlock.
    final cachedNext =
        readCachedPendingCartTransactionWidget(ref, isExpense: isExpense);
    ITransaction? nextPending =
        (cachedNext != null &&
            cachedNext.id.isNotEmpty &&
            cachedNext.id != soldId &&
            cachedNext.status == PENDING)
        ? cachedNext
        : null;
    if (nextPending == null) {
      try {
        nextPending = await ProxyService.getStrategy(Strategy.capella)
            .manageTransaction(
          transactionType:
              isExpense ? TransactionType.purchase : TransactionType.sale,
          isExpense: isExpense,
          branchId: branchId,
        );
      } catch (e, s) {
        tv_talk.talker.error(
          'Failed to prime next pending cart after sale completion',
          e,
          s,
        );
      }
    }
    if (nextPending != null &&
        nextPending.id.isNotEmpty &&
        nextPending.id != soldId &&
        nextPending.status == PENDING) {
      writeCachedPendingCartTransactionWidget(
        ref,
        isExpense: isExpense,
        transaction: nextPending,
      );
      ref
          .read(optimisticCartProvider.notifier)
          .bindPendingTransaction(nextPending.id);
      // Only release suppression once nothing still resolves the cart to the
      // completed sale. A pin surviving here would outrank [nextPending] in the
      // cache, so the sold lines would come straight back.
      final stillPinnedToSold =
          ref.read(pinnedPosCartTransactionIdProvider) == soldId;
      if (!stillPinnedToSold &&
          ref.read(suppressedCartTransactionIdProvider) == soldId) {
        ref.read(suppressedCartTransactionIdProvider.notifier).state = null;
      }
    } else {
      clearCachedPendingCartTransactionWidget(ref, isExpense: isExpense);
    }

    if (ref.read(previewingCart)) {
      ref.read(previewingCart.notifier).state = false;
    }

    if (mounted) {
      setState(() {});
      // Bounded: no frames are produced while the window is backgrounded, and
      // the completion lock below must be released regardless.
      await awaitNextFrameOrSkip();
    }

    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);
  }

  Future<void> _clearTransferCart(
    AsyncValue<ITransaction> transactionAsyncValue,
  ) async {
    final isOrdering = ProxyService.box.isOrdering() ?? false;
    if (isOrdering) return;
    final txn = transactionAsyncValue.asData?.value;
    if (txn == null) return;
    try {
      await ProxyService.getStrategy(
        Strategy.capella,
      ).deleteAllTransactionItems(transactionId: txn.id);
      clearCartLinesOptimistically();
      ref.read(optimisticCartProvider.notifier).clearForTransaction(txn.id);
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: txn.id,
          branchId: ProxyService.box.getBranchId() ?? '0',
        ),
      );
      if (mounted) setState(() {});
    } catch (e, s) {
      tv_talk.talker.error('Failed to clear transfer cart', e, s);
      if (mounted) {
        showErrorNotification(context, context.flipperL10n.failedToClearCart);
      }
    }
  }

  Future<void> _confirmOutgoingTransfer(
    AsyncValue<ITransaction> transactionAsyncValue,
  ) async {
    if (!ref.read(canSellProvider)) {
      showErrorNotification(
        context,
        context.flipperL10n.viewOnlyCannotTransferStock,
      );
      return;
    }
    if (_transferBusy) return;
    final txn = transactionAsyncValue.asData?.value;
    if (txn == null) return;
    final dest = ref.read(transferDestinationBranchProvider);
    if (dest == null) {
      showErrorNotification(context, context.flipperL10n.selectDestinationBranch);
      return;
    }
    final sourceId = ProxyService.box.getBranchId();
    if (sourceId == null || sourceId.isEmpty) {
      showErrorNotification(context, context.flipperL10n.currentBranchIsMissing);
      return;
    }

    final items = ref.read(posCartDisplayItemsProvider);
    if (items.isEmpty) {
      showErrorNotification(context, context.flipperL10n.addItemsBeforeTransferring);
      return;
    }

    setState(() => _transferBusy = true);
    try {
      final service = BranchTransferService();
      await service.confirmBranchTransfer(
        context: context,
        items: items,
        sourceBranchId: sourceId,
        destinationBranchId: dest.id,
        destinationBranchName: dest.name,
      );
      await service.finalizeCartAfterTransfer(
        transaction: txn,
        items: items,
      );

      if (!mounted) return;
      final destName = dest.name ?? 'branch';
      showSuccessNotification(
        context,
        context.flipperL10n.transferredItemsToBranch(items.length, destName),
      );

      ref.read(checkoutCartModeProvider.notifier).state =
          CheckoutCartMode.sale;
      ref.read(transferDestinationBranchProvider.notifier).state = null;
      await _onQuickSellComplete(txn);
    } catch (e, s) {
      tv_talk.talker.error('Outgoing branch transfer failed', e, s);
      if (mounted) {
        showErrorNotification(
          context,
          e is StateError || e is Exception
              ? e.toString().replaceFirst(RegExp(r'^Exception: '), '')
              : context.flipperL10n.transferFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _transferBusy = false);
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
        // While settling a till ticket, customer fields come from that ticket
        // (see settlingTillTicketProvider listen below) — not the collector's
        // own pending cart. Live session only: a *recovered* session's ticket
        // IS this pending row, so prefilling from it is both correct and the
        // only prefill that will run (the listen below never fires for a
        // session that was rebuilt rather than handed over).
        if (ref.read(settlingTillTicketProvider) != null) return;
        // After park/invalidate, Riverpod emits AsyncLoading that still carries
        // the previous parked row. Prefilling from that re-injects the handed-off
        // customer's name/phone onto the next empty cart (seen in production
        // logs right after park).
        if (next.isLoading || !next.hasValue || next.value == null) return;
        final txn = next.value!;
        if ((txn.status ?? '').toLowerCase() != PENDING.toLowerCase()) return;
        final isNewTransaction = previous?.value?.id != txn.id;
        _prefillCustomerDetails(txn, force: isNewTransaction);
        if (isNewTransaction) {
          resetDigitalReceiptToggle(ref);
          _cachedNonCreditPaid = 0.0;
          _lastPaymentInitTransactionId = null;
          _updateReceivedAmountIfNeeded(txn);
        }
      },
    );

    // Till collect: force customer name/phone from the queued ticket so Pay and
    // receipt printing do not keep a previous sale's box/controller values.
    ref.listen<SettlingTillTicket?>(settlingTillTicketProvider, (
      previous,
      next,
    ) {
      if (next == null || next.transactionId.isEmpty) return;
      if (previous?.transactionId == next.transactionId) return;
      // Prefer the snapshot captured at Collect — transactionById can still be
      // loading on the first frame after handoff.
      final snapshot = next.ticketSnapshot;
      if (snapshot != null) {
        _prefillCustomerDetails(snapshot, force: true);
        return;
      }
      final txn = ref.read(transactionByIdProvider(next.transactionId)).value;
      if (txn != null) {
        _prefillCustomerDetails(txn, force: true);
        return;
      }
      unawaited(() async {
        final loaded = await ref.read(
          transactionByIdProvider(next.transactionId).future,
        );
        if (!mounted || loaded == null) return;
        if (ref.read(settlingTillTicketProvider)?.transactionId !=
            next.transactionId) {
          return;
        }
        _prefillCustomerDetails(loaded, force: true);
      }());
    });

    // Payment totals track cart line totals (optimistic taps included).
    // Prefer [posCartPaymentRefreshSignalProvider] over list identity — item-row
    // qty bumps can yield list == equality while the sale total still changes.
    ref.listen<double>(posCartPaymentRefreshSignalProvider, (previous, next) {
      if (previous == next) return;
      // Cart total changed — refresh prior-paid from payment records (do not
      // zero the cache first; that unlocked partial-paid tickets during qty +/-).
      if (previous != null && (previous - next).abs() > 0.01) {
        unawaited(_refetchNonCreditPaidForPendingSale());
      }
      // Optimistic qty +/- already schedules sync; skip stale stream totals.
      if (hasOptimisticLineQtyDrift()) return;
      _scheduleReceivedAmountSync();
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
      final current =
          double.tryParse(widget.receivedAmountController.text.trim());
      if (current != null &&
          totalPaid < current - 0.01 &&
          hasOptimisticLineQtyDrift() &&
          (current - _lastAutoSetAmount).abs() <= 0.01) {
        return;
      }
      if (tenderAmountsMatch(widget.receivedAmountController.text, totalPaid)) {
        return;
      }
      if (totalPaid <= 0.01 && next.isEmpty) {
        if (widget.receivedAmountController.text.isNotEmpty) {
          widget.receivedAmountController.text = '';
        }
        return;
      }
      widget.receivedAmountController.text = formatTenderAmount(totalPaid);
    });

    final isExpense = ProxyService.box.isOrdering() ?? false;
    final basePendingTransaction = ref.watch(
      pendingTransactionStreamProvider(isExpense: isExpense),
    );
    final cachedPending =
        ref.watch(cachedPendingCartTransactionProvider(isExpense));
    // While settling a queued till ticket, drive the whole checkout (summary,
    // payment init, and — critically — completion) from that ticket rather than
    // the collector's own pending cart. Prefer the live row, else the snapshot
    // captured at Collect so Pay never binds to an empty pending twin.
    final settlingTicket = ref.watch(effectiveSettlingTillTicketProvider);
    final settlingTxn = settlingTicket == null
        ? null
        : (ref.watch(transactionByIdProvider(settlingTicket.transactionId)).value ??
            settlingTicket.ticketSnapshot);
    // Rebuild when cart lines change so Pay tracks the txn that owns them.
    ref.watch(posCartDisplayItemsProvider);
    final matched = settlingTicket != null
        ? null
        : _pendingCartMatchingDisplay(
            isExpense: isExpense,
            streamed: basePendingTransaction.value,
            cached: cachedPending,
            listen: true,
          );
    final AsyncValue<ITransaction> transactionAsyncValue;
    if (settlingTicket != null) {
      // Never fall through to the collector's pending cart while settling —
      // that twin-txn race completed the wrong sale / cleared the wrong id.
      transactionAsyncValue = settlingTxn != null
          ? AsyncValue<ITransaction>.data(settlingTxn)
          : const AsyncValue<ITransaction>.loading();
    } else if (matched != null) {
      transactionAsyncValue = AsyncValue<ITransaction>.data(matched);
    } else {
      transactionAsyncValue = basePendingTransaction;
    }
    final attachedCustomerId = transactionAsyncValue.value?.customerId;
    if (attachedCustomerId != null && attachedCustomerId.isNotEmpty) {
      ref.watch(attachedCustomerProvider(attachedCustomerId));
    }
    if (kDebugMode) {
      tv_talk.talker.debug(
        'QuickSellingView.build pending '
        'watch=${_qsvPendingLabel(transactionAsyncValue)}',
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
          overrideAlreadyPaid: _effectiveAlreadyPaid(txn),
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
    final isTransferMode =
        !isOrdering &&
        ref.watch(checkoutCartModeProvider) == CheckoutCartMode.transfer;

    return CustomScrollView(
      slivers: [
        // Ticket-Review queue: reviewers see pending sign-offs at a glance
        // without leaving the sale screen. Self-hides when empty / no access.
        // 16px inset matches the summary card sliver below (EdgeInsets.all(16)).
        const SliverToBoxAdapter(
          child: ReviewQueueBanner(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
          ),
        ),

        // Transaction Summary Header
        SliverToBoxAdapter(
          child: _buildTransactionSummaryCard(transactionAsyncValue, model),
        ),

        SliverToBoxAdapter(child: _buildInvoiceNumber()),

        if (!isOrdering)
          const SliverToBoxAdapter(child: CheckoutModeBar()),

        if (!isOrdering && !isTransferMode)
          SliverToBoxAdapter(child: _buildCompactCustomerCapture()),

        if (!isOrdering && isTransferMode)
          const SliverToBoxAdapter(child: CheckoutTransferBranchRow()),

        // Items Section
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            context.flipperL10n.items,
            Icons.shopping_basket_outlined,
            key: Key('items-section'),
          ),
        ),

        _buildMobileCartItemsSliver(transactionAsyncValue),

        // Customer & Payment Section (sale only; customer capture is above)
        if (!isOrdering && !isTransferMode) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader(
              context.flipperL10n.payment,
              Icons.payment_outlined,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildForm(
                isOrdering,
                transactionId: transactionAsyncValue.value?.id ?? '',
                alreadyPaid: alreadyPaid,
              ),
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
                  '#${_shortTransactionId(transactionAsyncValue.value?.id ?? '')}',
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
    if (!ref.read(canSellProvider)) return; // view-only: no cart edits
    // Real prior payments only — not tender mirrored into cashReceived.
    if (_effectiveAlreadyPaid(transactionAsyncValue.value) > 0.01) {
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
      // No `getBranchId()!`: without an active branch there is nothing sensible
      // to query, so say so instead of throwing out of the button handler.
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null || branchId.isEmpty) {
        if (mounted) {
          showErrorNotification(
            context,
            context.flipperL10n.currentBranchIsMissing,
          );
        }
        return;
      }
      var items = <TransactionItem>[];
      // Lines already deactivated in Capella must stay hidden if a later line
      // in the loop throws — restoring all of them showed items that no longer
      // exist.
      final deactivatedItemIds = <String>{};
      try {
        items = await ref.read(
          transactionItemsStreamProvider(
            transactionId: transactionAsyncValue.value?.id ?? "",
            branchId: branchId,
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
          deactivatedItemIds.add(item.id);
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
              if (deactivatedItemIds.contains(item.id)) continue;
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
          final cartLines = ref.watch(posCartDisplayItemsProvider);
          // A hidden id only means "deleted until the provider catches up", so it
          // must not outlive the line leaving the cart. Resumed tickets come back
          // with the *same* line ids, so a never-pruned set renders them as
          // deleted forever (mirrors [_visibleTransactionItems] in
          // [TransactionItemTable], whose set this one shadows).
          if (_optimisticallyDeletedItemIds.isNotEmpty) {
            final liveIds = cartLines.map((line) => line.id).toSet();
            _optimisticallyDeletedItemIds.removeWhere(
              (id) => !liveIds.contains(id),
            );
          }
          final items = cartLines
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
                          _effectiveAlreadyPaid(
                                transactionAsyncValue.value,
                              ) >
                              0.01
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
                          // `qty - 1` as a double, matching the cart table's
                          // [_decrementQuantity]. `.toInt()` silently dropped the
                          // fraction of a weighed line (2.5 kg → 1, not 1.5).
                          // The `> 1` gate is kept as-is so this button can never
                          // produce a zero-qty line (removal stays on Delete).
                          onPressed: displayQty > 1
                              ? () => _updateQuantity(
                                  item,
                                  displayQty - 1,
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
                              displayQty + 1,
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

    final isTransfer =
        ref.watch(checkoutCartModeProvider) == CheckoutCartMode.transfer;
    if (isTransfer) {
      return SafeArea(
        child: Material(
          elevation: 8,
          color: Theme.of(context).colorScheme.surface,
          child: CheckoutTransferFooter(
            itemCount: ref.watch(posCartDisplayItemsProvider).length,
            busy: _transferBusy,
            onClear: () => _clearTransferCart(transactionAsyncValue),
            onTransfer: () => unawaited(
              _confirmOutgoingTransfer(transactionAsyncValue),
            ),
          ),
        ),
      );
    }

    return Builder(
      builder: (context) {
        final branchAsync = ref.watch(activeBranchProvider);
        return branchAsync.when(
          data: (branch) {
            return FutureBuilder<bool>(
              // Memoized per branch: building this future inline re-ran the
              // BranchPaymentIntegration query (which may hydrate from remote)
              // on *every* rebuild of the bottom bar — i.e. on each cart tap,
              // tender keystroke and payment-signal bump — and flashed
              // digitalPaymentEnabled back to false while each new future
              // resolved. Same call and arguments as before, just cached.
              future: _digitalPaymentEnabledFor(branch.id),
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
                            final payments = ref.watch(paymentMethodsProvider);
                            final paymentAmount = _currentTenderAmount(payments)
                                .toCurrencyFormatted(
                                  symbol: ProxyService.box.defaultCurrency(),
                                );
                            final dueAmount = (_calculateTotal() - alreadyPaid)
                                .toCurrencyFormatted(
                                  symbol: ProxyService.box.defaultCurrency(),
                                );
                            // Listen so Admin → Ticket Review toggle flips
                            // Pay / Send for Review without leaving checkout.
                            return ListenableBuilder(
                              listenable: ProxyService.settings,
                              builder: (context, _) {
                                final ticketReviewWorkflowEnabled =
                                    ProxyService
                                        .settings
                                        .enableTicketReviewWorkflow;
                                final payWording =
                                    (_remainingBalance(alreadyPaid, payments) >
                                        0)
                                    ? context.flipperL10n
                                          .recordPaymentWithAmount(
                                            paymentAmount,
                                          )
                                    : ticketReviewWorkflowEnabled
                                    ? context.flipperL10n
                                          .sendForReviewWithAmount(dueAmount)
                                    : context.flipperL10n.payWithAmount(
                                        dueAmount,
                                      );
                                return PayableView(
                                  transactionId:
                                      transactionAsyncValue.value?.id ?? "",
                                  wording: payWording,
                              mode: SellingMode.forSelling,
                              canCollectPayment:
                                  ref.watch(canCollectPosPaymentProvider),
                              cartHasItems: ref.watch(
                                posCartDisplayItemsProvider.select(
                                  (l) => l.isNotEmpty,
                                ),
                              ),
                              sendToTillBusy: _sendToTillBusy,
                              sendToTill: () {
                                final txn = transactionAsyncValue.value;
                                if (txn == null) return;
                                unawaited(_sendCartToTill(txn));
                              },
                              completeTransaction:
                                  (
                                    immediateCompleteTransaction, [
                                    onPaymentConfirmed,
                                    onPaymentFailed,
                                  ]) async {
                                    talker.warning(
                                      "We are about to complete a sale",
                                    );
                                    if (!_ensureCustomerBeforePay(
                                      transactionAsyncValue.value,
                                    )) {
                                      return false;
                                    }
                                    return transactionAsyncValue.when(
                                      data: (ITransaction transaction) async {
                                        await ProxyService.box.writeBool(
                                          key: 'transactionCompleting',
                                          value: true,
                                        );
                                        bool waitingForPayment = false;
                                        try {
                                          waitingForPayment =
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
                                            attachedCustomerHint:
                                                _attachedCustomerHintFor(
                                                  transaction,
                                                ),
                                            onPaymentConfirmed:
                                                onPaymentConfirmed,
                                            onPaymentFailed: onPaymentFailed,
                                            overrideAlreadyPaid: alreadyPaid,
                                          );
                                        } catch (e) {
                                          await ProxyService.box.writeBool(
                                            key: 'transactionCompleting',
                                            value: false,
                                          );
                                          rethrow;
                                        }
                                        // Release the completion lock on every
                                        // exit that is not "still waiting for a
                                        // digital payment". The flow returns
                                        // false without throwing on its guard
                                        // paths (cart still saving, out of
                                        // stock, cancelled purchase code) —
                                        // left set, the flag makes every later
                                        // cart tap a silent no-op in
                                        // [PosCartAddService].
                                        if (!waitingForPayment) {
                                          await ProxyService.box.writeBool(
                                            key: 'transactionCompleting',
                                            value: false,
                                          );
                                        }
                                        ref
                                                .read(previewingCart.notifier)
                                                .state =
                                            false;
                                        // Per [CompleteTransaction]: true means
                                        // "an out-of-band payment is still
                                        // pending, keep the spinner". This used
                                        // to return an unconditional true —
                                        // meaning "handled" — which left
                                        // [PreviewSaleButton] unable to tell a
                                        // finished sale from one still waiting
                                        // on MoMo, so it could never release
                                        // the spinner itself.
                                        return waitingForPayment;
                                      },
                                      // [PreviewSaleButton] delegates clearing the
                                      // Pay spinner to this callback, so these
                                      // branches must release it themselves.
                                      // Reachable when Pay is tapped while the
                                      // cart's transaction row is still resolving
                                      // (optimistic ghosts already make
                                      // cartHasItems true) — without this the
                                      // spinner never stops.
                                      loading: () async {
                                        ref
                                            .read(
                                              payButtonStateProvider.notifier,
                                            )
                                            .stopLoading();
                                        return false;
                                      },
                                      error: (error, stack) async {
                                        ref
                                            .read(
                                              payButtonStateProvider.notifier,
                                            )
                                            .stopLoading();
                                        return false;
                                      },
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
    if (!ref.read(canSellProvider)) return; // view-only: no cart edits
    // Real prior payments only — not tender mirrored into cashReceived.
    if (_effectiveAlreadyPaid(transactionAsyncValue.value) > 0.01) {
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

  /// [newQty] is a double so weighed lines keep their fraction — the cart table
  /// ([TransactionItemTable]) has always used double qty for the same buttons.
  void _updateQuantity(
    TransactionItem item,
    double newQty,
    AsyncValue<ITransaction> transactionAsyncValue,
  ) async {
    if (!ref.read(canSellProvider)) return; // view-only: no cart edits
    // Real prior payments only — not tender mirrored into cashReceived.
    if (_effectiveAlreadyPaid(transactionAsyncValue.value) > 0.01) {
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

  /// Settling banner + Invoice / Txn / Save ticket. Visuals unchanged; callers
  /// pin this above scroll so it stays visible.
  Widget _buildSharedViewPinnedHeader({
    required AsyncValue<ITransaction> transactionAsyncValue,
    required CoreViewModel model,
  }) {
    // Effective, not live: a resumed ticket whose in-memory settling session was
    // dropped (reload / restart) must still show the banner and its way back.
    final settling = ref.watch(effectiveSettlingTillTicketProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ReviewQueueBanner(),
        if (settling != null) _buildSettlingBanner(settling),
        _buildTopBarCheckoutSummary(
          transactionAsyncValue: transactionAsyncValue,
          model: model,
        ),
      ],
    );
  }

  /// Cart column: checkout summary, mode, customer/branch, items table, optional delivery.
  /// When [pinGrandTotal] is true, the table keeps Grand Total pinned at the
  /// bottom of this pane; parent must provide bounded height ([Expanded]).
  /// The top summary bar is outside the list [ListView] so it stays visible
  /// while line items scroll. Set [includePinnedHeader] false when the parent
  /// already renders [_buildSharedViewPinnedHeader] above a scroll view.
  Widget _buildSharedViewItemsPane({
    required double alreadyPaid,
    required AsyncValue<ITransaction> transactionAsyncValue,
    required CoreViewModel model,
    required bool isOrdering,
    required bool pinGrandTotal,
    required bool isTransferMode,
    bool includePinnedHeader = true,
  }) {
    final settling = ref.watch(effectiveSettlingTillTicketProvider);
    final isSettling = settling != null;
    // View-only staff get a read-only cart table (no price/qty/delete controls).
    final readOnlyCart = isSettling || !ref.watch(canSellProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (includePinnedHeader)
          _buildSharedViewPinnedHeader(
            transactionAsyncValue: transactionAsyncValue,
            model: model,
          ),
        if (!isOrdering)
          CheckoutModeBar(enabled: !isOrdering && !isSettling),
        if (!isOrdering && !isTransferMode && !isSettling && !readOnlyCart) ...[
          _buildCompactCustomerCapture(),
        ],
        if (!isOrdering && isTransferMode) ...[
          const CheckoutTransferBranchRow(),
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
                  readOnly: readOnlyCart,
                  alreadyPaid: alreadyPaid,
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
                readOnly: readOnlyCart,
                alreadyPaid: alreadyPaid,
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

  /// Bounded short/settling pane: pin invoice bar; scroll the rest.
  Widget _buildPinnedHeaderScrollCheckout({
    required BoxConstraints constraints,
    required AsyncValue<ITransaction> transactionAsyncValue,
    required CoreViewModel model,
    required Widget scrollChild,
  }) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
            child: _buildSharedViewPinnedHeader(
              transactionAsyncValue: transactionAsyncValue,
              model: model,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
              child: scrollChild,
            ),
          ),
        ],
      ),
    );
  }

  /// Search Customer OR Name+Phone — mutually exclusive swap (handover).
  Widget _buildCompactCustomerCapture() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 4, 8, 6),
      child: _customerFieldsExpanded
          ? AnimatedBuilder(
              animation: Listenable.merge(
                [_customerNameFocusNode, _customerPhoneFocusNode],
              ),
              builder: (context, _) {
                // Whichever field currently has focus gets more room so it
                // has enough space to be typed into comfortably; the other
                // field yields space to it (swap, not stack).
                final phoneFocused = _customerPhoneFocusNode.hasFocus;
                final nameFraction = phoneFocused ? 0.45 : 0.6;
                final phoneFraction = phoneFocused ? 0.55 : 0.4;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 7.0;
                    const closeButtonWidth = 40.0;
                    final availableWidth =
                        constraints.maxWidth - spacing - closeButtonWidth;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          width: availableWidth * nameFraction,
                          child: _customerNameField(),
                        ),
                        const SizedBox(width: spacing),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          width: availableWidth * phoneFraction,
                          child: _buildCustomerPhoneField(),
                        ),
                        const SizedBox(width: 6),
                        Tooltip(
                          message: context.flipperL10n.close,
                          child: Material(
                            color: const Color(0xFFFDECEC),
                            borderRadius: BorderRadius.circular(9),
                            child: InkWell(
                              onTap: _collapseCustomerFields,
                              borderRadius: BorderRadius.circular(9),
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: const Color(0xFFF3B4B4),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Color(0xFFC0392B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          : Row(
              children: [
                const Expanded(
                  child: SearchInputWithDropdown(embeddedInCheckoutPane: true),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: context.flipperL10n.addCustomer,
                  child: Material(
                    color: PosLayoutBreakpoints.posAccentBlue
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                    child: InkWell(
                      onTap: () {
                        setState(() => _customerFieldsExpanded = true);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            _customerNameFocusNode.requestFocus();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: PosLayoutBreakpoints.posAccentBlue
                                .withValues(alpha: 0.35),
                          ),
                        ),
                        child: const Icon(
                          FluentIcons.person_add_20_regular,
                          size: 18,
                          color: PosLayoutBreakpoints.posAccentBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _collapseCustomerFields() {
    setState(() => _customerFieldsExpanded = false);
    ref.read(customerNameControllerProvider).clear();
    widget.customerPhoneNumberController.clear();
    ProxyService.box.writeString(key: 'customerName', value: '');
    ProxyService.box.writeString(
      key: 'currentSaleCustomerPhoneNumber',
      value: '',
    );
  }

  Widget _buildSharedView(
    double alreadyPaid,
    AsyncValue<ITransaction> transactionAsyncValue,
    bool isSmallDevice,
    bool isOrdering,
    CoreViewModel model,
  ) {
    final isTransferMode =
        !isOrdering &&
        ref.watch(checkoutCartModeProvider) == CheckoutCartMode.transfer;
    // Collecting a till ticket adds a settling banner + invoice/txn row above
    // the cart (see _buildSharedViewItemsPane) that the height heuristic below
    // does not budget for. The "tall pane" branch's payment form is not
    // scrollable on its own, so that extra height can overflow past its
    // Expanded allocation and visually bury the Pay bar (PosDefaultView renders
    // it as a fixed sibling below QuickSellingView, so it is never literally
    // missing — just painted over). Force the scrollable fallback here so the
    // whole pane scrolls instead of overflowing.
    final isSettling = ref.watch(effectiveSettlingTillTicketProvider) != null;

    final pinnedBottomColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isOrdering && !isTransferMode) ...[
          _buildForm(
            isOrdering,
            transactionId: transactionAsyncValue.value?.id ?? "",
            alreadyPaid: alreadyPaid,
          ),
        ],
        if (!isOrdering && isTransferMode) ...[
          CheckoutTransferFooter(
            itemCount: ref.watch(posCartDisplayItemsProvider).length,
            busy: _transferBusy,
            onClear: () => _clearTransferCart(transactionAsyncValue),
            onTransfer: () => unawaited(
              _confirmOutgoingTransfer(transactionAsyncValue),
            ),
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
                  isTransferMode: isTransferMode,
                ),
                if (!isOrdering) ...[
                  const SizedBox(height: 12),
                  pinnedBottomColumn,
                ],
              ],
            ),
          );
        }

        // Phone landscape and other short panels (or the taller settling
        // banner eating into the same budget): pin invoice/Save ticket, scroll
        // the rest so the Pay bar stays reachable without burying the header.
        if (isSettling ||
            PosLayoutBreakpoints.useSingleScrollCheckoutPane(
              constraints.maxHeight,
            )) {
          if (isOrdering) {
            return _buildPinnedHeaderScrollCheckout(
              constraints: constraints,
              transactionAsyncValue: transactionAsyncValue,
              model: model,
              scrollChild: _buildSharedViewItemsPane(
                alreadyPaid: alreadyPaid,
                transactionAsyncValue: transactionAsyncValue,
                model: model,
                isOrdering: isOrdering,
                pinGrandTotal: false,
                isTransferMode: isTransferMode,
                includePinnedHeader: false,
              ),
            );
          }
          return _buildPinnedHeaderScrollCheckout(
            constraints: constraints,
            transactionAsyncValue: transactionAsyncValue,
            model: model,
            scrollChild: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSharedViewItemsPane(
                  alreadyPaid: alreadyPaid,
                  transactionAsyncValue: transactionAsyncValue,
                  model: model,
                  isOrdering: isOrdering,
                  pinGrandTotal: false,
                  isTransferMode: isTransferMode,
                  includePinnedHeader: false,
                ),
                const SizedBox(height: 12),
                pinnedBottomColumn,
              ],
            ),
          );
        }

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
                isTransferMode: isTransferMode,
              ),
            ),
          );
        }

        // Tall pane: only line items scroll; form/footer is intrinsic height.
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: _buildSharedViewItemsPane(
                    alreadyPaid: alreadyPaid,
                    transactionAsyncValue: transactionAsyncValue,
                    model: model,
                    isOrdering: isOrdering,
                    pinGrandTotal: true,
                    isTransferMode: isTransferMode,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: pinnedBottomColumn,
              ),
            ],
          ),
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
          // Handle Ctrl+Enter or Cmd+Enter to complete sale (till roles only)
          if ((HardwareKeyboard.instance.isControlPressed ||
                  HardwareKeyboard.instance.isMetaPressed) &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (!ref.read(canCollectPosPaymentProvider)) return;
            // Trigger complete sale action — settle the till ticket when one is
            // being collected, else the operator's own pending cart.
            final activeTxn = _activeCheckoutTransaction();
            // ref.read, not ref.watch: outside build, watch registers a
            // subscription that outlives this callback and forces a rebuild on
            // every emission (Riverpod tears it down again on the next build).
            // Both providers are already watched by build(), so the value is the
            // same snapshot.
            final transactionAsyncValue = activeTxn != null
                ? AsyncValue<ITransaction>.data(activeTxn)
                : ref.read(
                    pendingTransactionStreamProvider(
                      isExpense: ProxyService.box.isOrdering() ?? false,
                    ),
                  );
            transactionAsyncValue.whenData((ITransaction transaction) {
              if (!_ensureCustomerBeforePay(transaction)) return;
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
                bool waitingForPayment = false;
                try {
                  waitingForPayment = await startCompleteTransactionFlow(
                    immediateCompletion: false,
                    completeTransaction: () async {
                      await _onQuickSellComplete(transaction);
                    },
                    transactionId: transaction.id,
                    transactionHint: transaction,
                    transactionItemsHint: transactionItemsHint,
                    // ref.read: this runs after an await, where ref.watch would
                    // also leave a stray subscription behind (see above).
                    paymentMethods: ref.read(paymentMethodsProvider),
                    attachedCustomerHint: _attachedCustomerHintFor(transaction),
                    overrideAlreadyPaid: _effectiveAlreadyPaid(
                      transactionAsyncValue.value,
                    ),
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
                  return;
                }
                // See the Pay-button path: only a pending digital payment may
                // keep the completion lock — or the spinner — held past this
                // point. This path has no [PreviewSaleButton] to release it.
                if (!waitingForPayment) {
                  await ProxyService.box.writeBool(
                    key: 'transactionCompleting',
                    value: false,
                  );
                  if (mounted) {
                    loadingNotifier.stopLoading(ButtonType.pay);
                  }
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
              _focusCustomerNameAfterAmount();
            } else if (_customerNameFocusNode.hasFocus && !isOrdering) {
              _focusCustomerPhoneAfterName();
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
            // Payment section only — customer capture lives above the cart list.
            // Staff cannot tender; till roles keep the existing controls.
            if (!isOrdering && ref.watch(canCollectPosPaymentProvider)) ...[
              _buildBalanceDueBanner(alreadyPaid),
              _buildDigitalReceiptToggle(),
              _buildReceivedAmountField(
                transactionId: transactionId,
                alreadyPaid: alreadyPaid,
              ),
              const SizedBox(height: 10.0),
              _buildPaymentRow(isOrdering, transactionId, alreadyPaid),
            ] else if (!isOrdering) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                child: Text(
                  context.flipperL10n.paymentsCollectedAtTill,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey[600],
                    height: 1.35,
                  ),
                ),
              ),
            ],
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
        final saleTotal = _checkoutSaleTotal();
        final finalPayable = (saleTotal - alreadyPaid).clamp(
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
          child: Material(
            color: Colors.white,
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
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
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _focusCustomerNameAfterAmount(),
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
        suffix: Text(
          ProxyService.box.defaultCurrency(),
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        onChanged: (value) => setState(() {
          final receivedAmount = double.tryParse(value);
          if (receivedAmount == null) {
            ProxyService.box.writeDouble(key: 'getCashReceived', value: 0.0);
            return;
          }
          // Field text is already [value]; only sync payments + box.
          ProxyService.box.writeDouble(
            key: 'getCashReceived',
            value: receivedAmount,
          );
          final payments = ref.read(paymentMethodsProvider);
          if (payments.isEmpty) return;
          final payment = payments[0];
          final text = receivedAmount.toString();
          if (payment.controller.text != text) {
            payment.controller.text = text;
          }
          if ((payment.amount - receivedAmount).abs() <= 0.01) return;
          ref
              .read(paymentMethodsProvider.notifier)
              .updatePaymentMethod(
                0,
                Payment(
                  amount: receivedAmount,
                  method: payment.method,
                  id: payment.id,
                  controller: payment.controller,
                ),
                transactionId: transactionId,
              );
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

  void _schedulePersistCustomerName(String value) {
    _customerNamePersistTimer?.cancel();
    _customerNamePersistTimer = Timer(_customerFieldPersistDebounce, () {
      if (!mounted) return;
      unawaited(_persistCustomerNameToPendingTransaction(value));
    });
  }

  Future<void> _persistCustomerNameToPendingTransaction(String value) async {
    if (_skipLiveCustomerCapellaPersistDuringSaleCompletion()) return;
    try {
      final transactionAsync = ref.read(
        pendingTransactionStreamProvider(
          isExpense: ProxyService.box.isOrdering() ?? false,
        ),
      );
      final transaction = transactionAsync.asData?.value;
      if (transaction != null && transaction.id.isNotEmpty) {
        await ProxyService.getStrategy(Strategy.capella).updateTransaction(
          transaction: transaction,
          customerName: value,
        );
      }
    } catch (e, s) {
      talker.error(
        'Failed to update transaction with customer name',
        e,
        s,
      );
    }
  }

  void _schedulePersistCustomerPhone(String value) {
    _customerPhonePersistTimer?.cancel();
    _customerPhonePersistTimer = Timer(_customerFieldPersistDebounce, () {
      if (!mounted) return;
      unawaited(_persistCustomerPhoneToPendingTransaction(value));
    });
  }

  Future<void> _persistCustomerPhoneToPendingTransaction(String value) async {
    if (_skipLiveCustomerCapellaPersistDuringSaleCompletion()) return;
    try {
      final transactionAsync = ref.read(
        pendingTransactionStreamProvider(
          isExpense: ProxyService.box.isOrdering() ?? false,
        ),
      );
      final transaction = transactionAsync.asData?.value;
      if (transaction != null && transaction.id.isNotEmpty) {
        await ProxyService.getStrategy(Strategy.capella).updateTransaction(
          transaction: transaction,
          // Persist the bare local number — the same shape that
          // `box` and sale completion store. Prefixing the
          // country code here produced "+250<partial>" values
          // that later got mis-stripped to a single digit on
          // the printed receipt.
          customerPhone: value,
        );
      }
    } catch (e, s) {
      talker.error(
        'Failed to update transaction with customer phone',
        e,
        s,
      );
    }
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
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _focusCustomerPhoneAfterName(),
        maxLines: 1,
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
        onChanged: (value) {
          // Store the customer name with the exact key expected by rw_tax.dart
          ProxyService.box.writeString(key: 'customerName', value: value);

          // For debugging
          talker.info('Customer name set to: $value');

          _schedulePersistCustomerName(value);
        },
      ),
    );
  }

  Widget _buildCustomerPhoneField() {
    const accent = PosLayoutBreakpoints.posAccentBlue;

    return Semantics(
      label: context.flipperL10n.customerPhoneNumber,
      hint: context.flipperL10n.customerPhoneNumberHint,
      child: ListenableBuilder(
        listenable: _customerPhoneFocusNode,
        builder: (context, _) {
          final focused = _customerPhoneFocusNode.hasFocus;
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: focused ? accent : const Color(0xFFE5E7EB),
                width: focused ? 2 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ExcludeFocus(
                  child: CountryCodePicker(
                    onChanged: (countryCode) {
                      widget.countryCodeController.text =
                          countryCode.dialCode!;
                    },
                    initialSelection: 'RW',
                    favorite: const ['+250', 'RW'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    showDropDownButton: false,
                    alignLeft: false,
                    padding: EdgeInsets.zero,
                    flagWidth: 22,
                    builder: (country) {
                      final dialCode = country?.dialCode ?? '+250';
                      final flagUri = country?.flagUri;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (flagUri != null)
                              Image.asset(
                                flagUri,
                                package: 'country_code_picker',
                                width: 22,
                              ),
                            const SizedBox(width: 6),
                            Text(
                              dialCode,
                              style: const TextStyle(
                                color: accent,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: const Color(0xFFE5E7EB),
                ),
                Expanded(
                  child: StyledTextFormField.create(
                    context: context,
                    labelText: null,
                    hintText: context.flipperL10n.phoneNumber,
                    controller: widget.customerPhoneNumberController,
                    focusNode: _customerPhoneFocusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      final isOrdering = ProxyService.box.isOrdering() ?? false;
                      if (isOrdering) {
                        _deliveryNoteFocusNode.requestFocus();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    maxLines: 1,
                    minLines: 1,
                    borderless: true,
                    fillColor: Colors.transparent,
                    hintColor: const Color(0xFF6B7280),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    suffixIcon: const Icon(
                      FluentIcons.call_20_regular,
                      color: accent,
                    ),
                    onChanged: (value) {
                      ProxyService.box.writeString(
                        key: 'currentSaleCustomerPhoneNumber',
                        value: value,
                      );

                      talker.info('Customer phone set to: $value');

                      _schedulePersistCustomerPhone(value);
                    },
                    // Phone is required only when no TIN is on file (same rule as
                    // [missingCustomerDetailsForPay]).
                    //
                    // No format check on a non-empty value: this field is paired
                    // with a [CountryCodePicker], so the national number shape is
                    // country-dependent and the Rwanda-only `^[1-9]\d{8}$` rule
                    // used by bar-mode settle (which has no picker) would block
                    // Pay for any non-RW number. The previous
                    // `value.isEmpty` + regex branch never validated a typed
                    // number at all — it only fired on an *empty* field, which
                    // returned "invalid number" and blocked completion for a
                    // customer who legitimately has a TIN and no phone.
                    validator: (String? value) {
                      final customerTin = ProxyService.box.customerTin();

                      if ((customerTin == null || customerTin.isEmpty) &&
                          (value == null || value.isEmpty)) {
                        ref.read(payButtonStateProvider.notifier).stopLoading();
                        return context.flipperL10n.phoneRequiredWhenTinMissing;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showParkDialog(
    ITransaction transaction,
    CoreViewModel model,
  ) async {
    if (!ref.read(canSellProvider)) return; // view-only: cannot park a sale
    // Keep the identity of the transaction the checkout is acting on — the
    // settling till ticket, else the pending row that owns the on-screen lines
    // (see [_pendingCartMatchingDisplay]). Only swap in a fresher row for the
    // SAME id. Reading the pending stream unconditionally (with a hardcoded
    // `isExpense: false`) parked the collector's own pending cart while settling,
    // the sale cart while in ordering mode, and a freshly minted empty twin
    // during a twin-txn race — in each case with the visible cart's total
    // written onto the wrong row via [displayAmount].
    final isExpense = ProxyService.box.isOrdering() ?? false;
    final streamedPending = ref
        .read(pendingTransactionStreamProvider(isExpense: isExpense))
        .value;
    final txn =
        (streamedPending != null && streamedPending.id == transaction.id)
        ? streamedPending
        : transaction;
    var parked = false;
    // transaction.subTotal is a persisted/streamed snapshot that can lag
    // behind optimistic cart edits and discounts — pass the live sale total
    // (same source the checkout screen renders) so the dialog never shows a
    // different amount than what the operator just saw.
    await showSharedTicketDialog(
      context: context,
      transaction: txn,
      displayAmount: totalAfterDiscountAndShipping,
      onParked: () => parked = true,
    );
    if (!parked || !mounted) return;

    // [showSharedTicketDialog] parks through [ParkTransactionService] directly,
    // bypassing [parkTransactionProvider] — so the badge/list refresh that
    // provider performs (for when the Ditto observer misses the first onChange)
    // has to happen here, or a just-parked ticket can be missing from Tickets.
    ref.invalidate(ticketsStreamProvider);

    // Unlike mobile checkout — which navigates away to the tickets list right
    // after parking — this view stays put, so the handed-off lines must be
    // cleared locally. parkSaleTicketFast mints the replacement pending cart
    // unawaited, so waiting on the pending stream leaves the parked ticket
    // rendered as the cart for as long as Ditto takes to reconcile.
    final settling = ref.read(effectiveSettlingTillTicketProvider);
    if (settling != null) {
      // A settling session scopes posCartDisplayItemsProvider straight to the
      // ticket's item stream, which outranks every clear below.
      ref.read(settlingTillTicketProvider.notifier).state = null;
      clearPinnedPosCartTransactionIfWidget(
        ref,
        transactionId: settling.transactionId,
      );
    }
    _clearCartAfterTicketHandoff(txn);
    if (ref.read(previewingCart)) {
      ref.read(previewingCart.notifier).state = false;
    }
    setState(() {});
  }

  /// Same-frame local reset for a cart that just left this device — parked as a
  /// ticket or sent to the till. The pending-cart cache, the resume pin and the
  /// optimistic ghosts all still point at [transaction] after the park lands in
  /// Ditto, so without this the cart keeps rendering the handed-off lines (and
  /// the next sale inherits its customer and tender fields).
  void _clearCartAfterTicketHandoff(ITransaction transaction) {
    // Ordering mode keeps its pending cart under the purchase key, so a
    // hardcoded `isExpense: false` cleared/invalidated the sale side and left
    // the handed-off purchase lines rendering.
    final isExpense = ProxyService.box.isOrdering() ?? false;
    ref.read(suppressedCartTransactionIdProvider.notifier).state =
        transaction.id;
    // A resumed ticket handed off again leaves its pin behind. Since the pin
    // wins over the (just-cleared) cache, the suppression above would then
    // blank *every* later cart too — new taps write to the next pending id
    // while the display still resolves the suppressed, pinned one.
    clearPinnedPosCartTransactionIfWidget(ref, transactionId: transaction.id);
    clearCartLinesOptimistically();
    ref
        .read(optimisticCartProvider.notifier)
        .clearForTransaction(transaction.id);
    clearCachedPendingCartTransactionWidget(
      ref,
      isExpense: isExpense,
    );
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transaction.id,
        branchId: ProxyService.box.getBranchId() ?? '0',
      ),
    );
    _resetCheckoutFieldsAfterHandoff();
    ref.invalidate(pendingTransactionStreamProvider(isExpense: isExpense));
  }

  /// Tender / discount / customer fields for a cart that just left this device.
  ///
  /// Shared by [_clearCartAfterTicketHandoff] and the fallback branch of
  /// [_backToNewSaleFromSettling] (which reached this point with no resolved
  /// transaction and therefore used to leave the ticket's customer name, phone
  /// and tender behind for the next sale). Name/phone live in controllers *and*
  /// persisted box keys — mirrors [_collapseCustomerFields].
  void _resetCheckoutFieldsAfterHandoff() {
    // Cancel debounced Capella writes so the parked ticket's customer name /
    // phone cannot land on the newly minted empty pending cart and later be
    // promoted by resume cleanup into a mystery till ticket.
    _customerNamePersistTimer?.cancel();
    _customerNamePersistTimer = null;
    _customerPhonePersistTimer?.cancel();
    _customerPhonePersistTimer = null;
    _lastAutoSetAmount = 0.0;
    _lastPaymentInitTransactionId = null;
    _cachedNonCreditPaid = null;
    ref.invalidate(paymentMethodsProvider);
    widget.receivedAmountController.clear();
    widget.discountController.clear();
    ref.read(customerNameControllerProvider).clear();
    widget.customerPhoneNumberController.clear();
    ProxyService.box.writeString(key: 'customerName', value: '');
    ProxyService.box.writeString(
      key: 'currentSaleCustomerPhoneNumber',
      value: '',
    );
  }

  Future<void> _sendCartToTill(ITransaction transaction) async {
    if (!ref.read(canSellProvider)) return; // view-only: cannot send to till
    if (_sendToTillBusy) return;
    final items = ref.read(posCartDisplayItemsProvider);
    if (items.isEmpty) return;

    setState(() => _sendToTillBusy = true);
    final displayRef = _ticketDisplayRef(transaction);
    // [transaction] is the object held by the pending-cart cache / Ditto stream,
    // so a subTotal written for the park below must be rolled back if the park
    // fails — otherwise provider state keeps a total that was never persisted.
    final previousSubTotal = transaction.subTotal;
    var didOverrideSubTotal = false;
    try {
      // Same staleness guard as the Save Ticket dialog: transaction.subTotal
      // can lag behind an in-flight optimistic qty edit, and a merge into an
      // existing ticket for this customer trusts this field directly.
      final liveTotal = totalAfterDiscountAndShipping;
      if (liveTotal > 0) {
        transaction.subTotal = liveTotal;
        didOverrideSubTotal = true;
      }
      await ref.read(parkTransactionProvider.notifier).park(
            ticketName: 'Till · $displayRef',
            ticketNote: 'Sent to till for payment',
            transaction: transaction,
            customerId: transaction.customerId,
          );

      _clearCartAfterTicketHandoff(transaction);

      if (mounted) {
        showSuccessNotification(
          context,
          context.flipperL10n.sentToTillTicket(displayRef),
        );
      }
    } catch (e, st) {
      if (didOverrideSubTotal) {
        transaction.subTotal = previousSubTotal;
      }
      tv_talk.talker.error('Send to till failed: $e', st);
      if (mounted) {
        showErrorNotification(
          context,
          context.flipperL10n.failedToSendToTill(e.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _sendToTillBusy = false);
    }
  }

  Future<void> _backToNewSaleFromSettling() async {
    if (_backToNewSaleBusy) return;
    // Matches the banner: works for a session rebuilt from the resumed ticket
    // as well as a live Collect hand-off.
    final settling = ref.read(effectiveSettlingTillTicketProvider);
    if (settling == null) return;

    setState(() => _backToNewSaleBusy = true);
    final branchId = ProxyService.box.getBranchId() ?? '';
    try {
      // Collect forces its snapshot to PENDING at hand-off; a recovered
      // snapshot is only as fresh as the cart row it came from, so re-read the
      // row before parking on it.
      ITransaction? txn = settling.recovered ? null : settling.ticketSnapshot;
      try {
        txn ??= await ProxyService.getStrategy(Strategy.capella).getTransaction(
          id: settling.transactionId,
          branchId: branchId,
        );
        if (txn != null &&
            (txn.status ?? '').toLowerCase() == PENDING.toLowerCase()) {
          await ref.read(parkTransactionProvider.notifier).park(
                ticketName: pendingSaleCartReparkTicketName(
                  id: settling.transactionId,
                  ticketName: settling.ticketName,
                  customerName: settling.ticketSnapshot?.customerName ??
                      txn.customerName,
                  reference: settling.displayRef,
                ),
                ticketNote: settling.ticketNote ?? 'Sent to till for payment',
                transaction: txn,
                customerId: txn.customerId,
              );
        }
      } catch (e, st) {
        tv_talk.talker.error('Back to new sale re-park failed: $e', st);
        if (mounted) {
          showErrorNotification(
            context,
            'Could not return this ticket to the till. Please try again.',
          );
        }
        // Keep settling set — clearing here orphans a PENDING till ticket.
        return;
      }

      ref.read(settlingTillTicketProvider.notifier).state = null;
      // Same handoff clear as Park / Send-to-till so the re-parked ticket's
      // lines (and pin/suppress) cannot linger on the next empty cart.
      if (txn != null) {
        _clearCartAfterTicketHandoff(txn);
      } else {
        clearPinnedPosCartTransactionWidget(ref);
        clearCartLinesOptimistically();
        ref.read(suppressedCartTransactionIdProvider.notifier).state =
            settling.transactionId;
        ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
        // The ticket row never resolved, so the handoff clear above was skipped —
        // without this the collected ticket's customer/tender carried into the
        // operator's next sale.
        _resetCheckoutFieldsAfterHandoff();
      }
      // Collect forced the full cart view; return to the normal catalog view.
      if (ref.read(previewingCart)) {
        ref.read(previewingCart.notifier).state = false;
      }
    } finally {
      if (mounted) setState(() => _backToNewSaleBusy = false);
    }
  }

  Widget _buildSettlingBanner(SettlingTillTicket settling) {
    final mins = _minutesAgo(settling.createdAt);
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFEEF3FF),
          borderRadius: BorderRadius.circular(PosTokens.radiusSm),
          border: Border.all(color: const Color(0xFFC7D8FF)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.flipperL10n.collectingPaymentForTicket(
                    settling.displayRef,
                    settling.creatorName,
                    mins.toString(),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: _backToNewSaleBusy
                    ? null
                    : () => unawaited(_backToNewSaleFromSettling()),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1D4ED8),
                  disabledForegroundColor:
                      const Color(0xFF1D4ED8).withValues(alpha: 0.6),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: _backToNewSaleBusy
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.flipperL10n.returningEllipsis,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '✕ ${context.flipperL10n.backToNewSale}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
