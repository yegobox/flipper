// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimistic_cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OptimisticCart)
final optimisticCartProvider = OptimisticCartProvider._();

final class OptimisticCartProvider
    extends $NotifierProvider<OptimisticCart, OptimisticCartState> {
  OptimisticCartProvider._()
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

String _$optimisticCartHash() => r'4590f3e642dcf5ab69a97c35467f7e54440c77f7';

abstract class _$OptimisticCart extends $Notifier<OptimisticCartState> {
  OptimisticCartState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OptimisticCartState, OptimisticCartState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OptimisticCartState, OptimisticCartState>,
              OptimisticCartState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
