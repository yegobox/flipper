// ignore_for_file: unused_result
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';

mixin DateCoreWidget<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  IconButton datePicker() {
    return IconButton(
      onPressed: _handleDateTimePicker,
      icon: const Icon(
        Icons.calendar_today_rounded,
        color: Colors.blue,
        size: 28,
      ),
      tooltip: 'Select Date',
      splashColor: Colors.blue.withValues(alpha: .3),
      highlightColor: Colors.blue.withValues(alpha: 0.1),
      splashRadius: 24,
      padding: const EdgeInsets.all(8),
    );
  }

  void _onDateRangeSelected(DateTimeRange? dateRange) {
    if (dateRange != null) {
      ref.read(dateRangeProvider.notifier).setStartDate(dateRange.start);
      ref.read(dateRangeProvider.notifier).setEndDate(dateRange.end);
      ref.refresh(transactionListProvider(forceRealData: true));
      toast('Date selected');
    }
  }

  void _handleDateTimePicker() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Date Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  // This will handle single date selection
                  // For range selection, we'll use the action buttons below
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final dateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: DateTimeRange(
                          start:
                              DateTime.now().subtract(const Duration(days: 4)),
                          end: DateTime.now().add(const Duration(days: 3)),
                        ),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme:
                                  Theme.of(context).colorScheme.copyWith(
                                        primary: Colors.blue,
                                      ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (dateRange != null) {
                        _onDateRangeSelected(dateRange);
                        Navigator.maybePop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Select Range'),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.maybePop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
