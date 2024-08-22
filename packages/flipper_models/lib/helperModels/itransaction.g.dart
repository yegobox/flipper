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
      branchId: json['branchId'] as int,
      status: json['status'] as String,
      transactionType: json['transactionType'] as String,
      subTotal: (json['subTotal'] as num).toDouble(),
      paymentType: json['paymentType'] as String,
      cashReceived: (json['cashReceived'] as num).toDouble(),
      customerChangeDue: (json['customerChangeDue'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      supplierId: json['supplierId'] as int?,
      receiptType: json['receiptType'] as String?,
      updatedAt: json['updatedAt'] as String?,
      customerId: json['customerId'] as int?,
      customerType: json['customerType'] as String?,
      note: json['note'] as String?,
      id: json['id'] as int?,
      lastTouched:
          ITransaction._dateTimeFromJson(json['lastTouched'] as String?),
      action: json['action'] as String,
      ticketName: json['ticketName'] as String?,
      deletedAt: ITransaction._dateTimeFromJson(json['deletedAt'] as String?),
    );

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
