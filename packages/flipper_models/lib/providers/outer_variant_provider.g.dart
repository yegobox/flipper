// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outer_variant_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The stock view the POS grid is showing. Starts on in-stock items every
/// session; a search always lists everything regardless (see [PosStockFilter]).

@ProviderFor(PosCatalogStockFilter)
const posCatalogStockFilterProvider = PosCatalogStockFilterProvider._();

/// The stock view the POS grid is showing. Starts on in-stock items every
/// session; a search always lists everything regardless (see [PosStockFilter]).
final class PosCatalogStockFilterProvider
    extends $NotifierProvider<PosCatalogStockFilter, PosStockFilter> {
  /// The stock view the POS grid is showing. Starts on in-stock items every
  /// session; a search always lists everything regardless (see [PosStockFilter]).
  const PosCatalogStockFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'posCatalogStockFilterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$posCatalogStockFilterHash();

  @$internal
  @override
  PosCatalogStockFilter create() => PosCatalogStockFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PosStockFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PosStockFilter>(value),
    );
  }
}

String _$posCatalogStockFilterHash() =>
    r'2f552754bc9a80db117b4b8ed8ddd4929100b21a';

/// The stock view the POS grid is showing. Starts on in-stock items every
/// session; a search always lists everything regardless (see [PosStockFilter]).

abstract class _$PosCatalogStockFilter extends $Notifier<PosStockFilter> {
  PosStockFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PosStockFilter, PosStockFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PosStockFilter, PosStockFilter>,
              PosStockFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(OuterVariants)
const outerVariantsProvider = OuterVariantsFamily._();

final class OuterVariantsProvider
    extends $AsyncNotifierProvider<OuterVariants, List<Variant>> {
  const OuterVariantsProvider._({
    required OuterVariantsFamily super.from,
    required (String, {PosStockFilter stockFilter}) super.argument,
  }) : super(
         retry: null,
         name: r'outerVariantsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$outerVariantsHash();

  @override
  String toString() {
    return r'outerVariantsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  OuterVariants create() => OuterVariants();

  @override
  bool operator ==(Object other) {
    return other is OuterVariantsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$outerVariantsHash() => r'207a4d80f7c6c08769e33588f6a19ef796073f3c';

final class OuterVariantsFamily extends $Family
    with
        $ClassFamilyOverride<
          OuterVariants,
          AsyncValue<List<Variant>>,
          List<Variant>,
          FutureOr<List<Variant>>,
          (String, {PosStockFilter stockFilter})
        > {
  const OuterVariantsFamily._()
    : super(
        retry: null,
        name: r'outerVariantsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OuterVariantsProvider call(
    String branchId, {
    PosStockFilter stockFilter = PosStockFilter.all,
  }) => OuterVariantsProvider._(
    argument: (branchId, stockFilter: stockFilter),
    from: this,
  );

  @override
  String toString() => r'outerVariantsProvider';
}

abstract class _$OuterVariants extends $AsyncNotifier<List<Variant>> {
  late final _$args = ref.$arg as (String, {PosStockFilter stockFilter});
  String get branchId => _$args.$1;
  PosStockFilter get stockFilter => _$args.stockFilter;

  FutureOr<List<Variant>> build(
    String branchId, {
    PosStockFilter stockFilter = PosStockFilter.all,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, stockFilter: _$args.stockFilter);
    final ref = this.ref as $Ref<AsyncValue<List<Variant>>, List<Variant>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Variant>>, List<Variant>>,
              AsyncValue<List<Variant>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Products)
const productsProvider = ProductsFamily._();

final class ProductsProvider
    extends $AsyncNotifierProvider<Products, List<Product>> {
  const ProductsProvider._({
    required ProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @override
  String toString() {
    return r'productsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Products create() => Products();

  @override
  bool operator ==(Object other) {
    return other is ProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsHash() => r'0bfb9244dd41c09b111c193ceb32ec17b467b7c4';

final class ProductsFamily extends $Family
    with
        $ClassFamilyOverride<
          Products,
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>,
          String
        > {
  const ProductsFamily._()
    : super(
        retry: null,
        name: r'productsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductsProvider call(String branchId) =>
      ProductsProvider._(argument: branchId, from: this);

  @override
  String toString() => r'productsProvider';
}

abstract class _$Products extends $AsyncNotifier<List<Product>> {
  late final _$args = ref.$arg as String;
  String get branchId => _$args;

  FutureOr<List<Product>> build(String branchId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
