import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin StockMixin implements StockInterface {
  Repository get repository;

  @override
  Future<Stock?> getStockById({required String id}) async {
    return (await repository.get<Stock>(
      query: Query(where: [Where('id').isExactly(id)]),
    ))
        .firstOrNull;
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
    return await repository.get<InventoryRequest>(
      query: Query(where: [Where('id').isExactly(requestId)]),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<Stock> saveStock(
      {Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required int branchId,
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
