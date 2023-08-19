import 'package:sentry_flutter/sentry_flutter.dart';

abstract class SentryServiceInterface {
  Future<SentryId> debug({required String event});
}

class SentryServiceUnsported implements SentryServiceInterface {
  @override
  Future<SentryId> debug({required String event}) {
    // TODO: implement debug
    throw UnimplementedError();
  }
}

class SentryService implements SentryServiceInterface {
  @override
  Future<SentryId> debug({required String event}) async {
    // NewrelicMobile.instance.recordCustomEvent(event,
    //     eventName: event,
    //     eventAttributes: {"item1": "Clothes", "price": 34.00});
    return await Sentry.captureMessage(event, level: SentryLevel.debug);
  }
}
