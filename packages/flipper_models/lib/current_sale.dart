library flipper_models;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'current_sale.g.dart';

abstract class CurrentSale implements Built<CurrentSale, CurrentSaleBuilder> {
  CurrentSale._();
  String get id;
  String get variantName;
  double get quantity;

  factory CurrentSale([void Function(CurrentSaleBuilder) updates]) =
      _$CurrentSale;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(CurrentSale.serializer, this);
  }

  CurrentSale fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static CurrentSale fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(CurrentSale.serializer, jsonMap);
  }

  static Serializer<CurrentSale> get serializer => _$currentSaleSerializer;
}
