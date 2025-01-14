// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/mixins/base_cart_mixin.dart';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin DiscountMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, BaseCartMixin<T> {
  Future<void> applyDiscount(ITransaction transaction) async {
    try {
      final items = await _getActiveTransactionItems(transaction);
      final discountRate = double.tryParse(discountController.text) ?? 0;

      if (discountRate <= 0) return;

      final itemsTotal = _calculateItemsTotal(items);
      if (itemsTotal <= 0) return;

      await _processDiscount(items, discountRate, itemsTotal, transaction);
    } catch (e) {
      talker.error('Error applying discount: $e');
      rethrow;
    }
  }

  Future<List<TransactionItem>> _getActiveTransactionItems(
      ITransaction transaction) async {
    return await ProxyService.strategy.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: transaction.id,
      doneWithTransaction: false,
      active: true,
    );
  }

  double _calculateItemsTotal(List<TransactionItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.qty));
  }

  Future<void> _processDiscount(List<TransactionItem> items,
      double discountRate, double itemsTotal, ITransaction transaction) async {
    final discountAmount = (discountRate * itemsTotal) / 100;
    double remainingDiscount = discountAmount;

    for (var i = 0; i < items.length; i++) {
      await _applyItemDiscount(
        items[i],
        i == items.length - 1,
        discountRate,
        discountAmount,
        itemsTotal,
        remainingDiscount,
      );

      if (i != items.length - 1) {
        remainingDiscount -=
            (items[i].price * items[i].qty / itemsTotal) * discountAmount;
      }
    }

    await ProxyService.strategy.updateTransaction(
      transaction: transaction,
      subTotal: itemsTotal - discountAmount,
    );
  }

  Future<void> _applyItemDiscount(
    TransactionItem item,
    bool isLastItem,
    double discountRate,
    double totalDiscountAmount,
    double itemsTotal,
    double remainingDiscount,
  ) async {
    double itemDiscountAmount = isLastItem
        ? remainingDiscount
        : (item.price * item.qty / itemsTotal) * totalDiscountAmount;

    await ProxyService.strategy.updateTransactionItem(
      transactionItemId: item.id,
      dcRt: discountRate,
      dcAmt: itemDiscountAmount,
    );
  }
}
