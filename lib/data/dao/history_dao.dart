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
    // using replace will update all fields from the entry that are not marked as a primary key.
    // it will also make sure that only the entry with the same primary key will be updated.
    // Here, this means that the row that has the same id as entry will be updated to reflect
    // the entry's title, content and category. As it set's its where clause automatically, it
    // can not be used together with where.
    return update(db.stockHistoryTable).replace(entry);
  }

  Future<List<StockHistoryTableData>> getHistories() =>
      select(db.stockHistoryTable).get();

  Future<StockHistoryTableData> getById({String id}) {
    return (select(db.stockHistoryTable)..where((t) => t.id.equals(id)))
        .getSingle();
  }
}
