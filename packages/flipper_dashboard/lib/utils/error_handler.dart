import 'package:flutter/material.dart';
import 'package:flipper_dashboard/utils/snack_bar_utils.dart';

/// Utility class for handling and displaying user-friendly error messages
class ErrorHandler {
  /// Converts technical errors to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Database errors
    if (errorString.contains('databaseexception') ||
        errorString.contains('readonly') ||
        errorString.contains('attempt to write a readonly database') ||
        errorString.contains('code=1032')) {
      return 'Unable to save data. Please restart the app and try again.';
    }

    if (errorString.contains('database') && errorString.contains('locked')) {
      return 'Database is busy. Please wait a moment and try again.';
    }

    // Network errors
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('handshake')) {
      return 'No internet connection. Please check your network and try again.';
    }

    // Authentication errors
    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('401')) {
      return 'Session expired. Please log in again.';
    }

    if (errorString.contains('forbidden') || errorString.contains('403')) {
      return 'You don\'t have permission to perform this action.';
    }

    // Timeout errors
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    // Permission errors
    if (errorString.contains('permission')) {
      return 'Permission denied. Please check app permissions in settings.';
    }

    // Server errors
    if (errorString.contains('500') ||
        errorString.contains('503') ||
        errorString.contains('server error')) {
      return 'Server is temporarily unavailable. Please try again later.';
    }

    // Not found errors
    if (errorString.contains('404') || errorString.contains('not found')) {
      return 'The requested resource was not found.';
    }

    // Validation errors
    if (errorString.contains('validation') || errorString.contains('invalid')) {
      return 'Please check your input and try again.';
    }

    // Ditto sync errors
    if (errorString.contains('ditto') || errorString.contains('sync')) {
      return 'Sync temporarily unavailable. Your changes will sync when connection is restored.';
    }

    // Generic fallback
    return 'Something went wrong. Please try again or contact support if the problem persists.';
  }

  /// Shows a user-friendly error message in a SnackBar
  static void showErrorSnackBar(
    BuildContext context,
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
  }) {
    showCustomSnackBarUtil(
      context,
      getUserFriendlyMessage(error),
      type: NotificationType.error,
      backgroundColor: backgroundColor,
      duration: duration,
      showCloseButton: true,
    );
  }

  /// Shows a success message in a SnackBar
  static void showSuccessSnackBar(
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

  /// Shows an info message in a SnackBar
  static void showInfoSnackBar(
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

  /// Shows a warning message in a SnackBar
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    showCustomSnackBarUtil(
      context,
      message,
      type: NotificationType.warning,
      duration: duration,
    );
  }
}
