// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      id: (json['id'] as num?)?.toInt(),
      resultCd: json['resultCd'] as String,
      branchId: (json['branchId'] as num).toInt(),
      resultMsg: json['resultMsg'] as String,
      resultDt: json['resultDt'] as String,
      rcptNo: (json['rcptNo'] as num).toInt(),
      intrlData: json['intrlData'] as String,
      rcptSign: json['rcptSign'] as String,
      totRcptNo: (json['totRcptNo'] as num).toInt(),
      vsdcRcptPbctDate: json['vsdcRcptPbctDate'] as String,
      sdcId: json['sdcId'] as String,
      mrcNo: json['mrcNo'] as String,
      qrCode: json['qrCode'] as String,
      receiptType: json['receiptType'] as String,
      transactionId: (json['transactionId'] as num).toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String? ?? "created",
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'resultCd': instance.resultCd,
      'resultMsg': instance.resultMsg,
      'resultDt': instance.resultDt,
      'rcptNo': instance.rcptNo,
      'intrlData': instance.intrlData,
      'rcptSign': instance.rcptSign,
      'totRcptNo': instance.totRcptNo,
      'vsdcRcptPbctDate': instance.vsdcRcptPbctDate,
      'sdcId': instance.sdcId,
      'mrcNo': instance.mrcNo,
      'qrCode': instance.qrCode,
      'receiptType': instance.receiptType,
      'branchId': instance.branchId,
      'transactionId': instance.transactionId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
    };
