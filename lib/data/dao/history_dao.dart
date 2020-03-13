import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/stock_history_table.dart';
import 'package:moor/moor.dart';

part 'history_dao.g.dart';

@UseDao(tables: [StockHistoryTable])
class StockHistoryDao extends DatabaseAccessor<Database>
    with _$StockHistoryDaoMixin {
  final Database db;

  StockHistoryDao(this.db) : super(db);

  Future insert(Insertable<StockHistoryTableData> stockHistory) =>
      into(db.stockHistoryTable).insert(stockHistory);

  Future updateHistory(StockHistoryTableData entry) {
    return update(db.stockHistoryTable).replace(entry);
  }

  Future<List<StockHistoryTableData>> getHistories() =>
      select(db.stockHistoryTable).get();

  Future<StockHistoryTableData> getById({String id}) {
    return (select(db.stockHistoryTable)
          ..where((t) => t.id.like('%' + id + '%')))
        .getSingle();
  }

  Future<StockHistoryTableData> getByVariantId({String variantId}) {
    return (select(db.stockHistoryTable)
          ..where((t) => t.variantId.like('%' + variantId + '%')))
        .getSingle();
  }
}
