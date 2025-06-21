import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:intl/intl.dart';

import '../models/notification.dart';

/// Utility class for notification-related operations
class NotificationUtils {
  /// Create a notification object from a conversation
  static Notification createNotificationFromConversation(
      Conversation conversation) {
    final createdAt = conversation.createdAt ?? DateTime.now().toLocal();
    final dueDateFormatted = DateFormat.yMMMMd().add_jm().format(createdAt);

    final iConversation = IConversation(
      id: conversation.id,
      body: conversation.body ?? "",
      createdAt: conversation.createdAt,
      userName: conversation.userName ?? "",
    );

    return Notification(
      id: conversation.id.toString().codeUnitAt(0),
      title: iConversation.body,
      body: dueDateFormatted,
      payload: jsonEncode(iConversation),
    );
  }

  /// Check if a scheduled date is in the past
  static bool isScheduledDateInPast(DateTime? scheduledDate) {
    if (scheduledDate == null) return false;
    return scheduledDate.isBefore(DateTime.now());
  }

  /// Parse a notification payload into an IConversation object
  static IConversation? parseNotificationPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      return IConversation.fromJson(jsonDecode(payload));
    } catch (e) {
      return null;
    }
  }
}
