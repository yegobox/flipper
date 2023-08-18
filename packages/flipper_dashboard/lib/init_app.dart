import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

class InitApp {
  static void init() {
    ProxyService.event.connect();

    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();

    // Connect to any available printer
    // Implement review system.
    ProxyService.review.review();

    // Schedule the report
    ProxyService.cron.connectBlueToothPrinter();
    ProxyService.cron.deleteReceivedMessageFromServer();

    ProxyService.sync.pull();

    ProxyService.cron.schedule();

    ProxyService.status.updateStatusColor();

    ProxyService.event.connect();

    ProxyService.messaging.listenTapOnNotificationForeground();

    if (isDesktopOrWeb) {
      ProxyService.event.subscribeToLogoutEvent(
          channel: "${ProxyService.box.getUserId()}-logout");
    }

    if (ProxyService.box.getBusinessId() != null) {
      ProxyService.event.subscribeToMessages(
          channel: ProxyService.box.getBusinessId()!.toString());
    }

    if (!isDesktopOrWeb) {
      ProxyService.event.subscribeToDeviceEvent(channel: 'device');
    }

    ProxyService.messaging
        .initializeFirebaseMessagingAndSubscribeToBusinessNotifications();

    ProxyService.forceDateEntry.dataBootstrapper();
  }
}
