import 'dart:convert';
import 'dart:math';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:intl/intl.dart';

import '../models/notification.dart';

/// Utility class for notification-related operations
class NotificationUtils {
  /// Create a notification object from a conversation
  static Notification createNotificationFromConversation(
    Conversation conversation,
  ) {
    final createdAt = conversation.createdAt ?? DateTime.now().toLocal();
    final dueDateFormatted = DateFormat.yMMMMd().add_jm().format(createdAt);

    final iConversation = IConversation(
      id: conversation.id,
      body: conversation.title,
      createdAt: conversation.createdAt,
      userName: conversation.title,
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

  /// OS / in-app banner body for a print delegation notification.
  static String formatDelegationBody(TransactionDelegation delegation) {
    final amount = NumberFormat('#,##0', 'en_US').format(delegation.subTotal);
    final customerName = delegation.customerName?.trim();
    final fromDevice = delegation.delegatedFromDevice;

    if (customerName != null && customerName.isNotEmpty) {
      return '${delegation.receiptType} receipt for $customerName · '
          'RWF $amount · from $fromDevice';
    }
    return '${delegation.receiptType} receipt · RWF $amount · from $fromDevice';
  }

  /// Branch name shown in a notification, never its id — an id means nothing
  /// to staff. Falls back to a generic label while the branch doc has not
  /// synced to this device yet.
  static String branchLabel(Branch? branch) {
    final name = branch?.name?.trim();
    return (name == null || name.isEmpty) ? 'another branch' : name;
  }

  /// OS / in-app banner body for an incoming branch stock transfer.
  ///
  /// [request.branch] is the source branch (hydrated from `mainBranchId` by
  /// `requestsStreamOutgoing`). Lists product names when the items are
  /// loaded, otherwise just the count.
  static String formatStockTransferBody(InventoryRequest request) {
    final from = branchLabel(request.branch);
    final names = (request.transactionItems ?? const <TransactionItem>[])
        .map((item) => item.name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    final count = max(request.itemCounts?.toInt() ?? 0, names.length);

    if (names.isNotEmpty) {
      const shown = 2;
      final listed = names.take(shown).join(', ');
      final more = count - min(names.length, shown);
      return 'Incoming transfer from $from: $listed'
          '${more > 0 ? ' +$more more' : ''}';
    }
    if (count > 0) {
      return 'Incoming transfer from $from '
          '($count ${count == 1 ? 'item' : 'items'})';
    }
    return 'Incoming transfer from $from';
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
