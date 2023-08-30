import 'dart:async';
import 'dart:developer';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_dashboard/pininput.dart';
import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:flutter/scheduler.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';

class FlipperApp extends StatefulWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  _FlipperAppState createState() => _FlipperAppState();
}

class _FlipperAppState extends State<FlipperApp> with WidgetsBindingObserver {
  PageController page = PageController();
  final TextEditingController controller = TextEditingController();
  SideMenuController sideMenu = SideMenuController();
  int tabselected = 0;
  OverlayEntry? _overlayEntry;
  final formKey = GlobalKey<FormState>();

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
  }

  @override
  void dispose() {
    AppService.cleanedDataController.close();
    super.dispose();
  }

  Future<void> nfc() async {
    if (!isDesktopOrWeb) {
      if ((isAndroid || isIos) && await NfcManager.instance.isAvailable()) {
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
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      // AppLifecycleState.
      case AppLifecycleState.resumed:
        nfc();
        ProxyService.sync.push();
        break;
      case AppLifecycleState.paused:
        // AppService.cleanedDataController.close();
        ProxyService.sync.push();
        break;
      default:
        ProxyService.sync.push();
        break;
    }
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  void _insertOverlay(
      {required BuildContext context, required HomeViewModel model}) {
    _overlayEntry = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      print(size.width);
      return Material(
        color: Colors.transparent,
        child: Scaffold(
          backgroundColor: Color(0xFF6F2F9).withOpacity(0.6),
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () {
              // Handle tap on the overlay
              print('ON TAP OVERLAY!');
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder<ITenant?>(
                          future: ProxyService.isar.getTenantBYUserId(
                            userId: ProxyService.box.getUserId()!,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return SizedBox.shrink();
                            }
                            ITenant tenant = snapshot.data!;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12.0), // Adjust spacing
                              child: ProfileWidget(
                                tenant: tenant,
                                size: 25,
                                sessionActive: tenant.sessionActive!,
                                showIcon: false,
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 230, 230, 230),
                              borderRadius: BorderRadius.circular(10)),
                          width: 320,
                          height: 140,
                          child: OnlyBottomCursor(model: model),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        fireOnViewModelReadyOnce: true,
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) async {
          //get default tenant
          model.defaultTenant();
          ProxyService.isar.refreshSession(
              branchId: ProxyService.box.getBranchId()!,
              refreshRate: kDebugMode ? 10 : 5);

          /// if there is current order ongoing show them when the app starts
          ProxyService.dynamicLink.handleDynamicLink(context);
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
              permission.Permission.storage,
              permission.Permission.manageExternalStorage
            ].request();
          }
        },
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async {
              return onWillPop(
                  context: context, message: 'Do you want to leave this app?');
            },
            child: Scaffold(
              appBar: AppBar(
                title: Center(
                    child: Text(
                  ProxyService.status.statusText.value ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                )),
                backgroundColor: ProxyService.status.statusColor.value,
                automaticallyImplyLeading: false,
                toolbarHeight:
                    ProxyService.status.statusText.value?.isNotEmpty == true
                        ? 25
                        : 0,
              ),
              body: StreamBuilder<ITenant?>(
                  stream: ProxyService.isar.authState(
                    branchId: ProxyService.box.getBranchId()!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && !snapshot.data!.sessionActive!) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _removeOverlay();
                        _insertOverlay(context: context, model: model);
                      });
                    } else if (snapshot.hasData &&
                        snapshot.data!.sessionActive!) {
                      _removeOverlay();
                    }
                    return AppLayoutDrawer(
                        controller: controller,
                        tabSelected: tabselected,
                        model: model);
                  }),
            ),
          );
        });
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}
