// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_payment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isDigitalPaymentEnabled)
const isDigitalPaymentEnabledProvider = IsDigitalPaymentEnabledProvider._();

final class IsDigitalPaymentEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const IsDigitalPaymentEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isDigitalPaymentEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isDigitalPaymentEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isDigitalPaymentEnabled(ref);
  }
}

String _$isDigitalPaymentEnabledHash() =>
    r'89d5c809b134c384feaeb2116e1d0b0c0872c915';
