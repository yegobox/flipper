// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/business_home_view.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Routes {
  static const String startUpView = '/';
  static const String dashboardView = '/dashboard-view';
  static const String signUpFormView = '/sign-up-form-view';
  static const String businessHomeView = '/business-home-view';
  static const String loginView = '/login-view';
  static const String addProductView = '/add-product-view';
  static const String listCategories = '/list-categories';
  static const String colorTile = '/color-tile';
  static const String receiveStock = '/receive-stock';
  static const String addCategory = '/add-category';
  static const String addVariation = '/add-variation';
  static const String listUnits = '/list-units';
  static const all = <String>{
    startUpView,
    dashboardView,
    signUpFormView,
    businessHomeView,
    loginView,
    addProductView,
    listCategories,
    colorTile,
    receiveStock,
    addCategory,
    addVariation,
    listUnits,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.dashboardView, page: DashboardView),
    RouteDef(Routes.signUpFormView, page: SignUpFormView),
    RouteDef(Routes.businessHomeView, page: BusinessHomeView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.addProductView, page: AddProductView),
    RouteDef(Routes.listCategories, page: ListCategories),
    RouteDef(Routes.colorTile, page: ColorTile),
    RouteDef(Routes.receiveStock, page: ReceiveStock),
    RouteDef(Routes.addCategory, page: AddCategory),
    RouteDef(Routes.addVariation, page: AddVariation),
    RouteDef(Routes.listUnits, page: ListUnits),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    DashboardView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => DashboardView(),
        settings: data,
      );
    },
    SignUpFormView: (data) {
      var args = data.getArgs<SignUpFormViewArguments>(
        orElse: () => SignUpFormViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignUpFormView(key: args.key),
        settings: data,
      );
    },
    BusinessHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const BusinessHomeView(),
        settings: data,
      );
    },
    LoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(),
        settings: data,
      );
    },
    AddProductView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AddProductView(),
        settings: data,
      );
    },
    ListCategories: (data) {
      var args = data.getArgs<ListCategoriesArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ListCategories(
          key: args.key,
          categories: args.categories,
        ),
        settings: data,
      );
    },
    ColorTile: (data) {
      var args = data.getArgs<ColorTileArguments>(
        orElse: () => ColorTileArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ColorTile(key: args.key),
        settings: data,
      );
    },
    ReceiveStock: (data) {
      var args = data.getArgs<ReceiveStockArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ReceiveStock(
          key: args.key,
          variantId: args.variantId,
        ),
        settings: data,
      );
    },
    AddCategory: (data) {
      var args = data.getArgs<AddCategoryArguments>(
        orElse: () => AddCategoryArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddCategory(key: args.key),
        settings: data,
      );
    },
    AddVariation: (data) {
      var args = data.getArgs<AddVariationArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddVariation(
          key: args.key,
          productId: args.productId,
        ),
        settings: data,
      );
    },
    ListUnits: (data) {
      var args = data.getArgs<ListUnitsArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ListUnits(
          key: args.key,
          type: args.type,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// SignUpFormView arguments holder class
class SignUpFormViewArguments {
  final Key? key;
  SignUpFormViewArguments({this.key});
}

/// ListCategories arguments holder class
class ListCategoriesArguments {
  final Key? key;
  final List<Category> categories;
  ListCategoriesArguments({this.key, required this.categories});
}

/// ColorTile arguments holder class
class ColorTileArguments {
  final Key? key;
  ColorTileArguments({this.key});
}

/// ReceiveStock arguments holder class
class ReceiveStockArguments {
  final Key? key;
  final String variantId;
  ReceiveStockArguments({this.key, required this.variantId});
}

/// AddCategory arguments holder class
class AddCategoryArguments {
  final Key? key;
  AddCategoryArguments({this.key});
}

/// AddVariation arguments holder class
class AddVariationArguments {
  final Key? key;
  final String productId;
  AddVariationArguments({this.key, required this.productId});
}

/// ListUnits arguments holder class
class ListUnitsArguments {
  final Key? key;
  final String type;
  ListUnitsArguments({this.key, required this.type});
}
