import 'package:flipper/routes.locator.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_test.dart';
import 'startup_viewmodel_test.mocks.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/abstractions/storage.dart';
// import 'package:flipper_services/proxy.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.

@GenerateMocks([Api, LocalStorage])
void main() {
  final model = StartUpViewModel();
  final client = MockApi();
  final box = MockLocalStorage();
  group('StartUpViewModel', () {
    setUpAll(() {
      setupLocator();
      locator.registerSingleton<LocalStorage>(box);
      locator.registerSingleton<Api>(client);
    });
    test('Given users have business should update didSync ==true..', () async {
      List<Business> c = [];
      c.add(businessMockData);
      when(client.businesses()).thenAnswer((_) async => c);
      when(box.read(key: 'userId')).thenAnswer((_) => 'true');

      model.isLoggedIn();

      model.notifyListeners();
      expect(await model.didWeSync(), true);
    });
    test('Given users does not have business should update didSync ==false..',
        () async {
      List<Business> c = [];
      when(client.businesses()).thenAnswer((_) async => c);
      when(box.read(key: 'userId')).thenAnswer((_) => 'false');

      model.isLoggedIn();

      model.notifyListeners();
      expect(await model.didWeSync(), false);
    });
  });
}
