import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide RepeatInterval;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:launcher_entry/launcher_entry.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:window_manager/window_manager.dart';

import 'package:flipper_ui/system_tray/system_tray_manager.dart';
import '../notifications.dart';

part 'notifications_state.dart';
part 'notifications_cubit.freezed.dart';

class NotificationsCubit {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationsCubit._(
    this._notificationsPlugin,
  ) {
    instance = this;
    _checkAppStartup();
  }
  static late NotificationsCubit instance;

  static Future<NotificationsCubit> initialize({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) async {
    tz.initializeTimeZones();
    final localTimeZoneName = tz.local.name;
    tz.setLocalLocation(tz.getLocation(localTimeZoneName));

    const initSettingsAndroid = AndroidInitializationSettings('app_icon');
    const initSettingsDarwin = DarwinInitializationSettings();
    final initSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon(AppIcons.linux),
    );

    final initSettings = InitializationSettings(
        android: initSettingsAndroid,
        iOS: initSettingsDarwin,
        macOS: initSettingsDarwin,
        windows: WindowsInitializationSettings(
            appName: "flipper",
            appUserModelId: localTimeZoneName,
            guid: "0E6A8A0A-B5A6-4E0B-A9B8-D1D5D0D3D4D5"),
        linux: initSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse:
          _notificationBackgroundCallback,
      onDidReceiveNotificationResponse: _notificationCallback,
    );

    return NotificationsCubit._(
      flutterLocalNotificationsPlugin,
    );
  }

  static const _androidNotificationDetails = AndroidNotificationDetails(
    kPackageId,
    'App notifications',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: DefaultStyleInformation(true, true),
  );

  static const _iOSNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const _macOSNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const _linuxNotificationDetails = LinuxNotificationDetails(
    actions: [
      LinuxNotificationAction(
        key: 'complete',
        label: 'Complete',
      ),
      LinuxNotificationAction(
        key: 'snooze',
        label: 'Snooze',
      ),
    ],
    defaultActionName: 'Open notification',
    urgency: LinuxNotificationUrgency.critical,
  );

  final _timers = <String, Timer>{};

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> setNotificationBadge(int count) async {
    if (isLinux) {
      await _setNotificationBadgeLinux(count);
    } else if (isWindows) {
      await _setNotificationBadgeWindows(count);
    }
  }

  bool permissionGranted = false;
  Future<void> scheduleNotification(Conversation conversation) async {
    if (!(await _requestPermission())!) {
      return;
    }

    final createdAt = DateTime.parse(
            conversation.createdAt ?? DateTime.now().toIso8601String())
        .toLocal();
    final String? dueDateFormatted;

    final iConversation = IConversation(
        id: conversation.id,
        body: conversation.body ?? "",
        createdAt: conversation.createdAt,
        userName: conversation.userName ?? "");

    dueDateFormatted = DateFormat.yMMMMd().add_jm().format(createdAt);

    final notification = Notification(
      id: conversation.id.toString().codeUnitAt(0),
      title: iConversation.body,
      body: dueDateFormatted,
      payload: jsonEncode(iConversation),
    );

    if (isLinux || isWindows) {
      await _scheduleNotificationDesktop(notification);
    } else {
      await _scheduleNotificationMobile(notification);
    }
  }

  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    id ??= _generateNotificationId();

    const notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iOSNotificationDetails,
      macOS: _macOSNotificationDetails,
      linux: _linuxNotificationDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> snoozeTask(Conversation task) async {
    await cancelNotification(task.id.toString().codeUnitAt(0));
  }

  Future<void> _checkAppStartup() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;

    final appLaunchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();

    final notificationResponse = appLaunchDetails?.notificationResponse;

    if (appLaunchDetails == null ||
        !appLaunchDetails.didNotificationLaunchApp ||
        notificationResponse == null) {
      return;
    }
  }

  int _generateNotificationId() {
    return Random().nextInt(1 << 30);
  }

  Future<bool?> _requestPermission() async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return true;
    }

    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    return await androidPlugin.requestNotificationsPermission();
  }

  Future<void> _scheduleNotificationDesktop(Notification notification) async {
    if (isWindows) {
      await _scheduleNotificationWindows(notification);
      return;
    }

    final task = IConversation.fromJson(jsonDecode(notification.payload!));

    final dueDate = task.createdAt;
    if (dueDate == null) {
      return;
    }

    if (DateTime.parse(dueDate).isBefore(DateTime.now())) {
      await showNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
      );
      return;
    }

    final timer = Timer(
      DateTime.parse(dueDate).difference(DateTime.now()),
      () async {
        await showNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
        );
      },
    );

    _timers[task.id.toString()] = timer;
  }

  Future<void> _scheduleNotificationMobile(Notification notification) async {
    final conversation =
        IConversation.fromJson(jsonDecode(notification.payload!));

    final createdAt = conversation.createdAt;
    if (createdAt == null) {
      return;
    }

    if (DateTime.parse(createdAt).isBefore(DateTime.now())) {
      await showNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        payload: notification.payload,
      );
      return;
    }

    await _scheduleNotificationWithSystem(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: DateTime.parse(createdAt),
      payload: notification.payload,
    );
  }

  Future<void> _scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
      iOS: _iOSNotificationDetails,
      macOS: _macOSNotificationDetails,
      linux: _linuxNotificationDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> _scheduleNotificationWindows(Notification notification) async {
    final conversation =
        IConversation.fromJson(jsonDecode(notification.payload!));

    final createdAt = conversation.createdAt;

    if (createdAt == null) {
      return;
    }

    if (DateTime.parse(createdAt).isBefore(DateTime.now())) {
      return;
    }

    final timer = Timer(
      DateTime.parse(createdAt).difference(DateTime.now()),
      () async {},
    );

    _timers[conversation.id.toString()] = timer;
  }

  Future<void> _setNotificationBadgeLinux(int count) async {
    await _setNotificationBadgeLinuxTaskbar(count);
    await _setNotificationBadgeLinuxSystemTray(count);
  }

  Future<void> _setNotificationBadgeLinuxTaskbar(int count) async {
    final service = LauncherEntryService(
      appUri: 'application://$kPackageId.desktop',
    );
    await service.update(count: count, countVisible: true);
  }

  Future<void> _setNotificationBadgeLinuxSystemTray(int count) async {
    final icon = (count > 0)
        ? AppIcons.linuxSymbolicWithNotificationBadge
        : AppIcons.linuxSymbolic;

    await SystemTrayManager.instance.setIcon(icon);
  }

  Future<void> _setNotificationBadgeWindows(int count) async {
    await _setNotificationBadgeWindowsTaskbar(count);
    await _setNotificationBadgeWindowsSystemTray(count);
  }

  Future<void> _setNotificationBadgeWindowsTaskbar(int count) async {
    final icon =
        (count > 0) ? AppIcons.windowsWithNotificationBadge : AppIcons.windows;

    await windowManager.setIcon(icon);
  }

  Future<void> _setNotificationBadgeWindowsSystemTray(int count) async {
    final icon = (count > 0)
        ? AppIcons.windowsSymbolicWithNotificationBadge
        : AppIcons.windowsSymbolic;

    await SystemTrayManager.instance.setIcon(icon);
  }
}

/// A stream that emits a notification response when the user taps on a
/// notification.
final StreamController<NotificationResponse> notificationResponseStream =
    StreamController.broadcast();

/// Handle background notification actions.
///
/// This is called when the user taps on a notification action button.
///
/// On all platforms except Linux this runs in a separate isolate.
@pragma('vm:entry-point')
void _notificationBackgroundCallback(NotificationResponse response) {
  throw UnimplementedError();
}

/// Called when the user taps on a notification.
Future<void> _notificationCallback(NotificationResponse response) async {
  switch (response.notificationResponseType) {
    case NotificationResponseType.selectedNotification:
      notificationResponseStream.add(response);
      break;
    case NotificationResponseType.selectedNotificationAction:
      notificationResponseStream.add(response);
      break;
  }
}
