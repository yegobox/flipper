// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service provider for inventory operations

@ProviderFor(inventoryService)
const inventoryServiceProvider = InventoryServiceProvider._();

/// Service provider for inventory operations

final class InventoryServiceProvider extends $FunctionalProvider<
    InventoryService,
    InventoryService,
    InventoryService> with $Provider<InventoryService> {
  /// Service provider for inventory operations
  const InventoryServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'inventoryServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$inventoryServiceHash();

  @$internal
  @override
  $ProviderElement<InventoryService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  InventoryService create(Ref ref) {
    return inventoryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryService>(value),
    );
  }
}

String _$inventoryServiceHash() => r'4bf9182ae0cc65223faa5ae6b9ed2943665b626f';

/// Provider for expired items

@ProviderFor(expiredItems)
const expiredItemsProvider = ExpiredItemsFamily._();

/// Provider for expired items

final class ExpiredItemsProvider extends $FunctionalProvider<
        AsyncValue<List<InventoryItem>>,
        List<InventoryItem>,
        FutureOr<List<InventoryItem>>>
    with
        $FutureModifier<List<InventoryItem>>,
        $FutureProvider<List<InventoryItem>> {
  /// Provider for expired items
  const ExpiredItemsProvider._(
      {required ExpiredItemsFamily super.from,
      required ExpiredItemsParams super.argument})
      : super(
          retry: null,
          name: r'expiredItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expiredItemsHash();

  @override
  String toString() {
    return r'expiredItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<InventoryItem>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryItem>> create(Ref ref) {
    final argument = this.argument as ExpiredItemsParams;
    return expiredItems(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExpiredItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expiredItemsHash() => r'0850b2818a5761395f64de4b34391db5bbadeaaa';

/// Provider for expired items

final class ExpiredItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<InventoryItem>>,
            ExpiredItemsParams> {
  const ExpiredItemsFamily._()
      : super(
          retry: null,
          name: r'expiredItemsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for expired items

  ExpiredItemsProvider call(
    ExpiredItemsParams params,
  ) =>
      ExpiredItemsProvider._(argument: params, from: this);

  @override
  String toString() => r'expiredItemsProvider';
}

/// Provider for near expiry items

@ProviderFor(nearExpiryItems)
const nearExpiryItemsProvider = NearExpiryItemsFamily._();

/// Provider for near expiry items

final class NearExpiryItemsProvider extends $FunctionalProvider<
        AsyncValue<List<InventoryItem>>,
        List<InventoryItem>,
        FutureOr<List<InventoryItem>>>
    with
        $FutureModifier<List<InventoryItem>>,
        $FutureProvider<List<InventoryItem>> {
  /// Provider for near expiry items
  const NearExpiryItemsProvider._(
      {required NearExpiryItemsFamily super.from,
      required NearExpiryItemsParams super.argument})
      : super(
          retry: null,
          name: r'nearExpiryItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nearExpiryItemsHash();

  @override
  String toString() {
    return r'nearExpiryItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<InventoryItem>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryItem>> create(Ref ref) {
    final argument = this.argument as NearExpiryItemsParams;
    return nearExpiryItems(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NearExpiryItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$nearExpiryItemsHash() => r'3fa2a658c3f54461b31e4412385305496b051ea9';

/// Provider for near expiry items

final class NearExpiryItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<InventoryItem>>,
            NearExpiryItemsParams> {
  const NearExpiryItemsFamily._()
      : super(
          retry: null,
          name: r'nearExpiryItemsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Provider for near expiry items

  NearExpiryItemsProvider call(
    NearExpiryItemsParams params,
  ) =>
      NearExpiryItemsProvider._(argument: params, from: this);

  @override
  String toString() => r'nearExpiryItemsProvider';
}

/// Provider for total items count and trend

@ProviderFor(totalItems)
const totalItemsProvider = TotalItemsProvider._();

/// Provider for total items count and trend

final class TotalItemsProvider extends $FunctionalProvider<
        AsyncValue<TotalItemsData>, TotalItemsData, FutureOr<TotalItemsData>>
    with $FutureModifier<TotalItemsData>, $FutureProvider<TotalItemsData> {
  /// Provider for total items count and trend
  const TotalItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'totalItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$totalItemsHash();

  @$internal
  @override
  $FutureProviderElement<TotalItemsData> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TotalItemsData> create(Ref ref) {
    return totalItems(ref);
  }
}

String _$totalItemsHash() => r'3d36cdd6d4b8ca46faa8f2a62eeb6c60182a1766';

/// Provider for low stock items count and trend

@ProviderFor(lowStockItems)
const lowStockItemsProvider = LowStockItemsProvider._();

/// Provider for low stock items count and trend

final class LowStockItemsProvider extends $FunctionalProvider<
        AsyncValue<TotalItemsData>, TotalItemsData, FutureOr<TotalItemsData>>
    with $FutureModifier<TotalItemsData>, $FutureProvider<TotalItemsData> {
  /// Provider for low stock items count and trend
  const LowStockItemsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lowStockItemsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lowStockItemsHash();

  @$internal
  @override
  $FutureProviderElement<TotalItemsData> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TotalItemsData> create(Ref ref) {
    return lowStockItems(ref);
  }
}

String _$lowStockItemsHash() => r'96f26e1f9862510aae8297905c4e2a675064a1b4';

/// Provider for pending orders count and trend

@ProviderFor(pendingOrders)
const pendingOrdersProvider = PendingOrdersProvider._();

/// Provider for pending orders count and trend

final class PendingOrdersProvider extends $FunctionalProvider<
        AsyncValue<TotalItemsData>, TotalItemsData, FutureOr<TotalItemsData>>
    with $FutureModifier<TotalItemsData>, $FutureProvider<TotalItemsData> {
  /// Provider for pending orders count and trend
  const PendingOrdersProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pendingOrdersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pendingOrdersHash();

  @$internal
  @override
  $FutureProviderElement<TotalItemsData> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<TotalItemsData> create(Ref ref) {
    return pendingOrders(ref);
  }
}

String _$pendingOrdersHash() => r'01ec8807bdf5d884d866e20a4f3137073a2a3a56';
