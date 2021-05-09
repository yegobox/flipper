import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flipper/main.dart' as app;
// flutter drive \
//   --driver=test_driver/integration_test.dart \
//   --target=integration_test/app_test.dart -d windows
//

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Should load the app and act as real user!',
        (WidgetTester tester) async {
      //start by logging out the user
      app.main();
      await tester.pumpAndSettle();

      // final loaderScreen = find.byKey(Key('Loader'));
      // await tester.pumpAndSettle();
      // expect(loaderScreen, findsOneWidget);
      final loaderView = find.byKey(Key('createAccountButton'));
      await tester.pumpAndSettle();
      expect(loaderView, findsOneWidget);

      //when login or register should show a model.
      await tester.tap(find.byKey(Key('createAccountButton')));
      await tester.pumpAndSettle();
      // expect(find.text('Welcome To'), findsOneWidget);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is RichText &&
              widget.text.toPlainText().startsWith('Welcome To')),
          findsOneWidget);
      // now fill the form with a number and tap expect to go to otp
    });
  });
}
