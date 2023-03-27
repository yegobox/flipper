import 'package:flipper_socials/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:flipper_socials/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:flipper_socials/ui/views/home/home_view.dart';
import 'package:flipper_socials/ui/views/startup/social_startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    CustomRoute(page: SocialStartUpView, initial: true),
    CustomRoute(page: HomeView),
    // @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: RouterService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
