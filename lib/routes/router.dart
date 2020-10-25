import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flipper/ui/order/order_details_view.dart';
import 'package:flipper/ui/product/add/add_category_screen.dart';
import 'package:flipper/ui/product/add/add_product_screen.dart';
import 'package:flipper/ui/product/edit/edit_product_title.dart';
import 'package:flipper/ui/product/products_view.dart';
import 'package:flipper/ui/product/single_product_view.dart';
import 'package:flipper/ui/product/view_products_screen.dart';
import 'package:flipper/ui/variation/edit_variation_screen.dart';
import 'package:flipper/ui/welcome/business/create_business_screen.dart';
import 'package:flipper/ui/welcome/business/sign_up_screen.dart';
import 'package:flipper/ui/welcome/home/dash_board.dart';
import 'package:flipper/ui/welcome/login/login_screen.dart';
import 'package:flipper/ui/welcome/selling/complete_sale_screen.dart';
import 'package:flipper/ui/welcome/selling/tender_screen.dart';
import 'package:flipper/ui/welcome/splash/aftersplash.dart';
import 'package:flipper/ui/welcome/splash/splash_screen.dart';

import 'package:flipper/ui/widget/note/add_note_screen.dart';

import 'package:flipper/ui/widget/unit/add_unit_type.dart';
import 'package:flipper/ui/widget/variation/add_variation_screen.dart';
import 'package:flipper/ui/camera/camera_preview.dart';

import 'package:flipper/ui/category/create_category_input_screen.dart';


import 'package:flipper/ui/open_close_drawerview.dart';

import 'package:flipper/ui/widget/stock/receive_stock.dart';
import 'package:flipper/ui/reports/date_screen.dart';
import 'package:flipper/ui/reports/report_screen.dart';
import 'package:flipper/ui/selling/change_quantity_selling.dart';
import 'package:flipper/ui/setting_up_application_screen.dart';
import 'package:flipper/ui/transactions/transaction_screen.dart';
import 'package:flipper/ui/widget/unit/edit_unit_screen.dart';
import 'package:flipper/ui/widget/category/edit_category_screen.dart';

import 'package:flipper_login/otp.dart';
import 'package:flipper/ui/contacts/contact_view.dart';

@MaterialAutoRouter()
class $Routing {
  @initial
  SplashScreen splashScreen;
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

  @MaterialRoute(fullscreenDialog: true)
  SettingUpApplicationScreen settingUpApplicationScreen;

  @CustomRoute(
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 200)
  @MaterialRoute(fullscreenDialog: true)
  SignUpScreen signUpScreen;

  @MaterialRoute(fullscreenDialog: true)
  CreateBusinessScreen createBusiness;

  @MaterialRoute(fullscreenDialog: true)
  AddProductScreen addProduct;

  @MaterialRoute(fullscreenDialog: true)
  EditItemTitle editItemTitle;

  @MaterialRoute(fullscreenDialog: true)
  AddVariationScreen addVariationScreen;

  @MaterialRoute(fullscreenDialog: true)
  AddUnitTypeScreen addUnitType;

  @MaterialRoute(fullscreenDialog: true)
  AddCategoryScreen addCategoryScreen;

  @MaterialRoute(fullscreenDialog: true)
  CreateCategoryInputScreen createCategoryInputScreen;

  // @MaterialRoute(fullscreenDialog: true)
  ReceiveStockScreen receiveStock;

  @MaterialRoute(fullscreenDialog: true)
  ChangeQuantityForSelling editQuantityItemScreen;

  @MaterialRoute(fullscreenDialog: true)
  OrderDetailsView orderDetailsView;

  @MaterialRoute(fullscreenDialog: true)
  AllItemScreen allItemScreen;

  ViewProductsScreen viewItemsScreen;
  LoginScreen login;

  @MaterialRoute(fullscreenDialog: true)
  ViewSingleItemScreen viewSingleItem;


  EditVariationScreen editVariationScreen;

  EditCategoryScreen editCategoryScreen;

  EditUnitTypeScreen editUnitType;

  TransactionScreen transactionScreen;

  @MaterialRoute(fullscreenDialog: true)
  ReportScreen reportScreen;

  @MaterialRoute(fullscreenDialog: true)
  DateScreen dateScreen;

  @MaterialRoute(fullscreenDialog: true)
  CompleteSaleScreen completeSaleScreen;

  @MaterialRoute(fullscreenDialog: true)
  TenderScreen tenderScreen;

  @MaterialRoute(fullscreenDialog: true)
  CameraPreview cameraPreview;

  @MaterialRoute(fullscreenDialog: true)
  OtpPage otpPage;

  @MaterialRoute(fullscreenDialog: true)
  @CustomRoute(
    transitionsBuilder: TransitionsBuilders.zoomIn,
    durationInMilliseconds: 200,
  )
  OpenCloseDrawerView openCloseDrawerview;

  ContactView contactView;
  
}

//  flutter packages pub run build_runner watch --delete-conflicting-outputs  --enable-experiment=non-nullable