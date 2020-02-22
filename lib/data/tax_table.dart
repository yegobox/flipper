import 'package:moor/moor.dart';

class TaxTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();

  IntColumn get branchId =>
      integer().customConstraint('NULL REFERENCES branch_table(id)')();
  RealColumn get value => real().withDefault(Constant(18.0.toDouble()))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
