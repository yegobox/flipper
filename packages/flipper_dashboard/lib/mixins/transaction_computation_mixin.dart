import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';

import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';

mixin TransactionComputationMixin {
  double calculateTransactionTotal({
    required List<TransactionItem> items,
    ITransaction? transaction,
    double discountPercent = 0.0,
  }) {
    // Default to using the sum of items
    // Round each item's subtotal to 2 decimal places to avoid
    // floating-point drift (e.g. 3000 * 2.6666... = 7999.80 → 8000.00)
    final settingsService = locator<SettingsService>();
    final isCurrencyDecimal = settingsService.isCurrencyDecimal;

    double baseTotal = items.fold(0.0, (sum, item) {
      final lineNet = SaleLinePricing.subtotalNetForItem(
        unitPrice: item.price.toDouble(),
        qty: item.qty.toDouble(),
        dcRt: item.dcRt?.toDouble(),
        dcAmt: item.dcAmt?.toDouble(),
      );
      return sum +
          (isCurrencyDecimal
              ? lineNet.roundToTwoDecimalPlaces()
              : lineNet.roundToDouble());
    });

    // Fallback/Validation: REMOVED
    // We strictly use the sum of items because relying on transaction.subTotal
    // can lead to stale totals when items are deleted but the transaction
    // object hasn't been updated/refreshed yet.
    // if (transaction != null && (transaction.subTotal ?? 0.0) > baseTotal) {
    //   baseTotal = transaction.subTotal!;
    // }

    if (discountPercent > 0) {
      final discountAmount = (baseTotal * discountPercent) / 100;
      return baseTotal - discountAmount;
    }

    return baseTotal;
  }

  double calculateTotalPaid(
    List<Payment> payments, {
    double alreadyPaid = 0.0,
  }) {
    return payments.fold<double>(alreadyPaid, (sum, p) => sum + p.amount);
  }

  double calculateRemainingBalance({
    required double total,
    required double paid,
  }) {
    final remaining = total - paid;
    // Use a small epsilon for float comparison
    return remaining > 0.01 ? remaining : 0.0;
  }

  double calculateAmountToChange({
    required double total,
    required double paid,
  }) {
    final change = paid - total;
    return change > 0.01 ? change : 0.0;
  }

  String formatTenderAmount(double amount) => _formatTenderAmount(amount);

  bool tenderAmountsMatch(String fieldText, double amount) {
    final parsed = double.tryParse(fieldText.trim());
    return parsed != null && (parsed - amount).abs() <= 0.01;
  }

  String _formatTenderAmount(double amount) {
    return amount == amount.truncateToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
  }

  void _syncPrimaryPaymentAmount({
    required WidgetRef ref,
    required double amount,
  }) {
    final text = _formatTenderAmount(amount);
    ProxyService.box.writeDouble(key: 'getCashReceived', value: amount);

    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;

    final payment = payments[0];
    if (payment.controller.text != text) {
      payment.controller.text = text;
    }
    if ((payment.amount - amount).abs() <= 0.01) return;

    ref
        .read(paymentMethodsProvider.notifier)
        .updatePaymentMethod(
          0,
          Payment(
            amount: amount,
            method: payment.method,
            id: payment.id,
            controller: payment.controller,
          ),
        );
  }

  void updatePaymentRemainder({
    required WidgetRef ref,
    required ITransaction transaction,
    required double total,
    required double lastAutoSetAmount,
    double? overrideAlreadyPaid,
    TextEditingController? receivedAmountController,
    Function(double)? onAutoSetAmountChanged,
  }) {
    // Never fall back to [ITransaction.cashReceived]: item-add mirrors
    // getCashReceived into that field, so it is the in-progress tender and
    // would make displayRemainder 0 (received amount stuck at "0").
    final alreadyPaid = overrideAlreadyPaid ?? 0.0;
    final due = total - alreadyPaid;
    final displayRemainder = due > 0 ? due : 0.0;

    final fieldText = receivedAmountController?.text.trim() ?? '';
    final fieldAmount = double.tryParse(fieldText);
    // "0" is not empty — empty-cart reset writes "0", so treat it as unset.
    final fieldIsEmptyOrZero =
        fieldText.isEmpty || fieldAmount == null || fieldAmount <= 0.01;

    // When the field is cleared/zero, fill to the sale total unless there is a
    // real partial payment (0 < alreadyPaid < total). A stale alreadyPaid that
    // equals the total (cashReceived mirror) must not keep the field at 0.
    var fillAmount = displayRemainder;
    if (fieldIsEmptyOrZero && total > 0.01) {
      final realPartial =
          alreadyPaid > 0.01 && alreadyPaid < total - 0.01;
      fillAmount = realPartial ? displayRemainder : total;
    }

    // Still on the last auto-filled amount (qty +/- or catalog tap) — follow total.
    final onAutoFillTrack = !fieldIsEmptyOrZero &&
        (fieldAmount - lastAutoSetAmount).abs() <= 0.01;
    if (onAutoFillTrack && (total - lastAutoSetAmount).abs() > 0.01) {
      final realPartialRemainder =
          alreadyPaid > 0.01 &&
          alreadyPaid < total - 0.01 &&
          (fieldAmount + alreadyPaid - total).abs() <= 0.01;
      fillAmount = realPartialRemainder ? (total - alreadyPaid) : total;
    }

    final remainderChanged = (fillAmount - lastAutoSetAmount).abs() > 0.01;
    final needsFillFromZero = fieldIsEmptyOrZero && fillAmount > 0.01;

    final payments = ref.read(paymentMethodsProvider);
    final paymentsTotal = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final stalePayments = !fieldIsEmptyOrZero &&
        (fieldAmount - fillAmount).abs() <= 0.01 &&
        (paymentsTotal - fillAmount).abs() > 0.01;

    if (remainderChanged || needsFillFromZero || stalePayments) {
      final paymentsMatchBefore =
          (paymentsTotal - fillAmount).abs() <= 0.01;
      final fieldMatchesBefore =
          receivedAmountController != null &&
          tenderAmountsMatch(receivedAmountController.text, fillAmount);

      if (fieldMatchesBefore && paymentsMatchBefore) {
        // Sale total grew but fill still matches old tender — do not bail out early.
        if (onAutoFillTrack && (total - fillAmount).abs() > 0.01) {
          fillAmount = total;
        } else {
          if ((fillAmount - lastAutoSetAmount).abs() > 0.01) {
            onAutoSetAmountChanged?.call(fillAmount);
          }
          return;
        }
      }

      final text = _formatTenderAmount(fillAmount);
      if (receivedAmountController != null &&
          !tenderAmountsMatch(receivedAmountController.text, fillAmount)) {
        receivedAmountController.text = text;
      }

      onAutoSetAmountChanged?.call(fillAmount);
      if ((paymentsTotal - fillAmount).abs() > 0.01) {
        _syncPrimaryPaymentAmount(ref: ref, amount: fillAmount);
      }
      return;
    }

    // User typed a custom tender (e.g. for change) — keep payment methods aligned.
    if (fieldAmount != null &&
        fieldAmount > 0.01 &&
        (paymentsTotal - fieldAmount).abs() > 0.01) {
      _syncPrimaryPaymentAmount(ref: ref, amount: fieldAmount);
    }
  }

  double calculateCurrentRemainder(
    ITransaction transaction,
    double total, {
    double? overrideAlreadyPaid,
  }) {
    // Same as [updatePaymentRemainder]: do not use cashReceived as prior paid.
    final alreadyPaid = overrideAlreadyPaid ?? 0.0;
    final currentRemainder = total - alreadyPaid;
    return currentRemainder > 0.01 ? currentRemainder : 0.0;
  }

  /// Fetches the actual cash paid for a transaction from payment records,
  /// excluding CREDIT entries so only real money received is counted.
  Future<double> fetchNonCreditPaid(String transactionId) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) return 0.0;

    try {
      final paid = await ProxyService.getStrategy(Strategy.capella)
          .getTotalPaidForTransaction(
            transactionId: transactionId,
            branchId: branchId,
            excludePaymentMethod: 'CREDIT',
          );
      if (paid != null && paid > 0) return paid;
    } catch (_) {
      // Capella/Ditto is the POS cart source of truth.
    }
    return 0.0;
  }

  void standardizedPaymentInitialization({
    required WidgetRef ref,
    required ITransaction transaction,
    required double total,
    double? overrideAlreadyPaid,
  }) {
    final alreadyPaid = overrideAlreadyPaid ?? transaction.cashReceived ?? 0.0;
    final remainder = total - alreadyPaid;
    final displayRemainder = remainder > 0.01 ? remainder : 0.0;

    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) {
      ref
          .read(paymentMethodsProvider.notifier)
          .addPaymentMethod(
            Payment(
              amount: displayRemainder,
              method: "Cash",
              controller: TextEditingController(
                text: displayRemainder.toString(),
              ),
            ),
          );
    } else {
      final firstPayment = payments[0];
      // If the first payment is 0 or matches a "default" state,
      // update it to the true remainder for this session.
      if (firstPayment.amount == 0 ||
          (firstPayment.amount - displayRemainder).abs() > 0.01) {
        // Only update if the current controller text is empty or matches old logic
        bool shouldUpdateControllerText =
            firstPayment.controller.text.isEmpty ||
            double.tryParse(firstPayment.controller.text) == 0;

        if (shouldUpdateControllerText &&
            firstPayment.controller.text != displayRemainder.toString()) {
          firstPayment.controller.text = displayRemainder.toString();
        }

        // Create a new Payment with updated amount but REUSE controller
        Payment updatedPayment = Payment(
          amount: displayRemainder,
          method: firstPayment.method,
          id: firstPayment.id,
          controller: firstPayment.controller,
        );

        ref
            .read(paymentMethodsProvider.notifier)
            .updatePaymentMethod(0, updatedPayment);
      }
    }
  }
}
