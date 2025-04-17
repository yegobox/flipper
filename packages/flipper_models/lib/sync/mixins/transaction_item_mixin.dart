import 'dart:async';

import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin TransactionItemMixin implements TransactionItemInterface {
  Repository get repository;

  @override
  Future<void> addTransactionItem({
    ITransaction? transaction,
    required bool partOfComposite,
    required DateTime lastTouched,
    required double discount,
    bool? doneWithTransaction,
    double? compositePrice,
    required double quantity,
    required double currentStock,
    Variant? variation,
    required double amountTotal,
    required String name,
    TransactionItem? item,
  }) async {
    try {
      // Validate that either `item` or `variation` is provided
      if (item == null && variation == null) {
        throw ArgumentError('Either `item` or `variation` must be provided.');
      }
      if (transaction == null) {
        throw ArgumentError('Either `item` or `variation` must be provided.');
      }

      TransactionItem transactionItem;

      if (item != null) {
        // Use the provided `TransactionItem`
        transactionItem = item;
        transactionItem.qty = quantity; // Update quantity
        transactionItem.doneWithTransaction =
            doneWithTransaction ?? transactionItem.doneWithTransaction;
        // Check if retailPrice is not null before performing calculations
        if (variation?.retailPrice != null) {
          transactionItem.taxblAmt =
              variation!.retailPrice! * quantity; // Recalculate taxblAmt
          transactionItem.totAmt =
              variation.retailPrice! * quantity; // Recalculate totAmt
          transactionItem.remainingStock = currentStock - quantity;
        } else {
          // Handle the case where retailPrice is null
          throw ArgumentError(
              'Retail price is required for transaction item calculations');
        }
      } else {
        // Create a new `TransactionItem` from the `variation` object
        final double price = variation!.retailPrice!;
        final double taxblAmt = price * quantity;
        final double taxAmt =
            double.parse((amountTotal * 18 / 118).toStringAsFixed(2));
        final double totAmt = price * quantity;
        final double dcAmt =
            (price * (variation.qty ?? 1.0)) * (variation.dcRt ?? 0.0);

        transactionItem = TransactionItem(
          itemNm: variation.itemNm ?? variation.name, // Required
          lastTouched: lastTouched, // Required
          name: name, // Use the passed `name` parameter
          qty: quantity, // Required
          price: price, // Required
          discount: discount, // Use the passed `discount` parameter
          prc: price, // Required
          splyAmt: variation.supplyPrice,
          taxTyCd: variation.taxTyCd,
          bcd: variation.bcd,
          itemClsCd: variation.itemClsCd,
          itemTyCd: variation.itemTyCd,
          itemStdNm: variation.itemStdNm,
          orgnNatCd: variation.orgnNatCd,
          pkg: variation.pkg.toString(),
          itemCd: variation.itemCd,
          pkgUnitCd: variation.pkgUnitCd,
          qtyUnitCd: variation.qtyUnitCd,
          tin: variation.tin,
          bhfId: variation.bhfId,
          dftPrc: variation.dftPrc,
          addInfo: variation.addInfo,
          isrcAplcbYn: variation.isrcAplcbYn,
          useYn: variation.useYn,
          regrId: variation.regrId,
          regrNm: variation.regrNm,

          modrId: variation.modrId,
          modrNm: variation.modrNm,
          branchId: ProxyService.box.getBranchId(),
          ebmSynced: false, // Assuming default value
          partOfComposite: partOfComposite,
          compositePrice: compositePrice,
          quantityRequested: quantity.toInt(),
          quantityApproved: 0,
          quantityShipped: 0,
          transactionId: transaction.id,
          variantId: variation.id,
          remainingStock: currentStock - quantity,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isRefunded: false, // Assuming default value
          doneWithTransaction: doneWithTransaction ?? false,
          active: true,
          dcRt: variation.dcRt,
          dcAmt: dcAmt,
          taxblAmt: taxblAmt,
          taxAmt: taxAmt,
          totAmt: totAmt,
          itemSeq: variation.itemSeq,
          isrccCd: variation.isrccCd,
          isrccNm: variation.isrccNm,
          isrcRt: variation.isrcRt,
          isrcAmt: variation.isrcAmt,
        );
      }

      // Upsert the item in the repository
      repository.upsert<TransactionItem>(transactionItem);

      // Fetch all items for the transaction and update their `itemSeq`
      final allItems = await repository.get<TransactionItem>(
        query: Query(
          where: [Where('transactionId').isExactly(transaction.id)],
        ),
      );

      // Sort items by `createdAt`
      allItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      // Update `itemSeq` for each item
      for (var i = 0; i < allItems.length; i++) {
        allItems[i].itemSeq = i + 1; // itemSeq should start from 1
        await repository.upsert<TransactionItem>(allItems[i]);
      }
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    int? branchId,
    DateTime? startDate,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    String? requestId,
    bool fetchRemote = false,
  }) {
    // Create a list of conditions for better readability and debugging
    final List<Where> conditions = [];

    // Always include branchId since it's required
    if (branchId != null) {
      conditions.add(Where('branchId').isExactly(branchId));
    }

    // Optional conditions
    if (transactionId != null) {
      conditions.add(Where('transactionId').isExactly(transactionId));
    }

    if (requestId != null) {
      conditions.add(Where('inventoryRequestId').isExactly(requestId));
    }

    // Date range handling (match transactionsStream logic)
    if (startDate != null && endDate != null) {
      if (startDate == endDate) {
        talker.info('Date Given ${startDate.toIso8601String()}');
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            startDate.toIso8601String(),
          ),
        );
        // Add condition for the end of the same day
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            endDate.add(const Duration(days: 1)).toIso8601String(),
          ),
        );
      } else {
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            startDate.toIso8601String(),
          ),
        );
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            endDate.add(const Duration(days: 1)).toIso8601String(),
          ),
        );
      }
    }

    if (doneWithTransaction != null) {
      conditions
          .add(Where('doneWithTransaction').isExactly(doneWithTransaction));
    }

    if (active != null) {
      conditions.add(Where('active').isExactly(active));
    }

    // Add logging to help debug the query
    talker.debug('TransactionItems query conditions: $conditions');

    final queryString = Query(
      where: conditions,
      orderBy: [OrderBy('lastTouched', ascending: false)],
    );

    // Return the stream directly from repository with mapping
    return repository.subscribe<TransactionItem>(
      query: queryString,
      policy: fetchRemote == true
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
    );
  }

  @override
  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    int? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
  }) async {
    final items = await repository.get<TransactionItem>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : OfflineFirstGetPolicy.localOnly,
        query: Query(where: [
          if (transactionId != null)
            Where('transactionId').isExactly(transactionId),
          if (branchId != null) Where('branchId').isExactly(branchId),
          if (id != null) Where('id').isExactly(id),
          if (doneWithTransaction != null)
            Where('doneWithTransaction').isExactly(doneWithTransaction),
          if (active != null) Where('active').isExactly(active),
          if (variantId != null) Where('variantId').isExactly(active),
          if (requestId != null)
            Where('inventoryRequestId').isExactly(requestId),
        ]));
    return items;
  }

  @override
  FutureOr<void> updateTransactionItem(
      {double? qty,
      required String transactionItemId,
      double? discount,
      bool? active,
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
      double? dcAmt}) async {
    TransactionItem? item = (await repository.get<TransactionItem>(
            query: Query(where: [
      Where('id', value: transactionItemId, compare: Compare.exact),
    ])))
        .firstOrNull;
    if (item != null) {
      item.qty = incrementQty == true ? item.qty + 1 : qty ?? item.qty;
      item.discount = discount ?? item.discount;
      item.active = active ?? item.active;
      item.price = price ?? item.price;
      item.prc = prc ?? item.prc;
      item.taxAmt = taxAmt ?? item.taxAmt;
      item.isRefunded = isRefunded ?? item.isRefunded;
      item.ebmSynced = ebmSynced ?? item.ebmSynced;
      item.quantityApproved =
          (item.quantityApproved ?? 0) + (quantityApproved ?? 0);
      item.quantityRequested = incrementQty == true
          ? (item.qty + 1).toInt()
          : qty?.toInt() ?? item.qty.toInt();
      item.splyAmt = splyAmt ?? item.splyAmt;
      item.quantityShipped = quantityShipped ?? item.quantityShipped;
      item.taxblAmt = taxblAmt ?? item.taxblAmt;
      item.totAmt = totAmt ?? item.totAmt;
      item.doneWithTransaction =
          doneWithTransaction ?? item.doneWithTransaction;
      repository.upsert(policy: OfflineFirstUpsertPolicy.optimisticLocal, item);
    }
  }
}
