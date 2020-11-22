import 'dart:async';
import 'package:flipper/model/pcolor.dart';
import 'package:meta/meta.dart';
import 'package:flipper/model/variation.dart';
import 'package:built_collection/built_collection.dart';

/// Actions are payloads of information that send data from your application to
/// your store. They are the only source of information for the store.
///
/// They are PODOs (Plain Old Dart Objects). We normally use stacked but in some case we need to share the state on global app level
/// that is where we need to use redux but we don't use it as in the whole application
///
class ConnectToDataSource {
  @override
  String toString() {
    return 'ConnectToDataSource{}';
  }
}

//@immutable
class OnUser {
  OnUser({this.user, Completer completer})
      : completer = completer ?? Completer();

  final Completer completer;
  final String user;
}

@immutable
class OnProductLoaded {
  const OnProductLoaded(this.userId);

  final String userId;

  @override
  String toString() {
    return 'SelectGroup{groupId: $userId}';
  }
}

@immutable
class CurrentColor{
  const CurrentColor({this.color});
  final PColor color;
}
@immutable
class Variations{
  const Variations({this.variations});
  final BuiltList<Variation> variations;
}
