// import 'dart:core';
// import 'dart:developer';
// import 'package:flipper_models/sync.dart';
// import 'package:flipper_services/constants.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:pocketbase/pocketbase.dart';
// import 'isar_models.dart';

import 'package:flipper_services/constants.dart';

abstract class IJsonSerializable {
  Map<String, dynamic> toJson();
  DateTime? lastTouched = DateTime.now();
  DateTime? deletedAt;
  String action = AppActions.created;
}
