import 'package:flipper_models/isar/random.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flipper_services/proxy.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// TODO:
// import 'package:mobile_scanner/mobile_scanner.dart' as newKid;

//

class ScannView extends StatefulWidget {
  const ScannView(
      {Key? key, this.intent = 'selling', this.useLatestImplementation = false})
      : super(key: key);
  final String intent;
  final bool useLatestImplementation;

  @override
  State<StatefulWidget> createState() => _ScannViewState();
}

class _ScannViewState extends State<ScannView> {
  Barcode? result;
  // newKid.Barcode? resultForNewKid;
  List<Offset> points = [];
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _routerService = locator<RouterService>();
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) {
        final size = MediaQuery.of(context).size;
        final double aspectRatio = size.width / size.height;

        return Scaffold(
          body: Stack(
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: _buildQrView(context, model),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 -
                    (40 - 0.5 * 80) -
                    340,
                left: MediaQuery.of(context).size.width / 2 - 40,
                child: IconButton(
                  iconSize: 80,
                  onPressed: () => _routerService.pop(),
                  icon: const CircleAvatar(
                    backgroundColor: Color(0xff006AFE),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    return IconButton(
                      onPressed: () {
                        if (controller != null) {
                          controller!.toggleFlash();
                        }
                      },
                      icon: snapshot.data == false
                          ? const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.blue,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQrView(BuildContext context, HomeViewModel model) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    if (widget.useLatestImplementation) {
      // TODO: waiting for this PR: https://github.com/juliansteenbakker/mobile_scanner/pull/586
      // return Stack(
      //   children: [
      //     newKid.MobileScanner(
      //       fit: BoxFit.fill,
      //       onDetect: (capture) {
      //         final List<newKid.Barcode> barcodes = capture.barcodes;
      //         performIntentForNewKid(barcodes.first, model);
      //       },
      //     ),
      //   ],
      // );
      // return this for now as mobile_scanner above is not yet stable and causing web issues
      return QRView(
        key: qrKey,
        onQRViewCreated: (controller) {
          _onQRViewCreated(controller, model);
        },
        overlay: QrScannerOverlayShape(
            borderColor: const Color(0xFF375778),
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    } else {
      return QRView(
        key: qrKey,
        onQRViewCreated: (controller) {
          _onQRViewCreated(controller, model);
        },
        overlay: QrScannerOverlayShape(
            borderColor: const Color(0xFF375778),
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: scanArea),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void scanToLogin({required String? result}) {
    if (result != null && result.contains('-')) {
      // haptic feedback for a user to know we have got the scan result
      HapticFeedback.lightImpact();
      showToast(context, 'Login success');
      final split = result.split('-');
      if (split.length > 1 && split[0] == 'login') {
        /// send the login detail to pubnub
        int userId = ProxyService.box.getUserId()!;
        int businessId = ProxyService.box.getBusinessId()!;
        int branchId = ProxyService.box.getBranchId()!;
        String phone = ProxyService.box.getUserPhone()!;
        int defaultApp = ProxyService.box.getDefaultApp();
        ProxyService.event.publish(loginDetails: {
          // this avoid users to log in to unintended device!
          'channel': split[1],
          'userId': userId,
          'businessId': businessId,
          'branchId': branchId,
          'phone': phone,
          'defaultApp': defaultApp,
          'deviceName': Platform.operatingSystem,
          'deviceVersion': Platform.operatingSystemVersion,
          'linkingCode': randomNumber().toString()
        });
      }
    }
  }

  void _onQRViewCreated(QRViewController controller, HomeViewModel model) {
    setState(() {
      this.controller = controller;
    });
    result = null;
    if (kDebugMode) {
      model.productService.setBarcode('11232532');
      navigate('11232532', model);
    }

    controller.scannedDataStream.first.then((scanData) {
      if (result == null) {
        performIntent(scanData, model);
      }
    }).catchError((error) {
      // Handle the error here
    });
  }

  // void performIntentForNewKid(
  //     newKid.Barcode scanData, BusinessHomeViewModel model) {
  //   return setState(() async {
  //     resultForNewKid = scanData;
  //     if (widget.intent == addBarCode) {
  //       model.productService.setBarcode(scanData.displayValue);
  //     }
  //     // split result on - if first part is login then
  //     // it is a login request
  //     scanToLogin(result: scanData.displayValue);
  //     if (widget.intent == attendance) {
  //       // pull my bio data and asign them to the scan business.
  //       bool isCheckInDone = await ProxyService.isarApi
  //           .checkIn(checkInCode: scanData.displayValue);
  //       if (isCheckInDone) {
  //         showSimpleNotification(
  //           const Text('Check In Successful'),
  //           background: Colors.green,
  //           position: NotificationPosition.bottom,
  //         );
  //         _routerService.pop();
  //       }
  //     }

  //     navigate(scanData.displayValue, model);
  //   });
  // }

  void performIntent(Barcode scanData, HomeViewModel model) {
    return setState(() async {
      result = scanData;
      if (widget.intent == addBarCode) {
        model.productService.setBarcode(scanData.code);
      }
      // split result on - if first part is login then
      // it is a login request
      scanToLogin(result: scanData.code);
      if (widget.intent == attendance) {
        // pull my bio data and asign them to the scan business.
        bool isCheckInDone =
            await ProxyService.isar.checkIn(checkInCode: scanData.code);
        if (isCheckInDone) {
          showSimpleNotification(
            const Text('Check In Successful'),
            background: Colors.green,
            position: NotificationPosition.bottom,
          );
          _routerService.pop();
        }
      }

      navigate(scanData.code, model);
    });
  }

  void navigate(String? code, HomeViewModel model) async {
    if (widget.intent == addBarCode) {
      _routerService.pop();
      return;
    }
    if (widget.intent == selling) {
      Product? product =
          await model.productService.getProductByBarCode(code: code);
      if (product != null) {
        _routerService.navigateTo(SellRoute(product: product));
        return;
      }
      showSimpleNotification(
        const Text("Product not found"),
        background: Colors.green,
        position: NotificationPosition.bottom,
      );
      _routerService.pop();
      return;
    }
    if (widget.intent == attendance) {
      return;
    }
    if (widget.intent == login) {
      return;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
