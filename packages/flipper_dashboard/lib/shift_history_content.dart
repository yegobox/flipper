import 'package:flipper_accounting/shift_history_view.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Embeds [ShiftHistoryView] in the dashboard shell (no nested route).
class ShiftHistoryContent extends ConsumerWidget {
  const ShiftHistoryContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShiftHistoryView(
      onBack: () {
        ref.read(selectedPageProvider.notifier).state = DashboardPage.inventory;
      },
    );
  }
}
