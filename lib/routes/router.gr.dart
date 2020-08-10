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
import 'package:flipper/home/add_product_screen.dart';
import 'package:flipper/home/edit_item_title.dart';
import 'package:flipper/home/add_variation_screen.dart';
import 'package:flipper/home/add_unit_type.dart';
import 'package:flipper/home/add_category_screen.dart';
import 'package:flipper/home/category/create_category_input_screen.dart';
import 'package:flipper/home/receive_stock.dart';
import 'package:flipper/home/selling/change_quantity_selling.dart';
import 'package:flipper/home/cart/cart_details_screen.dart';
import 'package:flipper/model/cart.dart';
import 'package:flipper/home/products/all_item_screen.dart';
import 'package:flipper/home/products/view_products_screen.dart';
import 'package:flipper/presentation/login/login_screen.dart';
import 'package:flipper/home/products/view_single_item_screen.dart';
import 'package:flipper/home/products/edit_variation_screen.dart';
import 'package:flipper/home/widget/category/edit_category_screen.dart';
import 'package:flipper/home/unit/edit_unit_screen.dart';
import 'package:flipper/home/transactions/transaction_screen.dart';
import 'package:flipper/presentation/login/auth_webview.dart';
import 'package:flipper/home/reports/report_screen.dart';
import 'package:flipper/home/reports/date_screen.dart';
import 'package:flipper/presentation/selling/complete_sale_screen.dart';
import 'package:flipper/presentation/selling/tender_screen.dart';
import 'package:flipper/presentation/subscription.dart';
import 'package:flipper/home/camera/camera_preview.dart';

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
  static const reportScreen = '/report-screen';
  static const dateScreen = '/date-screen';
  static const completeSaleScreen = '/complete-sale-screen';
  static const tenderScreen = '/tender-screen';
  static const subscription = '/subscription';
  static const cameraPreview = '/camera-preview';
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
          builder: (_) => AddProductScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.editItemTitle:
        if (hasInvalidArgs<EditItemTitleArguments>(args)) {
          return misTypedArgsRoute<EditItemTitleArguments>(args);
        }
        final typedArgs =
            args as EditItemTitleArguments ?? EditItemTitleArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              EditItemTitle(key: typedArgs.key, productId: typedArgs.productId),
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
              retailPrice: typedArgs.retailPrice,
              supplyPrice: typedArgs.supplyPrice),
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
          builder: (_) => AddUnitTypeScreen(
              key: typedArgs.key, productId: typedArgs.productId),
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
              key: typedArgs.key, productId: typedArgs.productId),
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
          builder: (_) => ViewProductsScreen(key: typedArgs),
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
              productId: typedArgs.productId,
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
              productId: typedArgs.productId,
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
          builder: (_) => EditCategoryScreen(
              key: typedArgs.key, productId: typedArgs.productId),
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
      case Router.reportScreen:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ReportScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.dateScreen:
        if (hasInvalidArgs<DateScreenArguments>(args)) {
          return misTypedArgsRoute<DateScreenArguments>(args);
        }
        final typedArgs = args as DateScreenArguments ?? DateScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              DateScreen(key: typedArgs.key, title: typedArgs.title),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.completeSaleScreen:
        if (hasInvalidArgs<CompleteSaleScreenArguments>(args)) {
          return misTypedArgsRoute<CompleteSaleScreenArguments>(args);
        }
        final typedArgs = args as CompleteSaleScreenArguments ??
            CompleteSaleScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => CompleteSaleScreen(
              key: typedArgs.key, cashReceived: typedArgs.cashReceived),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.tenderScreen:
        if (hasInvalidArgs<TenderScreenArguments>(args)) {
          return misTypedArgsRoute<TenderScreenArguments>(args);
        }
        final typedArgs =
            args as TenderScreenArguments ?? TenderScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => TenderScreen(
              key: typedArgs.key, cashReceived: typedArgs.cashReceived),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.subscription:
        if (hasInvalidArgs<SubscriptionArguments>(args)) {
          return misTypedArgsRoute<SubscriptionArguments>(args);
        }
        final typedArgs =
            args as SubscriptionArguments ?? SubscriptionArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => Subscription(
              key: typedArgs.key,
              name: typedArgs.name,
              avatar: typedArgs.avatar,
              email: typedArgs.email,
              token: typedArgs.token,
              authType: typedArgs.authType),
          settings: settings,
        );
      case Router.cameraPreview:
        if (hasInvalidArgs<CameraPreviewArguments>(args)) {
          return misTypedArgsRoute<CameraPreviewArguments>(args);
        }
        final typedArgs =
            args as CameraPreviewArguments ?? CameraPreviewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              CameraPreview(key: typedArgs.key, image: typedArgs.image),
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

//EditItemTitle arguments holder class
class EditItemTitleArguments {
  final Key key;
  final String productId;
  EditItemTitleArguments({this.key, this.productId});
}

//AddVariationScreen arguments holder class
class AddVariationScreenArguments {
  final Key key;
  final double retailPrice;
  final double supplyPrice;
  AddVariationScreenArguments(
      {this.key, @required this.retailPrice, @required this.supplyPrice});
}

//AddUnitTypeScreen arguments holder class
class AddUnitTypeScreenArguments {
  final Key key;
  final String productId;
  AddUnitTypeScreenArguments({this.key, this.productId});
}

//ReceiveStockScreen arguments holder class
class ReceiveStockScreenArguments {
  final Key key;
  final String variationId;
  ReceiveStockScreenArguments({this.key, @required this.variationId});
}

//ChangeQuantityForSelling arguments holder class
class ChangeQuantityForSellingArguments {
  final Key key;
  final String productId;
  ChangeQuantityForSellingArguments({this.key, @required this.productId});
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
  final String productId;
  final String itemName;
  final String itemColor;
  ViewSingleItemScreenArguments(
      {this.key,
      @required this.productId,
      @required this.itemName,
      @required this.itemColor});
}

//EditVariationScreen arguments holder class
class EditVariationScreenArguments {
  final Key key;
  final String variationId;
  final String productId;
  final String unitId;
  EditVariationScreenArguments(
      {this.key,
      @required this.variationId,
      @required this.productId,
      this.unitId});
}

//EditCategoryScreen arguments holder class
class EditCategoryScreenArguments {
  final Key key;
  final String productId;
  EditCategoryScreenArguments({this.key, @required this.productId});
}

//EditUnitTypeScreen arguments holder class
class EditUnitTypeScreenArguments {
  final Key key;
  final String itemId;
  EditUnitTypeScreenArguments({this.key, @required this.itemId});
}

//AuthWebView arguments holder class
class AuthWebViewArguments {
  final Key key;
  final String url;
  final String authType;
  AuthWebViewArguments({this.key, this.url, this.authType});
}

//DateScreen arguments holder class
class DateScreenArguments {
  final Key key;
  final String title;
  DateScreenArguments({this.key, this.title});
}

//CompleteSaleScreen arguments holder class
class CompleteSaleScreenArguments {
  final Key key;
  final int cashReceived;
  CompleteSaleScreenArguments({this.key, this.cashReceived});
}

//TenderScreen arguments holder class
class TenderScreenArguments {
  final Key key;
  final int cashReceived;
  TenderScreenArguments({this.key, this.cashReceived});
}

//Subscription arguments holder class
class SubscriptionArguments {
  final Key key;
  final String name;
  final String avatar;
  final String email;
  final String token;
  final String authType;
  SubscriptionArguments(
      {this.key,
      this.name,
      this.avatar,
      this.email,
      this.token,
      this.authType});
}

//CameraPreview arguments holder class
class CameraPreviewArguments {
  final Key key;
  final dynamic image;
  CameraPreviewArguments({this.key, this.image});
}
