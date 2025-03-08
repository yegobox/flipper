import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';

void main() {
  group('PayButtonState Provider', () {
    late ProviderContainer container;
    late PayButtonState notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(payButtonStateProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should have all buttons set to false (not loading)',
        () {
      final state = container.read(payButtonStateProvider);
      expect(state[ButtonType.pay], false);
      expect(state[ButtonType.completeNow], false);
    });

    test('startLoading should set specific button to true', () {
      notifier.startLoading(ButtonType.pay);
      expect(container.read(payButtonStateProvider)[ButtonType.pay], true);
      expect(container.read(payButtonStateProvider)[ButtonType.completeNow],
          false);
    });

    test('stopLoading should set specific button to false', () {
      notifier.startLoading(ButtonType.pay);
      expect(container.read(payButtonStateProvider)[ButtonType.pay], true);

      notifier.stopLoading(ButtonType.pay);
      expect(container.read(payButtonStateProvider)[ButtonType.pay], false);
    });

    test('stopLoading with no arguments should set all buttons to false', () {
      notifier.startLoading(ButtonType.pay);
      notifier.startLoading(ButtonType.completeNow);
      expect(container.read(payButtonStateProvider)[ButtonType.pay], true);
      expect(
          container.read(payButtonStateProvider)[ButtonType.completeNow], true);

      notifier.stopLoading();
      expect(container.read(payButtonStateProvider)[ButtonType.pay], false);
      expect(container.read(payButtonStateProvider)[ButtonType.completeNow],
          false);
    });

    test('isLoading should return correct state', () {
      expect(notifier.isLoading(ButtonType.pay), false);
      notifier.startLoading(ButtonType.pay);
      expect(notifier.isLoading(ButtonType.pay), true);
    });
  });

  group('SelectedButtonType Provider', () {
    late ProviderContainer container;
    late SelectedButtonType notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(selectedButtonTypeProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be ButtonType.pay', () {
      expect(container.read(selectedButtonTypeProvider), ButtonType.pay);
    });

    test('setButtonType should update state correctly', () {
      notifier.setButtonType(ButtonType.completeNow);
      expect(
          container.read(selectedButtonTypeProvider), ButtonType.completeNow);
    });
  });
}
