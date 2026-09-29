import 'package:flipper_models/services/payment_verification_navigator.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_verification_provider.g.dart';

/// Provider for the payment verification service
@riverpod
PaymentVerificationService paymentVerification(Ref ref) {
  return PaymentVerificationService();
}

/// Provider for manually triggering payment verification
@riverpod
Future<PaymentVerificationResponse> verifyPayment(Ref ref) async {
  final service = ref.watch(paymentVerificationProvider);
  return await service.verifyPaymentStatus();
}

/// Provider for forcing payment verification (verify only, no navigation).
@riverpod
Future<PaymentVerificationResponse> forcePaymentVerification(Ref ref) async {
  final service = ref.watch(paymentVerificationProvider);
  return service.forcePaymentVerification();
}

/// The check a "Check subscription" tap performs: verify online, then navigate.
///
/// A provider of its own so tests can swap it for a fake.
final manualPaymentVerificationRunnerProvider =
    Provider<Future<PaymentVerificationResponse> Function()>(
      (ref) => () =>
          PaymentVerificationNavigator.verifyAndNavigate(userInitiated: true),
    );

/// State of the user-requested subscription check (sales / post-signup).
///
/// Idle (`AsyncData(null)`) until [ManualPaymentVerificationNotifier.run] is
/// called, so watching it for a loading label is free of side effects.
///
/// It used to be a `FutureProvider` that *ran* the check — as
/// `userInitiated: true`, which gets past every guard that stops a background
/// check from moving a working user. Merely building the drawer's "Check
/// subscription" row watched it, so every time the drawer opened the app
/// verified and navigated home on its own, landing individual businesses on
/// the unfinished personal screen.
final manualPaymentVerificationProvider =
    AsyncNotifierProvider.autoDispose<
      ManualPaymentVerificationNotifier,
      PaymentVerificationResponse?
    >(ManualPaymentVerificationNotifier.new);

class ManualPaymentVerificationNotifier
    extends AsyncNotifier<PaymentVerificationResponse?> {
  @override
  PaymentVerificationResponse? build() => null;

  /// Runs the check the user asked for. Rethrows so callers can report it.
  Future<PaymentVerificationResponse> run() async {
    state = const AsyncLoading();
    try {
      final response = await ref.read(manualPaymentVerificationRunnerProvider)();
      if (ref.mounted) state = AsyncData(response);
      return response;
    } catch (e, st) {
      if (ref.mounted) state = AsyncError(e, st);
      rethrow;
    }
  }
}
