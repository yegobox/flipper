// ignore_for_file: unused_result

import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final date = args.value as PickerDateRange;
      if (date.startDate != null) {
        ref.read(dateRangeProvider.notifier).setStartDate(date.startDate!);
        ref.read(dateRangeProvider.notifier).setEndDate(
              date.endDate ?? date.startDate!,
            );
        ref.refresh(transactionListProvider);
        toast(
          'Date selected',
        );
      }
    }
  }

  void _handleDateTimePicker() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: SfDateRangePicker(
          onSubmit: (_) => Navigator.maybePop(context),
          onCancel: () => Navigator.maybePop(context),
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          navigationMode: DateRangePickerNavigationMode.scroll,
          showNavigationArrow: true,
          initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(const Duration(days: 3)),
          ),
        ),
      ),
    );
  }
}
