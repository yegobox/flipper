import 'package:freezed_annotation/freezed_annotation.dart';
import 'composite.dart';
part 'product.freezed.dart';
part 'product.g.dart'; 

@freezed
class Product with _$Product {
  factory Product({
    int? id,
    String? name,
    String? description,
    String? taxId,
    @Default("#e74c3c") String color,
    int? businessId,

    int? branchId,
    String? supplierId,
    int? categoryId,
    String? createdAt,
    String? unit,
    String? imageUrl,
    String? expiryDate,

    String? barCode,
    @Default(false) bool nfcEnabled,

    int? bindedToTenantId,
    @Default(false) bool isFavorite,

    DateTime? lastTouched,
    DateTime? deletedAt,

    @Default(false) @JsonKey(includeToJson: false) bool searchMatch, // Ignored field
    String? spplrNm,
    @Default(false) bool? isComposite,

    @Default(<Composite>[]) List<Composite> composites,
  }) = _Product;

  // Optional: factory constructor for creating the object from JSON
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}


