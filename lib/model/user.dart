import "package:built_value/built_value.dart";

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  @nullable
  int get id;

  @nullable
  String get email;

  bool get active;

  String get name;

  @nullable
  String get status;
  String get role;
  String get permissions;
  String get createdAt;
  String get updatedAt;

  @nullable
  String get token;

  @nullable
  String get avatar;

  User._();

  factory User([void Function(UserBuilder) updates]) = _$User;
}

class UserHelper {
  static List<String> userIds(List<dynamic> userIds) {
    if (userIds == null) return [];
    return userIds.whereType<String>().toList();
  }
}
