import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/permission/permission_check.dart';
import 'package:flipper_models/permission.dart';
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
  // ignore: always_specify_types
  return (Store<AppState> store, action, next) async {
    final PermissionStatus locationStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    final PermissionStatus contactStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);

    final PermissionStatus smsStatus =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.sms);

    if (locationStatus == PermissionStatus.granted &&
        contactStatus == PermissionStatus.granted &&
        smsStatus == PermissionStatus.granted) {
      final Permission permission = Permission((PermissionBuilder p) => p
        ..checked = false
        ..type = 'Location');
      store.dispatch(OnCheckedPermission(permission: permission));
    } else {
      try {
        final Map<PermissionGroup, PermissionStatus> status =
            await PermissionHandler()
                // ignore: always_specify_types
                .requestPermissions([
          PermissionGroup.locationAlways,
          PermissionGroup.contacts,
          PermissionGroup.sms
        ]);

        if (status[PermissionGroup.locationWhenInUse] ==
            PermissionStatus.granted) {
          final Permission permission = Permission((PermissionBuilder p) => p
            ..checked = false
            ..type = 'Location');
          store.dispatch(OnCheckedPermission(permission: permission));
        }
        // ignore: empty_catches
      } catch (e) {}
    }
  };
}
