import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/notifications/cubit/notifications_cubit.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

abstract class LNotification {
  Future<void> sendLocalNotification({Conversation? payload});
}

class UnSupportedLocalNotification implements LNotification {
  @override
  Future<void> sendLocalNotification({Conversation? payload}) {
    throw UnimplementedError();
  }
}

class LocalNotificationService implements LNotification {
  @override
  Future<void> sendLocalNotification({Conversation? payload}) async {
    if (payload != null) {
      await ProxyService.realm.create(data: payload);
      print('Received a new message in payload: ${payload.body}');
      Conversation? localConversation = await ProxyService.realm
          .getConversation(messageId: payload.messageId!);
      if (localConversation == null) {
        await ProxyService.realm.create(data: payload);
      }
      await NotificationsCubit.instance.scheduleNotification(payload);
    }
  }
}
