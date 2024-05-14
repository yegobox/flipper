import 'package:json_annotation/json_annotation.dart';

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
  final List<Item>? itemList;

  Data({
    this.rcptNo,
    this.intrlData,
    this.rcptSign,
    this.totRcptNo,
    this.vsdcRcptPbctDate,
    this.sdcId,
    this.mrcNo,
    this.itemList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Item {
  final String taskCd;
  final String dclDe;
  final int itemSeq;
  final String dclNo;
  final String hsCd;
  String itemNm;
  final String imptItemsttsCd;
  final String orgnNatCd;
  final String exptNatCd;
  final int pkg;
  final dynamic pkgUnitCd;
  final int qty;
  final String qtyUnitCd;
  final int totWt;
  final int netWt;
  final String spplrNm;
  final String agntNm;
  final int invcFcurAmt;
  final String invcFcurCd;
  final double invcFcurExcrt;
  double? supplyPrice;
  double? retailPrice;

  Item({
    required this.taskCd,
    required this.dclDe,
    required this.itemSeq,
    required this.dclNo,
    required this.hsCd,
    required this.itemNm,
    required this.imptItemsttsCd,
    required this.orgnNatCd,
    required this.exptNatCd,
    required this.pkg,
    required this.pkgUnitCd,
    required this.qty,
    required this.qtyUnitCd,
    required this.totWt,
    required this.netWt,
    required this.spplrNm,
    required this.agntNm,
    required this.invcFcurAmt,
    required this.invcFcurCd,
    required this.invcFcurExcrt,
    this.supplyPrice,
    this.retailPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
