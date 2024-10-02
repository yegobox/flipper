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

const _$ReceiptFieldMap = <String, String>{
  'deletedAt': 'deletedAt',
  'id': 'id',
  'resultCd': 'resultCd',
  'resultMsg': 'resultMsg',
  'resultDt': 'resultDt',
  'rcptNo': 'rcptNo',
  'intrlData': 'intrlData',
  'rcptSign': 'rcptSign',
  'totRcptNo': 'totRcptNo',
  'vsdcRcptPbctDate': 'vsdcRcptPbctDate',
  'sdcId': 'sdcId',
  'mrcNo': 'mrcNo',
  'qrCode': 'qrCode',
  'receiptType': 'receiptType',
  'branchId': 'branchId',
  'transactionId': 'transactionId',
  'lastTouched': 'lastTouched',
  'action': 'action',
};

// ignore: unused_element
abstract class _$ReceiptPerFieldToJson {
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? resultCd(String instance) => instance;
  // ignore: unused_element
  static Object? resultMsg(String instance) => instance;
  // ignore: unused_element
  static Object? resultDt(String instance) => instance;
  // ignore: unused_element
  static Object? rcptNo(int instance) => instance;
  // ignore: unused_element
  static Object? intrlData(String instance) => instance;
  // ignore: unused_element
  static Object? rcptSign(String instance) => instance;
  // ignore: unused_element
  static Object? totRcptNo(int instance) => instance;
  // ignore: unused_element
  static Object? vsdcRcptPbctDate(String instance) => instance;
  // ignore: unused_element
  static Object? sdcId(String instance) => instance;
  // ignore: unused_element
  static Object? mrcNo(String instance) => instance;
  // ignore: unused_element
  static Object? qrCode(String instance) => instance;
  // ignore: unused_element
  static Object? receiptType(String instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? transactionId(int instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? action(String instance) => instance;
}

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
