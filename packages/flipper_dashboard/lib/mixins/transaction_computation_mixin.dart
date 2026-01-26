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

    // Fallback/Validation: Check if the transaction's stored subTotal is larger (implying missing items in the UI list)
    if (transaction != null && (transaction.subTotal ?? 0.0) > baseTotal) {
      baseTotal = transaction.subTotal!;
    }

    if (discountPercent > 0) {
      final discountAmount = (baseTotal * discountPercent) / 100;
      return baseTotal - discountAmount;
    }

    return baseTotal;
  }

  double calculateTotalPaid(List<Payment> payments) {
    return payments.fold<double>(0.0, (sum, p) => sum + p.amount);
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
        key: 'getCashReceived',
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
                controller: payments[0].controller,
              ),
              transactionId: transaction.id,
            );
        payments[0].controller.text = displayRemainder.toString();
      }
    }
  }
}
