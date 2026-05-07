// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimistic_cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OptimisticCart)
const optimisticCartProvider = OptimisticCartProvider._();

final class OptimisticCartProvider
    extends $NotifierProvider<OptimisticCart, OptimisticCartState> {
  const OptimisticCartProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'optimisticCartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$optimisticCartHash();

  @$internal
  @override
  OptimisticCart create() => OptimisticCart();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OptimisticCartState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OptimisticCartState>(value),
    );
  }
}

String _$optimisticCartHash() => r'156d03ab492bcfc05b62bd84c184ebc54e0ba887';

abstract class _$OptimisticCart extends $Notifier<OptimisticCartState> {
  OptimisticCartState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<OptimisticCartState, OptimisticCartState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OptimisticCartState, OptimisticCartState>,
              OptimisticCartState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
