import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import '../models/production_output_models.dart';

/// SAP Fiori-inspired Responsive Table widget (ALV-style)
///
/// Displays work orders in a data table with filtering, sorting,
/// and status indicators following SAP table conventions.
class WorkOrderTable extends StatefulWidget {
  final List<WorkOrder> workOrders;
  final bool isLoading;
  final Function(WorkOrder)? onRowTap;
  final Function(WorkOrder)? onRecordOutput;
  final Function(WorkOrder)? onComplete;

  const WorkOrderTable({
    Key? key,
    required this.workOrders,
    this.isLoading = false,
    this.onRowTap,
    this.onRecordOutput,
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
                ? _buildEmptyState()
                : _buildTable(sortedOrders),
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
            'Work Orders',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            '${widget.workOrders.length} items',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
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
            'Status:',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          ...['All', 'Planned', 'In Progress', 'Completed'].map((status) {
            final filterValue = status == 'All'
                ? null
                : status == 'In Progress'
                ? 'in_progress'
                : status.toLowerCase();
            final isSelected = _statusFilter == filterValue;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(status),
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

  Widget _buildTable(List<WorkOrder> orders) {
    return SingleChildScrollView(
      child: DataTable(
        sortColumnIndex: _getSortColumnIndex(),
        sortAscending: _sortAscending,
        headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
        dataRowMinHeight: 56,
        dataRowMaxHeight: 72,
        columns: [
          DataColumn(
            label: const Text('Product'),
            onSort: (_, __) => _onSort('variantName'),
          ),
          DataColumn(
            label: const Text('Target Date'),
            onSort: (_, __) => _onSort('targetDate'),
          ),
          DataColumn(
            label: const Text('Planned'),
            numeric: true,
            onSort: (_, __) => _onSort('plannedQuantity'),
          ),
          DataColumn(
            label: const Text('Actual'),
            numeric: true,
            onSort: (_, __) => _onSort('actualQuantity'),
          ),
          DataColumn(label: const Text('Variance'), numeric: true),
          const DataColumn(label: Text('Status')),
          const DataColumn(label: Text('Actions')),
        ],
        rows: orders.map((order) => _buildDataRow(order)).toList(),
      ),
    );
  }

  DataRow _buildDataRow(WorkOrder order) {
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
                order.variantName ?? 'Unknown',
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
        DataCell(_buildStatusBadge(status)),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!order.isCompleted && widget.onRecordOutput != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  tooltip: 'Record Output',
                  onPressed: () => widget.onRecordOutput!(order),
                  color: Color(VarianceColors.neutral),
                ),
              if (!order.isCompleted && widget.onComplete != null)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  tooltip: 'Complete',
                  onPressed: () => widget.onComplete!(order),
                  color: Color(VarianceColors.positive),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(WorkOrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Color(status.color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.label,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No work orders found',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a work order to start tracking production',
            style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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
