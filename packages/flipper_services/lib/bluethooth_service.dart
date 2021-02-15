library flipper_services;

import 'dart:async';

// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flipper_models/printable.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
// import 'package:flipper_services/services/shared_state_service.dart';
// import 'package:flipper_services/locator.dart';

// import 'locator.dart';

class BlueToothService {
  // ignore: always_specify_types

  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  // final Logger log = Logging.getLogger('Bluetooth service ....');
  // final state = locator<SharedStateService>();

  Future<void> printTicket({@required List<Printable> printables}) async {
    final String isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == 'true') {
      final Ticket ticket = await getTicket(printables: printables);
      final result = await BluetoothThermalPrinter.writeBytes(ticket.bytes);
      print('Print $result');
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<void> printGraphics() async {
    final String isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == 'true') {
      final Ticket ticket = await getGraphicsTicket();
      final result = await BluetoothThermalPrinter.writeBytes(ticket.bytes);
      print('Print $result');
    } else {
      //Hadnle Not Connected Senario
    }
  }

  Future<Ticket> getGraphicsTicket() async {
    final CapabilityProfile profile = await CapabilityProfile.load();
    final Ticket ticket = Ticket(PaperSize.mm80, profile);

    // Print QR Code using native function
    ticket.qrcode('example.com');

    ticket.hr();

    // Print Barcode using native function
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    ticket.barcode(Barcode.upcA(barData));

    ticket.cut();

    return ticket;
  }

  Future<Ticket> getTicket({@required List<Printable> printables}) async {
    final CapabilityProfile profile = await CapabilityProfile.load();
    final Ticket ticket = Ticket(PaperSize.mm80, profile);
    ticket.text(ProxyService.sharedState.business.name,
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    // ticket.text(
    //   '+250783054874', //(this is a phone number)
    //   styles: const PosStyles(align: PosAlign.center),
    // );
    // ticket.hr();
    var total = 0.0;
    for (Printable printable in printables) {
      total += printable.quantity * printable.price;
      ticket.row([
        PosColumn(
          text: printable.name +
              ' * ' +
              printable.quantity.toInt().toString() +
              '   ' +
              printable.unit,
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        PosColumn(
          text: printable.price.toString(),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        )
      ]);
    }

    ticket.row([
      PosColumn(
        text: 'TOTAL',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: total.toInt().toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ),
      )
    ]);

    // ticket.hr(ch: '=', linesAfter: 1);

    final DateTime now = DateTime.now();
    final DateTime date = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    // ticket.feed(2);
    ticket.text('Thank you!',
        styles: const PosStyles(align: PosAlign.center, bold: true));

    ticket.text(date.toLocal().toString(),
        styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    ticket.text('Note: Goods once sold will not be taken back or exchanged.',
        styles: const PosStyles(align: PosAlign.center, bold: false));
    ticket.cut();
    return ticket;
  }
}
