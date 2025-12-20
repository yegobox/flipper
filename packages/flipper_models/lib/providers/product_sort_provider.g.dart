// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sort_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductSort)
const productSortProvider = ProductSortProvider._();

final class ProductSortProvider
    extends $NotifierProvider<ProductSort, ProductSortOption> {
  const ProductSortProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'productSortProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$productSortHash();

  @$internal
  @override
  ProductSort create() => ProductSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductSortOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductSortOption>(value),
    );
  }
}

String _$productSortHash() => r'6b73e5f7cb8f45dc72842598dd70b8527daa249a';

abstract class _$ProductSort extends $Notifier<ProductSortOption> {
  ProductSortOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ProductSortOption, ProductSortOption>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ProductSortOption, ProductSortOption>,
        ProductSortOption,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
