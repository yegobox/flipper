// ignore_for_file: unused_result

import 'package:flipper_dashboard/mixins/base_cart_mixin.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin DiscountMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, BaseCartMixin<T> {
  Future<void> applyDiscount(ITransaction transaction) async {
    try {
      final items = await _getActiveTransactionItems(transaction);
      final discountRate = double.tryParse(discountController.text) ?? 0;

      if (discountRate <= 0 || items.isEmpty) return;

      await _processDiscount(items, discountRate, transaction);
    } catch (e) {
      talker.error('Error applying discount: $e');
      rethrow;
    }
  }

  Future<List<TransactionItem>> _getActiveTransactionItems(
    ITransaction transaction,
  ) async {
    return await ProxyService.getStrategy(Strategy.capella).transactionItems(
      branchId: (await ProxyService.getStrategy(Strategy.capella).activeBranch(
        branchId: ProxyService.box.getBranchId()!,
      )).id,
      transactionId: transaction.id,
      doneWithTransaction: false,
      active: true,
    );
  }

  Future<void> _processDiscount(
    List<TransactionItem> items,
    double discountRate,
    ITransaction transaction,
  ) async {
    final capella = ProxyService.getStrategy(Strategy.capella);
    var netTotal = 0.0;

    for (final item in items) {
      final pricing = SaleLinePricing.compute(
        unitPrice: item.price.toDouble(),
        qty: item.qty.toDouble(),
        dcRt: discountRate,
        taxTyCd: item.taxTyCd ?? 'B',
        taxPercentage: item.taxPercentage?.toDouble() ?? 18.0,
      );
      netTotal += pricing.subtotalNet;
      await capella.updateTransactionItem(
        transactionItemId: item.id,
        ignoreForReport: false,
        dcRt: pricing.dcRt,
        dcAmt: pricing.dcAmt,
        discount: pricing.discount,
        totAmt: pricing.totAmt,
        taxAmt: pricing.taxAmt,
        taxblAmt: pricing.taxblAmt,
      );
      item.dcRt = pricing.dcRt;
      item.dcAmt = pricing.dcAmt;
      item.discount = pricing.discount;
      item.totAmt = pricing.totAmt;
      item.taxAmt = pricing.taxAmt;
      item.taxblAmt = pricing.taxblAmt;
    }

    await capella.updateTransaction(
      transaction: transaction,
      subTotal: netTotal,
    );
    transaction.subTotal = netTotal;
  }
}
