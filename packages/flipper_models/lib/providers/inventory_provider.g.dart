// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expiredItemsHash() => r'07adc8cc52a483b2e7aa6c292ed3208e3ced774b';

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

abstract class _$ExpiredItems
    extends BuildlessAutoDisposeAsyncNotifier<List<InventoryItem>> {
  late final int? branchId;
  late final int? daysToExpiry;
  late final int? limit;

  FutureOr<List<InventoryItem>> build({
    int? branchId,
    int? daysToExpiry,
    int? limit,
  });
}

/// Provider for inventory-related data
///
/// Copied from [ExpiredItems].
@ProviderFor(ExpiredItems)
const expiredItemsProvider = ExpiredItemsFamily();

/// Provider for inventory-related data
///
/// Copied from [ExpiredItems].
class ExpiredItemsFamily extends Family<AsyncValue<List<InventoryItem>>> {
  /// Provider for inventory-related data
  ///
  /// Copied from [ExpiredItems].
  const ExpiredItemsFamily();

  /// Provider for inventory-related data
  ///
  /// Copied from [ExpiredItems].
  ExpiredItemsProvider call({
    int? branchId,
    int? daysToExpiry,
    int? limit,
  }) {
    return ExpiredItemsProvider(
      branchId: branchId,
      daysToExpiry: daysToExpiry,
      limit: limit,
    );
  }

  @override
  ExpiredItemsProvider getProviderOverride(
    covariant ExpiredItemsProvider provider,
  ) {
    return call(
      branchId: provider.branchId,
      daysToExpiry: provider.daysToExpiry,
      limit: provider.limit,
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
  String? get name => r'expiredItemsProvider';
}

/// Provider for inventory-related data
///
/// Copied from [ExpiredItems].
class ExpiredItemsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ExpiredItems, List<InventoryItem>> {
  /// Provider for inventory-related data
  ///
  /// Copied from [ExpiredItems].
  ExpiredItemsProvider({
    int? branchId,
    int? daysToExpiry,
    int? limit,
  }) : this._internal(
          () => ExpiredItems()
            ..branchId = branchId
            ..daysToExpiry = daysToExpiry
            ..limit = limit,
          from: expiredItemsProvider,
          name: r'expiredItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$expiredItemsHash,
          dependencies: ExpiredItemsFamily._dependencies,
          allTransitiveDependencies:
              ExpiredItemsFamily._allTransitiveDependencies,
          branchId: branchId,
          daysToExpiry: daysToExpiry,
          limit: limit,
        );

  ExpiredItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.daysToExpiry,
    required this.limit,
  }) : super.internal();

  final int? branchId;
  final int? daysToExpiry;
  final int? limit;

  @override
  FutureOr<List<InventoryItem>> runNotifierBuild(
    covariant ExpiredItems notifier,
  ) {
    return notifier.build(
      branchId: branchId,
      daysToExpiry: daysToExpiry,
      limit: limit,
    );
  }

  @override
  Override overrideWith(ExpiredItems Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExpiredItemsProvider._internal(
        () => create()
          ..branchId = branchId
          ..daysToExpiry = daysToExpiry
          ..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        daysToExpiry: daysToExpiry,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ExpiredItems, List<InventoryItem>>
      createElement() {
    return _ExpiredItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpiredItemsProvider &&
        other.branchId == branchId &&
        other.daysToExpiry == daysToExpiry &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, daysToExpiry.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExpiredItemsRef
    on AutoDisposeAsyncNotifierProviderRef<List<InventoryItem>> {
  /// The parameter `branchId` of this provider.
  int? get branchId;

  /// The parameter `daysToExpiry` of this provider.
  int? get daysToExpiry;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _ExpiredItemsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ExpiredItems,
        List<InventoryItem>> with ExpiredItemsRef {
  _ExpiredItemsProviderElement(super.provider);

  @override
  int? get branchId => (origin as ExpiredItemsProvider).branchId;
  @override
  int? get daysToExpiry => (origin as ExpiredItemsProvider).daysToExpiry;
  @override
  int? get limit => (origin as ExpiredItemsProvider).limit;
}

String _$nearExpiryItemsHash() => r'102df7adab05ea8bb040692f2a380bd9c80fe368';

abstract class _$NearExpiryItems
    extends BuildlessAutoDisposeAsyncNotifier<List<InventoryItem>> {
  late final int? branchId;
  late final int daysToExpiry;
  late final int? limit;

  FutureOr<List<InventoryItem>> build({
    int? branchId,
    int daysToExpiry = 7,
    int? limit,
  });
}

/// Provider for near expiry items
///
/// Copied from [NearExpiryItems].
@ProviderFor(NearExpiryItems)
const nearExpiryItemsProvider = NearExpiryItemsFamily();

/// Provider for near expiry items
///
/// Copied from [NearExpiryItems].
class NearExpiryItemsFamily extends Family<AsyncValue<List<InventoryItem>>> {
  /// Provider for near expiry items
  ///
  /// Copied from [NearExpiryItems].
  const NearExpiryItemsFamily();

  /// Provider for near expiry items
  ///
  /// Copied from [NearExpiryItems].
  NearExpiryItemsProvider call({
    int? branchId,
    int daysToExpiry = 7,
    int? limit,
  }) {
    return NearExpiryItemsProvider(
      branchId: branchId,
      daysToExpiry: daysToExpiry,
      limit: limit,
    );
  }

  @override
  NearExpiryItemsProvider getProviderOverride(
    covariant NearExpiryItemsProvider provider,
  ) {
    return call(
      branchId: provider.branchId,
      daysToExpiry: provider.daysToExpiry,
      limit: provider.limit,
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
  String? get name => r'nearExpiryItemsProvider';
}

/// Provider for near expiry items
///
/// Copied from [NearExpiryItems].
class NearExpiryItemsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    NearExpiryItems, List<InventoryItem>> {
  /// Provider for near expiry items
  ///
  /// Copied from [NearExpiryItems].
  NearExpiryItemsProvider({
    int? branchId,
    int daysToExpiry = 7,
    int? limit,
  }) : this._internal(
          () => NearExpiryItems()
            ..branchId = branchId
            ..daysToExpiry = daysToExpiry
            ..limit = limit,
          from: nearExpiryItemsProvider,
          name: r'nearExpiryItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearExpiryItemsHash,
          dependencies: NearExpiryItemsFamily._dependencies,
          allTransitiveDependencies:
              NearExpiryItemsFamily._allTransitiveDependencies,
          branchId: branchId,
          daysToExpiry: daysToExpiry,
          limit: limit,
        );

  NearExpiryItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.branchId,
    required this.daysToExpiry,
    required this.limit,
  }) : super.internal();

  final int? branchId;
  final int daysToExpiry;
  final int? limit;

  @override
  FutureOr<List<InventoryItem>> runNotifierBuild(
    covariant NearExpiryItems notifier,
  ) {
    return notifier.build(
      branchId: branchId,
      daysToExpiry: daysToExpiry,
      limit: limit,
    );
  }

  @override
  Override overrideWith(NearExpiryItems Function() create) {
    return ProviderOverride(
      origin: this,
      override: NearExpiryItemsProvider._internal(
        () => create()
          ..branchId = branchId
          ..daysToExpiry = daysToExpiry
          ..limit = limit,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        branchId: branchId,
        daysToExpiry: daysToExpiry,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<NearExpiryItems, List<InventoryItem>>
      createElement() {
    return _NearExpiryItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearExpiryItemsProvider &&
        other.branchId == branchId &&
        other.daysToExpiry == daysToExpiry &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, branchId.hashCode);
    hash = _SystemHash.combine(hash, daysToExpiry.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin NearExpiryItemsRef
    on AutoDisposeAsyncNotifierProviderRef<List<InventoryItem>> {
  /// The parameter `branchId` of this provider.
  int? get branchId;

  /// The parameter `daysToExpiry` of this provider.
  int get daysToExpiry;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _NearExpiryItemsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<NearExpiryItems,
        List<InventoryItem>> with NearExpiryItemsRef {
  _NearExpiryItemsProviderElement(super.provider);

  @override
  int? get branchId => (origin as NearExpiryItemsProvider).branchId;
  @override
  int get daysToExpiry => (origin as NearExpiryItemsProvider).daysToExpiry;
  @override
  int? get limit => (origin as NearExpiryItemsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
