import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/order_detail_table.dart';
import 'package:flipper/data/order_table.dart';
import 'package:flipper/data/stock_tabble.dart';
import 'package:moor/moor.dart';

part 'stock_dao.g.dart';

@UseDao(tables: [StockTable, OrderTable, OrderDetailTable])
class StockDao extends DatabaseAccessor<Database> with _$StockDaoMixin {
  final Database db;

  StockDao(this.db) : super(db);

  Future insert(Insertable<StockTableData> stock) =>
      into(db.stockTable).insert(stock);

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

  Future<List<OrderDetailTableData>> getReport({String dateFilter}) {
    switch (dateFilter) {
      case '1D':
        final dateFil = DateTime.now();
        return (select(db.orderDetailTable)
              ..where((t) {
                final date = t.createdAt;
                return date.year.equals(dateFil.year) &
                    date.month.equals(dateFil.month) &
                    date.day.equals(dateFil.day);
              }))
            .get();

        break;
      case '1W':
        final today = DateTime.now();
        final week = today.subtract(
            new Duration(days: 7)); //this will give is a week back in time

        //reference: https://github.com/simolus3/moor/issues/304#issuecomment-606201777
        return (select(db.orderDetailTable)
              ..where((row) => row.createdAt.isBetweenValues(week, today)))
            .get();
        break;
      case '1M':
        final today = DateTime.now();

        DateTime lastDayOfMonth = new DateTime(today.year, today.month + 1, 0);

        final week = today.subtract(new Duration(
            days: lastDayOfMonth.day)); //this will give is a month back in time

        //reference: https://github.com/simolus3/moor/issues/304#issuecomment-606201777
        return (select(db.orderDetailTable)
              ..where((row) => row.createdAt.isBetweenValues(week, today)))
            .get();
        break;
      case '3M':
        final today = DateTime.now();

        DateTime lastDayOfMonth = new DateTime(today.year, today.month + 1, 0);

        final week = today.subtract(new Duration(days: lastDayOfMonth.day * 3));

        //reference: https://github.com/simolus3/moor/issues/304#issuecomment-606201777
        return (select(db.orderDetailTable)
              ..where((row) => row.createdAt.isBetweenValues(week, today)))
            .get();
        break;

      case '3M':
        final today = DateTime.now();

        DateTime lastDayOfMonth = new DateTime(today.year, today.month + 1, 0);

        final week =
            today.subtract(new Duration(days: lastDayOfMonth.day * 11));

        //reference: https://github.com/simolus3/moor/issues/304#issuecomment-606201777
        return (select(db.orderDetailTable)
              ..where((row) => row.createdAt.isBetweenValues(week, today)))
            .get();
        break;
      case 'custom':
        break;
      default:
        final dateFil = DateTime.now();
        return (select(db.orderDetailTable)
              ..where((t) {
                final date = t.createdAt;
                return date.year.equals(dateFil.year) &
                    date.month.equals(dateFil.month) &
                    date.day.equals(dateFil.day);
              }))
            .get();
    }
  }

  Future<List<StockTableData>> getReasons() => select(db.stockTable).get();

  Future deleteStock(Insertable<StockTableData> stock) =>
      delete(db.stockTable).delete(stock);
}

//example of more advanced query use them later after v1. if necessary.
// return (select(db.orderDetailTable)
//       ..where((t) {
//         final date = t.createdAt;
//         return date.year.equals(dateFil.year) &
//             date.month.equals(dateFil.month) &
//             date.day.equals(dateFil.day);
//       }))
//     .join([
//   leftOuterJoin(db.stockHistoryTable,
//       db.productTable.id.equalsExp(db.orderDetailTable.id)),
// ]).map(
//   (rows) {
//     return rows.readTable(db.orderDetailTable);
//   },
// ).get();
