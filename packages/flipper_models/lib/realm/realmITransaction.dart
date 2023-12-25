import 'package:realm/realm.dart';

part 'realmITransaction.g.dart';

@RealmModel()
class _RealmITransaction {
  late String id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  late String reference;
  String? categoryId;
  late String transactionNumber;
  late int branchId;
  late String status;
  late String transactionType;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  // add receipt type offerered on this transaction
  /// a comma separated of the receipt type offered on this transaction eg. NR, NS etc...
  String? receiptType;
  String? updatedAt;

  String? customerId;
  String? note;

  DateTime? lastTouched;

  late String action;

  // int categoryId;

  String? ticketName;
  DateTime? deletedAt;

  // fields when a transaction is created for ordering system
  int? supplierId;

  void updateProperties(RealmITransaction other) {
    reference = other.reference;
    transactionNumber = other.transactionNumber;
    branchId = other.branchId;
    status = other.status;
    transactionType = other.transactionType;
    subTotal = other.subTotal;
    paymentType = other.paymentType;
    cashReceived = other.cashReceived;
    customerChangeDue = other.customerChangeDue;
    createdAt = other.createdAt;
    action = other.action;
    categoryId = other.categoryId;
    customerId = other.customerId;
    deletedAt = other.deletedAt;
    lastTouched = other.lastTouched;
    note = other.note;
    receiptType = other.receiptType;
    supplierId = other.supplierId;
    ticketName = other.ticketName;
    updatedAt = other.updatedAt;
  }
}
