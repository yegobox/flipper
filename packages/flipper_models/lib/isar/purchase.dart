library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
part 'purchase.g.dart';

@JsonSerializable()
@Collection()
class Purchase extends IJsonSerializable {
  late String id;
  // these are item on the
  List<String> itemIds;
  // add the following

  /// NOTE: I need to go back to do research
  /// how does purchase does data they enter in on purchase
  /// get data from printed receipt? basically how String? spplrItemClsCd;
  // String? spplrItemCd;
  // String? spplrItemNm; fields are saved and how to get them
  /// the confusion come as those fields are supposed to be saved on item or while saving item
  /// and in my opinion how is that?

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  DateTime createdAt;

  String action;

  String? tin;
  String? bhfId;
  int? invcNo;
  int? orgInvcNo;
  String? spplrTin;
  String? spplrBhfId;
  String? spplrNm;
  String? spplrInvcNo;
  String? regTyCd;
  String? pchsTyCd;
  String? rcptTyCd;
  String? pmtTyCd;
  String? pchsSttsCd;
  String? cfmDt;
  String? pchsDt;
  String? wrhsDt;
  String? cnclReqDt;
  String? cnclDt;
  String? rfdDt;
  int? totItemCnt;
  double? taxblAmtA;
  double? taxblAmtB;
  double? taxblAmtC;
  double? taxblAmtD;
  double? taxRtA;
  double? taxRtB;
  double? taxRtC;
  double? taxRtD;
  double? taxAmtA;
  double? taxAmtB;
  double? taxAmtC;
  double? taxAmtD;
  double? totTaxblAmt;
  double? totTaxAmt;
  double? totAmt;
  String? remark;
  int? modrId;
  String? modrNm;
  int? regrId;

  Purchase({
    required this.id,
    required this.itemIds,
    required this.createdAt,
    required this.action,
    this.lastTouched,
    this.tin,
    this.bhfId,
    this.invcNo,
    this.orgInvcNo,
    this.spplrTin,
    this.spplrBhfId,
    this.spplrNm,
    this.spplrInvcNo,
    this.regTyCd,
    this.pchsTyCd,
    this.rcptTyCd,
    this.pmtTyCd,
    this.pchsSttsCd,
    this.cfmDt,
    this.pchsDt,
    this.wrhsDt,
    this.cnclReqDt,
    this.cnclDt,
    this.rfdDt,
    this.totItemCnt,
    this.taxblAmtA,
    this.taxblAmtB,
    this.taxblAmtC,
    this.taxblAmtD,
    this.taxRtA,
    this.taxRtB,
    this.taxRtC,
    this.taxRtD,
    this.taxAmtA,
    this.taxAmtB,
    this.taxAmtC,
    this.taxAmtD,
    this.totTaxblAmt,
    this.totTaxAmt,
    this.totAmt,
    this.remark,
    this.modrId,
    this.modrNm,
    this.regrId,
  });
  // to json
  @override
  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}
