// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flipper/presentation/splash/splash_screen.dart';
import 'package:flipper/presentation/home/dash_board.dart';
import 'package:flipper/presentation/splash/aftersplash.dart';
import 'package:flipper/home/add_note_screen.dart';
import 'package:flipper/home/setting_up_application_screen.dart';
import 'package:flipper/presentation/business/sign_up_screen.dart';
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
import 'package:flipper/model/cart.dart';
import 'package:flipper/home/items/all_item_screen.dart';
import 'package:flipper/home/items/view_items_screen.dart';
import 'package:flipper/presentation/login/login_screen.dart';
import 'package:flipper/home/items/view_single_item_screen.dart';
import 'package:flipper/home/items/edit_variation_screen.dart';
import 'package:flipper/home/widget/category/edit_category_screen.dart';
import 'package:flipper/home/unit/edit_unit_screen.dart';
import 'package:flipper/home/transactions/transaction_screen.dart';
import 'package:flipper/presentation/login/auth_webview.dart';

class Router {
  static const splashScreen = '/';
  static const dashboard = '/dashboard';
  static const afterSplash = '/after-splash';
  static const addNoteScreen = '/add-note-screen';
  static const settingUpApplicationScreen = '/setting-up-application-screen';
  static const signUpScreen = '/sign-up-screen';
  static const createBusiness = '/create-business';
  static const addItemScreen = '/add-item-screen';
  static const editItemTitle = '/edit-item-title';
  static const takePictureScreen = '/take-picture-screen';
  static const addVariationScreen = '/add-variation-screen';
  static const addUnitType = '/add-unit-type';
  static const addCategoryScreen = '/add-category-screen';
  static const createCategoryInputScreen = '/create-category-input-screen';
  static const receiveStock = '/receive-stock';
  static const editQuantityItemScreen = '/edit-quantity-item-screen';
  static const cartDetailsScreen = '/cart-details-screen';
  static const allItemScreen = '/all-item-screen';
  static const viewItemsScreen = '/view-items-screen';
  static const login = '/login';
  static const viewSingleItem = '/view-single-item';
  static const editVariationScreen = '/edit-variation-screen';
  static const editCategoryScreen = '/edit-category-screen';
  static const editUnitType = '/edit-unit-type';
  static const transactionScreen = '/transaction-screen';
  static const webView = '/web-view';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.splashScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashScreen(key: typedArgs),
          settings: settings,
        );
      case Router.dashboard:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => DashBoard(key: typedArgs),
          settings: settings,
        );
      case Router.afterSplash:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AfterSplash(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addNoteScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddNoteScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.settingUpApplicationScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SettingUpApplicationScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.signUpScreen:
        if (hasInvalidArgs<SignUpScreenArguments>(args)) {
          return misTypedArgsRoute<SignUpScreenArguments>(args);
        }
        final typedArgs =
            args as SignUpScreenArguments ?? SignUpScreenArguments();
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => SignUpScreen(
              key: typedArgs.key,
              token: typedArgs.token,
              email: typedArgs.email,
              name: typedArgs.name,
              avatar: typedArgs.avatar),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Router.createBusiness:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => CreateBusinessScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addItemScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddItemScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editItemTitle:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditItemTitle(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.takePictureScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => TakePictureScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addVariationScreen:
        if (hasInvalidArgs<AddVariationScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<AddVariationScreenArguments>(args);
        }
        final typedArgs = args as AddVariationScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddVariationScreen(
              key: typedArgs.key,
              regularRetailPrice: typedArgs.regularRetailPrice,
              regularCostPrice: typedArgs.regularCostPrice),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addUnitType:
        if (hasInvalidArgs<AddUnitTypeScreenArguments>(args)) {
          return misTypedArgsRoute<AddUnitTypeScreenArguments>(args);
        }
        final typedArgs =
            args as AddUnitTypeScreenArguments ?? AddUnitTypeScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              AddUnitTypeScreen(key: typedArgs.key, itemId: typedArgs.itemId),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.addCategoryScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddCategoryScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.createCategoryInputScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => CreateCategoryInputScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.receiveStock:
        if (hasInvalidArgs<ReceiveStockScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ReceiveStockScreenArguments>(args);
        }
        final typedArgs = args as ReceiveStockScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ReceiveStockScreen(
              key: typedArgs.key, variationId: typedArgs.variationId),
          settings: settings,
        );
      case Router.editQuantityItemScreen:
        if (hasInvalidArgs<ChangeQuantityForSellingArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ChangeQuantityForSellingArguments>(args);
        }
        final typedArgs = args as ChangeQuantityForSellingArguments;
        return MaterialPageRoute<dynamic>(
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
        return MaterialPageRoute<dynamic>(
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
        return MaterialPageRoute<dynamic>(
          builder: (_) => AllItemScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.viewItemsScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ViewItemsScreen(key: typedArgs),
          settings: settings,
        );
      case Router.login:
        return MaterialPageRoute<dynamic>(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case Router.viewSingleItem:
        if (hasInvalidArgs<ViewSingleItemScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<ViewSingleItemScreenArguments>(args);
        }
        final typedArgs = args as ViewSingleItemScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ViewSingleItemScreen(
              key: typedArgs.key,
              itemId: typedArgs.itemId,
              itemName: typedArgs.itemName,
              itemColor: typedArgs.itemColor),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editVariationScreen:
        if (hasInvalidArgs<EditVariationScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<EditVariationScreenArguments>(args);
        }
        final typedArgs = args as EditVariationScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditVariationScreen(
              key: typedArgs.key,
              variationId: typedArgs.variationId,
              itemId: typedArgs.itemId,
              unitId: typedArgs.unitId),
          settings: settings,
        );
      case Router.editCategoryScreen:
        if (hasInvalidArgs<EditCategoryScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<EditCategoryScreenArguments>(args);
        }
        final typedArgs = args as EditCategoryScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              EditCategoryScreen(key: typedArgs.key, ItemId: typedArgs.ItemId),
          settings: settings,
        );
      case Router.editUnitType:
        if (hasInvalidArgs<EditUnitTypeScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<EditUnitTypeScreenArguments>(args);
        }
        final typedArgs = args as EditUnitTypeScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              EditUnitTypeScreen(key: typedArgs.key, itemId: typedArgs.itemId),
          settings: settings,
        );
      case Router.transactionScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => TransactionScreen(key: typedArgs),
          settings: settings,
        );
      case Router.webView:
        if (hasInvalidArgs<AuthWebViewArguments>(args)) {
          return misTypedArgsRoute<AuthWebViewArguments>(args);
        }
        final typedArgs =
            args as AuthWebViewArguments ?? AuthWebViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuthWebView(
              key: typedArgs.key,
              url: typedArgs.url,
              authType: typedArgs.authType),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//SignUpScreen arguments holder class
class SignUpScreenArguments {
  final Key key;
  final String token;
  final String email;
  final String name;
  final String avatar;
  SignUpScreenArguments(
      {this.key, this.token, this.email, this.name, this.avatar});
}

//AddVariationScreen arguments holder class
class AddVariationScreenArguments {
  final Key key;
  final double regularRetailPrice;
  final double regularCostPrice;
  AddVariationScreenArguments(
      {this.key,
      @required this.regularRetailPrice,
      @required this.regularCostPrice});
}

//AddUnitTypeScreen arguments holder class
class AddUnitTypeScreenArguments {
  final Key key;
  final int itemId;
  AddUnitTypeScreenArguments({this.key, this.itemId});
}

//ReceiveStockScreen arguments holder class
class ReceiveStockScreenArguments {
  final Key key;
  final int variationId;
  ReceiveStockScreenArguments({this.key, @required this.variationId});
}

//ChangeQuantityForSelling arguments holder class
class ChangeQuantityForSellingArguments {
  final Key key;
  final int itemId;
  ChangeQuantityForSellingArguments({this.key, @required this.itemId});
}

//CartDetailsScreen arguments holder class
class CartDetailsScreenArguments {
  final Key key;
  final List<Cart> carts;
  CartDetailsScreenArguments({this.key, this.carts});
}

//ViewSingleItemScreen arguments holder class
class ViewSingleItemScreenArguments {
  final Key key;
  final int itemId;
  final String itemName;
  final String itemColor;
  ViewSingleItemScreenArguments(
      {this.key,
      @required this.itemId,
      @required this.itemName,
      @required this.itemColor});
}

//EditVariationScreen arguments holder class
class EditVariationScreenArguments {
  final Key key;
  final int variationId;
  final int itemId;
  final int unitId;
  EditVariationScreenArguments(
      {this.key,
      @required this.variationId,
      @required this.itemId,
      this.unitId});
}

//EditCategoryScreen arguments holder class
class EditCategoryScreenArguments {
  final Key key;
  final int ItemId;
  EditCategoryScreenArguments({this.key, @required this.ItemId});
}

//EditUnitTypeScreen arguments holder class
class EditUnitTypeScreenArguments {
  final Key key;
  final int itemId;
  EditUnitTypeScreenArguments({this.key, @required this.itemId});
}

//AuthWebView arguments holder class
class AuthWebViewArguments {
  final Key key;
  final String url;
  final String authType;
  AuthWebViewArguments({this.key, this.url, this.authType});
}
