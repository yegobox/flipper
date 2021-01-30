library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'fcontact.g.dart';

abstract class FContact implements Built<FContact, FContactBuilder> {
  @nullable
  String get name;
  @nullable
  String get phoneNumber;

  FContact._();

  factory FContact([void Function(FContactBuilder) updates]) = _$FContact;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(FContact.serializer, this);
  }

  FContact fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static FContact fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(FContact.serializer, jsonMap);
  }

  static Serializer<FContact> get serializer => _$fContactSerializer;
}
