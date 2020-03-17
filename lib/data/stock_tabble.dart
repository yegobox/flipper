import 'package:moor/moor.dart';

class StockTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  IntColumn get currentStock => integer().nullable().withDefault(Constant(0))();
  IntColumn get lowStock => integer().nullable().withDefault(Constant(0))();
  BoolColumn get canTrackingStock => boolean().withDefault(Constant(false))();

  BoolColumn get showLowStockAlert => boolean().withDefault(Constant(false))();

  //this column is not global i.e should not be shared to other apps.
  BoolColumn get isActive =>
      boolean().nullable().withDefault(Constant(false))();

  RealColumn get supplyPrice => real()
      .nullable()
      .customConstraint('DECIMAL(6,2)')
      .withDefault(Constant(0))();

  RealColumn get retailPrice => real()
      .nullable()
      .customConstraint('DECIMAL(6,2)')
      .withDefault(Constant(0))();

  TextColumn get variantId => text()();

  TextColumn get branchId => text()();
  TextColumn get productId => text()();

//  TextColumn get channel => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
