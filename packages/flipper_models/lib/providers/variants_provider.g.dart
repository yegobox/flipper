// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variants_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(variant)
const variantProvider = VariantFamily._();

final class VariantProvider extends $FunctionalProvider<
        AsyncValue<List<Variant>>, List<Variant>, FutureOr<List<Variant>>>
    with $FutureModifier<List<Variant>>, $FutureProvider<List<Variant>> {
  const VariantProvider._(
      {required VariantFamily super.from,
      required ({
        int branchId,
        String? key,
        bool forImportScreen,
        bool forPurchaseScreen,
      })
          super.argument})
      : super(
          retry: null,
          name: r'variantProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$variantHash();

  @override
  String toString() {
    return r'variantProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Variant>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Variant>> create(Ref ref) {
    final argument = this.argument as ({
      int branchId,
      String? key,
      bool forImportScreen,
      bool forPurchaseScreen,
    });
    return variant(
      ref,
      branchId: argument.branchId,
      key: argument.key,
      forImportScreen: argument.forImportScreen,
      forPurchaseScreen: argument.forPurchaseScreen,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VariantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$variantHash() => r'a17d4daf12dfead182571ec7beb47c39c53bf2e8';

final class VariantFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<Variant>>,
            ({
              int branchId,
              String? key,
              bool forImportScreen,
              bool forPurchaseScreen,
            })> {
  const VariantFamily._()
      : super(
          retry: null,
          name: r'variantProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  VariantProvider call({
    required int branchId,
    String? key,
    bool forImportScreen = false,
    bool forPurchaseScreen = false,
  }) =>
      VariantProvider._(argument: (
        branchId: branchId,
        key: key,
        forImportScreen: forImportScreen,
        forPurchaseScreen: forPurchaseScreen,
      ), from: this);

  @override
  String toString() => r'variantProvider';
}

@ProviderFor(purchaseVariant)
const purchaseVariantProvider = PurchaseVariantFamily._();

final class PurchaseVariantProvider extends $FunctionalProvider<
        AsyncValue<List<Variant>>, List<Variant>, FutureOr<List<Variant>>>
    with $FutureModifier<List<Variant>>, $FutureProvider<List<Variant>> {
  const PurchaseVariantProvider._(
      {required PurchaseVariantFamily super.from,
      required ({
        int branchId,
        String? purchaseId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'purchaseVariantProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$purchaseVariantHash();

  @override
  String toString() {
    return r'purchaseVariantProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Variant>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Variant>> create(Ref ref) {
    final argument = this.argument as ({
      int branchId,
      String? purchaseId,
    });
    return purchaseVariant(
      ref,
      branchId: argument.branchId,
      purchaseId: argument.purchaseId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PurchaseVariantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$purchaseVariantHash() => r'661e989996a1d7f320e5c09b8b37610691e224c4';

final class PurchaseVariantFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<Variant>>,
            ({
              int branchId,
              String? purchaseId,
            })> {
  const PurchaseVariantFamily._()
      : super(
          retry: null,
          name: r'purchaseVariantProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  PurchaseVariantProvider call({
    required int branchId,
    String? purchaseId,
  }) =>
      PurchaseVariantProvider._(argument: (
        branchId: branchId,
        purchaseId: purchaseId,
      ), from: this);

  @override
  String toString() => r'purchaseVariantProvider';
}

@ProviderFor(stockById)
const stockByIdProvider = StockByIdFamily._();

final class StockByIdProvider
    extends $FunctionalProvider<AsyncValue<Stock?>, Stock?, FutureOr<Stock?>>
    with $FutureModifier<Stock?>, $FutureProvider<Stock?> {
  const StockByIdProvider._(
      {required StockByIdFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'stockByIdProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$stockByIdHash();

  @override
  String toString() {
    return r'stockByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Stock?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Stock?> create(Ref ref) {
    final argument = this.argument as String;
    return stockById(
      ref,
      stockId: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StockByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stockByIdHash() => r'0656c9babb20066f9f25c8b657359d6112ff8428';

final class StockByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Stock?>, String> {
  const StockByIdFamily._()
      : super(
          retry: null,
          name: r'stockByIdProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  StockByIdProvider call({
    required String stockId,
  }) =>
      StockByIdProvider._(argument: stockId, from: this);

  @override
  String toString() => r'stockByIdProvider';
}
