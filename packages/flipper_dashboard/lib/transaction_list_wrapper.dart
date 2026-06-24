import 'package:flipper_dashboard/transactionList.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Hosts [TransactionList] inside dialogs or constrained shells.
///
/// Previously this widget duplicated a minimal header and passed
/// [TransactionList.hideHeader] `true`, which hid KPI cards, filters, cashier
/// chips, export/print, and view toggles. Reports now use the full
/// transaction report layout from [TransactionList] (`hideHeader: false`).
class TransactionListWrapper extends ConsumerWidget {
  const TransactionListWrapper({
    super.key,
    this.showDetailedReport = true,
    this.padding = EdgeInsets.zero,
  });

  final bool showDetailedReport;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: padding,
      child: TransactionList(
        showDetailedReport: showDetailedReport,
        hideHeader: false,
        showSearch: true,
      ),
    );
  }
}
