
// ignore: library_names
library Switcher;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'switcher.g.dart';

abstract class Switcher implements Built<Switcher, SwitcherBuilder> {
  Switcher._();

  factory Switcher([updates(SwitcherBuilder b)]) = _$Switcher;

  @BuiltValueField(wireName: 'cashierName')
  @nullable
  String get cashierName;
  @BuiltValueField(wireName: 'isClosed')
  bool get isClosed;
  @BuiltValueField(wireName: 'isSocial')
  @nullable
  bool get isSocial;
  @BuiltValueField(wireName: 'tableName')
  @nullable
  String get tableName;
  @nullable
  @BuiltValueField(wireName: 'openingFLoat')
  double get openingFLoat;
  @nullable
  @BuiltValueField(wireName: 'closingFloat')
  double get closingFloat;
  @nullable
  @BuiltValueField(wireName: 'displayText')
  @nullable
  String get displayText;
  @nullable
  @BuiltValueField(wireName: 'businessId')
  @nullable
  String get businessId;
  @BuiltValueField(wireName: 'userId')
  @nullable
  String get userId;

  String toJson() {
    return json.encode(toMap());
  }

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
