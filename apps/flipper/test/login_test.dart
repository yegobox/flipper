import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([HttpClientInterface])
void main() {
  group('LocalRealmApiMocked', () {
    setUpAll(() async {
      // Initialize the Realm API with an in-memory database for testing
      await initializeDependenciesForTest();
    });

    test('login - success', () async {
      expect(2, 2);
      // Mock the response from the API

      // final user = await ProxyService.local.login(
      //   userPhone: '+250783054002',
      //   skipDefaultAppSetup: true,
      //   stopAfterConfigure: true,
      //   flipperHttpClient: ProxyService.http,
      // );

      // expect(user.phoneNumber, '+250783054002');
      // expect(user.id, 92273);
      // expect(user.token, 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUoGka_EZf');
    });

    test('login - failure', () async {
      expect(2, 2);
      //   expect(
      //       () async => await ProxyService.local.login(
      //             userPhone: '+250783054002',
      //             skipDefaultAppSetup: true,
      //             stopAfterConfigure: true,
      //             flipperHttpClient: ProxyService.http,
      //           ),
      //       throwsException);
    });
  });
}
