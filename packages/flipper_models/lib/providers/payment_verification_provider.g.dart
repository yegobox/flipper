// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the payment verification service

@ProviderFor(paymentVerification)
const paymentVerificationProvider = PaymentVerificationProvider._();

/// Provider for the payment verification service

final class PaymentVerificationProvider
    extends
        $FunctionalProvider<
          PaymentVerificationService,
          PaymentVerificationService,
          PaymentVerificationService
        >
    with $Provider<PaymentVerificationService> {
  /// Provider for the payment verification service
  const PaymentVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentVerificationHash();

  @$internal
  @override
  $ProviderElement<PaymentVerificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PaymentVerificationService create(Ref ref) {
    return paymentVerification(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaymentVerificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaymentVerificationService>(value),
    );
  }
}

String _$paymentVerificationHash() =>
    r'd9353785f1c484a9fec40fc7b9cc7a99c093ce87';

/// Provider for manually triggering payment verification

@ProviderFor(verifyPayment)
const verifyPaymentProvider = VerifyPaymentProvider._();

/// Provider for manually triggering payment verification

final class VerifyPaymentProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaymentVerificationResponse>,
          PaymentVerificationResponse,
          FutureOr<PaymentVerificationResponse>
        >
    with
        $FutureModifier<PaymentVerificationResponse>,
        $FutureProvider<PaymentVerificationResponse> {
  /// Provider for manually triggering payment verification
  const VerifyPaymentProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyPaymentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyPaymentHash();

  @$internal
  @override
  $FutureProviderElement<PaymentVerificationResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaymentVerificationResponse> create(Ref ref) {
    return verifyPayment(ref);
  }
}

String _$verifyPaymentHash() => r'463b7d0bab65e08288e436d021f283cfa124fdc5';

/// Provider for forcing payment verification

@ProviderFor(forcePaymentVerification)
const forcePaymentVerificationProvider = ForcePaymentVerificationProvider._();

/// Provider for forcing payment verification

final class ForcePaymentVerificationProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Provider for forcing payment verification
  const ForcePaymentVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forcePaymentVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forcePaymentVerificationHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return forcePaymentVerification(ref);
  }
}

String _$forcePaymentVerificationHash() =>
    r'7a890ae6ebc168065408e7702ee00a72418a8d43';
