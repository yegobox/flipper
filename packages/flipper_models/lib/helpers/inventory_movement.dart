import 'dart:math' as math;

/// Reporting window for inventory movement figures.
enum InventoryWindow { today, days7, days30, days90 }

extension InventoryWindowX on InventoryWindow {
  /// Whole days covered by the window (today counts as 1).
  int get days => switch (this) {
        InventoryWindow.today => 1,
        InventoryWindow.days7 => 7,
        InventoryWindow.days30 => 30,
        InventoryWindow.days90 => 90,
      };

  String get shortLabel => switch (this) {
        InventoryWindow.today => 'Today',
        InventoryWindow.days7 => '7 days',
        InventoryWindow.days30 => '30 days',
        InventoryWindow.days90 => '90 days',
      };

  String get longLabel => switch (this) {
        InventoryWindow.today => 'today',
        InventoryWindow.days7 => 'the last 7 days',
        InventoryWindow.days30 => 'the last 30 days',
        InventoryWindow.days90 => 'the last 90 days',
      };
}

/// Inclusive day window ending today.
({DateTime start, DateTime end}) inventoryWindowRange(InventoryWindow window) {
  final now = DateTime.now();
  final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  final startDay = now.subtract(Duration(days: window.days - 1));
  final start = DateTime(startDay.year, startDay.month, startDay.day);
  return (start: start, end: end);
}

/// What actually happened to one variant's stock inside a window.
///
/// Everything here is measured, never inferred from `initialStock`: units come
/// from completed sale lines, adjustments from submitted stock recounts, and
/// receipts from the gaps in the sale-line stock ledger.
class VariantMovement {
  const VariantMovement({
    required this.variantId,
    required this.unitsSold,
    required this.unitsRefunded,
    required this.revenue,
    required this.profit,
    required this.saleCount,
    required this.lastSoldAt,
    required this.adjustment,
    required this.lastCountedAt,
    required this.openingStock,
    required this.restocked,
    required this.lastRemainingStock,
  });

  static const empty = VariantMovement(
    variantId: '',
    unitsSold: 0,
    unitsRefunded: 0,
    revenue: 0,
    profit: 0,
    saleCount: 0,
    lastSoldAt: null,
    adjustment: 0,
    lastCountedAt: null,
    openingStock: null,
    restocked: null,
    lastRemainingStock: null,
  );

  final String variantId;

  /// Net units that left the shelf through completed sales.
  final double unitsSold;

  /// Units on lines flagged as refunded (excluded from [unitsSold]).
  final double unitsRefunded;

  /// Gross selling value of those units.
  final double revenue;

  /// Selling value minus recorded supply cost.
  final double profit;

  /// Number of distinct sales the item appeared on.
  final int saleCount;

  final DateTime? lastSoldAt;

  /// Net counted difference from stock recounts: negative means shrink/loss.
  final double adjustment;

  final DateTime? lastCountedAt;

  /// Stock on the shelf just before the first sale of the window, when the
  /// sale-line ledger carries it. Null when no ledger reading is available.
  final double? openingStock;

  /// Units that appeared between sales (deliveries, transfers in, corrections).
  /// Null when the ledger is too sparse to tell.
  final double? restocked;

  /// Stock left after the most recent sale — lets a caller close the ledger
  /// against live stock without re-reading sale lines.
  final double? lastRemainingStock;

  bool get hasLedger => openingStock != null;

  double get shrink => adjustment < 0 ? -adjustment : 0;

  double get margin => revenue <= 0 ? 0 : profit / revenue;

  /// Average units sold per day across the window.
  double velocityPerDay(int windowDays) =>
      windowDays <= 0 ? 0 : unitsSold / windowDays;

  /// Days of stock left at the current selling pace. Null when nothing sold.
  double? daysOfCover(double currentStock, int windowDays) {
    final velocity = velocityPerDay(windowDays);
    if (velocity <= 0) return null;
    return currentStock / velocity;
  }

  /// Units that were available to sell during the window: what was on the
  /// shelf at the start plus everything that came in.
  double? availableInWindow(double currentStock) {
    if (openingStock == null) return null;
    final received = restocked ?? 0;
    final lateReceipt = lastRemainingStock == null
        ? 0.0
        : math.max(0.0, currentStock - lastRemainingStock!);
    return openingStock! + received + lateReceipt;
  }

  /// Share of the stock that was available in the window which actually sold.
  /// Falls back to `sold / (sold + current)` when there is no ledger.
  double sellThrough(double currentStock) {
    final available = availableInWindow(currentStock);
    if (available != null && available > 0) {
      return (unitsSold / available).clamp(0, 1);
    }
    final base = unitsSold + math.max(0, currentStock);
    return base <= 0 ? 0 : (unitsSold / base).clamp(0, 1);
  }
}

/// Branch-wide inventory movement for a window.
class InventoryMovementData {
  const InventoryMovementData({
    required this.branchId,
    required this.window,
    required this.start,
    required this.end,
    required this.byVariant,
    required this.salesCount,
    required this.unavailable,
  });

  const InventoryMovementData.unavailableFor({
    required this.branchId,
    required this.window,
    required this.start,
    required this.end,
  })  : byVariant = const {},
        salesCount = 0,
        unavailable = true;

  final String branchId;
  final InventoryWindow window;
  final DateTime start;
  final DateTime end;
  final Map<String, VariantMovement> byVariant;

  /// Completed sales that contributed counted lines.
  final int salesCount;

  /// True when movement could not be read (no Ditto/strategy, or a failure).
  /// Callers should say so rather than show zeros as fact.
  final bool unavailable;

  int get days => window.days;

  VariantMovement forVariant(String variantId) =>
      byVariant[variantId] ?? VariantMovement.empty;

  double get totalUnitsSold =>
      byVariant.values.fold(0, (s, m) => s + m.unitsSold);

  double get totalRevenue => byVariant.values.fold(0, (s, m) => s + m.revenue);

  double get totalProfit => byVariant.values.fold(0, (s, m) => s + m.profit);

  double get totalShrink => byVariant.values.fold(0, (s, m) => s + m.shrink);

  double get totalAdjustment =>
      byVariant.values.fold(0, (s, m) => s + m.adjustment);

  int get itemsWithSales =>
      byVariant.values.where((m) => m.unitsSold > 0).length;
}
