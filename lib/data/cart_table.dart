import 'package:moor/moor.dart';

class CartTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer()
      .customConstraint('NULL REFERENCES branch_table(id) ON DELETE CASCADE')();

  IntColumn get count => integer()();

  IntColumn get orderId => integer()
      .customConstraint('NULL REFERENCES order_table(id) ON DELETE CASCADE')();

  IntColumn get variationId => integer().customConstraint(
      'NULL REFERENCES variation_table(id) ON UPDATE CASCADE')();

  TextColumn get parentName => text()();
  TextColumn get variationName => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
