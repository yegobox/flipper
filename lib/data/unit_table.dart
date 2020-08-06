import 'package:moor/moor.dart';

class UnitTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().nullable()();
  TextColumn get value => text()();

  BoolColumn get focused => boolean().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
