// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visible_stocks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One Ditto observer for all stock rows on the current catalog page (max ~15).
///
/// [stockFilter] must match the catalog the grid renders, or the observer
/// watches another page's stock rows.

@ProviderFor(stocksForVisibleVariants)
const stocksForVisibleVariantsProvider = StocksForVisibleVariantsFamily._();

/// One Ditto observer for all stock rows on the current catalog page (max ~15).
///
/// [stockFilter] must match the catalog the grid renders, or the observer
/// watches another page's stock rows.

final class StocksForVisibleVariantsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Stock?>>,
          Map<String, Stock?>,
          Stream<Map<String, Stock?>>
        >
    with
        $FutureModifier<Map<String, Stock?>>,
        $StreamProvider<Map<String, Stock?>> {
  /// One Ditto observer for all stock rows on the current catalog page (max ~15).
  ///
  /// [stockFilter] must match the catalog the grid renders, or the observer
  /// watches another page's stock rows.
  const StocksForVisibleVariantsProvider._({
    required StocksForVisibleVariantsFamily super.from,
    required (String, {PosStockFilter stockFilter}) super.argument,
  }) : super(
         retry: null,
         name: r'stocksForVisibleVariantsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stocksForVisibleVariantsHash();

  @override
  String toString() {
    return r'stocksForVisibleVariantsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, Stock?>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Stock?>> create(Ref ref) {
    final argument = this.argument as (String, {PosStockFilter stockFilter});
    return stocksForVisibleVariants(
      ref,
      argument.$1,
      stockFilter: argument.stockFilter,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StocksForVisibleVariantsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stocksForVisibleVariantsHash() =>
    r'658f44a82b269b3b0813056cabc76510e878bb9a';

/// One Ditto observer for all stock rows on the current catalog page (max ~15).
///
/// [stockFilter] must match the catalog the grid renders, or the observer
/// watches another page's stock rows.

final class StocksForVisibleVariantsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, Stock?>>,
          (String, {PosStockFilter stockFilter})
        > {
  const StocksForVisibleVariantsFamily._()
    : super(
        retry: null,
        name: r'stocksForVisibleVariantsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One Ditto observer for all stock rows on the current catalog page (max ~15).
  ///
  /// [stockFilter] must match the catalog the grid renders, or the observer
  /// watches another page's stock rows.

  StocksForVisibleVariantsProvider call(
    String branchId, {
    PosStockFilter stockFilter = PosStockFilter.all,
  }) => StocksForVisibleVariantsProvider._(
    argument: (branchId, stockFilter: stockFilter),
    from: this,
  );

  @override
  String toString() => r'stocksForVisibleVariantsProvider';
}
