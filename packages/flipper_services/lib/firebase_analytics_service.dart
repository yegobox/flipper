import 'package:flipper_services/abstractions/analytic.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flipper_services/proxy.dart';

class UnSupportedAnalyticPlatform implements Analytic {
  @override
  void recordUser() {
    // TODO: implement recordUser
  }
}

class FirebaseAnalyticsService implements Analytic {
  @override
  void recordUser() {
    String? userId = ProxyService.box.read(key: 'userId');
    FirebaseAnalytics().setUserId(userId);
    FirebaseAnalytics().setUserProperty(name: "user", value: userId);
    FirebaseAnalytics().logEvent(
      name: 'user',
      parameters: <String, dynamic>{
        'UserUsingApp': userId,
      },
    );
  }
}
