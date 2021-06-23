// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:chat/screens/about_chat.dart';
import 'package:chat/screens/add_conversation.dart';
import 'package:chat/screens/chat_list.dart';
import 'package:chat/screens/chatpage.dart';
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
import 'package:flipper_dashboard/customers.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flipper_dashboard/order_summary.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:flipper_dashboard/setting_secreen.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/category.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Routes {
  static const String startUpView = '/';
  static const String dashboard = '/dashboard-view';
  static const String signup = '/sign-up-form-view';
  static const String home = '/Home';
  static const String login = '/Login';
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
  static const String settings = '/settings-screen';
  static const String about = '/about-chat-mini-app';
  static const String chatHome = '/chat-list';
  static const String chatPage = '/k-chat-page';
  static const String addConvo = '/add-conversation';
  static const String customers = '/Customers';
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
    settings,
    about,
    chatHome,
    chatPage,
    addConvo,
    customers,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.dashboard, page: DashboardView),
    RouteDef(Routes.signup, page: SignUpFormView),
    RouteDef(Routes.home, page: Home),
    RouteDef(Routes.login, page: Login),
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
    RouteDef(Routes.settings, page: SettingsScreen),
    RouteDef(Routes.about, page: AboutChatMiniApp),
    RouteDef(Routes.chatHome, page: ChatList),
    RouteDef(Routes.chatPage, page: KChatPage),
    RouteDef(Routes.addConvo, page: AddConversation),
    RouteDef(Routes.customers, page: Customers),
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
    Home: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const Home(),
        settings: data,
      );
    },
    Login: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => Login(),
        settings: data,
      );
    },
    AddProductView: (data) {
      var args = data.getArgs<AddProductViewArguments>(
        orElse: () => AddProductViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddProductView(key: args.key),
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
      var args = data.getArgs<AfterSaleArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => AfterSale(
          key: args.key,
          totalOrderAmount: args.totalOrderAmount,
        ),
        settings: data,
      );
    },
    SettingsScreen: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SettingsScreen(),
        settings: data,
      );
    },
    AboutChatMiniApp: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AboutChatMiniApp(),
        settings: data,
      );
    },
    ChatList: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => ChatList(),
        settings: data,
      );
    },
    KChatPage: (data) {
      var args = data.getArgs<KChatPageArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => KChatPage(
          key: args.key,
          receiverId: args.receiverId,
        ),
        settings: data,
      );
    },
    AddConversation: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AddConversation(),
        settings: data,
      );
    },
    Customers: (data) {
      var args = data.getArgs<CustomersArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
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

/// SignUpFormView arguments holder class
class SignUpFormViewArguments {
  final Key? key;
  SignUpFormViewArguments({this.key});
}

/// AddProductView arguments holder class
class AddProductViewArguments {
  final Key? key;
  AddProductViewArguments({this.key});
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

/// KChatPage arguments holder class
class KChatPageArguments {
  final Key? key;
  final int receiverId;
  KChatPageArguments({this.key, required this.receiverId});
}

/// Customers arguments holder class
class CustomersArguments {
  final Key? key;
  final int orderId;
  CustomersArguments({this.key, required this.orderId});
}
