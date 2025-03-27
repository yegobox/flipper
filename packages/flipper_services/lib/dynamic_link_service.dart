library flipper_services;

import 'package:flutter/cupertino.dart';
import 'abstractions/dynamic_link.dart';

class UnSupportedDynamicLink implements DynamicLink {
  @override
  Future<String> createDynamicLink() async {
    return "https://play.google.com/store/apps/details?id=rw.flipper";
  }

  @override
  Future handleDynamicLink(BuildContext context) async {}
}

class DynamicLinkService implements DynamicLink {
  @override
  Future handleDynamicLink(BuildContext context) async {}

  @override
  Future<String> createDynamicLink() async {
    throw UnimplementedError();
  }
}
