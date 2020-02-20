import 'package:moor/moor.dart';

class VariationTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get sku => text().nullable()();
  IntColumn get branchId =>
      integer().customConstraint('NULL REFERENCES branch_table(id)')();

  IntColumn get itemId =>
      integer().customConstraint('NULL REFERENCES item_table(id)')();

  BoolColumn get isActive => boolean().withDefault(Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
