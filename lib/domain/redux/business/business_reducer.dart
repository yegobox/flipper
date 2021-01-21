import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/business/business_actions.dart';
import 'package:redux/redux.dart';

final businessReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, OnBusinessLoaded>(_onBusinessLoaded),
  TypedReducer<AppState, ActiveBusinessAction>(_onActiveBusinessId),
  
  TypedReducer<AppState, WithBusiness>(_onCreatingBusiness),
  TypedReducer<AppState, ResetBusiness>(_resetBusiness),
  TypedReducer<AppState, RefreshBusinessList>(_refreshBusinessList),
];
AppState _onBusinessLoaded(AppState state, OnBusinessLoaded action) {
  return state.rebuild((a) => a..businesses = action.business);
}

AppState _onCreatingBusiness(AppState state, WithBusiness action) {
  return state.rebuild((a) => a..business = action.business.toBuilder());
}

AppState _resetBusiness(AppState state, ResetBusiness action) {
  return state.rebuild((a) => a..business = null);
}

AppState _onActiveBusinessId(AppState state, ActiveBusinessAction action) {
  return state
      .rebuild((a) => a..currentActiveBusiness = action.bussiness.toBuilder());
}


AppState _refreshBusinessList(AppState state, RefreshBusinessList action) {
  //TODO(richard):FIXME: this is not updating as it should
  //FIXME:
  return state.rebuild((a) => a
//    ..businesses.remove( state.previousActiveBusiness)
//    ..businesses.add(action.updatedBusiness)
      );
}
