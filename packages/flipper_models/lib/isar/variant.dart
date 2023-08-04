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
  Id? id;
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
  String action;

  // only for accor when fetching from remove
  int? localId;
  @Index()
  DateTime? deletedAt;
  Variant({
    required this.name,
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
    this.deletedAt,
  });

  factory Variant.fromRecord(RecordModel record) =>
      Variant.fromJson(record.toJson());

  factory Variant.fromJson(Map<String, dynamic> json) {
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];
    json['remoteID'] = json['id'] is int ? json['id'].toString() : json['id'];
    json.remove('id');
    return _$VariantFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$VariantToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
