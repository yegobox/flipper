import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flipper/util/logger.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

class BlueToothService {
  // ignore: always_specify_types
  final PublishSubject _blueConnected = PublishSubject();
  final Logger log = Logging.getLogger('Firestore service ....');
  final BluetoothPrint _bluetoothPrint = BluetoothPrint.instance;

  // ignore: sort_constructors_first
  BlueToothService(){
    connectToAnyBlueToothAvailable();
  }
  // ignore: always_specify_types
  Future connectToAnyBlueToothAvailable() async {
    _bluetoothPrint.scanResults.listen((List<BluetoothDevice> devices) async {
      if (devices[0].connected) {
        // TODO(richard): add analytics here so we know who is using the feature.
        log.i('connected to device' +
            _bluetoothPrint.connect(devices[0]).toString());
        await _bluetoothPrint.connect(devices[0]);
      }
    });

    // ignore: always_specify_types
    _blueConnected?.listen((connected) {
      log.i(
          'connected to bluetooth device'); // a simple toast to show a client that flipper found a bluethooth device to print to.
    });
  }

  Future<void> initBluetooth() async {
    //  start scanning the available bluetooth
    _bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    // bool isConnected=await bluetoothPrint.isConnected;
    _bluetoothPrint.state.listen((state) {
      // print('cur device status: $state');
      switch (state) {
        case BluetoothPrint.CONNECTED:
          _blueConnected.add(true);
          break;
        case BluetoothPrint.DISCONNECTED:
          _blueConnected.add(false);
          break;
        default:
          break;
      }
    });

    // blueConnected.add(isConnected);
  }

  Future<void> printReceipt(
      {String businessName = 'Your Business Name',
      String billNo = 'Bill No. 1',
      String cashier = 'admin',
      String todayDate = 'Sept 10,2020',
      String time = '01:49 PM',
      List<String> items}) async {
    Map<String, dynamic> config = Map();
    List<LineText> list = List();
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Your Business Name',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
        underline: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Bill No. 1',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Cashier: admin',
        weight: 0,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Sept 10,2020',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '01:49 PM',
        weight: 0,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '----------------------',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'ITEM',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Qty',
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'RATE',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Total',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '----------------------',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Item 1',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '1',
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '100',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '1/1',
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Grand Total = 100',
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(linefeed: 1));

    await _bluetoothPrint.printReceipt(config, list);
  }
}
