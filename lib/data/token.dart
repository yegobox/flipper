import 'package:moor/moor.dart';

class TokenTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get token => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
