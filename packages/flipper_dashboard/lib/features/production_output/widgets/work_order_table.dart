import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import '../models/production_output_models.dart';
import '../../stock_recount/stock_recount_tokens.dart';
import '../../stock_recount/stock_recount_icons.dart';
import '../../stock_recount/stock_recount_helpers.dart';

/// SAP Fiori-inspired Responsive Table widget (ALV-style)
///
/// Displays work orders in a data table with filtering, sorting,
/// and status indicators following SAP table conventions.
class WorkOrderTable extends StatefulWidget {
  final List<WorkOrder> workOrders;
  final bool isLoading;
  final Function(WorkOrder)? onRowTap;
  final Function(WorkOrder)? onRecordOutput;
  final Function(WorkOrder)? onStart;
  final Function(WorkOrder)? onComplete;

  const WorkOrderTable({
    Key? key,
    required this.workOrders,
    this.isLoading = false,
    this.onRowTap,
    this.onRecordOutput,
    this.onStart,
    this.onComplete,
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
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    final filteredOrders = _getFilteredOrders();
    final sortedOrders = _getSortedOrders(filteredOrders);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(context),
          _buildFilterBar(context),
          Expanded(
            child: sortedOrders.isEmpty
                ? _buildEmptyState(context)
                : _buildTable(context, sortedOrders),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.assignment,
            color: Color(VarianceColors.neutral),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            context.flipperL10n.productionOutputWorkOrders,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            context.flipperL10n.productionOutputItemsCount(
              widget.workOrders.length,
            ),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final l10n = context.flipperL10n;
    // (label, filter value) — the value matches the stored work-order status.
    final filters = <(String, String?)>[
      (l10n.productionOutputFilterAll, null),
      (l10n.productionOutputStatusPlanned, 'planned'),
      (l10n.productionOutputStatusInProgress, 'in_progress'),
      (l10n.productionOutputStatusCompleted, 'completed'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Text(
            l10n.productionOutputStatusFilterLabel,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          ...filters.map((filter) {
            final (label, filterValue) = filter;
            final isSelected = _statusFilter == filterValue;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _statusFilter = filterValue;
                  });
                },
                selectedColor: Color(VarianceColors.neutral).withOpacity(0.2),
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Color(VarianceColors.neutral)
                      : Colors.grey[600],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                visualDensity: VisualDensity.compact,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<WorkOrder> orders) {
    final l10n = context.flipperL10n;
    return SingleChildScrollView(
      child: DataTable(
        sortColumnIndex: _getSortColumnIndex(),
        sortAscending: _sortAscending,
        headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
        dataRowMinHeight: 56,
        dataRowMaxHeight: 72,
        columns: [
          DataColumn(
            label: Text(l10n.productionOutputProduct),
            onSort: (_, __) => _onSort('variantName'),
          ),
          DataColumn(
            label: Text(l10n.productionOutputTargetDate),
            onSort: (_, __) => _onSort('targetDate'),
          ),
          DataColumn(
            label: Text(l10n.productionOutputPlanned),
            numeric: true,
            onSort: (_, __) => _onSort('plannedQuantity'),
          ),
          DataColumn(
            label: Text(l10n.productionOutputActual),
            numeric: true,
            onSort: (_, __) => _onSort('actualQuantity'),
          ),
          DataColumn(label: Text(l10n.productionOutputVariance), numeric: true),
          DataColumn(label: Text(l10n.productionOutputStatus)),
          DataColumn(label: Text(l10n.actions)),
        ],
        rows: orders.map((order) => _buildDataRow(l10n, order)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(FlipperAppLocalizations l10n, WorkOrder order) {
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
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                order.id.substring(0, 8),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        DataCell(Text(_formatDate(order.targetDate))),
        DataCell(Text(order.plannedQuantity.toStringAsFixed(0))),
        DataCell(
          Text(
            order.actualQuantity.toStringAsFixed(0),
            style: TextStyle(
              color: order.actualQuantity > 0 ? varianceColor : Colors.grey,
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                variance >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: varianceColor,
              ),
              Text(
                '${variance.abs().toStringAsFixed(0)}',
                style: TextStyle(
                  color: varianceColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        DataCell(_buildStatusBadge(l10n, status)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Start button (only for pending orders)
              if (status == WorkOrderStatus.planned && widget.onStart != null)
                IconButton(
                  icon: const Icon(Icons.play_arrow, size: 20),
                  tooltip: l10n.productionOutputStart,
                  onPressed: () => widget.onStart!(order),
                  color: Colors.blue[700],
                ),
              // Record output button (for in-progress and pending)
              if (!order.isCompleted && widget.onRecordOutput != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  tooltip: l10n.productionOutputRecordOutput,
                  onPressed: () => widget.onRecordOutput!(order),
                  color: Color(VarianceColors.neutral),
                ),
              // Complete button (for in-progress orders)
              if (status == WorkOrderStatus.inProgress &&
                  widget.onComplete != null)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  tooltip: l10n.productionOutputComplete,
                  onPressed: () => widget.onComplete!(order),
                  color: Color(VarianceColors.positive),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(
    FlipperAppLocalizations l10n,
    WorkOrderStatus status,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(status.color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.localizedLabel(l10n),
        style: TextStyle(
          fontSize: 12,
          color: Color(status.color),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  StockRecountTokens.accentTint2,
                  StockRecountTokens.accentTint,
                ],
              ),
            ),
            child: StockRecountIcons.box(
              size: 40,
              color: StockRecountTokens.accent,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            context.flipperL10n.productionOutputNoWorkOrdersFound,
            style: StockRecountHelpers.text(size: 19, weight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            context.flipperL10n.productionOutputTableEmptyHint,
            textAlign: TextAlign.center,
            style: StockRecountHelpers.text(
              size: 14.5,
              color: StockRecountTokens.ink3,
            ),
          ),
        ],
      ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
