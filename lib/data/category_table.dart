import 'package:moor/moor.dart';

class CategoryTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();

  //should not be pushed to other app.
  BoolColumn get focused => boolean()();
  TextColumn get id => text()();

  TextColumn get name => text()();
//  TextColumn get channels => text()();

  TextColumn get branchId => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get deletedAt => text().withDefault(Constant('null')).nullable()();
}
