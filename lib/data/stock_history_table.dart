import 'package:moor/moor.dart';

class StockHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get quantity => integer()();

  TextColumn get note => text()();

  IntColumn get stockId => integer().customConstraint(
      'NULL REFERENCES stock_table(id) ON DELETE SET NULL ON UPDATE CASCADE')();

  IntColumn get orderId => integer().nullable().customConstraint(
      'NULL REFERENCES order_table(id) ON DELETE SET NULL ON UPDATE CASCADE')();

  IntColumn get reasonId => integer().customConstraint(
      'NULL REFERENCES reason_table(id) ON DELETE SET NULL ON UPDATE CASCADE')();

  IntColumn get variantId =>
      integer().customConstraint('NULL REFERENCES variation_table(id)')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
