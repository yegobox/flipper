// Ensure these imports point to your actual interface definitions
// Assuming FlipperHttpClient is defined here
import 'package:http/http.dart' as http; // For http.Response

import 'package:flipper_login/pin_login.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';
// Remove this if not directly used or correctly aliased for LocalStorage:
// import 'package:supabase_models/brick/repository/storage.dart';

import 'TestApp.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

class MockPin extends Mock implements IPin {}

// flutter test test/pin_login_test.dart --dart-define=FLUTTER_TEST_ENV=true
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
      registerFallbackValue(Pin(
          id: "1",
          userId: 1,
          branchId: 1,
          businessId: 1,
          ownerName: 'test',
          phoneNumber: '1234567890'));
      registerFallbackValue(MockUser()); // Added this for `login` mock
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

      // IMPORTANT: Register mocks for the INTERFACES that ProxyService resolves to.

      // Register mockBox for BoxInterface (ProxyService.box)
      // Check your 'BoxInterface' definition and its path.
      if (GetIt.I.isRegistered<LocalStorage>()) {
        // THIS SHOULD BE BoxInterface, not LocalStorage
        GetIt.I.unregister<LocalStorage>();
      }
      GetIt.I.registerSingleton<LocalStorage>(mockBox); // Use BoxInterface

      // Register mockRouterService for RouterService
      if (GetIt.I.isRegistered<RouterService>()) {
        GetIt.I.unregister<RouterService>();
      }
      GetIt.I.registerSingleton<RouterService>(mockRouterService);

      // Reset mocks before each test to ensure a clean state
      reset(mockBox);
      reset(mockFlipperHttpClient);
      reset(mockDatabaseSync);
      reset(mockRouterService);

      // Common mock setups for mockBox
      when(() => mockBox.writeBool(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => mockBox.readBool(key: any(named: 'key'))).thenReturn(false);
      when(() => mockBox.readString(key: any(named: 'key'))).thenReturn(null);
      when(() => mockBox.readInt(key: any(named: 'key'))).thenReturn(null);
      when(() => mockBox.getBusinessId()).thenReturn(1);
      when(() => mockBox.getUserId()).thenReturn(1);
      when(() => mockBox.getDefaultApp()).thenReturn('POS');
      when(() => mockBox.bhfId()).thenAnswer((_) async => '00');
      when(() => mockBox.writeInt(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
          key: any(named: 'key'),
          value: any(named: 'value'))).thenAnswer((_) async {});

      // Fixed: Correctly mock FlipperHttpClient.get
      when(() => mockFlipperHttpClient.get(
                any(that: isA<Uri>()), // Match any Uri object
                headers: any(named: 'headers'), // Match any optional headers
              ))
          .thenAnswer((_) async => http.Response('{"status": "success"}', 200));
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
      expect(find.byKey(const Key('signInButtonText')), findsOneWidget);
    });

    testWidgets('PIN input and visibility toggle works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      final pinField = find.byType(TextFormField);
      expect(pinField, findsOneWidget);

      final textField =
          find.descendant(of: pinField, matching: find.byType(TextField));
      expect(textField, findsOneWidget);

      // Initially obscured
      expect(tester.widget<TextField>(textField).obscureText, isTrue);

      // Enter PIN
      await tester.enterText(pinField, '1234');
      expect(tester.widget<TextField>(textField).controller!.text, '1234');

      // Toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(tester.widget<TextField>(textField).obscureText, isFalse);

      // Toggle back
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(tester.widget<TextField>(textField).obscureText, isTrue);
    });

    testWidgets('Shows error for empty PIN', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      await tester.tap(find.byKey(const Key('signInButtonText')));
      await tester.pumpAndSettle();

      expect(find.text('PIN is required'), findsOneWidget);
      expect(find.text('Invalid PIN. Please try again.'),
          findsNothing); // Should not show generic error yet
    });

    testWidgets('Shows error for PIN less than 4 digits',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      await tester.enterText(find.byType(TextFormField), '123');
      await tester.tap(find.byKey(const Key('signInButtonText')));
      await tester.pumpAndSettle();

      expect(find.text('PIN must be at least 4 digits'), findsOneWidget);
    });

    // testWidgets('Successful login navigates to app',
    //     (WidgetTester tester) async {
    //   final mockPin = MockPin();
    //   when(() => mockPin.userId).thenReturn('1');
    //   when(() => mockPin.phoneNumber).thenReturn('1234567890');
    //   when(() => mockPin.branchId).thenReturn(1);
    //   when(() => mockPin.businessId).thenReturn(1);
    //   when(() => mockPin.ownerName).thenReturn('Test Owner');

    //   // Crucial: Ensure the mocked `getPin` is called with the arguments
    //   // that the PinLogin widget will actually pass.
    //   when(() => mockDatabaseSync.getPin(
    //         pinString: '1234', // The entered text
    //         flipperHttpClient:
    //             mockFlipperHttpClient, // The registered HTTP client
    //       )).thenAnswer((_) async => mockPin);

    //   // Mock getPinLocal to return null for no existing local PIN
    //   when(() => mockDatabaseSync.getPinLocal(userId: 1, alwaysHydrate: false))
    //       .thenAnswer((_) async => null);

    //   // Mock login method
    //   when(() => mockDatabaseSync.login(
    //         pin: any(named: 'pin'), // Use any() for the complex Pin object
    //         isInSignUpProgress: false,
    //         flipperHttpClient: mockFlipperHttpClient,
    //         skipDefaultAppSetup: false,
    //         userPhone: '1234567890',
    //       )).thenAnswer((_) async => MockUser()); // Return a MockUser

    //   // Mock completeLogin
    //   when(() => mockDatabaseSync.completeLogin(any(that: isA<Pin>())))
    //       .thenAnswer((_) async {});

    //   await tester.pumpWidget(
    //     TestApp(
    //       child: PinLogin(),
    //     ),
    //   );

    //   await tester.enterText(find.byType(TextFormField), '1234');
    //   await tester.tap(find.byKey(const Key('signInButtonText')));
    //   await tester.pumpAndSettle();

    //   // Verify the correct methods were called with expected arguments
    //   verify(() => mockBox.writeBool(key: 'pinLogin', value: true)).called(1);
    //   verify(() => mockDatabaseSync.getPin(
    //         pinString: '1234',
    //         flipperHttpClient: mockFlipperHttpClient,
    //       )).called(1);
    //   verify(() => mockBox.writeBool(key: 'isAnonymous', value: true))
    //       .called(1);
    //   verify(() => mockDatabaseSync.login(
    //         pin: any(named: 'pin'),
    //         isInSignUpProgress: false,
    //         flipperHttpClient: mockFlipperHttpClient,
    //         skipDefaultAppSetup: false,
    //         userPhone: '1234567890',
    //       )).called(1);
    //   verify(() => mockDatabaseSync.completeLogin(any(that: isA<Pin>())))
    //       .called(1);

    //   // Verify no error message is shown
    //   expect(find.text('Invalid PIN. Please try again.'), findsNothing);
    // });

    // testWidgets('Failed login shows error message and shakes',
    //     (WidgetTester tester) async {
    //   // Mock getPin to throw PinError for 'wrongpin'
    //   when(() => mockDatabaseSync.getPin(
    //         pinString: 'wrongpin',
    //         flipperHttpClient: mockFlipperHttpClient,
    //       )).thenThrow(PinError(term: "Invalid PIN"));

    //   // Mock handleLoginError to return a specific error message
    //   when(() => mockDatabaseSync.handleLoginError(
    //             any(), // The exception (PinError)
    //             any(that: isA<StackTrace>()), // The stack trace
    //           ))
    //       .thenAnswer(
    //           (_) async => {'errorMessage': 'Invalid PIN. Please try again.'});

    //   await tester.pumpWidget(
    //     TestApp(
    //       child: PinLogin(),
    //     ),
    //   );

    //   await tester.enterText(find.byType(TextFormField), 'wrongpin');
    //   await tester.tap(find.byKey(const Key('signInButtonText')));
    //   await tester.pumpAndSettle();

    //   expect(find.text('Invalid PIN. Please try again.'), findsOneWidget);
    //   // For shake animation, you might visually inspect or use a custom matcher
    //   // if you have a way to assert animation state. For simplicity, we rely
    //   // on the error message for this test.
    // });

    // testWidgets('Error message disappears on focus change',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(
    //     TestApp(
    //       child: PinLogin(),
    //     ),
    //   );

    //   await tester.enterText(find.byType(TextFormField), '123');
    //   await tester.tap(find.byKey(const Key('signInButtonText')));
    //   await tester.pumpAndSettle();

    //   expect(find.text('PIN must be at least 4 digits'), findsOneWidget);

    //   // Tap on the text field again to trigger focus change
    //   await tester.tap(find.byType(TextFormField));
    //   await tester.pumpAndSettle();

    //   expect(find.text('PIN must be at least 4 digits'), findsNothing);
    // });
    testWidgets('Successful MFA login flow', (WidgetTester tester) async {
      // Mock the requestOtp call
      when(() => mockDatabaseSync.requestOtp(any())).thenAnswer((_) async => {
            'success': true,
            'message': 'OTP sent to your phone',
            'phoneNumber': '250788123456',
            'requiresOtp': true,
          });

      // Mock the verifyOtpAndLogin call
      when(() => mockDatabaseSync.verifyOtpAndLogin(any(), pin: any(named: 'pin')))
          .thenAnswer((_) async => MockUser());

      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      // Enter PIN
      await tester.enterText(find.byType(TextFormField), '1234');
      await tester.tap(find.byKey(const Key('signInButtonText')));
      await tester.pumpAndSettle();

      // Verify that the OTP field is now visible
      expect(find.text('Enter your OTP'), findsOneWidget);

      // Enter OTP
      await tester.enterText(find.byKey(const Key('otpField')), '123456');
      await tester.tap(find.byKey(const Key('signInButtonText')));
      await tester.pumpAndSettle();

      // Verify that the login was successful
      verify(() => mockDatabaseSync.verifyOtpAndLogin('1234', pin: any()))
          .called(1);
    });
  });
}
