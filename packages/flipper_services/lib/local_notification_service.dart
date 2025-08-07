import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/notifications/notification_manager.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

abstract class LNotification {
  Future<void> sendLocalNotification(
      {required String body, String? userName = "Flipper"});
}

class UnSupportedLocalNotification implements LNotification {
  @override
  Future<void> sendLocalNotification(
      {required String body, String? userName = "System"}) {
    // TODO: implement sendLocalNotification
    throw UnimplementedError();
  }
}

class LocalNotificationService implements LNotification {
  // Initialize the NotificationManager instance
  static NotificationManager? _notificationManager;

  LocalNotificationService() {
    // Initialize the NotificationManager in the constructor
    _initNotificationManager();
  }

  // Initialize the NotificationManager (ideally this should be done
  // in your main function or a global setup method)
  void _initNotificationManager() async {
    _notificationManager = await NotificationManager.create(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }

  @override
  Future<void> sendLocalNotification(
      {required String body, String? userName = "Flipper"}) async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        // Skip notification if branch ID is not available
        return;
      }
      
      Conversation? conversation = Conversation(
        title: body,
        branchId: branchId,
      );

      // Now you can use _notificationManager safely
      await _notificationManager?.scheduleNotification(conversation);
    } catch (e) {
      rethrow;
    }
  }
}
