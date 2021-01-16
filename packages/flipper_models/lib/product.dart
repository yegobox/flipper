library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'product.g.dart';

//Note: it is highligy recommended to know that even if we mark the field as nullable
//they are required when mass assigning, it is only marked as required
//because the use of this model with other model that does not have or do not have to
//comply with this model. a concrete reference of this model and other model can be found
//in technical document of database design.
abstract class Product implements Built<Product, ProductBuilder> {
  String get name;

  String get id;

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
  bool get touched;

  String get table;

  @nullable
  bool get isDraft;
  @nullable
  String get color;
  @nullable
  bool get isCurrentUpdate;
  @nullable
  String get businessId;

  @nullable
  String get supplierId;
  @nullable
  String get categoryId;

  @nullable
  String get createdAt;

  @nullable
  String get unit;

  @nullable
  String get updatedAt;

  @nullable
  int get count;

  BuiltList<String> get channels;

  // ignore: sort_constructors_first
  Product._();
  // ignore: sort_unnamed_constructors_first
  // ignore: sort_constructors_first
  factory Product([updates(ProductBuilder b)]) = _$Product;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Product.serializer, this);
  }

  Product fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Product fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Product.serializer, jsonMap);
  }

  static Serializer<Product> get serializer => _$productSerializer;
}
