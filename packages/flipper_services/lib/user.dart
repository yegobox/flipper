import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class User extends Equatable {
  final String username;
  final String password;

  const User({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];

  static const User empty = User(
    username: '',
    password: '',
  );
}
