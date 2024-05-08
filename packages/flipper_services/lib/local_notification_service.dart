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
  @override
  Future<void> sendLocalNotification(
      {required String body, String? userName = "Flipper"}) async {
    try {
      Conversation? conversation = Conversation(
        ObjectId(),
        body: body,
        phoneNumberId: randomNumber().toString().substring(0, 5),
        createdAt: DateTime.now().toIso8601String(),
        userName: userName,
        id: randomNumber(),
        businessId: ProxyService.box.getBusinessId(),
      );
      await NotificationsCubit.instance.scheduleNotification(conversation);
    } catch (e) {
      rethrow;
    }
  }
}
