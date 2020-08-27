import 'package:built_value/built_value.dart';

part 'fuser.g.dart';

abstract class FUser implements Built<FUser, FUserBuilder> {
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

  factory FUser([void Function(FUserBuilder) updates]) = _$FUser;
}

class UserHelper {
  static List<String> userIds(List<dynamic> userIds) {
    if (userIds == null) return [];
    return userIds.whereType<String>().toList();
  }
}
