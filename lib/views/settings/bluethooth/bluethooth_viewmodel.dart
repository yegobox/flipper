
import 'package:flipper/locator.dart';
import 'package:flipper/services/bluethooth_service.dart';
import 'package:flipper/services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';


class BlueThoothViewModel extends ReactiveViewModel{
   final state = locator<SharedStateService>();

  final blue = locator<BlueToothService>();
  
   Future<void> getBluetooth() async {
    final List bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print('Print $bluetooths');
      state.setBluethoothDevices(devices:bluetooths);
    notifyListeners();
  }

  Future<void> setConnect(String mac) async {
    print(mac);
    final String result = await BluetoothThermalPrinter.connect(mac);
    print('state conneected $result');
    if (result == 'true') {
        state.setBluethoothConnected(connected:true);
    }else{
      state.setBluethoothConnected(connected:false);
    }
     notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [state];

}