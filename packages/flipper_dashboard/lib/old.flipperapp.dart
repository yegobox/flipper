import 'package:flipper_rw/bottom_sheets/bottom_sheet_builder.dart';
import 'package:flipper_rw/bottom_sheets/activate_subscription.dart';
import 'package:flipper_rw/bottom_sheets/subscription_widget.dart';
import 'package:flipper_dashboard/app_data.dart';
import 'package:flipper_dashboard/body.dart' show BodyWidget;
import 'package:flipper_dashboard/bottom_sheet.dart';
import 'package:flipper_services/abstractions/dynamic_link.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_dashboard/responsive_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_chat/omni/update_profile.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;

class FlipperApp extends StatefulWidget {
  const FlipperApp({
    Key? key,
  }) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> {
  late ScrollController scrollController;
  TextEditingController controller = TextEditingController();
  final DynamicLink _link = locator<DynamicLink>();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  ValueNotifier<int> pageIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    ProxyService.event.connect();
    ProxyService.firestore.configureEbm();

    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
    //connect to anyy available printer
    // ProxyService.printer.blueTooths();
    ProxyService.analytics.recordUser();
    ProxyService.forceDateEntry.caller();
    // init the crashlytics
    // ProxyService.crash.initializeFlutterFire();
    // implement review system.
    ProxyService.review.review();
    // schedule the report
    ProxyService.cron.schedule();
    ProxyService.cron.connectBlueToothPrinter();
    ProxyService.cron.deleteReceivedMessageFromServer();

    /// This is one solution to have data synced across devices. and connected clients
    /// once the objectbox sync is available the option will be evaluated and added. to package and maybe also
    /// the two solution will be sold differently with different price.
    if (ProxyService.remoteConfig.isSyncAvailable()) {
      // ProxyService.syncApi.pull();
      // ProxyService.syncApi.push();
    }

    // scrollController =
    // ScrollController(keepScrollOffset: true, initialScrollOffset: 0);
    ProxyService.cron.schedule();

    /// to avoid receiving the message of the contact you don't have in your book
    /// we need to load contacts when the app starts.
    // ProxyService.isarApi.contacts().asBroadcastStream();
    // ProxyService.isarApi.createPin();

    super.initState();
    if (!kDebugMode) {
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          int businessId = ProxyService.box.read(key: 'businessId');
          Profile? profile =
              await ProxyService.isarApi.profile(businessId: businessId);

          int today = DateTime.now().day;
          // if today is tuesday for example and other even days
          if (profile == null && today % 2 == 0 && !isWindows) {
            bottomSheetBuilderProfile(
              context: context,
              body: <Widget>[const UpdateProfile()],
              header: header(title: 'Update Profile', context: context),
            );
          }
          // if to day is monday or wednesday and other odd days
          if (today % 2 == 1 &&
              !await ProxyService.billing.activeSubscription() &&
              !isWindows) {
            activateSubscription(
              context: context,
              body: <Widget>[const SubscriptionWidget()],
              header: header(title: 'Activate flipper pro', context: context),
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _sideOpenController.dispose();
    // scrollController.dispose();
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    // final double margins = AppData.responsiveInsets(media.size.width);
    // final double topPadding = media.padding.top + kToolbarHeight + margins;
    // final double bottomPadding = media.padding.bottom + margins;
    // We are on phone width media, based on our definition in this app.
    final bool isPhone = media.size.width < AppData.phoneBreakpoint;

    final ThemeData theme = Theme.of(context);
    // final TextTheme textTheme = theme.textTheme;
    // final TextStyle headline4 = textTheme.headline4!;
    // In dark mode?
    final bool isDark = theme.brightness == Brightness.dark;

    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      viewModelBuilder: () => BusinessHomeViewModel(),
      onModelReady: (model) async {
        model.currentOrder();
        ProxyService.notification.initialize(context);
        ProxyService.notification.listen(context);
        ProxyService.dynamicLink.handleDynamicLink(context);
        model.loadReport();
        await [perm.Permission.storage, perm.Permission.manageExternalStorage]
            .request();
      },
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: SafeArea(
            child: ResponsiveScaffold(
              model: model,
              // title: Text(AppData.title(context)),
              menuTitle: const Text(AppData.appName),
              // Make Rail width larger when using it on tablet or desktop.
              railWidth: isPhone ? 52 : 66,
              breakpointShowFullMenu: AppData.desktopBreakpoint,
              extendBodyBehindAppBar: false,
              extendBody: true,
              onSelect: (String index) async {
                if (index == MenuConfig.darkMode) {
                  if (isDark) {
                    model.onThemeModeChanged(ThemeMode.light);
                  } else {
                    model.onThemeModeChanged(ThemeMode.dark);
                  }
                }
                if (index == MenuConfig.addMember) {
                  addWorkSpace(context: context);
                }

                /// settings
                if (index == MenuConfig.settings) {
                  preferences(context: context, model: model);
                }
                if (index == MenuConfig.share) {
                  String uri = await _link.createDynamicLink();
                  ProxyService.share.share(uri.toString());
                }
              },
              body: !isMacOs && !isWindows && !kDebugMode
                  ? UpgradeAlert(
                      child: BodyWidget(
                        model: model,
                        controller: controller,
                        nodeDisabled: false,
                      ),
                    )
                  : BodyWidget(
                      model: model,
                      controller: controller,
                      nodeDisabled: false,
                    ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (int index) {
                  setState(() {
                    model.setTab(tab: index);
                  });
                },
                currentIndex: model.tab,
                items: <BottomNavigationBarItem>[
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.calculate),
                    label: 'KeyPad',
                  ),
                  // if (UniversalPlatform.isDesktopOrWeb)
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.analytics),
                    label: 'Transactions',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.store),
                    label: 'Store',
                  ),
                  if (ProxyService.remoteConfig.isLinkedDeviceAvailable())
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
