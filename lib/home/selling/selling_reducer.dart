import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/home/selling/actions.dart';
import 'package:redux/redux.dart';

final sellingReducer = <AppState Function(AppState, dynamic)>[
  TypedReducer<AppState, OnNewTotal>(_onSellAction),
];
AppState _onSellAction(AppState state, OnNewTotal action) {
  return state.rebuild((a) => a..total = action.total.toBuilder());
}
