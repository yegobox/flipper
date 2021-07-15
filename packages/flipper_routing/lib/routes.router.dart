// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flipper_chat/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Routes {
  static const String rootApp = '/';
  static const all = <String>{
    rootApp,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.rootApp, page: RootApp),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    RootApp: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => RootApp(),
        settings: data,
      );
    },
  };
}
