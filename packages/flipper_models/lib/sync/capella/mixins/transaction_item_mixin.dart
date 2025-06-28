import 'dart:async';

import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaTransactionItemMixin implements TransactionItemInterface {
  Repository get repository;
  Talker get talker;
  @override
  Future<void> addTransactionItem(
      {ITransaction? transaction,
      required bool partOfComposite,
      required bool ignoreForReport,
      required DateTime lastTouched,
      required double discount,
      double? compositePrice,
      bool? doneWithTransaction,
      required double quantity,
      required double currentStock,
      Variant? variation,
      required double amountTotal,
      required String name,
      TransactionItem? item}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError();
  }

  @override
  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    String? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
    bool forceRealData = true,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    String? branchId,
    DateTime? startDate,
    String? branchIdString,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    String? requestId,
    bool fetchRemote = false,
    bool forceRealData = true,
  }) {
    throw UnimplementedError();
  }

  FutureOr<void> updateTransactionItem(
      {double? qty,
      required String transactionItemId,
      double? discount,
      bool? active,
      bool? ignoreForReport,
      double? taxAmt,
      int? quantityApproved,
      int? quantityRequested,
      bool? ebmSynced,
      bool? isRefunded,
      bool? incrementQty,
      double? price,
      double? prc,
      double? splyAmt,
      bool? doneWithTransaction,
      int? quantityShipped,
      double? taxblAmt,
      double? totAmt,
      double? dcRt,
      double? dcAmt}) {
    throw UnimplementedError();
  }
}
