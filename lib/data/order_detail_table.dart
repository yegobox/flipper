import 'package:moor/moor.dart';

class OrderDetail extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get branchId => text()();

  IntColumn get count => integer()();

  IntColumn get discountRate => integer()();

  IntColumn get discountAmount => integer()();

  TextColumn get unit => text()();

  TextColumn get note => text()();

  IntColumn get taxRate => integer()();

  RealColumn get price => real()();

  RealColumn get taxAmount => real()();

  RealColumn get quantity => real()();

  RealColumn get subTotal => real()();

  TextColumn get orderId => text()();

  TextColumn get variationId => text()();

  TextColumn get variantName => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
