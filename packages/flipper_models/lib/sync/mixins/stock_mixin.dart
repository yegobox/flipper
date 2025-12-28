import 'package:flipper_models/SyncStrategy.dart';
import 'dart:async';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart' hide TransactionItem;
import 'package:supabase_models/brick/models/transactionItem.model.dart'
    as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';

mixin StockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<Stock?> getStockById({required String id}) async {
    return await ProxyService.getStrategy(Strategy.capella)
        .getStockById(id: id);
  }

  @override
  Stream<Stock?> watchStockByVariantId({required String stockId}) {
    throw UnimplementedError('watchStockByVariantId needs to be implemented');
  }

  @override
  Future<void> updateStock({
    required String stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    bool appending = false,
    DateTime? lastTouched,
  }) async {
    Stock? stock = await getStockById(id: stockId);
    Variant? variant =
        await ProxyService.strategy.getVariant(stockId: stock!.id);

    // If appending, add to existing values; otherwise, replace.
    if (currentStock != null) {
      stock.currentStock =
          appending ? (stock.currentStock ?? 0) + currentStock : currentStock;
    }
    if (rsdQty != null) {
      stock.rsdQty = appending ? (stock.rsdQty ?? 0) + rsdQty : rsdQty;
    }
    if (initialStock != null) {
      stock.initialStock =
          appending ? (stock.initialStock ?? 0) + initialStock : initialStock;
    }
    if (value != null) {
      stock.value = appending ? (variant!.retailPrice! * currentStock!) : value;
    }

    // These fields should always be replaced, not appended
    if (ebmSynced != null) {
      stock.ebmSynced = ebmSynced;
    }
    if (lastTouched != null) {
      stock.lastTouched = lastTouched;
    }

    await repository.upsert(stock);
  }

  @override
  Future<List<InventoryRequest>> requests({required String requestId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:19');
    }

    final result = await ditto.store.execute(
      'SELECT * FROM stock_requests WHERE _id = :requestId',
      arguments: {'requestId': requestId},
    );

    return result.items.map((item) {
      final data = Map<String, dynamic>.from(item.value);
      return _convertInventoryRequestFromDitto(data);
    }).toList();
  }

  InventoryRequest _convertInventoryRequestFromDitto(
      Map<String, dynamic> data) {
    // Parse transactionItems from embedded data
    List<models.TransactionItem>? items;
    if (data['transactionItems'] != null && data['transactionItems'] is List) {
      items = (data['transactionItems'] as List).map((itemData) {
        final itemMap = Map<String, dynamic>.from(itemData);
        return models.TransactionItem(
          id: itemMap['id'],
          name: itemMap['name'],
          qty: itemMap['qty'] ?? 0,
          price: itemMap['price'] ?? 0,
          discount: itemMap['discount'] ?? 0,
          prc: itemMap['prc'] ?? 0,
          ttCatCd: itemMap['ttCatCd'],
          quantityRequested: itemMap['quantityRequested'],
          quantityApproved: itemMap['quantityApproved'],
          quantityShipped: itemMap['quantityShipped'],
          transactionId: itemMap['transactionId'],
          variantId: itemMap['variantId'],
          inventoryRequestId: itemMap['inventoryRequestId'],
        );
      }).toList();
    }

    return InventoryRequest(
      id: data['_id'] ?? data['id'],
      mainBranchId: data['mainBranchId'],
      subBranchId: data['subBranchId'],
      branchId: data['branchId'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      status: data['status'],
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.parse(data['deliveryDate'])
          : null,
      deliveryNote: data['deliveryNote'],
      orderNote: data['orderNote'],
      customerReceivedOrder: data['customerReceivedOrder'],
      driverRequestDeliveryConfirmation:
          data['driverRequestDeliveryConfirmation'],
      driverId: data['driverId'],
      updatedAt:
          data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
      itemCounts: data['itemCounts'],
      bhfId: data['bhfId'],
      tinNumber: data['tinNumber'],
      financingId: data['financingId'],
      transactionItems: items,
    );
  }

  @override
  Future<Stock> saveStock(
      {Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required String branchId,
      required double currentStock,
      required double value}) async {
    final stock = Stock(
      id: const Uuid().v4(),
      lastTouched: DateTime.now().toUtc(),
      branchId: branchId,
      currentStock: currentStock,
      rsdQty: rsdQty,
      value: value,
    );
    return await repository.upsert<Stock>(stock);
  }
}
