import 'package:flipper/domain/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'base_model.dart';

class DrawerViewModel extends BaseModel {
  Future<void> desktopLogin({BuildContext context, String code}) async {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final http.Response response =
        await http.post('https://flipper.rw/api/ws', body: {
      'code': code,
      'token': store.state.user.token
    }, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer  ${store.state.user.token}',
    });
  }

  Future<void> scanQR(BuildContext context) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    await desktopLogin(context: context, code: barcodeScanRes);
  }

  Future<void> loginWithQr({BuildContext context}) async {
    setBusy(true);

    await scanQR(context);

    setBusy(false);
  }
}
