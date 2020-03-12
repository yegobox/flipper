import 'package:moor/moor.dart';

//Todo: examine this table and delete if no inuse anymore!
class PriceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get value => text()();
  IntColumn get categoryId => integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
