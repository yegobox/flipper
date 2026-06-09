import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_page_header.dart';
import 'package:flutter/material.dart';

class AccountingTableColumn {
  const AccountingTableColumn({
    required this.label,
    this.align = TextAlign.left,
    this.width,
  });

  final String label;
  final TextAlign align;
  final double? width;
}

class AccountingDataTable extends StatelessWidget {
  const AccountingDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.mutedRow,
    this.onRowTap,
  });

  final List<AccountingTableColumn> columns;
  final List<List<Widget>> rows;
  final bool Function(int index)? mutedRow;
  final void Function(int index)? onRowTap;

  @override
  Widget build(BuildContext context) {
    return AccountingCard(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AccountingTokens.radiusLg),
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
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AccountingTokens.line),
                        ),
                      ),
                      children: [
                        for (final col in columns)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
                            child: Align(
                              alignment: col.align == TextAlign.right
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                col.label.toUpperCase(),
                                style: AccountingTokens.tableHead,
                              ),
                            ),
                          ),
                      ],
                    ),
                    for (var ri = 0; ri < rows.length; ri++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: ri == rows.length - 1
                                  ? Colors.transparent
                                  : AccountingTokens.line.withValues(alpha: 0.65),
                            ),
                          ),
                        ),
                        children: [
                          for (var ci = 0; ci < rows[ri].length; ci++)
                            _Cell(
                              muted: mutedRow?.call(ri) ?? false,
                              onTap: onRowTap == null ? null : () => onRowTap!(ri),
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
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.child,
    required this.align,
    this.muted = false,
    this.onTap,
  });

  final Widget child;
  final TextAlign align;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Opacity(
      opacity: muted ? 0.55 : 1,
      child: Align(
        alignment: align == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: child,
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: AccountingTokens.surface2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: content,
        ),
      ),
    );
  }
}

/// Handoff `.rec-ic` — blue tinted icon box in recurring table rows.
class RecurringIconBox extends StatelessWidget {
  const RecurringIconBox({super.key, required this.icon});

  final AccIcon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AccountingTokens.accentTint,
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: AccountingIcon(icon: icon, size: 17, color: AccountingTokens.accent),
    );
  }
}
