import 'package:flipper_models/order.dart';
import 'package:meta/meta.dart';

// Authentication
class VerifyAuthenticationState {}

class AfterLoginAction {}

class LogOutAction {}

class OnLogoutSuccess {
  OnLogoutSuccess();

  @override
  String toString() {
    return 'LogOut{user: null}';
  }
}

@immutable
class OrderCreated {
  const OrderCreated({this.order});

  final Order order;
}

@immutable
class OnDbLoaded {
  const OnDbLoaded({this.name});

  final String name;
}

class Unauthenticated {
  Unauthenticated(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'OnLogoutFail{There was an error logging in: $error}';
  }
}

@immutable
class OnAuthenticated {
  const OnAuthenticated({@required this.user});
  final dynamic user;
  @override
  String toString() {
    return 'OnAuthenticated{user: $user}';
  }
}
