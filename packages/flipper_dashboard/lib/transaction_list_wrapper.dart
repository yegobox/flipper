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
        color: colorScheme.primaryContainer.withValues(alpha: .2),
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

  void _showDatePicker() async {
    final dateRange = ref.read(dateRangeProvider);
    final initialStartDate =
        dateRange.startDate ?? DateTime.now().subtract(const Duration(days: 7));
    final initialEndDate = dateRange.endDate ?? DateTime.now();

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: initialStartDate,
        end: initialEndDate,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(dateRangeProvider.notifier).setStartDate(picked.start);
      ref.read(dateRangeProvider.notifier).setEndDate(picked.end);

      // Refresh transaction data
      ref.invalidate(transactionsProvider);
      ref.invalidate(transactionItemListProvider);
    }
  }
}
