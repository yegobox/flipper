library flipper_services;

import 'package:flutter/material.dart';

class FlipperNavigationService {
  final GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();


  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState.pop();
  }

  void popUntil(String route) {
    return _navigationKey.currentState.popUntil(ModalRoute.withName(route));
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }
}
