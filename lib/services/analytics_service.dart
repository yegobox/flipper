import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver()=> FirebaseAnalyticsObserver(analytics:_analytics);

// User property tell us what the user is and what is doing so we know features are used by who.
  Future setUserProperties({@required String userId, String userRole})async{
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(name:'user_role',value: userRole);
  }
}