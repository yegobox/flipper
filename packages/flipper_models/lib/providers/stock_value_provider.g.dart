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
      {required StockValueFamily super.from, required String super.argument})
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
    final argument = this.argument as String;
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

String _$stockValueHash() => r'0abf0dde6b1eb11f79faa1efc61b1bfc98599676';

final class StockValueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  const StockValueFamily._()
      : super(
          retry: null,
          name: r'stockValueProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StockValueProvider call({
    required String branchId,
  }) =>
      StockValueProvider._(argument: branchId, from: this);

  @override
  String toString() => r'stockValueProvider';
}
