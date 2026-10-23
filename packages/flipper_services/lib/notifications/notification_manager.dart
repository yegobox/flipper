import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'engagement_push.dart';
import 'interfaces/notification_interface.dart';
import 'platforms/android_notifications.dart';
import 'platforms/darwin_notifications.dart';
import 'platforms/linux_notifications.dart';
import 'platforms/web_notifications.dart';
import 'platforms/windows_notifications.dart';

/// A stream that emits a notification response when the user taps on a notification.
final StreamController<NotificationResponse> notificationResponseStream =
    StreamController.broadcast();

/// Manager class that handles notifications across all platforms
class NotificationManager implements NotificationInterface {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  late NotificationInterface _platformNotifications;
  static late NotificationManager instance;

  NotificationManager._(this._notificationsPlugin) {
    instance = this;
    _initPlatformImplementation();
    _checkAppStartup();
  }

  /// Initialize the notification manager
  static Future<NotificationManager> create({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) async {
    final manager = NotificationManager._(flutterLocalNotificationsPlugin);
    await manager._platformNotifications.initialize();
    return manager;
  }

  /// Initialize the platform-specific implementation
  void _initPlatformImplementation() {
    if (kIsWeb) {
      _platformNotifications = WebNotifications(_notificationsPlugin);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      _platformNotifications = AndroidNotifications(_notificationsPlugin);
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      _platformNotifications = DarwinNotifications(_notificationsPlugin);
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      _platformNotifications = LinuxNotifications(_notificationsPlugin);
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      _platformNotifications = WindowsNotifications(_notificationsPlugin);
    } else {
      throw UnsupportedError('Unsupported platform: $defaultTargetPlatform');
    }
  }

  /// Check if the app was launched from a notification
  Future<void> _checkAppStartup() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    // [create] runs at boot and again lazily; the launch details stay the
    // same all process long, so only the first may route them.
    if (!claimLaunchEngagementTap()) return;

    final appLaunchDetails = await _notificationsPlugin
        .getNotificationAppLaunchDetails();

    final notificationResponse = appLaunchDetails?.notificationResponse;

    if (appLaunchDetails == null ||
        !appLaunchDetails.didNotificationLaunchApp ||
        notificationResponse == null) {
      return;
    }
    // The app was started by a tap on one of our local notifications (an
    // engagement push shown while the app was open): route it like a tap on
    // a running app. [openEngagementAction] keeps it until the home is up.
    final action = engagementActionFromPayload(notificationResponse.payload);
    if (action != null) openEngagementAction(action);
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _platformNotifications.cancelNotification(id);
  }

  @override
  Future<bool?> requestPermission() async {
    return await _platformNotifications.requestPermission();
  }

  @override
  Future<void> scheduleNotification(Conversation conversation) async {
    await _platformNotifications.scheduleNotification(conversation);
  }

  @override
  Future<void> setNotificationBadge(int count) async {
    await _platformNotifications.setNotificationBadge(count);
  }

  @override
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _platformNotifications.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  @override
  Future<void> snoozeTask(Conversation task) async {
    await _platformNotifications.snoozeTask(task);
  }

  @override
  Future<void> showOrderNotification(InventoryRequest order) async {
    await _platformNotifications.showOrderNotification(order);
  }

  @override
  Future<void> showDelegationNotification(
    TransactionDelegation delegation,
  ) async {
    await _platformNotifications.showDelegationNotification(delegation);
  }

  @override
  Future<void> initialize() async {
    // Already initialized in the static initialize method
  }
}

/// Handle background notification actions.
///
/// This is called when the user taps on a notification action button.
///
/// On all platforms except Linux this runs in a separate isolate.
@pragma('vm:entry-point')
void notificationBackgroundCallback(NotificationResponse response) {
  throw UnimplementedError();
}

/// Called when the user taps on a notification.
Future<void> notificationCallback(NotificationResponse response) async {
  switch (response.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      notificationResponseStream.add(response);
      break;
    case NotificationResponseType.selectedNotificationAction:
      notificationResponseStream.add(response);
      break;
    case NotificationResponseType.notificationDismissed:
      break;
  }
}
