import 'package:supabase_models/brick/models/transactionItem.model.dart'
    show TransactionItem;
import 'package:supabase_models/brick/models/variant.model.dart';

class TransactionItemUtil {
  static TransactionItem fromVariant(Variant variantToSave,
      {int itemSeq = 1, double? approvedQty}) {
    return TransactionItem(
      pkgUnitCd: variantToSave.pkgUnitCd,
      itemSeq: itemSeq,
      itemCd: variantToSave.itemCd!,
      itemClsCd: variantToSave.itemClsCd!,
      itemNm: variantToSave.itemNm!,
      qty: approvedQty ?? variantToSave.stock?.currentStock ?? 0,
      prc: variantToSave.retailPrice ?? 0,
      dcRt: variantToSave.dcRt ?? 0,
      taxTyCd: variantToSave.taxTyCd ?? "A",
      name: variantToSave.name,
      price: variantToSave.retailPrice ?? 0,
      discount: _calculateDiscount(variantToSave),
      ttCatCd: variantToSave.ttCatCd,

      // Additional fields from variant data
      itemTyCd: variantToSave.itemTyCd,
      orgnNatCd: variantToSave.orgnNatCd,
      qtyUnitCd: variantToSave.qtyUnitCd,
      dftPrc: variantToSave.retailPrice ?? 0,
      taxPercentage: variantToSave.taxPercentage,
      productId: variantToSave.productId,
      variantId: variantToSave.id,
      retailPrice: variantToSave.retailPrice ?? 0,
      supplyPrice: variantToSave.supplyPrice,
      categoryId: variantToSave.categoryId,
      categoryName: variantToSave.categoryName,
      sku: variantToSave.sku,
      unit: variantToSave.unit,
      productName: variantToSave.productName,
      color: variantToSave.color,

      // Default values
      active: true,
      doneWithTransaction: false,
      isRefunded: false,
      ebmSynced: false,
      partOfComposite: false,
      useYn: 'Y',
      ignoreForReport: false,

      // Optional fields
      purchaseId: null,
      stock: variantToSave.stock,
      spplrItemNm: null,
      totWt: null,
      netWt: null,
      spplrNm: null,
      agntNm: null,
      invcFcurAmt: null,
      invcFcurCd: null,
      invcFcurExcrt: null,
      exptNatCd: null,
      dclNo: null,
      taskCd: null,
      dclDe: null,
      hsCd: null,
      imptItemSttsCd: null,
      isShared: null,
      assigned: null,
      splyAmt: null,
      bcd: null,
      itemStdNm: null,
      pkg: null,
      tin: null,
      bhfId: null,
      addInfo: null,
      isrcAplcbYn: null,
      regrId: null,
      regrNm: null,
      modrId: null,
      modrNm: null,
      branchId: null,
      compositePrice: null,
      quantityRequested: null,
      quantityApproved: null,
      quantityShipped: null,
      transactionId: null,
      remainingStock: variantToSave.stock?.currentStock,
      dcAmt: null,
      taxblAmt: null,
      taxAmt: null,
      totAmt: null,
      isrccCd: null,
      isrccNm: null,
      isrcRt: null,
      isrcAmt: null,
      inventoryRequestId: null,
      spplrItemClsCd: null,
      spplrItemCd: null,
      supplyPriceAtSale: variantToSave.supplyPrice,
    );
  }

  static double _calculateDiscount(Variant variant) {
    if (variant.dcRt != null && variant.retailPrice != null) {
      return (variant.dcRt! / 100) * variant.retailPrice!;
    }
    return 0;
  }

  // Utility method to create multiple TransactionItems from variants
  static List<TransactionItem> fromVariants(List<Variant> variants) {
    return variants.asMap().entries.map((entry) {
      final index = entry.key;
      final variant = entry.value;
      return fromVariant(variant, itemSeq: index + 1);
    }).toList();
  }

  // Utility method to update existing TransactionItem with variant data
  static TransactionItem updateFromVariant(
      TransactionItem existingItem, Variant variant) {
    return existingItem.copyWith(
      pkgUnitCd: variant.pkgUnitCd,
      itemCd: variant.itemCd,
      itemClsCd: variant.itemClsCd,
      itemNm: variant.itemNm,
      qty: variant.stock?.currentStock ?? 0,
      prc: variant.retailPrice ?? 0,
      dcRt: variant.dcRt ?? 0,
      taxTyCd: variant.taxTyCd ?? "A",
      name: variant.name,
      price: variant.retailPrice ?? 0,
      discount: _calculateDiscount(variant),
      ttCatCd: variant.ttCatCd,
      itemTyCd: variant.itemTyCd,
      orgnNatCd: variant.orgnNatCd,
      qtyUnitCd: variant.qtyUnitCd,
      dftPrc: variant.retailPrice ?? 0,
      taxPercentage: variant.taxPercentage,
      productId: variant.productId,
      variantId: variant.id,
      retailPrice: variant.retailPrice ?? 0,
      supplyPrice: variant.supplyPrice,
      categoryId: variant.categoryId,
      categoryName: variant.categoryName,
      sku: variant.sku,
      unit: variant.unit,
      productName: variant.productName,
      color: variant.color,
      stock: variant.stock,
      remainingStock: variant.stock?.currentStock,
      supplyPriceAtSale: variant.supplyPrice,
    );
  }
}
