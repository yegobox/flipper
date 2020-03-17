import 'package:moor/moor.dart';

class TaxTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();

  TextColumn get name => text()();
//  TextColumn get channel => text().nullable()();

  BoolColumn get isDefault => boolean()();

  RealColumn get percentage => real().withDefault(Constant(18.0.toDouble()))();

  TextColumn get id => text()();

  TextColumn get businessId => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
