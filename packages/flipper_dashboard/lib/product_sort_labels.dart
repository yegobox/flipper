import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/product_sort_provider.dart';

/// Localized display names for [ProductSortOption].
///
/// These live here rather than on the enum because `flipper_models` has no
/// `flipper_localize` dependency, and an enum's const field cannot resolve a
/// locale anyway. Keeping the English text only in `app_en.arb` also stops the
/// two copies drifting apart.
extension ProductSortOptionLabels on ProductSortOption {
  /// Full sentence used in the sort dropdown, e.g. "Sort by latest".
  String localizedLabel(FlipperAppLocalizations l10n) {
    switch (this) {
      case ProductSortOption.defaultSorting:
        return l10n.sortDefault;
      case ProductSortOption.popularity:
        return l10n.sortByPopularity;
      case ProductSortOption.averageRating:
        return l10n.sortByAverageRating;
      case ProductSortOption.latest:
        return l10n.sortByLatest;
      case ProductSortOption.priceLowToHigh:
        return l10n.sortByPriceLowToHigh;
      case ProductSortOption.priceHighToLow:
        return l10n.sortByPriceHighToLow;
      case ProductSortOption.stockOut:
        return l10n.sortByStockOut;
      case ProductSortOption.eventDateOldToNew:
        return l10n.sortByEventDateOldToNew;
      case ProductSortOption.eventDateNewToOld:
        return l10n.sortByEventDateNewToOld;
    }
  }

  /// Short form for the compact chip. The arrows carry the direction, so only
  /// the noun is translated.
  String compactLabel(FlipperAppLocalizations l10n) {
    switch (this) {
      case ProductSortOption.latest:
        return l10n.sortCompactLatest;
      case ProductSortOption.defaultSorting:
        return l10n.sortCompactDefault;
      case ProductSortOption.popularity:
        return l10n.sortCompactPopular;
      case ProductSortOption.averageRating:
        return l10n.sortCompactRating;
      case ProductSortOption.priceLowToHigh:
        return '${l10n.sortCompactPrice} ↑';
      case ProductSortOption.priceHighToLow:
        return '${l10n.sortCompactPrice} ↓';
      case ProductSortOption.stockOut:
        return l10n.sortCompactStockOut;
      case ProductSortOption.eventDateOldToNew:
        return '${l10n.sortCompactDate} ↑';
      case ProductSortOption.eventDateNewToOld:
        return '${l10n.sortCompactDate} ↓';
    }
  }
}
