import 'dart:developer';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pubnub/pubnub.dart';
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

class ScannView extends StatefulHookConsumerWidget {
  const ScannView({
    Key? key,
    this.intent = 'selling',
    this.useLatestImplementation = false,
  }) : super(key: key);

  final String intent;
  final bool useLatestImplementation;

  @override
  ScannViewState createState() => ScannViewState();
}

class ScannViewState extends ConsumerState<ScannView> {
  Barcode? result;
  List<Offset> points = [];
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _routerService = locator<RouterService>();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
            children: [
              _buildQrView(context, model),
              _buildCloseButton(context),
              _buildFlashButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height / 2 - (40 - 0.5 * 80) - 340,
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
    );
  }

  Widget _buildFlashButton(BuildContext context) {
    return Positioned(
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
            icon: Icon(
              snapshot.data == false
                  ? Icons.lightbulb_outline
                  : Icons.lightbulb_outline,
              color: snapshot.data == false ? Colors.white : Colors.blue,
            ),
          );
        },
      ),
    );
  }

  Widget _buildQrView(BuildContext context, CoreViewModel model) {
    var scanArea = MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400
        ? 250.0
        : 300.0;

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
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void scanToLogin({required String? result}) {
    log(result ?? "", name: 'logiiinnnn');
    if (result != null && result.contains('-')) {
      final split = result.split('-');
      if (split.length > 1 && split[0] == 'login') {
        _publishLoginDetails(split[1]);
      }
    }
  }

  Future<void> _publishLoginDetails(String channel) async {
    int userId = ProxyService.box.getUserId()!;
    int businessId = ProxyService.box.getBusinessId()!;
    int branchId = ProxyService.box.getBranchId()!;
    String phone = ProxyService.box.getUserPhone()!;
    String defaultApp = ProxyService.box.getDefaultApp();

    PublishResult result = await ProxyService.event.publish(loginDetails: {
      'channel': channel,
      'userId': userId,
      'businessId': businessId,
      'branchId': branchId,
      'phone': phone,
      'defaultApp': defaultApp,
      'deviceName': Platform.operatingSystem,
      'deviceVersion': Platform.operatingSystemVersion,
      'linkingCode': randomNumber().toString(),
    });
    if (!result.isError) {
      HapticFeedback.lightImpact();
      showToast(context, 'Login success');
      _routerService.back();
    } else {
      showToast(context, 'Login failed');
      _routerService.back();
    }
  }

  void _onQRViewCreated(QRViewController givenController, CoreViewModel model) {
    this.controller = givenController;

    result = null;

    if (kDebugMode) {
      model.productService.setBarcode('11232532');
      navigate('11232532', model);
    }

    controller?.scannedDataStream.first.then((scanData) {
      if (result == null) {
        performIntent(scanData, model);
      }
    }).catchError((error) {
      // Handle the error here
    });
  }

  Future<void> performIntent(Barcode scanData, CoreViewModel model) async {
    setState(() {
      result = scanData;
    });
    if (widget.intent == BARCODE) {
      model.productService.setBarcode(scanData.code);
    }
    scanToLogin(result: scanData.code);
    if (widget.intent == ATTENDANCE) {
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
  }

  void navigate(String? code, CoreViewModel model) async {
    if (widget.intent == BARCODE) {
      _routerService.pop();
      return;
    }
    if (widget.intent == SELLING) {
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
    if (widget.intent == ATTENDANCE) {
      return;
    }
    if (widget.intent == LOGIN) {
      return;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
