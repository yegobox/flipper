library flipper_models;

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'pcolor.g.dart';

abstract class PColor implements Built<PColor, PColorBuilder> {
  String get id;

  String get name;

  String get table;

  bool get isActive;

  @nullable
  BuiltList<String> get channels;

  // ignore: sort_constructors_first
  PColor._();
  // ignore: sort_unnamed_constructors_first
  // ignore: sort_constructors_first
  factory PColor([updates(PColorBuilder b)]) = _$PColor;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(PColor.serializer, this);
  }

  PColor fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static PColor fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(PColor.serializer, jsonMap);
  }

  static Serializer<PColor> get serializer => _$pColorSerializer;
}
