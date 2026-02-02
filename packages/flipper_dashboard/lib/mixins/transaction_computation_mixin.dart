import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_services/proxy.dart';

mixin TransactionComputationMixin {
  double calculateTransactionTotal({
    required List<TransactionItem> items,
    ITransaction? transaction,
    double discountPercent = 0.0,
  }) {
    // Default to using the sum of items
    double baseTotal = items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.qty),
    );

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

  void updatePaymentRemainder({
    required WidgetRef ref,
    required ITransaction transaction,
    required double total,
    required double lastAutoSetAmount,
    TextEditingController? receivedAmountController,
    Function(double)? onAutoSetAmountChanged,
  }) {
    final alreadyPaid = transaction.cashReceived ?? 0.0;
    final currentRemainder = total - alreadyPaid;
    final displayRemainder = currentRemainder > 0 ? currentRemainder : 0.0;

    // Only auto-update if remainder has likely changed or field is empty.
    if ((displayRemainder - lastAutoSetAmount).abs() > 0.01 ||
        (receivedAmountController != null &&
            receivedAmountController.text.isEmpty)) {
      if (receivedAmountController != null) {
        receivedAmountController.text = displayRemainder.toString();
      }

      if (onAutoSetAmountChanged != null) {
        onAutoSetAmountChanged(displayRemainder);
      }

      ProxyService.box.writeDouble(
        key: 'lastSetRemainder',
        value: displayRemainder,
      );

      final payments = ref.read(paymentMethodsProvider);
      if (payments.isNotEmpty) {
        ref
            .read(paymentMethodsProvider.notifier)
            .updatePaymentMethod(
              0,
              Payment(
                amount: displayRemainder,
                method: payments[0].method,
                id: payments[0].id,
                controller: TextEditingController(
                  text: displayRemainder.toString(),
                ),
              ),
            );
      }
    }
  }

  double calculateCurrentRemainder(ITransaction transaction, double total) {
    final alreadyPaid = transaction.cashReceived ?? 0.0;
    final currentRemainder = total - alreadyPaid;
    return currentRemainder > 0.01 ? currentRemainder : 0.0;
  }

  void standardizedPaymentInitialization({
    required WidgetRef ref,
    required ITransaction transaction,
    required double total,
  }) {
    final alreadyPaid = transaction.cashReceived ?? 0.0;
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
      // If the first payment is 0 or matches the full total (default initialization),
      // update it to the true remainder for this session.
      if (firstPayment.amount == 0 ||
          (firstPayment.amount - (transaction.subTotal ?? 0.0)).abs() < 0.01) {
        // Check if we need to update the controller text
        bool shouldUpdateControllerText =
            firstPayment.controller.text.isEmpty ||
            double.tryParse(firstPayment.controller.text) ==
                (transaction.subTotal ?? 0.0);

        // Create a new Payment with updated amount and potentially updated controller
        Payment updatedPayment = Payment(
          amount: displayRemainder,
          method: firstPayment.method,
          id: firstPayment.id,
          controller: shouldUpdateControllerText
              ? TextEditingController(text: displayRemainder.toString())
              : firstPayment.controller,
        );

        ref
            .read(paymentMethodsProvider.notifier)
            .updatePaymentMethod(0, updatedPayment);
      }
    }
  }
}
