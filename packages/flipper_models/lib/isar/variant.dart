library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'variant.g.dart';

@JsonSerializable()
@Collection()
class Variant extends IJsonSerializable {
  late String id;
  @Index()
  late String name;
    late String color;
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

  // only for accor when fetching from remove

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
    required this.color,
    required this.id,
    this.taxName = 'N/A',
    this.taxPercentage = 0,
    this.itemSeq,
    this.isrccCd,
    this.isrccNm,
    this.isrcRt,
    this.isrcAmt,
    this.taxTyCd,
    this.bcd,
    this.itemClsCd = 'itemClsCd',
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

  factory Variant.fromJson(Map<String, dynamic> json) {
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$VariantFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$VariantToJson(this);
}
