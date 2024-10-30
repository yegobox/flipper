import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'stock.dart';

part 'variant.g.dart';

@JsonSerializable()
@Collection<Variant>('variants')
class Variant {
  final int? id;
  final DateTime? deletedAt;
  final String? name;
  final String? color;
  final String? sku;
  final int? productId;
  final String? unit;
  final String? productName;
  final int? branchId;
  @JsonKey(defaultValue: "")
  final String? taxName;
  @JsonKey(defaultValue: 0.0)
  final double taxPercentage;

  // RRA fields
  final int? itemSeq;
  @JsonKey(defaultValue: "")
  final String? isrccCd; // insurance code
  @JsonKey(defaultValue: "")
  final String? isrccNm; // insurance name
  @JsonKey(defaultValue: 0)
  final int? isrcRt; // premium rate
  @JsonKey(defaultValue: 0)
  final int? isrcAmt; // insurance amount
  @JsonKey(defaultValue: "B")
  final String? taxTyCd; // taxation type code
  @JsonKey(defaultValue: "")
  final String? bcd; // bar code
  final String? itemClsCd; // Item code
  final String? itemTyCd; // Item type code
  @JsonKey(defaultValue: "")
  final String? itemStdNm; // Item standard name
  @JsonKey(defaultValue: "")
  final String? orgnNatCd; // Item origin
  @JsonKey(defaultValue: "1")
  final String? pkg; // packaging unit code
  @JsonKey(defaultValue: "")
  final String? itemCd; // item code
  @JsonKey(defaultValue: "CT")
  final String? pkgUnitCd;
  @JsonKey(defaultValue: "BX")
  final String? qtyUnitCd;
  final String? itemNm; // same as name but for rra happiness
  @JsonKey(defaultValue: 0.0)
  final double qty;
  @JsonKey(defaultValue: 0.0)
  final double prc; // unit price
  @JsonKey(defaultValue: 0.0)
  final double splyAmt; // supply amount
  final int? tin;
  final String? bhfId;
  @JsonKey(defaultValue: 0.0)
  final double? dftPrc;
  @JsonKey(defaultValue: "")
  final String? addInfo;
  @JsonKey(defaultValue: "")
  final String? isrcAplcbYn;
  @JsonKey(defaultValue: "")
  final String? useYn;
  final String? regrId;
  final String? regrNm;
  final String? modrId;
  final String? modrNm;

  // Stock-related properties
  @JsonKey(defaultValue: 0.0)
  final double rsdQty;

  /// property for stock but presented here for easy
  final DateTime? lastTouched;
  @JsonKey(defaultValue: 0.0)
  final double supplyPrice;
  @JsonKey(defaultValue: 0.0)
  final double retailPrice;

  // Supplier-related fields
  final String? spplrItemClsCd;

  /// fields for supplier-owned items
  final String? spplrItemCd;
  final String? spplrItemNm;

  // EBM sync status
  @JsonKey(defaultValue: false)
  final bool ebmSynced;

  // Deprecated fields
  @Deprecated('use taxTyCd="A" instead')
  @JsonKey(defaultValue: false)
  final bool isTaxExempted;
  @Deprecated('use taxTyCd instead')
  @JsonKey(defaultValue: "B")
  final String taxType;

  // Branch and stock relationships
  @JsonKey(defaultValue: [])
  final List<int> branchIds;
  final Stock? stock;

  const Variant({
    this.id,
    this.deletedAt,
    this.name,
    this.color,
    this.sku,
    this.productId,
    this.unit,
    this.productName,
    this.branchId,
    this.taxName = "",
    this.taxPercentage = 0.0,
    this.itemSeq,
    this.isrccCd = "",
    this.isrccNm = "",
    this.isrcRt = 0,
    this.isrcAmt = 0,
    this.taxTyCd = "B",
    this.bcd = "",
    this.itemClsCd,
    this.itemTyCd,
    this.itemStdNm = "",
    this.orgnNatCd = "",
    this.pkg = "1",
    this.itemCd = "",
    this.pkgUnitCd = "CT",
    this.qtyUnitCd = "BX",
    this.itemNm,
    this.qty = 0.0,
    this.prc = 0.0,
    this.splyAmt = 0.0,
    this.tin,
    this.bhfId,
    this.dftPrc = 0.0,
    this.addInfo = "",
    this.isrcAplcbYn = "",
    this.useYn = "",
    this.regrId,
    this.regrNm,
    this.modrId,
    this.modrNm,
    this.rsdQty = 0.0,
    this.lastTouched,
    this.supplyPrice = 0.0,
    this.retailPrice = 0.0,
    this.spplrItemClsCd,
    this.spplrItemCd,
    this.spplrItemNm,
    this.ebmSynced = false,
    @Deprecated('use taxTyCd="A" instead') this.isTaxExempted = false,
    @Deprecated('use taxTyCd instead') this.taxType = "B",
    this.branchIds = const [],
    this.stock,
  });

  // Factory constructor to create a Variant from JSON
  factory Variant.fromJson(Map<String, dynamic> json) =>
      _$VariantFromJson(json);

  // Method to convert Variant to JSON
  Map<String, dynamic> toJson() => _$VariantToJson(this);

  // Implement copyWith method for immutability
  Variant copyWith({
    int? id,
    DateTime? deletedAt,
    String? name,
    String? color,
    String? sku,
    int? productId,
    String? unit,
    String? productName,
    int? branchId,
    String? taxName,
    double? taxPercentage,
    int? itemSeq,
    String? isrccCd,
    String? isrccNm,
    int? isrcRt,
    int? isrcAmt,
    String? taxTyCd,
    String? bcd,
    String? itemClsCd,
    String? itemTyCd,
    String? itemStdNm,
    String? orgnNatCd,
    String? pkg,
    String? itemCd,
    String? pkgUnitCd,
    String? qtyUnitCd,
    String? itemNm,
    double? qty,
    double? prc,
    double? splyAmt,
    int? tin,
    String? bhfId,
    double? dftPrc,
    String? addInfo,
    String? isrcAplcbYn,
    String? useYn,
    String? regrId,
    String? regrNm,
    String? modrId,
    String? modrNm,
    double? rsdQty,
    DateTime? lastTouched,
    double? supplyPrice,
    double? retailPrice,
    String? spplrItemClsCd,
    String? spplrItemCd,
    String? spplrItemNm,
    bool? ebmSynced,
    bool? isTaxExempted,
    String? taxType,
    List<int>? branchIds,
    Stock? stock,
  }) {
    return Variant(
      id: id ?? this.id,
      deletedAt: deletedAt ?? this.deletedAt,
      name: name ?? this.name,
      color: color ?? this.color,
      sku: sku ?? this.sku,
      productId: productId ?? this.productId,
      unit: unit ?? this.unit,
      productName: productName ?? this.productName,
      branchId: branchId ?? this.branchId,
      taxName: taxName ?? this.taxName,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      itemSeq: itemSeq ?? this.itemSeq,
      isrccCd: isrccCd ?? this.isrccCd,
      isrccNm: isrccNm ?? this.isrccNm,
      isrcRt: isrcRt ?? this.isrcRt,
      isrcAmt: isrcAmt ?? this.isrcAmt,
      taxTyCd: taxTyCd ?? this.taxTyCd,
      bcd: bcd ?? this.bcd,
      itemClsCd: itemClsCd ?? this.itemClsCd,
      itemTyCd: itemTyCd ?? this.itemTyCd,
      itemStdNm: itemStdNm ?? this.itemStdNm,
      orgnNatCd: orgnNatCd ?? this.orgnNatCd,
      pkg: pkg ?? this.pkg,
      itemCd: itemCd ?? this.itemCd,
      pkgUnitCd: pkgUnitCd ?? this.pkgUnitCd,
      qtyUnitCd: qtyUnitCd ?? this.qtyUnitCd,
      itemNm: itemNm ?? this.itemNm,
      qty: qty ?? this.qty,
      prc: prc ?? this.prc,
      splyAmt: splyAmt ?? this.splyAmt,
      tin: tin ?? this.tin,
      bhfId: bhfId ?? this.bhfId,
      dftPrc: dftPrc ?? this.dftPrc,
      addInfo: addInfo ?? this.addInfo,
      isrcAplcbYn: isrcAplcbYn ?? this.isrcAplcbYn,
      useYn: useYn ?? this.useYn,
      regrId: regrId ?? this.regrId,
      regrNm: regrNm ?? this.regrNm,
      modrId: modrId ?? this.modrId,
      modrNm: modrNm ?? this.modrNm,
      rsdQty: rsdQty ?? this.rsdQty,
      lastTouched: lastTouched ?? this.lastTouched,
      supplyPrice: supplyPrice ?? this.supplyPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      spplrItemClsCd: spplrItemClsCd ?? this.spplrItemClsCd,
      spplrItemCd: spplrItemCd ?? this.spplrItemCd,
      spplrItemNm: spplrItemNm ?? this.spplrItemNm,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      isTaxExempted: isTaxExempted ?? this.isTaxExempted,
      taxType: taxType ?? this.taxType,
      branchIds: branchIds ?? this.branchIds,
      stock: stock ?? this.stock,
    );
  }
}

final variantsRef = VariantCollectionReference();
