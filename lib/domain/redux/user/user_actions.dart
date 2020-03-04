import "dart:async";

import 'package:flipper/model/user.dart';
import "package:meta/meta.dart";

@immutable
class UsersUpdateAction {
  final List<User> users;

  const UsersUpdateAction(this.users);
}

@immutable
class OnUserUpdateAction {
  final User user;

  const OnUserUpdateAction(this.user);
}

@immutable
class WithUsers {
  final List<User> users;

  WithUsers({this.users});
}

@immutable
class WithUser {
  final User user;

  const WithUser({this.user});
}

@immutable
class UserID {
  final int userId;

  const UserID({this.userId});
}

@immutable
class CreateUser {
  final User user;

  const CreateUser(this.user);
}

@immutable
class UpdateUserLocaleAction {
  final String locale;

  const UpdateUserLocaleAction(this.locale);
}

@immutable
class UpdateUserAction {
  final User user;
  final Completer completer;

  const UpdateUserAction(this.user, this.completer);
}
