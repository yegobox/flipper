import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:realm/realm.dart';

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
  // Initialize the NotificationsCubit instance
  static NotificationsCubit? _notificationsCubit;

  LocalNotificationService() {
    // Initialize the NotificationsCubit in the constructor
    _initNotificationsCubit();
  }

  // Initialize the NotificationsCubit (ideally this should be done
  // in your main function or a global setup method)
  void _initNotificationsCubit() async {
    _notificationsCubit = await NotificationsCubit.initialize(
      flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
    );
  }

  @override
  Future<void> sendLocalNotification(
      {required String body, String? userName = "Flipper"}) async {
    try {
      Conversation? conversation = Conversation(
        ObjectId(),
        body: body,
        phoneNumberId: randomNumber().toString().substring(0, 5),
        createdAt: DateTime.now().add(Duration(seconds: 10)).toIso8601String(),
        userName: userName,
        id: randomNumber(),
        businessId: ProxyService.box.getBusinessId(),
      );

      // Now you can use _notificationsCubit safely
      await _notificationsCubit?.scheduleNotification(conversation);
    } catch (e) {
      rethrow;
    }
  }
}
