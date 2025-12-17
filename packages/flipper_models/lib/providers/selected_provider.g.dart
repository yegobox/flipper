// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedSupplier)
const selectedSupplierProvider = SelectedSupplierProvider._();

final class SelectedSupplierProvider
    extends $NotifierProvider<SelectedSupplier, Branch?> {
  const SelectedSupplierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedSupplierProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedSupplierHash();

  @$internal
  @override
  SelectedSupplier create() => SelectedSupplier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Branch? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Branch?>(value),
    );
  }
}

String _$selectedSupplierHash() => r'78431bb988a113756773cb294bb9c5444d7ba59f';

abstract class _$SelectedSupplier extends $Notifier<Branch?> {
  Branch? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Branch?, Branch?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Branch?, Branch?>, Branch?, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
