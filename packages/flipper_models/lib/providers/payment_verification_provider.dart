import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the payment verification service
final paymentVerificationProvider = Provider<PaymentVerificationService>((ref) {
  return PaymentVerificationService();
});

/// Provider for manually triggering payment verification
final verifyPaymentProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(paymentVerificationProvider);
  return await service.verifyPaymentStatus();
});

/// Provider for forcing payment verification
final forcePaymentVerificationProvider = FutureProvider.autoDispose<void>((ref) async {
  final service = ref.watch(paymentVerificationProvider);
  await service.forcePaymentVerification();
});
