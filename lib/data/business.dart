import 'package:moor/moor.dart';

class BusinessTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get active => boolean().withDefault(Constant(false))();

  TextColumn get userId => text()();
  TextColumn get typeId => text()();

  TextColumn get categoryId => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get timeZone => text().nullable()();
  RealColumn get longitude => real().nullable()();
  RealColumn get latitude => real().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
