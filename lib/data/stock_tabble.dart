import 'package:moor/moor.dart';

class StockTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get currentStock => integer()();
  BoolColumn get canTrackStock => boolean().withDefault(Constant(false))();

  BoolColumn get isActive => boolean().withDefault(Constant(false))();

  RealColumn get costPrice =>
      real().customConstraint('DECIMAL(6,2)').withDefault(Constant(0))();

  RealColumn get retailPrice =>
      real().customConstraint('DECIMAL(6,2)').withDefault(Constant(0))();
  IntColumn get itemId => integer()
      .nullable()
      .customConstraint('NULL REFERENCES item_table(id) ON DELETE SET NULL')();

  IntColumn get variantId => integer().nullable().customConstraint(
      'NULL REFERENCES variation_table(id) ON DELETE SET NULL')();

  IntColumn get branchId => integer().nullable().customConstraint(
      'NULL REFERENCES branch_table(id) ON DELETE SET NULL')();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
