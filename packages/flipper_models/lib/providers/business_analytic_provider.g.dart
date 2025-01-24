// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_analytic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchStockPerformanceHash() =>
    r'e493a3159e414f4487405c8c3307dc4f21add7d5';

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

/// See also [fetchStockPerformance].
@ProviderFor(fetchStockPerformance)
const fetchStockPerformanceProvider = FetchStockPerformanceFamily();

/// See also [fetchStockPerformance].
class FetchStockPerformanceFamily
    extends Family<AsyncValue<List<BusinessAnalytic>>> {
  /// See also [fetchStockPerformance].
  const FetchStockPerformanceFamily();

  /// See also [fetchStockPerformance].
  FetchStockPerformanceProvider call(
    int branchId,
  ) {
    return FetchStockPerformanceProvider(
      branchId,
    );
  }

  @override
  FetchStockPerformanceProvider getProviderOverride(
    covariant FetchStockPerformanceProvider provider,
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
  String? get name => r'fetchStockPerformanceProvider';
}

/// See also [fetchStockPerformance].
class FetchStockPerformanceProvider
    extends AutoDisposeFutureProvider<List<BusinessAnalytic>> {
  /// See also [fetchStockPerformance].
  FetchStockPerformanceProvider(
    int branchId,
  ) : this._internal(
          (ref) => fetchStockPerformance(
            ref as FetchStockPerformanceRef,
            branchId,
          ),
          from: fetchStockPerformanceProvider,
          name: r'fetchStockPerformanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchStockPerformanceHash,
          dependencies: FetchStockPerformanceFamily._dependencies,
          allTransitiveDependencies:
              FetchStockPerformanceFamily._allTransitiveDependencies,
          branchId: branchId,
        );

  FetchStockPerformanceProvider._internal(
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
    FutureOr<List<BusinessAnalytic>> Function(FetchStockPerformanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchStockPerformanceProvider._internal(
        (ref) => create(ref as FetchStockPerformanceRef),
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
  AutoDisposeFutureProviderElement<List<BusinessAnalytic>> createElement() {
    return _FetchStockPerformanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchStockPerformanceProvider && other.branchId == branchId;
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
mixin FetchStockPerformanceRef
    on AutoDisposeFutureProviderRef<List<BusinessAnalytic>> {
  /// The parameter `branchId` of this provider.
  int get branchId;
}

class _FetchStockPerformanceProviderElement
    extends AutoDisposeFutureProviderElement<List<BusinessAnalytic>>
    with FetchStockPerformanceRef {
  _FetchStockPerformanceProviderElement(super.provider);

  @override
  int get branchId => (origin as FetchStockPerformanceProvider).branchId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
