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
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF2F4F7),
        foregroundColor: const Color(0xFF111827),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Transaction Reports',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: const SafeArea(
        child: TransactionListWrapper(showDetailedReport: true),
      ),
    );
  }
}
