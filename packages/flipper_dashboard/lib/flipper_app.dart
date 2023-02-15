import 'dart:async';
import 'dart:developer';

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'badge_icon.dart';
import 'init_app.dart';
import 'page_switcher.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isIos = UniversalPlatform.isIOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;

final isDesktopOrWeb = UniversalPlatform.isDesktopOrWeb;

class FlipperApp extends StatefulWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  final TextEditingController controller = TextEditingController();
  int tabselected = 0;
  Future<void> _disableScreenshots() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    _disableScreenshots();
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      // AppLifecycleState.
      case AppLifecycleState.resumed:
        if (isAndroid || isIos) {
          // This code will run every 1 second while the app is in the foreground
          AppService().nfc.stopNfc();
          AppService().nfc.startNFC(
                callback: (nfcData) {
                  AppService.cleanedDataController
                      .add(nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last);
                },
                textData: "",
                write: false,
              );
        }
        break;
      case AppLifecycleState.paused:
        // AppService.cleanedDataController.close();

        break;
      default:
        log("default");
        break;
    }
  }

  bool _initAppCalled = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        fireOnViewModelReadyOnce: true,
        viewModelBuilder: () => BusinessHomeViewModel(),
        onViewModelReady: (model) async {
          if (!_initAppCalled) {
            _initAppCalled = true;
            InitApp.init();
          }

          /// if there is current order ongoing show them when the app starts
          model.currentOrder();

          ProxyService.dynamicLink.handleDynamicLink(context);
          // showToast(context, 'URL ${getEnvVariables.url()}');
          ProxyService.messaging.init();
          model.app.automaticBackup();

          if (isAndroid || isIos) {
            AppService().nfc.startNFC(
                  callback: (nfcData) {
                    AppService.cleanedDataController.add(
                        nfcData.split(RegExp(r"(NFC_DATA:|en|\\x02)")).last);
                  },
                  textData: "",
                  write: false,
                );
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
                            semanticsLabel: 'Checkout',
                            color: Color.fromARGB(255, 0, 6, 10)),
                        label: 'Checkout',
                        selectedIcon: SvgPicture.asset("assets/checkout.svg",
                            semanticsLabel: 'Checkout',
                            color: const Color(0xff006AFE)),
                      ),
                      NavigationDestination(
                        icon: SvgPicture.asset("assets/transactions.svg",
                            semanticsLabel: 'Transactions',
                            color: Color.fromARGB(255, 0, 6, 10)),
                        label: 'Transactions',
                        selectedIcon: SvgPicture.asset(
                            "assets/transactions.svg",
                            semanticsLabel: 'Transactions',
                            color: const Color(0xff006AFE)),
                      ),
                      NavigationDestination(
                        icon: BadgeIcon(
                          icon: SvgPicture.asset("assets/notifications.svg",
                              semanticsLabel: 'Notifications',
                              color: Color.fromARGB(255, 0, 6, 10)),
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
                              semanticsLabel: 'Notifications',
                              color: const Color(0xff006AFE)),
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
                            semanticsLabel: 'More',
                            color: Color.fromARGB(255, 0, 6, 10)),
                        label: 'More',
                        selectedIcon: SvgPicture.asset("assets/more.svg",
                            semanticsLabel: 'More',
                            color: const Color(0xff006AFE)),
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
      Drawers? drawer = await ProxyService.isarApi
          .isDrawerOpen(cashierId: ProxyService.box.getBusinessId()!);
      GoRouter.of(context).push("/drawer/close", extra: drawer);
      //we return again false to be able to go to close a day page
      return false;
    } else {
      // Handle staying on the current page
      // ...
      return false;
    }
  }
}
