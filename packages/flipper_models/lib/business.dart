library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'business.g.dart';

abstract class Business implements Built<Business, BusinessBuilder> {
  @BuiltValueField(wireName: 'id')
  String get id;

  String get name;

  bool get active;

  String get currency;

  String get categoryId;

  @nullable
  String get latitude;

  @nullable
  String get longitude;

  @nullable
  String get userId;

  String get typeId;

  @nullable
  String get timeZone;

  @nullable
  String get createdAt;

  @nullable
  String get updatedAt;

  BuiltList<String> get channels;

  String get country;
  @nullable
  String get businessUrl;

  @nullable
  String get hexColor;

  @nullable
  String get image;

  @nullable
  String get type;

  @nullable
  String get table;

  // ignore: sort_constructors_first
  Business._();

  factory Business([void Function(BusinessBuilder) updates]) = _$Business;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Business.serializer, this);
  }

  Business fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Business fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Business.serializer, jsonMap);
  }

  static Serializer<Business> get serializer => _$businessSerializer;
}
