// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StockRequests)
const stockRequestsProvider = StockRequestsFamily._();

final class StockRequestsProvider
    extends $StreamNotifierProvider<StockRequests, List<InventoryRequest>> {
  const StockRequestsProvider._({
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

String _$stockRequestsHash() => r'3edaa277bb52d4122a36fc384b00b873a129101f';

final class StockRequestsFamily extends $Family
    with
        $ClassFamilyOverride<
          StockRequests,
          AsyncValue<List<InventoryRequest>>,
          List<InventoryRequest>,
          Stream<List<InventoryRequest>>,
          ({String status, String? search})
        > {
  const StockRequestsFamily._()
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
  void runBuild() {
    final created = build(status: _$args.status, search: _$args.search);
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
    element.handleValue(ref, created);
  }
}

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.

@ProviderFor(OutgoingStockRequests)
const outgoingStockRequestsProvider = OutgoingStockRequestsFamily._();

/// Outgoing / destination-side stock requests (this branch is [subBranchId]).
///
/// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.
final class OutgoingStockRequestsProvider
    extends
        $StreamNotifierProvider<OutgoingStockRequests, List<InventoryRequest>> {
  /// Outgoing / destination-side stock requests (this branch is [subBranchId]).
  ///
  /// Used by Incoming Orders "Outgoing" tab and POS transfer destination alerts.
  const OutgoingStockRequestsProvider._({
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
    r'6f814a4330d3bb4d9bbeb9acfcf8b12c9f7ae0fd';

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
  const OutgoingStockRequestsFamily._()
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
  void runBuild() {
    final created = build(status: _$args.status, search: _$args.search);
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
    element.handleValue(ref, created);
  }
}
