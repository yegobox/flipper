import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_dashboard/business_home_view.dart';
import 'package:flipper_dashboard/order_summary.dart';
import 'package:flipper_dashboard/collect_cash.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: DashboardView, name: 'dashboard'),
    MaterialRoute(page: SignUpFormView, name: 'signup'),
    MaterialRoute(page: BusinessHomeView, name: 'home'),
    MaterialRoute(page: LoginView, name: 'login'),
    MaterialRoute(page: AddProductView, name: 'product'),
    MaterialRoute(page: ListCategories, name: 'categories'),
    MaterialRoute(page: ColorTile, name: 'colors'),
    MaterialRoute(page: ReceiveStock, name: 'stock'),
    MaterialRoute(page: AddCategory, name: 'category'),
    MaterialRoute(page: AddVariation, name: 'variation'),
    MaterialRoute(page: ListUnits, name: 'units'),
    MaterialRoute(page: OrderSummary, name: 'summary'),
    MaterialRoute(page: Sell, name: 'sell'),
    MaterialRoute(page: Payments, name: 'pay'),
    MaterialRoute(page: CollectCashView, name: 'collect'),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}

// // ./flutterw packages pub run build_runner build --delete-conflicting-outputs
// // flutter packages pub run build_runner build --delete-conflicting-outputs
// //  firebase deploy --only hosting
// // flutter build web
// NOTE:TODO: when rebuilding login_popup_view remember to add library flipper_login; in generated file
// firebase install https://firebase.flutter.dev/docs/installation/android/
// flutter create --template=package hello
// flutter run -d chrome --release
//  flutter pub add moor_flutter
// flutter pub run msix:create
//cheat code
//TODO: push notification service https://github.com/Pronto-AG/Pronto-MIA-App/blob/master/pronto_mia/lib/core/services/push_notification_service.dart
// find . -name '*.dart' | xargs wc -l
//  16693  +633  +1388 = 18714