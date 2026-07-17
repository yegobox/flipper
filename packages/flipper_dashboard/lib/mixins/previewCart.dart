// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/utils/sale_completion_budget.dart';
import 'package:flipper_models/helperModels/sale_cart_qty_rows.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';

import 'package:flipper_dashboard/PurchaseCodeForm.dart';
import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flipper_dashboard/providers/digital_receipt_provider.dart';
// ignore: unused_import
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/digital_receipt_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flipper_dashboard/utils/sale_agent_completion.dart';
import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_dashboard/utils/stock_validator.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/pending_cart_sale_session_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:supabase_models/services/turbo_tax_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_dashboard/transaction_report_cashier_profile.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/models/user.model.dart' as brick_user;
import 'package:supabase_models/brick/repository.dart';

// Stock validation functions have been moved to utils/stock_validator.dart

/// Fetches transaction items for the given transaction ID.
///
/// Reads with the transaction's own branch so a till ticket collected from the
/// queue resolves against the branch its line items were saved in (matches the
/// scoped read in [posCartDisplayItemsProvider]); falls back to the active
/// branch for a normal in-branch cart.
Future<List<TransactionItem>> _getTransactionItems({
  required ITransaction transaction,
}) async {
  final branchId =
      (transaction.branchId != null && transaction.branchId!.isNotEmpty)
          ? transaction.branchId!
          : ProxyService.box.getBranchId()!;
  final items = await ProxyService.getStrategy(Strategy.capella)
      .transactionItems(
        branchId: branchId,
        transactionId: transaction.id,
        doneWithTransaction: false,
        active: true,
      );
  return items;
}

const _cartPersistPollMs = 100;
const _cartPersistMaxWaitMs = 8000;

Map<String, double> _checkoutCartQtyByVariant(WidgetRef ref) {
  return saleLineQtyByVariantId(
    saleCartQtyRowsFromTransactionItems(ref.read(posCartDisplayItemsProvider)),
  );
}

/// Waits until Ditto line qtys match what checkout displays (authoritative read).
Future<List<TransactionItem>?> _pollPersistedCartForDisplay({
  required WidgetRef ref,
  required ITransaction transaction,
  required String transactionId,
}) async {
  final deadline = DateTime.now().add(
    const Duration(milliseconds: _cartPersistMaxWaitMs),
  );
  final cartNotifier = ref.read(optimisticCartProvider.notifier);

  while (DateTime.now().isBefore(deadline)) {
    final checkoutQty = _checkoutCartQtyByVariant(ref);
    if (checkoutQty.isEmpty) {
      await Future<void>.delayed(
        const Duration(milliseconds: _cartPersistPollMs),
      );
      continue;
    }

    final ditto = await _getTransactionItems(transaction: transaction);
    cartNotifier.reconcileFromPersistedItems(
      transactionId: transactionId,
      items: ditto,
    );

    final dittoQty = saleLineQtyByVariantId(
      saleCartQtyRowsFromTransactionItems(ditto),
    );
    if (saleLineQtyMapsMatch(checkoutQty, dittoQty)) {
      return ditto;
    }

    await Future<void>.delayed(
      const Duration(milliseconds: _cartPersistPollMs),
    );
  }
  return null;
}

/// Resolves cart lines for Pay / RRA sign after [_pollPersistedCartForDisplay].
Future<List<TransactionItem>> _resolveTransactionItemsForCompletion({
  required ITransaction transaction,
  required String transactionId,
  List<TransactionItem>? hint,
  required List<TransactionItem> persistedCart,
}) async {
  if (hint != null &&
      hint.isNotEmpty &&
      hint.every((i) => i.transactionId == transactionId) &&
      saleLineQtyMapsMatch(
        saleLineQtyByVariantId(saleCartQtyRowsFromTransactionItems(hint)),
        saleLineQtyByVariantId(
          saleCartQtyRowsFromTransactionItems(persistedCart),
        ),
      )) {
    return List<TransactionItem>.from(hint);
  }
  return persistedCart;
}

const double _tenderEpsilon = 0.0001;

/// Tender lines for completion, reading controller text when [Payment.amount] is unset.
List<PaymentLineForSaleCompletion> paymentLinesForSaleCompletion(
  List<Payment> paymentMethods,
) {
  return paymentMethods
      .map((p) {
        var amt = p.amount;
        if (amt <= _tenderEpsilon) {
          amt = double.tryParse(p.controller.text.trim()) ?? 0.0;
        }
        return PaymentLineForSaleCompletion(amount: amt, method: p.method);
      })
      .toList();
}

double sumTenderFromPaymentMethods(List<Payment> paymentMethods) {
  final sum = paymentLinesForSaleCompletion(paymentMethods)
      .fold<double>(0, (s, p) => s + p.amount);
  return sum > _tenderEpsilon ? sum : 0.0;
}

/// Resolves how much tender was received when the dedicated "received amount"
/// field is empty or stale (e.g. mobile checkout only updates payment rows, or
/// QuickSellingView auto-filled the received field to the full total while the
/// user underpaid on [PaymentMethodsCard]).
///
/// Also ignores a stale over-tender in payment methods when the field was
/// auto-filled back to the sale total (delete/re-add or cart total change).
double resolveTenderAmountForSaleCompletion({
  required TextEditingController receivedAmountController,
  required List<Payment> paymentMethods,
  required double saleTotal,
}) {
  final fromPayments = sumTenderFromPaymentMethods(paymentMethods);
  final fromReceived =
      double.tryParse(receivedAmountController.text.trim()) ?? 0.0;

  if (fromPayments > _tenderEpsilon && fromReceived > _tenderEpsilon) {
    // Field matches sale total but payment methods still hold a prior tender
    // (e.g. change amount from before the line was deleted and re-added).
    if ((fromReceived - saleTotal).abs() <= _tenderEpsilon &&
        fromPayments > fromReceived + _tenderEpsilon) {
      return fromReceived;
    }
    // Prefer payment rows when the user underpaid there while the field still
    // shows the auto-filled full total.
    return fromPayments;
  }

  if (fromPayments > _tenderEpsilon) return fromPayments;
  if (fromReceived > _tenderEpsilon) return fromReceived;

  return saleTotal > _tenderEpsilon ? saleTotal : 0.0;
}

mixin PreviewCartMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, TransactionMixinOld, TextEditingControllersMixin {
  // Store stream subscription for proper cleanup
  StreamSubscription? _paymentStatusSubscription;
  RealtimeChannel? _paymentStatusChannel;

  // Store timer reference for proper cleanup
  Timer? _paymentTimeout;

  // Track if we're already processing a payment to prevent double-processing
  bool _isProcessingPayment = false;

  /// Queues SMS after PDF upload when the digital-receipt toggle is on.
  /// Branch SMS is already required for the toggle to be shown in Quick Selling.
  Future<bool> resolveSendDigitalReceipt(String transactionId) async {
    if (!ref.read(digitalReceiptToggleProvider)) return false;
    await DigitalReceiptService.queueSmsAfterReceiptUpload(transactionId);
    return true;
  }

  void _resetDigitalReceiptToggleAfterSale() {
    if (!mounted) return;
    resetDigitalReceiptToggle(ref);
  }

  Future<void> _invokeCompleteTransactionCallback(Function callback) async {
    final result = callback();
    if (result is Future) await result;
  }

  @override
  void dispose() {
    // Cancel timer to prevent it from running after widget disposal
    _paymentTimeout?.cancel();
    _paymentStatusSubscription?.cancel();
    _paymentStatusChannel?.unsubscribe();
    super.dispose();
  }

  /// this method will either preview or completeOrder
  Future<void> placeFinalOrder({
    bool isShoppingFromWareHouse = true,
    required ITransaction transaction,
    required FinanceProvider financeOption,
  }) async {
    if (!isShoppingFromWareHouse) {
      /// here we just navigate to Quick setting to preview what's on cart
      /// just return as nothing to be done.
      return;
    }

    /// the code is reviewing the cart while shopping as external party e.g a sub branch
    /// shopping to main warehouse

    try {
      String deliveryNote = deliveryNoteCotroller.text;

      final items = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
            branchId: ProxyService.box.getBranchId()!,
            transactionId: transaction.id,
            doneWithTransaction: false,
            active: true,
          );

      /// previewingCart start with state false then if is true then we are previewing stop completing the order
      if (items.isEmpty) {
        // ref.read(toggleProvider.notifier).state = false;
        return;
      }

      final supplier = ref.read(selectedSupplierProvider);
      if (supplier == null || supplier.serverId == null) {
        throw Exception('Please select a supplier first.');
      }

      // ignore: unused_local_variable
      String orderId = await ProxyService.getStrategy(Strategy.capella)
          .createStockRequest(
            items,
            mainBranchId: supplier.id,
            subBranchId: ProxyService.box.getBranchId()!,
            deliveryNote: deliveryNote,
            orderNote: null,
            financingId: financeOption.id,
          );
      await _markItemsAsDone(items, transaction);
      await _changeTransactionStatus(transaction: transaction);
      await _refreshTransactionItems(transactionId: transaction.id);
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  FutureOr<void> _changeTransactionStatus({
    required ITransaction transaction,
  }) async {
    await ProxyService.getStrategy(
      Strategy.capella,
    ).updateTransaction(transaction: transaction, status: ORDERING);
  }

  Future<void> _markItemsAsDone(
    List<TransactionItem> items,
    dynamic pendingTransaction,
  ) async {
    await ProxyService.getStrategy(
      Strategy.capella,
    ).markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      ignoreForReport: false,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _refreshTransactionItems({required String transactionId}) async {
    ref.refresh(transactionItemsProvider(transactionId: transactionId));
  }

  Future<void> applyDiscount(ITransaction transaction) async {
    // get items on cart
    final items = await ProxyService.getStrategy(Strategy.capella)
        .transactionItems(
          branchId: ProxyService.box.getBranchId()!,
          transactionId: transaction.id,
          doneWithTransaction: false,
          active: true,
        );

    double discountRate = double.tryParse(discountController.text) ?? 0;
    if (discountRate <= 0) return;

    double itemsTotal = 0;

    // Calculate total amount before discount
    for (var item in items) {
      itemsTotal += (item.price.toDouble() * item.qty.toDouble());
    }

    if (itemsTotal <= 0) return;

    // Calculate discount amount based on rate
    final discountAmount = (discountRate * itemsTotal) / 100;
    double remainingDiscount = discountAmount;

    try {
      // Update items
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        double itemTotal = item.price.toDouble() * item.qty.toDouble();
        double itemDiscountAmount;

        if (i == items.length - 1) {
          // Last item gets remaining discount to avoid rounding issues
          itemDiscountAmount = remainingDiscount;
        } else {
          itemDiscountAmount = (itemTotal / itemsTotal) * discountAmount;
          remainingDiscount -= itemDiscountAmount;
        }
        ProxyService.getStrategy(Strategy.capella).updateTransactionItem(
          transactionItemId: item.id,
          dcRt: discountRate,
          ignoreForReport: false,
          dcAmt: itemDiscountAmount,
        );
      }
      ProxyService.getStrategy(Strategy.capella).updateTransaction(
        transaction: transaction,
        cashReceived: ProxyService.box.getCashReceived(),
        subTotal: itemsTotal - discountAmount,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> startCompleteTransactionFlow({
    required String transactionId,
    required Function completeTransaction,
    required List<Payment> paymentMethods,
    ITransaction? transactionHint,

    /// When non-null and every row belongs to [transactionId], skips an extra Ditto load.
    List<TransactionItem>? transactionItemsHint,
    bool immediateCompletion = false,
    Function? onPaymentConfirmed,

    /// Sum of non-credit payments already persisted for this transaction
    /// (prior installments on a resumed loan/layaway). Pass 0 for a fresh sale.
    double overrideAlreadyPaid = 0.0,
    Function(String)? onPaymentFailed,

    /// Preloaded attached customer (e.g. mobile checkout UI already resolved it).
    Customer? attachedCustomerHint,
  }) async {
    // Store original stock quantities for potential rollback
    final Map<String, double> originalStockQuantities = {};
    var allowSellingBelowStock = false;
    String? completionCashierName;
    bool transactionWasMarkedCompleted = false;
    final flowWatch = Stopwatch()..start();
    final capella = ProxyService.getStrategy(Strategy.capella);

    try {
      // Staff cannot complete payment — Send to Till only.
      if (!ref.read(canCollectPosPaymentProvider)) {
        talker.warning(
          'Blocked sale completion: user lacks till payment role | '
          'userId=${ProxyService.box.getUserId()} | '
          '(see prior "POS till role decision" log for full breakdown)',
        );
        throw Exception(
          'Payments are collected at the till. Send this order to a manager.',
        );
      }

      // Settling a queued till ticket: complete THAT ticket, not the collector's
      // own pending cart. The desktop checkout is bound to
      // [pendingTransactionStreamProvider], which can hand completion the
      // operator's empty pending-cart id during the settling hand-off.
      final settlingTicket = ref.read(settlingTillTicketProvider);
      if (settlingTicket != null &&
          settlingTicket.transactionId.isNotEmpty &&
          settlingTicket.transactionId != transactionId) {
        talker.info(
          'Settling: redirecting completion from $transactionId to '
          '${settlingTicket.transactionId}',
        );
        transactionId = settlingTicket.transactionId;
        transactionHint =
            ref.read(transactionByIdProvider(settlingTicket.transactionId)).value;
      }

      String branchIdInt = ProxyService.box.getBranchId()!;

      final resolveSw = Stopwatch()..start();
      ITransaction? resolved;
      if (transactionHint != null && transactionHint.id == transactionId) {
        resolved = transactionHint;
      } else {
        resolved = await capella.getTransaction(
          id: transactionId,
          branchId: branchIdInt,
        );
        resolved ??= await capella.getTransaction(
          id: transactionId,
          branchId: branchIdInt,
        );
      }
      talker.debug(
        '[sale_completion_timing] resolve_transaction_ms=${resolveSw.elapsedMilliseconds} '
        'total_ms=${flowWatch.elapsedMilliseconds}',
      );

      if (resolved == null) {
        throw Exception("Transaction not found for completion.");
      }
      final transaction = resolved;

      final cashierSw = Stopwatch()..start();
      // Denormalize cashier name once at completion time to avoid per-row lookups in reports.
      final currentUserId = ProxyService.box.getUserId();
      if (currentUserId != null && currentUserId.trim().isNotEmpty) {
        try {
          final repo = Repository();
          // Try local cache first (offline), then remote when available.
          final q = Query(where: [Where('id').isExactly(currentUserId)]);
          final local = await repo.get<brick_user.User>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: q,
          );
          brick_user.User? u = local.isNotEmpty ? local.first : null;
          if (u != null) {
            completionCashierName =
                TransactionReportCashierProfile.displayNameFromUserRow(
                  name: u.name,
                  email: u.key,
                );
          }
        } catch (_) {
          // Best-effort: completion should still work offline.
        }
      }
      talker.debug(
        '[sale_completion_timing] cashier_lookup_ms=${cashierSw.elapsedMilliseconds} '
        'total_ms=${flowWatch.elapsedMilliseconds}',
      );
      final isValid = formKey.currentState?.validate() ?? true;
      if (!isValid) return false;

      if (paymentMethods.length > 1) {
        final missingIndices = <int>[];
        final invalidIndices = <int>[];
        final zeroAmountIndices = <int>[];
        for (var i = 0; i < paymentMethods.length; i++) {
          final text = paymentMethods[i].controller.text.trim();
          if (text.isEmpty) {
            missingIndices.add(i + 1);
            continue;
          }
          final parsed = double.tryParse(text);
          if (parsed == null || !parsed.isFinite || parsed < 0) {
            invalidIndices.add(i + 1);
            continue;
          }
          // With multiple methods, every line must carry a real share (not 0).
          if (parsed <= 0.01) {
            zeroAmountIndices.add(i + 1);
          }
        }
        if (missingIndices.isNotEmpty ||
            invalidIndices.isNotEmpty ||
            zeroAmountIndices.isNotEmpty) {
          final parts = <String>[];
          if (missingIndices.isNotEmpty) {
            parts.add(
              'enter an amount for payment ${missingIndices.join(', ')}',
            );
          }
          if (invalidIndices.isNotEmpty) {
            parts.add(
              'fix invalid amount for payment ${invalidIndices.join(', ')}',
            );
          }
          if (zeroAmountIndices.isNotEmpty) {
            parts.add(
              'each method needs an amount above zero (payment ${zeroAmountIndices.join(', ')})',
            );
          }
          final message =
              'Multiple payment methods are in use: ${parts.join('; ')}.';
          if (mounted && context.mounted) {
            showCustomSnackBarUtil(
              context,
              message,
              backgroundColor: Colors.red,
              showCloseButton: true,
            );
          }
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return false;
        }
      }

      // CREDIT (loan) payments require an attached customer for tracking.
      final hasCreditPayment = paymentMethods.any(
        (p) => p.method == "CREDIT" && p.amount > 0,
      );
      if (hasCreditPayment) {
        final hasCustomer =
            (transaction.customerName != null &&
                transaction.customerName!.isNotEmpty) ||
            (transaction.customerPhone != null &&
                transaction.customerPhone!.isNotEmpty) ||
            transaction.customerId != null;

        if (!hasCustomer) {
          if (mounted && context.mounted) {
            showCustomSnackBarUtil(
              context,
              "A customer name or phone is required for credit/loan payments.",
              backgroundColor: Colors.red,
              showCloseButton: true,
            );
          }
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return false;
        }
      }

      // Validate stock levels before proceeding
      final itemsSw = Stopwatch()..start();
      // Settling a queued till ticket: its line items were persisted by the
      // staff who created it (no optimistic taps to wait for), so read them
      // directly instead of polling for a display/Ditto qty match — the poll can
      // never converge here because the cart is scoped to the ticket's branch.
      // Reuse the settling snapshot captured at the top of this flow. Re-reading
      // the provider here would let an asynchronously cleared settling state
      // flip this ticket back to normal cart polling (which never converges for
      // a settling ticket) after completion was already redirected to it.
      final settling = settlingTicket;
      final bool isSettlingThisTicket =
          settling != null && settling.transactionId == transactionId;
      final List<TransactionItem>? persistedCart;
      if (isSettlingThisTicket) {
        // Read with the exact branch the settling display used (captured at
        // collect time) so the fetch resolves the same rows shown on screen.
        final settlingBranchId =
            (settling.branchId != null && settling.branchId!.isNotEmpty)
                ? settling.branchId!
                : (transaction.branchId != null &&
                        transaction.branchId!.isNotEmpty
                    ? transaction.branchId!
                    : ProxyService.box.getBranchId()!);
        final items = await ProxyService.getStrategy(Strategy.capella)
            .transactionItems(
              branchId: settlingBranchId,
              transactionId: transactionId,
              doneWithTransaction: false,
              active: true,
            );
        persistedCart = items.isNotEmpty ? items : null;
      } else {
        persistedCart = await _pollPersistedCartForDisplay(
          ref: ref,
          transaction: transaction,
          transactionId: transactionId,
        );
      }
      if (persistedCart == null) {
        final hasPending = ref
            .read(optimisticCartProvider.notifier)
            .hasPendingFor(transactionId);
        final hasGhosts = ref
            .read(posCartDisplayItemsProvider)
            .any((i) => OptimisticCartIds.isOptimistic(i.id));
        final checkoutQty = _checkoutCartQtyByVariant(ref);
        talker.warning(
          'Sale completion blocked: cart not fully persisted txn=$transactionId '
          'pending=$hasPending ghosts=$hasGhosts checkoutVariants=${checkoutQty.length}',
        );
        if (mounted && context.mounted) {
          showCustomSnackBarUtil(
            context,
            'Cart is still saving. Wait a moment and tap Pay again.',
            backgroundColor: Colors.orange,
            showCloseButton: true,
          );
        }
        ref.read(payButtonStateProvider.notifier).stopLoading();
        return false;
      }
      final transactionItems = await _resolveTransactionItemsForCompletion(
        transaction: transaction,
        transactionId: transactionId,
        hint: transactionItemsHint,
        persistedCart: persistedCart,
      );
      talker.debug(
        '[sale_completion_timing] load_transaction_items_ms=${itemsSw.elapsedMilliseconds} '
        'count=${transactionItems.length} total_ms=${flowWatch.elapsedMilliseconds}',
      );
      if (transactionItems.isEmpty) {
        talker.warning(
          'Sale completion blocked: no line items for transaction $transactionId',
        );
        if (mounted && context.mounted) {
          showCustomSnackBarUtil(
            context,
            'Cart is still saving. Wait a moment and tap Pay again.',
            backgroundColor: Colors.orange,
            showCloseButton: true,
          );
        }
        ref.read(payButtonStateProvider.notifier).stopLoading();
        return false;
      }
      // Filter out services (itemTyCd == "3") from stock validation
      final itemsToValidate = transactionItems
          .where((item) => item.itemTyCd != "3")
          .toList();

      final saleSettingsSvc = locator<SettingsService>();
      allowSellingBelowStock =
          await saleSettingsSvc.isAllowSellingBelowStock();

      if (!allowSellingBelowStock) {
        final outOfStockItems = await validateStockQuantity(
          itemsToValidate,
        );
        if (outOfStockItems.isNotEmpty) {
          if (mounted) {
            await showOutOfStockDialog(context, outOfStockItems);
          }
          ref.read(payButtonStateProvider.notifier).stopLoading();
          return false;
        }
      }

      final bool isProformaOrTraining =
          await TurboTaxService.handleProformaOrTrainingMode();

      final receiptTypeForStock = getFilterType(
        transactionType: transaction.receiptType,
      ).name;
      final stockIoSarTyCd = resolveRraStockIoSarTyCd(
        receiptType: receiptTypeForStock,
      );

      if (!isProformaOrTraining) {
        final snapshotSw = Stopwatch()..start();
        await persistPreSaleStockSnapshot(
          transactionItems: transactionItems,
          transactionId: transactionId,
        );
        talker.debug(
          '[sale_completion_timing] pre_sale_stock_snapshot_ms='
          '${snapshotSw.elapsedMilliseconds} total_ms=${flowWatch.elapsedMilliseconds}',
        );
        // Local stock decrement runs after RRA sign via [schedulePostSaleStockDeduction]
        // so Pay stays within the 5s budget (Ditto write queue was blocking ~30s+).
      }

      void schedulePostSaleStockDeduction() {
        schedulePostSaleStockDeductionAndRraSync(
          transactionItems: transactionItems,
          allowSellingBelowStock: allowSellingBelowStock,
          isProformaOrTraining: isProformaOrTraining,
          transactionId: transactionId,
          transaction: transaction,
          receiptType: receiptTypeForStock,
          sarTyCd: stockIoSarTyCd,
        );
      }

      // update this transaction as completed

      final isCurrencyDecimal = saleSettingsSvc.isCurrencyDecimal;

      // Compute final subtotal using item discounts (dcAmt) if present.
      // NOTE: `applyDiscount()` persists discounts to items + transaction.subTotal.
      // We must not overwrite it here with a pre-discount recomputation.
      final double finalSubTotal = transactionItems.fold(0.0, (sum, item) {
        final lineGross = (item.price.toDouble() * item.qty.toDouble());
        final lineDiscount = (item.dcAmt ?? 0).toDouble();
        final lineNet = lineGross - lineDiscount;
        final rounded = isCurrencyDecimal
            ? lineNet.roundToTwoDecimalPlaces()
            : lineNet.roundToDouble();
        return sum + rounded;
      });

      transaction.subTotal = finalSubTotal;

      final amount = resolveTenderAmountForSaleCompletion(
        receivedAmountController: receivedAmountController,
        paymentMethods: paymentMethods,
        saleTotal: finalSubTotal,
      );
      ProxyService.box.writeString(
        key: 'receivedAmount',
        value: amount.toString(),
      );
      final discount = double.tryParse(discountController.text) ?? 0;

      final String branchId = ProxyService.box.getBranchId()!;
      final paymentType = ProxyService.box.paymentType() ?? "Cash";

      if (!isValid) return false;

      final isDigitalPaymentEnabled = await ProxyService.getStrategy(
        Strategy.capella,
      ).isBranchEnableForPayment(
            currentBranchId: branchId,
            fetchRemote: false,
          );

      Customer? customer = await _resolveAttachedCustomerForSale(
        transaction: transaction,
        hint: attachedCustomerHint,
        fetchIfMissing:
            hasCreditPayment ||
            isDigitalPaymentEnabled ||
            (transaction.customerId != null &&
                transaction.customerId!.isNotEmpty),
      );

      final String? ticketName =
          customer?.custNm ??
          transaction.customerName ??
          (mounted ? ref.read(customerNameControllerProvider).text : null);

      if (isDigitalPaymentEnabled && !immediateCompletion) {
        // Process digital payment only if immediateCompletion is false
        await _processDigitalPayment(
          customer: customer,
          transaction: transaction,
          amount: amount,
          discount: discount,
          branchId: branchId,
          paymentMethods: paymentMethods,
          completeTransaction: completeTransaction,
          paymentType: paymentType,
          onPaymentConfirmed: onPaymentConfirmed,
          onPaymentFailed: onPaymentFailed,
          ticketName: ticketName,
          finalSubTotal: finalSubTotal,
          completionCashierName: completionCashierName,
          transactionItems: transactionItems,
          allowSellingBelowStock: allowSellingBelowStock,
          isProformaOrTraining: isProformaOrTraining,
          receiptTypeForStock: receiptTypeForStock,
          stockIoSarTyCd: stockIoSarTyCd,
          overrideAlreadyPaid: overrideAlreadyPaid,
        );
        talker.debug(
          '[sale_completion_timing] flow_total_until_waiting_payment_ms=${flowWatch.elapsedMilliseconds}',
        );
        // Return true to indicate we're waiting for payment confirmation
        // Bottom sheet should NOT close yet
        return true;
      } else {
        // Process cash payment or skip digital payment if immediateCompletion is true
        await _finalStepInCompletingTransaction(
          customer: customer,
          transaction: transaction,
          amount: amount,
          paymentMethods: paymentMethods,
          discount: discount,
          paymentType: paymentType,
          ticketName: ticketName,
          preloadedLineItemsForCollectPayment: transactionItems,
          skipCollectPaymentTransactionPersist: true,
          completeTransaction: () async {
            final mark = await markTransactionAsCompleted(
              transaction: transaction,
              finalSubTotal: finalSubTotal,
              paymentMethods: paymentMethods,
              ticketName: ticketName,
              cashierName: completionCashierName,
              lineItemsForAgentCommission: transactionItems,
              deferPaymentPersist: true,
              overrideAlreadyPaid: overrideAlreadyPaid,
            );
            transactionWasMarkedCompleted = true;
            schedulePostSaleStockDeduction();
            if (mounted && context.mounted) {
              showCustomSnackBarUtil(
                context,
                mark.wasLoan
                    ? "Payment recorded. Transaction parked as loan."
                    : "Payment Successful",
                backgroundColor: mark.wasLoan ? Colors.orange : Colors.green,
                showCloseButton: true,
              );
              ref.read(payButtonStateProvider.notifier).stopLoading();
            }
            final deferredPayments = mark.deferredPayments;
            if (deferredPayments != null && deferredPayments.isNotEmpty) {
              unawaited(
                _persistSalePaymentLines(
                  capella: capella,
                  transactionId: transaction.id,
                  payments: deferredPayments,
                ),
              );
            }
            try {
              await _invokeCompleteTransactionCallback(completeTransaction);
            } catch (e, s) {
              talker.error('Error in completeTransaction callback: $e', s);
            }
            _resetDigitalReceiptToggleAfterSale();
          },
        );
        talker.debug(
          '[sale_completion_timing] flow_total_sync_completion_ms=${flowWatch.elapsedMilliseconds}',
        );
        logSaleCompletionOverBudget(
          elapsedMs: flowWatch.elapsedMilliseconds,
          source: 'preview_cart_sync',
        );
        // Return false to indicate payment is complete
        // Bottom sheet will close after user confirmation
        return false;
      }
    } catch (e, s) {
      talker.error("Error in complete transaction flow: $e", s);

      if (!transactionWasMarkedCompleted) {
        ProxyService.box.remove(key: rraSaleStockSnapshotBoxKey(transactionId));
        // Rollback stock quantities
        for (var entry in originalStockQuantities.entries) {
          final stockId = entry.key;
          final originalStock = entry.value;
          await capella.updateStock(
            stockId: stockId,
            currentStock: originalStock,
            rsdQty: originalStock,
          );
        }
        await capella.updateTransaction(
          transactionId: transactionId,
          status: PENDING,
          cashReceived: ProxyService.box.getCashReceived(),
        );
      }

      if (mounted) {
        ref.read(payButtonStateProvider.notifier).stopLoading();
      }
      String errorMessage = e
          .toString()
          .split('Caught Exception: ')
          .last
          .replaceAll("Exception: ", "");
      _handlePaymentError(errorMessage, s, context);
      rethrow;
    }
  }

  Future<void> _persistSalePaymentLines({
    required dynamic capella,
    required String transactionId,
    required List<PaymentLineForSaleCompletion> payments,
  }) async {
    final paySw = Stopwatch()..start();
    try {
      for (final payment in payments) {
        await capella.savePaymentType(
          singlePaymentOnly: false,
          amount: payment.amount,
          transactionId: transactionId,
          paymentMethod: payment.method,
          saleCompletionFastPath: true,
        );
      }
    } catch (e, s) {
      talker.error('Deferred sale payment persist failed: $e', s);
    }
    talker.debug(
      '[sale_completion_timing] save_payments_ms=${paySw.elapsedMilliseconds} '
      'deferred_after_ui=true',
    );
  }

  /// Returns loan flag and optional payment lines when [deferPaymentPersist] is true.
  ///
  /// [overrideAlreadyPaid] is the sum of non-credit payments already persisted
  /// for this transaction (prior installments on a resumed loan/layaway). Pass 0
  /// (the default) for a fresh sale.
  Future<({bool wasLoan, List<PaymentLineForSaleCompletion>? deferredPayments})>
  markTransactionAsCompleted({
    required ITransaction transaction,
    required double finalSubTotal,
    required List<Payment> paymentMethods,
    String? ticketName,
    String? cashierName,
    List<TransactionItem>? lineItemsForAgentCommission,
    bool deferPaymentPersist = false,
    double overrideAlreadyPaid = 0.0,
  }) async {
    final capella = ProxyService.getStrategy(Strategy.capella);

    final paymentLines = paymentLinesForSaleCompletion(paymentMethods);

    final derived = deriveSaleCompletionState(
      transactionCashReceived: transaction.cashReceived ?? 0,
      finalSubTotal: finalSubTotal,
      paymentMethods: paymentLines,
      priorAlreadyPaidNonCredit: overrideAlreadyPaid,
    );

    final paymentsToPersist = normalizePaymentLinesToSaleTotal(
      paymentMethods: paymentLines,
      saleTotal: finalSubTotal,
      shouldBeLoan: derived.shouldBeLoan,
    );

    final commSw = Stopwatch()..start();
    final hasAgentCommissionHints =
        (transaction.attributedAgentUserId?.isNotEmpty ?? false) ||
        transaction.agentCommissionType != null ||
        transaction.agentCommissionValue != null;
    if (hasAgentCommissionHints) {
      if (transaction.attributedAgentUserId?.isNotEmpty ?? false) {
        applyAgentCommissionForSaleCompletionInMemory(
          transaction: transaction,
          finalSubTotal: finalSubTotal,
          preloadedLineItems: lineItemsForAgentCommission,
        );
      } else {
        await finalizeAgentCommissionForSaleCompletion(
          transaction: transaction,
          finalSubTotal: finalSubTotal,
          preloadedLineItems: lineItemsForAgentCommission,
        );
      }
    }
    talker.debug(
      '[sale_completion_timing] agent_commission_ms=${commSw.elapsedMilliseconds} '
      'has_hints=$hasAgentCommissionHints',
    );

    final markSw = Stopwatch()..start();
    final now = DateTime.now();
    final txnSw = Stopwatch()..start();
    await capella.updateTransaction(
      transaction: transaction,
      status: derived.status,
      isLoan: derived.shouldBeLoan,
      remainingBalance: derived.remainingBalance,
      cashReceived: derived.nonCreditCashReceived,
      subTotal: finalSubTotal,
      lastTouched: now,
      cashierName: cashierName,
      ticketName:
          (transaction.ticketName == null || transaction.ticketName!.isEmpty)
          ? ticketName
          : transaction.ticketName,
      customerName: transaction.customerName,
      customerPhone: transaction.customerPhone,
      // Receipt / EBM fields (may be set in memory during tax receipt flow).
      receiptType: transaction.receiptType,
      sarNo: transaction.sarNo,
      receiptNumber: transaction.receiptNumber,
      totalReceiptNumber: transaction.totalReceiptNumber,
      invoiceNumber: transaction.invoiceNumber,
      receiptPrinted: transaction.receiptPrinted,
      isProformaMode: ProxyService.box.isProformaMode(),
      isTrainingMode: ProxyService.box.isTrainingMode(),
      deferEnsureNextPendingCart: true,
    );
    talker.debug(
      '[sale_completion_timing] update_transaction_ms=${txnSw.elapsedMilliseconds}',
    );
    transaction.subTotal = finalSubTotal;
    transaction.lastTouched = now;
    transaction.createdAt = now;
    transaction.status = derived.status;

    if (!deferPaymentPersist) {
      final paySw = Stopwatch()..start();
      for (final payment in paymentsToPersist) {
        await capella.savePaymentType(
          singlePaymentOnly: false,
          amount: payment.amount,
          transactionId: transaction.id,
          paymentMethod: payment.method,
          saleCompletionFastPath: true,
        );
      }
      talker.debug(
        '[sale_completion_timing] save_payments_ms=${paySw.elapsedMilliseconds}',
      );
    }

    talker.debug(
      '[sale_completion_timing] mark_completed_tx_ms=${markSw.elapsedMilliseconds} '
      'defer_payments=$deferPaymentPersist',
    );

    if (mounted) {
      void refreshPendingCartProviders() {
        ref.invalidate(
          pendingTransactionStreamProvider(
            isExpense: ProxyService.box.isOrdering() ?? false,
          ),
        );
        ref.read(pendingCartSaleSessionProvider.notifier).state =
            ref.read(pendingCartSaleSessionProvider) + 1;
      }

      if (deferPaymentPersist) {
        unawaited(Future.microtask(refreshPendingCartProviders));
      } else {
        refreshPendingCartProviders();
      }
    }

    return (
      wasLoan: derived.shouldBeLoan,
      deferredPayments: deferPaymentPersist ? paymentsToPersist : null,
    );
  }

  /// Attached customer for checkout/receipt: prefers [attachedCustomerProvider]
  /// cache (warmed by Quick Selling / mobile checkout UI), then fetches once.
  Future<Customer?> _resolveAttachedCustomerForSale({
    required ITransaction transaction,
    Customer? hint,
    required bool fetchIfMissing,
  }) async {
    if (hint != null) return hint;

    final customerId = transaction.customerId;
    if (customerId == null || customerId.isEmpty) return null;

    final cached =
        ref.read(attachedCustomerProvider(customerId)).asData?.value;
    if (cached != null) return cached;

    if (!fetchIfMissing) return null;

    return ref.read(attachedCustomerProvider(customerId).future);
  }

  /// Get country calling code from country name
  String _getCountryCallingCode(String? countryName) {
    final countryCodeMap = {
      'Rwanda': '250',
      'Kenya': '254',
      'Uganda': '256',
      'Tanzania': '255',
      'Burundi': '257',
      'South Africa': '27',
      'Zambia': '260',
      'Mozambique': '258',
      'Zimbabwe': '263',
      'Malawi': '265',
      'DRC': '243',
      'Congo': '243',
    };
    return countryCodeMap[countryName] ??
        '250'; // Default to Rwanda if country not found
  }

  Future<void> _processDigitalPayment({
    required Customer? customer,
    required ITransaction transaction,
    required double amount,
    required double discount,
    required String branchId,
    required Function completeTransaction,
    required String paymentType,
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
    required List<Payment> paymentMethods,
    String? ticketName,
    required double finalSubTotal,
    String? completionCashierName,
    required List<TransactionItem> transactionItems,
    required bool allowSellingBelowStock,
    required bool isProformaOrTraining,
    required String receiptTypeForStock,
    required String stockIoSarTyCd,
    double overrideAlreadyPaid = 0.0,
  }) async {
    try {
      // customer.telNo from database already has country code (e.g., "+250783054874")
      // currentSaleCustomerPhoneNumber from localStorage is just digits (e.g., "783054874")
      String phoneNumber;
      if (customer?.telNo != null) {
        phoneNumber = customer!.telNo!.replaceAll("+", "");
      } else {
        // Get country code dynamically from business country
        final branch = await ProxyService.getStrategy(Strategy.capella).activeBranch(
          branchId: ProxyService.box.getBranchId()!,
        );
        final business = await ProxyService.getStrategy(Strategy.capella).getBusiness(
          businessId: branch.businessId!,
        );
        final countryCode = _getCountryCallingCode(business?.country);

        String localPhone =
            ProxyService.box.currentSaleCustomerPhoneNumber() ?? "";

        // Remove leading 0 if present (e.g., "0783054874" -> "783054874")
        if (localPhone.startsWith("0")) {
          localPhone = localPhone.substring(1);
        }

        // Only add country code prefix if phone doesn't already start with it
        phoneNumber = localPhone.startsWith(countryCode)
            ? localPhone
            : "$countryCode$localPhone";
      }

      await _sendpaymentRequest(
        phoneNumber: phoneNumber,
        branchId: branchId,
        externalId: transaction.id,
        finalPrice: transaction.subTotal!.toInt(),
      );

      talker.info("📤 Payment request sent to phone: $phoneNumber");
      talker.info("💰 Amount: ${transaction.subTotal!.toInt()}");

      final uuid = Uuid();
      final paymentId = uuid.v4();

      await Supabase.instance.client.from('customer_payments').upsert({
        'id': paymentId,
        'phone_number': phoneNumber,
        'payment_status': "pending",
        'amount_payable': transaction.subTotal!,
        'transaction_id': transaction.id,
      });

      talker.info(
        "⏳ Payment status set to PENDING - Waiting for user confirmation...",
      );
      talker.info(
        "🔍 Setting up realtime listener for transaction: ${transaction.id}",
      );

      talker.info(
        "👂 Realtime listener active - Will trigger when payment status = 'completed'",
      );

      // Add timeout for payment confirmation (60 seconds)
      // Store timer reference for cleanup in dispose()
      _paymentTimeout = Timer(Duration(seconds: 60), () {
        if (!_isProcessingPayment) {
          talker.warning("⏰ Payment confirmation timeout after 60 seconds");
          onPaymentFailed?.call(
            'Payment confirmation timeout. Please try again.',
          );
          _paymentStatusChannel?.unsubscribe();
        }
      });

      // Cancel any existing subscription
      await _paymentStatusSubscription?.cancel();

      // Create channel with callback
      final channel = Supabase.instance.client
          .channel(
            'schema-db-changes',
            opts: const RealtimeChannelConfig(ack: true),
          )
          .onPostgresChanges(
            event: PostgresChangeEvent.update,
            schema: 'public',
            table: 'customer_payments',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'transaction_id',
              value: transaction.id,
            ),
            callback: (payload) async {
              // Extract the new record from the payload
              final newRecord = payload.newRecord;
              // Filter for completed payments only
              if (newRecord['payment_status'] != 'completed') return;

              // Prevent double-processing
              if (_isProcessingPayment) {
                talker.warning(
                  "⚠️ Already processing payment, skipping duplicate event",
                );
                return;
              }

              // Mark as processing
              _isProcessingPayment = true;

              talker.info(
                "✅ Payment CONFIRMED by user - Status: ${newRecord['paymentStatus']}",
              );
              talker.info(
                "📱 Phone: ${newRecord['phoneNumber']}, Amount: ${newRecord['amountPayable']}",
              );

              // Check if widget is still mounted before proceeding
              if (!mounted) {
                talker.warning("Widget disposed, skipping payment completion");
                _isProcessingPayment = false;
                return;
              }

              try {
                // Call the onPaymentConfirmed callback to update UI
                onPaymentConfirmed?.call();

                talker.info(
                  "🧾 Starting receipt generation after payment confirmation...",
                );
                final bool
                didComplete = await _finalStepInCompletingTransaction(
                  customer: customer,
                  transaction: transaction,
                  amount: amount,
                  discount: discount,
                  paymentMethods: paymentMethods,
                  paymentType: paymentType,
                  ticketName: ticketName,
                  preloadedLineItemsForCollectPayment: transactionItems,
                  skipCollectPaymentTransactionPersist: false,
                  completeTransaction: () {
                    // For digital payments, don't call completeTransaction yet
                    // We'll call it after this succeeds
                    talker.info(
                      "✅ Receipt generation completed for digital payment",
                    );
                    talker.info("📄 Receipt successfully saved and synced");
                  },
                );
                // Execution reaches here AFTER _finalStepInCompletingTransaction completes
                talker.info(
                  "🏁 _finalStepInCompletingTransaction returned successfully",
                );

                if (!didComplete) {
                  // User cancelled or receipt generation did not complete.
                  talker.info(
                    "ℹ️ Receipt generation did not complete; not closing bottom sheet",
                  );
                  _isProcessingPayment = false;
                  _paymentTimeout?.cancel();
                  return;
                }

                // Digital payment confirmed and receipt generated successfully
                // NOW we can call the actual completeTransaction callback
                talker.info(
                  "✅ Digital payment completed successfully - Closing bottom sheet",
                );
                talker.info(
                  "⏰ Receipt generation took: ${DateTime.now().toIso8601String()}",
                );
                talker.info(
                  "🔄 Calling completeTransaction callback to close bottom sheet...",
                );

                final mark = await markTransactionAsCompleted(
                  transaction: transaction,
                  finalSubTotal: finalSubTotal,
                  paymentMethods: paymentMethods,
                  ticketName: ticketName,
                  cashierName: completionCashierName,
                  lineItemsForAgentCommission: transactionItems,
                  deferPaymentPersist: true,
                  overrideAlreadyPaid: overrideAlreadyPaid,
                );

                final deferredPayments = mark.deferredPayments;
                if (deferredPayments != null && deferredPayments.isNotEmpty) {
                  final capellaStrategy = ProxyService.getStrategy(
                    Strategy.capella,
                  );
                  unawaited(
                    _persistSalePaymentLines(
                      capella: capellaStrategy,
                      transactionId: transaction.id,
                      payments: deferredPayments,
                    ),
                  );
                }

                schedulePostSaleStockDeductionAndRraSync(
                  transactionItems: transactionItems,
                  allowSellingBelowStock: allowSellingBelowStock,
                  isProformaOrTraining: isProformaOrTraining,
                  transactionId: transaction.id,
                  transaction: transaction,
                  receiptType: receiptTypeForStock,
                  sarTyCd: stockIoSarTyCd,
                );

                _isProcessingPayment = false;
                _paymentTimeout?.cancel(); // Cancel timeout on success

                unawaited(() async {
                  try {
                    await _invokeCompleteTransactionCallback(
                      completeTransaction,
                    );
                  } catch (e) {
                    talker.error("Error in completeTransaction callback: $e");
                  }
                }());
                _resetDigitalReceiptToggleAfterSale();

                talker.info(
                  "✅ completeTransaction callback executed - Bottom sheet should now close",
                );
              } catch (e) {
                talker.error(
                  "❌ Error completing transaction after payment: $e",
                );
                _isProcessingPayment = false; // Reset flag on error
                _paymentTimeout?.cancel(); // Cancel timeout on error
                onPaymentFailed?.call(
                  e.toString().replaceAll('Exception: ', ''),
                );
                rethrow;
              }
            },
          );

      // Subscribe to the channel with status monitoring
      _paymentStatusChannel = channel.subscribe();
    } catch (e) {
      talker.error("Error in digital payment processing: $e");
      rethrow;
    }
  }

  Future<bool> _finalStepInCompletingTransaction({
    required Customer? customer,
    required ITransaction transaction,
    required double amount,
    required double discount,
    required String paymentType,
    required Function completeTransaction,
    required List<Payment> paymentMethods,
    String? ticketName,
    List<TransactionItem>? preloadedLineItemsForCollectPayment,

    /// When true, [collectPayment] skips persisting the txn row because [completeTransaction]
    /// immediately calls [markTransactionAsCompleted] (sync cash path). When false, persist
    /// in [collectPayment] so a later early return (e.g. receipt cancelled) still records payment.
    bool skipCollectPaymentTransactionPersist = false,
  }) async {
    try {
      // Check if widget is still mounted before using ref
      if (!mounted) {
        talker.warning("Widget disposed, cannot complete transaction");
        return false;
      }

      if (transaction.customerTin != null &&
          transaction.customerTin!.isNotEmpty) {
        // Show dialog and capture whether the dialog completed successfully
        final bool? dialogResult =
            await additionalInformationIsRequiredToCompleteTransaction(
              amount: amount,
              onComplete: completeTransaction,
              discount: discount,
              paymentType: paymentTypeController.text,
              transaction: transaction,
              context: context,
              customer: customer,
            );

        // If user cancelled or dialog didn't complete, propagate false
        if (dialogResult != true) {
          if (mounted) {
            // Stop loading but DO NOT refresh the pendingTransaction stream here.
            // Capella ensures the next pending cart when status leaves [PENDING];
            // refreshing here can cancel the Ditto observer and is unnecessary.
            ref.read(payButtonStateProvider.notifier).stopLoading();
          }
          return false;
        }

        if (mounted) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
        }
      } else {
        // Get the controller value before async operations
        final customerNameController = mounted
            ? ref.watch(customerNameControllerProvider)
            : TextEditingController();

        final sendDigitalReceipt = await resolveSendDigitalReceipt(
          transaction.id,
        );

        await finalizePayment(
          formKey: formKey,
          countryCodeController: countryCodeController,
          customerNameController: customerNameController,
          context: context,
          paymentType: paymentType,
          transactionType: TransactionType.sale,
          transaction: transaction,
          amount: amount,
          onComplete: completeTransaction,
          discount: discount,
          preloadedLineItemsForCollectPayment:
              preloadedLineItemsForCollectPayment,
          skipTransactionPersist: skipCollectPaymentTransactionPersist,
          deferPersistTaxReceiptFields: true,
          sendDigitalReceipt: sendDigitalReceipt,
          customer: customer,
          onSuccess: () {
            ref.read(payButtonStateProvider.notifier).stopLoading();
          },
        );

        if (mounted) {
          ref.read(payButtonStateProvider.notifier).stopLoading();
        }
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// a method to send payment request
  Future<bool> _sendpaymentRequest({
    required String phoneNumber,
    required int finalPrice,
    required String branchId,
    required String externalId,
  }) async {
    try {
      final response = await ProxyService.ht.makePayment(
        payeemessage: "Pay for Goods",
        payerMessage: "Pay for Goods",
        paymentType: "PaymentNormal",
        externalId: externalId,
        phoneNumber: phoneNumber.replaceAll("+", ""),
        branchId: branchId,
        amount: finalPrice,
        flipperHttpClient: ProxyService.http,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Helper method to handle payment errors
  void _handlePaymentError(
    dynamic error,
    StackTrace stackTrace,
    BuildContext context,
  ) {
    String errorMessage;

    if ((ProxyService.box.enableDebug() ?? false)) {
      // In debug mode, show the stack trace
      errorMessage = stackTrace.toString().split('Caught Exception: ').last;
    } else {
      // In production mode, show a user-friendly error message
      errorMessage = error.toString();
      if (error is Exception) {
        errorMessage = error.toString().split('Exception: ').last;
      }
      errorMessage = errorMessage.toString().split('Caught Exception: ').last;
    }

    // Use the standardized snackbar utility
    showCustomSnackBarUtil(
      context,
      errorMessage,
      backgroundColor: Colors.red[600],
    );
  }

  Future<bool?> additionalInformationIsRequiredToCompleteTransaction({
    required String paymentType,
    required double amount,
    required ITransaction transaction,
    required double discount,
    required Function onComplete,
    required BuildContext context,
    Customer? customer,
  }) async {
    if (transaction.customerTin != null &&
        transaction.customerTin!.isNotEmpty) {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          final double height = MediaQuery.of(dialogContext).size.height;
          final double adjustedHeight = height * 0.8;

          final sendDigitalReceiptFuture = resolveSendDigitalReceipt(
            transaction.id,
          );

          return BlocProvider(
            create: (context) => PurchaseCodeFormBloc(
              formKey: formKey,
              countryCodeController: countryCodeController,
              onComplete: onComplete,
              customerNameController: ref.watch(customerNameControllerProvider),
              amount: amount,
              discount: discount,
              paymentType: paymentType,
              transaction: transaction,
              context: dialogContext,
              skipTransactionPersist: true,
              sendDigitalReceiptFuture: sendDigitalReceiptFuture,
              customer: customer,
            ),
            child: Builder(
              builder: (context) {
                final formBloc = context.read<PurchaseCodeFormBloc>();

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.grey[100],
                  title: Text(
                    'Digital Receipt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  content: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: adjustedHeight),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FormBlocListener<PurchaseCodeFormBloc, String, String>(
                          onSubmitting: (context, state) {
                            ref
                                .read(isProcessingProvider.notifier)
                                .toggleProcessing();
                          },
                          onSuccess: (context, state) {
                            ref
                                .read(isProcessingProvider.notifier)
                                .stopProcessing();

                            unawaited(
                              DigitalReceiptService.queueSmsAfterReceiptUpload(
                                transaction.id,
                              ),
                            );

                            // Call onComplete first to trigger transaction completion
                            onComplete();

                            // Close dialog
                            Navigator.of(dialogContext).pop(true);
                          },
                          onFailure: (context, state) {
                            ref
                                .read(isProcessingProvider.notifier)
                                .stopProcessing();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                'Do you need a digital receipt?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[800],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.purchaseCode,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Purchase Code',
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.receipt,
                                    color: Colors.blue[800],
                                  ),
                                  // Explicit error styling to ensure validation
                                  // errors render visibly (red) across themes
                                  errorStyle: TextStyle(color: Colors.red[700]),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.red.shade700,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.red.shade700,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                onSubmitted: (value) {
                                  talker.warning("purchase code submitted[1]");
                                  formBloc.submit();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    BlocBuilder<PurchaseCodeFormBloc, FormBlocState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(false),
                              child: Text('Cancel'),
                            ),
                            SizedBox(width: 8),
                            FlipperButton(
                              busy: state is FormBlocSubmitting,
                              text: 'Submit',
                              textColor: Colors.black,
                              onPressed: () => formBloc.submit(),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      );

      return result;
    }
    return null;
  }

  void handleTicketNavigation(ITransaction transaction) {
    final _routerService = locator<RouterService>();
    _routerService.navigateTo(TicketsListRoute(transaction: transaction));
  }

  String getCartItemCount({required String transactionId}) {
    return ref
            .watch(transactionItemsProvider(transactionId: transactionId))
            .value
            ?.length
            .toString() ??
        '0';
  }

  double getSumOfItems({String? transactionId}) {
    final items = ref.watch(posCartDisplayItemsProvider);
    if (items.isEmpty && transactionId != null) {
      final transactionItems = ref.watch(
        transactionItemsProvider(transactionId: transactionId),
      );
      if (transactionItems.hasValue) {
        return _sumTransactionItems(transactionItems.value!);
      }
      return 0.0;
    }
    return _sumTransactionItems(items);
  }

  double _sumTransactionItems(List<TransactionItem> items) {
    final settingsService = locator<SettingsService>();
    final isCurrencyDecimal = settingsService.isCurrencyDecimal;

    return items.fold(0.0, (sum, item) {
      final val = (item.price * item.qty).toDouble();
      return sum +
          (isCurrencyDecimal
              ? val.roundToTwoDecimalPlaces()
              : val.roundToDouble());
    });
  }
}

