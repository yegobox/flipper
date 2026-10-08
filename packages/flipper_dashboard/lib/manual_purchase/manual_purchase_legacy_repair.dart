import 'package:collection/collection.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';

/// What to do with one legacy manual purchase line (see
/// [ManualPurchaseDitto.legacyLines]).
enum LegacyLineRepairAction {
  /// Nothing left on hand: just turn it into a purchase record.
  retire,

  /// Move what is left on hand onto the catalog product, then retire it.
  merge,

  /// Already repaired, but its stock is off zero (another device moved it
  /// too, or a refund landed on it): move the difference to its product.
  rebalance,

  /// Stock left, but no single product to give it to: leave it for a person.
  review,

  /// Already repaired and settled.
  none,
}

class LegacyLineRepairPlan {
  const LegacyLineRepairPlan(this.action, {this.target});

  final LegacyLineRepairAction action;

  /// The catalog variant that takes the stock, for
  /// [LegacyLineRepairAction.merge] and [LegacyLineRepairAction.rebalance].
  final Variant? target;
}

String _key(String? value) => (value ?? '').trim().toLowerCase();

/// A sellable catalog row the line's stock may go to: a real product on the
/// same branch with a stock row to receive it, not another purchase line, and
/// not hidden from the POS. A product without stock would make the move throw
/// on every run instead of leaving the line for review.
bool _isCatalogProduct(Variant candidate, Variant line) =>
    candidate.id != line.id &&
    candidate.branchId == line.branchId &&
    (candidate.productId ?? '').isNotEmpty &&
    (candidate.stockId ?? '').trim().isNotEmpty &&
    (candidate.purchaseId ?? '').isEmpty &&
    !const {'01', '03', '04'}.contains(candidate.pchsSttsCd) &&
    !const {'2', '4'}.contains(candidate.imptItemSttsCd);

/// Decides one legacy line. A match is tried by item code, then barcode, then
/// name; the first of those that names exactly one product wins, so two
/// products sharing a name never get a guess. A line an earlier run already
/// repaired keeps the product it was given ([repairedTargetId]).
LegacyLineRepairPlan planLegacyLineRepair({
  required Variant line,
  required double onHand,
  required Iterable<Variant> catalog,
  bool repaired = false,
  String? repairedTargetId,
}) {
  if (repaired) {
    if (onHand == 0 || repairedTargetId == null) {
      return const LegacyLineRepairPlan(LegacyLineRepairAction.none);
    }
    final target = catalog.firstWhereOrNull((v) => v.id == repairedTargetId);
    return target == null
        ? const LegacyLineRepairPlan(LegacyLineRepairAction.review)
        : LegacyLineRepairPlan(
            LegacyLineRepairAction.rebalance,
            target: target,
          );
  }
  if (onHand <= 0) {
    return const LegacyLineRepairPlan(LegacyLineRepairAction.retire);
  }

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

  /// False until Ditto is open; the repair then reports it did not run.
  bool get ready;
  Future<List<LegacyPurchaseLine>> legacyLines(String branchId);
  Future<List<Variant>> branchVariants(String branchId);

  /// On-hand of a stock row, or null when it does not exist.
  Future<double?> onHand(String stockId);
  Future<void> retire(String lineId);

  /// Moves [qty] (possibly negative) from [line]'s stock to [target]'s and
  /// marks the line repaired, atomically (see
  /// [ManualPurchaseDitto.moveLegacyLineStock]).
  Future<void> move({
    required Variant line,
    required Variant target,
    required double qty,
  });
}

class DittoLegacyLineRepairStore extends LegacyLineRepairStore {
  const DittoLegacyLineRepairStore();

  @override
  bool get ready => ManualPurchaseDitto.isReady;

  @override
  Future<List<LegacyPurchaseLine>> legacyLines(String branchId) =>
      ManualPurchaseDitto.legacyLines(branchId);

  @override
  Future<List<Variant>> branchVariants(String branchId) =>
      ManualPurchaseDitto.branchVariants(branchId);

  @override
  Future<double?> onHand(String stockId) =>
      ManualPurchaseDitto.stockOnHand(stockId);

  @override
  Future<void> retire(String lineId) =>
      ManualPurchaseDitto.retireLegacyLine(lineId);

  @override
  Future<void> move({
    required Variant line,
    required Variant target,
    required double qty,
  }) {
    final lineStockId = line.stockId?.trim() ?? '';
    final targetStockId = target.stockId?.trim() ?? '';
    if (lineStockId.isEmpty || targetStockId.isEmpty) {
      throw StateError('Line ${line.id} or product ${target.id} has no stock');
    }
    return ManualPurchaseDitto.moveLegacyLineStock(
      lineId: line.id,
      lineStockId: lineStockId,
      targetVariantId: target.id,
      targetStockId: targetStockId,
      qty: qty,
    );
  }
}

class LegacyLineRepairResult {
  const LegacyLineRepairResult({
    this.ran = true,
    this.merged = 0,
    this.rebalanced = 0,
    this.retired = 0,
    this.failed = 0,
    this.deferred = 0,
    this.review = const [],
    this.settledStockIds = const [],
  });

  /// False when Ditto was not open yet, so nothing was looked at.
  final bool ran;
  final int merged;
  final int rebalanced;
  final int retired;

  /// Lines whose repair threw; a later run tries them again.
  final int failed;

  /// Lines whose stock row has not synced to this device yet: their on-hand
  /// is unknown, so they are left for a later run rather than retired.
  final int deferred;

  /// Names of lines left as they were (still selling on their own).
  final List<String> review;

  /// Stock rows of lines whose stock now sits on a product. Another device's
  /// move of the same line shows up here, after a sync, as a balance off
  /// zero (see [legacyLineBalancesDrifted]).
  final List<String> settledStockIds;

  bool get changedCatalog => merged + rebalanced + retired > 0;

  /// Every line was looked at and settled; nothing is left to retry.
  bool get complete => ran && failed == 0 && deferred == 0;
}

/// Clears manual purchase lines that builds before #710 left in the catalog:
/// they were approved to `'02'` with stock of their own, so they sell as
/// separate products (the bar grid lists them even at zero stock). Each line's
/// remaining stock moves onto the product it was bought for and the line
/// becomes a purchase record (`'03'`), as approval does today.
///
/// Safe to run on several devices: each move is atomic locally, and a move
/// two offline devices both made shows up as the line's stock going negative,
/// which the next run moves back ([LegacyLineRepairAction.rebalance]). The
/// stock move is not reported to RRA.
Future<LegacyLineRepairResult> repairLegacyManualPurchaseLines({
  required String branchId,
  LegacyLineRepairStore store = const DittoLegacyLineRepairStore(),
}) async {
  if (!store.ready) return const LegacyLineRepairResult(ran: false);
  final lines = await store.legacyLines(branchId);
  if (lines.isEmpty) return const LegacyLineRepairResult();
  final catalog = await store.branchVariants(branchId);

  var merged = 0;
  var rebalanced = 0;
  var retired = 0;
  var failed = 0;
  var deferred = 0;
  final review = <String>[];
  final settled = <String>[];
  for (final legacy in lines) {
    final line = legacy.line;
    try {
      // A line without a stock row has nothing on hand. One whose row has
      // not synced yet might: retiring it would strand that stock.
      final stockId = line.stockId?.trim() ?? '';
      final onHand = stockId.isEmpty ? 0.0 : await store.onHand(stockId);
      if (onHand == null) {
        deferred++;
        continue;
      }
      final plan = planLegacyLineRepair(
        line: line,
        onHand: onHand,
        catalog: catalog,
        repaired: legacy.repaired,
        repairedTargetId: legacy.targetVariantId,
      );
      switch (plan.action) {
        case LegacyLineRepairAction.retire:
          await store.retire(line.id);
          retired++;
        case LegacyLineRepairAction.merge:
        case LegacyLineRepairAction.rebalance:
          await store.move(line: line, target: plan.target!, qty: onHand);
          if (plan.action == LegacyLineRepairAction.merge) {
            merged++;
          } else {
            rebalanced++;
          }
          settled.add(stockId);
          talker.info(
            'Legacy purchase line ${line.id}: $onHand moved to '
            '${plan.target!.id} (${plan.action.name})',
          );
        case LegacyLineRepairAction.review:
          review.add(line.itemNm ?? line.name);
        case LegacyLineRepairAction.none:
          if (legacy.targetVariantId != null && stockId.isNotEmpty) {
            settled.add(stockId);
          }
      }
    } catch (e, s) {
      failed++;
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
    rebalanced: rebalanced,
    retired: retired,
    failed: failed,
    deferred: deferred,
    review: review,
    settledStockIds: settled,
  );
}

/// Whether a sync has since put any of [stockIds] (a complete run's
/// [LegacyLineRepairResult.settledStockIds]) off zero: another device moved
/// the same line, so the repair has a balance to move back. Reads only those
/// stock rows, so it is cheap enough for every Purchases load.
Future<bool> legacyLineBalancesDrifted(
  List<String> stockIds, {
  LegacyLineRepairStore store = const DittoLegacyLineRepairStore(),
}) async {
  if (stockIds.isEmpty || !store.ready) return false;
  for (final stockId in stockIds) {
    final onHand = await store.onHand(stockId);
    if (onHand != null && onHand != 0) return true;
  }
  return false;
}
