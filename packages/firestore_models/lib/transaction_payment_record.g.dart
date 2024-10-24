// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_payment_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionPaymentRecordImpl _$$TransactionPaymentRecordImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionPaymentRecordImpl(
      id: (json['id'] as num?)?.toInt(),
      transactionId: (json['transactionId'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

const _$$TransactionPaymentRecordImplFieldMap = <String, String>{
  'id': 'id',
  'transactionId': 'transactionId',
  'amount': 'amount',
  'paymentMethod': 'paymentMethod',
  'createdAt': 'createdAt',
};

// ignore: unused_element
abstract class _$$TransactionPaymentRecordImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? transactionId(int? instance) => instance;
  // ignore: unused_element
  static Object? amount(double? instance) => instance;
  // ignore: unused_element
  static Object? paymentMethod(String? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$TransactionPaymentRecordImplToJson(
        _$TransactionPaymentRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
