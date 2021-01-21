// ignore: library_names
library flipper_models;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

// import 'serializers.dart';

part 'switcher.g.dart';

abstract class Switcher implements Built<Switcher, SwitcherBuilder> {
  Switcher._();

  // ignore: sort_unnamed_constructors_first
  factory Switcher([updates(SwitcherBuilder b)]) = _$Switcher;

  @BuiltValueField(wireName: 'id')
  @nullable
  String get documentId;

  @BuiltValueField(wireName: 'cashierName')
  @nullable
  String get cashierName;

  @BuiltValueField(wireName: 'isClosed')
  bool get isClosed;

  @BuiltValueField(wireName: 'isSocial')
  @nullable
  bool get isSocial;

  @BuiltValueField(wireName: 'table')
  @nullable
  String get table;

  @nullable
  @BuiltValueField(wireName: 'openingFLoat')
  double get openingFLoat;

  @nullable
  @BuiltValueField(wireName: 'closingFloat')
  double get closingFloat;

  @BuiltValueField(wireName: 'displayText')
  @nullable
  String get displayText;

  @nullable
  @BuiltValueField(wireName: 'businessId')
  String get businessId;

  @BuiltValueField(wireName: 'userId')
  @nullable
  String get userId;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Switcher.serializer, this);
  }

  Switcher fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Switcher fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Switcher.serializer, jsonMap);
  }

  static Serializer<Switcher> get serializer => _$switcherSerializer;
}
