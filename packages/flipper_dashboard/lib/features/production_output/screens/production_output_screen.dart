import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/production_output_provider.dart';
import '../models/production_output_models.dart';
import '../services/production_output_service.dart';
import '../widgets/object_page_header.dart';
import '../widgets/analytical_cards.dart';
import '../widgets/variance_chart.dart';
import '../widgets/work_order_table.dart';
import '../widgets/work_order_form.dart';
import '../widgets/variance_reason_dialog.dart';

/// Main screen for Production Output feature
///
/// SAP Fiori Object Page layout with:
/// - Header KPIs
/// - Analytical cards
/// - Variance chart
/// - Work orders table
class ProductionOutputScreen extends ConsumerStatefulWidget {
  const ProductionOutputScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductionOutputScreen> createState() =>
      _ProductionOutputScreenState();
}

class _ProductionOutputScreenState
    extends ConsumerState<ProductionOutputScreen> {
  final ProductionOutputService _service = ProductionOutputService();

  ProductionSummary _summary = ProductionSummary.empty;
  List<VarianceDataPoint> _chartData = [];
  bool _isLoading = true;
  bool _showCreateForm = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final summary = await _service.getProductionSummary();
      final chartData = await _service.getVarianceChartData(days: 7);

      setState(() {
        _summary = summary;
        _chartData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workOrdersAsync = ref.watch(todayWorkOrdersProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              elevation: 1,
              title: Row(
                children: [
                  Icon(Icons.factory, color: Color(VarianceColors.neutral)),
                  const SizedBox(width: 8),
                  Text(
                    isMobile ? 'Production' : 'Production Output',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black54),
                  onPressed: _loadData,
                  tooltip: 'Refresh',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _showCreateForm = !_showCreateForm;
                    });
                  },
                  tooltip: 'Create Work Order',
                ),
              ],
            ),
            // Content
            SliverPadding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Create form (collapsible)
                  if (_showCreateForm) ...[
                    WorkOrderForm(
                      onSubmit: (data) async {
                        await _service.createWorkOrder(
                          variantId: data['variantId'] as String,
                          plannedQuantity: data['plannedQuantity'] as double,
                          targetDate: data['targetDate'] as DateTime,
                          shiftId: data['shiftId'] as String?,
                          notes: data['notes'] as String?,
                        );
                        setState(() {
                          _showCreateForm = false;
                        });
                        _loadData();
                        ref.invalidate(todayWorkOrdersProvider);
                      },
                      onCancel: () {
                        setState(() {
                          _showCreateForm = false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Object Page Header with KPIs
                  ObjectPageHeader(
                    summary: _summary,
                    isLoading: _isLoading,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 16),
                  // Analytical Cards
                  AnalyticalCards(
                    summary: _summary,
                    isLoading: _isLoading,
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 16),
                  // Variance Chart
                  SizedBox(
                    height: isMobile ? 220 : 280,
                    child: VarianceChart(
                      dataPoints: _chartData,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Work Orders Table - use card list on mobile
                  if (isMobile)
                    _buildMobileWorkOrdersList(workOrdersAsync)
                  else
                    SizedBox(
                      height: 400,
                      child: workOrdersAsync.when(
                        data: (workOrders) => WorkOrderTable(
                          workOrders: workOrders,
                          isLoading: false,
                          onRowTap: (wo) => _showWorkOrderDetails(wo),
                          onRecordOutput: (wo) => _showRecordOutputDialog(wo),
                          onComplete: (wo) => _completeWorkOrder(wo),
                        ),
                        loading: () => const WorkOrderTable(
                          workOrders: [],
                          isLoading: true,
                        ),
                        error: (_, __) => const WorkOrderTable(
                          workOrders: [],
                          isLoading: false,
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mobile-friendly work orders list using cards instead of table
  Widget _buildMobileWorkOrdersList(AsyncValue workOrdersAsync) {
    return workOrdersAsync.when(
      data: (workOrders) {
        if (workOrders.isEmpty) {
          return _buildEmptyWorkOrdersCard();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${workOrders.length} items',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            ...workOrders.map((wo) => _buildWorkOrderCard(wo)),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => _buildEmptyWorkOrdersCard(),
    );
  }

  Widget _buildEmptyWorkOrdersCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No work orders',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create a work order',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkOrderCard(dynamic wo) {
    final status = WorkOrderStatus.fromString(wo.status ?? 'planned');
    final variance = (wo.actualQuantity ?? 0.0) - (wo.plannedQuantity ?? 0.0);
    final varianceColor = variance >= 0
        ? Color(VarianceColors.positive)
        : Color(VarianceColors.negative);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  wo.variantName ?? 'Unknown Product',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(status.color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(status.color),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Metrics row
          Row(
            children: [
              _buildMetricChip(
                'Planned',
                wo.plannedQuantity?.toStringAsFixed(0) ?? '0',
              ),
              const SizedBox(width: 12),
              _buildMetricChip(
                'Actual',
                wo.actualQuantity?.toStringAsFixed(0) ?? '0',
                color: varianceColor,
              ),
              const SizedBox(width: 12),
              _buildMetricChip(
                'Variance',
                '${variance >= 0 ? '+' : ''}${variance.toStringAsFixed(0)}',
                color: varianceColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Actions row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (wo.status != 'completed') ...[
                TextButton.icon(
                  onPressed: () => _showRecordOutputDialog(wo),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Record'),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(VarianceColors.neutral),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _completeWorkOrder(wo),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Complete'),
                  style: TextButton.styleFrom(
                    foregroundColor: Color(VarianceColors.positive),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _showWorkOrderDetails(dynamic workOrder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Work Order: ${workOrder.variantName ?? 'Unknown'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${workOrder.id.substring(0, 8)}'),
            Text('Planned: ${workOrder.plannedQuantity.toStringAsFixed(0)}'),
            Text('Actual: ${workOrder.actualQuantity.toStringAsFixed(0)}'),
            Text('Variance: ${workOrder.variance.toStringAsFixed(0)}'),
            Text('Efficiency: ${workOrder.efficiency.toStringAsFixed(1)}%'),
            Text('Status: ${workOrder.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRecordOutputDialog(dynamic workOrder) async {
    String? varianceReason;
    String? notes;

    final result = await VarianceReasonDialog.show(context);
    if (result != null) {
      varianceReason = result['reason'];
      notes = result['notes'];
    }

    final quantity = await showDialog<double>(
      context: context,
      builder: (context) => _RecordOutputDialog(workOrder: workOrder),
    );

    if (quantity != null) {
      await _service.recordActualOutput(
        workOrderId: workOrder.id as String,
        actualQuantity: quantity,
        varianceReason: varianceReason,
        notes: notes,
      );
      _loadData();
      ref.invalidate(todayWorkOrdersProvider);
    }
  }

  Future<void> _completeWorkOrder(dynamic workOrder) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Work Order?'),
        content: Text('Mark "${workOrder.variantName}" as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(VarianceColors.positive),
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.completeWorkOrder(workOrder.id as String);
      _loadData();
      ref.invalidate(todayWorkOrdersProvider);
    }
  }
}

/// Dialog for recording output quantity
class _RecordOutputDialog extends StatefulWidget {
  final dynamic workOrder;

  const _RecordOutputDialog({Key? key, required this.workOrder})
    : super(key: key);

  @override
  State<_RecordOutputDialog> createState() => _RecordOutputDialogState();
}

class _RecordOutputDialogState extends State<_RecordOutputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Output'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product: ${widget.workOrder.variantName ?? 'Unknown'}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Target: ${widget.workOrder.plannedQuantity.toStringAsFixed(0)}',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Actual Quantity',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final quantity = double.tryParse(_controller.text);
            if (quantity != null && quantity > 0) {
              Navigator.of(context).pop(quantity);
            }
          },
          child: const Text('Record'),
        ),
      ],
    );
  }
}
