import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:newrelic_mobile/newrelic_mobile.dart';

abstract class SentryServiceInterface {
  Future<SentryId> debug();
}

class SentryServiceUnsported implements SentryServiceInterface {
  @override
  Future<SentryId> debug() {
    // TODO: implement debug
    throw UnimplementedError();
  }
}

class SentryService implements SentryServiceInterface {
  @override
  Future<SentryId> debug() async {
    NewrelicMobile.instance.recordCustomEvent("Major",
        eventName: "User Purchase",
        eventAttributes: {"item1": "Clothes", "price": 34.00});
    return await Sentry.captureMessage("event", level: SentryLevel.debug);
  }
}
