import 'package:moor/moor.dart';

class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get username => text().nullable()();
  TextColumn get token => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get avatar => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
