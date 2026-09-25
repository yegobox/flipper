class PagedVariants {
  final List variants;
  final int? totalCount;

  /// Catalog rows the stock filter left out; null when no filter ran. Lets a
  /// caller tell "nothing in stock" apart from "nothing synced yet".
  final int? stockFilteredOut;

  PagedVariants({
    required this.variants,
    this.totalCount,
    this.stockFilteredOut,
  });
}
