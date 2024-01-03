import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

abstract class Device {
  Future<String?> getDeviceId();
}

class DeviceIdService implements Device {
  @override
  Future<String?> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    } else if (Platform.isWindows) {
      var androidDeviceInfo = await deviceInfo.windowsInfo;
      return androidDeviceInfo.deviceId;
    } else if (Platform.isLinux) {
      var androidDeviceInfo = await deviceInfo.linuxInfo;
      return androidDeviceInfo.machineId;
    }
    return null; // Return null for unsupported platforms
  }
}

void main() async {
  var deviceIdService = DeviceIdService();
  var deviceId = await deviceIdService.getDeviceId();
  print('Device ID: $deviceId');
}
