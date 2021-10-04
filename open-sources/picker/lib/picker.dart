
import 'dart:async';

import 'package:flutter/services.dart';

class Picker {
  static const MethodChannel _channel = MethodChannel('picker');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
