import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_login/pin_login.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'TestApp.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

// flutter test test/pin_login_test.dart --dart-define=FLUTTER_TEST_ENV=true
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
      registerFallbackValue(Uri.parse('http://localhost'));
      registerFallbackValue(Pin(
          id: "1",
          userId: 1,
          branchId: 1,
          businessId: 1,
          ownerName: 'test',
          phoneNumber: '1234567890'));
      registerFallbackValue(MockUser());
      registerFallbackValue(FakeHttpClient());
    });

    tearDownAll(() {
      env.restore();
    });

    setUp(() {
      env.injectMocks();
      mockBox = env.mockBox;
      mockFlipperHttpClient = env.mockFlipperHttpClient;
      mockDatabaseSync = MockDatabaseSync();
      mockRouterService = MockRouterService();

      // Register mocks with GetIt
      if (GetIt.I.isRegistered<LocalStorage>()) {
        GetIt.I.unregister<LocalStorage>();
      }
      GetIt.I.registerSingleton<LocalStorage>(mockBox);

      if (GetIt.I.isRegistered<RouterService>()) {
        GetIt.I.unregister<RouterService>();
      }
      GetIt.I.registerSingleton<RouterService>(mockRouterService);

      if (GetIt.I.isRegistered<DatabaseSyncInterface>()) {
        GetIt.I.unregister<DatabaseSyncInterface>();
      }
      GetIt.I.registerSingleton<DatabaseSyncInterface>(mockDatabaseSync);

      // Reset mocks
      reset(mockBox);
      reset(mockFlipperHttpClient);
      reset(mockDatabaseSync);
      reset(mockRouterService);

      // Common mock setups for mockBox
      when(() => mockBox.writeBool(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});
      when(() => mockBox.readBool(key: any(named: 'key'))).thenReturn(false);
      when(() => mockBox.readString(key: any(named: 'key'))).thenReturn(null);
      when(() => mockBox.readInt(key: any(named: 'key'))).thenReturn(null);
      when(() => mockBox.getBusinessId()).thenReturn(1);
      when(() => mockBox.getUserId()).thenReturn(1);
      when(() => mockBox.getDefaultApp()).thenReturn('POS');
      when(() => mockBox.bhfId()).thenAnswer((_) async => '00');
      when(() => mockBox.writeInt(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => 0);
      when(() => mockBox.writeString(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      // Mock HTTP client
      when(() => mockFlipperHttpClient.get(
                any(that: isA<Uri>()),
                headers: any(named: 'headers'),
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

      final pinField = find.byKey(const Key('pinField'));
      expect(pinField, findsOneWidget);

      final textField =
          find.descendant(of: pinField, matching: find.byType(TextField));
      expect(textField, findsOneWidget);

      expect(tester.widget<TextField>(textField).obscureText, isTrue);

      await tester.enterText(pinField, '1234');
      expect(tester.widget<TextField>(textField).controller!.text, '1234');

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(tester.widget<TextField>(textField).obscureText, isFalse);

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
      expect(find.text('Invalid PIN or OTP. Please try again.'), findsNothing);
    });

    testWidgets('Shows error for PIN less than 4 digits',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: PinLogin(),
        ),
      );

      await tester.enterText(find.byKey(const Key('pinField')), '123');
      await tester.tap(find.byKey(const Key('signInButtonText')));
      await tester.pumpAndSettle();

      expect(find.text('PIN must be at least 4 digits'), findsOneWidget);
    });
  });
}
