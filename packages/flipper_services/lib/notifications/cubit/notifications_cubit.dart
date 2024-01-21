import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flipper_models/isar/conversation.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide RepeatInterval;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:launcher_entry/launcher_entry.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:window_manager/window_manager.dart';

import 'package:flipper_ui/system_tray/system_tray_manager.dart';
import 'package:flipper_ui/window/app_window.dart';
import '../notifications.dart';

part 'notifications_state.dart';
part 'notifications_cubit.freezed.dart';

/// Cubit for managing notifications.
// class NotificationsCubit extends Cubit<NotificationsState> {
class NotificationsCubit {
  /// Plugin instance.
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationsCubit._(
    this._notificationsPlugin,
  ) {
    instance = this;
    _checkAppStartup();
  }
  //  NotificationsCubit._(
  //   this._notificationsPlugin,
  // ) : super(NotificationsState.initial()) {
  //   instance = this;
  //   _checkAppStartup();
  // }
  /// Singleton instance.
  static late NotificationsCubit instance;

  /// Initialize the cubit.
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
        linux: initSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse:
          _notificationBackgroundCallback,
      onDidReceiveNotificationResponse: _notificationCallback,
    );

    if (isWindows) {
      await localNotifier.setup(appName: kPackageId);
    }

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

  /// Notification timers.
  ///
  /// This is a map of task ids to timers. The timers are used to schedule
  /// notifications for tasks on desktop.
  final _timers = <String, Timer>{};

  /// Cancel a notification.
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Set the taskbar and system tray icon notification badge.
  ///
  /// Only works on Linux and Windows.
  Future<void> setNotificationBadge(int count) async {
    //if (state.overdueTasksCount == count) return;

    if (isLinux) {
      await _setNotificationBadgeLinux(count);
    } else if (isWindows) {
      await _setNotificationBadgeWindows(count);
    }

    //emit(state.copyWith(overdueTasksCount: count));
  }

  /// Schedule a notification for a task.
  ///
  /// This will only schedule a notification if notifications are enabled and
  /// permission has been granted.
  bool permissionGranted = false;
  Future<void> scheduleNotification(Conversation conversation) async {
    // if (!state.enabled) {
    //   // log('Notifications are disabled. Not scheduling notification.');
    //   return;
    // }

    if (!permissionGranted) {
      await _requestPermission();
      if (!permissionGranted) {
        print(
          'Notifications permission not granted. Not scheduling notification.',
        );
        return;
      }
    }

    // The due date in local time and user-friendly format: 'March 1, 2021 12:00 AM'
    final createdAt = DateTime.parse(conversation.createdAt!).toLocal();
    final String? dueDateFormatted;

    dueDateFormatted = DateFormat.yMMMMd().add_jm().format(createdAt);

    final notification = Notification(
      id: conversation.id.codeUnitAt(0),
      title: conversation.body,
      body: dueDateFormatted,
      payload: jsonEncode(conversation.toJson()),
    );

    if (isLinux || isWindows) {
      await _scheduleNotificationDesktop(notification);
    } else {
      await _scheduleNotificationMobile(notification);
    }
  }

  /// Show a notification.
  ///
  /// This will only show a notification if notifications are enabled and
  /// permission has been granted.
  ///
  /// [id] is a unique identifier for the notification. If not specified, a
  /// random id will be generated. The id must fit within a 32-bit integer.
  Future<void> showNotification({
    int? id,
    required String title,
    required String body,
    String? payload,
  }) async {
    // log.v('Showing notification: $title, $body, $payload');

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

  /// Snooze a task's notification.
  Future<void> snoozeTask(Conversation task) async {
    // log.v('Snoozing notification for task: ${task.id}');
    await cancelNotification(task.id.codeUnitAt(0));
    // const snoozeDuration = Duration(minutes: 10);
    // final snoozeTime = DateTime.now().add(snoozeDuration);
    // final updatedTask = task.copyWith(dueDate: snoozeTime);
    // await scheduleNotification(updatedTask);
  }

  /// Check if the app was started from a notification.
  ///
  /// If so, emit state so we can navigate to the correct screen.
  Future<void> _checkAppStartup() async {
    // Currently only supported on Android.
    if (defaultTargetPlatform != TargetPlatform.android) return;

    final appLaunchDetails = await _notificationsPlugin //
        .getNotificationAppLaunchDetails();

    final notificationResponse = appLaunchDetails?.notificationResponse;

    if (appLaunchDetails == null ||
        !appLaunchDetails.didNotificationLaunchApp ||
        notificationResponse == null) {
      return;
    }

    // log.i('App started from notification');
  }

  /// Generate a random id for a notification.
  ///
  /// The id will fit within a 32-bit integer as required by the plugin.
  int _generateNotificationId() {
    return Random().nextInt(1 << 30);
  }

  /// Request permission to show notifications.
  Future<void> _requestPermission() async {
    // Currently only Android requires permission.
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    final androidPlugin = _notificationsPlugin //
        .resolvePlatformSpecificImplementation //
        <AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    final bool? permissionGranted = await androidPlugin.requestPermission();
    if (permissionGranted == null) return;

    if (permissionGranted) {
      // log.i('Notifications permission granted');
    } else {
      // log.i('Notifications permission denied');
    }
  }

  /// Schedule a notification on desktop.
  ///
  /// This will create a timer that will show the notification when the timer
  /// expires.
  Future<void> _scheduleNotificationDesktop(Notification notification) async {
    if (isWindows) {
      await _scheduleNotificationWindows(notification);
      return;
    }

    final task = Conversation.fromJson(jsonDecode(notification.payload!));

    // log.v('Scheduling notification for task: ${task.id}');

    final dueDate = task.createdAt;
    if (dueDate == null) {
      // log.v('Task has no due date. Not scheduling notification.');
      return;
    }

    // If the task is already overdue, show the notification immediately.
    if (DateTime.parse(dueDate).isBefore(DateTime.now())) {
      // log.v('Task is already overdue. Showing notification immediately.');
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
        // log.v('Showing scheduled notification for task: ${task.id}');
        await showNotification(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          payload: notification.payload,
        );
      },
    );

    _timers[task.id.toString()] = timer;
    // log.v('Scheduled notification for task: ${task.id}');
  }

  /// Schedule a notification on mobile.
  ///
  /// This will register a notification with the OS.
  Future<void> _scheduleNotificationMobile(Notification notification) async {
    final conversation =
        Conversation.fromJson(jsonDecode(notification.payload!));

    // // log.v('Scheduling notification for task: ${task.id}');

    // if (!state.enabled) {
    //   // log.v('Notifications are disabled. Not scheduling notification.');
    //   return;
    // }

    final createdAt = conversation.createdAt;
    if (createdAt == null) {
      // log.v('Task has no due date. Not scheduling notification.');
      return;
    }

    // If the task is already overdue, show the notification immediately.
    if (DateTime.parse(createdAt).isBefore(DateTime.now())) {
      // log.v('Task is already overdue. Showing notification immediately.');
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

  /// Schedule a notification with the host OS.
  ///
  /// [id] is a unique identifier for the notification. If not specified, a
  /// random id will be generated. The id must fit within a 32-bit integer.
  ///
  /// [scheduledDate] is the date and time the notification should be shown.
  ///
  /// [payload] is an optional string that will be passed to the app when the
  /// notification is tapped.
  Future<void> _scheduleNotificationWithSystem({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // log.v('Scheduling notification: $title');

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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  /// Schedule a notification on Windows.
  ///
  /// The `flutter_local_notifications` plugin does not support Windows yet.
  /// See: https://github.com/MaikuB/flutter_local_notifications/issues/746
  ///
  /// When the plugin is updated, this method should be removed and
  /// `_scheduleNotificationDesktop` should be used instead.
  Future<void> _scheduleNotificationWindows(Notification notification) async {
    final conversation =
        Conversation.fromJson(jsonDecode(notification.payload!));
    // log.v('Scheduling notification for task: ${task.id}');

    final createdAt = conversation.createdAt;

    if (createdAt == null) {
      // log.v('Task has no due date. Not scheduling notification.');
      return;
    }

    final localNotification = LocalNotification(
      identifier: conversation.id.toString(),
      title: conversation.body,
      body: conversation.body,
    );

    localNotification.onClick = () {
      _notificationCallback(NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        id: conversation.id.codeUnitAt(0),
        payload: jsonEncode(conversation.toJson()),
      ));
    };

    // If the task is already overdue, show the notification immediately.
    if (DateTime.parse(createdAt).isBefore(DateTime.now())) {
      // log.v('Task is already overdue. Showing notification immediately.');
      localNotification.show();
      return;
    }

    final timer = Timer(
      DateTime.parse(createdAt).difference(DateTime.now()),
      () async {
        // log.v('Showing scheduled notification for task: ${task.id}');
        localNotification.show();
      },
    );

    _timers[conversation.id.toString()] = timer;
    // log.v('Scheduled notification for task: ${task.id}');
  }

  /// Set the notification badges on Linux.
  Future<void> _setNotificationBadgeLinux(int count) async {
    await _setNotificationBadgeLinuxTaskbar(count);
    await _setNotificationBadgeLinuxSystemTray(count);
  }

  /// Set the notification badge on the Linux taskbar.
  Future<void> _setNotificationBadgeLinuxTaskbar(int count) async {
    /// Linux uses the Unity API to set the badge count.
    /// See: https://wiki.ubuntu.com/Unity/LauncherAPI
    final service = LauncherEntryService(
      appUri: 'application://$kPackageId.desktop',
    );
    await service.update(count: count, countVisible: true);
  }

  /// Set the notification badge on the Linux system tray.
  Future<void> _setNotificationBadgeLinuxSystemTray(int count) async {
    final icon = (count > 0)
        ? AppIcons.linuxSymbolicWithNotificationBadge
        : AppIcons.linuxSymbolic;

    await SystemTrayManager.instance.setIcon(icon);
  }

  /// Set the notification badge on Windows.
  Future<void> _setNotificationBadgeWindows(int count) async {
    await _setNotificationBadgeWindowsTaskbar(count);
    await _setNotificationBadgeWindowsSystemTray(count);
  }

  /// Set the notification badge on the Windows taskbar.
  Future<void> _setNotificationBadgeWindowsTaskbar(int count) async {
    final icon =
        (count > 0) ? AppIcons.windowsWithNotificationBadge : AppIcons.windows;

    // await TaskbarManager.instance.setIcon(icon);
    await windowManager.setIcon(icon);
  }

  /// Set the notification badge on the Windows system tray.
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
      if (isWindows || isLinux) {
        // On desktop, the app is already running so we can just show the window.
        await AppWindow.instance.show();
        await AppWindow.instance.focus();
      }

      notificationResponseStream.add(response);
      break;
    case NotificationResponseType.selectedNotificationAction:
      // response.actionId will be either `complete` or `snooze`.
      notificationResponseStream.add(response);
      break;
  }
}
