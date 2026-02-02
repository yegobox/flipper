// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimistic_order_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// A simple state provider to track the order count optimistically.
/// This increments immediately when an item is added, providing instant UI feedback.
/// The actual count from the stream will eventually sync and correct any discrepancies.

@ProviderFor(OptimisticOrderCount)
const optimisticOrderCountProvider = OptimisticOrderCountProvider._();

/// A simple state provider to track the order count optimistically.
/// This increments immediately when an item is added, providing instant UI feedback.
/// The actual count from the stream will eventually sync and correct any discrepancies.
final class OptimisticOrderCountProvider
    extends $NotifierProvider<OptimisticOrderCount, int> {
  /// A simple state provider to track the order count optimistically.
  /// This increments immediately when an item is added, providing instant UI feedback.
  /// The actual count from the stream will eventually sync and correct any discrepancies.
  const OptimisticOrderCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'optimisticOrderCountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$optimisticOrderCountHash();

  @$internal
  @override
  OptimisticOrderCount create() => OptimisticOrderCount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$optimisticOrderCountHash() =>
    r'3dedcbb677479a7921371375891d30ce754b1402';

/// A simple state provider to track the order count optimistically.
/// This increments immediately when an item is added, providing instant UI feedback.
/// The actual count from the stream will eventually sync and correct any discrepancies.

abstract class _$OptimisticOrderCount extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
