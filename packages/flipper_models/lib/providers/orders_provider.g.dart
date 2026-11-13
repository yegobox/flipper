// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StockRequests)
final stockRequestsProvider = StockRequestsFamily._();

final class StockRequestsProvider
    extends $StreamNotifierProvider<StockRequests, List<InventoryRequest>> {
  StockRequestsProvider._({
    required StockRequestsFamily super.from,
    required ({String status, String? search}) super.argument,
  }) : super(
         retry: null,
         name: r'stockRequestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stockRequestsHash();

  @override
  String toString() {
    return r'stockRequestsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  StockRequests create() => StockRequests();

  @override
  bool operator ==(Object other) {
    return other is StockRequestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockRequestsHash() => r'5042c2b3d8ac2681932f3d328d2c5422668a5305';

final class StockRequestsFamily extends $Family
    with
        $ClassFamilyOverride<
          StockRequests,
          AsyncValue<List<InventoryRequest>>,
          List<InventoryRequest>,
          Stream<List<InventoryRequest>>,
          ({String status, String? search})
        > {
  StockRequestsFamily._()
    : super(
        retry: null,
        name: r'stockRequestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StockRequestsProvider call({required String status, String? search}) =>
      StockRequestsProvider._(
        argument: (status: status, search: search),
        from: this,
      );

  @override
  String toString() => r'stockRequestsProvider';
}

abstract class _$StockRequests extends $StreamNotifier<List<InventoryRequest>> {
  late final _$args = ref.$arg as ({String status, String? search});
  String get status => _$args.status;
  String? get search => _$args.search;

  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<InventoryRequest>>, List<InventoryRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<InventoryRequest>>,
                List<InventoryRequest>
              >,
              AsyncValue<List<InventoryRequest>>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(status: _$args.status, search: _$args.search),
    );
  }
}

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.

@ProviderFor(OutgoingStockRequests)
final outgoingStockRequestsProvider = OutgoingStockRequestsFamily._();

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.
final class OutgoingStockRequestsProvider
    extends
        $StreamNotifierProvider<OutgoingStockRequests, List<InventoryRequest>> {
  /// Outgoing / destination-side stock requests (this branch is [subBranchId]).
  ///
  /// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.
  OutgoingStockRequestsProvider._({
    required OutgoingStockRequestsFamily super.from,
    required ({String status, String? search}) super.argument,
  }) : super(
         retry: null,
         name: r'outgoingStockRequestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$outgoingStockRequestsHash();

  @override
  String toString() {
    return r'outgoingStockRequestsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  OutgoingStockRequests create() => OutgoingStockRequests();

  @override
  bool operator ==(Object other) {
    return other is OutgoingStockRequestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outgoingStockRequestsHash() =>
    r'e9ea047bf7dc0f5e1c3eafdea1564f530196c6a6';

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.

final class OutgoingStockRequestsFamily extends $Family
    with
        $ClassFamilyOverride<
          OutgoingStockRequests,
          AsyncValue<List<InventoryRequest>>,
          List<InventoryRequest>,
          Stream<List<InventoryRequest>>,
          ({String status, String? search})
        > {
  OutgoingStockRequestsFamily._()
    : super(
        retry: null,
        name: r'outgoingStockRequestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Outgoing / destination-side stock requests (this branch is [subBranchId]).
  ///
  /// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.

  OutgoingStockRequestsProvider call({
    required String status,
    String? search,
  }) => OutgoingStockRequestsProvider._(
    argument: (status: status, search: search),
    from: this,
  );

  @override
  String toString() => r'outgoingStockRequestsProvider';
}

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.

abstract class _$OutgoingStockRequests
    extends $StreamNotifier<List<InventoryRequest>> {
  late final _$args = ref.$arg as ({String status, String? search});
  String get status => _$args.status;
  String? get search => _$args.search;

  Stream<List<InventoryRequest>> build({
    required String status,
    String? search,
  });
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<InventoryRequest>>, List<InventoryRequest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<InventoryRequest>>,
                List<InventoryRequest>
              >,
              AsyncValue<List<InventoryRequest>>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(status: _$args.status, search: _$args.search),
    );
  }
}
