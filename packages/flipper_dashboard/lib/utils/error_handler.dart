import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_ui/snack_bar_utils.dart';

/// Utility class for handling and displaying user-friendly error messages
class ErrorHandler {
  /// Converts technical errors to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    final l10n = FlipperL10n.current;

    // Database errors
    if (errorString.contains('databaseexception') ||
        errorString.contains('readonly') ||
        errorString.contains('attempt to write a readonly database') ||
        errorString.contains('code=1032')) {
      return l10n.errorUnableToSaveData;
    }

    if (errorString.contains('database') && errorString.contains('locked')) {
      return l10n.errorDatabaseBusy;
    }

    // Network errors
    if (errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('handshake')) {
      return l10n.errorNoInternet;
    }

    // Authentication errors
    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('401')) {
      return l10n.errorSessionExpired;
    }

    if (errorString.contains('forbidden') || errorString.contains('403')) {
      return l10n.errorNoPermission;
    }

    // Timeout errors
    if (errorString.contains('timeout')) {
      return l10n.errorRequestTimedOut;
    }

    // Permission errors
    if (errorString.contains('permission')) {
      return l10n.errorPermissionDenied;
    }

    // Server errors
    if (errorString.contains('500') ||
        errorString.contains('503') ||
        errorString.contains('server error')) {
      return l10n.errorServerUnavailable;
    }

    // Not found errors
    if (errorString.contains('404') || errorString.contains('not found')) {
      return l10n.errorNotFound;
    }

    // Validation errors
    if (errorString.contains('validation') || errorString.contains('invalid')) {
      return l10n.errorCheckInput;
    }

    // Ditto sync errors
    if (errorString.contains('ditto') || errorString.contains('sync')) {
      return l10n.errorSyncUnavailable;
    }

    // Generic fallback
    return l10n.errorGenericContactSupport;
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
