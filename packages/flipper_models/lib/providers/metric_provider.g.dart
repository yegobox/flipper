// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(fetchMetrics)
const fetchMetricsProvider = FetchMetricsFamily._();

final class FetchMetricsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Metric>>,
          List<Metric>,
          FutureOr<List<Metric>>
        >
    with $FutureModifier<List<Metric>>, $FutureProvider<List<Metric>> {
  const FetchMetricsProvider._({
    required FetchMetricsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'fetchMetricsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$fetchMetricsHash();

  @override
  String toString() {
    return r'fetchMetricsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Metric>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Metric>> create(Ref ref) {
    final argument = this.argument as String;
    return fetchMetrics(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMetricsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$fetchMetricsHash() => r'c97ec630cef0f8b1ab4d4f3918b7c572a5b316a2';

final class FetchMetricsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Metric>>, String> {
  const FetchMetricsFamily._()
    : super(
        retry: null,
        name: r'fetchMetricsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FetchMetricsProvider call(String branchId) =>
      FetchMetricsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'fetchMetricsProvider';
}
