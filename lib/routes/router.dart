import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:flipper/home/add_category_screen.dart';
import 'package:flipper/home/add_note_screen.dart';
import 'package:flipper/home/add_product_screen.dart';
import 'package:flipper/home/add_unit_type.dart';
import 'package:flipper/home/add_variation_screen.dart';
import 'package:flipper/home/camera/camera_preview.dart';
import 'package:flipper/home/cart/cart_details_screen.dart';
import 'package:flipper/home/category/create_category_input_screen.dart';
import 'package:flipper/home/edit_item_title.dart';
import 'package:flipper/home/products/all_item_screen.dart';
import 'package:flipper/home/products/edit_variation_screen.dart';
import 'package:flipper/home/products/view_products_screen.dart';
import 'package:flipper/home/products/view_single_item_screen.dart';
import 'package:flipper/home/receive_stock.dart';
import 'package:flipper/home/reports/date_screen.dart';
import 'package:flipper/home/reports/report_screen.dart';
import 'package:flipper/home/selling/change_quantity_selling.dart';
import 'package:flipper/home/setting_up_application_screen.dart';

import 'package:flipper/home/transactions/transaction_screen.dart';
import 'package:flipper/home/unit/edit_unit_screen.dart';
import 'package:flipper/home/widget/category/edit_category_screen.dart';
import 'package:flipper/presentation/business/create_business_screen.dart';
import 'package:flipper/presentation/business/sign_up_screen.dart';
import 'package:flipper/presentation/home/dash_board.dart';
// import 'package:flipper/presentation/login/auth_webview.dart';
import 'package:flipper/presentation/login/login_screen.dart';
import 'package:flipper/presentation/selling/complete_sale_screen.dart';
import 'package:flipper/presentation/selling/tender_screen.dart';
import 'package:flipper/presentation/splash/aftersplash.dart';
import 'package:flipper/presentation/splash/splash_screen.dart';
import 'package:flipper/presentation/subscription.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SplashScreen splashScreen;
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
  AddProductScreen addItemScreen;

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
  CartDetailsScreen cartDetailsScreen;

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

  // @MaterialRoute(fullscreenDialog: true)
  // AuthWebView webView;

  @MaterialRoute(fullscreenDialog: true)
  ReportScreen reportScreen;

  @MaterialRoute(fullscreenDialog: true)
  DateScreen dateScreen;

  @MaterialRoute(fullscreenDialog: true)
  CompleteSaleScreen compleSaleScreen;

  @MaterialRoute(fullscreenDialog: true)
  TenderScreen tenderScreen;

  Subscription subscription;

  @MaterialRoute(fullscreenDialog: true)
  CameraPreview cameraPreview;
}
