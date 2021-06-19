import 'package:flipper_services/abstractions/analytic.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flipper_services/proxy.dart';

class UnSupportedAnalyticPlatform implements Analytic {
  @override
  void recordUser() {
    // TODO: implement recordUser
  }
}

class FirebaseAnalyticsService implements Analytic {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);
  @override
  void recordUser() {
    String? userId = ProxyService.box.read(key: 'userId');
    _analytics.setUserId(userId);
    _analytics.logEvent(
      name: 'user_logged_in',
      parameters: <String, dynamic>{
        'userId': userId,
        'loggedIn': true,
      },
    );
  }
}
