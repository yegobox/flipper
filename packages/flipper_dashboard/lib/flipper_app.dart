import 'dart:async';
import 'dart:developer';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flipper_dashboard/add_product_buttons.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_dashboard/popup_modal.dart';
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

  void _insertOverlay(BuildContext context) {
    return Overlay.of(context).insert(OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      print(size.width);
      return Stack(
        children: [
          Positioned(
            child: Material(
              color: Colors.black.withOpacity(0.5),
              child: GestureDetector(
                onTap: () => print('ON TAP OVERLAY!'),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
        fireOnViewModelReadyOnce: true,
        viewModelBuilder: () => HomeViewModel(),
        onViewModelReady: (model) async {
          //get default tenant
          model.defaultTenant();

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
              body: StreamBuilder<({bool authState, ITenant? tenant})>(
                  stream: ProxyService.isar.authState(
                      branchId: ProxyService.box.getBranchId()!,
                      refreshRate: kDebugMode ? 1 : 5),
                  builder: (context, snapshot) {
                    //TODO:implement the session timeout dialog...see wiki
                    log('user sessions has no activity for last 5 minute',
                        name: 'session track');
                    if (snapshot.hasData) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _insertOverlay(context);
                      });
                    }
                    return AppLayoutDraw(
                        controller: controller,
                        tabselected: tabselected,
                        model: model);
                  }),
            ),
          );
        });
  }
}
