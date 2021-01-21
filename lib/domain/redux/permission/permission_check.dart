import 'package:flipper_models/permission.dart';
import 'package:flutter/material.dart';

@immutable
class OnCheckedPermission {
  final Permission permission;
  const OnCheckedPermission({@required this.permission});

  @override
  String toString() {
    return 'OnCheckingPermission{OnCheckingPermission: $permission}';
  }
}

@immutable
class CheckPermission {
  final bool checking;

  const CheckPermission({@required this.checking});

  @override
  String toString() {
    return 'CheckPermission{CheckPermission: $checking}';
  }
}
