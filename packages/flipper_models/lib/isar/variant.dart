library flipper_models;

import 'package:flipper_models/isar/random.dart';

import 'DateTimeConverter.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'variant.g.dart';

@JsonSerializable()
@Collection()
class Variant extends IJsonSerializable {
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? deletedAt;
  late String id;
  @Index()
  late String name;
  @JsonKey(fromJson: _colorFromJson)
  String color;
  late String sku;
  @Index()
  late String productId;
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
  // packacking unit these are mainly AM
  ///Certainly! Here are the codes along with their explanations:

// AM: Ampoule Ampoule
// BA: Barrel Barrel
// BC: Bottlecrate Bottlecrate
// BE: Bundle Bundle
// BF: Balloon, non-protected Balloon, non-protected
// BG: Bag Bag
// BJ: Bucket Bucket
// BK: Basket Basket
// BL: Bale Bale
// BQ: Bottle, protected cylindrical Bottle, protected cylindrical
// BR: Bar Bar
// BV: Bottle, bulbous Bottle, bulbous
// BZ: Bag Bag
// CA: Can Can
// CH: Chest Chest
// CJ: Coffin Coffin
// CL: Coil Coil
// CR: Wooden Box, Wooden Case Wooden Box, Wooden Case

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

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  late double supplyPrice;

  late double retailPrice;

  String action;

  /// these fields are empty in normal business when this item is owned by a business
  /// but in case when this item is owned by a supplier then these fields will be filled
  /// this is the case after purchase action is done
  String? spplrItemClsCd;
  String? spplrItemCd;
  String? spplrItemNm;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool ebmSynced;

  // only for accor when fetching from remove
  static DateTime? _dateTimeFromJson(String? json) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.fromJson(json);
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.toJson(dateTime);
  }

  static String _colorFromJson(dynamic json) {
    // Return a default color if the deserialized value is an empty string
    return (json ?? "").isEmpty ? "#FF0000" : json;
  }

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
    required this.color,
    required this.id,
    this.ebmSynced = false,
    this.spplrItemClsCd,
    this.spplrItemCd,
    this.spplrItemNm,
    this.taxName,
    this.taxPercentage = 0,
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
    this.prc = 0.0,
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
    required this.lastTouched,
    this.deletedAt,
  });

  factory Variant.fromRecord(RecordModel record) =>
      Variant.fromJson(record.toJson());

  factory Variant.fromJson(Map<String, dynamic> json) =>
      _$VariantFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VariantToJson(this);
}
