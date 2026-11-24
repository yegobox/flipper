import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/pos_catalog_stock_filter.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';

/// A combo (composite product) sells as ONE line at its own price; the combo
/// itself is a service and holds no stock. Its components' stock moves when
/// the sale is paid or refunded. Stock paths (pre-sale snapshot, deduction,
/// RRA stock report, refund restock) therefore see a combo line as one line
/// per component, built here. Those component lines exist only in memory:
/// their ids mark them so a "stock deducted" flag lands on the real combo line.
const _componentIdSeparator = '::combo::';

/// The in-memory id of [variantId]'s line inside combo line [comboLineId].
String comboComponentLineId(String comboLineId, String variantId) =>
    '$comboLineId$_componentIdSeparator$variantId';

/// The combo line a component line came from; null for a real line.
String? comboLineIdOf(String lineId) {
  final i = lineId.indexOf(_componentIdSeparator);
  return i < 0 ? null : lineId.substring(0, i);
}

/// One component's line for [comboLine]: [Composite.qty] (1 when unset) of
/// [component] per combo sold. It counts as stock-deducted exactly when the
/// combo line does.
TransactionItem comboComponentLine(
  TransactionItem comboLine,
  Composite composite,
  Variant component,
) {
  final perCombo = (composite.qty ?? 0) > 0 ? composite.qty! : 1.0;
  final qty = comboLine.qty.toDouble() * perCombo;
  final shipped = comboLine.quantityShipped == comboLine.qty.toInt();
  final retail = (component.retailPrice ?? 0).toDouble();
  // Tax as the goods sale path stores it on a line (saveTransactionItem):
  // the stock-IO envelope sums it.
  final pricing = SaleLinePricing.compute(
    unitPrice: retail,
    qty: qty,
    taxTyCd: component.taxTyCd,
    taxPercentage: (component.taxPercentage ?? 18.0).toDouble(),
  );
  return TransactionItem(
    id: comboComponentLineId(comboLine.id, component.id),
    transactionId: comboLine.transactionId,
    branchId: comboLine.branchId,
    variantId: component.id,
    productId: component.productId,
    name: component.name,
    itemNm: component.itemNm ?? component.name,
    itemCd: component.itemCd,
    itemClsCd: component.itemClsCd,
    itemTyCd: component.itemTyCd,
    itemStdNm: component.itemStdNm,
    qtyUnitCd: component.qtyUnitCd,
    pkgUnitCd: component.pkgUnitCd,
    orgnNatCd: component.orgnNatCd,
    bcd: component.bcd,
    taxTyCd: component.taxTyCd,
    ttCatCd: component.ttCatCd,
    taxPercentage: component.taxPercentage,
    taxAmt: pricing.taxAmt,
    itemSeq: comboLine.itemSeq,
    qty: qty,
    price: retail,
    prc: retail,
    supplyPrice: component.supplyPrice,
    discount: 0,
    quantityShipped: shipped ? qty.toInt() : 0,
  );
}

/// [items] with each combo line replaced by its component lines, in order.
///
/// [productIdOf] gives a line's product; [componentsByProductId] holds the
/// components of every product that is a combo (and only those);
/// [variantsById] the component variants. A component whose variant is gone
/// is left out.
List<TransactionItem> expandComboLines(
  List<TransactionItem> items, {
  required String? Function(TransactionItem line) productIdOf,
  required Map<String, List<Composite>> componentsByProductId,
  required Map<String, Variant> variantsById,
}) {
  if (componentsByProductId.isEmpty) return items;
  final out = <TransactionItem>[];
  for (final item in items) {
    final components = componentsByProductId[productIdOf(item)];
    if (components == null || !isServiceItemType(item.itemTyCd)) {
      out.add(item);
      continue;
    }
    for (final composite in components) {
      final variant = variantsById[composite.variantId];
      if (variant != null)
        out.add(comboComponentLine(item, composite, variant));
    }
  }
  return out;
}

/// [items] as stock sees them: combo lines become their components
/// ([expandComboLines]). Reads local data, and only for service lines: a
/// product counts as a combo when it is marked composite and has components.
/// A combo with no components on this till gets one remote fetch, bounded by
/// [remoteTimeout]; when that finds none either, it is logged and skipped.
Future<List<TransactionItem>> expandComboLinesForStock(
  List<TransactionItem> items, {
  required DatabaseSyncInterface capella,
  required String? businessId,
  required String? branchId,
  Duration remoteTimeout = comboComponentsRemoteTimeout,
}) async {
  final serviceLines = items
      .where(
        (i) => isServiceItemType(i.itemTyCd) && comboLineIdOf(i.id) == null,
      )
      .toList();
  if (serviceLines.isEmpty || businessId == null || businessId.isEmpty) {
    return items;
  }

  final needVariant = serviceLines
      .where(
        (l) => (l.productId ?? '').isEmpty && (l.variantId ?? '').isNotEmpty,
      )
      .map((l) => l.variantId!)
      .toSet()
      .toList();
  final lineVariants = needVariant.isEmpty
      ? const <String, Variant>{}
      : await capella.batchGetVariantsByIds(needVariant);
  String? productIdOf(TransactionItem line) {
    final own = line.productId;
    if (own != null && own.isNotEmpty) return own;
    return lineVariants[line.variantId]?.productId;
  }

  final componentsByProductId = <String, List<Composite>>{};
  final branchByProduct = <String, String>{};
  for (final line in serviceLines) {
    final pid = productIdOf(line);
    if (pid != null && pid.isNotEmpty) {
      final branch = line.branchId ?? branchId;
      if (branch != null && branch.isNotEmpty) {
        branchByProduct.putIfAbsent(pid, () => branch);
      }
    }
  }
  for (final entry in branchByProduct.entries) {
    final product = await capella.getProduct(
      id: entry.key,
      branchId: entry.value,
      businessId: businessId,
    );
    if (product?.isComposite != true) continue;
    // Local first: this runs on the Pay path, which must never wait long on
    // the network.
    var components = await capella.composites(
      productId: entry.key,
      localOnly: true,
    );
    if (components.isEmpty) {
      // A combo made before #587 may have no rows on this till yet (fresh
      // install, new till). Fetch them once, bounded, so the sale still moves
      // its components' stock.
      components = await _remoteComponents(capella, entry.key, remoteTimeout);
    }
    if (components.isNotEmpty) {
      componentsByProductId[entry.key] = components;
    } else {
      talker.warning(
        'Combo "${product?.name}" (${entry.key}) has no components on this '
        'till or the server: its components\' stock was not moved.',
      );
    }
  }
  if (componentsByProductId.isEmpty) return items;

  final componentIds = componentsByProductId.values
      .expand((c) => c)
      .map((c) => c.variantId)
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  final variantsById = componentIds.isEmpty
      ? const <String, Variant>{}
      : await capella.batchGetVariantsByIds(componentIds);

  return expandComboLines(
    items,
    productIdOf: productIdOf,
    componentsByProductId: componentsByProductId,
    variantsById: variantsById,
  );
}

/// How long Pay waits for a combo's components from the server when this
/// till has none of them.
const comboComponentsRemoteTimeout = Duration(seconds: 5);

/// [productId]'s components from the server, or none when the fetch fails or
/// takes longer than [timeout].
Future<List<Composite>> _remoteComponents(
  DatabaseSyncInterface capella,
  String productId,
  Duration timeout,
) async {
  try {
    return await Future.sync(
      () => capella.composites(productId: productId, localOnly: false),
    ).timeout(timeout);
  } catch (e) {
    talker.warning('Combo $productId: remote components fetch failed: $e');
    return const <Composite>[];
  }
}

/// The stored sale lines to mark "stock deducted" after [deducted] lines moved
/// stock: a real line marks itself; a combo's component line marks its combo
/// line, once, however many of its components moved. A retry then skips the
/// whole combo instead of deducting it twice.
List<TransactionItem> saleLinesToMarkShipped(
  Iterable<TransactionItem> deducted,
  Map<String, TransactionItem> saleLinesById,
) {
  final marked = <String, TransactionItem>{};
  for (final item in deducted) {
    final comboId = comboLineIdOf(item.id);
    final line = comboId == null ? item : saleLinesById[comboId];
    if (line != null) marked[line.id] = line;
  }
  return marked.values.toList();
}

/// What the combos in a cart take of each stocked component: for every
/// combo in [combosInCart] (combo variant id → qty), [Composite.qty] (1 when
/// unset) of each of its [componentsByCombo] per combo. Components that hold
/// no stock (services, gone) are left out.
Map<String, double> comboComponentNeeds({
  required Map<String, List<Composite>> componentsByCombo,
  required Map<String, double> combosInCart,
  required Map<String, Variant> variantsById,
}) {
  final needs = <String, double>{};
  for (final entry in componentsByCombo.entries) {
    final combos = combosInCart[entry.key] ?? 0;
    if (combos <= 0) continue;
    for (final component in entry.value) {
      final variant = variantsById[component.variantId];
      if (variant == null || isServiceItemType(variant.itemTyCd)) continue;
      final perCombo = (component.qty ?? 0) > 0 ? component.qty! : 1.0;
      needs[variant.id] = (needs[variant.id] ?? 0) + perCombo * combos;
    }
  }
  return needs;
}

/// Whether the stock covers what the cart's combos take of each component
/// ([needs], from [comboComponentNeeds] over every combo in the cart) plus
/// what the cart holds of that component on its own ([inCartAlone]).
/// Components with no stock record never block.
bool comboComponentsInStock({
  required Map<String, double> needs,
  required Map<String, Variant> variantsById,
  required Map<String, Stock> stocksById,
  required double Function(String variantId) inCartAlone,
}) {
  for (final entry in needs.entries) {
    final stockId = variantsById[entry.key]?.stockId;
    if (stockId == null || stockId.isEmpty) continue;
    final onHand = stocksById[stockId]?.currentStock ?? 0;
    if (onHand < entry.value + inCartAlone(entry.key)) return false;
  }
  return true;
}
