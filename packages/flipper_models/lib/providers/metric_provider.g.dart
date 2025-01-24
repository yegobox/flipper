// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchMetricsHash() => r'385aa342a0812b4fd5baa38a2a72a962fd33e4c0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchMetrics].
@ProviderFor(fetchMetrics)
const fetchMetricsProvider = FetchMetricsFamily();

/// See also [fetchMetrics].
class FetchMetricsFamily extends Family<AsyncValue<List<Metric>>> {
  /// See also [fetchMetrics].
  const FetchMetricsFamily();

  /// See also [fetchMetrics].
  FetchMetricsProvider call(
    int branchId,
  ) {
    return FetchMetricsProvider(
      branchId,
    );
  }

  @override
  FetchMetricsProvider getProviderOverride(
    covariant FetchMetricsProvider provider,
  ) {
    return call(
      provider.branchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchMetricsProvider';
}

/// See also [fetchMetrics].
class FetchMetricsProvider extends AutoDisposeFutureProvider<List<Metric>> {
  /// See also [fetchMetrics].
  FetchMetricsProvider(
    int branchId,
  ) : this._internal(
          (ref) => fetchMetrics(
            ref as FetchMetricsRef,
            branchId,
          ),
          from: fetchMetricsProvider,
          name: r'fetchMetricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchMetricsHash,
          dependencies: FetchMetricsFamily._dependencies,
          allTransitiveDependencies:
              FetchMetricsFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  FetchMetricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
  }) : super.internal();

  final int branchId;

  @override
  Override overrideWith(
    FutureOr<List<Metric>> Function(FetchMetricsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchMetricsProvider._internal(
        (ref) => create(ref as FetchMetricsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Metric>> createElement() {
    return _FetchMetricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMetricsProvider && other.branchId == branchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchMetricsRef on AutoDisposeFutureProviderRef<List<Metric>> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _FetchMetricsProviderElement
    extends AutoDisposeFutureProviderElement<List<Metric>>
    with FetchMetricsRef {
  _FetchMetricsProviderElement(super.provider);

  @override
  int get branchId => (origin as FetchMetricsProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
