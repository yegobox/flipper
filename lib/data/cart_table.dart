import 'package:moor/moor.dart';

class CartTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get branchId => text()();

  IntColumn get count => integer()();

  TextColumn get orderId => text()();

  TextColumn get variationId => text()();

  TextColumn get parentName => text()();
  TextColumn get variationName => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
