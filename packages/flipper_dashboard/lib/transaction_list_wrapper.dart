import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// A wrapper for TransactionList that handles date selection without creating nested dialogs
/// This is used when TransactionList is displayed inside another dialog
class TransactionListWrapper extends ConsumerStatefulWidget {
  const TransactionListWrapper({
    Key? key,
    this.showDetailedReport = true,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  final bool showDetailedReport;
  final EdgeInsetsGeometry padding;

  @override
  TransactionListWrapperState createState() => TransactionListWrapperState();
}

class TransactionListWrapperState
    extends ConsumerState<TransactionListWrapper> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(startDate, endDate, colorScheme),
          const SizedBox(height: 2),
          Expanded(
            child: TransactionList(
              showDetailedReport: widget.showDetailedReport,
              hideHeader: true,
              showSearch: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    DateTime? startDate,
    DateTime? endDate,
    ColorScheme colorScheme,
  ) {
    final dateRangeText = _formatDateRange(startDate, endDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction Reports',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDateDisplay(dateRangeText, colorScheme),
              ],
            ),
          ),
          _buildDatePickerButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildDateDisplay(String dateRangeText, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 16, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            dateRangeText,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerButton(ColorScheme colorScheme) {
    return ElevatedButton.icon(
      onPressed: _showDatePicker,
      icon: const Icon(Icons.date_range_rounded),
      label: const Text('Change Date'),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return 'Select date';
    }

    final formattedStartDate = _dateFormat.format(startDate);

    if (endDate == null || startDate.isAtSameMomentAs(endDate)) {
      return formattedStartDate;
    }

    return '$formattedStartDate - ${_dateFormat.format(endDate)}';
  }

  void _showDatePicker() {
    final dateRange = ref.read(dateRangeProvider);
    final now = DateTime.now();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: _DatePickerDialog(
              initialStartDate:
                  dateRange.startDate ?? now.subtract(const Duration(days: 7)),
              initialEndDate: dateRange.endDate ?? now,
              onDateRangeSelected: (start, end) {
                ref.read(dateRangeProvider.notifier).setStartDate(start);
                ref.read(dateRangeProvider.notifier).setEndDate(end);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.invalidate(transactionsProvider);
                  ref.invalidate(transactionItemListProvider);
                });
              },
            ),
          ),
        );
      },
    );
  }
}

class _DatePreset {
  final String label;
  final IconData icon;
  final DateTimeRange Function() range;

  const _DatePreset({
    required this.label,
    required this.icon,
    required this.range,
  });
}

class _DatePickerDialog extends StatefulWidget {
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final void Function(DateTime start, DateTime end) onDateRangeSelected;

  const _DatePickerDialog({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onDateRangeSelected,
  });

  @override
  State<_DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<_DatePickerDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  int? _selectedPresetIndex;
  bool _showCalendar = false;
  bool _pickingEndDate = false;
  final DateFormat _fmt = DateFormat('MMM dd, yyyy');

  static DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  static DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59);

  late final List<_DatePreset> _presets = [
    _DatePreset(
      label: 'Today',
      icon: Icons.today_rounded,
      range: () {
        final now = DateTime.now();
        return DateTimeRange(start: _startOfDay(now), end: _endOfDay(now));
      },
    ),
    _DatePreset(
      label: 'Yesterday',
      icon: Icons.history_rounded,
      range: () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        return DateTimeRange(
          start: _startOfDay(yesterday),
          end: _endOfDay(yesterday),
        );
      },
    ),
    _DatePreset(
      label: 'Last 7 Days',
      icon: Icons.date_range_rounded,
      range: () {
        final now = DateTime.now();
        return DateTimeRange(
          start: _startOfDay(now.subtract(const Duration(days: 6))),
          end: _endOfDay(now),
        );
      },
    ),
    _DatePreset(
      label: 'Last 30 Days',
      icon: Icons.calendar_month_rounded,
      range: () {
        final now = DateTime.now();
        return DateTimeRange(
          start: _startOfDay(now.subtract(const Duration(days: 29))),
          end: _endOfDay(now),
        );
      },
    ),
    _DatePreset(
      label: 'This Month',
      icon: Icons.calendar_view_month_rounded,
      range: () {
        final now = DateTime.now();
        return DateTimeRange(
          start: _startOfDay(DateTime(now.year, now.month, 1)),
          end: _endOfDay(now),
        );
      },
    ),
    _DatePreset(
      label: 'This Year',
      icon: Icons.calendar_today_outlined,
      range: () {
        final now = DateTime.now();
        return DateTimeRange(
          start: _startOfDay(DateTime(now.year, 1, 1)),
          end: _endOfDay(now),
        );
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _detectPreset();
  }

  void _detectPreset() {
    for (int i = 0; i < _presets.length; i++) {
      final range = _presets[i].range();
      if (_startOfDay(_startDate) == _startOfDay(range.start) &&
          _startOfDay(_endDate) == _startOfDay(range.end)) {
        _selectedPresetIndex = i;
        return;
      }
    }
    _selectedPresetIndex = null;
  }

  void _selectPreset(int index) {
    final range = _presets[index].range();
    setState(() {
      _startDate = range.start;
      _endDate = range.end;
      _selectedPresetIndex = index;
    });
  }

  void _toggleCustomCalendar() {
    setState(() {
      _showCalendar = !_showCalendar;
      _pickingEndDate = false;
      _selectedPresetIndex = null;
    });
  }

  void _onCalendarDateSelected(DateTime date) {
    setState(() {
      if (!_pickingEndDate) {
        _startDate = _startOfDay(date);
        if (_startOfDay(date).isAfter(_startOfDay(_endDate))) {
          _endDate = _endOfDay(date);
        }
        _pickingEndDate = true;
      } else {
        if (_startOfDay(date).isBefore(_startOfDay(_startDate))) {
          _startDate = _startOfDay(date);
        } else {
          _endDate = _endOfDay(date);
        }
        _pickingEndDate = false;
        _showCalendar = false;
        _detectPreset();
      }
    });
  }

  void _apply() {
    widget.onDateRangeSelected(_startDate, _endDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSameDay = _startOfDay(_startDate) == _startOfDay(_endDate);

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: colorScheme.onPrimary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Select Date Range',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: colorScheme.onPrimary.withValues(alpha: .8),
                          size: 20,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.onPrimary.withValues(
                            alpha: .12,
                          ),
                          minimumSize: const Size(36, 36),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Selected range summary
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _dateChip(
                          colorScheme,
                          isSameDay ? 'Date' : 'From',
                          _fmt.format(_startDate),
                        ),
                        if (!isSameDay) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: colorScheme.onPrimary.withValues(
                                alpha: .7,
                              ),
                              size: 18,
                            ),
                          ),
                          _dateChip(colorScheme, 'To', _fmt.format(_endDate)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (!_showCalendar) ...[
              // Preset grid
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Select',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_presets.length, (i) {
                        final preset = _presets[i];
                        final isSelected = _selectedPresetIndex == i;
                        return _presetChip(
                          colorScheme,
                          preset,
                          isSelected,
                          () => _selectPreset(i),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 24),
              ),

              // Custom range button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: _toggleCustomCalendar,
                  icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                  label: const Text('Pick Custom Range'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 46),
                    side: BorderSide(
                      color: colorScheme.outline.withValues(alpha: .4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: colorScheme.primary,
                  ),
                ),
              ),
            ] else ...[
              // Inline calendar picker
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: _toggleCustomCalendar,
                          icon: const Icon(Icons.arrow_back_rounded, size: 20),
                          style: IconButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _pickingEndDate
                              ? 'Select End Date'
                              : 'Select Start Date',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Step indicator
                    Row(
                      children: [
                        _stepIndicator(
                          colorScheme,
                          'Start',
                          _fmt.format(_startDate),
                          isActive: !_pickingEndDate,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: .5,
                            ),
                          ),
                        ),
                        _stepIndicator(
                          colorScheme,
                          'End',
                          _fmt.format(_endDate),
                          isActive: _pickingEndDate,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CalendarDatePicker(
                      initialDate: _pickingEndDate ? _endDate : _startDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      onDateChanged: _onCalendarDateSelected,
                    ),
                  ],
                ),
              ),
            ],

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 46),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: .4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _apply,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Apply'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 46),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateChip(ColorScheme colorScheme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onPrimary.withValues(alpha: .7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _stepIndicator(
    ColorScheme colorScheme,
    String label,
    String value, {
    required bool isActive,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primaryContainer.withValues(alpha: .3)
              : colorScheme.surfaceContainerHighest.withValues(alpha: .3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? colorScheme.primary.withValues(alpha: .5)
                : colorScheme.outline.withValues(alpha: .15),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetChip(
    ColorScheme colorScheme,
    _DatePreset preset,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Material(
        color: isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: .5)
                    : colorScheme.outline.withValues(alpha: .15),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  preset.icon,
                  size: 16,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  preset.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
