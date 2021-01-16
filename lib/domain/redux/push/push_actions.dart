import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper_models/in_app_notification.dart';
import "package:redux/src/store.dart" show Store;

class UpdateUserTokenAction {
  final String token;

  UpdateUserTokenAction(this.token, Store<AppState> store);
}

class OnPushNotificationOpenAction {
  final Map<String, dynamic> message;

  OnPushNotificationOpenAction(this.message);
}

class OnPushNotificationReceivedAction {
  final Map<String, dynamic> message;

  OnPushNotificationReceivedAction(this.message);
}

class ShowPushNotificationAction {
  InAppNotification inAppNotification;

  ShowPushNotificationAction(this.inAppNotification);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowPushNotificationAction &&
          runtimeType == other.runtimeType &&
          inAppNotification == other.inAppNotification;

  @override
  int get hashCode => inAppNotification.hashCode;
}

class OnPushNotificationDismissedAction {}
