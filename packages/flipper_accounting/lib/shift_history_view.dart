import 'dart:ui' show ImageFilter;

import 'package:flipper_accounting/shift_history_viewmodel.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

const Color _kBg = Color(0xFFF9FAFB);
const Color _kBlue = Color(0xFF3B82F6);
const Color _kGreen = Color(0xFF22C55E);
const Color _kAmber = Color(0xFFF59E0B);
const Color _kTextPrimary = Color(0xFF111827);
const Color _kTextMuted = Color(0xFF6B7280);
const Color _kBorder = Color(0xFFE5E7EB);

class ShiftHistoryView extends StackedView<ShiftHistoryViewModel> {
  const ShiftHistoryView({super.key, this.onBack});

  /// When embedded in dashboard; falls back to [Navigator.maybePop] when null.
  final VoidCallback? onBack;

  static String _formatAmount(String currencyCode, num value) {
    final fmt = NumberFormat('#,##0.00', 'en_US');
    return '$currencyCode ${fmt.format(value)}';
  }

  static String _primaryUserLine(Shift shift, ShiftHistoryViewModel vm) {
    final name = vm.userDisplayName(shift.userId);
    if (name != null && name.isNotEmpty) return name;
    final id = shift.userId;
    if (id.length <= 14) return 'User: $id';
    return 'User: ${id.substring(0, 8)}…${id.substring(id.length - 6)}';
  }

  static String _initials(Shift shift, ShiftHistoryViewModel vm) {
    final name = vm.userDisplayName(shift.userId);
    if (name != null && name.trim().isNotEmpty) {
      final parts =
          name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
      if (parts.length >= 2) {
        return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
      }
      return name.trim().substring(0, name.trim().length >= 2 ? 2 : 1).toUpperCase();
    }
    final id = shift.userId;
    if (id.length >= 2) return id.substring(0, 2).toUpperCase();
    return '?';
  }

  static String _durationLabel(Shift shift) {
    final end = shift.endAt;
    if (end == null) return '';
    final d = end.difference(shift.startAt);
    final h = d.inHours;
    final m = d.inMinutes % 60;
    if (h > 0) return '~${h}h ${m}m';
    return '~${m}m';
  }

  @override
  Widget builder(
    BuildContext context,
    ShiftHistoryViewModel viewModel,
    Widget? child,
  ) {
    final currencyCode = ProxyService.box.defaultCurrency();
    final theme = Theme.of(context);
    final shifts = viewModel.filteredShifts;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: _buildAppBar(context, viewModel, theme),
      body: viewModel.isBusy
          ? _buildLoadingState()
          : shifts.isEmpty
              ? _buildEmptyState(
                  viewModel.hasActiveFilters,
                  viewModel,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _SummaryRow(
                        totalShifts: shifts.length,
                        totalCashSales: viewModel.filteredTotalCashSales,
                        openCount: viewModel.filteredOpenCount,
                        closedCount: viewModel.filteredClosedCount,
                        currencyCode: currencyCode,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _SearchBar(viewModel: viewModel),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: _ResultMetaRow(viewModel: viewModel),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        itemCount: shifts.length,
                        itemBuilder: (context, index) {
                          return _ShiftCard(
                            shift: shifts[index],
                            viewModel: viewModel,
                            currencyCode: currencyCode,
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ShiftHistoryViewModel viewModel,
    ThemeData theme,
  ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () {
            if (onBack != null) {
              onBack!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          style: IconButton.styleFrom(
            backgroundColor: _kBg,
            shape: const CircleBorder(),
            side: const BorderSide(color: _kBorder),
            padding: const EdgeInsets.all(4),
            minimumSize: const Size(40, 40),
          ),
          icon: const Icon(Icons.chevron_left, color: _kTextPrimary, size: 22),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _kBlue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kBlue.withValues(alpha: 0.25)),
            ),
            child: const Icon(Icons.schedule, color: _kBlue, size: 22),
          ),
          const SizedBox(width: 12),
          Text(
            'Shift History',
            style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _kTextPrimary,
                  fontSize: 20,
                ) ??
                const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _kTextPrimary,
                ),
          ),
        ],
      ),
      actions: [
        _AppBarIconBox(
          icon: Icons.tune,
          onPressed: () => _showFilterOptions(context, viewModel),
        ),
        _AppBarIconBox(
          icon: Icons.search,
          onPressed: () => viewModel.searchFocusNode.requestFocus(),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_kBlue),
          ),
          SizedBox(height: 16),
          Text(
            'Loading shift history...',
            style: TextStyle(
              color: _kTextMuted,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    bool isFiltered,
    ShiftHistoryViewModel viewModel,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _kBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered ? Icons.filter_alt_off : Icons.history_outlined,
              size: 48,
              color: _kBlue,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isFiltered ? 'No matching shifts' : 'No shifts found',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _kTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Try adjusting your filters or search query.'
                : 'Shift records will appear here once you\nstart managing your shifts.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _kTextMuted,
              fontSize: 14,
            ),
          ),
          if (isFiltered)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextButton(
                onPressed: viewModel.clearFilters,
                child: const Text('Clear Filters'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showFilterOptions(
    BuildContext context,
    ShiftHistoryViewModel viewModel,
  ) async {
    final currencyCode = ProxyService.box.defaultCurrency();
    final barrierLabel =
        MaterialLocalizations.of(context).modalBarrierDismissLabel;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: barrierLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(dialogContext).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.32),
                ),
              ),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: _FilterShiftsDialog(
                  viewModel: viewModel,
                  currencyCode: currencyCode,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  ShiftHistoryViewModel viewModelBuilder(BuildContext context) =>
      ShiftHistoryViewModel(businessId: ProxyService.box.getBusinessId()!);
}

class _AppBarIconBox extends StatelessWidget {
  const _AppBarIconBox({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _kBorder),
            ),
            child: Icon(icon, size: 20, color: _kTextPrimary),
          ),
        ),
      ),
    );
  }
}

class _FilterShiftsDialog extends StatefulWidget {
  const _FilterShiftsDialog({
    required this.viewModel,
    required this.currencyCode,
  });

  final ShiftHistoryViewModel viewModel;
  final String currencyCode;

  @override
  State<_FilterShiftsDialog> createState() => _FilterShiftsDialogState();
}

class _FilterShiftsDialogState extends State<_FilterShiftsDialog> {
  late DateTime? _from;
  late DateTime? _to;
  late ShiftHistoryStatusSegment _status;
  late ShiftHistorySortOrder _sort;
  late final TextEditingController _minCash;
  late final TextEditingController _maxCash;

  static const Color _fieldFill = Color(0xFFF3F4F6);

  @override
  void initState() {
    super.initState();
    final vm = widget.viewModel;
    _from = vm.startDate;
    _to = vm.endDate;
    _status = vm.statusSegment;
    _sort = vm.sortOrder;
    _minCash = TextEditingController(
      text: vm.minCashSales != null ? '${vm.minCashSales}' : '',
    );
    _maxCash = TextEditingController(
      text: vm.maxCashSales != null ? '${vm.maxCashSales}' : '',
    );
  }

  @override
  void dispose() {
    _minCash.dispose();
    _maxCash.dispose();
    super.dispose();
  }

  void _resetForm() {
    setState(() {
      _from = null;
      _to = null;
      _status = ShiftHistoryStatusSegment.all;
      _sort = ShiftHistorySortOrder.newestFirst;
      _minCash.clear();
      _maxCash.clear();
    });
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom ? _from : _to;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  num? _parseCash(TextEditingController c) {
    final t = c.text.trim();
    if (t.isEmpty) return null;
    return num.tryParse(t);
  }

  void _apply() {
    widget.viewModel.applySheetFilters(
      startDate: _from,
      endDate: _to,
      status: _status,
      minCash: _parseCash(_minCash),
      maxCash: _parseCash(_maxCash),
      sort: _sort,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cashLabel =
        'CASH SALES RANGE (${widget.currencyCode.toUpperCase()})';

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 440,
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            elevation: 12,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Filter shifts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _kTextPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: _fieldFill,
                          shape: const CircleBorder(),
                          side: const BorderSide(color: _kBorder),
                          padding: const EdgeInsets.all(8),
                          minimumSize: const Size(36, 36),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _sectionLabel('DATE RANGE'),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _dateField(
                                  label: 'From',
                                  date: _from,
                                  onTap: () => _pickDate(isFrom: true),
                                  onClear: () => setState(() => _from = null),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _dateField(
                                  label: 'To',
                                  date: _to,
                                  onTap: () => _pickDate(isFrom: false),
                                  onClear: () => setState(() => _to = null),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          _sectionLabel('STATUS'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _statusPill(
                                  label: 'All shifts',
                                  selected: _status ==
                                      ShiftHistoryStatusSegment.all,
                                  onTap: () => setState(() =>
                                      _status = ShiftHistoryStatusSegment.all),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _statusPill(
                                  label: 'Open',
                                  selected: _status ==
                                      ShiftHistoryStatusSegment.open,
                                  dotColor: _kBlue,
                                  onTap: () => setState(() =>
                                      _status = ShiftHistoryStatusSegment.open),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _statusPill(
                                  label: 'Closed',
                                  selected: _status ==
                                      ShiftHistoryStatusSegment.closed,
                                  dotColor: _kGreen,
                                  onTap: () => setState(() => _status =
                                      ShiftHistoryStatusSegment.closed),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          _sectionLabel(cashLabel),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _cashField(
                                  label: 'Minimum',
                                  controller: _minCash,
                                  hintText: '0',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _cashField(
                                  label: 'Maximum',
                                  controller: _maxCash,
                                  hintText: 'No limit',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          _sectionLabel('SORT BY'),
                          const SizedBox(height: 10),
                          _sortRow(
                            title: 'Newest first',
                            selected:
                                _sort == ShiftHistorySortOrder.newestFirst,
                            onTap: () => setState(
                                () => _sort = ShiftHistorySortOrder.newestFirst),
                          ),
                          const SizedBox(height: 8),
                          _sortRow(
                            title: 'Oldest first',
                            selected:
                                _sort == ShiftHistorySortOrder.oldestFirst,
                            onTap: () => setState(
                                () => _sort = ShiftHistorySortOrder.oldestFirst),
                          ),
                          const SizedBox(height: 8),
                          _sortRow(
                            title: 'Cash sales — high to low',
                            selected: _sort ==
                                ShiftHistorySortOrder.cashSalesHighToLow,
                            onTap: () => setState(() => _sort =
                                ShiftHistorySortOrder.cashSalesHighToLow),
                          ),
                          const SizedBox(height: 8),
                          _sortRow(
                            title: 'Cash sales — low to high',
                            selected: _sort ==
                                ShiftHistorySortOrder.cashSalesLowToHigh,
                            onTap: () => setState(() => _sort =
                                ShiftHistorySortOrder.cashSalesLowToHigh),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: _kBorder),
                            foregroundColor: _kTextPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Clear all',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: FilledButton.icon(
                          onPressed: _apply,
                          icon: const Icon(Icons.check, size: 20, color: Colors.white),
                          label: const Text(
                            'Apply filters',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: _kBlue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.9,
        color: _kTextMuted,
      ),
    );
  }

  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _kTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: _fieldFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      date != null
                          ? DateFormat('MM/dd/yyyy').format(date.toLocal())
                          : 'mm/dd/yyyy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: date != null ? _kTextPrimary : _kTextMuted,
                      ),
                    ),
                  ),
                  if (date != null)
                    InkWell(
                      onTap: onClear,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.close, size: 18, color: _kTextMuted),
                      ),
                    )
                  else
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: _kTextMuted,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusPill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? dotColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _kTextPrimary : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? _kTextPrimary : _kBorder,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!selected && dotColor != null) ...[
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : _kTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cashField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _kTextPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _kTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: _kTextMuted,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: _fieldFill,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _kBlue, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sortRow({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? _kBlue : _kBorder,
              width: selected ? 1.5 : 1,
            ),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _kTextPrimary,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected ? _kBlue : _kTextMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.totalShifts,
    required this.totalCashSales,
    required this.openCount,
    required this.closedCount,
    required this.currencyCode,
  });

  final int totalShifts;
  final num totalCashSales;
  final int openCount;
  final int closedCount;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'TOTAL SHIFTS',
            child: Text(
              '$totalShifts',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _kTextPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'TOTAL CASH SALES',
            child: Text(
              ShiftHistoryView._formatAmount(currencyCode, totalCashSales),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _kGreen,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'OPEN / CLOSED',
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(text: '$openCount', style: const TextStyle(color: _kBlue)),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: _kTextMuted, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: '$closedCount', style: const TextStyle(color: _kGreen)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: _kBorder.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: _kTextMuted,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.viewModel});

  final ShiftHistoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: viewModel.searchController,
      focusNode: viewModel.searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search by user ID or date...',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon:
            Icon(Icons.search, color: Colors.grey.shade500, size: 22),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _kBlue, width: 1.2),
        ),
      ),
    );
  }
}

class _ResultMetaRow extends StatelessWidget {
  const _ResultMetaRow({required this.viewModel});

  final ShiftHistoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final n = viewModel.filteredShifts.length;
    return Text(
      'Showing $n shift${n == 1 ? '' : 's'}',
      style: const TextStyle(
        fontSize: 13,
        color: _kTextMuted,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _ShiftCard extends StatelessWidget {
  const _ShiftCard({
    required this.shift,
    required this.viewModel,
    required this.currencyCode,
  });

  final Shift shift;
  final ShiftHistoryViewModel viewModel;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final isOpen = shift.status == ShiftStatus.Open;
    final cashSales = shift.cashSales ?? 0;
    final cashDifference = shift.cashDifference ?? 0.0;
    final hasCashDifference = cashDifference != 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: _kBorder.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _kBlue,
                  child: Text(
                    ShiftHistoryView._initials(shift, viewModel),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ShiftHistoryView._primaryUserLine(shift, viewModel),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: _kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Started ${DateFormat('MMM dd, yyyy • HH:mm').format(shift.startAt.toLocal())}',
                        style: const TextStyle(
                          color: _kTextMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(isOpen: isOpen),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _TimeColumn(shift: shift),
                  ),
                  const VerticalDivider(width: 24, thickness: 1, color: _kBorder),
                  Expanded(
                    child: _FinancialColumn(
                      shift: shift,
                      currencyCode: currencyCode,
                      cashSales: cashSales,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (hasCashDifference)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cashDifference > 0
                      ? _kGreen.withValues(alpha: 0.08)
                      : const Color(0xFFEF4444).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: cashDifference > 0
                        ? _kGreen.withValues(alpha: 0.35)
                        : const Color(0xFFEF4444).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      cashDifference > 0 ? Icons.trending_up : Icons.trending_down,
                      color: cashDifference > 0 ? _kGreen : const Color(0xFFEF4444),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Cash difference: ${ShiftHistoryView._formatAmount(currencyCode, cashDifference)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: cashDifference > 0 ? _kGreen : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _BottomAccentBar(isOpen: isOpen),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final text = isOpen ? 'Open' : 'Closed';
    final color = isOpen ? _kBlue : _kGreen;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({required this.shift});

  final Shift shift;

  @override
  Widget build(BuildContext context) {
    final isOpen = shift.status == ShiftStatus.Open;
    final dur = ShiftHistoryView._durationLabel(shift);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TIME PERIOD',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: _kTextMuted,
          ),
        ),
        const SizedBox(height: 10),
        _kvRow(
          'Start Time',
          DateFormat('MMM dd, yyyy • HH:mm').format(shift.startAt.toLocal()),
        ),
        const SizedBox(height: 8),
        _kvRowEnd(
          'End Time',
          isOpen
              ? null
              : DateFormat('MMM dd, yyyy • HH:mm')
                  .format(shift.endAt!.toLocal()),
          isOpen: isOpen,
        ),
        if (!isOpen && dur.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Duration: $dur',
            style: const TextStyle(
              fontSize: 12,
              color: _kTextMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _kvRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: _kTextMuted),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _kTextPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _kvRowEnd(String label, String? value, {required bool isOpen}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: _kTextMuted),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: isOpen
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'In Progress',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _kAmber,
                      ),
                    ),
                  )
                : Text(
                    value!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _kTextPrimary,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _FinancialColumn extends StatelessWidget {
  const _FinancialColumn({
    required this.shift,
    required this.currencyCode,
    required this.cashSales,
  });

  final Shift shift;
  final String currencyCode;
  final num cashSales;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'FINANCIAL SUMMARY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: _kTextMuted,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.calculate_outlined, size: 14, color: Colors.grey.shade500),
          ],
        ),
        const SizedBox(height: 10),
        _moneyRow(
          'Opening Balance',
          ShiftHistoryView._formatAmount(currencyCode, shift.openingBalance),
          valueStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _kTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        _moneyRow(
          'Cash Sales',
          ShiftHistoryView._formatAmount(currencyCode, cashSales),
          valueStyle: TextStyle(
            fontSize: 12,
            fontWeight: cashSales > 0 ? FontWeight.w800 : FontWeight.w500,
            color: cashSales > 0 ? _kGreen : _kTextMuted,
          ),
        ),
        const SizedBox(height: 8),
        _moneyRow(
          'Expected Cash',
          ShiftHistoryView._formatAmount(
            currencyCode,
            shift.expectedCash ?? 0,
          ),
          valueStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _kBlue,
          ),
        ),
        const SizedBox(height: 8),
        _moneyRow(
          'Closing Balance',
          ShiftHistoryView._formatAmount(
            currencyCode,
            shift.closingBalance ?? 0,
          ),
          valueStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: _kTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _moneyRow(
    String label,
    String formatted, {
    required TextStyle valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: _kTextMuted),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            formatted,
            textAlign: TextAlign.right,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}

class _BottomAccentBar extends StatelessWidget {
  const _BottomAccentBar({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    if (isOpen) {
      return SizedBox(
        height: 4,
        child: Row(
          children: [
            Expanded(child: Container(color: _kBlue)),
            Expanded(child: Container(color: _kGreen)),
          ],
        ),
      );
    }
    return Container(height: 4, color: _kGreen);
  }
}
