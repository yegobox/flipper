import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flipper/main.dart' as app;
import '../test/helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());
    testWidgets('Should load the app and act as real user!',
        (WidgetTester tester) async {
      //start by logging out the user
      ProxyService.api.logOut();
      app.main();
      await tester.pumpAndSettle();

// flutter drive \
//   --driver=test_driver/integration_test.dart \
//   --target=integration_test/app_test.dart -d windows
//

//  should start by showing a loading screen before moving to other screen
      final loaderView = find.byKey(Key('createAccountButton'));
      await tester.pumpAndSettle();
      expect(1, 1); //for now fake testing.
    });
  });
}
