import 'package:flipper_dashboard/manual_purchase/manual_purchase_stock_in.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';

/// What to do with one legacy manual purchase line (see
/// [ManualPurchaseDitto.legacyApprovedLines]).
enum LegacyLineRepairAction {
  /// Nothing left on hand: just turn it into a purchase record.
  retire,

  /// Move what is left on hand onto the catalog product, then retire it.
  merge,

  /// Stock left, but no single product to give it to: leave it for a person.
  review,
}

class LegacyLineRepairPlan {
  const LegacyLineRepairPlan(this.action, {this.target});

  final LegacyLineRepairAction action;

  /// The catalog variant that takes the stock, for [LegacyLineRepairAction.merge].
  final Variant? target;
}

String _key(String? value) => (value ?? '').trim().toLowerCase();

/// A sellable catalog row the line's stock may go to: a real product on the
/// same branch, not another purchase line, and not hidden from the POS.
bool _isCatalogProduct(Variant candidate, Variant line) =>
    candidate.id != line.id &&
    candidate.branchId == line.branchId &&
    (candidate.productId ?? '').isNotEmpty &&
    (candidate.purchaseId ?? '').isEmpty &&
    !const {'01', '03', '04'}.contains(candidate.pchsSttsCd) &&
    !const {'2', '4'}.contains(candidate.imptItemSttsCd);

/// Decides one legacy line. A match is tried by item code, then barcode, then
/// name; the first of those that names exactly one product wins, so two
/// products sharing a name never get a guess.
LegacyLineRepairPlan planLegacyLineRepair({
  required Variant line,
  required double onHand,
  required Iterable<Variant> catalog,
}) {
  if (onHand <= 0)
    return const LegacyLineRepairPlan(LegacyLineRepairAction.retire);

  final products = catalog.where((v) => _isCatalogProduct(v, line)).toList();
  final name = _key(line.itemNm ?? line.name);
  final tiers = <(String, bool Function(Variant))>[
    (_key(line.itemCd), (v) => _key(v.itemCd) == _key(line.itemCd)),
    (_key(line.bcd), (v) => _key(v.bcd) == _key(line.bcd)),
    (name, (v) => _key(v.name) == name || _key(v.itemNm) == name),
  ];
  for (final (lineKey, matches) in tiers) {
    if (lineKey.isEmpty) continue;
    final hits = {for (final v in products.where(matches)) v.id: v};
    if (hits.length == 1) {
      return LegacyLineRepairPlan(
        LegacyLineRepairAction.merge,
        target: hits.values.single,
      );
    }
  }
  return const LegacyLineRepairPlan(LegacyLineRepairAction.review);
}

/// The Ditto reads and writes the repair makes, so it can run on fakes.
abstract class LegacyLineRepairStore {
  const LegacyLineRepairStore();

  Future<List<Variant>> legacyLines(String branchId);
  Future<List<Variant>> branchVariants(String branchId);
  Future<void> retire({required String lineId, String? targetVariantId});
}

class DittoLegacyLineRepairStore extends LegacyLineRepairStore {
  const DittoLegacyLineRepairStore();

  @override
  Future<List<Variant>> legacyLines(String branchId) =>
      ManualPurchaseDitto.legacyApprovedLines(branchId);

  @override
  Future<List<Variant>> branchVariants(String branchId) =>
      ManualPurchaseDitto.branchVariants(branchId);

  @override
  Future<void> retire({required String lineId, String? targetVariantId}) =>
      ManualPurchaseDitto.retireLegacyLine(
        lineId: lineId,
        targetVariantId: targetVariantId,
      );
}

class LegacyLineRepairResult {
  const LegacyLineRepairResult({
    this.merged = 0,
    this.retired = 0,
    this.review = const [],
  });

  final int merged;
  final int retired;

  /// Names of lines left as they were (still selling on their own).
  final List<String> review;
}

/// Clears manual purchase lines that builds before #710 left in the catalog:
/// they were approved to `'02'` with stock of their own, so they sell as
/// separate products (the bar grid lists them even at zero stock). Each line's
/// remaining stock moves onto the product it was bought for and the line
/// becomes a purchase record (`'03'`), as approval does today.
///
/// Re-running finds nothing to do: repaired lines are no longer `'02'`. The
/// stock move is not reported to RRA.
Future<LegacyLineRepairResult> repairLegacyManualPurchaseLines({
  required String branchId,
  required DatabaseSyncInterface capella,
  LegacyLineRepairStore store = const DittoLegacyLineRepairStore(),
}) async {
  final lines = await store.legacyLines(branchId);
  if (lines.isEmpty) return const LegacyLineRepairResult();
  final catalog = await store.branchVariants(branchId);

  var merged = 0;
  var retired = 0;
  final review = <String>[];
  for (final line in lines) {
    try {
      final stockId = line.stockId?.trim() ?? '';
      final stock = stockId.isEmpty
          ? null
          : await capella.getStockById(id: stockId);
      final onHand = (stock?.currentStock ?? 0).toDouble();
      final plan = planLegacyLineRepair(
        line: line,
        onHand: onHand,
        catalog: catalog,
      );
      switch (plan.action) {
        case LegacyLineRepairAction.retire:
          await store.retire(lineId: line.id);
          retired++;
        case LegacyLineRepairAction.merge:
          final target = plan.target!;
          // Add first: a crash before the line is retired re-runs the add,
          // where the other order would lose the stock outright.
          await addPurchasedStock(
            variant: target,
            qty: onHand,
            capella: capella,
          );
          await capella.updateStock(
            stockId: stock!.id,
            currentStock: 0,
            rsdQty: 0,
            lastTouched: DateTime.now().toUtc(),
          );
          await store.retire(lineId: line.id, targetVariantId: target.id);
          merged++;
          talker.info(
            'Legacy purchase line ${line.id}: +$onHand moved to ${target.id}',
          );
        case LegacyLineRepairAction.review:
          review.add(line.itemNm ?? line.name);
      }
    } catch (e, s) {
      talker.error('Legacy purchase line ${line.id} repair failed: $e', s);
    }
  }
  if (review.isNotEmpty) {
    talker.warning(
      'Legacy purchase lines with stock and no single matching product, '
      'left in the catalog: ${review.join(', ')}',
    );
  }
  return LegacyLineRepairResult(
    merged: merged,
    retired: retired,
    review: review,
  );
}
