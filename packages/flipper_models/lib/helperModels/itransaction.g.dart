// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itransaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ITransaction _$ITransactionFromJson(Map<String, dynamic> json) => ITransaction(
      reference: json['reference'] as String,
      categoryId: json['categoryId'] as String?,
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      transactionNumber: json['transactionNumber'] as String,
      branchId: (json['branchId'] as num).toInt(),
      status: json['status'] as String,
      transactionType: json['transactionType'] as String,
      subTotal: (json['subTotal'] as num).toDouble(),
      paymentType: json['paymentType'] as String,
      cashReceived: (json['cashReceived'] as num).toDouble(),
      customerChangeDue: (json['customerChangeDue'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      supplierId: (json['supplierId'] as num?)?.toInt(),
      receiptType: json['receiptType'] as String?,
      updatedAt: json['updatedAt'] as String?,
      customerId: (json['customerId'] as num?)?.toInt(),
      customerType: json['customerType'] as String?,
      note: json['note'] as String?,
      id: (json['id'] as num?)?.toInt(),
      lastTouched:
          ITransaction._dateTimeFromJson(json['lastTouched'] as String?),
      action: json['action'] as String,
      ticketName: json['ticketName'] as String?,
      deletedAt: ITransaction._dateTimeFromJson(json['deletedAt'] as String?),
    );

const _$ITransactionFieldMap = <String, String>{
  'id': 'id',
  'reference': 'reference',
  'categoryId': 'categoryId',
  'transactionNumber': 'transactionNumber',
  'branchId': 'branchId',
  'status': 'status',
  'transactionType': 'transactionType',
  'subTotal': 'subTotal',
  'paymentType': 'paymentType',
  'cashReceived': 'cashReceived',
  'customerChangeDue': 'customerChangeDue',
  'createdAt': 'createdAt',
  'receiptType': 'receiptType',
  'updatedAt': 'updatedAt',
  'customerId': 'customerId',
  'customerType': 'customerType',
  'note': 'note',
  'lastTouched': 'lastTouched',
  'action': 'action',
  'ticketName': 'ticketName',
  'deletedAt': 'deletedAt',
  'supplierId': 'supplierId',
  'ebmSynced': 'ebmSynced',
};

// ignore: unused_element
abstract class _$ITransactionPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? reference(String instance) => instance;
  // ignore: unused_element
  static Object? categoryId(String? instance) => instance;
  // ignore: unused_element
  static Object? transactionNumber(String instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? status(String instance) => instance;
  // ignore: unused_element
  static Object? transactionType(String instance) => instance;
  // ignore: unused_element
  static Object? subTotal(double instance) => instance;
  // ignore: unused_element
  static Object? paymentType(String instance) => instance;
  // ignore: unused_element
  static Object? cashReceived(double instance) => instance;
  // ignore: unused_element
  static Object? customerChangeDue(double instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String instance) => instance;
  // ignore: unused_element
  static Object? receiptType(String? instance) => instance;
  // ignore: unused_element
  static Object? updatedAt(String? instance) => instance;
  // ignore: unused_element
  static Object? customerId(int? instance) => instance;
  // ignore: unused_element
  static Object? customerType(String? instance) => instance;
  // ignore: unused_element
  static Object? note(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) =>
      ITransaction._dateTimeToJson(instance);
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? ticketName(String? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) =>
      ITransaction._dateTimeToJson(instance);
  // ignore: unused_element
  static Object? supplierId(int? instance) => instance;
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
}

Map<String, dynamic> _$ITransactionToJson(ITransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'categoryId': instance.categoryId,
      'transactionNumber': instance.transactionNumber,
      'branchId': instance.branchId,
      'status': instance.status,
      'transactionType': instance.transactionType,
      'subTotal': instance.subTotal,
      'paymentType': instance.paymentType,
      'cashReceived': instance.cashReceived,
      'customerChangeDue': instance.customerChangeDue,
      'createdAt': instance.createdAt,
      'receiptType': instance.receiptType,
      'updatedAt': instance.updatedAt,
      'customerId': instance.customerId,
      'customerType': instance.customerType,
      'note': instance.note,
      'lastTouched': ITransaction._dateTimeToJson(instance.lastTouched),
      'action': instance.action,
      'ticketName': instance.ticketName,
      'deletedAt': ITransaction._dateTimeToJson(instance.deletedAt),
      'supplierId': instance.supplierId,
      'ebmSynced': instance.ebmSynced,
    };
