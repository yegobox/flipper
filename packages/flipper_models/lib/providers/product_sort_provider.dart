import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_sort_provider.g.dart';

/// Display names live in `app_en.arb` and are resolved by the
/// `ProductSortOptionLabels` extension in `flipper_dashboard`, since this
/// package has no `flipper_localize` dependency and a const enum field cannot
/// resolve a locale.
enum ProductSortOption {
  defaultSorting,
  popularity,
  averageRating,
  latest,
  priceLowToHigh,
  priceHighToLow,
  stockOut,
  eventDateOldToNew,
  eventDateNewToOld,
}

@riverpod
class ProductSort extends _$ProductSort {
  @override
  ProductSortOption build() {
    return ProductSortOption.latest;
  }

  void set(ProductSortOption option) {
    state = option;
  }
}
