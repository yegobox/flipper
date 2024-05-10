library flipper_models;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ITransactionItem.g.dart';

@JsonSerializable()
class ITransactionItem {
  ITransactionItem({
    this.id,
    this.name,
    this.transactionId,
    this.variantId,
    this.qty = 0.0,
    this.price = 0.0,
    this.discount = 0.0,
    this.type,
    this.remainingStock = 0.0,
    this.createdAt,
    this.updatedAt,
    this.isTaxExempted = false,
    this.isRefunded = false,
    this.doneWithTransaction,
    this.active,
    // RRA fields
    this.dcRt = 0.0,
    this.dcAmt = 0.0,
    this.taxblAmt = 0.0,
    this.taxAmt = 0.0,
    this.totAmt = 0.0,
    // properties from variants
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
    this.prc = 0.0,
    this.splyAmt = 0.0,
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
    this.lastTouched,
    this.deletedAt,
    this.action,
    this.branchId,
  });

  int? id;

  String? name;

  int? transactionId;
  int? variantId;
  // quantity
  double qty = 0.0;
  double price = 0.0;
  double discount = 0.0;
  String? type;
  double remainingStock = 0.0;
  String? createdAt;
  String? updatedAt;
  bool isTaxExempted = false;
  bool isRefunded = false;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  // discount rate
  double dcRt = 0.0;
  // discount amount
  double dcAmt = 0.0;

  double taxblAmt = 0.0;
  double taxAmt = 0.0;

  double totAmt = 0.0;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
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
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  double prc = 0.0;
  // supply amount
  double splyAmt = 0.0;
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

  DateTime? lastTouched;
  DateTime? deletedAt;
  String? action;

  int? branchId;

  factory ITransactionItem.fromJson(Map<String, dynamic> json) =>
      _$ITransactionItemFromJson(json);
  Map<String, dynamic> toJson() => _$ITransactionItemToJson(this);
}
