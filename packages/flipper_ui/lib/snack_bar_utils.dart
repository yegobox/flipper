import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Enum for different notification types
enum NotificationType {
  success,
  error,
  warning,
  info,
}

/// Configuration class for snackbar animations
class SnackBarAnimationConfig {
  final Duration slideInDuration;
  final Duration slideOutDuration;
  final Curve slideInCurve;
  final Curve slideOutCurve;

  const SnackBarAnimationConfig({
    this.slideInDuration = const Duration(milliseconds: 300),
    this.slideOutDuration = const Duration(milliseconds: 200),
    this.slideInCurve = Curves.easeOutCubic,
    this.slideOutCurve = Curves.easeInCubic,
  });
}

/// Shows a custom SnackBar with enhanced styling and animations
void showCustomSnackBarUtil(
  BuildContext context,
  String message, {
  NotificationType type = NotificationType.success,
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 4),
  bool showCloseButton = true,
  IconData? icon,
  VoidCallback? onAction,
  String? actionLabel,
  bool enableHapticFeedback = true,
  TextStyle? messageStyle,
  SnackBarAnimationConfig? animationConfig,
  String? semanticLabel,
  double? maxWidth,
  Widget? leading,
  Widget? trailing,
}) {
  // Trigger haptic feedback based on notification type
  if (enableHapticFeedback) {
    _triggerHapticFeedback(type);
  }

  // Get color and icon based on type if not provided
  final Color bgColor = backgroundColor ?? _getTypeColor(type);
  final IconData displayIcon = icon ?? _getTypeIcon(type);
  final config = animationConfig ?? const SnackBarAnimationConfig();

  // Calculate responsive margins
  final screenWidth = MediaQuery.of(context).size.width;
  final isWideScreen = screenWidth > 600;
  final horizontalMargin =
      isWideScreen ? (screenWidth > 1200 ? 400.0 : 350.0) : 16.0;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.only(
        left:
            maxWidth != null ? (screenWidth - maxWidth) / 2 : horizontalMargin,
        right:
            maxWidth != null ? (screenWidth - maxWidth) / 2 : horizontalMargin,
        bottom: 20.0,
      ),
      content: Semantics(
        label: semanticLabel ?? '$message notification',
        liveRegion: true,
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 12),
            ] else ...[
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
            ],
            Expanded(
              child: Text(
                message,
                style: messageStyle ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
              ),
            ),
            if (showCloseButton || onAction != null) ...[
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  if (enableHapticFeedback) {
                    HapticFeedback.lightImpact();
                  }
                  if (onAction != null) {
                    onAction();
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: actionLabel != null
                      ? Text(
                          actionLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                ),
              ),
            ] else if (trailing != null) ...[
              const SizedBox(width: 8),
              trailing,
            ],
          ],
        ),
      ),
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: duration,
      animation: CurvedAnimation(
        parent: kAlwaysCompleteAnimation,
        curve: config.slideInCurve,
        reverseCurve: config.slideOutCurve,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      dismissDirection: DismissDirection.horizontal,
      clipBehavior: Clip.antiAlias,
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
  bool enableHapticFeedback = true,
  String? customTitle,
  String? customWarning,
  double? maxWidth,
}) {
  if (enableHapticFeedback) {
    HapticFeedback.mediumImpact();
  }

  final screenWidth = MediaQuery.of(context).size.width;
  final isWideScreen = screenWidth > 600;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: const Color(0xFF1E1E1E),
      duration: const Duration(seconds: 6),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: maxWidth != null
            ? (screenWidth - maxWidth) / 2
            : (isWideScreen ? 350.0 : 16.0),
        vertical: 16,
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      content: Semantics(
        label: 'Delete confirmation for ${items.length} items',
        child: Column(
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
                        customTitle ??
                            'Delete ${items.length} item${items.length == 1 ? '' : 's'}?',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customWarning ?? 'This action cannot be undone',
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
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
                  onPressed: () {
                    if (enableHapticFeedback) {
                      HapticFeedback.lightImpact();
                    }
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (enableHapticFeedback) {
                      HapticFeedback.mediumImpact();
                    }
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'DELETE',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows a success notification
void showSuccessNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
  bool enableHapticFeedback = true,
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.success,
    duration: duration,
    enableHapticFeedback: enableHapticFeedback,
  );
}

/// Shows an error notification, optionally with an inline action button.
///
/// Pass [actionLabel] + [onAction] to embed a button (e.g. "Resend OTP")
/// directly in the snackbar instead of using a raw [ScaffoldMessenger] call.
void showErrorNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
  bool enableHapticFeedback = true,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.error,
    duration: duration,
    enableHapticFeedback: enableHapticFeedback,
    actionLabel: actionLabel,
    onAction: onAction,
  );
}

/// Shows a warning notification
void showWarningNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 4),
  bool enableHapticFeedback = true,
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.warning,
    duration: duration,
    enableHapticFeedback: enableHapticFeedback,
  );
}

/// Shows an info notification
void showInfoNotification(
  BuildContext context,
  String message, {
  Duration duration = const Duration(seconds: 3),
  bool enableHapticFeedback = true,
}) {
  showCustomSnackBarUtil(
    context,
    message,
    type: NotificationType.info,
    duration: duration,
    enableHapticFeedback: enableHapticFeedback,
  );
}

/// Triggers haptic feedback based on notification type
void _triggerHapticFeedback(NotificationType type) {
  switch (type) {
    case NotificationType.success:
      HapticFeedback.lightImpact();
      break;
    case NotificationType.error:
      HapticFeedback.mediumImpact();
      break;
    case NotificationType.warning:
      HapticFeedback.lightImpact();
      break;
    case NotificationType.info:
      HapticFeedback.selectionClick();
      break;
  }
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
