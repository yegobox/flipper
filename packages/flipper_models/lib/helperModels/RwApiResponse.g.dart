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
          ?.map((e) => Variant.fromJson(e as Map<String, dynamic>))
          .toList(),
      saleList: (json['saleList'] as List<dynamic>?)
          ?.map((e) => SaleList.fromJson(e as Map<String, dynamic>))
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
      'saleList': instance.saleList,
    };
