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
    // TODO: implements the load bytes from any path.so this can be flexible.
    // use the printing package to generate PDF and save them in known place
    // on click of print we check the device, if is windows,macos then use default printing
    // which deal with device connected printer
    // if it is android and or ios we check bluetooth device printer and print on in.
    // https://flutteragency.com/how-to-read-bytes-of-a-local-image-file-in-flutter/
    final ByteData data = await rootBundle.load('assets/flipper-logo.png');
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
