import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/BulkAddProductViewModel.dart';
import 'package:supabase_models/brick/models/ProgressData.dart';

/// Blocks the full bulk form while save is in progress.
class BulkSaveOverlay extends StatelessWidget {
  final BulkAddProductViewModel model;

  const BulkSaveOverlay({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: AbsorbPointer(
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
          ),
          ValueListenableBuilder<ProgressData>(
            valueListenable: model.progressNotifier,
            builder: (context, progressData, _) {
              final total = progressData.totalItems;
              final current = progressData.currentItem;
              final ratio = total > 0 ? current / total : 0.0;
              final pctLabel = ProgressData.formatPercent(current, total);

              return Material(
                borderRadius: BorderRadius.circular(16),
                elevation: 8,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Saving products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: total > 0 ? ratio.clamp(0.0, 1.0) : null,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (total > 0)
                        Text(
                          '$current of $total',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      if (total > 0) const SizedBox(height: 4),
                      Text(
                        pctLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        progressData.progress.isNotEmpty
                            ? progressData.progress
                            : 'Please wait…',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => model.dismissBlockingSaveOverlay(),
                        child: const Text(
                          'Hide · save continues',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        'Progress stays on the bar above the grid.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
