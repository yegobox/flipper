import 'package:newrelic_mobile/config.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';

class NewRelic {
  static Future<void> initialize() async {
    const appToken = "AAbbd887ce4300ef17e2e403be632d198c86f486a0-NRMA";
    Config config = Config(
        accessToken: appToken,
        analyticsEventEnabled: true,
        networkErrorRequestEnabled: true,
        networkRequestEnabled: true,
        crashReportingEnabled: true,
        interactionTracingEnabled: true,
        httpResponseBodyCaptureEnabled: true,
        loggingEnabled: true,
        webViewInstrumentation: true,
        printStatementAsEventsEnabled: true,
        httpInstrumentationEnabled: true);
    await NewrelicMobile.instance.startAgent(config);
  }
}
