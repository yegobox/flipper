import 'package:moor/moor.dart';

// @DataClassName("items")
class ProductTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  TextColumn get name => text()();

  TextColumn get picture => text()();
  BoolColumn get active => boolean()();
  BoolColumn get hasPicture => boolean()();
  BoolColumn get isDraft => boolean()();
  BoolColumn get isCurrentUpdate => boolean()();
  TextColumn get description => text().nullable()();

  TextColumn get color => text().withDefault(Constant("#03bafc")).nullable()();

  TextColumn get businessId => text()();

  TextColumn get supplierId => text()();

  TextColumn get categoryId => text().nullable()();

  TextColumn get taxId => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  TextColumn get deletedAt => text().withDefault(Constant("null")).nullable()();
}
