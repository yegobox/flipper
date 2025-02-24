library flipper_routing;

import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'all_routes.dart';

@StackedApp(
  routes: [
    CustomRoute(page: StartUpView, initial: true),
    CustomRoute(page: SignUpView),
    CustomRoute(page: FlipperApp),
    CustomRoute(page: FailedPayment),
    //Login Routes
    CustomRoute(page: Login),
    CustomRoute(page: Landing),
    CustomRoute(page: Auth),
    CustomRoute(page: CountryPicker),
    CustomRoute(page: PhoneInputScreen),
    CustomRoute(page: InventoryRequestMobileView),
    //End of login routes

    CustomRoute(page: AddProductView),
    CustomRoute(page: AddToFavorites),
    CustomRoute(page: AddDiscount),
    CustomRoute(page: ListCategories),
    CustomRoute(page: ColorTile),
    CustomRoute(page: ReceiveStock),
    CustomRoute(page: AddVariation),
    CustomRoute(page: AddCategory),
    CustomRoute(page: ListUnits),
    CustomRoute(page: Sell),
    CustomRoute(page: Payments),
    CustomRoute(page: PaymentConfirmation),
    CustomRoute(page: TransactionDetail),
    CustomRoute(page: SettingsScreen),
    CustomRoute(page: SwitchBranchView),
    CustomRoute(page: ScannView),
    CustomRoute(page: OrderView),
    CustomRoute(page: Orders),
    CustomRoute(page: Customers),
    CustomRoute(page: NoNet),
    CustomRoute(page: PinLogin),
    CustomRoute(page: Devices),
    CustomRoute(page: TaxConfiguration),
    CustomRoute(page: Printing),
    CustomRoute(page: BackUp),
    CustomRoute(page: LoginChoices),
    CustomRoute(page: TenantManagement),
    CustomRoute(page: SocialHomeView),
    CustomRoute(page: DrawerScreen),
    CustomRoute(page: ChatListView),
    CustomRoute(page: ConversationHistory),
    CustomRoute(page: TicketsList),
    CustomRoute(page: NewTicket),
    CustomRoute(page: Apps),
    CustomRoute(page: CheckOut),
    CustomRoute(page: Cashbook),

    CustomRoute(page: SettingPage),
    CustomRoute(page: Transactions),
    CustomRoute(page: Security),
    CustomRoute(page: Comfirm),
    CustomRoute(page: ReportsDashboard),
    CustomRoute(page: AdminControl),
    CustomRoute(page: AddBranch),
    CustomRoute(page: QuickSellingView),
    CustomRoute(page: PaymentPlanUI),
    CustomRoute(page: PaymentFinalize),
    CustomRoute(page: WaitingOrdersPlaced),
    //
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: RouterService)
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    StackedDialog(classType: AppCenter),
    StackedDialog(classType: LogOut),
  ],
  logger: StackedLogger(),
)
class App {}
//  https://developer.android.com/studio/preview/features#device-mirroring-giraffe
//  before adding a package see from the bellow list if we don't
// modal_bottom_sheet: ^3.0.0-pre
// ``dart run build_runner build --delete-conflicting-outputs``
// dart run build_runner watch
// `dart run realm generate --watch`
// dart pub cache clean
//  dart pub global run melos bootstrap
// While debugging if you lost communication, then you can not use the Hot-Reload or Hot-Restart feature. So, instead of re-building or installing new applications, you can attach existing installed applications.
// NOTE: we have custom toast service you can call it like this  showToast(
//                                 context, 'Binded to ${tenants[index].name}');
// flutter attach -d <DEVICE_ID>


// https://thiele.dev/blog/part-1-configure-a-flutter-app-with-dart-define-environment-variable/
// dart run msix:create
// TODO: implement SNS notification as well
// https://medium.com/iiitians-network/flutter-push-notifications-using-aws-sns-dac464c1edf0
// TODO: implement quick action on mobile
// https://www.youtube.com/watch?v=sqw-taR2_Ww
// TODO: implement shortcut https://www.youtube.com/watch?v=WMVoNA5cY9A
//TODO: can I sync data acrross connect bluethooth?? https://github.com/boskokg/flutter_blue_plus
// TODO: tip for pro flutter web: https://www.youtube.com/watch?v=ZFx9leiFlvM

/// packages to use in socials
// https://pub.dev/packages/flutter_link_previewer
// https://pub.dev/packages/any_link_preview
// https://pub.dev/packages/chat_list
//  stacked create app name --template=web

// TODO: learn from twitter algo
// https://blog.twitter.com/engineering/en_us/topics/open-source/2023/twitter-recommendation-algorithm
// https://pub.dev/packages/pip_view
// https://docs.getwidget.dev/gf-app-bar/
// https://pub.dev/packages/getwidget
// TODO: add profile picture on user https://firebase.google.com/docs/auth/flutter/manage-users
// when can not install local generated msix file https://www.advancedinstaller.com/install-test-certificate-from-msix.html
// https://github.com/YehudaKremer/msix/issues/191
// TODO: reading visa card, master card
// https://github.com/jordanliu/flutter-emv-reader
// TODO: on my todos
// -https://pub.dev/packages/tray_manager
// -ref: https://github.com/Merrit/adventure_list/blob/main/lib/src/system_tray/system_tray_manager.dart
//   packages we can use
// - https://github.com/luckysmg/flutter_swipe_action_cell(if we choose to use this, then we will need to  the one we use on while showing product item)
// git submodule update --remote --merge
// git config submodule.recurse false
// git pull https://github.com/joelhigi/flipper.git stable
// flutterfire configure
// git submodule deinit -f open-sources/flutter_datetime_picker
// STEPS to remove submodule
///git submodule deinit -f open-sources/flutter_datetime_picker
///git rm -rf open-sources/flutter_datetime_picker
///rm -rf open-sources/qr_code_scanner
///git commit -m "Remove submodule open-sources/flutter_launcher_icons"
///rm -rf path/to/submodule
///git submodule add https://github.com/yegobox/dart_pdf.git open-sources/dart_pdf

// / find ./ -name pubspec.lock -type f -delete
// / find ./ -name pubspec_overrides.yaml -type f -delete
// / find ./ -name dependencies.txt -type f -delete
/// https://developer.apple.com/in-app-purchase/
/// https://github.com/flutter/packages/tree/main/packages/in_app_purchase/in_app_purchase
/// C:\Users\Richie\Downloads\vcpkg\vcpkg.exe install cppwinrt
/// https://vcpkg.io/en/packages.html
/// import 'package:newrelic_mobile/newrelic_navigation_observer.dart';
/// https://learn.microsoft.com/en-us/gaming/gdk/_content/gc/commerce/service-to-service/xstore-requesting-a-userstoreid
/// https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app
/// https://learn.microsoft.com/en-us/gaming/gdk/_content/gc/commerce/service-to-service/xstore-requesting-a-userstoreid#step-2
/// https://learn.microsoft.com/en-us/gaming/gdk/_content/gc/commerce/service-to-service/microsoft-store-apis/xstore-v8-recurrence-query

/// intresting package: https://pub.dev/packages/xdg_desktop_portal
/// this guy used google calendar in innovative way: https://github.com/Merrit/adventure_list/issues/7
// https://codepush.dev/
//TODO: adapt to new FIGMA things https://uxplanet.org/whats-new-in-figma-10-updates-from-config-2023-c1651012835
// https://codelabs.developers.google.com/design-android-launcher#4
/// there was a time I used this frag in CMAKELists.txt and this was when
///TODO: firebase core was not friendy and for now it seem to be fixed.
// set(CMAKE_BUILD_TYPE "Release")
// TODO: remove these deprecated fields from remote db
// https://pub.dev/packages/pinput
// active
// reported
// draft
// getting key hash key
//  keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
//  keytool -list -v -keystore ./debug.keystore -alias androiddebugkey -storepass android -keypass android
// TODO:learn more about bluetooth here https://github.com/TrackMyIndoorWorkout/TrackMyIndoorWorkout
// TODO: resisable widget https://pub.dev/packages/resizable_widget, https://github.com/zamaniafshar/Flutter-Resizable-Widget
// TODO: https://github.com/firebase/flutterfire/issues/11648 (this need to be fixed before updating to firebase_auth latest)
// TODO: https://blog.mobile.dev/running-your-maestro-flows-on-github-actions-fe2e016b7338
// TODO: https://github.com/hautvfami/firebase_admob_config/blob/main/example/lib/main.dart
// TODO: https://pub.dev/packages/flutter_nfc_kit

// TODO:https://pub.dev/packages/datecs_printer package to use
// TODO: https://medium.com/flutter-community/a-better-approach-for-cloud-firestore-odm-ad2f6eed11e1
// best packages
// https://pub.dev/packages/device_apps

// TODO: support auto-printing
//https://github.com/DavBfr/kds/issues/1116

// TODO: using custom domain follow this
//https://github.com/firebase/flutterfire/issues/9668 to update
// https://github.com/firebase/flutterfire/pull/11925
// https://github.com/firebase/flutterfire/issues/9668

// https://pub.dev/packages/wakelock
// https://pub.dev/packages/system_tray

// Auto-printing
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// void main() async {
//   // Create a PDF document
//   final pdf = pw.Document();
//   pdf.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Text('Hello World'),
//         ); // Center
//       })); // Page

//   // Print the document without opening a dialog
//   await Printing.directPrintPdf(
//     printer: await Printing.pickPrinter(),
//     onLayout: (PdfPageFormat format) async => pdf.save(),
//   );
// }
// TODO: when get time implement this: https://app.posthog.com/ (login with richard github account)
// https://pub.dev/packages/side_navigation
//TODO: realm crud https://medium.com/@alperenekin/another-mobile-database-option-realm-database-for-flutter-f269763b79ef
// Login Pins
// YEGOBOX: 31658
//customerTin: 999941411
// seller Tin: 999909695
// PETER: 49528
// 67364
// 28462948626200
// TODO:https://github.com/bdlukaa/fluent_ui/issues/150
// TODO:Flipper pitch https://www.mongodb.com/blog/post/how-enhance-inventory-management-real-time-data-strategies?utm_campaign=realtimedata&utm_source=youtube&utm_medium=organic_social
// TODO:https://www.mongodb.com/developer/products/atlas/build-inventory-management-system-using-mongodb-atlas/?utm_campaign=inventorymgmt&utm_source=youtube&utm_medium=organic_social
//TODO: https://github.com/mongodb-industry-solutions/Inventory_mgmt
//TODO: thing to consider when building entreprise dashboard https://ui.shadcn.com/docs/installation/laravel
// TODO: https://www.youtube.com/watch?v=G7lZBKFFnls
// TODO: colapsible sidebar https://github.com/DrunkOnBytes/flutter_collapsible_sidebar
// https://pub.dev/packages/sidebarx
// https://medevel.com/flutter-17-ui/
// https://pub.dev/packages/awesome_snackbar_content
// https://pub.dev/packages/responsive_framework
// https://pub.dev/packages/timelines
/// TODO: once this issue is closed https://github.com/realm/realm-dart/issues/1451
/// i.e new realm 1.7 released then I shall move realm in separate isolate
/// to improve the UI blocking that is currently happening when realm is busy in flipper app
///TODO: automatic release on windows store https://github.com/marketplace/actions/windows-store-publish
///https://yashgarg.dev/pensieve/flutter-testing/
///TODO:-
///work on updating the stock value should not override instead should add
///also consider signs..
///https://www.youtube.com/watch?v=EIiBDoVHlNc
///https://console.shorebird.dev/
///https://www.youtube.com/watch?v=JRwTCKjc37o
///https://podman.io/
///When it is time for us to migrate to kubernetes, this should be
///before we request production EBM.
///https://youtu.be/MeU5_k9ssrs?t=1627
///https://www.padok.fr/en/blog/digitalocean-kubernetes
///https://ryderdamen.medium.com/deploying-kubernetes-web-servers-to-digital-ocean-with-tls-and-terraform-2ccba95c5a3c
///
///https://blog.wimwauters.com/devops/2022-02-25-digitalocean_terraform_k8s/
///Example of how to use completer
/// User? _currentUser;
//  Completer<void> _completer = Completer();

// initState(){
//  firebaseAuth.userChanges().skip(1).listen((user) {
//       _currentUser = user;
//       if (!_completer.isCompleted) {
//         _completer.complete();
//       }
//     });
// }

//  Future<String?> get accessToken async {
//     try {
//       await _completer.future;
//       return await _currentUser?.getIdToken(true);
//     } catch (_) {
//       return null;
//     }
//   }
/// users to use while testing tenant
/// start by creating a business and add the bellow users to that business
/// then logout and log in the users to test if when they login
/// they are prompted to choose a business/branches to login to
/// FYI they will have to register fully before prompted to login to the business/branch
//+250783054002 - User A
//+250783054874 - User B
//+250783054801 - User C
/// TODO: sentry support isar db for instrumentation, I will support that in near future!
/// https://github.com/getsentry/sentry-dart/pull/1726/commits/5ee8639f20bb1e566c849f2b3af2c6be5a1a5626
/// TODO: https://github.com/SharezoneApp/sharezone-app
///
///TODO: Code for new app header on mobile WIP
/// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 child: Row(
//                   children: [
//                     Chip(
//                       label: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Icon(Icons.radio_button_checked, color: Colors.orange),
//                           Text('R'),
//                           Icon(Icons.check_circle_outline, color: Colors.green),
//                         ],
//                       ),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         side: BorderSide(color: Colors.grey, width: 0.5),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(child:
//                 Icon(Icons.loop, color: Colors.red, size: 30.0),
//               ),
//               Container(child:
//                 Chip(
//                   label: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text('RWF 500', style: TextStyle(color: Colors.black)),
//                     ],
//                   ),
//                   backgroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     side: BorderSide(color: Colors.grey, width: 0.5),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           backgroundColor: Colors.white,
//         ),
//       ),
//     );
//   }
// }

//TODO:api/selectInitInfo
//{
//     "resultCd": "000",
//     "resultMsg": "It is succeeded",
//     "resultDt": "20240202210557",
//     "data": {
//         "info": {
//             "tin": "999909695",
//             "taxprNm": "TESTING COMPANY 14 LTD",
//             "bsnsActv": null,
//             "bhfId": "00",
//             "bhfNm": "Headquarter",
//             "bhfOpenDt": "20210927",
//             "prvncNm": "SOUTH",
//             "dstrtNm": "KAMONYI",
//             "sctrNm": "NYARUBAKA",
//             "locDesc": "RRA",
//             "hqYn": "Y",
//             "mgrNm": "TESTING COMPANY 14 LTD",
//             "mgrTelNo": "0788427097",
//             "mgrEmail": "ebm@rra.gov.rw",
//             "sdcId": null,
//             "mrcNo": null,
//             "dvcId": "1036147990000001",
//             "intrlKey": null,
//             "signKey": null,
//             "cmcKey": null,
//             "lastPchsInvcNo": 40,
//             "lastSaleRcptNo": null,
//             "lastInvcNo": null,
//             "lastSaleInvcNo": 7885983517,
//             "lastTrainInvcNo": null,
//             "lastProfrmInvcNo": null,
//             "lastCopyInvcNo": null,
//             "vatTyCd": null
//         }
//     }
// }
//https://pub.dev/packages/floating_overlay
// https://www.youtube.com/watch?v=yjsN2Goe_po
//article to check: https://medium.com/@ABausG/interactive-homescreen-widgets-with-flutter-using-home-widget-83cb0706a417
// https://github.com/Shopify/ejson
//TODO: People to hire to clean the UI: https://goods.overnice.com/
// fix nuget issue : winget install Microsoft.NuGet
//Show things on second screen: https://pub.dev/packages/presentation_displays

// https://pub.dev/packages/requests_inspector

// Now need to heavily use sizer: ^2.0.15 for managing the scalability

// # Create a new virtual environment
// python3 -m venv myenv

// # Activate the virtual environment
// source myenv/bin/activate  # For Unix/Linux
// # or
// myenv\Scripts\activate     # For Windows

// # Now you can install Pandas using pip
// python -m pip install pandas

// https://www.mongodb.com/docs/atlas/app-services/data-api/
// https://www.mongodb.com/blog/post/atlas-edge-server-now-in-public-preview?utm_source=beamer&utm_medium=sidebar&utm_campaign=Atlas-Edge-Server-is-Now-in-Public-Preview&utm_content=ctalink

/// NOTE: in prodduct_view
/// We also show buildProductList inside
/// Edge server token:
/// TODO: deal with flavor https://docs.flutter.dev/deployment/flavors#conditionally-bundling-assets-based-on-flavor
///
///
///WHY!
///I am using git submodule add https://github.com/yegobox/plus_plugins.git open-sources/plus_plugins because orgional is wasting my time with java sdk 17 request
/// sudo killall coreaudiod
///
/// Things to remember
/// 1. update branchId and businessId in counter in realm
/// 2. test receipt see if I am not getting counter issue
// / 999959413
/// 999909695 Client tin
/// enhance login and permission https://github.com/quarkusio/quarkus-quickstarts/tree/main/security-keycloak-authorization-quickstart
/// https://quarkus.io/guides/security-keycloak-authorization
/// https://www.keycloak.org/migration/migrating-to-quarkus
///
/// git commit -am "[build release windows] [build release android]"

/// https://medium.com/lodgify-technology-blog/deploy-your-flutter-app-to-google-play-with-github-actions-f13a11c4492e
/// base64 -i upload-keystore.jks -o keystoreBase64
/// ShoreBird skll down here!
/// shorebird release android
/// ✅ Published Release 1.170.4252223231897+1717794359!
/// Your next step is to upload the app bundle to the Play Store:
/// Users/richard/Documents/GitHub/flipper/apps/flipper/build/app/outputs/bundle/release/app-release.aab

/// For information on uploading to the Play Store, see:
/// https://support.google.com/googleplay/android-developer/answer/9859152?hl=en

/// To create a patch for this release,   shorebird patch --platforms=android --release-version=1.170.4252223232270+1723701200

/// Note: shorebird patch --platforms=android without the --release-version option will patch the current version of the app.
///
///  nohup java -jar rra.war &  echo $! > pid.txt

// {
//     "resultCd": "000",
//     "resultMsg": "It is succeeded",
//     "resultDt": "20240610195641",
//     "data": {
//         "info": {
//             "tin": "999909695",
//             "taxprNm": "TESTING COMPANY 14 LTD",
//             "bsnsActv": null,
//             "bhfId": "00",
//             "bhfNm": "Headquarter",
//             "bhfOpenDt": "20210927",
//             "prvncNm": "SOUTH",
//             "dstrtNm": "KAMONYI",
//             "sctrNm": "NYARUBAKA",
//             "locDesc": "RRA",
//             "hqYn": "Y",
//             "mgrNm": "TESTING COMPANY 14 LTD",
//             "mgrTelNo": "0788427097",
//             "mgrEmail": "ebm@rra.gov.rw",
//             "sdcId": null,
//             "mrcNo": null,
//             "dvcId": "1036147990000001",
//             "intrlKey": null,
//             "signKey": null,
//             "cmcKey": null,
//             "lastPchsInvcNo": 54,
//             "lastSaleRcptNo": null,
//             "lastInvcNo": null,
//             "lastSaleInvcNo": 7885983517,
//             "lastTrainInvcNo": null,
//             "lastProfrmInvcNo": null,
//             "lastCopyInvcNo": null,
//             "vatTyCd": null
//         }
//     }
// }
//  docker run -it -e NGROK_AUTHTOKEN=2iuypwkYzPBh8SXyZbGbH_4XTQbAcY12w4yG7Tyag1h ngrok/ngrok http 8080
// ngrok http http://localhost:8080

// ✔ Initialized provider successfully.
// ✅ Initialized your environment successfully.
// ✅ Your project has been successfully initialized and connected to the cloud!
// Some next steps:

// "amplify status" will show you what you've added already and if it's locally configured or deployed
// "amplify add <category>" will allow you to add features like user login or a backend API
// "amplify push" will build all your local backend resources and provision it in the cloud
// "amplify console" to open the Amplify Console and view your project status
// "amplify publish" will build all your local backend and frontend resources (if you have hosting category added) and provision it in the cloud

// Pro tip:
// Try "amplify add api" to create a backend API and then "amplify push" to deploy everything
/// https://myrratest.rra.gov.rw/app/ebm/trns/sales/indexTrnsSalesInvoice
/// FLIPPER-17189
/// https://momoapi.mtn.co.rw/
/// https://partner.mtn.co.rw/
/// Username: YEGOBOX.SP
/// JS Interop: https://www.youtube.com/watch?v=cTzmllsYiCI
///
/// NOTE: deal with python experiment, python will be used
/// for heavy experimentation.
///  mkdir py
///  cd py
///  python3 -m venv venv
///  source venv/bin/activate
///  pip install tensorflow pandas scikit-learn matplotlib
/// pip install python-dotenv
/// password: :93h)]6m7V8B
/// TODO: hire in future
/// https://www.merixstudio.com/development/flutter
///
/// https://www.mongodb.com/docs/atlas/app-services/data-api/examples/
///
/// Macos & ios build
/// https://medium.com/team-rockstars-it/the-easiest-way-to-build-a-flutter-ios-app-using-github-actions-plus-a-key-takeaway-for-developers-48cf2ad7c72a
/// https://medium.com/@vovaklh20012/code-push-for-flutter-update-your-app-without-new-release-using-shorebird-d3575ba0a2c0
/// https://github.com/fastlane/fastlane/discussions/20177
/// Hire a developer to help you with your flutter app https://superdeclarative.com/ (This one can help in UI and Testing)
/// https://red-badger.com/
///
/// TODO: impressive widgets
/// https://github.com/merixstudio/flutter-vizier-challenge
/// https://pub.dev/packages/mrx_charts
///
/// TODO: something we can steal
/// https://ente.io/ (flipper home page)
/// https://gitlab.com/wolfenrain/okane
/// https://pub.dev/packages/flutter_nearby_connections
/// https://github.com/AOSSIE-Org/OpenPeerChat-flutter/blob/main/pubspec.yaml
/// https://github.com/AOSSIE-Org/OpenPeerChat-flutter/tree/main
/// https://github.com/fluttergems/awesome-open-source-flutter-apps?tab=readme-ov-file
/// https://github.com/localsend/localsend
/// https://github.com/tejasbadone/flutterzon_bloc
/// Bellow project is good in terms of UI, code organization, Design system start with Figma, this is something
/// I will consider surely in future
/// https://github.com/openfoodfacts/smooth-app
/// https://github.com/smaranjitghose/DocLense
////
/// TODO: learn about integeation test or get some ideas
/// https://github.com/ubuntu/app-center/blob/main/packages/app_center/integration_test/app_center_test.dart
/// git commit -am "test direct-build-windows test direct-build-android"
/// 
/// git commit -am "test direct-build-windows"
/// git commit -am "test direct-build-android"
/// 
/// https://fly.io/docs/about/pricing/
/// https://pub.dev/packages/wolt_modal_sheet#why-use-modaldecorator-for-state-management
/// https://www.corbado.com/pricing
/// https://github.com/corbado/flutter-passkeys
/// https://www.epam.com/
/// echo "$PRODUCT_NAME.app" > "$PROJECT_DIR"/Flutter/ephemeral/.app_filename && "$FLUTTER_ROOT"/packages/flutter_tools/bin/macos_assemble.sh embed
/// Features TODO: take advantage of https://pub.dev/packages/sentry_flutter/changelog
// Add dart platform to sentry frames (#2193)
// This allows viewing the correct dart formatted raw stacktrace in the Sentry UI
// Support ignoredExceptionsForType (#2150)
// Filter out exception types by calling SentryOptions.addExceptionFilterForType(Type exceptionType)
// https://pub.dev/packages/flutter_thermal_printer
// https://pos-x.com/download/thermal-receipt-printer-driver-2/

// TIP on testing
//https://stackoverflow.com/questions/73022762/how-to-specify-test-tags-correctly-in-dart-test-yaml
// Rust flutter
// https://www.youtube.com/watch?v=FyRo7tvwteQ
//https://github.com/TimNN/cargo-lipo
//https://blog.logrocket.com/using-flutter-rust-bridge-cross-platform-development/
// https://github.com/cunarist/rinf
//https://rinf.cunarist.com/
// https://github.com/realm/realm-dart/issues/1771
// https://github.com/microsoft/store-submission/issues/12
// https://github.com/LanceMcCarthy/MediaFileManager/blob/cb3e5f41e20e0d611a99405f22478242a7b748e3/.github/workflows/cd_release_msstore.yml#L110

//TODO:Testing https://seniorturkmen.medium.com/managing-multi-package-flutter-projects-with-melos-a-leap-towards-efficient-development-a305e696fe73
// https://medium.com/@meliksahcakirr/unit-tests-and-coverage-reports-in-multi-package-flutter-project-5b0ce47d2fc2

// Have been looking to how I can build rust + flutter here is solution
// https://github.com/AppFlowy-IO/AppFlowy/tree/main/frontend/rust-lib/flowy-ai
// Read excel file
// https://pub.dev/packages/excel

// Watch this issue if is solved https://github.com/realm/realm-dart/issues/1790 then if yes switch to google login
// // await amplify.Amplify.Storage.remove(
//   //   path: storagePath,
//   // );
// https://developer.apple.com/documentation/bundleresources/information_property_list/lsapplicationcategorytype
// https://medium.com/swiftable/build-and-deploy-the-app-to-testflight-using-github-actions-with-fastlane-and-app-distribution-ff1786a8bf72

// Download ios Simulator
// https://developer.apple.com/download/all/?q=Simulator%20Runtime

// Power sync isolate example TODO: when https://github.com/aws-amplify/amplify-flutter/issues/5477 is closed.
// https://github.com/powersync-ja/powersync.dart/discussions/178
// https://gist.github.com/rkistner/e1067e51ad340f9447c4e55bc7bc96e1

// import 'package:flipper_models/realmExtension.dart';
// import 'package:flipper_models/power_sync/schema.dart';
// https://github.com/firebase/flutterfire/blob/master/.github/workflows/scripts/start-firebase-emulator.sh

// firebase deploy --only firestore:rules
// firebase emulators:start --only firestore,auth
// https://github.com/appium/appium-flutter-driver
// firebase crashlytics:symbols:upload --app=yegobox-2ee43 PATH/TO/symbols
// https://firebase.google.com/docs/crashlytics/get-started?platform=flutter
// https://github.com/firebase/flutterfire/issues/11547
// https://github.com/firebase/flutterfire/issues/16536 (Can't use latest firebase_auth)
//https://firebase.google.com/docs/crashlytics/get-started?platform=flutter
// https://stackoverflow.com/questions/48390821/unable-to-upload-crashlytics-dsym-file-during-build-phase-due-to-script-error

// FIXME: use latest flutter, I have to keep watching this issue as it affect me on android
// https://github.com/flutter/flutter/issues/9707

// xcrun simctl runtime add "~/Downloads/iOS_18_Simulator_Runtime.dmg"
// https://www.youtube.com/watch?v=CasigPskeM
// https://github.com/firebase/flutterfire/issues/12987

// https://developer.couchbase.com/dart-flutter-replication-app-services
// https://www.hungrimind.com/articles/flutter-apple-pay
// https://medium.com/blocship/integrate-apple-sign-in-on-android-using-flutter-bf5d61c85332

//  Map<String, dynamic> map = {"id": 15};
//       final db = ProxyService.capela.capella!.database!;

// // Use the writeN method to write the document
// await db.writeN(
// tableName:
//     "your_table_name", // Table name (although Couchbase Lite uses collections)
// writeCallback: () {
//   // Create a document with the given ID and map data
//   final document = MutableDocument.withId("15", map);

//   // Return the created document (of type T, in this case a MutableDocument)
//   return document;
// },
// onAdd: (doc) async {
//   // After the write operation, save the document to the collection
//   final collection = await db.defaultCollection;
//   await collection.saveDocument(doc);

//   // Optionally, you can log or perform further operations here
//   print("Document saved: ${doc.id}");
// });
//  await capella!.database!.writeN(
//           tableName: countersTable,
//           writeCallback: () {
//             Counter counter = Counter(id: randomNumber(), curRcptNo: 1111);
//             return MutableDocument.withId(
//                 counter.id.toString(), counter.toJson());
//           },
//           onAdd: (doc) async {
//             await collection!.saveDocument(doc);
//             talker.warning("Document saved: ${doc.id}");
//           });

// https://cbl-dart.dev/queries/query-builder/

//  start ms-settings:developers
// set DART_VM_OPTIONS="--root-certificate-path=C:\Users\HP\Documents\flipper\apps\flipper\assets\ca\lets-encrypt-r3.pem"

//  archive: ^3.3.5
//   bloc: ^8.1.0
//  cbl_flutter_ce: ^3.1.3
//   cbl_flutter: ^3.1.3
//
//   collection: ^1.16.0
//   cupertino_icons: ^1.0.5
//   equatable: ^2.0.5

// curl -X PUT http://127.0.0.1:4985/flipper/ \
//  -H "Content-Type: application/json" \
//  -u admin:umwana789 \
//  -d '{
//    "bucket": "flipper",
//    "enable_shared_bucket_access": true,
//    "import_docs": true

//  }'

//

// https://cloudapi.cloud.couchbase.com/v4/organizations/{organizationId}/projects/{projectId}/clusters/{clusterId}/buckets/{bucketId}/scopes

// Couchbase
// https://www.youtube.com/watch?v=j2Zs1mzwdME
// https://www.youtube.com/watch?v=X0hL1Z32ck0
// CREATE PRIMARY INDEX ON `flipper`.`user_data`.`counters`;
// https://docs.couchbase.com/couchbase-lite/current/java/gs-build.html
// https://docs.couchbase.com/cloud/app-services/user-management/create-app-role.html
// https://docs.couchbase.com/cloud/app-services/deployment/access-control-data-validation.html

// TESTING:
// https://github.com/nektos/act
// {
//     "resultCd": "000",
//     "resultMsg": "It is succeeded",
//     "resultDt": "20241123193851",
//     "data": {
//         "rcptNo": 1029,
//         "intrlData": "ZB2QJS3QLLULGJRSCRVGWNHCKU",
//         "rcptSign": "GHTWTMU66UNYGXZQ",
//         "totRcptNo": 1379,
//         "vsdcRcptPbctDate": "20241123193851",
//         "sdcId": "SDC010000052",
//         "mrcNo": "WIS00000052"
//     }
// }
// https://stackoverflow.com/questions/71090014/how-to-launch-other-appgo-service-when-flutter-windows-app-start/71123035#71123035

// Sqlite ship with app:
// https://github.com/alextekartik/flutter_app_example/blob/master/demo_sqflite/tool/windows/windows_release_info.md
// Firestore testing
// https://github.com/alextekartik/flutter_app_example/blob/master/demo_sqflite/tool/windows/windows_release_info.md

// https://pub.dev/packages/app_links


// Find all comments in a file: //.*$|/\*[\s\S]*?\*/
// brick knowledge: https://github.com/GetDutchie/brick/issues/454
// https://github.com/GetDutchie/brick/issues/493
// SUPABSE-BRICK knowledge
// https://supabase.com/blog/offline-first-flutter-apps
// 50482
// brick only update
// https://github.com/GetDutchie/brick/blob/main/packages/brick_supabase/lib/src/supabase_provider.dart#L119-L136
// https://github.com/GetDutchie/brick/pull/529/commits/165ee1bca04d4804b08df318de64777b8f5bd850

// https://github.com/MaikuB/flutter_local_notifications/issues/2512

// https://medium.com/team-rockstars-it/the-easiest-way-to-build-a-flutter-ios-app-using-github-actions-plus-a-key-takeaway-for-developers-48cf2ad7c72a
// App of reference:
// https://www.projectmanager.com/software/dashboard

// TODO: on my watch: https://pub.dev/packages/ditto_live when they support windows that will be my trigger
// see how others are using it https://github.com/ente-io/ente/commit/18cc16bcc00590f8852d02237d4f1bbe79b0c0b4


// d0d742ef-4c6a-4cc7-9bd5-a3a4de5bc44e

//62c494a9-53d3-4de2-a37a-055ec06fa606 

// accounting research:
// https://chat.deepseek.com/a/chat/s/d2353971-acce-41b8-875b-2bbb4cb66efe
// https://pub.dev/packages/smart_auth

// DROP TABLE  _brick_InventoryRequest_transaction_items;
// ALTER TABLE TransactionItem DROP COLUMN inventory_request_InventoryRequest_brick_id;
// ALTER TABLE TransactionItem DROP COLUMN inventory_request_id;
// ALTER TABLE TransactionItem DROP COLUMN inventory_request_InventoryRequest_brick_id;
// ALTER TABLE TransactionItem DROP COLUMN inventory_request_InventoryRequest_brick_id;
// ALTER TABLE InventoryRequest DROP COLUMN id;

// https://docs.flutter.dev/release/breaking-changes/flutter-gradle-plugin-apply

// https://github.com/tekartik/sqflite/issues/873

// copy all file names in a folder
// ls -1 | tr '\n' '\n' | pbcopy
// the bellow copy files with modifiet twists
// ls -1 | grep -v 'g\.dart$' | grep '\.dart$' | awk '{printf "export \x27%s\x27;\n", $0}' | pbcopy
// https://medium.com/@matheusdeveloper.henrique/flutter-integration-test-with-gcloud-firebase-testlab-and-github-actions-31ba1f2c173c


// TODO: check if ProxyService.strategy.updateStock( is being called propper