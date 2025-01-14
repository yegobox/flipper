import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_models/brick/models/all_models.dart';

part 'RwApiResponse.g.dart';

@JsonSerializable()
class RwApiResponse {
  final String resultCd;
  final String resultMsg;
  final String? resultDt;
  final Data? data;

  RwApiResponse({
    required this.resultCd,
    required this.resultMsg,
    this.resultDt,
    this.data,
  });

  factory RwApiResponse.fromJson(Map<String, dynamic> json) =>
      _$RwApiResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RwApiResponseToJson(this);
}

@JsonSerializable()
class Data {
  final int? rcptNo;
  final String? intrlData;
  final String? rcptSign;
  final int? totRcptNo;
  final String? vsdcRcptPbctDate;
  final String? sdcId;
  final String? mrcNo;
  final List<Variant>? itemList;
  final List<SaleList>? saleList; // Added saleList here

  Data({
    this.rcptNo,
    this.intrlData,
    this.rcptSign,
    this.totRcptNo,
    this.vsdcRcptPbctDate,
    this.sdcId,
    this.mrcNo,
    this.itemList,
    this.saleList, // Added saleList here
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
