import 'package:moor/moor.dart';

class BusinessUserTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get userId => text().nullable()();

  TextColumn get businessId => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
