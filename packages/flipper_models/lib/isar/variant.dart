// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'variant.g.dart';

@JsonSerializable()
@Collection()
class Variant extends IJsonSerializable {
  Id? id = null;
  @Index(caseSensitive: true)
  late String name;
  late String sku;
  @Index()
  late int productId;
  late String unit;
  late String productName;
  late int branchId;
  late String? taxName;
  double? taxPercentage;

  late bool isTaxExempted;

  // add RRA fields
  String? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm;
  // premium rate
  String? isrcRt;
  // insurance amount
  String? isrcAmt;
  // taxation type code.
  String? taxTyCd;
  // bar code
  String? bcd;
  // Item code
  String? itemClsCd;
  // Item type code
  String? itemTyCd;
  // Item standard name
  String? itemStdNm;
  // Item origin
  String? orgnNatCd;
  // packaging unit code
  String? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
  double? qty;
  // unit price
  double? prc;
  // supply amount
  double? splyAmt;
  int? tin;
  String? bhfId;
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;

  /// property for stock but presented here for easy
  double? rsdQty;
  @Index()
  String? lastTouched;
  @Index()
  late double supplyPrice;
  @Index()
  late double retailPrice;
  @Index()
  String? remoteID;
  int? localId;
  String action;

  Variant(
      {required this.name,
      required this.sku,
      required this.productId,
      required this.unit,
      required this.productName,
      required this.branchId,
      required this.supplyPrice,
      required this.retailPrice,
      required this.isTaxExempted,
      required this.action,
      this.id,
      this.taxName,
      this.taxPercentage,
      this.itemSeq,
      this.isrccCd,
      this.isrccNm,
      this.isrcRt,
      this.isrcAmt,
      this.taxTyCd,
      this.bcd,
      this.itemClsCd,
      this.itemTyCd,
      this.itemStdNm,
      this.orgnNatCd,
      this.pkg,
      this.itemCd,
      this.pkgUnitCd,
      this.qtyUnitCd,
      this.itemNm,
      this.qty,
      this.prc,
      this.splyAmt,
      this.tin,
      this.bhfId,
      this.dftPrc,
      this.addInfo,
      this.isrcAplcbYn,
      this.useYn,
      this.regrId,
      this.regrNm,
      this.modrId,
      this.modrNm,
      this.rsdQty,
      this.lastTouched,
      this.remoteID,
      this.localId});

  // toJson helper
  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'sku': sku,
        'productId': productId,
        'unit': unit,
        'productName': productName,
        'branchId': branchId,
        'taxName': taxName,
        'taxPercentage': taxPercentage,
        'supplyPrice': supplyPrice,
        'retailPrice': retailPrice,
        'itemSeq': itemSeq,
        'isrccCd': isrccCd,
        'isrccNm': isrccNm,
        'isrcRt': isrcRt,
        'isrcAmt': isrcAmt,
        'taxTyCd': taxTyCd,
        'bcd': bcd,
        'itemClsCd': itemClsCd,
        'itemTyCd': itemTyCd,
        'itemStdNm': itemStdNm,
        'orgnNatCd': orgnNatCd,
        'pkg': pkg,
        'itemCd': itemCd,
        'pkgUnitCd': pkgUnitCd,
        'qtyUnitCd': qtyUnitCd,
        'itemNm': itemNm,
        'qty': qty,
        'prc': prc,
        'splyAmt': splyAmt,
        'tin': tin,
        'bhfId': bhfId,
        'dftPrc': dftPrc,
        'addInfo': addInfo,
        'isrcAplcbYn': isrcAplcbYn,
        'useYn': useYn,
        'regrId': regrId,
        'regrNm': regrNm,
        'modrId': modrId,
        'modrNm': modrNm,
        "rsdQty": rsdQty,
        "localId": id,
        "action": action,
        "remoteID": remoteID,
      };
  factory Variant.fromRecord(RecordModel record) =>
      Variant.fromJson(record.toJson());
  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
        name: json['name'],
        sku: json['sku'],
        localId: json['localId'],
        productId: json['productId'],
        unit: json['unit'],
        productName: json['productName'],
        branchId: json['branchId'],
        taxName: json['taxName'],
        taxPercentage: json['taxPercentage']?.toDouble() ?? 0.0,
        supplyPrice: json['supplyPrice']?.toDouble() ?? 0.0,
        retailPrice: json['retailPrice']?.toDouble() ?? 0.0,
        isTaxExempted: json['isTaxExempted'],
        itemSeq: json['itemSeq'],
        isrccCd: json['isrccCd'],
        isrccNm: json['isrccNm'],
        isrcRt: json['isrcRt'],
        isrcAmt: json['isrcAmt'],
        taxTyCd: json['taxTyCd'],
        bcd: json['bcd'],
        itemClsCd: json['itemClsCd'],
        itemTyCd: json['itemTyCd'],
        itemStdNm: json['itemStdNm'],
        orgnNatCd: json['orgnNatCd'],
        pkg: json['pkg'],
        itemCd: json['itemCd'],
        pkgUnitCd: json['pkgUnitCd'],
        qtyUnitCd: json['qtyUnitCd'],
        itemNm: json['itemNm'],
        qty: json['qty']?.toDouble() ?? 0.0,
        prc: json['prc']?.toDouble() ?? 0.0,
        splyAmt: json['splyAmt']?.toDouble() ?? 0.0,
        tin: json['tin'],
        bhfId: json['bhfId'],
        dftPrc: json['dftPrc']?.toDouble() ?? 0.0,
        addInfo: json['addInfo'],
        isrcAplcbYn: json['isrcAplcbYn'],
        useYn: json['useYn'],
        regrId: json['regrId'],
        regrNm: json['regrNm'],
        modrId: json['modrId'],
        modrNm: json['modrNm'],
        rsdQty: json['rsdQty']?.toDouble() ?? 0.0,
        lastTouched: json['lastTouched'],
        id: json['localId'],
        remoteID: json['id'],
        action: "sync");
  }
}
