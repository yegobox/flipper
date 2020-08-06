import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/permission/permission_check.dart';
import 'package:redux/redux.dart';

final businessReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, OnCheckedPermission>(_onPermissionCheck),
];

AppState _onPermissionCheck(AppState state, OnCheckedPermission action) {
  return state.rebuild((a) => a..permissions = action.permission.toBuilder());
}
