// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drawers _$DrawersFromJson(Map<String, dynamic> json) => Drawers(
      id: (json['id'] as num?)?.toInt(),
      openingBalance: (json['openingBalance'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
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
      cashierId: (json['cashierId'] as num).toInt(),
      open: json['open'] as bool,
    )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

Map<String, dynamic> _$DrawersToJson(Drawers instance) => <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
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
    };
