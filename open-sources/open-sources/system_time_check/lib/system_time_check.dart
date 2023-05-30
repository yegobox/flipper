import 'dart:async';

import 'package:flutter/services.dart';

class SystemTimeCheck {
  static const MethodChannel _channel = MethodChannel('system_time_check');

  static Future<bool?> get isSystemTimeAutomatic async {
    final bool? isSystemTimeAutomatic =
        await _channel.invokeMethod('isSystemTimeAutomatic');
    return isSystemTimeAutomatic;
  }

  static Future<bool?> get isSystemTimeAutomaticDebug async {
    final bool? isSystemTimeAutomatic =
        await _channel.invokeMethod('isSystemTimeAutomaticDebug');
    return isSystemTimeAutomatic;
  }
}
