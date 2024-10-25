// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DrawersImpl _$$DrawersImplFromJson(Map<String, dynamic> json) =>
    _$DrawersImpl(
      id: (json['id'] as num?)?.toInt(),
      openingBalance: (json['openingBalance'] as num?)?.toDouble(),
      closingBalance: (json['closingBalance'] as num?)?.toDouble(),
      openingDateTime: json['openingDateTime'] as String?,
      closingDateTime: json['closingDateTime'] as String?,
      csSaleCount: (json['csSaleCount'] as num?)?.toInt(),
      tradeName: json['tradeName'] as String?,
      totalNsSaleIncome: (json['totalNsSaleIncome'] as num?)?.toDouble(),
      totalCsSaleIncome: (json['totalCsSaleIncome'] as num?)?.toDouble(),
      nrSaleCount: (json['nrSaleCount'] as num?)?.toInt(),
      nsSaleCount: (json['nsSaleCount'] as num?)?.toInt(),
      trSaleCount: (json['trSaleCount'] as num?)?.toInt(),
      psSaleCount: (json['psSaleCount'] as num?)?.toInt(),
      incompleteSale: (json['incompleteSale'] as num?)?.toInt(),
      otherTransactions: (json['otherTransactions'] as num?)?.toInt(),
      paymentMode: json['paymentMode'] as String?,
      cashierId: (json['cashierId'] as num?)?.toInt(),
      open: json['open'] as bool?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
    );

const _$$DrawersImplFieldMap = <String, String>{
  'id': 'id',
  'openingBalance': 'openingBalance',
  'closingBalance': 'closingBalance',
  'openingDateTime': 'openingDateTime',
  'closingDateTime': 'closingDateTime',
  'csSaleCount': 'csSaleCount',
  'tradeName': 'tradeName',
  'totalNsSaleIncome': 'totalNsSaleIncome',
  'totalCsSaleIncome': 'totalCsSaleIncome',
  'nrSaleCount': 'nrSaleCount',
  'nsSaleCount': 'nsSaleCount',
  'trSaleCount': 'trSaleCount',
  'psSaleCount': 'psSaleCount',
  'incompleteSale': 'incompleteSale',
  'otherTransactions': 'otherTransactions',
  'paymentMode': 'paymentMode',
  'cashierId': 'cashierId',
  'open': 'open',
  'deletedAt': 'deletedAt',
  'businessId': 'businessId',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$$DrawersImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? openingBalance(double? instance) => instance;
  // ignore: unused_element
  static Object? closingBalance(double? instance) => instance;
  // ignore: unused_element
  static Object? openingDateTime(String? instance) => instance;
  // ignore: unused_element
  static Object? closingDateTime(String? instance) => instance;
  // ignore: unused_element
  static Object? csSaleCount(int? instance) => instance;
  // ignore: unused_element
  static Object? tradeName(String? instance) => instance;
  // ignore: unused_element
  static Object? totalNsSaleIncome(double? instance) => instance;
  // ignore: unused_element
  static Object? totalCsSaleIncome(double? instance) => instance;
  // ignore: unused_element
  static Object? nrSaleCount(int? instance) => instance;
  // ignore: unused_element
  static Object? nsSaleCount(int? instance) => instance;
  // ignore: unused_element
  static Object? trSaleCount(int? instance) => instance;
  // ignore: unused_element
  static Object? psSaleCount(int? instance) => instance;
  // ignore: unused_element
  static Object? incompleteSale(int? instance) => instance;
  // ignore: unused_element
  static Object? otherTransactions(int? instance) => instance;
  // ignore: unused_element
  static Object? paymentMode(String? instance) => instance;
  // ignore: unused_element
  static Object? cashierId(int? instance) => instance;
  // ignore: unused_element
  static Object? open(bool? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
}

Map<String, dynamic> _$$DrawersImplToJson(_$DrawersImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'openingBalance': instance.openingBalance,
      'closingBalance': instance.closingBalance,
      'openingDateTime': instance.openingDateTime,
      'closingDateTime': instance.closingDateTime,
      'csSaleCount': instance.csSaleCount,
      'tradeName': instance.tradeName,
      'totalNsSaleIncome': instance.totalNsSaleIncome,
      'totalCsSaleIncome': instance.totalCsSaleIncome,
      'nrSaleCount': instance.nrSaleCount,
      'nsSaleCount': instance.nsSaleCount,
      'trSaleCount': instance.trSaleCount,
      'psSaleCount': instance.psSaleCount,
      'incompleteSale': instance.incompleteSale,
      'otherTransactions': instance.otherTransactions,
      'paymentMode': instance.paymentMode,
      'cashierId': instance.cashierId,
      'open': instance.open,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'businessId': instance.businessId,
      'branchId': instance.branchId,
    };
