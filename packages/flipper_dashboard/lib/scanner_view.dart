import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:developer';
import 'dart:io';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// import 'package:flutter_qr_reader/qrcode_reader_view.dart';

// class ScannView extends StatefulWidget {
//   ScannView({Key? key}) : super(key: key);

//   @override
//   _ScannViewState createState() => new _ScannViewState();
// }

// class _ScannViewState extends State<ScannView> {
//   GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body: QrcodeReaderView(
//         key: _key,
//         onScan: onScan,
//         headerWidget: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//         ),
//       ),
//     );
//   }

//   Future onScan(String? data) async {
//     await showCupertinoDialog(
//       context: context,
//       builder: (context) {
//         return CupertinoAlertDialog(
//           title: Text("扫码结果"),
//           content: Text(data!),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               child: Text("确认"),
//               onPressed: () => Navigator.pop(context),
//             )
//           ],
//         );
//       },
//     );
//     _key.currentState!.startScan();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }

class ScannView extends StatefulWidget {
  const ScannView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannViewState();
}

class _ScannViewState extends State<ScannView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
        rightActionButtonName: 'Save',
        icon: Icons.close,
        multi: 3,
        bottomSpacer: 50,
      ),
      body: Column(
        children: <Widget>[Expanded(flex: 4, child: _buildQrView(context))],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
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
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        showSimpleNotification(
          Text(scanData.code),
          background: Colors.green,
          position: NotificationPosition.bottom,
        );
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
