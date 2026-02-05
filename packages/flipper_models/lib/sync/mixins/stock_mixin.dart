import 'package:flipper_models/SyncStrategy.dart';
import 'dart:async';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart'
    as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';

import 'package:supabase_models/brick/models/all_models.dart' as models;
// import 'package:cbl/cbl.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

mixin StockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Stock?> getStockById({required String id}) async {
    return await ProxyService.getStrategy(
      Strategy.capella,
    ).getStockById(id: id);
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
    Variant? variant = await ProxyService.strategy.getVariant(
      stockId: stock!.id,
    );

    // If appending, add to existing values; otherwise, replace.
    if (currentStock != null) {
      stock.currentStock = appending
          ? (stock.currentStock ?? 0) + currentStock
          : currentStock;
    }
    if (rsdQty != null) {
      stock.rsdQty = appending ? (stock.rsdQty ?? 0) + rsdQty : rsdQty;
    }
    if (initialStock != null) {
      stock.initialStock = appending
          ? (stock.initialStock ?? 0) + initialStock
          : initialStock;
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
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
  }) {
    // This should be implemented by specific sync strategies (e.g., Capella)
    throw UnimplementedError();
  }

  @override
  Future<List<InventoryRequest>> requests({
    String? branchId,
    String? requestId,
  }) async {
    // This should be implemented by specific sync strategies (e.g., Capella)
    throw UnimplementedError();
  }

  @override
  Future<Stock> saveStock({
    Variant? variant,
    required double rsdQty,
    required String productId,
    required String variantId,
    required String branchId,
    required double currentStock,
    required double value,
  }) async {
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

  @override
  Future<String> createStockRequest(
    List<models.TransactionItem> items, {
    required String mainBranchId,
    required String subBranchId,
    String? deliveryNote,
    String? orderNote,
    String? financingId,
  }) async {
    throw UnimplementedError();
  }
}
