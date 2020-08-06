import 'dart:async';

import 'package:meta/meta.dart';

/// Actions are payloads of information that send data from your application to
/// your store. They are the only source of information for the store.
///
/// They are PODOs (Plain Old Dart Objects).
///
class ConnectToDataSource {
  @override
  String toString() {
    return 'ConnectToDataSource{}';
  }
}

//@immutable
class OnUser {
  final String user;
  final Completer completer;
  OnUser({this.user, Completer completer})
      : completer = completer ?? Completer();
}

@immutable
class OnProductLoaded {
  final String userId;

  const OnProductLoaded(this.userId);

  @override
  String toString() {
    return 'SelectGroup{groupId: $userId}';
  }
}
