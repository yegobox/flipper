import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_sort_provider.g.dart';

enum ProductSortOption {
  defaultSorting('Default sorting'),
  popularity('Sort by popularity'),
  averageRating('Sort by average rating'),
  latest('Sort by latest'),
  priceLowToHigh('Sort by price: low to high'),
  priceHighToLow('Sort by price: high to low'),
  eventDateOldToNew('Sort by event date: Old to New'),
  eventDateNewToOld('Sort by event date: New to Old');

  const ProductSortOption(this.label);
  final String label;
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
