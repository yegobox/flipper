library flipper_routing;

import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/after_sale.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/list_categories.dart';

import 'package:flipper_dashboard/flipper_dashboard.dart';
import 'package:flipper_dashboard/add_discount.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/setting_secreen.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_login/login_view.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_dashboard/business_home_view.dart';
import 'package:flipper_dashboard/customers.dart';
import 'package:flipper_dashboard/order_summary.dart';
import 'package:flipper_dashboard/collect_cash.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:flipper_dashboard/connection_failed_view.dart';
import 'package:flipper_dashboard/analytic.dart';
import 'package:flipper_dashboard/scanner_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// import 'package:flipper_chat/flipper_chat_app.dart';
import 'package:flipper_chat/lite/pages/lite.dart';
import 'package:flipper_chat/lite/pages/contact_page.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true, name: 'initial'),
    // MaterialRoute(page: StartUpView),
    // MaterialRoute(page: FlipperChatApp, name: 'chat'),
    MaterialRoute(page: Lite, name: 'chat'),
    MaterialRoute(page: ContactPage, name: 'contacts'),
    // MaterialRoute(page: FlipperChatApp, initial: true),
    MaterialRoute(page: DashboardView, name: 'dashboard'),

    MaterialRoute(page: SignUpFormView, name: 'signup'),
    MaterialRoute(page: Home, name: 'home'),
    MaterialRoute(page: Login, name: 'login'),
    MaterialRoute(page: AddProductView, name: 'product'),
    MaterialRoute(page: AddDiscount, name: 'discount'),
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
    MaterialRoute(page: AfterSale, name: 'afterSale'),
    MaterialRoute(page: SettingsScreen, name: 'settings'),
    MaterialRoute(page: Analytics, name: 'analytics'),
    MaterialRoute(page: ScannView, name: 'qrview'),
    MaterialRoute(page: ConnectionFailedView, name: 'connectionState'),

    // chat routes

    // customer
    MaterialRoute(page: Customers, name: 'customers'),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}

// ./flutterw packages pub run build_runner build --delete-conflicting-outputs
// flutter packages pub run build_runner build --delete-conflicting-outputs
//  firebase deploy --only hosting
//  firebase deploy --only functions
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
//  30243  +1625 = 31868
// sudo a2enmod proxy_wstunnel (enabling apache sockets)
// bb-operations-sql.database.windows.net
// 1433
// https://github.com/metrogistics/laravel-azure-ad-oauth

//TODO: The nex things in consumer app!
// https://github.com/JoshuaR503/Stock-Market-App
// https://www.youtube.com/watch?v=IbJt7tr8kL0
// https://developers.amadeus.com/self-service/category/air/api-doc/flight-offers-search/api-reference 
// https://github.com/amadeus4dev/amadeus-java
// TODO: Qr code.!
// https://www.youtube.com/watch?v=hHehIGfX_yU

// TODO:changed data type of id from string to int, if go back to couchbase need to change that too where I am using uid;
//carefully look for where the ID is used while building object eg unit and turn back to Int when accessing data as when saved it was changed to int on couchbaseside.
// https://dev.to/ashishrawat2911/handling-network-calls-and-exceptions-in-flutter-54me
// https://docs.microsoft.com/en-us/windows/msix/package/signing-package-device-guard-signing
// https://github.com/marketplace/actions/windows-store-publish

// cameras to buy
// 1) go pro 9 black
// 2) https://snapmounts.com/

// share one tab of google sheets
// https://www.youtube.com/watch?v=Sj_uGLZqBmc

// dataModels update
// https://docs.objectbox.io/advanced/data-model-updates
// A/B Testing.
// https://firebase.google.com/docs/ab-testing/abtest-config#java

// on DeleteOfOrderItem call another func to update tickets this can be refreshing tickets..
// version.(1)
// TODO: implement geofancing of businesses and customers 
// https://pub.dev/packages/geofence_service (if I am near a shop in 100 metters to receive advert of business willing to offer me deal)
// a user will set the price he is willing to pay and item then he get adverts related to the settings.


// masterting analytics
// https://medium.com/flutterdevs/firebase-analytics-2044e865efc4

// test pin:085214


// when adding new repo with other submodules
// git submodule add https://github.com/yegobox/flutter_landing_page.git open-sources/landing
// https://gist.github.com/myusuf3/7f645819ded92bda6677

// %AppData%
// This will not restart the server.!
// docker-compose up -d --no-deps --build app-server  

// TODO:when want to calculate distance between points
// https://flutteragency.com/total-distance-from-latlng-list-in-flutter/
// git add . && git stash && git pull origin main && gradle build && docker-compose up --build -d

// TODO: use repeat ionicons in chat's fload button.

// debug key: when debugging
// https://stackoverflow.com/questions/12456491/i-dont-remember-my-android-debug-keystore-password
// keytool -list -v -keystore ~/.android/debug.keystore

//when prod: when prod
// keytool -list -v -keystore

// ongoing: twitter bot experiment.
// https://www.socialseer.com/twitter-programming-in-java-with-twitter4j/authentication-with-twitter/pin-based-authentication-in-java-with-twitter4j/

//TODO: before using this:check if it works for browser too
// https://pub.dev/packages/nb_utils
// TODO: when making 5M per month, will switch to fluent UI as core UI of flipper
// https://pub.dev/packages/fluent_ui

//  List<FileSystemEntity> es =
// Directory(dir.path + '/db_1/data.mdb').listSync();
// for (FileSystemEntity e in es) {
// print(e.absolute);
// }