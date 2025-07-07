import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_models/brick/models/variant.model.dart' as models;

/// A custom JSON converter for the Variant class
class VariantConverter
    implements JsonConverter<models.Variant, Map<String, dynamic>> {
  const VariantConverter();

  @override
  models.Variant fromJson(Map<String, dynamic> json) {
    final variant = models.Variant(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
    );

    // Set optional fields
    variant.purchaseId = json['purchaseId'] as String?;
    variant.itemNm = json['itemNm'] as String?;
    variant.stockId = json['stockId'] as String?;
    variant.taxPercentage = json['taxPercentage'] as num?;
    variant.color = json['color'] as String?;
    variant.sku = json['sku'] as String?;
    variant.productId = json['productId'] as String?;
    variant.invcFcurAmt = (json['invcFcurAmt'] as num?) ?? 0.0;
    variant.unit = json['unit'] as String?;
    variant.productName = json['productName'] as String?;
    variant.categoryId = json['categoryId'] as String?;
    variant.categoryName = json['categoryName'] as String?;
    variant.branchId = json['branchId'] as int?;
    variant.taxName = json['taxName'] as String?;

    // Set RRA and import fields
    variant.itemSeq = json['itemSeq'] as int?;
    variant.isrccCd = json['isrccCd'] as String?;
    variant.isrccNm = json['isrccNm'] as String?;
    variant.isrcRt = json['isrcRt'] as int?;
    variant.isrcAmt = json['isrcAmt'] as int?;
    variant.taxTyCd = json['taxTyCd'] as String?;
    variant.bcd = json['bcd'] as String?;
    variant.itemClsCd = json['itemClsCd'] as String?;
    variant.itemTyCd = json['itemTyCd'] as String?;
    variant.itemStdNm = json['itemStdNm'] as String?;
    variant.orgnNatCd = json['orgnNatCd'] as String?;
    variant.taskCd = json['taskCd'] as String?;
    variant.dclDe = json['dclDe'] as String?;
    variant.dclNo = json['dclNo'] as String?;
    variant.hsCd = json['hsCd'] as String?;
    variant.imptItemSttsCd =
        json['imptItemsttsCd'] as String? ?? json['imptItemSttsCd'] as String?;
    variant.exptNatCd = json['exptNatCd'] as String?;
    variant.pkg = json['pkg'] as int?;
    variant.pkgUnitCd = json['pkgUnitCd'] as String?;
    variant.qty = (json['qty'] as int?)?.toDouble() ?? 0.0;
    variant.qtyUnitCd = json['qtyUnitCd'] as String?;
    variant.totWt = json['totWt'] as int?;
    variant.netWt = json['netWt'] as int?;
    variant.spplrNm = json['spplrNm'] as String?;
    variant.agntNm = json['agntNm'] as String?;
    variant.invcFcurCd = json['invcFcurCd'] as String?;
    final invcFcurExcrtRaw = json['invcFcurExcrt'];
    variant.invcFcurExcrt =
        invcFcurExcrtRaw != null ? (invcFcurExcrtRaw as num).toDouble() : null;

    return variant;
  }

  @override
  Map<String, dynamic> toJson(models.Variant variant) {
    return variant.toFlipperJson();
  }
}
