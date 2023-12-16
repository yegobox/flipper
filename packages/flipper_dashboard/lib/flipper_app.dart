import 'dart:async';
import 'dart:developer';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flipper_dashboard/init_app.dart';
import 'package:flipper_dashboard/layout.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:stacked/stacked.dart';

class FlipperApp extends StatefulHookConsumerWidget {
  const FlipperApp({Key? key}) : super(key: key);

  @override
  FlipperAppState createState() => FlipperAppState();
}

class FlipperAppState extends ConsumerState<FlipperApp>
    with WidgetsBindingObserver {
  PageController page = PageController();
  final TextEditingController controller = TextEditingController();
  SideMenuController sideMenu = SideMenuController();
  int tabselected = 0;
  final formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  Future<void> _disableScreenshots() async {
    if (!kDebugMode && !isDesktopOrWeb) {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  void initState() {
    super.initState();
    if (isAndroid && ProxyService.remoteConfig.enableTakingScreenShoot()) {
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

  void initializeApplicationIfRequired() {
    if (ProxyService.box.getBranchId() != null &&
        ProxyService.box.getBusinessId() != null &&
        ProxyService.box.getUserId() != null) {
      InitApp.init();
    }
  }

  List<LogicalKeyboardKey> keys = [];
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
        // fireOnViewModelReadyOnce: true,
        viewModelBuilder: () => CoreViewModel(),
        onViewModelReady: (model) async {
          initializeApplicationIfRequired();
          //get default tenant
          model.defaultTenant();
          ProxyService.isar.refreshSession(
              branchId: ProxyService.box.getBranchId()!,
              refreshRate: kDebugMode
                  ? 10
                  : ProxyService.remoteConfig.sessionTimeOutMinutes());

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
              final pendingTransaction =
                  ref.watch(pendingTransactionProvider(TransactionType.custom));
              log(data);
              List<String> parts = data.split(':');
              String firstPart = parts[0];

              await model.sellWithCard(
                  tenantId: int.parse(firstPart),
                  pendingTransaction: pendingTransaction.value!.value!);
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
          return PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
            },
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (event) {
                final key = event.logicalKey;
                if (event is RawKeyDownEvent) {
                  if (keys.contains(key)) return;
                  setState(() {
                    keys.add(key);
                  });
                  return model.handleKeyBoardEvents(event: event);
                } else {
                  setState(() {
                    keys.remove(key);
                  });
                }
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
                      branchId: ProxyService.box.getBranchId() ?? 0,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          !(snapshot.data!.sessionActive == null
                              ? false
                              : snapshot.data!.sessionActive!)) {
                        SchedulerBinding.instance
                            .addPostFrameCallback((_) async {
                          // removeOverlay(_overlayEntry!);
                          if (ProxyService.remoteConfig
                                  .isLocalAuthAvailable() &&

                              /// this is to ensure that it will not prompt the pin for a user who did not set the pin
                              (snapshot.data!.pin != null &&
                                  snapshot.data!.pin != 0)) {
                            /// the bellow commented line worked before very well
                            // _overlayEntry = insertOverlay(context: context, model: model);
                            /// we have a returning user that want to login using the pin set
                            List<ITenant> tenants = await ProxyService.isar
                                .tenants(
                                    businessId:
                                        ProxyService.box.getBusinessId()!);
                            screenLock(
                              context: context,
                              correctString: model.passCode,
                              canCancel: false,
                              // inputController: ,
                              onUnlocked: () async {
                                log('onUnlocked');
                                ITenant? tenant = await ProxyService.isar
                                    .getTenantBYPin(
                                        pin: int.tryParse(model.passCode) ?? 0);
                                model.weakUp(
                                    userId: tenant!.userId,
                                    pin: model.passCode);
                                Navigator.of(context).maybePop();
                              },
                              onValidate: (input) async {
                                for (ITenant tenant in tenants) {
                                  log(tenant.pin.toString(),
                                      name: 'given pins');
                                  if (input
                                      .allMatches(tenant.pin.toString())
                                      .isNotEmpty) {
                                    model.passCode = input;
                                    return true;
                                  }
                                  return false;
                                }
                                return true;
                              },
                            );
                          }
                        });
                      } else if (snapshot.hasData &&
                          snapshot.data!.sessionActive!) {
                        model.passCode = snapshot.data!.pin.toString();

                        ///old code kept here for reference!
                        // removeOverlay(_overlayEntry!);
                      }
                      return AppLayoutDrawer(
                        controller: controller,
                        tabSelected: tabselected,
                        // model: model,
                        focusNode: focusNode,
                      );
                    }),
              ),
            ),
          );
        });
  }
}
