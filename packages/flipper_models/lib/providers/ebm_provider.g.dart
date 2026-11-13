// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ebm_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider that fetches the VAT enabled status from the EBM configuration

@ProviderFor(ebmVatEnabled)
final ebmVatEnabledProvider = EbmVatEnabledProvider._();

/// Provider that fetches the VAT enabled status from the EBM configuration

final class EbmVatEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider that fetches the VAT enabled status from the EBM configuration
  EbmVatEnabledProvider._()
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

String _$ebmVatEnabledHash() => r'808a8832c3d4d84c57f9f2ee92f1d140e5488fbf';
