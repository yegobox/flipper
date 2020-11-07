import 'package:moor/moor.dart';


class OrderDetailTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get branchId => text()();

  IntColumn get discountRate => integer()();

  IntColumn get discountAmount => integer()();

  TextColumn get unit => text()();

  //need to clarification.
  TextColumn get note => text()();

  IntColumn get taxRate => integer()();

  RealColumn get taxAmount => real()();

  RealColumn get quantity => real()();

  RealColumn get subTotal => real()();

  TextColumn get orderId => text()();

  TextColumn get stockId => text()();

  TextColumn get variationId => text()();

  TextColumn get variantName => text()();

  TextColumn get productName => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
