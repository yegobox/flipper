import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flipper_routing/routes.logger.dart';
import 'abstractions/printer.dart';

class BlueToothPrinterService implements Printer {
  List<int> bytes = [];
  final log = getLogger('BluetoothPrinterService');
  @override
  Future sendToPrinter() async {
    log.i('start priting');
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    // TODOimplements the load bytes from any path.so this can be flexible.
    // use the printing package to generate PDF and save them in known place

    final ByteData data =
        await rootBundle.load('packages/flipper/assets/fliper-logo.png');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image? image = decodeImage(imgBytes) as Image;
    bytes += generator.image(image!);
    bytes += generator.feed(2);
    bytes += generator.cut();

    final String? isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == 'true') {
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print('Print $result');
    } else {
      //Hadnle Not Connected Senario
    }
  }

  @override
  Future<List?> blueTooths() async {
    final List? bluetooth = await BluetoothThermalPrinter.getBluetooths;

    return bluetooth;
  }

  @override
  Future<bool> connect() async {
    //get blueTooths and loop through them and get the mac address and connect to each if possible
    //keep trying until a connection is made
    log.i('attempt to connect to the printer');
    List? bluetooths = await blueTooths();
    if (bluetooths == null) {
      return false;
    }
    for (var bluetooth in bluetooths) {
      List list = bluetooth.split("#");
      String mac = list[1];
      log.i(bluetooth);
      log.i(mac);
      String? connected = await BluetoothThermalPrinter.connectionStatus;
      log.i(connected);
      if (connected == "true") {
        if (kDebugMode) {
          sendToPrinter();
        }
      }
      final String? result = await BluetoothThermalPrinter.connect(mac);
      if (result == 'true') {
        log.i('connected to printer');
        if (kDebugMode) {
          sendToPrinter();
        }
        return true;
      }
    }
    return false;
  }
}
