import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'branch.g.dart';

abstract class Branch implements Built<Branch, BranchBuilder> {
  @nullable
  String get id;

  String get businessId;

  @nullable
  String get createdAt;

  String get name;

  @nullable
  String get mapLatitude;

  @nullable
  String get mapLongitude;

  @nullable
  String get updatedAt;
  @nullable

  String get description;

  @nullable
  bool get active;

  @nullable
  BuiltList<String> get channels;

  @nullable
  String get location;

  // ignore: sort_constructors_first
  Branch._();

  // ignore: sort_constructors_first
  factory Branch([void Function(BranchBuilder) updates]) = _$Branch;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(Branch.serializer, this);
  }

  Branch fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static Branch fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(Branch.serializer, jsonMap);
  }

  static Serializer<Branch> get serializer => _$branchSerializer;
}
