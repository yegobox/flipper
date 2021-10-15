// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flipper_chat/lite/pages/contact_page.dart';
import 'package:flipper_chat/lite/pages/lite.dart';
import 'package:flipper_dashboard/add_discount.dart';
import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/after_sale.dart';
import 'package:flipper_dashboard/analytic.dart';
import 'package:flipper_dashboard/business_home_view.dart';
import 'package:flipper_dashboard/collect_cash.dart';
import 'package:flipper_dashboard/connection_failed_view.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/customers.dart';
import 'package:flipper_dashboard/inapp_browser.dart';
import 'package:flipper_dashboard/order_summary.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/scanner_view.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:flipper_dashboard/setting_secreen.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_map/flipper_map.dart';
import 'package:flipper_map/subcategory.dart';
import 'package:flipper_models/discount.dart';
import 'package:flipper_models/product.dart';
// wimport 'package:flutter/foundation.dart';
import 'package:flipper_models/category.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

class Routes {
  static const String initial = '/';
  static const String chat = '/Lite';
  static const String contacts = '/contact-page';
  static const String signup = '/sign-up-form-view';
  static const String home = '/Home';
  static const String login = '/Login';
  static const String product = '/add-product-view';
  static const String discount = '/add-discount';
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
  static const String settings = '/settings-screen';
  static const String analytics = '/Analytics';
  static const String qrview = '/scann-view';
  static const String connectionState = '/connection-failed-view';
  static const String inappBrowser = '/in-app-browser';
  static const String map = '/map-view';
  static const String customers = '/Customers';
  static const all = <String>{
    initial,
    chat,
    contacts,
    signup,
    home,
    login,
    product,
    discount,
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
    settings,
    analytics,
    qrview,
    connectionState,
    inappBrowser,
    map,
    customers,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.initial, page: StartUpView),
    RouteDef(Routes.chat, page: Lite),
    RouteDef(Routes.contacts, page: ContactPage),
    RouteDef(Routes.signup, page: SignUpFormView),
    RouteDef(Routes.home, page: Home),
    RouteDef(Routes.login, page: Login),
    RouteDef(Routes.product, page: AddProductView),
    RouteDef(Routes.discount, page: AddDiscount),
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
    RouteDef(Routes.settings, page: SettingsScreen),
    RouteDef(Routes.analytics, page: Analytics),
    RouteDef(Routes.qrview, page: ScannView),
    RouteDef(Routes.connectionState, page: ConnectionFailedView),
    RouteDef(Routes.inappBrowser, page: InAppBrowser),
    RouteDef(Routes.map, page: MapView),
    RouteDef(Routes.customers, page: Customers),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    StartUpView: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    Lite: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => const Lite(),
        settings: data,
      );
    },
    ContactPage: (data) {
      var args = data.getArgs<ContactPageArguments>(
        orElse: () => ContactPageArguments(),
      );
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => ContactPage(
          key: args.key,
          fromType: args.fromType,
        ),
        settings: data,
      );
    },
    SignUpFormView: (data) {
      var args = data.getArgs<SignUpFormViewArguments>(
        orElse: () => SignUpFormViewArguments(),
      );
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => SignUpFormView(key: args.key),
        settings: data,
      );
    },
    Home: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => const Home(),
        settings: data,
      );
    },
    Login: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => Login(),
        settings: data,
      );
    },
    AddProductView: (data) {
      var args = data.getArgs<AddProductViewArguments>(
        orElse: () => AddProductViewArguments(),
      );
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => AddProductView(
          key: args.key,
          productId: args.productId,
        ),
        settings: data,
      );
    },
    AddDiscount: (data) {
      var args = data.getArgs<AddDiscountArguments>(
        orElse: () => AddDiscountArguments(),
      );
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => AddDiscount(
          key: args.key,
          discount: args.discount,
        ),
        settings: data,
      );
    },
    ListCategories: (data) {
      var args = data.getArgs<ListCategoriesArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
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
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => ColorTile(key: args.key),
        settings: data,
      );
    },
    ReceiveStock: (data) {
      var args = data.getArgs<ReceiveStockArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
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
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => AddCategory(key: args.key),
        settings: data,
      );
    },
    AddVariation: (data) {
      var args = data.getArgs<AddVariationArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => AddVariation(
          key: args.key,
          productId: args.productId,
        ),
        settings: data,
      );
    },
    ListUnits: (data) {
      var args = data.getArgs<ListUnitsArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
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
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => OrderSummary(key: args.key),
        settings: data,
      );
    },
    Sell: (data) {
      var args = data.getArgs<SellArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
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
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => Payments(key: args.key),
        settings: data,
      );
    },
    CollectCashView: (data) {
      var args = data.getArgs<CollectCashViewArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => CollectCashView(
          key: args.key,
          paymentType: args.paymentType,
        ),
        settings: data,
      );
    },
    AfterSale: (data) {
      var args = data.getArgs<AfterSaleArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => AfterSale(
          key: args.key,
          totalOrderAmount: args.totalOrderAmount,
        ),
        settings: data,
      );
    },
    SettingsScreen: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => SettingsScreen(),
        settings: data,
      );
    },
    Analytics: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => Analytics(),
        settings: data,
      );
    },
    ScannView: (data) {
      var args = data.getArgs<ScannViewArguments>(
        orElse: () => ScannViewArguments(),
      );
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => ScannView(
          key: args.key,
          intent: args.intent,
        ),
        settings: data,
      );
    },
    ConnectionFailedView: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => ConnectionFailedView(),
        settings: data,
      );
    },
    InAppBrowser: (data) {
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => const InAppBrowser(),
        settings: data,
        fullscreenDialog: true,
      );
    },
    MapView: (data) {
      var args = data.getArgs<MapViewArguments>(
        orElse: () => MapViewArguments(),
      );
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => MapView(
          key: args.key,
          subCategory: args.subCategory,
        ),
        settings: data,
      );
    },
    Customers: (data) {
      var args = data.getArgs<CustomersArguments>(nullOk: false);
      return MaterialPageRoute<MaterialRoute<dynamic>>(
        builder: (context) => Customers(
          key: args.key,
          orderId: args.orderId,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// ContactPage arguments holder class
class ContactPageArguments {
  final Key? key;
  final int? fromType;
  ContactPageArguments({this.key, this.fromType});
}

/// SignUpFormView arguments holder class
class SignUpFormViewArguments {
  final Key? key;
  SignUpFormViewArguments({this.key});
}

/// AddProductView arguments holder class
class AddProductViewArguments {
  final Key? key;
  final int? productId;
  AddProductViewArguments({this.key, this.productId});
}

/// AddDiscount arguments holder class
class AddDiscountArguments {
  final Key? key;
  final Discount? discount;
  AddDiscountArguments({this.key, this.discount});
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
  final int variantId;
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
  final int productId;
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

/// AfterSale arguments holder class
class AfterSaleArguments {
  final Key? key;
  final double totalOrderAmount;
  AfterSaleArguments({this.key, required this.totalOrderAmount});
}

/// ScannView arguments holder class
class ScannViewArguments {
  final Key? key;
  final String intent;
  ScannViewArguments({this.key, this.intent = 'selling'});
}

/// MapView arguments holder class
class MapViewArguments {
  final Key? key;
  final SubCategory? subCategory;
  MapViewArguments({this.key, this.subCategory});
}

/// Customers arguments holder class
class CustomersArguments {
  final Key? key;
  final int orderId;
  CustomersArguments({this.key, required this.orderId});
}
