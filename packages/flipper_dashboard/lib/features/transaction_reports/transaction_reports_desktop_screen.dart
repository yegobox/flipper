import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/features/transaction_reports/transaction_report_density.dart';
import 'package:flipper_dashboard/transaction_list_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Full-screen transaction reports (ribbon "Transactions").
///
/// Replaces modal dialog — shell appears immediately; data loads via
/// [TransactionList] rivers.
class TransactionReportsDesktopScreen extends ConsumerWidget {
  const TransactionReportsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Short windows (small Windows laptops, 1080p at 125/150% scaling) give the
    // 80px bar back to the transaction grid; `multi` and `bottomSpacer` must
    // agree or the bar overflows its preferred size.
    final metrics = ReportMetrics.forWindow(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      // Shared CustomAppBar so the close button matches the rest of the app
      // (circular outlined AppBarRoundIconButton, e.g. Cash Book).
      appBar: CustomAppBar(
        title: 'Transaction Reports',
        onPop: () => Navigator.of(context).pop(),
        barBackgroundColor: const Color(0xFFF2F4F7),
        isDividerVisible: false,
        multi: metrics.appBarMulti,
        bottomSpacer: metrics.appBarHeight,
      ),
      body: const SafeArea(
        child: TransactionListWrapper(showDetailedReport: true),
      ),
    );
  }
}
