import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/permission/permission_check.dart';
import 'package:flipper/model/permission.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> permissionMiddleware(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return [
    TypedMiddleware<AppState, CheckPermission>(_checkPermission(navigatorKey)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _checkPermission(GlobalKey<NavigatorState> navigatorKey) {
  return (store, action, next) async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (status == PermissionStatus.granted) {
      final permission = Permission((p) => p
        ..checked = false
        ..type = 'Location');
      store.dispatch(OnCheckedPermission(permission: permission));
    } else {
      Map<PermissionGroup, PermissionStatus> status = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);

      if (status[PermissionGroup.locationWhenInUse] ==
          PermissionStatus.granted) {
        final permission = Permission((p) => p
          ..checked = false
          ..type = 'Location');
        store.dispatch(OnCheckedPermission(permission: permission));
      }
    }
  };
}
