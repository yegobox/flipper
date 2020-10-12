import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'variation.g.dart';

abstract class Variation implements Built<Variation, VariationBuilder> {
  String get id;
  @nullable

  String get sku;

  String get productId;

  String get name;
  @nullable

  String get unit;

  Variation._();

  factory Variation([void Function(VariationBuilder) updates]) = _$Variation;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Variation.serializer, this);
  }

  Variation fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Variation fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Variation.serializer, jsonMap);
  }

  static Serializer<Variation> get serializer => _$variationSerializer;
}
