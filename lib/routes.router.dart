// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/after_sale.dart';
import 'package:flipper_dashboard/business_home_view.dart';
import 'package:flipper_dashboard/collect_cash.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flipper_dashboard/order_summary.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Routes {
  static const String startUpView = '/';
  static const String dashboard = '/dashboard-view';
  static const String signup = '/sign-up-form-view';
  static const String home = '/business-home-view';
  static const String login = '/login-view';
  static const String product = '/add-product-view';
  static const String categories = '/list-categories';
  static const String colors = '/color-tile';
  static const String stock = '/receive-stock';
  static const String category = '/add-category';
  static const String variation = '/add-variation';
  static const String units = '/list-units';
  static const String summary = '/order-summary';
  static const String sell = '/Sell';
  static const String pay = '/Payments';
  static const String collect = '/collect-cash-view';
  static const String afterSale = '/after-sale';
  static const all = <String>{
    startUpView,
    dashboard,
    signup,
    home,
    login,
    product,
    categories,
    colors,
    stock,
    category,
    variation,
    units,
    summary,
    sell,
    pay,
    collect,
    afterSale,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.dashboard, page: DashboardView),
    RouteDef(Routes.signup, page: SignUpFormView),
    RouteDef(Routes.home, page: BusinessHomeView),
    RouteDef(Routes.login, page: LoginView),
    RouteDef(Routes.product, page: AddProductView),
    RouteDef(Routes.categories, page: ListCategories),
    RouteDef(Routes.colors, page: ColorTile),
    RouteDef(Routes.stock, page: ReceiveStock),
    RouteDef(Routes.category, page: AddCategory),
    RouteDef(Routes.variation, page: AddVariation),
    RouteDef(Routes.units, page: ListUnits),
    RouteDef(Routes.summary, page: OrderSummary),
    RouteDef(Routes.sell, page: Sell),
    RouteDef(Routes.pay, page: Payments),
    RouteDef(Routes.collect, page: CollectCashView),
    RouteDef(Routes.afterSale, page: AfterSale),
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
    OrderSummary: (data) {
      var args = data.getArgs<OrderSummaryArguments>(
        orElse: () => OrderSummaryArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => OrderSummary(key: args.key),
        settings: data,
      );
    },
    Sell: (data) {
      var args = data.getArgs<SellArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => Sell(
          key: args.key,
          product: args.product,
        ),
        settings: data,
      );
    },
    Payments: (data) {
      var args = data.getArgs<PaymentsArguments>(
        orElse: () => PaymentsArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => Payments(key: args.key),
        settings: data,
      );
    },
    CollectCashView: (data) {
      var args = data.getArgs<CollectCashViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CollectCashView(
          key: args.key,
          paymentType: args.paymentType,
        ),
        settings: data,
      );
    },
    AfterSale: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AfterSale(),
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

/// OrderSummary arguments holder class
class OrderSummaryArguments {
  final Key? key;
  OrderSummaryArguments({this.key});
}

/// Sell arguments holder class
class SellArguments {
  final Key? key;
  final Product product;
  SellArguments({this.key, required this.product});
}

/// Payments arguments holder class
class PaymentsArguments {
  final Key? key;
  PaymentsArguments({this.key});
}

/// CollectCashView arguments holder class
class CollectCashViewArguments {
  final Key? key;
  final String paymentType;
  CollectCashViewArguments({this.key, required this.paymentType});
}
