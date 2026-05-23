import 'package:flutter/material.dart';
import 'package:flipper_models/bulk_rra_client.dart';

/// Result dialog after bulk save (replaces plain AlertDialog).
Future<bool?> showBulkSaveResultSheet({
  required BuildContext context,
  required BulkSaveResult result,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: !result.success,
    builder: (ctx) {
      return AlertDialog(
        title: Text(
          result.success ? 'Bulk save complete' : 'Bulk save failed',
        ),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (result.total > 0) ...[
                  Text(
                    'Total: ${result.total} · Succeeded: ${result.succeeded} · '
                    'Failed: ${result.failed}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(result.message),
                if (result.rraSkipped) ...[
                  const SizedBox(height: 12),
                  Text(
                    'RRA was not called (tax disabled for this branch).',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
                if (result.jobId != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Job: ${result.jobId}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          if (!result.success)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Stay'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(result.success),
            child: Text(result.success ? 'Done' : 'Close'),
          ),
        ],
      );
    },
  );
}
