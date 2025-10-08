import 'package:flutter/material.dart';

/// Enum for different notification types
enum NotificationType {
  success,
  error,
  warning,
  info,
}

/// Shows a custom SnackBar with enhanced styling and animations
void showCustomSnackBarUtil(
  BuildContext context,
  String message, {
  NotificationType type = NotificationType.success,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 4),
  bool showCloseButton = false,
  IconData? icon,
  VoidCallback? onAction,
  String? actionLabel,
}) {
  // Get color and icon based on type if not provided
  final Color bgColor = backgroundColor ?? _getTypeColor(type);
  final IconData displayIcon = icon ?? _getTypeIcon(type);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width > 600 ? 350.0 : 16.0,
        right: MediaQuery.of(context).size.width > 600 ? 350.0 : 16.0,
        bottom: 20.0,
      ),
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              displayIcon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: duration,
      action: showCloseButton || onAction != null
          ? SnackBarAction(
              label: actionLabel ?? '✕',
              textColor: Colors.white.withOpacity(0.9),
              onPressed: onAction ??
                  () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            )
          : null,
    ),
  );
}

/// Shows a fancy deletion confirmation snackbar with enhanced UX
void showDeletionConfirmationSnackBar<T>(
  BuildContext context,
  List<T> items,
  String Function(T) getDisplayName,
  Future<void> Function() onConfirm, {
  VoidCallback? onUndo,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color(0xFF1E1E1E),
      duration: const Duration(seconds: 6),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete ${items.length} item${items.length == 1 ? '' : 's'}?',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'This action cannot be undone',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                        .take(3)
                        .map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      getDisplayName(item),
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList() +
                    [
                      if (items.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '+ ${items.length - 3} more item${items.length - 3 == 1 ? '' : 's'}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[400],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'CANCEL',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'DELETE',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Shows a success notification
void showSuccessNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.success,
    duration: duration,
  );
}

/// Shows an error notification
void showErrorNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.error,
    duration: duration,
  );
}

/// Shows a warning notification
void showWarningNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.warning,
    duration: duration,
  );
}

/// Shows an info notification
void showInfoNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.info,
    duration: duration,
  );
}

/// Helper function to get color based on notification type
Color _getTypeColor(NotificationType type) {
  switch (type) {
    case NotificationType.success:
      return const Color(0xFF10B981);
    case NotificationType.error:
      return const Color(0xFFEF4444);
    case NotificationType.warning:
      return const Color(0xFFF59E0B);
    case NotificationType.info:
      return const Color(0xFF3B82F6);
  }
}

/// Helper function to get icon based on notification type
IconData _getTypeIcon(NotificationType type) {
  switch (type) {
    case NotificationType.success:
      return Icons.check_circle_outline_rounded;
    case NotificationType.error:
      return Icons.error_outline_rounded;
    case NotificationType.warning:
      return Icons.warning_amber_rounded;
    case NotificationType.info:
      return Icons.info_outline_rounded;
  }
}