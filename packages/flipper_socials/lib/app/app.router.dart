// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i5;
import 'package:stacked/stacked.dart' as _i4;
import 'package:stacked_services/stacked_services.dart' as _i1;

import '../ui/views/home/home_view.dart' as _i3;
import '../ui/views/startup/startup_view.dart' as _i2;

final stackedRouter = StackedRouterWeb(_i1.StackedService.navigatorKey);

class StackedRouterWeb extends _i4.RootStackRouter {
  StackedRouterWeb([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    StartupViewRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i2.StartupView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
    HomeViewRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeView(),
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          StartupViewRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          HomeViewRoute.name,
          path: '/home-view',
        ),
      ];
}

/// generated route for
/// [_i2.StartupView]
class StartupViewRoute extends _i4.PageRouteInfo<void> {
  const StartupViewRoute()
      : super(
          StartupViewRoute.name,
          path: '/',
        );

  static const String name = 'StartupView';
}

/// generated route for
/// [_i3.HomeView]
class HomeViewRoute extends _i4.PageRouteInfo<void> {
  const HomeViewRoute()
      : super(
          HomeViewRoute.name,
          path: '/home-view',
        );

  static const String name = 'HomeView';
}
