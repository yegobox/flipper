// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_value_report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockValueReport)
const stockValueReportProvider = StockValueReportProvider._();

final class StockValueReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<StockValueReportData>,
          StockValueReportData,
          FutureOr<StockValueReportData>
        >
    with
        $FutureModifier<StockValueReportData>,
        $FutureProvider<StockValueReportData> {
  const StockValueReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockValueReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockValueReportHash();

  @$internal
  @override
  $FutureProviderElement<StockValueReportData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StockValueReportData> create(Ref ref) {
    return stockValueReport(ref);
  }
}

String _$stockValueReportHash() => r'126d50003af6b7d90658d63a36307bc015e7bbaf';

@ProviderFor(stockValueSummary)
const stockValueSummaryProvider = StockValueSummaryProvider._();

final class StockValueSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<StockValueSummaryData>,
          StockValueSummaryData,
          FutureOr<StockValueSummaryData>
        >
    with
        $FutureModifier<StockValueSummaryData>,
        $FutureProvider<StockValueSummaryData> {
  const StockValueSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockValueSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockValueSummaryHash();

  @$internal
  @override
  $FutureProviderElement<StockValueSummaryData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StockValueSummaryData> create(Ref ref) {
    return stockValueSummary(ref);
  }
}

String _$stockValueSummaryHash() => r'24dc8fff693e1b127eea69c35ffc09b801a50d69';
