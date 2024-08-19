// import 'package:flipper_rw/newRelic.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:newrelic_mobile/config.dart';
// import 'package:newrelic_mobile/newrelic_mobile.dart';

// // Mock classes
// class MockNewrelicMobile extends Mock implements NewrelicMobile {}

// class MockConfig extends Mock implements Config {} // Add mock for Config

// void main() {
//   group('NewRelic', () {
//     late MockNewrelicMobile mockNewrelicMobile;
//     late MockConfig mockConfig; // Add mock for Config

//     setUp(() {
//       mockNewrelicMobile = MockNewrelicMobile();
//       mockConfig = MockConfig();

//       // Stub the NewrelicMobile.instance to return the mock
//       when(NewrelicMobile.instance).thenReturn(mockNewrelicMobile);

//       // **Stub the startAgent method**
//       when(mockNewrelicMobile.startAgent(mockConfig))
//           .thenAnswer((_) async => {});
//     });

//     test('should initialize New Relic with correct config', () async {
//       // Act
//       expect(1, 1);
//       // await NewRelic.initialize();

//       // // Verify startAgent was called with the expected Config
//       // verify(mockNewrelicMobile.startAgent(mockConfig)).called(1);

//       // // Assertions on the Config
//       // // These assertions depend on how the actual Config is implemented
//       // verify(mockConfig.accessToken).called(1);
//       // expect(mockConfig.accessToken, "wwe-NRMA");
//       // expect(mockConfig.analyticsEventEnabled, true);
//       // expect(mockConfig.networkErrorRequestEnabled, true);
//       // expect(mockConfig.networkRequestEnabled, true);
//       // expect(mockConfig.crashReportingEnabled, true);
//       // expect(mockConfig.interactionTracingEnabled, true);
//       // expect(mockConfig.httpResponseBodyCaptureEnabled, true);
//       // expect(mockConfig.loggingEnabled, true);
//       // expect(mockConfig.webViewInstrumentation, true);
//       // expect(mockConfig.printStatementAsEventsEnabled, true);
//       // expect(mockConfig.httpInstrumentationEnabled, true);
//     });
//   });
// }
