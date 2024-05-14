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

@JsonSerializable()
class SaleList {
  final String spplrTin;
  final String spplrNm;
  final String spplrBhfId;
  final int spplrInvcNo;
  final String rcptTyCd;
  final String pmtTyCd;
  final String cfmDt;
  final String salesDt;
  final String? stockRlsDt;
  final int totItemCnt;
  final double taxblAmtA;
  final double taxblAmtB;
  final double taxblAmtC;
  final double taxblAmtD;
  final double taxRtA;
  final double taxRtB;
  final double taxRtC;
  final double taxRtD;
  final double taxAmtA;
  final double taxAmtB;
  final double taxAmtC;
  final double taxAmtD;
  final double totTaxblAmt;
  final double totTaxAmt;
  final double totAmt;
  final String? remark;
  final List<ItemList>? itemList;

  SaleList({
    required this.spplrTin,
    required this.spplrNm,
    required this.spplrBhfId,
    required this.spplrInvcNo,
    required this.rcptTyCd,
    required this.pmtTyCd,
    required this.cfmDt,
    required this.salesDt,
    this.stockRlsDt,
    required this.totItemCnt,
    required this.taxblAmtA,
    required this.taxblAmtB,
    required this.taxblAmtC,
    required this.taxblAmtD,
    required this.taxRtA,
    required this.taxRtB,
    required this.taxRtC,
    required this.taxRtD,
    required this.taxAmtA,
    required this.taxAmtB,
    required this.taxAmtC,
    required this.taxAmtD,
    required this.totTaxblAmt,
    required this.totTaxAmt,
    required this.totAmt,
    this.remark,
    this.itemList,
  });

  factory SaleList.fromJson(Map<String, dynamic> json) =>
      _$SaleListFromJson(json);

  Map<String, dynamic> toJson() => _$SaleListToJson(this);
}

@JsonSerializable()
class ItemList {
  final int itemSeq;
  final String itemCd;
  final String itemClsCd;
  String itemNm;
  final String? bcd;
  final String pkgUnitCd;
  final int pkg;
  final String qtyUnitCd;
  final int qty;
  final double prc;
  final double splyAmt;
  final double dcRt;
  final double dcAmt;
  final String taxTyCd;
  final double taxblAmt;
  final double taxAmt;
  final double totAmt;

  ItemList({
    required this.itemSeq,
    required this.itemCd,
    required this.itemClsCd,
    required this.itemNm,
    this.bcd,
    required this.pkgUnitCd,
    required this.pkg,
    required this.qtyUnitCd,
    required this.qty,
    required this.prc,
    required this.splyAmt,
    required this.dcRt,
    required this.dcAmt,
    required this.taxTyCd,
    required this.taxblAmt,
    required this.taxAmt,
    required this.totAmt,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) =>
      _$ItemListFromJson(json);

  Map<String, dynamic> toJson() => _$ItemListToJson(this);
}
