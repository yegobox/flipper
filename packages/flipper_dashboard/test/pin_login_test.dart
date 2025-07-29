import 'package:flipper_login/pin_login.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';

import 'TestApp.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

class MockPin extends Mock implements IPin {}

void main() {
  group('PinLogin', () {
    late TestEnvironment env;
    late MockBox mockBox;
    late MockFlipperHttpClient mockFlipperHttpClient;
    late MockDatabaseSync mockDatabaseSync;
    late MockRouterService mockRouterService;

    setUpAll(() async {
      env = TestEnvironment();
      await env.init();
      registerFallbackValue(MockPin());
      registerFallbackValue(StackTrace.current);
      registerFallbackValue(DialogRequest());
      registerFallbackValue(DialogResponse());
      registerFallbackValue(Uri.parse('http://localhost'));
    });

    tearDownAll(() {
      env.restore();
    });

    setUp(() {
      env.injectMocks();
      mockBox = env.mockBox;
      mockFlipperHttpClient = env.mockFlipperHttpClient;
      mockDatabaseSync = env.mockDbSync;
      mockRouterService = MockRouterService();

      if (GetIt.I.isRegistered<RouterService>()) {
        GetIt.I.unregister<RouterService>();
      }
      GetIt.I.registerSingleton<RouterService>(mockRouterService);

      reset(mockBox);
      reset(mockFlipperHttpClient);
      reset(mockDatabaseSync);
      reset(mockRouterService);

      when(() => mockBox.writeBool(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      when(() => mockBox.readBool(key: any(named: 'key'))).thenReturn(false);
      when(() => mockBox.readString(key: any(named: 'key'))).thenReturn(null);
      when(() => mockBox.readInt(key: any(named: 'key'))).thenReturn(null);
      when(() => mockBox.getBusinessId()).thenReturn(1);
      when(() => mockBox.getUserId()).thenReturn(1);
      when(() => mockBox.getDefaultApp()).thenReturn('POS');
      when(() => mockBox.bhfId()).thenAnswer((_) async => '00');
      when(() => mockBox.writeInt(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => 0);
      when(() => mockBox.writeString(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
    });

    testWidgets('PinLogin renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
         TestApp(
          child: PinLogin(),
        ),
      );

      expect(find.byKey(const Key('PinLogin')), findsOneWidget);
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('Enter your PIN'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('PIN input and visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      final pinField = find.byType(TextFormField);
      expect(pinField, findsOneWidget);

      // Initially obscured
      expect(tester.widget<TextFormField>(pinField).obscureText, isTrue);

      // Enter PIN
      await tester.enterText(pinField, '1234');
      expect(tester.widget<TextFormField>(pinField).controller!.text, '1234');

      // Toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(tester.widget<TextFormField>(pinField).obscureText, isFalse);

      // Toggle back
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(tester.widget<TextFormField>(pinField).obscureText, isTrue);
    });

    testWidgets('Shows error for empty PIN', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('PIN is required'), findsOneWidget);
      expect(find.text('Invalid PIN. Please try again.'), findsNothing); // Should not show generic error yet
    });

    testWidgets('Shows error for PIN less than 4 digits', (WidgetTester tester) async {
      await tester.pumpWidget(
        const TestApp(
          child: PinLogin(),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('PIN must be at least 4 digits'), findsOneWidget);
    });

    testWidgets('Successful login navigates to app', (WidgetTester tester) async {
      final mockPin = MockPin();
      when(() => mockPin.userId).thenReturn('1');
      when(() => mockPin.phoneNumber).thenReturn('1234567890');
      when(() => mockPin.branchId).thenReturn(1);
      when(() => mockPin.businessId).thenReturn(1);
      when(() => mockPin.ownerName).thenReturn('Test Owner');

      when(() => mockDatabaseSync.getPin(
            pinString: '1234',
            flipperHttpClient: mockFlipperHttpClient,
          )).thenAnswer((_) async => mockPin);

      when(() => mockDatabaseSync.getPinLocal(userId: 1, alwaysHydrate: false))
          .thenAnswer((_) async => null); // No existing local PIN

      when(() => mockDatabaseSync.login(
            pin: any(named: 'pin'),
            isInSignUpProgress: false,
            flipperHttpClient: mockFlipperHttpClient,
            skipDefaultAppSetup: false,
            userPhone: '1234567890',
          )).thenAnswer((_) async {});

      when(() => mockDatabaseSync.completeLogin(any(that: isA<Pin>())))
          .thenAnswer((_) async {});

      await tester.pumpWidget(
         TestApp(
          child: PinLogin(),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '1234');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      verify(() => mockBox.writeBool(key: 'pinLogin', value: true)).called(1);
      verify(() => mockDatabaseSync.getPin(
            pinString: '1234',
            flipperHttpClient: mockFlipperHttpClient,
          )).called(1);
      verify(() => mockBox.writeBool(key: 'isAnonymous', value: true)).called(1);
      verify(() => mockDatabaseSync.login(
            pin: any(named: 'pin'),
            isInSignUpProgress: false,
            flipperHttpClient: mockFlipperHttpClient,
            skipDefaultAppSetup: false,
            userPhone: '1234567890',
          )).called(1);
      verify(() => mockDatabaseSync.completeLogin(any(that: isA<Pin>()))).called(1);

      // Verify no error message is shown
      expect(find.text('Invalid PIN. Please try again.'), findsNothing);
    });

    testWidgets('Failed login shows error message and shakes', (WidgetTester tester) async {
      when(() => mockDatabaseSync.getPin(
            pinString: 'wrongpin',
            flipperHttpClient: mockFlipperHttpClient,
          )).thenThrow(PinError(term: "Invalid PIN"));

      when(() => mockDatabaseSync.handleLoginError(any(), any()))
          .thenAnswer((_) async => {'errorMessage': 'Invalid PIN. Please try again.'});

      await tester.pumpWidget(
         TestApp(
          child: PinLogin(),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'wrongpin');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid PIN. Please try again.'), findsOneWidget);
      // Verify shake animation (difficult to test directly, but we can check for its side effects or mock it)
      // For now, we'll rely on the error message being present.
    });

    testWidgets('Error message disappears on focus change', (WidgetTester tester) async {
      await tester.pumpWidget(
         TestApp(
          child: PinLogin(),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '123');
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('PIN must be at least 4 digits'), findsOneWidget);

      // Tap on the text field again to trigger focus change
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      expect(find.text('PIN must be at least 4 digits'), findsNothing);
    });
  });
}
