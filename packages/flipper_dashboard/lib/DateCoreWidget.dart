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
      icon: Icon(Icons.date_range, color: Colors.grey),
    );
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      PickerDateRange date = args.value as PickerDateRange;
      if (date.endDate != null) {
        showSnackBar(context, "Date range selected",
            textColor: Colors.white, backgroundColor: Colors.purple);
        ref.read(dateRangeProvider.notifier).setStartDate(date.startDate!);
        ref.read(dateRangeProvider.notifier).setEndDate(date.endDate!);
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
