import 'package:flipper_chat/omni/update_profile.dart';
import 'package:flipper_dashboard/bottom_sheet.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_rw/bottom_sheets/activate_subscription.dart';
import 'package:flipper_rw/bottom_sheets/bottom_sheet_builder.dart';
import 'package:flipper_rw/bottom_sheets/subscription_widget.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

import 'badge_icon.dart';
import 'page_switcher.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;

class FlipperApp extends StatefulWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController controller = TextEditingController();
  int tabselected = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    ProxyService.event.connect();
    ProxyService.firestore.configureEbm();
    ProxyService.firestore.configureTokens();

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
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Scaffold(
              bottomNavigationBar: NavigationBarTheme(
                data: NavigationBarThemeData(
                  backgroundColor: Colors.white,
                  indicatorColor: Colors.white,
                  labelTextStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.black26,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: NavigationBar(
                    height: 90,
                    selectedIndex: tabselected,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysShow,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    animationDuration: const Duration(seconds: 2),
                    onDestinationSelected: (index) {
                      setState(() {
                        tabselected = index;
                      });
                    },
                    destinations: [
                      NavigationDestination(
                        icon: SvgPicture.asset("assets/checkout.svg",
                            semanticsLabel: 'Checkout'),
                        label: 'Checkout',
                        selectedIcon: SvgPicture.asset("assets/checkout.svg",
                            semanticsLabel: 'Checkout'),
                      ),
                      NavigationDestination(
                        icon: SvgPicture.asset("assets/transactions.svg",
                            semanticsLabel: 'Transactions'),
                        label: 'Transactions',
                        selectedIcon: SvgPicture.asset(
                            "assets/transactions.svg",
                            semanticsLabel: 'Transactions'),
                      ),
                      NavigationDestination(
                        icon: BadgeIcon(
                          icon: SvgPicture.asset("assets/notifications.svg",
                              semanticsLabel: 'Notifications'),
                          badgeCount: 0,
                          badgeColor: Color(0xff006AFE),
                          badgeTextStyle: TextStyle(
                            color: Color(0xff006AFE),
                            fontSize: 8,
                          ),
                        ),
                        label: 'Notifications',
                        selectedIcon: BadgeIcon(
                          icon: SvgPicture.asset("assets/notifications.svg",
                              semanticsLabel: 'Notifications'),
                          badgeCount: 0,
                          badgeColor: Color(0xff006AFE),
                          badgeTextStyle: TextStyle(
                            color: Color(0xff006AFE),
                            fontSize: 8,
                          ),
                        ),
                      ),
                      NavigationDestination(
                        icon: SvgPicture.asset("assets/more.svg",
                            semanticsLabel: 'More'),
                        label: 'More',
                        selectedIcon: SvgPicture.asset("assets/more.svg",
                            semanticsLabel: 'More'),
                      ),
                    ],
                  ),
                ),
              ),
              body: SafeArea(
                child: PageSwitcher(
                  controller: controller,
                  model: model,
                  tabController: _tabController,
                  currentPage: tabselected,
                ),
              ),
            ),
          );
        });
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}
