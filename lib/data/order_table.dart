import 'package:moor/moor.dart';

class OrderTable extends Table {
  IntColumn get idLocal => integer().autoIncrement()();
  TextColumn get id => text()();
  IntColumn get userId => integer()();
  TextColumn get branchId => text()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get currency => text().nullable()();
  TextColumn get reference => text().nullable()();
  IntColumn get orderNUmber => integer().nullable()();
  IntColumn get supplierId => integer().nullable()();
  IntColumn get subTotal => integer().nullable()();
  IntColumn get supplierInvoiceNumber => integer().nullable()();
  DateTimeColumn get deliverDate => dateTime().nullable()();
  DateTimeColumn get orderDate => dateTime().nullable()();
  IntColumn get taxRate => integer().nullable()();
  IntColumn get taxAmount => integer().nullable()();
  IntColumn get count => integer().withDefault(Constant(1))();
  TextColumn get variantName => text().nullable()();

  IntColumn get discountRate => integer().nullable()();
  IntColumn get discountAmount => integer().nullable()();
  IntColumn get cashReceived => integer().nullable()();
  IntColumn get saleTotal => integer().nullable()();
  IntColumn get customerSaving => integer().nullable()();
  IntColumn get paymentId => integer().nullable()();
  TextColumn get orderNote => text().nullable()();
  BoolColumn get isDraft => boolean().withDefault(Constant(true))();
  TextColumn get status => text().withDefault(Constant('draft'))();
  TextColumn get orderType => text().withDefault(Constant('sales'))();
  IntColumn get customerChangeDue => integer().nullable()();
}
