import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
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
/// ([expandComboLines]). Reads only local Ditto, and only for service lines:
/// a product counts as a combo when it is marked composite and has components.
Future<List<TransactionItem>> expandComboLinesForStock(
  List<TransactionItem> items, {
  required DatabaseSyncInterface capella,
  required String? businessId,
  required String? branchId,
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
    final components = await capella.composites(productId: entry.key);
    if (components.isNotEmpty) componentsByProductId[entry.key] = components;
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
