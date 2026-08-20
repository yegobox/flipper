import 'package:flipper_design_system/src/theme/flipper_theme_extension.dart';
import 'package:flipper_design_system/src/tokens/flipper_radii.dart';
import 'package:flipper_design_system/src/tokens/flipper_typography.dart';
import 'package:flutter/material.dart';

/// Column spec for [FlipperDataTable].
class FlipperTableColumn {
  const FlipperTableColumn({
    required this.label,
    this.align = TextAlign.left,
    this.width,
  });

  final String label;
  final TextAlign align;
  final double? width;
}

/// Dense, sortable-by-caller data table for accounting and inventory
/// screens (journal/ledger views, stock lists). Built on [Table] rather
/// than Material's [DataTable] so it renders consistently across mobile,
/// desktop, and web instead of only fitting desktop pointer input.
///
/// Cell content is caller-supplied `Widget`s — use `FlipperFonts.mono` for
/// numeric/amount columns that need to align vertically.
class FlipperDataTable extends StatelessWidget {
  const FlipperDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.selectedRows = const {},
    this.zebraStriped = false,
    this.onRowTap,
    this.rowTapExcludeTrailingColumns = 0,
  });

  final List<FlipperTableColumn> columns;
  final List<List<Widget>> rows;
  final Set<int> selectedRows;
  final bool zebraStriped;
  final void Function(int index)? onRowTap;

  /// Trailing columns (e.g. a row menu) that should not trigger [onRowTap].
  final int rowTapExcludeTrailingColumns;

  @override
  Widget build(BuildContext context) {
    final ext = FlipperThemeExtension.of(context);
    final headStyle = TextStyle(
      fontSize: FontSizes.s11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      color: ext.secondaryTextColor,
    );

    return ClipRRect(
      borderRadius: Corners.s8Border,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  for (var i = 0; i < columns.length; i++)
                    if (columns[i].width != null)
                      i: FixedColumnWidth(columns[i].width!),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: ext.tableHeaderColor),
                    children: [
                      for (final col in columns)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
                          child: Align(
                            alignment: col.align == TextAlign.right
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Text(col.label.toUpperCase(), style: headStyle),
                          ),
                        ),
                    ],
                  ),
                  for (var ri = 0; ri < rows.length; ri++)
                    TableRow(
                      decoration: BoxDecoration(
                        color: selectedRows.contains(ri)
                            ? ext.tableRowSelectedColor
                            : (zebraStriped && ri.isOdd)
                                ? ext.tableRowAltColor
                                : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(color: ext.borderColor),
                        ),
                      ),
                      children: [
                        for (var ci = 0; ci < rows[ri].length; ci++)
                          _Cell(
                            hoverColor: ext.tableRowHoverColor,
                            onTap: onRowTap == null ||
                                    ci >=
                                        columns.length -
                                            rowTapExcludeTrailingColumns
                                ? null
                                : () => onRowTap!(ri),
                            align: columns[ci].align,
                            child: rows[ri][ci],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.child,
    required this.align,
    required this.hoverColor,
    this.onTap,
  });

  final Widget child;
  final TextAlign align;
  final Color hoverColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: hoverColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Align(
            alignment:
                align == TextAlign.right ? Alignment.centerRight : Alignment.centerLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}
