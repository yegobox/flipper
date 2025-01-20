// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/mixins/base_cart_mixin.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/states/selectedSupplierProvider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

mixin CartPreviewMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T>, BaseCartMixin<T> {
  Future<void> previewOrOrder(
      {bool isShopingFromWareHouse = true,
      required ITransaction transaction}) async {
    ref.read(previewingCart.notifier).state = !ref.read(previewingCart);

    if (!isShopingFromWareHouse) return;

    try {
      await _processWarehouseOrder(transaction);
    } catch (e, s) {
      talker.info(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<void> _processWarehouseOrder(ITransaction transaction) async {
    final items = await _getActiveTransactionItems(transaction);
    if (items.isEmpty || ref.read(previewingCart)) return;

    final deliveryNote = deliveryNoteCotroller.text;
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;

    String orderId = await ProxyService.strategy.createStockRequest(
      items,
      deliveryNote: deliveryNote,
      deliveryDate: startDate,
      mainBranchId: ref.read(selectedSupplierProvider).value!.serverId!,
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
      branchId: ProxyService.box.getBranchId()!,
      transactionId: transaction.id,
      doneWithTransaction: false,
      active: true,
    );
  }

  Future<void> _markItemsAsDone(
      List<TransactionItem> items, dynamic pendingTransaction) async {
    markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      pendingTransaction: pendingTransaction,
    );
  }

  Future<void> _changeTransactionStatus(
      {required ITransaction transaction}) async {
    await ProxyService.strategy
        .updateTransaction(transaction: transaction, status: ORDERING);
  }
}
