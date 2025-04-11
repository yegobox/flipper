import 'package:flipper_models/db_model_export.dart';

/// Interface defining the core functionality for notifications across all platforms
abstract class NotificationInterface {
  /// Initialize the notification system
  Future<void> initialize();

  /// Show a notification immediately
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  });

  /// Schedule a notification for a conversation
  Future<void> scheduleNotification(Conversation conversation);

  /// Cancel a notification by ID
  Future<void> cancelNotification(int id);

  /// Set the notification badge count
  Future<void> setNotificationBadge(int count);

  /// Snooze a task notification
  Future<void> snoozeTask(Conversation task);

  /// Request notification permissions if needed
  Future<bool?> requestPermission();
}
