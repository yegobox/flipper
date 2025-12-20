// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_analytic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchStockPerformance)
const fetchStockPerformanceProvider = FetchStockPerformanceFamily._();

final class FetchStockPerformanceProvider extends $FunctionalProvider<
        AsyncValue<List<BusinessAnalytic>>,
        List<BusinessAnalytic>,
        FutureOr<List<BusinessAnalytic>>>
    with
        $FutureModifier<List<BusinessAnalytic>>,
        $FutureProvider<List<BusinessAnalytic>> {
  const FetchStockPerformanceProvider._(
      {required FetchStockPerformanceFamily super.from,
      required int super.argument})
      : super(
          retry: null,
          name: r'fetchStockPerformanceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$fetchStockPerformanceHash();

  @override
  String toString() {
    return r'fetchStockPerformanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BusinessAnalytic>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<BusinessAnalytic>> create(Ref ref) {
    final argument = this.argument as int;
    return fetchStockPerformance(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FetchStockPerformanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchStockPerformanceHash() =>
    r'dec5a38c965aacf12cac0dc65f02e57f5b70e971';

final class FetchStockPerformanceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BusinessAnalytic>>, int> {
  const FetchStockPerformanceFamily._()
      : super(
          retry: null,
          name: r'fetchStockPerformanceProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  FetchStockPerformanceProvider call(
    int branchId,
  ) =>
      FetchStockPerformanceProvider._(argument: branchId, from: this);

  @override
  String toString() => r'fetchStockPerformanceProvider';
}
