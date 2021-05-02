import 'dart:async';

import 'package:flutter/services.dart';

class PusherBeams {
  static const MethodChannel _channel = const MethodChannel('pusher_beams');

  static Future<void> start(String instanceId) async {
    await _channel.invokeMethod('start', instanceId);
  }

  static Future<void> addDeviceInterest(String interest) async {
    await _channel.invokeMethod('addDeviceInterest', interest);
  }

  static Future<void> removeDeviceInterest(String interest) async {
    await _channel.invokeMethod('removeDeviceInterest', interest);
  }

  static Future<List<String>> getDeviceInterests() async {
    final List<String>? interests =
        await _channel.invokeListMethod('getDeviceInterests');

    return Future.value(interests);
  }

  static Future<void> setDeviceInterests(List<String> interests) async {
    await _channel.invokeMethod('setDeviceInterests', interests);
  }

  static Future<void> clearDeviceInterests() async {
    await _channel.invokeMethod('clearDeviceInterests');
  }

  static Future<bool> setUserId(String userId, tokenProvider) {
    throw UnimplementedError('This method is still unimplemented');
  }

  static Future<void> clearAllState() async {
    await _channel.invokeMethod('clearAllState');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stop');
  }
}
