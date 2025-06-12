// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/mixins/base_cart_mixin.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/selected_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin CartPreviewMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, BaseCartMixin<T> {
  Future<void> previewOrOrder(
      {bool isShopingFromWareHouse = true,
      required FinanceProvider financeOption,
      required ITransaction transaction}) async {
    ref.read(previewingCart.notifier).state = !ref.read(previewingCart);

    if (!isShopingFromWareHouse) return;

    try {
      await _processWarehouseOrder(transaction, financeOption);
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<void> _processWarehouseOrder(
      ITransaction transaction, FinanceProvider financeOption) async {
    final items = await _getActiveTransactionItems(transaction);
    if (items.isEmpty || ref.read(previewingCart)) return;

    final deliveryNote = deliveryNoteCotroller.text;
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;

    await ProxyService.strategy.createStockRequest(
      transaction: transaction,
      items,
      financeOption: financeOption,
      deliveryNote: deliveryNote,
      deliveryDate: startDate,
      mainBranchId: ref.read(selectedSupplierProvider)!.serverId!,
    );

    await _finalizeOrder(items, transaction);
  }

  Future<void> _finalizeOrder(
      List<TransactionItem> items, ITransaction transaction) async {
    await _markItemsAsDone(items, transaction);
    await _changeTransactionStatus(transaction: transaction);
    await refreshTransactionItems(transactionId: transaction.id);
  }

  Future<List<TransactionItem>> _getActiveTransactionItems(
      ITransaction transaction) async {
    return await ProxyService.strategy.transactionItems(
      branchId: (await ProxyService.strategy.activeBranch()).id,
      transactionId: transaction.id,
      doneWithTransaction: false,
      active: true,
    );
  }

  Future<void> _markItemsAsDone(
      List<TransactionItem> items, dynamic pendingTransaction) async {
    ProxyService.strategy.markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      ignoreForReport: false,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _changeTransactionStatus(
      {required ITransaction transaction}) async {
    await ProxyService.strategy
        .updateTransaction(transaction: transaction, status: ORDERING);
  }
}
