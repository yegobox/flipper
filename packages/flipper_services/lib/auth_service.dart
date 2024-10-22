import 'dart:async';

import 'user.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  authenticatedFailed,
  logout
}

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<void> authenticateUser(
      {required String username, required String password});
  Future<void> signOut();
  Stream<AuthenticationStatus> get status;
}

class FakeAuthenticationService extends AuthenticationService {
  FakeAuthenticationService() {
    _user = null;
  }

  final _controller = StreamController<AuthenticationStatus>();
  User? _user;

  void dispose() => _controller.close();

  @override
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  @override
  Future<User?> getCurrentUser() async => _user;

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(AuthenticationStatus.logout);
  }

  @override
  Future<bool> authenticateUser(
      {required String username, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      _user = null;
      _user = _users
          .where((i) => i.username == username && i.password == password)
          .first;
      if (_user == null) {
        _controller.add(AuthenticationStatus.authenticatedFailed);
      } else {
        _controller.add(AuthenticationStatus.authenticated);
        return true;
      }
    } catch (e) {
      _controller.add(AuthenticationStatus.authenticatedFailed);
    }
    return false;
  }

  final List<User> _users = [
    const User(username: 'demo@example.com', password: 'P@ssw0rd12'),
  ];
}
