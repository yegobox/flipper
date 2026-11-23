import 'package:flipper_models/db_model_export.dart';

/// One cart line a combo (composite product) adds per tap.
class ComboSaleLine {
  const ComboSaleLine({
    required this.variant,
    required this.qty,
    required this.currentStock,
  });

  /// The component sold.
  final Variant variant;

  /// How many of it one combo uses (`Composite.qty`; 1 when unset).
  final double qty;

  /// The component's own on-hand, reported to RRA as remaining stock.
  final double currentStock;
}

/// The lines one tap on a combo adds, in the combo's order. Components whose
/// variant can't be found (deleted since) are left out.
List<ComboSaleLine> planComboSaleLines(
  List<Composite> composites, {
  required Map<String, Variant> variantsById,
  required Map<String, Stock> stocksById,
}) {
  final lines = <ComboSaleLine>[];
  for (final composite in composites) {
    final variant = variantsById[composite.variantId];
    if (variant == null) continue;
    final perCombo = composite.qty ?? 0;
    lines.add(
      ComboSaleLine(
        variant: variant,
        qty: perCombo > 0 ? perCombo : 1,
        currentStock:
            stocksById[variant.stockId]?.currentStock ??
            variant.stock?.currentStock ??
            0,
      ),
    );
  }
  return lines;
}
