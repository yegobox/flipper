import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/production_output_provider.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import '../../../theme/pos_tokens.dart';
import '../models/production_output_models.dart';
import '../providers/production_output_derived_providers.dart';
import '../services/production_output_service.dart';
import '../widgets/object_page_header.dart';
import '../widgets/analytical_cards.dart';
import '../widgets/variance_chart.dart';
import '../widgets/work_order_table.dart';
import '../widgets/work_order_form.dart';
import '../widgets/work_order_bottom_sheet.dart';
import '../widgets/production_day_bar.dart';
import '../widgets/production_dialogs.dart';
import '../widgets/production_ui.dart';
import 'package:flipper_ui/dialogs/WorkOrderDetailsDialog.dart';
import 'package:flipper_ui/snack_bar_utils.dart';

/// Below this width Production is the phone layout: app bar, stacked day
/// strip, order cards and a bottom-sheet form.
const double kProductionPhoneBreakpoint = 600;

/// From this width the variance chart and the reason breakdown sit side by
/// side under the orders.
const double _kInsightsSideBySide = 1100;

/// Production Output: plan work orders per day and record what was made.
///
/// Top to bottom: the day strip with the page actions, the day's KPIs, the
/// day's orders (table on desktop, cards on phones), orders carried over from
/// earlier days, then the week's variance chart and reason breakdown.
class ProductionOutputScreen extends ConsumerStatefulWidget {
  const ProductionOutputScreen({Key? key, @visibleForTesting this.service})
    : super(key: key);

  /// Defaults to the live service; tests pass a fake.
  final ProductionOutputService? service;

  @override
  ConsumerState<ProductionOutputScreen> createState() =>
      _ProductionOutputScreenState();
}

class _ProductionOutputScreenState
    extends ConsumerState<ProductionOutputScreen> {
  late final ProductionOutputService _service =
      widget.service ?? ProductionOutputService();

  bool _showCreateForm = false;

  bool get _isPhone =>
      MediaQuery.sizeOf(context).width < kProductionPhoneBreakpoint;

  /// Re-registers the Ditto observers. Writes reach the UI on their own, so
  /// this is only for the explicit pull-to-refresh / refresh-button gesture.
  Future<void> _refresh() async {
    ref.invalidate(workOrdersStreamProvider);
    ref.invalidate(actualOutputsStreamProvider);
    await ref.read(workOrdersStreamProvider.future);
  }

  Future<void> _createWorkOrder(Map<String, dynamic> data) async {
    final targetDate = data['targetDate'] as DateTime;
    await _service.createWorkOrder(
      variantId: data['variantId'] as String,
      variantName: data['variantName'] as String?,
      plannedQuantity: data['plannedQuantity'] as double,
      targetDate: targetDate,
      shiftId: data['shiftId'] as String?,
      notes: data['notes'] as String?,
    );
    // No refetch: the Ditto observer behind workOrdersStreamProvider pushes
    // the new order as soon as its document lands. Show its day, so an order
    // planned for tomorrow is on screen instead of seeming to vanish.
    if (mounted) {
      ref.read(productionDayProvider.notifier).state = localDay(targetDate);
    }
  }

  /// One entry point for every "new work order" button: a bottom sheet on
  /// phones, the inline form on desktop.
  void _openCreateWorkOrder() {
    if (_isPhone) {
      WorkOrderBottomSheet.show(
        context: context,
        ref: ref,
        onSubmit: _createWorkOrder,
      );
    } else {
      setState(() => _showCreateForm = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayOrdersAsync = ref.watch(productionDayOrdersProvider);
    final workOrdersAsync = dayOrdersAsync.whenData((day) => day.due);
    final carriedOver =
        dayOrdersAsync.asData?.value.carriedOver ?? const <WorkOrder>[];
    final summaryAsync = ref.watch(productionSummaryProvider);
    final chartAsync = ref.watch(varianceChartDataProvider);
    final summary = summaryAsync.asData?.value ?? ProductionSummary.empty;
    final chartData = chartAsync.asData?.value ?? const <VarianceDataPoint>[];
    final isSummaryLoading = summaryAsync.isLoading;
    final isPhone = _isPhone;
    final width = MediaQuery.sizeOf(context).width;
    final l10n = context.flipperL10n;
    const gap = SizedBox(height: 16);

    final chart = SizedBox(
      height: isPhone ? 220 : 300,
      child: VarianceChart(
        dataPoints: chartData,
        isLoading: chartAsync.isLoading,
      ),
    );
    final cards = AnalyticalCards(
      summary: summary,
      isLoading: isSummaryLoading,
      isMobile: isPhone,
    );

    return Scaffold(
      backgroundColor: PosTokens.posBg,
      appBar: isPhone ? _phoneAppBar(l10n) : null,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(isPhone ? 12 : 20),
              sliver: SliverList.list(
                children: [
                  _ProductionToolbar(
                    isPhone: isPhone,
                    canPop: Navigator.of(context).canPop(),
                    onRefresh: _refresh,
                    onNew: _openCreateWorkOrder,
                  ),
                  gap,
                  if (_showCreateForm && !isPhone) ...[
                    WorkOrderForm(
                      onSubmit: (data) async {
                        await _createWorkOrder(data);
                        if (mounted) setState(() => _showCreateForm = false);
                      },
                      onCancel: () => setState(() => _showCreateForm = false),
                    ),
                    gap,
                  ],
                  ObjectPageHeader(
                    summary: summary,
                    isLoading: isSummaryLoading,
                    isMobile: isPhone,
                  ),
                  gap,
                  if (isPhone)
                    _buildMobileWorkOrdersList(workOrdersAsync)
                  else
                    workOrdersAsync.when(
                      data: (workOrders) => WorkOrderTable(
                        workOrders: workOrders,
                        isLoading: false,
                        onRowTap: _showWorkOrderDetails,
                        onRecordOutput: _showRecordOutputDialog,
                        onStart: _startWorkOrder,
                        onComplete: _completeWorkOrder,
                        onCreate: _openCreateWorkOrder,
                      ),
                      loading: () =>
                          const WorkOrderTable(workOrders: [], isLoading: true),
                      error: (error, stack) =>
                          _buildWorkOrdersErrorCard(error, stack),
                    ),
                  if (carriedOver.isNotEmpty) ...[
                    gap,
                    _buildCarriedOverList(carriedOver),
                  ],
                  gap,
                  if (width >= _kInsightsSideBySide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: chart),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: cards),
                      ],
                    )
                  else ...[
                    chart,
                    gap,
                    cards,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _phoneAppBar(FlipperAppLocalizations l10n) {
    return AppBar(
      backgroundColor: PosTokens.surface,
      surfaceTintColor: Colors.transparent,
      foregroundColor: PosTokens.ink1,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: const Border(bottom: BorderSide(color: PosTokens.line)),
      titleSpacing: 4,
      title: Text(l10n.production, style: PosTokens.sectionTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, size: PosTokens.iconMd),
          color: PosTokens.ink2,
          tooltip: l10n.refresh,
          onPressed: _refresh,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 4),
          child: ElevatedButton.icon(
            onPressed: _openCreateWorkOrder,
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.productionOutputNew),
            style: productionPrimaryButtonStyle().copyWith(
              minimumSize: const WidgetStatePropertyAll(
                Size(0, PosTokens.controlHeightSm + 4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Phone list: one card per order.
  Widget _buildMobileWorkOrdersList(AsyncValue<List<WorkOrder>> async) {
    return async.when(
      data: (workOrders) {
        if (workOrders.isEmpty) return _buildEmptyWorkOrdersCard();
        final l10n = context.flipperL10n;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionHeading(
              icon: Icons.assignment_outlined,
              title: l10n.productionOutputWorkOrders,
              trailing: l10n.productionOutputItemsCount(workOrders.length),
            ),
            ...workOrders.map(_buildWorkOrderCard),
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: PosTokens.blue,
          ),
        ),
      ),
      error: _buildWorkOrdersErrorCard,
    );
  }

  Widget _buildWorkOrdersErrorCard(Object error, StackTrace? stack) {
    talker.error('ProductionOutput: failed to load work orders', error, stack);
    final l10n = context.flipperL10n;
    return ProductionEmptyState(
      icon: Icons.error_outline,
      tone: PosTokens.loss,
      title: l10n.productionOutputLoadFailed,
      message: l10n.productionOutputCheckConnection,
      actionLabel: l10n.retry,
      actionIcon: Icons.refresh,
      onAction: _refresh,
    );
  }

  Widget _buildEmptyWorkOrdersCard() {
    final l10n = context.flipperL10n;
    return ProductionEmptyState(
      icon: Icons.inventory_2_outlined,
      title: l10n.productionOutputNoWorkOrdersYet,
      message: l10n.productionOutputNoWorkOrdersHint,
      actionLabel: l10n.productionOutputNewWorkOrder,
      actionIcon: Icons.add,
      onAction: _openCreateWorkOrder,
    );
  }

  /// Earlier days' orders still planned or in progress, shown on today so
  /// they aren't lost. They are not in today's numbers.
  Widget _buildCarriedOverList(List<WorkOrder> orders) {
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeading(
          icon: Icons.history,
          iconColor: PosTokens.warnAmber,
          title: l10n.productionOutputCarriedOver,
          trailing: l10n.productionOutputItemsCount(orders.length),
        ),
        ...orders.map((wo) => _buildWorkOrderCard(wo, showDueDate: true)),
      ],
    );
  }

  Widget _buildWorkOrderCard(WorkOrder wo, {bool showDueDate = false}) {
    final status = WorkOrderStatus.fromString(wo.status);
    final variance = wo.actualQuantity - wo.plannedQuantity;
    final varianceColor = variance >= 0
        ? Color(VarianceColors.positive)
        : Color(VarianceColors.negative);
    final l10n = context.flipperL10n;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: productionCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  wo.variantName ?? l10n.productionOutputUnknownProduct,
                  style: PosTokens.bodyStrong.copyWith(fontSize: 14),
                ),
              ),
              WorkOrderStatusBadge(status: status),
            ],
          ),
          if (showDueDate) ...[
            const SizedBox(height: 4),
            Text(
              MaterialLocalizations.of(
                context,
              ).formatMediumDate(localDay(wo.targetDate)),
              style: PosTokens.meta.copyWith(color: PosTokens.warnAmber),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: l10n.productionOutputPlanned,
                  value: wo.plannedQuantity.toStringAsFixed(0),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: l10n.productionOutputActual,
                  value: wo.actualQuantity.toStringAsFixed(0),
                  color: varianceColor,
                ),
              ),
              Expanded(
                child: _Metric(
                  label: l10n.productionOutputVariance,
                  value:
                      '${variance >= 0 ? '+' : ''}${variance.toStringAsFixed(0)}',
                  color: varianceColor,
                ),
              ),
            ],
          ),
          if (wo.status != 'completed') ...[
            const SizedBox(height: 10),
            const Divider(height: 1, color: PosTokens.line),
            const SizedBox(height: 6),
            // Wraps on narrow phones rather than overflowing.
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 2,
              children: [
                if (status == WorkOrderStatus.planned)
                  TextButton.icon(
                    onPressed: () => _startWorkOrder(wo),
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: Text(l10n.productionOutputStart),
                    style: _compactAction(PosTokens.ink2),
                  ),
                TextButton.icon(
                  onPressed: () => _showRecordOutputDialog(wo),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: Text(l10n.productionOutputRecord),
                  style: _compactAction(PosTokens.blue),
                ),
                TextButton.icon(
                  onPressed: () => _completeWorkOrder(wo),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(l10n.productionOutputComplete),
                  style: _compactAction(PosTokens.gainInk),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static ButtonStyle _compactAction(Color color) => TextButton.styleFrom(
    foregroundColor: color,
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    textStyle: PosTokens.bodyStrong,
  );

  void _showWorkOrderDetails(WorkOrder workOrder) {
    showWorkOrderDetailsDialog(
      context: context,
      workOrder: workOrder,
      onStart: () => _startWorkOrder(workOrder),
      onRecordOutput: () => _showRecordOutputDialog(workOrder),
      onComplete: () => _completeWorkOrder(workOrder),
    );
  }

  Future<void> _showRecordOutputDialog(WorkOrder workOrder) async {
    final failureMessage = context.flipperL10n.productionOutputRecordFailed;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => RecordOutputDialog(workOrder: workOrder),
    );

    if (result != null) {
      await _guard('record output', failureMessage, () async {
        final recorded = await _service.recordActualOutput(
          workOrder: workOrder,
          actualQuantity: result['quantity'] as double,
          varianceReason: result['varianceReason'] as String?,
          notes: null,
        );
        // The output is saved either way. A stock error means the stock
        // didn't move; an RRA message means only the tax report failed.
        final stockError = recorded.stockError;
        final rraMessage = recorded.rraMessage;
        if (stockError != null && mounted) {
          showCustomSnackBarUtil(
            context,
            stockError,
            type: NotificationType.error,
          );
        } else if (rraMessage != null && mounted) {
          showCustomSnackBarUtil(
            context,
            rraMessage,
            type: NotificationType.warning,
          );
        }
      });
    }
  }

  /// These handlers are invoked as fire-and-forget callbacks, so an escaping
  /// error would become an unhandled zone error instead of reaching the user.
  Future<void> _guard(
    String action,
    String failureMessage,
    Future<void> Function() run,
  ) async {
    try {
      await run();
    } catch (e, s) {
      talker.error('ProductionOutput: failed to $action', e, s);
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          failureMessage,
          type: NotificationType.error,
        );
      }
    }
  }

  Future<void> _completeWorkOrder(WorkOrder workOrder) async {
    final l10n = context.flipperL10n;
    final failureMessage = l10n.productionOutputCompleteFailed;
    final confirmed = await showProductionConfirm(
      context,
      title: l10n.productionOutputCompleteTitle,
      message: l10n.productionOutputCompleteMessage('${workOrder.variantName}'),
      confirmLabel: l10n.productionOutputComplete,
      icon: Icons.check_circle_outline,
      tone: PosTokens.gain,
    );
    if (confirmed) {
      await _guard(
        'complete this work order',
        failureMessage,
        () => _service.completeWorkOrder(workOrder.id),
      );
    }
  }

  Future<void> _startWorkOrder(WorkOrder workOrder) async {
    final l10n = context.flipperL10n;
    final failureMessage = l10n.productionOutputStartFailed;
    final confirmed = await showProductionConfirm(
      context,
      title: l10n.productionOutputStartTitle,
      message: l10n.productionOutputStartMessage('${workOrder.variantName}'),
      confirmLabel: l10n.productionOutputStart,
      icon: Icons.play_arrow_rounded,
    );
    if (confirmed) {
      await _guard(
        'start this work order',
        failureMessage,
        () => _service.startWorkOrder(workOrder),
      );
    }
  }
}

/// Day strip on the left, refresh and New on the right (desktop); just the
/// stacked strip on phones, whose actions live in the app bar.
class _ProductionToolbar extends StatelessWidget {
  const _ProductionToolbar({
    required this.isPhone,
    required this.canPop,
    required this.onRefresh,
    required this.onNew,
  });

  final bool isPhone;

  /// Opened as its own route (Quick apps): show a way back. In the rail the
  /// rail names the page, so there is no title.
  final bool canPop;
  final Future<void> Function() onRefresh;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final decoration = productionCardDecoration();
    if (isPhone) {
      return Container(
        padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
        decoration: decoration,
        child: const ProductionDayBar(),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: decoration,
      child: Row(
        children: [
          if (canPop) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back, size: PosTokens.iconMd),
              color: PosTokens.ink2,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(width: 4),
          ],
          const Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ProductionDayBar(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh, size: PosTokens.iconMd),
            color: PosTokens.ink2,
            tooltip: l10n.refresh,
            onPressed: onRefresh,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PosTokens.radiusMd),
                side: const BorderSide(color: PosTokens.line),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onNew,
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.productionOutputNewOrder),
            style: productionPrimaryButtonStyle(),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.title,
    required this.trailing,
    this.iconColor = PosTokens.ink2,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 2, right: 2),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: PosTokens.sectionTitle)),
          Text(trailing, style: PosTokens.meta),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: PosTokens.meta),
        const SizedBox(height: 2),
        Text(
          value,
          style: PosTokens.bodyStrong.copyWith(
            fontSize: 16,
            color: color ?? PosTokens.ink1,
          ),
        ),
      ],
    );
  }
}
