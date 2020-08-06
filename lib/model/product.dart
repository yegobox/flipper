import 'package:built_value/built_value.dart';

part 'product.g.dart';

//Note: it is highligy recommended to know that even if we mark the field as nullable
//they are required when mass assigning, it is only marked as required
//because the use of this model with other model that does not have or do not have to
//comply with this model. a concrete reference of this model and other model can be found
//in technical document of database design.
abstract class Product implements Built<Product, ProductBuilder> {
  String get name;
  String get productId;
  @nullable
  String get description;
  @nullable
  String get picture;
  @nullable
  String get taxId;
  @nullable
  bool get active;
  @nullable
  bool get hasPicture;

  @nullable
  bool get isImageLocal;

  @nullable
  bool get isDraft;
  @nullable
  String get color;
  @nullable
  bool get isCurrentUpdate;
  @nullable
  String get businessId;

  //nullable are not and should not be in mater data model
  //they are here for local usage as helper.
  @nullable
  String get supplierId;
  @nullable
  String get categoryId;

  //columns that is not needed when presenting model.
  @nullable
  String get createdAt;

  @nullable
  String get unit;

  @nullable
  String get updatedAt;

  @nullable
  int get count;
  Product._();
  factory Product([void Function(ProductBuilder) updates]) = _$Product;
}
