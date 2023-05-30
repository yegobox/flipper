// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding, TestWidgetsFlutterBinding;
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';
import 'package:sensors_plus_platform_interface/src/method_channel_sensors.dart';
import 'package:test/test.dart';

final MethodChannelSensors methodChannel = MethodChannelSensors();

/// A broadcast stream of events from the device accelerometer.
Stream<AccelerometerEvent> get accelerometerEvents {
  return methodChannel.accelerometerEvents;
}

/// A broadcast stream of events from the device gyroscope.
Stream<GyroscopeEvent> get gyroscopeEvents {
  return methodChannel.gyroscopeEvents;
}

/// Events from the device accelerometer with gravity removed.
Stream<UserAccelerometerEvent> get userAccelerometerEvents {
  return methodChannel.userAccelerometerEvents;
}

/// A broadcast stream of events from the device magnetometer.
Stream<MagnetometerEvent> get magnetometerEvents {
  return methodChannel.magnetometerEvents;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('$accelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/accelerometer';
    const sensorData = <double>[1.0, 2.0, 3.0];
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await accelerometerEvents.first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
  });

  test('$gyroscopeEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/gyroscope';
    const sensorData = <double>[3.0, 4.0, 5.0];
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await gyroscopeEvents.first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
  });

  test('$userAccelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/user_accel';
    const sensorData = <double>[6.0, 7.0, 8.0];
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await userAccelerometerEvents.first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
  });

  test('$magnetometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/magnetometer';
    const sensorData = <double>[8.0, 9.0, 10.0];
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await magnetometerEvents.first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
  });
}

void _initializeFakeSensorChannel(String channelName, List<double> sensorData) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
      channelName,
      event,
      (ByteData? reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == 'listen') {
      emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
      emitEvent(null);
      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}
