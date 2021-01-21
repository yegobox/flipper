import 'dart:async';

import 'package:flipper_models/fuser.dart';
import 'package:meta/meta.dart';

@immutable
class UsersUpdateAction {
  final List<FUser> users;

  const UsersUpdateAction(this.users);
}

@immutable
class OnUserUpdateAction {
  final FUser user;

  const OnUserUpdateAction(this.user);
}

@immutable
class WithUsers {
  final List<FUser> users;

  WithUsers({this.users});
}

@immutable
class WithUser {
  const WithUser({this.user});
  final FUser user;
}

@deprecated
@immutable
class CreateUser {
  final FUser user;

  const CreateUser(this.user);
}

@immutable
class UpdateUserLocaleAction {
  final String locale;

  const UpdateUserLocaleAction(this.locale);
}

@immutable
class UpdateUserAction {
  final FUser user;
  final Completer completer;

  const UpdateUserAction(this.user, this.completer);
}
