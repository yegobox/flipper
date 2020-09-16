
import 'package:rxdart/rxdart.dart';

class ProxyService {
  // BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  // ignore: always_specify_types
  PublishSubject isBlueToothConnected = PublishSubject(); 


  // ignore: always_specify_types
  PublishSubject loading = PublishSubject();


  bool _connected = false;
  // BluetoothDevice _device;

   // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initBluetooth() async {
  //   bluetoothPrint.startScan(timeout: Duration(seconds: 4));

  //   bluetoothPrint.state.listen((state) {
  //     switch (state) {
  //       case BluetoothPrint.CONNECTED:
  //         isBlueToothConnected.add(true);
  //         break;
  //       case BluetoothPrint.DISCONNECTED:
  //          isBlueToothConnected.add(true);
  //         break;
  //       default:
  //         break;
  //     }
  //   });

  // } 
}
final ProxyService proxyService = ProxyService();