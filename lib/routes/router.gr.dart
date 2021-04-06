// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:auto_route/auto_route.dart';
// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:built_collection/built_collection.dart';
// import 'pac'
import 'package:flipper/views/camera/camera_preview.dart';
import 'package:flipper/views/category/add_category_view.dart';
import 'package:flipper/views/category/create_category_input_screen.dart';
import 'package:flipper/views/customers/add_customer.dart';
import 'package:flipper/views/customers/customer_list_view.dart';
import 'package:flipper/views/discounts/discount_list_view.dart';
import 'package:flipper/views/discounts/discount_view.dart';
import 'package:flipper/views/open_close_drawerview.dart';
import 'package:flipper/views/product/add/add_product_view.dart';
import 'package:flipper/views/product/edit/edit_product_title.dart';
import 'package:flipper/views/product/product_list_view.dart';
import 'package:flipper/views/product/product_view.dart';
import 'package:flipper/views/product/widget/on_selling_view.dart';
import 'package:flipper/views/reports/build_sales_View.dart';
import 'package:flipper/views/sale/add_noteview.dart';
import 'package:flipper/views/sale/after_sale_view.dart';
import 'package:flipper/views/sale/collect_cash_view.dart';
import 'package:flipper/views/sale/order_summary_view.dart';
// import 'package:built_collection/src/list/built_list.dart';
import 'package:flipper/views/sale/payment_option_view.dart';
import 'package:flipper/views/selling/change_quantity_selling.dart';
import 'package:flipper/views/settings/settings_view.dart';
import 'package:flipper/views/stock/receive_stock.dart';
import 'package:flipper/views/switch/switch_view.dart';
import 'package:flipper/views/tickets/new_ticket.dart';
import 'package:flipper/views/tickets/tickets_view.dart';
import 'package:flipper/views/transactions/transaction_screen.dart';
import 'package:flipper/views/unit/add_unit_view.dart';
import 'package:flipper/views/unit/edit_unit_view.dart';
import 'package:flipper/views/variation/add_variation_screen.dart';
import 'package:flipper/views/variation/edit_variation_screen.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/views/welcome/home/dash_board.dart';
import 'package:flipper/views/welcome/signup/signup_view.dart';
import 'package:flipper/views/welcome/splash/aftersplash.dart';
import 'package:flipper/views/welcome/splash/splash_screen.dart';
import 'package:flipper/widget/calendar/calenderView.dart';
import 'package:flipper_chat/chat_view.dart';
import 'package:flipper_contacts/contact_view.dart';
import 'package:flipper_login/otp.dart';
import 'package:flipper_models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routing {
  static const signUpView = '/sign-up-view';
  static const addProduct = '/add-product';
  static const openCloseDrawerview = '/open-close-drawerview';
  static const salesView = '/sales-view';
  static const calendarView = '/calendar-view';
  static const discountView = '/discount-view';
  static const editCategoryScreen = '/edit-category-screen';
  static const editUnitType = '/edit-unit-type';
  static const editVariationScreen = '/edit-variation-screen';
  static const listCategoryView = '/list-category-view';
  static const listDiscountView = '/list-discount-view';
  static const onSellingView = '/on-selling-view';
  static const productsListView = '/products-list-view';
  static const productView = '/product-view';
  static const receiveStock = '/receive-stock';
  static const splashScreen = '/';
  static const transactionScreen = '/transaction-screen';
  static const dashboard = '/dashboard';
  static const afterSplash = '/after-splash';
  static const editItemTitle = '/edit-item-title';
  static const addVariationScreen = '/add-variation-screen';
  static const addUnitType = '/add-unit-type';
  static const addCategoryScreen = '/add-category-screen';
  static const createCategoryInputScreen = '/create-category-input-screen';
  static const editQuantityItemScreen = '/edit-quantity-item-screen';
  static const cameraPreview = '/camera-preview';
  static const otpPage = '/otp-page';
  static const settingsView = '/settings-view';
  static const contactView = '/contact-view';
  static const chatView = '/chat-view';
  static const completeSaleView = '/complete-sale-view';
  static const switchView = '/switch-view';
  static const collectCashView = '/collect-cash-view';
  static const afterSaleView = '/after-sale-view';
  static const addCustomerView = '/add-customer-view';
  static const customerListView = '/customer-list-view';
  static const ticketsView = '/tickets-view';
  static const newTicket = '/new-ticket';
  static const orderSummaryView = '/order-summary-view';
  static const addNoteView = '/add-note-view';
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
              businessState: typedArgs.businessState,
              wording: typedArgs.wording),
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
      case Routing.discountView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => DiscountView(key: typedArgs),
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

      case Routing.listDiscountView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => ListDiscountView(key: typedArgs),
          settings: settings,
        );
      case Routing.onSellingView:
        if (hasInvalidArgs<OnSellingViewArguments>(args)) {
          return misTypedArgsRoute<OnSellingViewArguments>(args);
        }
        final typedArgs =
            args as OnSellingViewArguments ?? OnSellingViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) =>
              OnSellingView(key: typedArgs.key, product: typedArgs.product),
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
          builder: (_) =>
              ReceiveStockScreen(key: typedArgs.key, id: typedArgs.id),
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
      case Routing.settingsView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => SettingsView(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routing.contactView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ContactView(),
          settings: settings,
        );
      case Routing.chatView:
        if (hasInvalidArgs<ChatViewArguments>(args)) {
          return misTypedArgsRoute<ChatViewArguments>(args);
        }
        final typedArgs = args as ChatViewArguments ?? ChatViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => ChatView(
              chatRoomId: typedArgs.chatRoomId, channels: typedArgs.channels),
          settings: settings,
        );
      case Routing.completeSaleView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => PaymentOptionView(),
          settings: settings,
        );
      case Routing.switchView:
        if (hasInvalidArgs<SwitchViewArguments>(args)) {
          return misTypedArgsRoute<SwitchViewArguments>(args);
        }
        final typedArgs = args as SwitchViewArguments ?? SwitchViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => SwitchView(
              key: typedArgs.key,
              vm: typedArgs.vm,
              sideOpenController: typedArgs.sideOpenController),
          settings: settings,
        );
      case Routing.collectCashView:
        if (hasInvalidArgs<CollectCashViewArguments>(args)) {
          return misTypedArgsRoute<CollectCashViewArguments>(args);
        }
        final typedArgs =
            args as CollectCashViewArguments ?? CollectCashViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => CollectCashView(
              key: typedArgs.key, paymentType: typedArgs.paymentType),
          settings: settings,
        );
      case Routing.afterSaleView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AfterSaleView(key: typedArgs),
          settings: settings,
        );
      case Routing.addCustomerView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddCustomerView(key: typedArgs),
          settings: settings,
        );
      case Routing.customerListView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => CustomerListView(key: typedArgs),
          settings: settings,
        );
      case Routing.ticketsView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => TicketsView(key: typedArgs),
          settings: settings,
        );
      case Routing.newTicket:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => NewTicket(key: typedArgs),
          settings: settings,
        );
      case Routing.orderSummaryView:
        return MaterialPageRoute<dynamic>(
          builder: (_) => OrderSummary(),
          settings: settings,
        );
      case Routing.addNoteView:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute<dynamic>(
          builder: (_) => AddNoteView(key: typedArgs),
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
  final BusinessState businessState;
  final String wording;
  OpenCloseDrawerViewArguments(
      {this.key,
      this.businessState = BusinessState.OPEN,
      this.wording = 'Opening Float'});
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

//OnSellingView arguments holder class
class OnSellingViewArguments {
  final Key key;
  final Product product;
  OnSellingViewArguments({this.key, this.product});
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
  final String id;
  ReceiveStockScreenArguments({this.key, @required this.id});
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

//CameraPreview arguments holder class
class CameraPreviewArguments {
  final Key key;
  final dynamic image;
  CameraPreviewArguments({this.key, this.image});
}

//ChatView arguments holder class
class ChatViewArguments {
  final String chatRoomId;
  final BuiltList<dynamic> channels;
  ChatViewArguments({this.chatRoomId, this.channels});
}

//SwitchView arguments holder class
class SwitchViewArguments {
  final Key key;
  final CommonViewModel vm;
  final ValueNotifier<bool> sideOpenController;
  SwitchViewArguments({this.key, this.vm, this.sideOpenController});
}

//CollectCashView arguments holder class
class CollectCashViewArguments {
  final Key key;
  final String paymentType;
  CollectCashViewArguments({this.key, this.paymentType});
}
