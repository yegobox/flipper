library flipper_models;

import 'package:built_value/built_value.dart';

part 'in_app_notification.g.dart';

abstract class InAppNotification
    implements Built<InAppNotification, InAppNotificationBuilder> {
  String get message;

  InAppNotification._();
  factory InAppNotification([void Function(InAppNotificationBuilder) updates]) =
      _$InAppNotification;
}
