import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'unit.g.dart';

abstract class Unit implements Built<Unit, UnitBuilder> {
  String get name;

  bool get focused;
  @nullable
  int get businessId;
  int get branchId;
  @nullable
  int get id;
  // ignore: sort_constructors_first
  Unit._();

  factory Unit([void Function(UnitBuilder) updates]) = _$Unit;

  BuiltList<String> get channels;
  
  String toJson() {
    return json.encode(toMap());
  }
  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Unit.serializer, this);
  }

  Unit fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  // ignore: always_specify_types
  static Unit fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Unit.serializer, jsonMap);
  }

  static Serializer<Unit> get serializer => _$unitSerializer;
}
