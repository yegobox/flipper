import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      DateTime? startDate, DateTime? endDate, ColorScheme colorScheme) {
    final dateRangeText = _formatDateRange(startDate, endDate);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
      ),
    );
  }

  Widget _buildDateDisplay(String dateRangeText, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: colorScheme.primary,
          ),
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
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDialogHeader(context, colorScheme),
              const SizedBox(height: 16),
              _buildDateRangePicker(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month_rounded,
          color: colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Text(
          'Select Date Range',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
          style: IconButton.styleFrom(
            backgroundColor: colorScheme.surfaceVariant.withOpacity(0.2),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangePicker(BuildContext context, ColorScheme colorScheme) {
    final dateRange = ref.read(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: colorScheme,
        ),
        child: SfDateRangePicker(
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          confirmText: "APPLY",
          cancelText: "CANCEL",
          enablePastDates: true,
          headerStyle: DateRangePickerHeaderStyle(
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            weekNumberStyle: DateRangePickerWeekNumberStyle(
              textStyle: TextStyle(color: colorScheme.primary),
              backgroundColor: colorScheme.primaryContainer.withOpacity(0.2),
            ),
          ),
          monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
            ),
            todayTextStyle: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            leadingDatesTextStyle: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            trailingDatesTextStyle: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          selectionColor: colorScheme.primary,
          startRangeSelectionColor: colorScheme.primary,
          endRangeSelectionColor: colorScheme.primary,
          rangeSelectionColor: colorScheme.primaryContainer.withOpacity(0.3),
          todayHighlightColor: colorScheme.primary,
          navigationDirection: DateRangePickerNavigationDirection.horizontal,
          navigationMode: DateRangePickerNavigationMode.snap,
          showNavigationArrow: true,
          initialSelectedRange: PickerDateRange(
            startDate ?? DateTime.now().subtract(const Duration(days: 7)),
            endDate ?? DateTime.now().toUtc(),
          ),
          onSubmit: (_) => Navigator.pop(context),
          onCancel: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final date = args.value as PickerDateRange;
      if (date.startDate != null) {
        ref.read(dateRangeProvider.notifier).setStartDate(date.startDate!);
        ref.read(dateRangeProvider.notifier).setEndDate(
              date.endDate ?? date.startDate!,
            );

        // Refresh transaction data
        ref.invalidate(transactionsProvider);
        ref.invalidate(transactionItemListProvider);
      }
    }
  }
}
