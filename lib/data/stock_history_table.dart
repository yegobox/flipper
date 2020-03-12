import 'package:moor/moor.dart';

class StockHistoryTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  IntColumn get quantity => integer()();

  TextColumn get note => text()();

  TextColumn get id => text()();

  TextColumn get reason => text()();

  // .customConstraint(
  // 'NULL REFERENCES stock_table(id) ON DELETE SET NULL ON UPDATE CASCADE')

  TextColumn get stockId => text()();

  TextColumn get variantId => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
