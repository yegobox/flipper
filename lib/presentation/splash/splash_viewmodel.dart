import 'package:built_value/built_value.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:redux/redux.dart';

part 'splash_viewmodel.g.dart';

abstract class SplashViewModel
    implements Built<SplashViewModel, SplashViewModelBuilder> {
  bool get hasData;
  SplashViewModel._();
  factory SplashViewModel([void Function(SplashViewModelBuilder) updates]) =
      _$SplashViewModel;

  static bool _hasData(Store<AppState> store) {
    if (store.state != null) {
      return store.state.user != null;
    }
    return false;
  }

  static SplashViewModel fromStore(Store<AppState> store) {
    return SplashViewModel((vm) => vm
      ..hasData = _hasData(
          store)); //Note is we don't call toBuilder to user it does not match the type.
  }
}
