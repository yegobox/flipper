import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'device_type_method_channel.dart';

abstract class DeviceTypePlatform extends PlatformInterface {
  /// Constructs a DeviceTypePlatform.
  DeviceTypePlatform() : super(token: _token);

  static final Object _token = Object();

  static DeviceTypePlatform _instance = MethodChannelDeviceType();

  /// The default instance of [DeviceTypePlatform] to use.
  ///
  /// Defaults to [MethodChannelDeviceType].
  static DeviceTypePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DeviceTypePlatform] when
  /// they register themselves.
  static set instance(DeviceTypePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
