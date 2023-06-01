import 'dart:async';
import 'dart:developer';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

import 'package:permission_handler/permission_handler.dart' as perm;
import 'badge_icon.dart';
import 'page_switcher.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
// import 'package:nfc_manager/nfc_manager.dart';

class FlipperApp extends StatefulWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  PageController page = PageController();
  final TextEditingController controller = TextEditingController();
  SideMenuController sideMenu = SideMenuController();
  final _routerService = locator<RouterService>();
  int tabselected = 0;
  Future<void> _disableScreenshots() async {
    if (!kDebugMode && !isDesktopOrWeb) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  void initState() {
    super.initState();
    if (isAndroid) {
      _disableScreenshots();
    }
    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      _tabController = TabController(length: 3, vsync: this);
      // run the code in here only once.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    AppService.cleanedDataController.close();
    _tabController.dispose();
  }

  Future<void> nfc() async {
    // if (!isDesktopOrWeb) {
    //   if ((isAndroid || isIos) && await NfcManager.instance.isAvailable()) {
    //     // This code will run every 1 second while the app is in the foreground
    //     AppService().nfc.stopNfc();
    //     AppService().nfc.startNFC(
    //           callback: (nfcData) {
    //             AppService.cleanedDataController
    //                 .add(nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last);
    //           },
    //           textData: "",
    //           write: false,
    //         );
    //   }
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      // AppLifecycleState.
      case AppLifecycleState.resumed:
        nfc();
        ProxyService.app.pushDataToServer();
        break;
      case AppLifecycleState.paused:
        // AppService.cleanedDataController.close();
        ProxyService.app.pushDataToServer();
        break;
      default:
        ProxyService.app.pushDataToServer();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        fireOnViewModelReadyOnce: true,
        viewModelBuilder: () => BusinessHomeViewModel(),
        onViewModelReady: (model) async {
          //get default tenant
          model.defaultTenant();

          /// if there is current order ongoing show them when the app starts
          model.currentOrder();
          ProxyService.dynamicLink.handleDynamicLink(context);
          if (isAndroid || isIos) {
            // AppService().nfc.startNFC(
            //       callback: (nfcData) {
            //         AppService.cleanedDataController.add(
            //             nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last);
            //       },
            //       textData: "",
            //       write: false,
            //     );
            AppService.cleanedData.listen((data) async {
              log("listened to data");
              log(data);
              List<String> parts = data.split(':');
              String firstPart = parts[0];

              await model.sellWithCard(tenantId: int.parse(firstPart));
              showToast(context, 'Sale recorded successfully.');
            });
          }

          model.loadReport();
          if (!isWindows) {
            await [
              perm.Permission.storage,
              perm.Permission.manageExternalStorage
            ].request();
          }
        },
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              return _onWillPop(
                model,
              );
            },
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                    child: Text(
                  model.app.statusText,
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                )),
                backgroundColor: model.app.statusColor,
                automaticallyImplyLeading: false,
                toolbarHeight: model.app.statusText.isNotEmpty ? 25 : 0,
              ),
              bottomNavigationBar: !isWindows
                  ? NavigationBarTheme(
                      data: NavigationBarThemeData(
                        backgroundColor: Colors.white,
                        indicatorColor: Colors.white,
                        labelTextStyle: MaterialStateProperty.all(
                          const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
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
                          // fluent icons: https://github.com/microsoft/fluentui-system-icons/blob/main/icons_regular.md
                          destinations: [
                            NavigationDestination(
                              icon: Icon(FluentIcons.dialpad_24_regular),
                              label: 'Checkout',
                              selectedIcon: Icon(
                                FluentIcons.dialpad_24_regular,
                                color: const Color(0xff006AFE),
                              ),
                            ),
                            NavigationDestination(
                              icon:
                                  Icon(FluentIcons.apps_list_detail_24_regular),
                              label: 'Transactions',
                              selectedIcon: Icon(
                                  FluentIcons.apps_list_detail_24_regular,
                                  color: const Color(0xff006AFE)),
                            ),
                            NavigationDestination(
                              icon: BadgeIcon(
                                icon: Icon(
                                    FluentIcons.mail_all_unread_20_regular),
                                badgeCount: 0,
                                badgeColor: Color(0xff006AFE),
                                badgeTextStyle: TextStyle(
                                  color: Color(0xff006AFE),
                                  fontSize: 8,
                                ),
                              ),
                              label: 'Notifications',
                              selectedIcon: BadgeIcon(
                                icon: Icon(
                                    FluentIcons.mail_all_unread_20_regular),
                                badgeCount: 0,
                                badgeColor: Color(0xff006AFE),
                                badgeTextStyle: TextStyle(
                                  color: Color(0xff006AFE),
                                  fontSize: 8,
                                ),
                              ),
                            ),
                            NavigationDestination(
                              icon: Icon(FluentIcons.navigation_20_regular),
                              label: 'More',
                              selectedIcon: Icon(
                                  FluentIcons.navigation_20_regular,
                                  color: Color(0xff006AFE)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth < 600) {
                  // this is a phone
                  return SafeArea(
                    child: PageSwitcher(
                      controller: controller,
                      model: model,
                      tabController: _tabController,
                      currentPage: tabselected,
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                        child: SizedBox.shrink(),
                      ),
                      // Left menu
                      // ignore: todo
                      // TODO: left menu will be essential when we add socials feature
                      // by the time I implement it I will remove the above SizedBox as it is helping me
                      // to keep the design consistent for now.
                      // Container(
                      //   width: 150,
                      //   child: SideMenu(
                      //     style: SideMenuStyle(
                      //       showTooltip: false,
                      //       displayMode: SideMenuDisplayMode.compact,
                      //       compactSideMenuWidth: 60,
                      //       openSideMenuWidth: 150,
                      //     ),
                      //     items: [
                      //       SideMenuItem(
                      //         // Priority of item to show on SideMenu, lower value is displayed at the top
                      //         priority: 0,
                      //         title: 'Dashboard',
                      //         icon: Icon(Icons.home),
                      //         badgeContent: Text(
                      //           '3',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       )
                      //     ],
                      //     controller: sideMenu,
                      //   ),
                      // ),

                      // Middle menu
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: ProductView(),
                        ),
                      ),

                      // Right menu
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: PageSwitcher(
                            isBigScreen: true,
                            controller: controller,
                            model: model,
                            tabController: _tabController,
                            currentPage: tabselected,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          );
        });
  }

  Future<bool> _onWillPop(BusinessHomeViewModel model) async {
    final shouldPop = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to leave this app?'),
          actions: <Widget>[
            OutlinedButton(
              child: Text('No',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.withOpacity(0.04);
                    }
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.12);
                    }
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            OutlinedButton(
              child: Text('Yes',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff006AFE)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blue.withOpacity(0.04);
                    }
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed)) {
                      return Colors.blue.withOpacity(0.12);
                    }
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (shouldPop == true) {
      // Handle leaving  the app
      // ...
      Drawers? drawer = await ProxyService.isar
          .getDrawer(cashierId: ProxyService.box.getBusinessId()!);
      _routerService
          .replaceWith(DrawerScreenRoute(open: "close", drawer: drawer));
      //we return again false to be able to go to close a day page
      return false;
    } else {
      // Handle staying on the current page
      // ...
      return false;
    }
  }
}
