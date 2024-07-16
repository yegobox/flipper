# device_type

A new Flutter plugin used to determine whether the device is a Phone, Phablet, Tablet, or a Larger Device like a Desktop.

# Essential Guide

![](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*ZIDOfmIgw40x9vvzmx_KKw.png)

[Flutter Device Type Medium](https://medium.com/@vinothmuthu/flutter-device-type-the-essential-guide-b294f8e758eb)

## Installation

1. Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  device_type: ^1.0.0-dev
```

2. Import the package and use it in your Flutter App.
```dart
import 'package:device_type/device_type.dart';


String _getDeviceType(BuildContext context) {
  return DeviceType.getDeviceType(context);
}

@override
Widget build(BuildContext context) {
  deviceType = _getDeviceType(context);
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin Device Type'),
      ),
      body: Center(
        child: Text('Running on: $deviceType\n'),
      ),
    ),
  );
}
```
## Package Documentation
[Example of using the library](https://pub.dev/documentation/device_type/latest) to determine whether the device is a Phone, Phablet, Tablet, or a Larger Device.


## Find Package at pub.dev
[Example of using the library](https://pub.dev/packages/device_type) to determine whether the device is a Phone, Phablet, Tablet, or a Larger Device.
