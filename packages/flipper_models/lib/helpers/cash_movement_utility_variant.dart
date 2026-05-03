import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/cash_movement_item_code.dart';

/// Builds the per-save utility [Variant] used for cash book lines (matches
/// [cashbook.dart] / keypad cash flows).
Variant cloneUtilityVariantForCashLine({
  required Variant utilityVariant,
  required double cashReceived,
  required String transactionType,
}) {
  final itemCode =
      buildCashMovementItemCode(transactionType, DateTime.now());

  return Variant(
    id: utilityVariant.id,
    name: utilityVariant.name,
    color: utilityVariant.color,
    sku: utilityVariant.sku,
    productId: utilityVariant.productId,
    unit: utilityVariant.unit,
    productName: utilityVariant.productName,
    branchId: utilityVariant.branchId,
    taxName: utilityVariant.taxName,
    taxPercentage: utilityVariant.taxPercentage,
    retailPrice: cashReceived,
    supplyPrice: utilityVariant.supplyPrice,
    lastTouched: utilityVariant.lastTouched,
    itemSeq: utilityVariant.itemSeq,
    isrccCd: utilityVariant.isrccCd,
    isrccNm: utilityVariant.isrccNm,
    isrcRt: utilityVariant.isrcRt,
    isrcAmt: utilityVariant.isrcAmt,
    taxTyCd: utilityVariant.taxTyCd,
    bcd: utilityVariant.bcd,
    itemClsCd: utilityVariant.itemClsCd,
    itemTyCd: utilityVariant.itemTyCd,
    itemStdNm: utilityVariant.itemStdNm,
    orgnNatCd: utilityVariant.orgnNatCd,
    pkg: utilityVariant.pkg,
    itemCd: itemCode,
    pkgUnitCd: utilityVariant.pkgUnitCd,
    qtyUnitCd: utilityVariant.qtyUnitCd,
    itemNm: utilityVariant.itemNm,
    qty: utilityVariant.qty,
    prc: utilityVariant.prc,
    splyAmt: utilityVariant.splyAmt,
    tin: utilityVariant.tin,
    bhfId: utilityVariant.bhfId,
    dftPrc: utilityVariant.dftPrc,
    addInfo: utilityVariant.addInfo,
    isrcAplcbYn: utilityVariant.isrcAplcbYn,
    useYn: utilityVariant.useYn,
    regrId: utilityVariant.regrId,
    regrNm: utilityVariant.regrNm,
    modrId: utilityVariant.modrId,
    modrNm: utilityVariant.modrNm,
    rsdQty: utilityVariant.rsdQty,
    dcRt: utilityVariant.dcRt,
    dcAmt: utilityVariant.dcAmt,
    stock: utilityVariant.stock,
    ebmSynced: utilityVariant.ebmSynced,
    taxAmt: utilityVariant.taxAmt,
  );
}

/// Synthetic line used by [collectPayment] to avoid a second line-item fetch.
List<TransactionItem> syntheticPreloadedCashLine({
  required Variant linedVariant,
  required String transactionId,
  required String branchId,
  required double cashReceived,
}) {
  return [
    TransactionItem(
      name: linedVariant.name,
      qty: 1,
      price: cashReceived,
      discount: 0,
      prc: cashReceived,
      totAmt: cashReceived,
      transactionId: transactionId,
      variantId: linedVariant.id,
      branchId: branchId,
      dcAmt: 0,
      ttCatCd: linedVariant.taxTyCd ?? 'B',
    ),
  ];
}
