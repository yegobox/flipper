import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flipper/main.dart' as app;

// flutter drive  --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d windows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('This use case assume the user has an account arleady!',
        (WidgetTester tester) async {
      //start by logging out the user
      app.main();
      await tester.pumpAndSettle();
      // await new Future.delayed(new Duration(milliseconds: 50));
      await tester.pump(new Duration(milliseconds: 50));

      ///logout the user
      ProxyService.api.logOut();
      await tester.pumpAndSettle();
      await tester.pump(new Duration(milliseconds: 5));

      /// end of logout.
      ///
      // final loaderScreen = find.byKey(Key('Loader'));
      // await tester.pumpAndSettle();
      // expect(loaderScreen, findsOneWidget);

      final signupButton = find.byKey(Key('createAccountButton'));
      await tester.pumpAndSettle();
      expect(signupButton, findsOneWidget);

      await tester.tap(signupButton);

      // show login modal
      final loginForm = find.byKey(Key('loginForm'));
      await tester.pumpAndSettle();
      expect(loginForm, findsOneWidget);

      /// fill in the login form.
      /// the testing number is 783054874
      final phoneNumber = '783054874';
      await tester.enterText(find.byKey(Key('phoneField')), phoneNumber);

      // Tap on a Sign in button
      await tester.tap(find.byKey(Key('signIn')));
      await tester.pumpAndSettle();

      /// after clicking on the sign in button should see the busy button waiting for otp
      final optForm = find.byKey(Key('optForm'));
      await tester.pumpAndSettle();
      expect(optForm, findsOneWidget);

      ///
      ///
      final otpField = '123456';
      await tester.enterText(find.byKey(Key('otpField')), otpField);

      ///
      ///
      await tester.tap(find.byKey(Key('verifyOtp')));

      ///
      ///
      final businessHomeView = find.byKey(Key('businessHomeView'));
      await tester.pumpAndSettle();
      expect(businessHomeView, findsOneWidget);
      await tester.pumpAndSettle();

      ///alwas end test with logging out
      ///logout the user
      ProxyService.api.logOut();
      // TODOtype the should see they keypad
    });
  });
}
