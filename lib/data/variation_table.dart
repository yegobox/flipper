import 'package:moor/moor.dart';

class VariationTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get sku => text().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get productId => text()();

  //this is a helper column should be in other app db. or synced.
  BoolColumn get isActive => boolean().withDefault(Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant('null')).nullable()();
}
