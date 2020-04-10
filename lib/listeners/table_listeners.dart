import 'package:flipper/data/main_database.dart';
import 'package:flipper/data/order_detail_table.dart';
import 'package:flipper/data/order_table.dart';
import 'package:flipper/data/stock_history_table.dart';
import 'package:flipper/data/stock_tabble.dart';
import 'package:moor/moor.dart';

part 'table_listeners.g.dart';

@UseDao(tables: [StockTable, OrderTable, OrderDetailTable, StockHistoryTable])
class Listner extends DatabaseAccessor<Database> with _$ListnerMixin {
  final Database db;

  Listner(this.db) : super(db);

  //reference: https://github.com/simolus3/moor/issues/394
  Stream<StockTableData> streamUpdate() {
    return tableUpdates(TableUpdateQuery.onTable(stockTable,
        limitUpdateKind: UpdateKind.update));
  }

  Stream<StockTableData> streamInsert() {
    return tableUpdates(TableUpdateQuery.onTable(stockTable,
        limitUpdateKind: UpdateKind.insert));
  }

  Stream<StockHistoryTableData> listenOnStockHistory() {
    return tableUpdates(TableUpdateQuery.onTable(stockHistoryTable,
        limitUpdateKind: UpdateKind.insert));
  }
}
