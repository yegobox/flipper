import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('customerNameControllerProvider disposes its controller once', () {
    final container = ProviderContainer();
    final controller = container.read(customerNameControllerProvider)
      ..text = 'Walk-in';

    // The provider owns the controller. A second dispose throws "used after
    // being disposed", which the container reports as an uncaught error.
    container.dispose();

    expect(() => controller.addListener(() {}), throwsA(isA<FlutterError>()));
  });
}
