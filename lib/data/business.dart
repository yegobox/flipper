import 'package:moor/moor.dart';

class BusinessTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get abbreviation => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(Constant(false))();
  //TODO: add user as foreign key here
  RealColumn get longitude => real().nullable()();
  RealColumn get latitude => real().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
