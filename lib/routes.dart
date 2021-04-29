import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_dashboard/business_home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'package:flipper_services/app_service.dart';
// import 'package:flipper_models/view_models/login_viewmodel.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: DashboardView),
    MaterialRoute(page: SignUpFormView),
    MaterialRoute(page: BusinessHomeView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: AddProductView),
    MaterialRoute(page: ListCategories),
    MaterialRoute(page: ColorTile),
    MaterialRoute(page: ReceiveStock),
    MaterialRoute(page: AddCategory),
    MaterialRoute(page: ListUnits),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    // LazySingleton(classType: AppService),
    // LazySingleton(classType: LoginViewModel)
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

