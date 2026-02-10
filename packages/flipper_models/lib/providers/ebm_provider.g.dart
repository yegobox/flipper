// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that fetches the VAT enabled status from the EBM configuration

@ProviderFor(ebmVatEnabled)
const ebmVatEnabledProvider = EbmVatEnabledProvider._();

/// Provider that fetches the VAT enabled status from the EBM configuration

final class EbmVatEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider that fetches the VAT enabled status from the EBM configuration
  const EbmVatEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ebmVatEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ebmVatEnabledHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return ebmVatEnabled(ref);
  }
}

String _$ebmVatEnabledHash() => r'd05cc6b4204816346879154fd475f5d016d2227d';
