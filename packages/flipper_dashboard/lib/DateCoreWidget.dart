// ignore_for_file: unused_result

import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
      splashColor: Colors.blue.withOpacity(0.3),
      highlightColor: Colors.blue.withOpacity(0.1),
      splashRadius: 24,
      padding: const EdgeInsets.all(8),
    );
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      PickerDateRange date = args.value as PickerDateRange;
      if (date.startDate != null) {
        showSnackBar(context, "Date selected",
            textColor: Colors.white, backgroundColor: Colors.black);
        ref.read(dateRangeProvider.notifier).setStartDate(date.startDate!);
        if (date.endDate != null) {
          ref.read(dateRangeProvider.notifier).setEndDate(date.endDate!);
        } else {
          // If no end date is selected, set it to the same as the start date
          ref.read(dateRangeProvider.notifier).setEndDate(date.startDate!);
        }
        ref.refresh(transactionListProvider);
      }
    }
  }

  void _handleDateTimePicker() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => OptionModal(
        child: SfDateRangePicker(
          onSubmit: (v) {
            Navigator.maybePop(context);
          },
          onCancel: () {
            Navigator.maybePop(context);
          },
          onSelectionChanged: _onSelectionChanged,
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          navigationMode: DateRangePickerNavigationMode.scroll,
          showNavigationArrow: true,
          initialSelectedRange: PickerDateRange(
            DateTime.now().subtract(const Duration(days: 4)),
            DateTime.now().add(
              const Duration(days: 3),
            ),
          ),
        ),
      ),
    );
  }
}
