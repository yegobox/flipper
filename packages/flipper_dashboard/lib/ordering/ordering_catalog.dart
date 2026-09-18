import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/states/productListProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Label for rows the supplier has not filed under a category.
const String kOrderingUncategorised = 'Uncategorised';

String orderingCategoryOf(Variant variant) {
  final name = variant.categoryName?.trim();
  return (name == null || name.isEmpty) ? kOrderingUncategorised : name;
}

String orderingSkuOf(Variant variant) {
  for (final candidate in [variant.sku, variant.itemCd]) {
    final value = candidate?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return '—';
}

String orderingUnitOf(Variant variant) {
  for (final candidate in [variant.unit, variant.qtyUnitCd]) {
    final value = candidate?.trim();
    if (value != null && value.isNotEmpty) return value;
  }
  return 'ea';
}

/// One rail entry: a category and how many of the supplier's products are in it.
class OrderingCategory {
  const OrderingCategory({required this.name, required this.count});

  final String name;
  final int count;

  bool get isAll => name == kOrderingAllCategories;
  String get label => isAll ? 'All products' : name;
}

/// A category section in the catalogue.
class OrderingGroup {
  const OrderingGroup({required this.label, required this.items});

  final String label;
  final List<Variant> items;
}

/// The catalogue as the three panes need it: rail counts, the rows that survive
/// the current filters, and how they are sectioned.
///
/// Counts are over the supplier's whole catalogue, not the filtered view — a
/// rail whose numbers moved every time you typed would be useless for deciding
/// where to look next.
class OrderingCatalog {
  const OrderingCatalog({
    required this.categories,
    required this.visible,
    required this.groups,
    required this.totalCount,
  });

  const OrderingCatalog.empty()
    : categories = const [],
      visible = const [],
      groups = const [],
      totalCount = 0;

  final List<OrderingCategory> categories;
  final List<Variant> visible;
  final List<OrderingGroup> groups;
  final int totalCount;

  /// The row Enter adds.
  Variant? get topMatch => visible.isEmpty ? null : visible.first;

  String get resultLabel => '${visible.length} of $totalCount products';
}

OrderingCatalog buildOrderingCatalog({
  required List<Variant> products,
  required String category,
  required String query,
  required bool stockOnly,
  required bool groupByCategory,
}) {
  if (products.isEmpty) return const OrderingCatalog.empty();

  final counts = <String, int>{};
  for (final product in products) {
    final name = orderingCategoryOf(product);
    counts[name] = (counts[name] ?? 0) + 1;
  }
  final categoryNames = counts.keys.toList()..sort();

  final needle = query.trim().toLowerCase();
  final visible = products.where((product) {
    if (category != kOrderingAllCategories &&
        orderingCategoryOf(product) != category) {
      return false;
    }
    // Only hide a row whose stock is *known* to be zero. An unknown stock
    // (no row, or the embed was dropped) is not evidence of none.
    if (stockOnly && (product.stock?.currentStock ?? -1) == 0) return false;
    if (needle.isEmpty) return true;
    // Name, SKU and barcode — what the field's placeholder promises. A scanner
    // types into the same box, so the barcode has to match too.
    final haystack =
        '${product.name} ${product.productName ?? ''} '
        '${orderingSkuOf(product)} ${product.bcd ?? ''}';
    return haystack.toLowerCase().contains(needle);
  }).toList();

  final groups = <OrderingGroup>[];
  if (groupByCategory) {
    for (final name in categoryNames) {
      final items = visible
          .where((product) => orderingCategoryOf(product) == name)
          .toList();
      if (items.isEmpty) continue;
      groups.add(OrderingGroup(label: name, items: items));
    }
  } else if (visible.isNotEmpty) {
    groups.add(OrderingGroup(label: '', items: visible));
  }

  return OrderingCatalog(
    categories: [
      OrderingCategory(
        name: kOrderingAllCategories,
        count: products.length,
      ),
      for (final name in categoryNames)
        OrderingCategory(name: name, count: counts[name] ?? 0),
    ],
    visible: visible,
    groups: groups,
    totalCount: products.length,
  );
}

/// Derived catalogue for the current supplier and filters.
///
/// Keeps the async state of the fetch so the table can tell "still loading"
/// from "this supplier has nothing".
final orderingCatalogProvider = Provider<AsyncValue<OrderingCatalog>>((ref) {
  final products = ref.watch(productFromSupplierWrapper);
  final category = ref.watch(orderingCategoryProvider);
  final query = ref.watch(orderingQueryProvider);
  final stockOnly = ref.watch(orderingStockOnlyProvider);
  final groupByCategory = ref.watch(orderingGroupByCategoryProvider);

  return products.whenData(
    (list) => buildOrderingCatalog(
      products: list,
      category: category,
      query: query,
      stockOnly: stockOnly,
      groupByCategory: groupByCategory,
    ),
  );
});
