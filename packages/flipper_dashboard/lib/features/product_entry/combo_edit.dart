import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/features/product_entry/combo_component_diff.dart';
import 'package:flipper_dashboard/features/product_entry/combo_save_values.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';

/// An edited combo as saved: the lines the editor shows (quantities kept) and
/// the rows they came from, which its save updates instead of duplicating.
typedef LoadedCombo = ({
  List<VariantState> lines,
  List<SavedComboComponent> saved,
});

/// Reads a combo's saved component rows and the variants they point at.
///
/// A component whose variant is not on this device (yet) is left out of both
/// lists, so a save neither shows it nor reads it as removed and deletes it.
/// A component saved twice shows once; both rows are kept in [LoadedCombo.saved]
/// so the save can delete the extra one.
Future<LoadedCombo> loadComboComponents({
  required DatabaseSyncInterface strategy,
  required String productId,
}) async {
  final rows = await strategy.composites(productId: productId, localOnly: true);
  final lines = <VariantState>[];
  final saved = <SavedComboComponent>[];
  final unresolved = <String>{};
  for (final row in rows) {
    final variantId = row.variantId;
    if (variantId == null || variantId.isEmpty) continue;
    if (unresolved.contains(variantId)) continue;
    final qty = row.qty ?? 1;
    if (lines.any((l) => l.variant.id == variantId)) {
      saved.add((id: row.id, variantId: variantId, qty: qty));
      continue;
    }
    final component = await strategy.getVariant(id: variantId);
    if (component == null) {
      unresolved.add(variantId);
      continue;
    }
    saved.add((id: row.id, variantId: variantId, qty: qty));
    lines.add(
      VariantState(
        variant: VVariant(
          productName: component.productName ?? component.name,
          name: component.name,
          id: component.id,
          productId: component.productId ?? '',
          retailPrice: component.retailPrice ?? 0,
          supplyPrice: component.supplyPrice ?? 0,
        ),
        quantity: qty,
      ),
    );
  }
  return (lines: lines, saved: saved);
}

/// Puts the form onto the combo's own variant (named after the combo when it
/// was made): name, bar code, kind, and the SKU when one is typed (blank keeps
/// the one it has). Returns its item type: "2" made in Production Output,
/// "3" put together when sold.
String applyComboForm(
  Variant comboVariant, {
  required ComboSaveValues values,
  required bool madeInProduction,
}) {
  if (values.sku.isNotEmpty) comboVariant.sku = values.sku;
  comboVariant.bcd = values.barcode;
  comboVariant.name = values.name;
  final itemType = madeInProduction ? '2' : '3';
  comboVariant.itemTyCd = itemType;
  return itemType;
}

/// Saves an edited combo in place, never through the create path:
/// - its component rows are updated, added or deleted to match [lines]
///   (see [planComboComponentChanges]), so none is written twice;
/// - the product is renamed and stays a combo;
/// - its own variant takes the form ([applyComboForm]) and is then updated by
///   [updateVariant] (the editor's usual variant update), never re-created.
///
/// [retailPrice] is the price the user changed to, or null when unchanged; the
/// component rows then keep the variant's own price.
Future<ComboComponentChanges> updateComboInPlace({
  required DatabaseSyncInterface strategy,
  required String productId,
  required String branchId,
  required String businessId,
  required Variant comboVariant,
  required ComboSaveValues values,
  required bool madeInProduction,
  required List<SavedComboComponent> saved,
  required List<VariantState> lines,
  required double? retailPrice,
  required Future<void> Function(String itemType) updateVariant,
}) async {
  final changes = planComboComponentChanges(
    saved: saved,
    lines: [
      for (final line in lines)
        (variantId: line.variant.id, qty: line.quantity),
    ],
  );
  for (final row in changes.upserts) {
    await strategy.saveComposite(
      composite: Composite(
        id: row.id,
        businessId: businessId,
        productId: productId,
        qty: row.qty,
        actualPrice: retailPrice ?? comboVariant.retailPrice ?? 0,
        branchId: branchId,
        variantId: row.variantId,
      ),
    );
  }
  for (final id in changes.deleteIds) {
    await strategy.flipperDelete(id: id, endPoint: 'composite');
  }
  talker.info(
    'Combo $productId edited: ${changes.upserts.length} component(s), '
    '${changes.deleteIds.length} removed',
  );

  await strategy.updateProduct(
    productId: productId,
    branchId: branchId,
    businessId: businessId,
    name: values.name,
    isComposite: true,
  );

  final itemType = applyComboForm(
    comboVariant,
    values: values,
    madeInProduction: madeInProduction,
  );
  await updateVariant(itemType);
  return changes;
}
