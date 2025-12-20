// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockRequests)
const stockRequestsProvider = StockRequestsFamily._();

final class StockRequestsProvider extends $FunctionalProvider<
        AsyncValue<List<InventoryRequest>>,
        List<InventoryRequest>,
        Stream<List<InventoryRequest>>>
    with
        $FutureModifier<List<InventoryRequest>>,
        $StreamProvider<List<InventoryRequest>> {
  const StockRequestsProvider._(
      {required StockRequestsFamily super.from,
      required ({
        String status,
        String? search,
      })
          super.argument})
      : super(
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
  $StreamProviderElement<List<InventoryRequest>> $createElement(
          $ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<InventoryRequest>> create(Ref ref) {
    final argument = this.argument as ({
      String status,
      String? search,
    });
    return stockRequests(
      ref,
      status: argument.status,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StockRequestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockRequestsHash() => r'acd9dbd0d8999808bec5f8463c4f324880d16362';

final class StockRequestsFamily extends $Family
    with
        $FunctionalFamilyOverride<
            Stream<List<InventoryRequest>>,
            ({
              String status,
              String? search,
            })> {
  const StockRequestsFamily._()
      : super(
          retry: null,
          name: r'stockRequestsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StockRequestsProvider call({
    required String status,
    String? search,
  }) =>
      StockRequestsProvider._(argument: (
        status: status,
        search: search,
      ), from: this);

  @override
  String toString() => r'stockRequestsProvider';
}
