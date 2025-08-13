import 'package:flutter/material.dart';

/// Shows a custom SnackBar with consistent styling.
void showCustomSnackBarUtil(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 4),
  bool showCloseButton = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: const EdgeInsets.only(
        left: 350.0,
        right: 350.0,
        bottom: 20.0,
      ),
      content: Text(message),
      backgroundColor: backgroundColor ?? Colors.green[600],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      duration: duration,
      action: showCloseButton
          ? SnackBarAction(
              label: 'X',
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            )
          : null,
    ),
  );
}

/// Shows a fancy deletion confirmation snackbar with ticket details
void showDeletionConfirmationSnackBar<T>(
  BuildContext context,
  List<T> items,
  String Function(T) getDisplayName,
  Future<void> Function() onConfirm,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.grey[900],
      duration: const Duration(seconds: 6),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Delete ${items.length} item${items.length == 1 ? '' : 's'}?',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.take(3).map((item) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '• ${getDisplayName(item)}',
                      style: TextStyle(color: Colors.grey[300], fontSize: 13),
                    ),
                  )
                ).toList() + [
                  if (items.length > 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '• and ${items.length - 3} more...',
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'DELETE',
        textColor: Colors.red,
        onPressed: () => onConfirm(),
      ),
    ),
  );
}
