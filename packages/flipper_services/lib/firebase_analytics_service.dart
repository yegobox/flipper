import 'package:flipper_services/abstractions/analytic.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';

class UnSupportedAnalyticPlatform implements Analytic {
  @override
  void addContext() {
    // TODO: implement addContext
  }

  @override
  void trackEvent(String eventName, Map<String, dynamic> parameters) {
    // TODO: implement trackEvent
  }
}

class FirebaseAnalyticsService with ListenableServiceMixin implements Analytic {
  @override
  void trackEvent(String eventName, Map<String, dynamic> parameters) {
    addContext();
    FirebaseAnalytics.instance
        .logEvent(name: eventName, parameters: parameters);
  }

  @override
  void addContext() {
    // Set the user ID
    FirebaseAnalytics.instance
        .setUserId(id: ProxyService.box.getUserId()!.toString());

    // Set the "user" user property to the user ID
    FirebaseAnalytics.instance.setUserProperty(
        name: "user", value: ProxyService.box.getUserId()!.toString());
  }
}
