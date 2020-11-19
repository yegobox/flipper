import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flipper/views/category/category_list_view.dart';
import 'package:flipper/views/category/edit_category_view.dart';
import 'package:flipper/views/discounts/discount_list_view.dart';
import 'package:flipper/views/discounts/discount_view.dart';
import 'package:flipper/views/note/add_note_screen.dart';
import 'package:flipper/views/order/order_details_view.dart';
import 'package:flipper/views/product/add/add_category_view.dart';
import 'package:flipper/views/product/add/add_product_view.dart';
import 'package:flipper/views/product/edit/edit_product_title.dart';
import 'package:flipper/views/product/product_list_view.dart';
import 'package:flipper/views/product/product_view.dart';
import 'package:flipper/views/product/widget/product_description.dart';
import 'package:flipper/views/reports/build_sales_View.dart';
import 'package:flipper/views/stock/receive_stock.dart';
import 'package:flipper/views/unit/add_unit_view.dart';
import 'package:flipper/views/unit/edit_unit_view.dart';
import 'package:flipper/views/variation/add_variation_screen.dart';

import 'package:flipper/views/variation/edit_variation_screen.dart';

import 'package:flipper/views/welcome/signup/signup_view.dart';
import 'package:flipper/views/welcome/home/dash_board.dart';
import 'package:flipper/views/welcome/selling/complete_sale_screen.dart';
import 'package:flipper/views/welcome/selling/tender_screen.dart';

import 'package:flipper/views/welcome/splash/aftersplash.dart';
import 'package:flipper/views/welcome/splash/splash_screen.dart';

import 'package:flipper/views/camera/camera_preview.dart';

import 'package:flipper/views/category/create_category_input_screen.dart';

import 'package:flipper/views/open_close_drawerview.dart';


import 'package:flipper/views/selling/change_quantity_selling.dart';
import 'package:flipper/views/transactions/transaction_screen.dart';

import 'package:flipper/widget/calendar/calenderView.dart';

import 'package:flipper_login/otp.dart';
import 'package:flipper/views/contacts/contact_view.dart';

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
  ContactView contactView;
  DiscountView discountView;
  EditCategoryScreen editCategoryScreen;
  EditUnitView editUnitType;
  EditVariationScreen editVariationScreen;
  ListCategoryView listCategoryView;
  ListDiscountView listDiscountView;
  ProductDescription productDescription;
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
  AddNoteScreen addNoteScreen;

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
  ChangeQuantityForSelling editQuantityItemScreen;

  @MaterialRoute(fullscreenDialog: true)
  OrderDetailsView orderDetailsView;

  @MaterialRoute(fullscreenDialog: true)
  CompleteSaleScreen completeSaleScreen;

  @MaterialRoute(fullscreenDialog: true)
  TenderScreen tenderScreen;

  @MaterialRoute(fullscreenDialog: true)
  CameraPreview cameraPreview;

  @MaterialRoute(fullscreenDialog: true)
  OtpPage otpPage;
}

//flutter packages pub run build_runner watch --delete-conflicting-outputs  --enable-experiment=non-nullable
// flutter packages pub run build_runner build --delete-conflicting-outputs --enable-experiment=non-nullable
