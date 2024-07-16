import 'package:flutter_test/flutter_test.dart';

class MockDeviceTypePlatform {
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {}
