import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'stock_value_insights.dart';
import 'stock_value_product_detail_dialog.dart';
import 'stock_value_report_common.dart';

// The Stock Health product table: which columns fit a width, the sortable
// header and one product row. The header and the rows ask
// StockValueTableColumns.forWidth with the same width, so they line up.

/// Column the product table is sorted by.
enum StockValueSortKey { name, category, unitPrice, stock, value, expiry }

// Shared column widths so the header and the rows line up.
const double _kColBcd = 80;
const double _kColPrice = 100;
const double _kColStock = 120;
const double _kColValue = 110;
const double _kColStatus = 104;
const double _kColExpiry = 100;

/// Narrowest the flexible Product and Category columns may get before a
/// fixed column is dropped.
const double _kMinProductWidth = 120;
const double _kMinCategoryWidth = 80;

/// Narrowest the Value column gets before it is hidden.
const double _kMinValueWidth = 48;

/// Which columns the product table shows at a given width. Below what
/// everything needs, BCD goes first, then Unit price, Category, Stock and
/// Status; on a pane narrower still, Value narrows and finally goes, so
/// Product never shrinks to nothing and the fixed columns never overflow
/// ([fixedWidth] <= width at any width). The header and the rows ask with
/// the same width, so they line up.
class StockValueTableColumns {
  final bool expiry;
  final bool bcd;
  final bool unitPrice;
  final bool category;
  final bool stock;
  final bool status;

  /// Width of the Value column; 0 when it is hidden.
  final double valueWidth;

  const StockValueTableColumns({
    this.expiry = false,
    required this.bcd,
    required this.unitPrice,
    required this.category,
    required this.stock,
    required this.status,
    required this.valueWidth,
  });

  bool get value => valueWidth > 0;

  /// Width of the fixed-width columns shown; the rest goes to Product (and
  /// Category).
  double get fixedWidth =>
      (expiry ? _kColExpiry : 0) +
      (bcd ? _kColBcd : 0) +
      (unitPrice ? _kColPrice : 0) +
      (stock ? _kColStock : 0) +
      valueWidth +
      (status ? _kColStatus : 0);

  /// [withExpiry]: the shop tracks expiry dates, so the Expiry column is
  /// wanted; it is the first to go when the table narrows.
  factory StockValueTableColumns.forWidth(
    double width, {
    bool withExpiry = false,
  }) {
    var expiry = withExpiry;
    var bcd = true, unitPrice = true, category = true, stock = true;
    var status = true;
    bool fits() {
      final fixed =
          (expiry ? _kColExpiry : 0) +
          (bcd ? _kColBcd : 0) +
          (unitPrice ? _kColPrice : 0) +
          (stock ? _kColStock : 0) +
          _kColValue +
          (status ? _kColStatus : 0);
      final flexible = _kMinProductWidth + (category ? _kMinCategoryWidth : 0);
      return width - fixed >= flexible;
    }

    if (!fits()) expiry = false;
    if (!fits()) bcd = false;
    if (!fits()) unitPrice = false;
    if (!fits()) category = false;
    if (!fits()) stock = false;
    if (!fits()) status = false;
    // Only Product and Value left: Value takes what Product leaves, and goes
    // once that is too narrow for an amount.
    final room = (width - _kMinProductWidth).clamp(0.0, _kColValue);
    return StockValueTableColumns(
      expiry: expiry,
      bcd: bcd,
      unitPrice: unitPrice,
      category: category,
      stock: stock,
      status: status,
      valueWidth: room < _kMinValueWidth ? 0 : room,
    );
  }
}

class StockValueTableHeader extends StatelessWidget {
  final bool showExpiry;
  final StockValueSortKey sortKey;
  final bool ascending;
  final ValueChanged<StockValueSortKey> onSort;

  const StockValueTableHeader({
    required this.showExpiry,
    required this.sortKey,
    required this.ascending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final style = GoogleFonts.outfit(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: Colors.black45,
    );

    Widget sortable(
      String label,
      StockValueSortKey key, {
      bool alignEnd = false,
    }) {
      final active = key == sortKey;
      final text = Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: active ? style.copyWith(color: Colors.black87) : style,
      );
      return InkWell(
        key: Key('stockValueSort_${key.name}'),
        onTap: () => onSort(key),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: alignEnd
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(child: text),
              if (active)
                Icon(
                  ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: Colors.black87,
                ),
            ],
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final cols = StockValueTableColumns.forWidth(
            box.maxWidth,
            withExpiry: showExpiry,
          );
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: sortable(
                  l10n.stockValueColProduct,
                  StockValueSortKey.name,
                ),
              ),
              if (cols.category)
                Expanded(
                  child: sortable(
                    l10n.stockValueColCategory,
                    StockValueSortKey.category,
                  ),
                ),
              if (cols.bcd)
                SizedBox(
                  width: _kColBcd,
                  child: Text('BCD', style: style),
                ),
              if (cols.unitPrice)
                SizedBox(
                  width: _kColPrice,
                  child: sortable(
                    l10n.stockValueColUnitPrice,
                    StockValueSortKey.unitPrice,
                  ),
                ),
              if (cols.stock)
                SizedBox(
                  width: _kColStock,
                  child: sortable(
                    l10n.stockValueColStock,
                    StockValueSortKey.stock,
                  ),
                ),
              if (cols.value)
                SizedBox(
                  width: cols.valueWidth,
                  child: sortable(
                    l10n.stockValueColValue,
                    StockValueSortKey.value,
                    alignEnd: true,
                  ),
                ),
              if (cols.expiry)
                SizedBox(
                  width: _kColExpiry,
                  child: sortable(
                    l10n.stockValueColExpiry,
                    StockValueSortKey.expiry,
                    alignEnd: true,
                  ),
                ),
              if (cols.status)
                SizedBox(
                  width: _kColStatus,
                  child: Text(
                    l10n.stockValueColStatus,
                    textAlign: TextAlign.right,
                    style: style,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class StockValueProductRow extends StatelessWidget {
  final StockValueProductLine line;
  final bool showExpiry;

  const StockValueProductRow({required this.line, required this.showExpiry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final String label;
    final Color fg;
    final Color bg;
    switch (line.status) {
      case StockValueLineStatus.ok:
        label = l10n.stockValueStatusOk;
        fg = const Color(0xFF16A34A);
        bg = const Color(0xFFDCFCE7);
        break;
      case StockValueLineStatus.low:
        label = l10n.stockValueStatusLow;
        fg = const Color(0xFF92400E);
        bg = const Color(0xFFFEF3C7);
        break;
      case StockValueLineStatus.critical:
        label = l10n.stockValueStatusCritical;
        fg = const Color(0xFFB91C1C);
        bg = const Color(0xFFFEE2E2);
        break;
      case StockValueLineStatus.out:
        label = l10n.stockValueStatusOut;
        fg = const Color(0xFF475569);
        bg = const Color(0xFFE2E8F0);
        break;
    }

    final denom = line.minStock > 0 ? (line.minStock * 2) : 1.0;
    var progress = (line.currentStock / denom).clamp(0.0, 1.0);
    if (line.minStock <= 0) {
      progress = line.currentStock > 0 ? 1.0 : 0.0;
    }
    final negative = line.currentStock < 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: InkWell(
        onTap: () => showStockValueProductDetailDialog(context, line: line),
        hoverColor: kStockValueAccentBlue.withValues(alpha: 0.06),
        child: LayoutBuilder(
          builder: (context, box) {
            final cols = StockValueTableColumns.forWidth(
              box.maxWidth,
              withExpiry: showExpiry,
            );
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    line.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (cols.category)
                  Expanded(
                    child: Text(
                      line.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                if (cols.bcd)
                  SizedBox(
                    width: _kColBcd,
                    child: Text(
                      (line.bcd == null || line.bcd!.isEmpty) ? '—' : line.bcd!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlipperFonts.mono(fontSize: 12),
                    ),
                  ),
                if (cols.unitPrice)
                  SizedBox(
                    width: _kColPrice,
                    child: Text(
                      'RWF ${formatNumber(line.unitPrice)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlipperFonts.mono(fontSize: 12),
                    ),
                  ),
                if (cols.stock)
                  SizedBox(
                    width: _kColStock,
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: Colors.black.withValues(
                                alpha: 0.08,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(fg),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Seven 12px mono characters, e.g. -12.345 or
                        // 123.456; the bar keeps the rest of the column.
                        SizedBox(
                          width: 56,
                          child: Text(
                            formatStockQty(line.currentStock),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: FlipperFonts.mono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: negative ? const Color(0xFFB91C1C) : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (cols.value)
                  SizedBox(
                    width: cols.valueWidth,
                    child: Text(
                      'RWF ${formatNumber(line.lineValue)}',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlipperFonts.mono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (cols.expiry)
                  SizedBox(
                    width: _kColExpiry,
                    child: StockValueExpiryText(line: line),
                  ),
                if (cols.status)
                  SizedBox(
                    width: _kColStatus,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: fg,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
