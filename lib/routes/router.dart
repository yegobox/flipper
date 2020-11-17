import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flipper/ui/order/order_details_view.dart';
import 'package:flipper/ui/product/add/add_category_view.dart';
import 'package:flipper/ui/product/add/add_product_view.dart';
import 'package:flipper/ui/product/edit/edit_product_title.dart';
import 'package:flipper/ui/product/widget/product_description.dart';

import 'package:flipper/ui/variation/edit_variation_screen.dart';

import 'package:flipper/ui/welcome/signup/signup_view.dart';
import 'package:flipper/ui/welcome/home/dash_board.dart';
import 'package:flipper/ui/welcome/selling/complete_sale_screen.dart';
import 'package:flipper/ui/welcome/selling/tender_screen.dart';

import 'package:flipper/ui/welcome/splash/aftersplash.dart';
import 'package:flipper/ui/welcome/splash/splash_screen.dart';

import 'package:flipper/ui/widget/note/add_note_screen.dart';
import 'package:flipper/ui/widget/products_edits/product_list_view.dart';
import 'package:flipper/ui/widget/products_edits/product_view.dart';

import 'package:flipper/ui/widget/unit/add_unit_view.dart';
import 'package:flipper/ui/widget/variation/add_variation_screen.dart';
import 'package:flipper/ui/camera/camera_preview.dart';

import 'package:flipper/ui/category/create_category_input_screen.dart';

import 'package:flipper/ui/open_close_drawerview.dart';

import 'package:flipper/ui/widget/stock/receive_stock.dart';

import 'package:flipper/ui/selling/change_quantity_selling.dart';
import 'package:flipper/ui/transactions/transaction_screen.dart';
import 'package:flipper/ui/widget/unit/edit_unit_view.dart';
import 'package:flipper/ui/widget/category/edit_category_view.dart';

import 'package:flipper_login/otp.dart';
import 'package:flipper/ui/contacts/contact_view.dart';
import 'package:flipper/ui/widget/report/build_sales_View.dart';
import 'package:flipper/ui/widget/calendar/calenderView.dart';
import 'package:flipper/ui/widget/discounts/discount_view.dart';

import 'package:flipper/ui/widget/category/category_list_view.dart';
import 'package:flipper/ui/widget/discounts/discount_list_view.dart';

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
 
  DiscountView discountView;

  CalendarView calendarView;
  ContactView contactView;
  EditCategoryScreen editCategoryScreen;
  EditUnitView editUnitType;
  EditVariationScreen editVariationScreen;
  ProductListView productsListView;
  ListCategoryView listCategoryView;
  ListDiscountView listDiscountView;
  ProductDescription productDescription;
  SalesView salesView;
  ProductView productView;
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

  // @MaterialRoute(fullscreenDialog: true)
  // SaleScreen saleScreen;

  // @MaterialRoute(fullscreenDialog: true)
  // SettingUpApplicationScreen settingUpApplicationScreen;

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

  // @MaterialRoute(fullscreenDialog: true)
  ReceiveStockScreen receiveStock;

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
