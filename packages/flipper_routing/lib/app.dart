library flipper_routing;

import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'all_routes.dart';

@StackedApp(
  routes: [
    CustomRoute(page: StartUpView, initial: true),
    CustomRoute(page: SignUpView),
    CustomRoute(page: FlipperApp),
    CustomRoute(page: LoginView),
    CustomRoute(page: AddProductView),
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
    //   // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
// TODO: https://developer.android.com/studio/preview/features#device-mirroring-giraffe
// TODO: before adding a package see from the bellow list if we don't
// modal_bottom_sheet: ^3.0.0-pre
//  flutter packages pub run build_runner build --delete-conflicting-outputs
// While debugging if you lost communication, then you can not use the Hot-Reload or Hot-Restart feature. So, instead of re-building or installing new applications, you can attach existing installed applications.
// NOTE: we have custom toast service you can call it like this  showToast(
//                                 context, 'Binded to ${tenants[index].name}');
// flutter attach -d <DEVICE_ID>

// FIXME: windows is not building
// https://github.com/flutter/flutter/issues/102451#issuecomment-1124651845
// https://github.com/mogol/flutter_secure_storage/issues/379

// FIXME: use dart-define for secrets
// https://thiele.dev/blog/part-1-configure-a-flutter-app-with-dart-define-environment-variable/
// flutter pub run msix:create
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
