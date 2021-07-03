import 'package:chat/screens/add_conversation.dart';
import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/after_sale.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/flipper_dashboard.dart';
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
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:chat/screens/about_chat.dart';
import 'package:chat/screens/chatpage.dart';
import 'package:chat/screens/chat_list.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: DashboardView, name: 'dashboard'),
    MaterialRoute(page: SignUpFormView, name: 'signup'),
    MaterialRoute(page: Home, name: 'home'),
    MaterialRoute(page: Login, name: 'login'),
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
    MaterialRoute(page: AfterSale, name: 'afterSale'),
    MaterialRoute(page: SettingsScreen, name: 'settings'),

    // chat routes
    MaterialRoute(page: AboutChatMiniApp, name: 'about'),
    MaterialRoute(page: ChatList, name: 'chatHome'),
    MaterialRoute(page: KChatPage, name: 'chatPage'),
    MaterialRoute(page: AddConversation, name: 'addConvo'),
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
// 
