import 'package:moor/moor.dart';

class OrderTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();

//  .customConstraint(
//      'NULL REFERENCES branch_table(id) ON DELETE SET NULL')
  TextColumn get branchId => text()();
  IntColumn get orderNUmber => integer().nullable()();
  IntColumn get supplierId => integer().nullable()();
  IntColumn get subTotal => integer().nullable()();
  IntColumn get supplierInvoiceNumber => integer().nullable()();
  DateTimeColumn get deliverDate => dateTime().nullable()();
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
  TextColumn get status => text().withDefault(Constant("draft"))();
  IntColumn get customerChangeDue => integer().nullable()();
}
