import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/bluethooth_service.dart';
import 'package:flipper_services/database_service.dart';
import 'package:flipper_services/shared_state_service.dart';
import 'package:stacked/stacked.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';

class BlueToothViewModel extends ReactiveViewModel {
  final state = locator<SharedStateService>();

  final blue = locator<BlueToothService>();

  Future<void> getBluetooth() async {
    final List bluetooth = await BluetoothThermalPrinter.getBluetooths;
    print('Print $bluetooth');
    state.setBluethoothDevices(devices: bluetooth);
    notifyListeners();
  }

  Future<void> setConnect(String mac) async {
    print(mac);
    final String result = await BluetoothThermalPrinter.connect(mac);
    print('state connected $result');
    if (result == 'true') {
      state.setBluethoothConnected(connected: true);
    } else {
      state.setBluethoothConnected(connected: false);
    }
    notifyListeners();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [state];
}
