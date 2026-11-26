import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

import '../../../theme/pos_tokens.dart';
import '../models/production_output_models.dart';
import 'production_ui.dart';

/// The day's work orders on desktop: a status filter over a sortable table
/// with the row actions (start, record output, complete).
///
/// It sizes itself to its rows, so the page scrolls as one instead of a fixed
/// box scrolling inside it.
class WorkOrderTable extends StatefulWidget {
  final List<WorkOrder> workOrders;
  final bool isLoading;
  final Function(WorkOrder)? onRowTap;
  final Function(WorkOrder)? onRecordOutput;
  final Function(WorkOrder)? onStart;
  final Function(WorkOrder)? onComplete;

  /// The empty state's "new work order" action.
  final VoidCallback? onCreate;

  const WorkOrderTable({
    Key? key,
    required this.workOrders,
    this.isLoading = false,
    this.onRowTap,
    this.onRecordOutput,
    this.onStart,
    this.onComplete,
    this.onCreate,
  }) : super(key: key);

  @override
  State<WorkOrderTable> createState() => _WorkOrderTableState();
}

class _WorkOrderTableState extends State<WorkOrderTable> {
  String _sortColumn = 'targetDate';
  bool _sortAscending = false;
  String? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredOrders();
    final sortedOrders = _getSortedOrders(filteredOrders);

    return Container(
      decoration: productionCardDecoration(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTableHeader(context),
          const Divider(height: 1, color: PosTokens.line),
          if (widget.isLoading)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: PosTokens.blue,
                ),
              ),
            )
          else if (sortedOrders.isEmpty)
            _buildEmptyState(context)
          else
            _buildTable(context, sortedOrders),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final l10n = context.flipperL10n;
    // (label, filter value) — the value matches the stored work-order status.
    final filters = <(String, String?)>[
      (l10n.productionOutputFilterAll, null),
      (l10n.productionOutputStatusPlanned, 'planned'),
      (l10n.productionOutputStatusInProgress, 'in_progress'),
      (l10n.productionOutputStatusCompleted, 'completed'),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8,
        spacing: 16,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: PosTokens.ink2,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.productionOutputWorkOrders,
                style: PosTokens.sectionTitle,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.productionOutputItemsCount(widget.workOrders.length),
                style: PosTokens.meta,
              ),
            ],
          ),
          _FilterSegments(
            filters: filters,
            selected: _statusFilter,
            onSelected: (value) => setState(() => _statusFilter = value),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<WorkOrder> orders) {
    final l10n = context.flipperL10n;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: DataTable(
            sortColumnIndex: _getSortColumnIndex(),
            sortAscending: _sortAscending,
            showCheckboxColumn: false,
            headingRowHeight: 40,
            headingRowColor: const WidgetStatePropertyAll(PosTokens.surface2),
            headingTextStyle: PosTokens.eyebrow,
            dataTextStyle: PosTokens.body,
            dataRowMinHeight: 52,
            dataRowMaxHeight: 60,
            horizontalMargin: 16,
            columnSpacing: 24,
            dividerThickness: 1,
            border: const TableBorder(
              horizontalInside: BorderSide(color: PosTokens.line),
            ),
            columns: [
              DataColumn(
                label: Text(l10n.productionOutputProduct.toUpperCase()),
                onSort: (_, __) => _onSort('variantName'),
              ),
              DataColumn(
                label: Text(l10n.productionOutputTargetDate.toUpperCase()),
                onSort: (_, __) => _onSort('targetDate'),
              ),
              DataColumn(
                label: Text(l10n.productionOutputPlanned.toUpperCase()),
                numeric: true,
                onSort: (_, __) => _onSort('plannedQuantity'),
              ),
              DataColumn(
                label: Text(l10n.productionOutputActual.toUpperCase()),
                numeric: true,
                onSort: (_, __) => _onSort('actualQuantity'),
              ),
              DataColumn(
                label: Text(l10n.productionOutputVariance.toUpperCase()),
                numeric: true,
              ),
              DataColumn(
                label: Text(l10n.productionOutputStatus.toUpperCase()),
              ),
              DataColumn(label: Text(l10n.actions.toUpperCase())),
            ],
            rows: orders
                .map((order) => _buildDataRow(context, l10n, order))
                .toList(),
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    FlipperAppLocalizations l10n,
    WorkOrder order,
  ) {
    final status = WorkOrderStatus.fromString(order.status);
    final variance = order.variance;
    final varianceColor = variance >= 0
        ? Color(VarianceColors.positive)
        : Color(VarianceColors.negative);

    return DataRow(
      onSelectChanged: widget.onRowTap != null
          ? (_) => widget.onRowTap!(order)
          : null,
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                order.variantName ?? l10n.productionOutputUnknown,
                style: PosTokens.bodyStrong,
              ),
              Text(
                order.id.length > 8 ? order.id.substring(0, 8) : order.id,
                style: PosTokens.meta,
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            MaterialLocalizations.of(
              context,
            ).formatMediumDate(order.targetDate.toLocal()),
          ),
        ),
        DataCell(Text(order.plannedQuantity.toStringAsFixed(0))),
        DataCell(
          Text(
            order.actualQuantity.toStringAsFixed(0),
            style: TextStyle(
              color: order.actualQuantity > 0 ? varianceColor : PosTokens.ink3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                variance >= 0
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 14,
                color: varianceColor,
              ),
              Text(
                variance.abs().toStringAsFixed(0),
                style: TextStyle(
                  color: varianceColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        DataCell(WorkOrderStatusBadge(status: status)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (status == WorkOrderStatus.planned && widget.onStart != null)
                _RowAction(
                  icon: Icons.play_arrow_rounded,
                  tooltip: l10n.productionOutputStart,
                  color: PosTokens.ink2,
                  onPressed: () => widget.onStart!(order),
                ),
              if (!order.isCompleted && widget.onRecordOutput != null)
                _RowAction(
                  icon: Icons.add_circle_outline,
                  tooltip: l10n.productionOutputRecordOutput,
                  color: PosTokens.blue,
                  onPressed: () => widget.onRecordOutput!(order),
                ),
              if (status == WorkOrderStatus.inProgress &&
                  widget.onComplete != null)
                _RowAction(
                  icon: Icons.check_circle_outline,
                  tooltip: l10n.productionOutputComplete,
                  color: PosTokens.gainInk,
                  onPressed: () => widget.onComplete!(order),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.flipperL10n;
    final filtered = _statusFilter != null && widget.workOrders.isNotEmpty;
    return ProductionEmptyState(
      framed: false,
      icon: Icons.inventory_2_outlined,
      title: l10n.productionOutputNoWorkOrdersFound,
      message: l10n.productionOutputTableEmptyHint,
      // A filter that hides everything is not a reason to plan more.
      actionLabel: filtered ? null : l10n.productionOutputNewWorkOrder,
      onAction: filtered ? null : widget.onCreate,
    );
  }

  List<WorkOrder> _getFilteredOrders() {
    if (_statusFilter == null) return widget.workOrders;
    return widget.workOrders
        .where((wo) => wo.status.toLowerCase() == _statusFilter)
        .toList();
  }

  List<WorkOrder> _getSortedOrders(List<WorkOrder> orders) {
    final sorted = List<WorkOrder>.from(orders);
    sorted.sort((a, b) {
      int comparison;
      switch (_sortColumn) {
        case 'variantName':
          comparison = (a.variantName ?? '').compareTo(b.variantName ?? '');
          break;
        case 'targetDate':
          comparison = a.targetDate.compareTo(b.targetDate);
          break;
        case 'plannedQuantity':
          comparison = a.plannedQuantity.compareTo(b.plannedQuantity);
          break;
        case 'actualQuantity':
          comparison = a.actualQuantity.compareTo(b.actualQuantity);
          break;
        default:
          comparison = 0;
      }
      return _sortAscending ? comparison : -comparison;
    });
    return sorted;
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  int _getSortColumnIndex() {
    switch (_sortColumn) {
      case 'variantName':
        return 0;
      case 'targetDate':
        return 1;
      case 'plannedQuantity':
        return 2;
      case 'actualQuantity':
        return 3;
      default:
        return 1;
    }
  }
}

/// All / Planned / In progress / Completed as one segmented control.
class _FilterSegments extends StatelessWidget {
  const _FilterSegments({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<(String, String?)> filters;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        border: Border.all(color: PosTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (label, value) in filters)
            _Segment(
              label: label,
              selected: selected == value,
              onTap: () => onSelected(value),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(PosTokens.radiusSm);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? PosTokens.surface : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: selected
              ? const BorderSide(color: PosTokens.line)
              : BorderSide.none,
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: selected ? PosTokens.ink1 : PosTokens.ink3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: PosTokens.iconMd),
      tooltip: tooltip,
      color: color,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        ),
      ),
    );
  }
}
