// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RwApiResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RwApiResponse _$RwApiResponseFromJson(Map<String, dynamic> json) =>
    RwApiResponse(
      resultCd: json['resultCd'] as String,
      resultMsg: json['resultMsg'] as String,
      resultDt: json['resultDt'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RwApiResponseToJson(RwApiResponse instance) =>
    <String, dynamic>{
      'resultCd': instance.resultCd,
      'resultMsg': instance.resultMsg,
      'resultDt': instance.resultDt,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      rcptNo: (json['rcptNo'] as num?)?.toInt(),
      intrlData: json['intrlData'] as String?,
      rcptSign: json['rcptSign'] as String?,
      totRcptNo: (json['totRcptNo'] as num?)?.toInt(),
      vsdcRcptPbctDate: json['vsdcRcptPbctDate'] as String?,
      sdcId: json['sdcId'] as String?,
      mrcNo: json['mrcNo'] as String?,
      itemList: (json['itemList'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'rcptNo': instance.rcptNo,
      'intrlData': instance.intrlData,
      'rcptSign': instance.rcptSign,
      'totRcptNo': instance.totRcptNo,
      'vsdcRcptPbctDate': instance.vsdcRcptPbctDate,
      'sdcId': instance.sdcId,
      'mrcNo': instance.mrcNo,
      'itemList': instance.itemList,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      taskCd: json['taskCd'] as String,
      dclDe: json['dclDe'] as String,
      itemSeq: (json['itemSeq'] as num).toInt(),
      dclNo: json['dclNo'] as String,
      hsCd: json['hsCd'] as String,
      itemNm: json['itemNm'] as String,
      imptItemsttsCd: json['imptItemsttsCd'] as String,
      orgnNatCd: json['orgnNatCd'] as String,
      exptNatCd: json['exptNatCd'] as String,
      pkg: (json['pkg'] as num).toInt(),
      pkgUnitCd: json['pkgUnitCd'],
      qty: (json['qty'] as num).toInt(),
      qtyUnitCd: json['qtyUnitCd'] as String,
      totWt: (json['totWt'] as num).toInt(),
      netWt: (json['netWt'] as num).toInt(),
      spplrNm: json['spplrNm'] as String,
      agntNm: json['agntNm'] as String,
      invcFcurAmt: (json['invcFcurAmt'] as num).toInt(),
      invcFcurCd: json['invcFcurCd'] as String,
      invcFcurExcrt: (json['invcFcurExcrt'] as num).toDouble(),
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'taskCd': instance.taskCd,
      'dclDe': instance.dclDe,
      'itemSeq': instance.itemSeq,
      'dclNo': instance.dclNo,
      'hsCd': instance.hsCd,
      'itemNm': instance.itemNm,
      'imptItemsttsCd': instance.imptItemsttsCd,
      'orgnNatCd': instance.orgnNatCd,
      'exptNatCd': instance.exptNatCd,
      'pkg': instance.pkg,
      'pkgUnitCd': instance.pkgUnitCd,
      'qty': instance.qty,
      'qtyUnitCd': instance.qtyUnitCd,
      'totWt': instance.totWt,
      'netWt': instance.netWt,
      'spplrNm': instance.spplrNm,
      'agntNm': instance.agntNm,
      'invcFcurAmt': instance.invcFcurAmt,
      'invcFcurCd': instance.invcFcurCd,
      'invcFcurExcrt': instance.invcFcurExcrt,
    };
