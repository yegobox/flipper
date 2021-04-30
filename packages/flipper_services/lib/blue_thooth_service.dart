import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

import 'abstractions/printer.dart';

class BlueToothPrinterService implements Printer {
  List<int> bytes = [];

  @override
  Future sendToPrinter() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final ByteData data = await rootBundle.load('assets/logo.png');
    final Uint8List imgBytes = data.buffer.asUint8List();
    final Image? image = decodeImage(imgBytes);
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
  Future<List?> getBluetooths() async {
    final List? bluetooth = await BluetoothThermalPrinter.getBluetooths;
    return bluetooth;
  }

  @override
  Future<bool> connect({required String mac}) async {
    final String? result = await BluetoothThermalPrinter.connect(mac);
    return true;
  }
}
