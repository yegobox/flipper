import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'composite.dart';

part 'product.g.dart';

@JsonSerializable()
@Collection<Product>('products')
class Product {
  final int? id;
  final String? name;
  final String? description;
  final String? taxId;
  @JsonKey(defaultValue: "#e74c3c")
  final String color;
  final int? businessId;
  final int? branchId;
  final String? supplierId;
  final int? categoryId;
  final String? createdAt;
  final String? unit;
  final String? imageUrl;
  final String? expiryDate;
  final String? barCode;
  @JsonKey(defaultValue: false)
  final bool nfcEnabled;
  final int? bindedToTenantId;
  @JsonKey(defaultValue: false)
  final bool isFavorite;
  final DateTime? lastTouched;
  final DateTime? deletedAt;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool searchMatch;
  final String? spplrNm;
  @JsonKey(defaultValue: false)
  final bool? isComposite;
  @JsonKey(defaultValue: <Composite>[])
  final List<Composite> composites;

  const Product({
    this.id,
    this.name,
    this.description,
    this.taxId,
    this.color = "#e74c3c",
    this.businessId,
    this.branchId,
    this.supplierId,
    this.categoryId,
    this.createdAt,
    this.unit,
    this.imageUrl,
    this.expiryDate,
    this.barCode,
    this.nfcEnabled = false,
    this.bindedToTenantId,
    this.isFavorite = false,
    this.lastTouched,
    this.deletedAt,
    this.searchMatch = false,
    this.spplrNm,
    this.isComposite = false,
    this.composites = const <Composite>[],
  });

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  // Method to convert Product to JSON
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  // Implement copyWith method for immutability
  Product copyWith({
    int? id,
    String? name,
    String? description,
    String? taxId,
    String? color,
    int? businessId,
    int? branchId,
    String? supplierId,
    int? categoryId,
    String? createdAt,
    String? unit,
    String? imageUrl,
    String? expiryDate,
    String? barCode,
    bool? nfcEnabled,
    int? bindedToTenantId,
    bool? isFavorite,
    DateTime? lastTouched,
    DateTime? deletedAt,
    bool? searchMatch,
    String? spplrNm,
    bool? isComposite,
    List<Composite>? composites,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      taxId: taxId ?? this.taxId,
      color: color ?? this.color,
      businessId: businessId ?? this.businessId,
      branchId: branchId ?? this.branchId,
      supplierId: supplierId ?? this.supplierId,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      expiryDate: expiryDate ?? this.expiryDate,
      barCode: barCode ?? this.barCode,
      nfcEnabled: nfcEnabled ?? this.nfcEnabled,
      bindedToTenantId: bindedToTenantId ?? this.bindedToTenantId,
      isFavorite: isFavorite ?? this.isFavorite,
      lastTouched: lastTouched ?? this.lastTouched,
      deletedAt: deletedAt ?? this.deletedAt,
      searchMatch: searchMatch ?? this.searchMatch,
      spplrNm: spplrNm ?? this.spplrNm,
      isComposite: isComposite ?? this.isComposite,
      composites: composites ?? this.composites,
    );
  }
}

final productsRef = ProductCollectionReference();
