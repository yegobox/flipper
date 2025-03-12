library flipper_services;

import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
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
  final _routerService = locator<RouterService>();
  @override
  Future handleDynamicLink(BuildContext context) async {
    // if the app is opened with the link
    throw UnimplementedError();
  }

  @override
  Future<String> createDynamicLink() async {
    throw UnimplementedError();
  }
}
