import 'package:flipper_accounting/shift_history_view.dart';
import 'package:flutter/material.dart';

/// Wrapper widget that displays ShiftHistoryView content without the Scaffold
/// This allows it to be embedded in the dashboard layout without nesting Scaffolds
class ShiftHistoryContent extends StatelessWidget {
  const ShiftHistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Return the ShiftHistoryView directly
    // The view will handle its own Scaffold, AppBar, and content
    return const ShiftHistoryView();
  }
}
