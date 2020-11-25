// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flipper/views/welcome/signup/signup_view.dart';
import 'package:flipper/views/product/add/add_product_view.dart';
import 'package:flipper/views/open_close_drawerview.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/views/reports/build_sales_View.dart';
import 'package:flipper/widget/calendar/calenderView.dart';
import 'package:flipper/views/contacts/contact_view.dart';
import 'package:flipper/views/discounts/discount_view.dart';
import 'package:flipper/views/category/edit_category_view.dart';
import 'package:flipper/views/unit/edit_unit_view.dart';
import 'package:flipper/views/variation/edit_variation_screen.dart';
import 'package:flipper/views/category/category_list_view.dart';
import 'package:flipper/views/discounts/discount_list_view.dart';
import 'package:flipper/views/product/widget/product_description.dart';
import 'package:flipper/views/product/product_list_view.dart';
import 'package:flipper/views/product/product_view.dart';
import 'package:flipper/views/stock/receive_stock.dart';
import 'package:flipper/views/product/stock/stock_view.dart';
import 'package:flipper/views/product/stock/stock_input.dart';
import 'package:flipper/views/welcome/splash/splash_screen.dart';
import 'package:flipper/views/transactions/transaction_screen.dart';
import 'package:flipper/views/welcome/home/dash_board.dart';
import 'package:flipper/views/welcome/splash/aftersplash.dart';
import 'package:flipper/views/note/add_note_screen.dart';
import 'package:flipper/views/product/edit/edit_product_title.dart';
import 'package:flipper/views/variation/add_variation_screen.dart';
import 'package:flipper/views/unit/add_unit_view.dart';
import 'package:flipper/views/product/add/add_category_view.dart';
import 'package:flipper/views/category/create_category_input_screen.dart';
import 'package:flipper/views/selling/change_quantity_selling.dart';
import 'package:flipper/views/order/order_details_view.dart';
import 'package:flipper/model/order.dart';
import 'package:flipper/views/welcome/selling/complete_sale_screen.dart';
import 'package:flipper/views/welcome/selling/tender_screen.dart';
import 'package:flipper/views/camera/camera_preview.dart';
import 'package:flipper_login/otp.dart';

class Routing {
  static const signUpView = '/sign-up-view';
  static const addProduct = '/add-product';
  static const openCloseDrawerview = '/open-close-drawerview';
  static const salesView = '/sales-view';
  static const calendarView = '/calendar-view';
  static const contactView = '/contact-view';
  static const discountView = '/discount-view';
  static const editCategoryScreen = '/edit-category-screen';
  static const editUnitType = '/edit-unit-type';
  static const editVariationScreen = '/edit-variation-screen';
  static const listCategoryView = '/list-category-view';
  static const listDiscountView = '/list-discount-view';
  static const productDescription = '/product-description';
  static const productsListView = '/products-list-view';
  static const productView = '/product-view';
  static const receiveStock = '/receive-stock';
  static const stockView = '/stock-view';
  static const addStockView = '/add-stock-view';
  static const splashScreen = '/';
  static const transactionScreen = '/transaction-screen';
  static const dashboard = '/dashboard';
  static const afterSplash = '/after-splash';
  static const addNoteScreen = '/add-note-screen';
  static const editItemTitle = '/edit-item-title';
  static const addVariationScreen = '/add-variation-screen';
  static const addUnitType = '/add-unit-type';
  static const addCategoryScreen = '/add-category-screen';
  static const createCategoryInputScreen = '/create-category-input-screen';
  static const editQuantityItemScreen = '/edit-quantity-item-screen';
  static const orderDetailsView = '/order-details-view';
  static const completeSaleScreen = '/complete-sale-screen';
  static const tenderScreen = '/tender-screen';
  static const cameraPreview = '/camera-preview';
  static const otpPage = '/otp-page';
  static final navigator = ExtendedNavigator();
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routing.signUpView:
        if (hasInvalidArgs<SignUpViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<SignUpViewArguments>(args);
        }
        final typedArgs = args as SignUpViewArguments;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) => SignUpView(
              key: typedArgs.key,
              token: typedArgs.token,
              email: typedArgs.email,
              name: typedArgs.name,
              avatar: typedArgs.avatar,
              userId: typedArgs.userId),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.slideLeft,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Routing.addProduct:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddProductView(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.openCloseDrawerview:
        if (hasInvalidArgs<OpenCloseDrawerViewArguments>(args)) {
          return misTypedArgsRoute<OpenCloseDrawerViewArguments>(args);
        }
        final typedArgs = args as OpenCloseDrawerViewArguments ??
            OpenCloseDrawerViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => OpenCloseDrawerView(
              key: typedArgs.key,
              vm: typedArgs.vm,
              businessState: typedArgs.businessState),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.salesView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SalesView(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.calendarView:
        if (hasInvalidArgs<CalendarViewArguments>(args)) {
          return misTypedArgsRoute<CalendarViewArguments>(args);
        }
        final typedArgs =
            args as CalendarViewArguments ?? CalendarViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              CalendarView(key: typedArgs.key, title: typedArgs.title),
          settings: settings,
        );
      case Routing.contactView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ContactView(),
          settings: settings,
        );
      case Routing.discountView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => DiscountView(key: typedArgs),
          settings: settings,
        );
      case Routing.editCategoryScreen:
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
      case Routing.editUnitType:
        if (hasInvalidArgs<EditUnitViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<EditUnitViewArguments>(args);
        }
        final typedArgs = args as EditUnitViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              EditUnitView(key: typedArgs.key, itemId: typedArgs.itemId),
          settings: settings,
        );
      case Routing.editVariationScreen:
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
      case Routing.listCategoryView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ListCategoryView(key: typedArgs),
          settings: settings,
        );
      case Routing.listDiscountView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ListDiscountView(key: typedArgs),
          settings: settings,
        );
      case Routing.productDescription:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ProductDescription(key: typedArgs),
          settings: settings,
        );
      case Routing.productsListView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ProductListView(key: typedArgs),
          settings: settings,
        );
      case Routing.productView:
        if (hasInvalidArgs<ProductViewArguments>(args)) {
          return misTypedArgsRoute<ProductViewArguments>(args);
        }
        final typedArgs =
            args as ProductViewArguments ?? ProductViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => ProductView(
              key: typedArgs.key,
              userId: typedArgs.userId,
              items: typedArgs.items,
              sellingModeView: typedArgs.sellingModeView),
          settings: settings,
        );
      case Routing.receiveStock:
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
      case Routing.stockView:
        if (hasInvalidArgs<StockViewArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<StockViewArguments>(args);
        }
        final typedArgs = args as StockViewArguments;
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              StockView(key: typedArgs.key, productId: typedArgs.productId),
          settings: settings,
        );
      case Routing.addStockView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddStockView(key: typedArgs),
          settings: settings,
        );
      case Routing.splashScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SplashScreen(key: typedArgs),
          settings: settings,
        );
      case Routing.transactionScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => TransactionScreen(key: typedArgs),
          settings: settings,
        );
      case Routing.dashboard:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder<dynamic>(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              DashBoard(key: typedArgs),
          settings: settings,
          transitionsBuilder: TransitionsBuilders.zoomIn,
          transitionDuration: Duration(milliseconds: 200),
        );
      case Routing.afterSplash:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AfterSplash(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.addNoteScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddNoteScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.editItemTitle:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditItemTitle(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.addVariationScreen:
        if (hasInvalidArgs<AddVariationScreenArguments>(args)) {
          return misTypedArgsRoute<AddVariationScreenArguments>(args);
        }
        final typedArgs = args as AddVariationScreenArguments ??
            AddVariationScreenArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddVariationScreen(
              key: typedArgs.key, productId: typedArgs.productId),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.addUnitType:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddUnitTypeScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.addCategoryScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddCategoryView(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.createCategoryInputScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => CreateCategoryInputScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.editQuantityItemScreen:
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
      case Routing.orderDetailsView:
        if (hasInvalidArgs<OrderDetailsViewArguments>(args)) {
          return misTypedArgsRoute<OrderDetailsViewArguments>(args);
        }
        final typedArgs =
            args as OrderDetailsViewArguments ?? OrderDetailsViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              OrderDetailsView(key: typedArgs.key, orders: typedArgs.orders),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.completeSaleScreen:
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
      case Routing.tenderScreen:
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
      case Routing.cameraPreview:
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
      case Routing.otpPage:
        if (hasInvalidArgs<String>(args)) {
          return misTypedArgsRoute<String>(args);
        }
        final typedArgs = args as String;
        return MaterialPageRoute<dynamic>(
          builder: (_) => OtpPage(phone: typedArgs),
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

//SignUpView arguments holder class
class SignUpViewArguments {
  final Key key;
  final String token;
  final String email;
  final String name;
  final String avatar;
  final String userId;
  SignUpViewArguments(
      {this.key,
      this.token,
      this.email,
      this.name,
      this.avatar,
      @required this.userId});
}

//OpenCloseDrawerView arguments holder class
class OpenCloseDrawerViewArguments {
  final Key key;
  final CommonViewModel vm;
  final BusinessState businessState;
  OpenCloseDrawerViewArguments(
      {this.key, this.vm, this.businessState = BusinessState.OPEN});
}

//CalendarView arguments holder class
class CalendarViewArguments {
  final Key key;
  final String title;
  CalendarViewArguments({this.key, this.title});
}

//EditCategoryScreen arguments holder class
class EditCategoryScreenArguments {
  final Key key;
  final String productId;
  EditCategoryScreenArguments({this.key, @required this.productId});
}

//EditUnitView arguments holder class
class EditUnitViewArguments {
  final Key key;
  final String itemId;
  EditUnitViewArguments({this.key, @required this.itemId});
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

//ProductView arguments holder class
class ProductViewArguments {
  final Key key;
  final String userId;
  final bool items;
  final bool sellingModeView;
  ProductViewArguments(
      {this.key, this.userId, this.items, this.sellingModeView = false});
}

//ReceiveStockScreen arguments holder class
class ReceiveStockScreenArguments {
  final Key key;
  final String variationId;
  ReceiveStockScreenArguments({this.key, @required this.variationId});
}

//StockView arguments holder class
class StockViewArguments {
  final Key key;
  final String productId;
  StockViewArguments({this.key, @required this.productId});
}

//AddVariationScreen arguments holder class
class AddVariationScreenArguments {
  final Key key;
  final String productId;
  AddVariationScreenArguments({this.key, this.productId});
}

//ChangeQuantityForSelling arguments holder class
class ChangeQuantityForSellingArguments {
  final Key key;
  final String productId;
  ChangeQuantityForSellingArguments({this.key, @required this.productId});
}

//OrderDetailsView arguments holder class
class OrderDetailsViewArguments {
  final Key key;
  final List<Order> orders;
  OrderDetailsViewArguments({this.key, this.orders});
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

//CameraPreview arguments holder class
class CameraPreviewArguments {
  final Key key;
  final dynamic image;
  CameraPreviewArguments({this.key, this.image});
}
