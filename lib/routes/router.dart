import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
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
import 'package:flipper/views/sale/payment_option_view.dart';
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
import 'package:flipper/views/welcome/home/dash_board.dart';
import 'package:flipper/views/welcome/signup/signup_view.dart';
import 'package:flipper/views/welcome/splash/aftersplash.dart';
import 'package:flipper/views/welcome/splash/splash_screen.dart';
import 'package:flipper/widget/calendar/calenderView.dart';
import 'package:flipper_chat/chat_view.dart';
import 'package:flipper_contacts/contact_view.dart';
import 'package:flipper_login/otp.dart';

@MaterialAutoRouter()
class $Routing {
  @CustomRoute(
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 200)
  @MaterialRoute(fullscreenDialog: true)
  SignUpView signUpView;

  @MaterialRoute(fullscreenDialog: true)
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.slideBottom,
    durationInMilliseconds: 200,
  )
  AddProductView addProduct;

  @MaterialRoute(fullscreenDialog: true)
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.zoomIn,
    durationInMilliseconds: 200,
  )
  OpenCloseDrawerView openCloseDrawerview;

  @MaterialRoute(fullscreenDialog: true)
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.zoomIn,
    durationInMilliseconds: 200,
  )
  SalesView salesView;

  CalendarView calendarView;
  DiscountView discountView;
  EditUnitView editUnitType;
  EditVariationScreen editVariationScreen;
  ListDiscountView listDiscountView;
  OnSellingView onSellingView;
  ProductListView productsListView;
  ProductView productView;
  ReceiveStockScreen receiveStock;

  @initial
  SplashScreen splashScreen;

  TransactionScreen transactionScreen;

  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.zoomIn,
    durationInMilliseconds: 200,
  )
  DashBoard dashboard;

  @MaterialRoute(fullscreenDialog: true)
  AfterSplash afterSplash;

  @MaterialRoute(fullscreenDialog: true)
  EditItemTitle editItemTitle;

  @MaterialRoute(fullscreenDialog: true)
  AddVariationScreen addVariationScreen;

  @MaterialRoute(fullscreenDialog: true)
  AddUnitTypeScreen addUnitType;

  @MaterialRoute(fullscreenDialog: true)
  AddCategoryView addCategoryScreen;

  @MaterialRoute(fullscreenDialog: true)
  CreateCategoryInputScreen createCategoryInputScreen;

  @MaterialRoute(fullscreenDialog: true)
  CameraPreview cameraPreview;

  @MaterialRoute(fullscreenDialog: true)
  OtpPage otpPage;

  @MaterialRoute(fullscreenDialog: true)
  SettingsView settingsView;

  ContactView contactView;

  ChatView chatView;

  PaymentOptionView completeSaleView;
  SwitchView switchView;
  CollectCashView collectCashView;
  AfterSaleView afterSaleView;
  AddCustomerView addCustomerView;
  CustomerListView customerListView;
  TicketsView ticketsView;
  NewTicket newTicket;

  OrderSummary orderSummaryView;

  AddNoteView addNoteView;
}

//flutter packages pub run build_runner watch --delete-conflicting-outputs  --enable-experiment=non-nullable
// ../../flutterw packages pub run build_runner build --delete-conflicting-outputs --enable-experiment=non-nullable
// NON null
// flutter packages pub run build_runner build --delete-conflicting-outputs

// code example
// orderDetail.data
//                   // ignore: always_specify_types
//                   .fold(0, (a, OrderDetailTableData b) => a + b.quantity);

// run multiple flutter release
// curl -sL https://raw.githubusercontent.com/passsy/flutter_wrapper/master/install.sh | bash -
// https://medium.com/@passsy/flutter-wrapper-bind-your-project-to-an-explicit-flutter-release-4062cfe6dcaf
// https://github.com/passsy/flutter_wrapper

// keytool -list -v  -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
// keytool -list -v  -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
// https://developers.google.com/android/guides/client-auth

// if you build route and there is error of import add this at the import
// import 'package:built_collection/built_collection.dart';
// import 'package:flipper_models/product.dart';
// c5b750b0
// https://pub.dev/packages/flutter_sms
//  'SELECT id,name,sku,productId,unit,table,channels WHERE table=\$VALUE AND name=\$NAME AND productId=\$PRODUCTID');
//https://pub.dev/packages/flutter_sms
// https://pub.dev/packages/miniplayer
// 84f3d28555 (flutter working version SDK keep this.)
//Known errors
//W/LiteCore [Query](18717): cbl_result_next: got error 4/2
