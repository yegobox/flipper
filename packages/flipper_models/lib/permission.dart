library flipper_models;

import 'package:built_value/built_value.dart';

part 'permission.g.dart';

abstract class Permission implements Built<Permission, PermissionBuilder> {
  bool get checked;
  String get type;

  Permission._();
  factory Permission([void Function(PermissionBuilder) updates]) = _$Permission;
}
