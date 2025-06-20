// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stockRequestsHash() => r'acd9dbd0d8999808bec5f8463c4f324880d16362';

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

/// See also [stockRequests].
@ProviderFor(stockRequests)
const stockRequestsProvider = StockRequestsFamily();

/// See also [stockRequests].
class StockRequestsFamily extends Family<AsyncValue<List<InventoryRequest>>> {
  /// See also [stockRequests].
  const StockRequestsFamily();

  /// See also [stockRequests].
  StockRequestsProvider call({
    required String status,
    String? search,
  }) {
    return StockRequestsProvider(
      status: status,
      search: search,
    );
  }

  @override
  StockRequestsProvider getProviderOverride(
    covariant StockRequestsProvider provider,
  ) {
    return call(
      status: provider.status,
      search: provider.search,
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
  String? get name => r'stockRequestsProvider';
}

/// See also [stockRequests].
class StockRequestsProvider
    extends AutoDisposeStreamProvider<List<InventoryRequest>> {
  /// See also [stockRequests].
  StockRequestsProvider({
    required String status,
    String? search,
  }) : this._internal(
          (ref) => stockRequests(
            ref as StockRequestsRef,
            status: status,
            search: search,
          ),
          from: stockRequestsProvider,
          name: r'stockRequestsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$stockRequestsHash,
          dependencies: StockRequestsFamily._dependencies,
          allTransitiveDependencies:
              StockRequestsFamily._allTransitiveDependencies,
          status: status,
          search: search,
        );

  StockRequestsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
    required this.search,
  }) : super.internal();

  final String status;
  final String? search;

  @override
  Override overrideWith(
    Stream<List<InventoryRequest>> Function(StockRequestsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StockRequestsProvider._internal(
        (ref) => create(ref as StockRequestsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<InventoryRequest>> createElement() {
    return _StockRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockRequestsProvider &&
        other.status == status &&
        other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StockRequestsRef on AutoDisposeStreamProviderRef<List<InventoryRequest>> {
  /// The parameter `status` of this provider.
  String get status;

  /// The parameter `search` of this provider.
  String? get search;
}

class _StockRequestsProviderElement
    extends AutoDisposeStreamProviderElement<List<InventoryRequest>>
    with StockRequestsRef {
  _StockRequestsProviderElement(super.provider);

  @override
  String get status => (origin as StockRequestsProvider).status;
  @override
  String? get search => (origin as StockRequestsProvider).search;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
