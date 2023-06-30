library flipper_routing;

//import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'all_routes.dart';

@StackedApp(
  routes: [
    CustomRoute(page: StartUpView, initial: true),
    CustomRoute(page: SignUpView),
    CustomRoute(page: FlipperApp),

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
    CustomRoute(page: CollectCashView),
    CustomRoute(page: AfterSale),
    CustomRoute(page: TransactionDetail),
    CustomRoute(page: SettingsScreen),
    CustomRoute(page: SwitchBranchView),
    CustomRoute(page: ScannView),
    CustomRoute(page: OrderView),
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
    CustomRoute(page: Tickets),
    CustomRoute(page: NewTicket),
    CustomRoute(page: Apps),
    CustomRoute(page: CheckOut),

    CustomRoute(page: SettingPage),
    CustomRoute(page: Transactions),
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
//  dart run build_runner build --delete-conflicting-outputs
// While debugging if you lost communication, then you can not use the Hot-Reload or Hot-Restart feature. So, instead of re-building or installing new applications, you can attach existing installed applications.
// NOTE: we have custom toast service you can call it like this  showToast(
//                                 context, 'Binded to ${tenants[index].name}');
// flutter attach -d <DEVICE_ID>

// FIXME: windows is not building
// https://github.com/flutter/flutter/issues/102451#issuecomment-1124651845
// https://github.com/mogol/flutter_secure_storage/issues/379

// FIXME: use dart-define for secrets
// https://thiele.dev/blog/part-1-configure-a-flutter-app-with-dart-define-environment-variable/
// dart run msix:create
// TODO: implement SNS notification as well
// https://medium.com/iiitians-network/flutter-push-notifications-using-aws-sns-dac464c1edf0
// TODO: implement quick action on mobile
// https://www.youtube.com/watch?v=sqw-taR2_Ww
// TODO: implement shortcut https://www.youtube.com/watch?v=WMVoNA5cY9A
//TODO: can I sync data acrross connect bluethooth?? https://github.com/boskokg/flutter_blue_plus
// FIXME: https://github.com/isar/isar/issues/686
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
// - https://github.com/luckysmg/flutter_swipe_action_cell(if we choose to use this, then we will need to remove the one we use on while showing product item)
// git submodule update --remote --merge 
// git config submodule.recurse false
// git pull https://github.com/joelhigi/flipper.git stable
// flutterfire configure
// git submodule deinit -f open-sources/plus_plugins
// STEPS to remove submodule
///git submodule deinit -f path/to/submodule
///git rm -rf path/to/submodule
///rm -rf .git/modules/path/to/submodule
///git commit -m "Remove submodule open-sources/flutter_launcher_icons"
///rm -rf path/to/submodule
/// find ./ -name pubspec.lock -type f -delete
/// find ./ -name pubspec_overrides.yaml -type f -delete
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

