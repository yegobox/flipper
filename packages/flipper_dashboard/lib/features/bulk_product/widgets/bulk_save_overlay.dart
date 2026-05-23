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
      child: AbsorbPointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.35),
          child: Center(
            child: ValueListenableBuilder<ProgressData>(
              valueListenable: model.progressNotifier,
              builder: (context, progressData, _) {
                final total = progressData.totalItems;
                final current = progressData.currentItem;
                final pct = total > 0 ? (current / total * 100) : 0.0;

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
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 72,
                          width: 72,
                          child: CircularProgressIndicator(
                            value: total > 0 ? current / total : null,
                            strokeWidth: 6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                        if (total > 0) ...[
                          const SizedBox(height: 6),
                          Text(
                            '$current of $total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
