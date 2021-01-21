library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'tax.g.dart';

//Note: it is highligy recommended to know that even if we mark the field as nullable
//they are required when mass assigning, it is only marked as required
//because the use of this model with other model that does not have or do not have to
//comply with this model. a concrete reference of this model and other model can be found
//in technical document of database design.
abstract class Tax implements Built<Tax, TaxBuilder> {
  String get name;
  String get id;
  @nullable
  bool get touched;
  String get table;

  bool get isDefault;

  double get percentage;
  String get businessId;

  BuiltList<String> get channels;

  // ignore: sort_constructors_first
  Tax._();
  // ignore: sort_constructors_first
  factory Tax([void Function(TaxBuilder) updates]) = _$Tax;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Tax.serializer, this);
  }

  Tax fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static Tax fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Tax.serializer, jsonMap);
  }

  static Serializer<Tax> get serializer => _$taxSerializer;
}
