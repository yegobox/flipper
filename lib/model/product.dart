import 'package:built_value/built_value.dart';

part 'product.g.dart';

abstract class Product implements Built<Product, ProductBuilder> {
  String get name;
  String get id;
  @nullable //todo: remove nullable a product should have atleast default description, should be added when creating a product.
  String get description;
  String get picture;
  String get taxId;
  bool get active;
  bool get hasPicture;
  bool get isDraft;
  String get color;
  bool get isCurrentUpdate;
  String get businessId;

  //nullable are not and should not be in mater data model
  //they are here for local usage as helper.

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
