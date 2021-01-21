library flipper_models;

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'converters/serializers.dart';

part 'fuser.g.dart';

abstract class FUser implements Built<FUser, FUserBuilder> {
  @nullable
  String get id;

  @nullable
  String get email;

  @nullable
  bool get active;

  @nullable
  String get name;

  String get userId;

  @nullable
  String get createdAt;
  @nullable
  String get updatedAt;

  @nullable
  String get token;

  FUser._();

  factory FUser([void Function(FUserBuilder) updates]) = _$FUser;

  String toJson() {
    return json.encode(toMap());
  }

  // ignore: always_specify_types
  Map toMap() {
    return standardSerializers.serializeWith(FUser.serializer, this);
  }

  FUser fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }

  static FUser fromMap(Map jsonMap) {
    return standardSerializers.deserializeWith(FUser.serializer, jsonMap);
  }

  static Serializer<FUser> get serializer => _$fUserSerializer;
}
