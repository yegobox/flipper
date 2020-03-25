import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/stock_tabble.dart';
import 'package:moor/moor.dart';

part 'stock_dao.g.dart';

@UseDao(tables: [StockTable])
class StockDao extends DatabaseAccessor<Database> with _$StockDaoMixin {
  final Database db;

  StockDao(this.db) : super(db);

  Future insert(Insertable<StockTableData> reason) =>
      into(db.stockTable).insert(reason);

  Future updateStock(StockTableData entry) {
    return update(db.stockTable).replace(entry);
  }

  Future<StockTableData> getStockByVariantId(
      {String branchId, String variantId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.variantId.equals(variantId)))
        .getSingle();
  }

  Future<List<StockTableData>> getStocks() => select(db.stockTable).get();

  Future<List<StockTableData>> getStockByProductId(
      {String branchId, String productId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.productId.equals(productId)))
        .get();
  }

  Stream<List<StockTableData>> getStockByProductIdStream(
      {String branchId, String productId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.productId.equals(productId)))
        .watch();
  }

  Stream<List<StockTableData>> getStockByVariantStream(
      {String branchId, String variationId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.like('%' + branchId + '%'))
          ..where((t) => t.variantId.like('%' + variationId + '%')))
        .watch();
  }

  Future<StockTableData> getById({String id}) {
    return (select(db.stockTable)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<StockTableData>> getStock({String id}) {
    return (select(db.stockTable)..where((t) => t.id.equals(id))).get();
  }

  // Future softDelete(StockTableData entry) {
  //   return update(db.stockTable)
  //       .replace(entry.copyWith(deletedAt: DateTime.now().toIso8601String()));
  // }

  Future<List<StockTableData>> getReasons() => select(db.stockTable).get();

  Future deleteStock(Insertable<StockTableData> stock) =>
      delete(db.stockTable).delete(stock);
}
