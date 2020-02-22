// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:flipper/presentation/splash/splash_screen.dart';
import 'package:flipper/presentation/home/dash_board.dart';
import 'package:flipper/presentation/splash/aftersplash.dart';
import 'package:flipper/home/add_note_screen.dart';
import 'package:flipper/home/setting_up_application_screen.dart';
import 'package:flipper/presentation/business/sign_up_screen.dart';
import 'package:auto_route/transitions_builders.dart';
import 'package:flipper/presentation/business/create_business_screen.dart';
import 'package:flipper/home/add_item_screen.dart';
import 'package:flipper/home/edit_item_title.dart';
import 'package:flipper/home/take_picture_screen.dart';
import 'package:flipper/home/add_variation_screen.dart';
import 'package:flipper/home/add_unit_type.dart';
import 'package:flipper/home/add_category_screen.dart';
import 'package:flipper/home/category/create_category_input_screen.dart';
import 'package:flipper/home/receive_stock.dart';
import 'package:flipper/home/selling/change_quantity_selling.dart';
import 'package:flipper/home/cart/cart_details_screen.dart';
import 'package:flipper/home/items/all_item_screen.dart';
import 'package:flipper/home/items/view_items_screen.dart';
import 'package:flipper/presentation/login/login_screen.dart';
import 'package:flipper/home/items/view_single_item_screen.dart';
import 'package:flipper/home/items/edit_variation_screen.dart';
import 'package:flipper/home/widget/category/edit_category_screen.dart';
import 'package:flipper/home/unit/edit_unit_screen.dart';

class Router {
  static const splashScreen = '/';
  static const dashboard = '/dashboard';
  static const afterSplash = '/afterSplash';
  static const addNoteScreen = '/addNoteScreen';
  static const settingUpApplicationScreen = '/settingUpApplicationScreen';
  static const signUpScreen = '/signUpScreen';
  static const createBusiness = '/createBusiness';
  static const addItemScreen = '/addItemScreen';
  static const editItemTitle = '/editItemTitle';
  static const takePictureScreen = '/takePictureScreen';
  static const addVariationScreen = '/addVariationScreen';
  static const addUnitType = '/addUnitType';
  static const addCategoryScreen = '/addCategoryScreen';
  static const createCategoryInputScreen = '/createCategoryInputScreen';
  static const receiveStock = '/receiveStock';
  static const editQuantityItemScreen = '/editQuantityItemScreen';
  static const cartDetailsScreen = '/cartDetailsScreen';
  static const allItemScreen = '/allItemScreen';
  static const viewItemsScreen = '/viewItemsScreen';
  static const login = '/login';
  static const viewSingleItem = '/viewSingleItem';
  static const editVariationScreen = '/editVariationScreen';
  static const editCategoryScreen = '/editCategoryScreen';
  static const editUnitType = '/editUnitType';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.splashScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => SplashScreen(key: typedArgs),
          settings: settings,
        );
      case Router.dashboard:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => DashBoard(key: typedArgs),
          settings: settings,
        );
      case Router.afterSplash:
        return MaterialPageRoute(
          builder: (_) => AfterSplash(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addNoteScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => AddNoteScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.settingUpApplicationScreen:
        return MaterialPageRoute(
          builder: (_) => SettingUpApplicationScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.signUpScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              SignUpScreen(key: typedArgs),
          settings: settings,
        );
      case Router.createBusiness:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => CreateBusinessScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addItemScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => AddItemScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editItemTitle:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => EditItemTitle(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.takePictureScreen:
        return MaterialPageRoute(
          builder: (_) => TakePictureScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addVariationScreen:
        if (hasInvalidArgs<AddVariationScreenArguments>(args)) {
          return misTypedArgsRoute<AddVariationScreenArguments>(args);
        }
        final typedArgs = args as AddVariationScreenArguments ??
            AddVariationScreenArguments();
        return MaterialPageRoute(
          builder: (_) => AddVariationScreen(
              key: typedArgs.key,
              regularRetailPrice: typedArgs.regularRetailPrice,
              regularCostPrice: typedArgs.regularCostPrice),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addUnitType:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => AddUnitType(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addCategoryScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => AddCategoryScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.createCategoryInputScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => CreateCategoryInputScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.receiveStock:
        if (hasInvalidArgs<int>(args)) {
          return misTypedArgsRoute<int>(args);
        }
        final typedArgs = args as int;
        return MaterialPageRoute(
          builder: (_) => ReceiveStock(variationId: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editQuantityItemScreen:
        if (hasInvalidArgs<ChangeQuantityForSellingArguments>(args)) {
          return misTypedArgsRoute<ChangeQuantityForSellingArguments>(args);
        }
        final typedArgs = args as ChangeQuantityForSellingArguments ??
            ChangeQuantityForSellingArguments();
        return MaterialPageRoute(
          builder: (_) => ChangeQuantityForSelling(
              key: typedArgs.key, itemId: typedArgs.itemId),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.cartDetailsScreen:
        if (hasInvalidArgs<CartDetailsScreenArguments>(args)) {
          return misTypedArgsRoute<CartDetailsScreenArguments>(args);
        }
        final typedArgs =
            args as CartDetailsScreenArguments ?? CartDetailsScreenArguments();
        return MaterialPageRoute(
          builder: (_) =>
              CartDetailsScreen(key: typedArgs.key, carts: typedArgs.carts),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.allItemScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => AllItemScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.viewItemsScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => ViewItemsScreen(key: typedArgs),
          settings: settings,
        );
      case Router.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case Router.viewSingleItem:
        if (hasInvalidArgs<ViewSingleItemScreenArguments>(args)) {
          return misTypedArgsRoute<ViewSingleItemScreenArguments>(args);
        }
        final typedArgs = args as ViewSingleItemScreenArguments ??
            ViewSingleItemScreenArguments();
        return MaterialPageRoute(
          builder: (_) => ViewSingleItemScreen(
              key: typedArgs.key,
              itemId: typedArgs.itemId,
              itemName: typedArgs.itemName,
              itemColor: typedArgs.itemColor),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editVariationScreen:
        if (hasInvalidArgs<EditVariationScreenArguments>(args)) {
          return misTypedArgsRoute<EditVariationScreenArguments>(args);
        }
        final typedArgs = args as EditVariationScreenArguments ??
            EditVariationScreenArguments();
        return MaterialPageRoute(
          builder: (_) => EditVariationScreen(
              key: typedArgs.key,
              variationId: typedArgs.variationId,
              itemId: typedArgs.itemId),
          settings: settings,
        );
      case Router.editCategoryScreen:
        if (hasInvalidArgs<EditCategoryScreenArguments>(args)) {
          return misTypedArgsRoute<EditCategoryScreenArguments>(args);
        }
        final typedArgs = args as EditCategoryScreenArguments ??
            EditCategoryScreenArguments();
        return MaterialPageRoute(
          builder: (_) =>
              EditCategoryScreen(key: typedArgs.key, ItemId: typedArgs.ItemId),
          settings: settings,
        );
      case Router.editUnitType:
        if (hasInvalidArgs<EditUnitTypeScreenArguments>(args)) {
          return misTypedArgsRoute<EditUnitTypeScreenArguments>(args);
        }
        final typedArgs = args as EditUnitTypeScreenArguments ??
            EditUnitTypeScreenArguments();
        return MaterialPageRoute(
          builder: (_) =>
              EditUnitTypeScreen(key: typedArgs.key, itemId: typedArgs.itemId),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//AddVariationScreen arguments holder class
class AddVariationScreenArguments {
  final Key key;
  final double regularRetailPrice;
  final double regularCostPrice;
  AddVariationScreenArguments(
      {this.key, this.regularRetailPrice, this.regularCostPrice});
}

//ChangeQuantityForSelling arguments holder class
class ChangeQuantityForSellingArguments {
  final Key key;
  final int itemId;
  ChangeQuantityForSellingArguments({this.key, this.itemId});
}

//CartDetailsScreen arguments holder class
class CartDetailsScreenArguments {
  final Key key;
  final List<dynamic> carts;
  CartDetailsScreenArguments({this.key, this.carts});
}

//ViewSingleItemScreen arguments holder class
class ViewSingleItemScreenArguments {
  final Key key;
  final int itemId;
  final String itemName;
  final String itemColor;
  ViewSingleItemScreenArguments(
      {this.key, this.itemId, this.itemName, this.itemColor});
}

//EditVariationScreen arguments holder class
class EditVariationScreenArguments {
  final Key key;
  final int variationId;
  final int itemId;
  EditVariationScreenArguments({this.key, this.variationId, this.itemId});
}

//EditCategoryScreen arguments holder class
class EditCategoryScreenArguments {
  final Key key;
  final int ItemId;
  EditCategoryScreenArguments({this.key, this.ItemId});
}

//EditUnitTypeScreen arguments holder class
class EditUnitTypeScreenArguments {
  final Key key;
  final int itemId;
  EditUnitTypeScreenArguments({this.key, this.itemId});
}
