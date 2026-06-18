// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visible_stocks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One Ditto observer for all stock rows on the current catalog page (max ~15).

@ProviderFor(stocksForVisibleVariants)
const stocksForVisibleVariantsProvider = StocksForVisibleVariantsFamily._();

/// One Ditto observer for all stock rows on the current catalog page (max ~15).

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
  const StocksForVisibleVariantsProvider._({
    required StocksForVisibleVariantsFamily super.from,
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, Stock?>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, Stock?>> create(Ref ref) {
    final argument = this.argument as String;
    return stocksForVisibleVariants(ref, argument);
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
    r'53186bc8ff11755ef95de7a9fd3578971cc3fce9';

/// One Ditto observer for all stock rows on the current catalog page (max ~15).

final class StocksForVisibleVariantsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Map<String, Stock?>>, String> {
  const StocksForVisibleVariantsFamily._()
    : super(
        retry: null,
        name: r'stocksForVisibleVariantsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One Ditto observer for all stock rows on the current catalog page (max ~15).

  StocksForVisibleVariantsProvider call(String branchId) =>
      StocksForVisibleVariantsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'stocksForVisibleVariantsProvider';
}
