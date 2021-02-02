library flipper_models;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'variant_stock.g.dart';

abstract class VariantStock
    implements Built<VariantStock, VariantStockBuilder> {
  String get name;
  @nullable
  String get productName;
  String get id;
  @nullable
  double get lowStock;
  @nullable
  double get currentStock;
  @nullable
  double get supplyPrice;
  @nullable
  double get retailPrice;

  @nullable
  String get sku;

  @nullable
  String get productId;

  @nullable
  String get unit;

  VariantStock._();

  // ignore: sort_unnamed_constructors_first
  // ignore: sort_constructors_first
  factory VariantStock([void Function(VariantStockBuilder) updates]) =
      _$VariantStock;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(VariantStock.serializer, this);
  }

  VariantStock fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static VariantStock fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(
        VariantStock.serializer, jsonMap);
  }

  static Serializer<VariantStock> get serializer => _$variantStockSerializer;
}
