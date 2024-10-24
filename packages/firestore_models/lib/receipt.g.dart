// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReceiptImpl _$$ReceiptImplFromJson(Map<String, dynamic> json) =>
    _$ReceiptImpl(
      id: (json['id'] as num?)?.toInt(),
      rcptNo: (json['rcptNo'] as num?)?.toInt(),
      totRcptNo: (json['totRcptNo'] as num?)?.toInt(),
      invcNo: (json['invcNo'] as num?)?.toInt(),
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
      receiptType: json['receiptType'] as String?,
      resultCd: json['resultCd'] as String?,
      resultMsg: json['resultMsg'] as String?,
      resultDt: json['resultDt'] as String?,
      intrlData: json['intrlData'] as String?,
      rcptSign: json['rcptSign'] as String?,
      vsdcRcptPbctDate: json['vsdcRcptPbctDate'] as String?,
      sdcId: json['sdcId'] as String?,
      mrcNo: json['mrcNo'] as String?,
      qrCode: json['qrCode'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      transactionId: (json['transactionId'] as num?)?.toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      whenCreated: json['whenCreated'] == null
          ? null
          : DateTime.parse(json['whenCreated'] as String),
    );

const _$$ReceiptImplFieldMap = <String, String>{
  'id': 'id',
  'rcptNo': 'rcptNo',
  'totRcptNo': 'totRcptNo',
  'invcNo': 'invcNo',
  'invoiceNumber': 'invoiceNumber',
  'receiptType': 'receiptType',
  'resultCd': 'resultCd',
  'resultMsg': 'resultMsg',
  'resultDt': 'resultDt',
  'intrlData': 'intrlData',
  'rcptSign': 'rcptSign',
  'vsdcRcptPbctDate': 'vsdcRcptPbctDate',
  'sdcId': 'sdcId',
  'mrcNo': 'mrcNo',
  'qrCode': 'qrCode',
  'branchId': 'branchId',
  'transactionId': 'transactionId',
  'lastTouched': 'lastTouched',
  'whenCreated': 'whenCreated',
};

// ignore: unused_element
abstract class _$$ReceiptImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? rcptNo(int? instance) => instance;
  // ignore: unused_element
  static Object? totRcptNo(int? instance) => instance;
  // ignore: unused_element
  static Object? invcNo(int? instance) => instance;
  // ignore: unused_element
  static Object? invoiceNumber(int? instance) => instance;
  // ignore: unused_element
  static Object? receiptType(String? instance) => instance;
  // ignore: unused_element
  static Object? resultCd(String? instance) => instance;
  // ignore: unused_element
  static Object? resultMsg(String? instance) => instance;
  // ignore: unused_element
  static Object? resultDt(String? instance) => instance;
  // ignore: unused_element
  static Object? intrlData(String? instance) => instance;
  // ignore: unused_element
  static Object? rcptSign(String? instance) => instance;
  // ignore: unused_element
  static Object? vsdcRcptPbctDate(String? instance) => instance;
  // ignore: unused_element
  static Object? sdcId(String? instance) => instance;
  // ignore: unused_element
  static Object? mrcNo(String? instance) => instance;
  // ignore: unused_element
  static Object? qrCode(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? transactionId(int? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? whenCreated(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$ReceiptImplToJson(_$ReceiptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rcptNo': instance.rcptNo,
      'totRcptNo': instance.totRcptNo,
      'invcNo': instance.invcNo,
      'invoiceNumber': instance.invoiceNumber,
      'receiptType': instance.receiptType,
      'resultCd': instance.resultCd,
      'resultMsg': instance.resultMsg,
      'resultDt': instance.resultDt,
      'intrlData': instance.intrlData,
      'rcptSign': instance.rcptSign,
      'vsdcRcptPbctDate': instance.vsdcRcptPbctDate,
      'sdcId': instance.sdcId,
      'mrcNo': instance.mrcNo,
      'qrCode': instance.qrCode,
      'branchId': instance.branchId,
      'transactionId': instance.transactionId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'whenCreated': instance.whenCreated?.toIso8601String(),
    };
