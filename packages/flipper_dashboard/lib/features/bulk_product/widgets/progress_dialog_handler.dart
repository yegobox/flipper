import 'package:flutter/material.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:supabase_models/brick/models/ProgressData.dart';
import 'package:flipper_dashboard/features/bulk_product/widgets/compact_progress_dialog.dart';

class ProgressDialogHandler extends StatelessWidget {
  final VoidCallback onSave;

  const ProgressDialogHandler({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return FlipperButton(
      textColor: Colors.white,
      color: Colors.blue,
      onPressed: onSave,
      text: 'Save All',
    );
  }

  static Future<void> showProgressDialog(
    BuildContext context,
    Future<void> Function(ValueNotifier<ProgressData>) savingFunction,
    {VoidCallback? onComplete,}
  ) async {
    final progressNotifier = ValueNotifier<ProgressData>(
      ProgressData(progress: '', currentItem: 0, totalItems: 0),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Use a custom wrapper to constrain the dialog width
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350), // Reduced width
            child: ValueListenableBuilder<ProgressData>(
              valueListenable: progressNotifier,
              builder: (context, progressData, child) {
                return CompactProgressDialog(
                  progress: progressData.progress,
                  currentItem: progressData.currentItem,
                  totalItems: progressData.totalItems,
                );
              },
            ),
          ),
        );
      },
    );

    try {
      await savingFunction(progressNotifier);
      // Add a small delay to show completion state
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pop();
      onComplete?.call();
    } catch (e) {
      Navigator.of(context).pop();
      rethrow;
    }
  }
}
