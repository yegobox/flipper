import 'package:moor/moor.dart';

class StockTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentStock => integer().nullable().withDefault(Constant(0))();
  BoolColumn get canTrackStock => boolean().withDefault(Constant(false))();

  BoolColumn get isActive => boolean().withDefault(Constant(false))();

  RealColumn get costPrice => real()
      .nullable()
      .customConstraint('DECIMAL(6,2)')
      .withDefault(Constant(0))();

  RealColumn get retailPrice => real()
      .nullable()
      .customConstraint('DECIMAL(6,2)')
      .withDefault(Constant(0))();

  IntColumn get itemId => integer()();

  IntColumn get variantId =>
      integer().customConstraint('NULL REFERENCES variation_table(id)')();

  IntColumn get branchId =>
      integer().customConstraint('NULL REFERENCES branch_table(id) ')();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
