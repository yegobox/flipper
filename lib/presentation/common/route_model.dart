import 'package:flutter/material.dart';


class RouteModel extends InheritedWidget {
  const RouteModel({
    Key key,
    // @required this.route,
    @required Widget child,
  }) : 
        assert(child != null),
        super(key: key, child: child);

  // final UserRoute route;

  static RouteModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RouteModel>();
  }

  @override
  bool updateShouldNotify(RouteModel oldWidget) {
    // return route != oldWidget.route;
  }
}