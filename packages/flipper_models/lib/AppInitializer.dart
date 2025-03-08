import 'dart:developer';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

class AppInitializer {
  static void initialize() {
    // Logging for initialization
    log('Initialized core app', name: 'AppInitializer');

    // --- Core Services Initialization ---

    // 1. Connect to the event bus
    _connectEventBus();

    // 2. Initialize remote configuration
    _initializeRemoteConfig();

    // 3. Initialize review system
    _initializeReviewSystem();

    // 4. Schedule cron jobs
    _scheduleCronJobs();

    // 5. Update status color
    _updateStatusColor();

    // 6. Listen for notification taps (Foreground)
    _listenForNotificationTaps();

    // 7. Subscribe to events based on platform
    _subscribeToEvents();

    // 8. Initialize Firebase messaging
    _initializeFirebaseMessaging();

    // 9. Bootstrap force date entry data
    _bootstrapForceDateEntryData();
  }

  // --- Helper Methods ---

  static void _connectEventBus() {
    ProxyService.event.connect();
  }

  static void _initializeRemoteConfig() {
    ProxyService.remoteConfig.config();
    ProxyService.remoteConfig.setDefault();
    ProxyService.remoteConfig.fetch();
  }

  static void _initializeReviewSystem() {
    // Implement review system
    ProxyService.review.review();
  }

  static void _scheduleCronJobs() {
    // Schedule cron tasks
    ProxyService.cron.schedule();
  }

  static void _updateStatusColor() {
    ProxyService.status.updateStatusColor();
  }

  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  static void _listenForNotificationTaps() {
    final isTest = const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
    if (isTest) {
      return;
    }
    ProxyService.messaging.listenTapOnNotificationForeground();
  }

  static void _subscribeToEvents() {
    // Desktop or Web
    if (isDesktopOrWeb) {
      ProxyService.event.subscribeToLogoutEvent(
          channel: "${ProxyService.box.getUserId()}-logout");
    }

    // Mobile
    if (!isDesktopOrWeb) {
      ProxyService.event.subscribeToDeviceEvent(
          channel: ProxyService.box.getUserPhone()!.replaceAll("+", ""));
    }

    // Business-Specific
    if (ProxyService.box.getBusinessId() != null) {
      ProxyService.event.subscribeToMessages(
          channel: ProxyService.box.getBusinessId()!.toString());
    }
  }

  static void _initializeFirebaseMessaging() {
    ProxyService.messaging
        .initializeFirebaseMessagingAndSubscribeToBusinessNotifications();
  }

  static void _bootstrapForceDateEntryData() {
    ProxyService.forceDateEntry.dataBootstrapper();
  }
}
