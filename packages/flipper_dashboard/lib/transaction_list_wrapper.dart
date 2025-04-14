import 'package:flipper_dashboard/transactionList.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// A wrapper for TransactionList that handles date selection without creating nested dialogs
/// This is used when TransactionList is displayed inside another dialog
class TransactionListWrapper extends ConsumerStatefulWidget {
  const TransactionListWrapper({
    Key? key,
    this.showDetailedReport = true,
  }) : super(key: key);

  final bool showDetailedReport;

  @override
  TransactionListWrapperState createState() => TransactionListWrapperState();
}

class TransactionListWrapperState
    extends ConsumerState<TransactionListWrapper> {
  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(startDate, endDate),
          const SizedBox(height: 16),
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

  Widget _buildHeader(DateTime? startDate, DateTime? endDate) {
    final formattedStartDate = startDate != null
        ? '${startDate.day}/${startDate.month}/${startDate.year}'
        : 'Select date';
    final formattedEndDate = endDate != null
        ? '${endDate.day}/${endDate.month}/${endDate.year}'
        : '';
    final dateRangeText = startDate != null && endDate != null
        ? '$formattedStartDate - $formattedEndDate'
        : formattedStartDate;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Reports',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    dateRangeText,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _showDatePicker,
          icon: const Icon(
            Icons.calendar_today_rounded,
            color: Colors.blue,
            size: 28,
          ),
          tooltip: 'Select Date',
          splashColor: Colors.blue.withOpacity(0.3),
          highlightColor: Colors.blue.withOpacity(0.1),
          splashRadius: 24,
          padding: const EdgeInsets.all(8),
        ),
      ],
    );
  }

  void _showDatePicker() {
    // Use a dialog with custom styling instead of a bottom sheet
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
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
              Row(
                children: [
                  Text(
                    'Select Date Range',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 24,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black87,
                    ),
                  ),
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    confirmText: "APPLY",
                    cancelText: "CANCEL",
                    headerStyle: const DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    monthCellStyle: DateRangePickerMonthCellStyle(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      todayTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      leadingDatesTextStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.3),
                      ),
                      trailingDatesTextStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    navigationDirection:
                        DateRangePickerNavigationDirection.horizontal,
                    navigationMode: DateRangePickerNavigationMode.snap,
                    showNavigationArrow: true,
                    initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 7)),
                      DateTime.now(),
                    ),
                    onSubmit: (_) => Navigator.pop(context),
                    onCancel: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
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
        // Refresh both providers to ensure data is updated
        // ignore: unused_result
        ref.refresh(transactionsProvider);
        // ignore: unused_result
        ref.refresh(transactionItemListProvider);
      }
    }
  }
}
