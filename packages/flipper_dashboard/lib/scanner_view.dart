import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:localize/localize.dart';
import 'package:flipper_services/proxy.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannView extends StatefulWidget {
  const ScannView({Key? key, this.intent = 'selling'}) : super(key: key);
  final String intent;

  @override
  State<StatefulWidget> createState() => _ScannViewState();
}

class _ScannViewState extends State<ScannView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final log = getLogger('_ScannViewState');

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
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      viewModelBuilder: () => BusinessHomeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 392.7,
                child: _buildQrView(context, model),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height / 1 - 120,
                left: MediaQuery.of(context).size.width / 2 - 30,
                right: MediaQuery.of(context).size.width / 2 - 20,
                child: IconButton(
                  iconSize: 40,
                  onPressed: () => ProxyService.nav.back(),
                  icon: CircleAvatar(
                    child: Icon(
                      Icons.close,
                      // size: 40,
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

  Widget _buildQrView(BuildContext context, BusinessHomeViewModel model) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        _onQRViewCreated(controller, model);
      },
      overlay: QrScannerOverlayShape(
          borderColor: Color(0xFF375778),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log.i('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  void QrLogin({required String? result}) {
    if (result != null && result.contains('-')) {
      final split = result.split('-');
      if (split.length > 1 && split[0] == 'login') {
        /// send the login detail to pubnub
        String userId = ProxyService.box.read(key: 'userId');
        int businessId = ProxyService.box.read(key: 'businessId');
        int branchId = ProxyService.box.read(key: 'branchId');
        String phone = ProxyService.box.read(key: 'userPhone');
        ProxyService.loginService.publish(loginDetails: {
          // this avoid users to log in to unintended device!
          'channel': split[1],
          'userId': userId,
          'businessId': businessId,
          'branchId': branchId,
          'phone': phone,
        });
      }
    }
  }

  void _onQRViewCreated(
      QRViewController controller, BusinessHomeViewModel model) {
    setState(() {
      this.controller = controller;
    });
    result = null;
    if (kDebugMode) {
      model.productService.setBarcode('11232532');
      navigate('11232532', model);
    }

    controller.scannedDataStream.listen((scanData) {
      if (result == null) {
        setState(() async {
          result = scanData;
          if (widget.intent == addBarCode) {
            model.productService.setBarcode(scanData.code);
          }
          // split result on - if first part is login then
          // it is a login request
          QrLogin(result: scanData.code);
          if (widget.intent == attendance) {
            // pull my bio data and asign them to the scan business.
            bool isCheckInDone =
                await ProxyService.api.checkIn(checkInCode: scanData.code);
            if (isCheckInDone) {
              showSimpleNotification(
                Text('Check In Successful'),
                background: Colors.green,
                position: NotificationPosition.bottom,
              );
              ProxyService.nav.back();
            }
          }

          navigate(scanData.code, model);
        });
      }
    });
  }

  void navigate(String? code, BusinessHomeViewModel model) async {
    if (widget.intent == addBarCode) {
      ProxyService.nav.back();
      return;
    }
    if (widget.intent == selling) {
      ProductSync? product =
          await model.productService.getProductByBarCode(code: code);
      if (product != null) {
        ProxyService.nav.navigateTo(Routes.sell,
            arguments: SellArguments(product: product));
        return;
      }
      showSimpleNotification(
        Text(FLocalization.of(context).productNotFound),
        background: Colors.green,
        position: NotificationPosition.bottom,
      );
      ProxyService.nav.back();
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
