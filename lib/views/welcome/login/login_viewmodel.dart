import 'package:built_value/built_value.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:redux/redux.dart';

part 'login_viewmodel.g.dart';

abstract class LoginViewModel
    implements Built<LoginViewModel, LoginViewModelBuilder> {
  LoginViewModel._();
  bool get hasData;
  factory LoginViewModel([void Function(LoginViewModelBuilder) updates]) =
      _$LoginViewModel;
  static bool _hasData(Store<AppState> store) {
    return store.state.user != null;
  }

  static LoginViewModel fromStore(Store<AppState> store) {
    return LoginViewModel((vm) => vm
      ..hasData = _hasData(
          store)); //Note is we don't call toBuilder to user it does not match the type.
  }
}
