import 'package:moor/moor.dart';

// @DataClassName("items")
class ItemTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId =>
      integer().customConstraint('NULL REFERENCES category_table(id)')();
  IntColumn get branchId => integer()();

  IntColumn get unitId =>
      integer().customConstraint('NULL REFERENCES unit_table(id)')();

  // DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
