// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: (json['id'] as num?)?.toInt(),
      reference: json['reference'] as String?,
      categoryId: json['categoryId'] as String?,
      transactionNumber: json['transactionNumber'] as String?,
      branchId: (json['branchId'] as num?)?.toInt() ?? null,
      status: json['status'] as String? ?? null,
      transactionType: json['transactionType'] as String? ?? null,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      paymentType: json['paymentType'] as String?,
      cashReceived: (json['cashReceived'] as num?)?.toDouble() ?? 0.0,
      customerChangeDue: (json['customerChangeDue'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] as String? ?? null,
      receiptType: json['receiptType'] as String?,
      updatedAt: json['updatedAt'] as String?,
      customerId: (json['customerId'] as num?)?.toInt() ?? null,
      customerType: json['customerType'] as String?,
      note: json['note'] as String?,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      ticketName: json['ticketName'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      supplierId: (json['supplierId'] as num?)?.toInt(),
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      isIncome: json['isIncome'] as bool? ?? false,
      isExpense: json['isExpense'] as bool? ?? false,
      isRefunded: json['isRefunded'] as bool? ?? false,
      customerName: json['customerName'] as String?,
      customerTin: json['customerTin'] as String?,
      remark: json['remark'] as String?,
      customerBhfId: json['customerBhfId'] as String?,
      sarTyCd: json['sarTyCd'] as String?,
      receiptNumber: (json['receiptNumber'] as num?)?.toInt(),
      totalReceiptNumber: (json['totalReceiptNumber'] as num?)?.toInt(),
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
    );

const _$$TransactionImplFieldMap = <String, String>{
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
  'ticketName': 'ticketName',
  'deletedAt': 'deletedAt',
  'supplierId': 'supplierId',
  'ebmSynced': 'ebmSynced',
  'isIncome': 'isIncome',
  'isExpense': 'isExpense',
  'isRefunded': 'isRefunded',
  'customerName': 'customerName',
  'customerTin': 'customerTin',
  'remark': 'remark',
  'customerBhfId': 'customerBhfId',
  'sarTyCd': 'sarTyCd',
  'receiptNumber': 'receiptNumber',
  'totalReceiptNumber': 'totalReceiptNumber',
  'invoiceNumber': 'invoiceNumber',
};

// ignore: unused_element
abstract class _$$TransactionImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? reference(String? instance) => instance;
  // ignore: unused_element
  static Object? categoryId(String? instance) => instance;
  // ignore: unused_element
  static Object? transactionNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? status(String? instance) => instance;
  // ignore: unused_element
  static Object? transactionType(String? instance) => instance;
  // ignore: unused_element
  static Object? subTotal(double instance) => instance;
  // ignore: unused_element
  static Object? paymentType(String? instance) => instance;
  // ignore: unused_element
  static Object? cashReceived(double instance) => instance;
  // ignore: unused_element
  static Object? customerChangeDue(double instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
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
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? ticketName(String? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? supplierId(int? instance) => instance;
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? isIncome(bool instance) => instance;
  // ignore: unused_element
  static Object? isExpense(bool instance) => instance;
  // ignore: unused_element
  static Object? isRefunded(bool instance) => instance;
  // ignore: unused_element
  static Object? customerName(String? instance) => instance;
  // ignore: unused_element
  static Object? customerTin(String? instance) => instance;
  // ignore: unused_element
  static Object? remark(String? instance) => instance;
  // ignore: unused_element
  static Object? customerBhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? sarTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? receiptNumber(int? instance) => instance;
  // ignore: unused_element
  static Object? totalReceiptNumber(int? instance) => instance;
  // ignore: unused_element
  static Object? invoiceNumber(int? instance) => instance;
}

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
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
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'ticketName': instance.ticketName,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'supplierId': instance.supplierId,
      'ebmSynced': instance.ebmSynced,
      'isIncome': instance.isIncome,
      'isExpense': instance.isExpense,
      'isRefunded': instance.isRefunded,
      'customerName': instance.customerName,
      'customerTin': instance.customerTin,
      'remark': instance.remark,
      'customerBhfId': instance.customerBhfId,
      'sarTyCd': instance.sarTyCd,
      'receiptNumber': instance.receiptNumber,
      'totalReceiptNumber': instance.totalReceiptNumber,
      'invoiceNumber': instance.invoiceNumber,
    };
