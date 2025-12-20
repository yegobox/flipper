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

/// Provider for forcing payment verification
@riverpod
Future<void> forcePaymentVerification(Ref ref) async {
  final service = ref.watch(paymentVerificationProvider);
  await service.forcePaymentVerification();
}
