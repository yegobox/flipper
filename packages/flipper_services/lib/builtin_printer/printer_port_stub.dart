import 'dart:typed_data';

import 'package:flipper_services/builtin_printer/printer_port_types.dart';

export 'package:flipper_services/builtin_printer/printer_port_types.dart';

/// Web build: there are no printer ports to drive.
bool get printerPortsSupported => false;

List<SerialPortInfo> describeSerialPorts() => const [];

List<UsbPrinterInfo> listUsbPrinters() => const [];

class PrinterPortWorker {
  static Future<PrinterPortWorker?> spawn() async => null;

  Future<void> write(PrinterTarget target, Uint8List bytes) async {}

  Future<int?> query(
    PrinterTarget target,
    Uint8List bytes, {
    int timeoutMs = 400,
  }) async => null;

  Future<void> close() async {}

  void dispose() {}
}
