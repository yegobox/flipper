library flipper_routing;

import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'all_routes.dart';

/// TODO: adapt to some change in this flutter release https://medium.com/flutter/whats-new-in-flutter-3-19-58b1aae242d2
@StackedApp(
  routes: [
    CustomRoute(page: StartUpView, initial: true),
    CustomRoute(page: SignUpView),
    CustomRoute(page: FlipperApp),

    // CustomRoute(page: TransactionList),
    //Login Routes
    CustomRoute(page: LoginView),
    CustomRoute(page: Landing),
    CustomRoute(page: AuthOptionPage),
    CustomRoute(page: CountryPicker),
    CustomRoute(page: PhoneInputScreen),
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
    CustomRoute(page: InAppBrowser),
    CustomRoute(page: Customers),
    CustomRoute(page: NoNet),
    CustomRoute(page: PinLogin),
    CustomRoute(page: Devices),
    CustomRoute(page: TaxConfiguration),
    CustomRoute(page: Printing),
    CustomRoute(page: BackUp),
    CustomRoute(page: LoginChoices),
    CustomRoute(page: TenantAdd),
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
    CustomRoute(page: Reports),
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
// TODO: https://developer.android.com/studio/preview/features#device-mirroring-giraffe
// TODO: before adding a package see from the bellow list if we don't
// modal_bottom_sheet: ^3.0.0-pre
// `dart run build_runner build --delete-conflicting-outputs`
// `dart run realm generate --watch`
// dart pub cache clean
//  dart pub global run melos bootstrap
// While debugging if you lost communication, then you can not use the Hot-Reload or Hot-Restart feature. So, instead of re-building or installing new applications, you can attach existing installed applications.
// NOTE: we have custom toast service you can call it like this  showToast(
//                                 context, 'Binded to ${tenants[index].name}');
// flutter attach -d <DEVICE_ID>

// FIXME: use dart-define for secrets
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
// TODO:  packages we can use
// - https://github.com/luckysmg/flutter_swipe_action_cell(if we choose to use this, then we will need to  the one we use on while showing product item)
// git submodule update --remote --merge 
// git config submodule.recurse false
// git pull https://github.com/joelhigi/flipper.git stable
// flutterfire configure
// git submodule deinit -f open-sources/flutter_datetime_picker
// STEPS to remove submodule
///git submodule deinit -f open-sources/flutter_datetime_picker
///git rm -rf open-sources/flutter_datetime_picker
///rm -rf open-sources/flutter_datetime_picker
///git commit -m "Remove submodule open-sources/flutter_launcher_icons"
///rm -rf path/to/submodule
///git submodule add https://github.com/yegobox/plus_plugins.git open-sources/plus_plugins

// / find ./ -name pubspec.lock -type f -delete
// / find ./ -name pubspec_overrides.yaml -type f -delete
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
//https://github.com/DavBfr/dart_pdf/issues/1116

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

/// To create a patch for this release, run shorebird patch --platforms=android --release-version=1.170.4252223231965+1718626337

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