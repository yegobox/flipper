import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/models/purchase.model.dart';
import 'variant_converter.dart';

// Import the generated file for JSON serialization

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
  @VariantConverter()
  @JsonKey(name: 'itemList')
  List<models.Variant>? itemList;

  @JsonKey(name: 'saleList')
  List<models.Purchase>? saleList;

  Data({
    this.rcptNo,
    this.intrlData,
    this.rcptSign,
    this.totRcptNo,
    this.vsdcRcptPbctDate,
    this.sdcId,
    this.mrcNo,
    this.itemList,
    this.saleList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
