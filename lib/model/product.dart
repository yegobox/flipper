import 'package:built_value/built_value.dart';

part 'product.g.dart';

abstract class Product implements Built<Product, ProductBuilder> {
  String get name;
  String get id;
  String get description;
  String get picture;
  String get taxId;
  bool get active;
  bool get hasPicture;
  bool get isDraft;
  String get color;
  bool get isCurrentUpdate;
  String get businessId;
  String get supplierId;
  String get categoryId;

  //columns that is not needed when presenting model.
  @nullable
  String get createdAt;

  @nullable
  String get updatedAt;

  @nullable
  int get count;
  Product._();
  factory Product([void Function(ProductBuilder) updates]) = _$Product;
}
