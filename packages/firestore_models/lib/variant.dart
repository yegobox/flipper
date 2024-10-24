import 'package:freezed_annotation/freezed_annotation.dart';

// Import the Stock class
import 'stock.dart';

part 'variant.freezed.dart';
part 'variant.g.dart';

@freezed
class Variant with _$Variant {
  const factory Variant({
    int? id,
    DateTime? deletedAt,
    String? name,
    String? color,
    String? sku,
    int? productId,
    String? unit,
    String? productName,
    int? branchId,
    @Default("") String? taxName,
    @Default(0.0) double taxPercentage,
    
    // RRA fields with comments preserved
    int? itemSeq,
    @Default("") String? isrccCd,    // insurance code
    @Default("") String? isrccNm,    // insurance name
    @Default(0) int? isrcRt,         // premium rate
    @Default(0) int? isrcAmt,        // insurance amount
    @Default("B") String? taxTyCd,   // taxation type code
    @Default("") String? bcd,        // bar code
    String? itemClsCd,               // Item code
    String? itemTyCd,                // Item type code
    @Default("") String? itemStdNm,  // Item standard name
    @Default("") String? orgnNatCd,  // Item origin
    @Default("1") String? pkg,       // packaging unit code
    @Default("") String? itemCd,     // item code
    @Default("CT") String? pkgUnitCd,
    @Default("BX") String? qtyUnitCd,
    String? itemNm,                  // same as name but for rra happiness
    @Default(0.0) double qty,
    @Default(0.0) double prc,        // unit price
    @Default(0.0) double splyAmt,    // supply amount
    int? tin,
    String? bhfId,
    @Default(0.0) double? dftPrc,
    @Default("") String? addInfo,
    @Default("") String? isrcAplcbYn,
    @Default("") String? useYn,
    String? regrId,
    String? regrNm,
    String? modrId,
    String? modrNm,
    
    // Stock-related properties
    @Default(0.0) double rsdQty,     /// property for stock but presented here for easy
    DateTime? lastTouched,
    @Default(0.0) double supplyPrice,
    @Default(0.0) double retailPrice,
    
    // Supplier-related fields
    String? spplrItemClsCd,          /// fields for supplier-owned items
    String? spplrItemCd,
    String? spplrItemNm,
    
    // EBM sync status
    @Default(false) bool ebmSynced,
    
    // Deprecated fields marked with @deprecated annotation
    @deprecated @Default(false) bool isTaxExempted,  /// use taxTyCd='A' instead
    @deprecated @Default("B") String taxType,        /// use taxTyCd instead
    
    // Branch and stock relationships
    @Default([]) List<int> branchIds,
    Stock? stock,
  }) = _Variant;

  factory Variant.fromJson(Map<String, dynamic> json) => 
      _$VariantFromJson(json);
}

/// Convenience extension for checking tax exemption status
extension VariantTaxHelpers on Variant {
  bool get isExempted => taxTyCd == 'A';
}