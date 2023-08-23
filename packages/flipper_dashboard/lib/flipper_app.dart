import 'dart:async';
import 'dart:developer';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/main.dart';
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
  final pinController = TextEditingController();
  final focusNode = FocusNode();
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
    pinController.dispose();
    focusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
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
                  stream: ProxyService.isar
                      .authState(branchId: ProxyService.box.getBranchId()!),
                  builder: (context, snapshot) {
                    if (snapshot.data!.authState == false) {
                      return FutureBuilder(
                        future: showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Not authenticated"),
                              content: Text("Please authenticate to continue."),
                              actions: [
                                Pinput(
                                  controller: pinController,
                                  focusNode: focusNode,
                                  androidSmsAutofillMethod:
                                      AndroidSmsAutofillMethod
                                          .smsUserConsentApi,
                                  listenForMultipleSmsOnAndroid: true,
                                  defaultPinTheme: defaultPinTheme,
                                  separatorBuilder: (index) =>
                                      const SizedBox(width: 8),
                                  validator: (value) {
                                    return value == '2222'
                                        ? null
                                        : 'Pin is incorrect';
                                  },
                                  // onClipboardFound: (value) {
                                  //   debugPrint('onClipboardFound: $value');
                                  //   pinController.setText(value);
                                  // },
                                  hapticFeedbackType:
                                      HapticFeedbackType.lightImpact,
                                  onCompleted: (pin) {
                                    debugPrint('onCompleted: $pin');
                                  },
                                  onChanged: (value) {
                                    debugPrint('onChanged: $value');
                                  },
                                  cursor: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 9),
                                        width: 22,
                                        height: 1,
                                        color: focusedBorderColor,
                                      ),
                                    ],
                                  ),
                                  focusedPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                        defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: focusedBorderColor),
                                    ),
                                  ),
                                  submittedPinTheme: defaultPinTheme.copyWith(
                                    decoration:
                                        defaultPinTheme.decoration!.copyWith(
                                      color: fillColor,
                                      borderRadius: BorderRadius.circular(19),
                                      border:
                                          Border.all(color: focusedBorderColor),
                                    ),
                                  ),
                                  errorPinTheme: defaultPinTheme.copyBorderWith(
                                    border: Border.all(color: Colors.redAccent),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        builder: (context, snapshot) {
                          return Main(
                              controller: controller,
                              tabselected: tabselected,
                              model: model);
                        },
                      );
                    } else {
                      return Main(
                          controller: controller,
                          tabselected: tabselected,
                          model: model);
                    }
                  }),
            ),
          );
        });
  }
}
