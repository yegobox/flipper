library flipper_models;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

// import './converters/serializers.dart';

part 'fuser.g.dart';

abstract class FUser implements Built<FUser, FUserBuilder> {
  String? get id;

  String? get email;

  bool? get active;

  String? get name;

  String get userId;

  String? get createdAt;

  String? get updatedAt;

  String? get token;

  String? get permissions;

  FUser._();

  factory FUser([void Function(FUserBuilder) updates]) = _$FUser;

  // String toJson() {
  //   return json.encode(toMap());
  // }

  // ignore: always_specify_types
  // Map? toMap() {
  //   return standardSerializers.serializeWith(FUser.serializer, this);
  // }

  // FUser? fromJson(String jsonString) {
  //   return fromMap(json.decode(jsonString));
  // }

  static FUser? fromMap(Map jsonMap) {
    // return standardSerializers.deserializeWith(FUser.serializer, jsonMap);
  }

  static Serializer<FUser> get serializer => _$fUserSerializer;
}
