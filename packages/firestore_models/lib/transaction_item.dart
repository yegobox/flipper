import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_item.freezed.dart';
part 'transaction_item.g.dart';

@freezed
class TransactionItem with _$TransactionItem {
  const factory TransactionItem({
    int? id,
    String? name,
    int? quantityRequested,
    int? quantityApproved,
    int? quantityShipped,
    int? transactionId,
    int? variantId,
    @Default(0.0) double qty,
    @Default(0.0) double price,
    @Default(0.0) double discount,
    String? type,
    @Default(0.0) double remainingStock,
    String? createdAt,
    String? updatedAt,
    @Default(false) bool isTaxExempted,
    @Default(false) bool isRefunded,
    bool? doneWithTransaction,
    bool? active,
    // RRA fields
    @Default(0.0) double dcRt,
    @Default(0.0) double dcAmt,
    @Default(0.0) double taxblAmt,
    @Default(0.0) double taxAmt,
    @Default(0.0) double totAmt,
    // Variant properties
    int? itemSeq,
    String? isrccCd,
    @Default("") String? isrccNm,
    @Default(0) int? isrcRt,
    @Default(0) int? isrcAmt,
    String? taxTyCd,
    String? bcd,
    String? itemClsCd,
    String? itemTyCd,
    String? itemStdNm,
    String? orgnNatCd,
    String? pkg,
    String? itemCd,
    @Default("CT") String? pkgUnitCd,
    @Default("BX") String? qtyUnitCd,
    String? itemNm,
    @Default(0.0) double prc,
    @Default(0.0) double splyAmt,
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
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? branchId,
    @Default(false) bool ebmSynced,
    @Default(false) bool partOfComposite,
    @Default(0.0) double compositePrice,
  }) = _TransactionItem;

  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);
}
