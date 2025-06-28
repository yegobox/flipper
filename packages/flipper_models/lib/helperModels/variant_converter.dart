import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_models/brick/models/variant.model.dart' as models;

/// A custom JSON converter for the Variant class
class VariantConverter
    implements JsonConverter<models.Variant, Map<String, dynamic>> {
  const VariantConverter();

  @override
  models.Variant fromJson(Map<String, dynamic> json) {
    final variant = models.Variant(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
    );

    // Set optional fields
    variant.purchaseId = json['purchaseId'] as String?;
    variant.stockId = json['stockId'] as String?;
    variant.taxPercentage = json['taxPercentage'] as num?;
    variant.color = json['color'] as String?;
    variant.sku = json['sku'] as String?;
    variant.productId = json['productId'] as String?;
    variant.unit = json['unit'] as String?;
    variant.productName = json['productName'] as String?;
    variant.categoryId = json['categoryId'] as String?;
    variant.categoryName = json['categoryName'] as String?;
    variant.branchId = json['branchId'] as int?;
    variant.taxName = json['taxName'] as String?;

    // Set RRA fields
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

    return variant;
  }

  @override
  Map<String, dynamic> toJson(models.Variant variant) {
    return variant.toFlipperJson();
  }
}
