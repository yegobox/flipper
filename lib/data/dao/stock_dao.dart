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

  Future<StockTableData> getStockByVariantId({int branchId, int variantId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.variantId.equals(variantId)))
        .getSingle();
  }

  Stream<List<StockTableData>> getStockByVariantIdStream(
      {int branchId, int variantId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.variantId.equals(variantId)))
        .watch();
  }

  Stream<List<StockTableData>> getStockByItemIdStream(
      {int branchId, int itemId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.itemId.equals(itemId)))
        .watch();
  }

  Stream<List<StockTableData>> getStockByVariantStream(
      {int branchId, int variationId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.variantId.equals(variationId)))
        .watch();
  }

  Future<List<StockTableData>> getItemFromStockByItemId(
      {int branchId, int itemId}) {
    return (select(db.stockTable)
          ..where((t) => t.branchId.equals(branchId))
          ..where((t) => t.itemId.equals(itemId)))
        .get();
  }

  Future softDelete(StockTableData entry) {
    return update(db.stockTable)
        .replace(entry.copyWith(deletedAt: DateTime.now().toString()));
  }

  Future<List<StockTableData>> getReasons() => select(db.stockTable).get();

  Future deleteStock(Insertable<StockTableData> stock) =>
      delete(db.stockTable).delete(stock);
}
