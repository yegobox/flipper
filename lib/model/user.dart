import 'package:built_value/built_value.dart';

part 'user.g.dart';

abstract class FUser implements Built<FUser, UserBuilder> {
  @nullable
  String get id;

  @nullable
  String get email;

  bool get active;

  String get name;

  String get createdAt;
  String get updatedAt;

  @nullable
  String get token;

  FUser._();

  factory FUser([void Function(UserBuilder) updates]) = _$User;
}

class UserHelper {
  static List<String> userIds(List<dynamic> userIds) {
    if (userIds == null) return [];
    return userIds.whereType<String>().toList();
  }
}
