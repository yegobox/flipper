// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_value_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StockValue)
const stockValueProvider = StockValueFamily._();

final class StockValueProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  const StockValueProvider._(
      {required StockValueFamily super.from, required int super.argument})
      : super(
          retry: null,
          name: r'stockValueProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$stockValueHash();

  @override
  String toString() {
    return r'stockValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as int;
    return StockValue(
      ref,
      branchId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StockValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockValueHash() => r'473e96005c3d3f03947db0434fbfa13bb60778a1';

final class StockValueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, int> {
  const StockValueFamily._()
      : super(
          retry: null,
          name: r'stockValueProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StockValueProvider call({
    required int branchId,
  }) =>
      StockValueProvider._(argument: branchId, from: this);

  @override
  String toString() => r'stockValueProvider';
}
