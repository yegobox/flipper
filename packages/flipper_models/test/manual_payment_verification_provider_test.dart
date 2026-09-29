import 'package:flipper_models/providers/payment_verification_provider.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pins that watching the "Check subscription" state never runs the check.
///
/// The regression this guards: `manualPaymentVerificationProvider` was a
/// FutureProvider whose body verified *and navigated* as a user-initiated
/// check. The drawer watched it for its loading label, so opening the drawer
/// moved the user — individual businesses onto the unfinished personal screen.
void main() {
  late int runs;
  late ProviderContainer container;

  setUp(() {
    runs = 0;
    container = ProviderContainer(
      overrides: [
        manualPaymentVerificationRunnerProvider.overrideWithValue(() async {
          runs++;
          return PaymentVerificationResponse(
            result: PaymentVerificationResult.active,
          );
        }),
      ],
    );
    addTearDown(container.dispose);
  });

  test('watching the provider does not run the check', () async {
    final sub = container.listen(manualPaymentVerificationProvider, (_, _) {});
    addTearDown(sub.close);
    await Future<void>.delayed(Duration.zero);

    expect(runs, 0);
    expect(sub.read(), const AsyncData<PaymentVerificationResponse?>(null));
    expect(sub.read().isLoading, isFalse);
  });

  test('run() performs exactly one check and exposes its result', () async {
    final sub = container.listen(manualPaymentVerificationProvider, (_, _) {});
    addTearDown(sub.close);

    final pending = container
        .read(manualPaymentVerificationProvider.notifier)
        .run();
    expect(sub.read().isLoading, isTrue);

    final response = await pending;
    expect(runs, 1);
    expect(response.result, PaymentVerificationResult.active);
    expect(sub.read().value?.result, PaymentVerificationResult.active);
  });

  test('a failed check surfaces as an error and rethrows', () async {
    final failing = ProviderContainer(
      overrides: [
        manualPaymentVerificationRunnerProvider.overrideWithValue(
          () async => throw StateError('offline'),
        ),
      ],
    );
    addTearDown(failing.dispose);
    final sub = failing.listen(manualPaymentVerificationProvider, (_, _) {});
    addTearDown(sub.close);

    await expectLater(
      failing.read(manualPaymentVerificationProvider.notifier).run(),
      throwsStateError,
    );
    expect(sub.read().hasError, isTrue);
  });
}
