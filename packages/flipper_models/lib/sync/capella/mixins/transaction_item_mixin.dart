import 'dart:async';

import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

mixin CapellaTransactionItemMixin implements TransactionItemInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;
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
  Future<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    String? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
    bool forceRealData = true,
    List<String>? itemIds,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:9');
        return [];
      }
      ditto.sync.registerSubscription(
        "SELECT * FROM transaction_items WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM transaction_items WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );

      String query = 'SELECT * FROM transaction_items';
      final arguments = <String, dynamic>{};
      final conditions = <String>[];

      if (transactionId != null) {
        conditions.add('transactionId = :transactionId');
        arguments['transactionId'] = transactionId;
      }
      if (requestId != null) {
        conditions.add('inventoryRequestId = :requestId');
        arguments['requestId'] = requestId;
      }
      if (branchId != null) {
        conditions.add('branchId = :branchId');
        arguments['branchId'] = branchId;
      }
      if (active != null) {
        conditions.add('active = :active');
        arguments['active'] = active;
      }
      if (doneWithTransaction != null) {
        conditions.add('doneWithTransaction = :doneWithTransaction');
        arguments['doneWithTransaction'] = doneWithTransaction;
      }

      if (conditions.isNotEmpty) {
        query += ' WHERE ' + conditions.join(' AND ');
      }

      // Subscribe to ensure we have the latest data
      await ditto.sync.registerSubscription(query, arguments: arguments);

      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((doc) {
        final data = Map<String, dynamic>.from(doc.value);
        return _convertFromDittoDocument(data);
      }).toList();
    } catch (e) {
      talker.error('Error getting transaction items: $e');
      return [];
    }
  }

  /// Convert Ditto document to TransactionItem model
  TransactionItem _convertFromDittoDocument(Map<String, dynamic> data) {
    DateTime? lastTouched;
    if (data['lastTouched'] != null) {
      if (data['lastTouched'] is String) {
        lastTouched = DateTime.parse(data['lastTouched']);
      } else {
        lastTouched = data['lastTouched'];
      }
    }

    return TransactionItem(
      id: data['_id'] ?? data['id'],
      name: data['name'] ?? '',
      transactionId: data['transactionId'],
      variantId: data['variantId'],
      qty: (data['qty'] as num?)?.toDouble() ?? 0.0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      discount: (data['discount'] as num?)?.toDouble() ?? 0.0,
      taxAmt: (data['taxAmt'] as num?)?.toDouble() ?? 0.0,
      remainingStock: (data['remainingStock'] as num?)?.toDouble() ?? 0.0,
      active: data['active'] ?? true,
      doneWithTransaction: data['doneWithTransaction'] ?? false,
      lastTouched: lastTouched,
      branchId: data['branchId'],
      taxTyCd: data['taxTyCd'],
      bcd: data['bcd'],
      itemClsCd: data['itemClsCd'],
      itemTyCd: data['itemTyCd'],
      itemStdNm: data['itemStdNm'],
      orgnNatCd: data['orgnNatCd'],
      pkgUnitCd: data['pkgUnitCd'],
      qtyUnitCd: data['qtyUnitCd'],
      totAmt: (data['totAmt'] as num?)?.toDouble() ?? 0.0,
      prc: (data['prc'] as num?)?.toDouble() ?? 0.0,
      splyAmt: (data['splyAmt'] as num?)?.toDouble() ?? 0.0,
      tin: data['tin'],
      bhfId: data['bhfId'],
      dftPrc: (data['dftPrc'] as num?)?.toDouble() ?? 0.0,
      addInfo: data['addInfo'],
      isrccCd: data['isrccCd'],
      isrccNm: data['isrccNm'],
      isrcRt: (data['isrcRt'] as num?)?.toInt() ?? 0,
      isrcAmt: (data['isrcAmt'] as num?)?.toInt() ?? 0,
      taxblAmt: (data['taxblAmt'] as num?)?.toDouble() ?? 0.0,
      dcRt: (data['dcRt'] as num?)?.toDouble() ?? 0.0,
      dcAmt: (data['dcAmt'] as num?)?.toDouble() ?? 0.0,
      isrcAplcbYn: data['isrccAplcbYn'],
      useYn: data['useYn'],
      regrId: data['regrId'],
      regrNm: data['regrNm'],
      modrId: data['modrId'],
      modrNm: data['modrNm'],
      itemSeq: data['itemSeq'],
      itemCd: data['itemCd'],
      itemNm: data['itemNm'],
      pkg: data['pkg'],
      ebmSynced: data['ebmSynced'],
      isRefunded: data['isRefunded'],
      ttCatCd: data['ttCatCd'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt:
          data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
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
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized:10');
      return Stream.value([]);
    }

    String query = 'SELECT * FROM transaction_items';
    final arguments = <String, dynamic>{};
    final conditions = <String>[];

    if (transactionId != null) {
      conditions.add('transactionId = :transactionId');
      arguments['transactionId'] = transactionId;
    }
    if (branchId != null) {
      conditions.add('branchId = :branchId');
      arguments['branchId'] = branchId;
    }
    if (active != null) {
      conditions.add('active = :active');
      arguments['active'] = active;
    }
    if (doneWithTransaction != null) {
      conditions.add('doneWithTransaction = :doneWithTransaction');
      arguments['doneWithTransaction'] = doneWithTransaction;
    }
    if (requestId != null) {
      conditions.add('inventoryRequestId = :requestId');
      arguments['requestId'] = requestId;
    }

    // Handle date filtering
    if (startDate != null || endDate != null) {
      if (startDate != null && endDate != null) {
        conditions.add('createdAt >= :startDate');
        conditions.add('createdAt <= :endDate');
        arguments['startDate'] = startDate.toIso8601String();
        arguments['endDate'] =
            endDate.add(const Duration(days: 1)).toIso8601String();
      } else if (startDate != null) {
        conditions.add('createdAt >= :startDate');
        arguments['startDate'] = startDate.toIso8601String();
      } else if (endDate != null) {
        conditions.add('createdAt <= :endDate');
        arguments['endDate'] =
            endDate.add(const Duration(days: 1)).toIso8601String();
      }
    }

    if (conditions.isNotEmpty) {
      query += ' WHERE ' + conditions.join(' AND ');
    }

    // Register subscription to sync data
    ditto.sync.registerSubscription(query, arguments: arguments);

    final controller = StreamController<List<TransactionItem>>.broadcast();
    dynamic observer;

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        if (controller.isClosed) return;

        final items = <TransactionItem>[];
        for (final doc in queryResult.items) {
          try {
            final data = Map<String, dynamic>.from(doc.value);
            items.add(_convertFromDittoDocument(data));
          } catch (e) {
            talker.error('Error converting transaction item: $e');
          }
        }
        controller.add(items);
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  Future<void> updateTransactionItem(
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
      double? dcAmt}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:12');
        return;
      }

      final updates = <String, dynamic>{};
      if (qty != null)
        updates['qty'] = incrementQty == true ? 'qty + $qty' : qty;
      if (discount != null) updates['discount'] = discount;
      if (active != null) updates['active'] = active;
      if (taxAmt != null) updates['taxAmt'] = taxAmt;
      if (ebmSynced != null) updates['ebmSynced'] = ebmSynced;
      if (isRefunded != null) updates['isRefunded'] = isRefunded;
      if (price != null) updates['price'] = price;
      if (prc != null) updates['prc'] = prc;
      if (splyAmt != null) updates['splyAmt'] = splyAmt;
      if (doneWithTransaction != null)
        updates['doneWithTransaction'] = doneWithTransaction;
      if (taxblAmt != null) updates['taxblAmt'] = taxblAmt;
      if (totAmt != null) updates['totAmt'] = totAmt;
      if (dcRt != null) updates['dcRt'] = dcRt;
      if (dcAmt != null) updates['dcAmt'] = dcAmt;

      if (updates.isEmpty) return;

      updates['updatedAt'] = DateTime.now().toIso8601String();

      final setClause = updates.keys
          .map((key) => key == 'qty' && incrementQty == true
              ? '$key = $key + :qty'
              : '$key = :$key')
          .join(', ');

      final query =
          'UPDATE transaction_items SET $setClause WHERE _id = :id OR id = :id';
      final arguments = Map<String, dynamic>.from(updates);
      arguments['id'] = transactionItemId;
      if (incrementQty == true && qty != null) {
        arguments['qty'] = qty;
      }

      await ditto.store.execute(query, arguments: arguments);
    } catch (e) {
      talker.error('Error updating transaction item: $e');
    }
  }
}
