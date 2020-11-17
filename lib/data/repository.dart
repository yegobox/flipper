// Copyright 2020-present the Saltech Systems authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


enum Environment { development, production }
enum LoginResult { unauthorized, authorized, disconnected, error }
enum LogoutMethod {
  normal,
  apiCredentialsError,
  dbCredentialsError,
  validationError,
  sessionDeleted
}

enum ResponseCode {
  success,
  notFound,
  error,
}

typedef LogoutCallback = void Function(LogoutMethod method);

class RepoResponse<T> {
  RepoResponse({@required this.code, this.result}) : assert(code != null);

  final ResponseCode code;
  final T result;

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RepoResponse &&
        other.code == code &&
        other.result == result;
  }
}

class ReceivedNotification {
  ReceivedNotification(
      {@required this.id,
      @required this.title,
      @required this.body,
      @required this.payload});

  final int id;
  final String title;
  final String body;
  final String payload;
}

class Repository {
 
  final _isLoggedInSubject = BehaviorSubject<bool>.seeded(false);
  final _lastLogoutMethodSubject =
      BehaviorSubject<LogoutMethod>.seeded(LogoutMethod.normal);

  Stream<bool> get isLoggedIn => _isLoggedInSubject.stream;
  Stream<LogoutMethod> get lastLogoutMethod => _lastLogoutMethodSubject.stream;

  void triggerLogout(LogoutMethod method) {
    _isLoggedInSubject.add(false);
    _lastLogoutMethodSubject.add(method);
  }

  void dispose() async {
    await _isLoggedInSubject.close();
    await _lastLogoutMethodSubject.close();
  }

}
