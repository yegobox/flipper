import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_models/product.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper/localization.dart';
import 'package:flipper_services/proxy.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:io';
import 'package:flipper_models/view_models/business_home_viewmodel.dart';
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
          appBar: CustomAppBar(
            onPop: () async {
              ProxyService.nav.back();
            },
            title: '',
            disableButton: true,
            showActionButton: false,
            onPressedCallback: () async {
              ProxyService.nav.back();
            },
            icon: Icons.close,
            multi: 3,
            bottomSpacer: 50,
          ),
          body: Column(
            children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context, model))
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
          borderColor: Colors.red,
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
        setState(() {
          result = scanData;
          model.productService.setBarcode(scanData.code);
          navigate(scanData.code, model);
        });
      }
    });
  }

  void navigate(String code, BusinessHomeViewModel model) async {
    if (widget.intent == addBarCode) {
      ProxyService.nav.back();
      return;
    }
    if (widget.intent == selling) {
      Product? product =
          await model.productService.getProductByBarCode(code: code);
      if (product != null) {
        ProxyService.nav.navigateTo(Routes.sell,
            arguments: SellArguments(product: product));
        return;
      }
      showSimpleNotification(
        Text(Localization.of(context)!.productNotFound),
        background: Colors.green,
        position: NotificationPosition.bottom,
      );
      ProxyService.nav.back();
      return;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
