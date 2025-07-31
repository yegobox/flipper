import 'package:flipper_dashboard/payment/FailedPayment.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:http/http.dart' as http;
import '../test_helpers/mocks.dart';
import '../test_helpers/setup.dart';

/// flutter test test/widgets/failed_payment_test.dart --dart-define=FLUTTER_TEST_ENV=true
class MockPaymentVerificationService extends Mock
    implements PaymentVerificationService {}

class MockRepository extends Mock implements Repository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnvironment env;
  late MockPaymentVerificationService mockPaymentVerificationService;
  late MockRouterService mockRouterService;
  late MockRepository mockRepository;
  late PaymentVerificationService service; // Added
  late MockDatabaseSync mockDatabaseSync; // Added
  late MockFlipperHttpClient mockFlipperHttpClient; // Added

  setUpAll(() async {
    // Changed to async
    env = TestEnvironment();
    await env.init(); // Added await

    mockPaymentVerificationService = MockPaymentVerificationService();
    mockRouterService = MockRouterService();
    mockRepository = MockRepository();
    mockDatabaseSync = env.mockDbSync; // Added
    mockFlipperHttpClient = env.mockFlipperHttpClient; // Added

    // Register fallbacks for mocktail
    registerFallbackValue(MockBusiness());
    registerFallbackValue(FakeHttpClient()); // Moved up
    registerFallbackValue(Uri()); // Moved up
    registerFallbackValue(MockPlan());
    registerFallbackValue(PaymentVerificationResponse(
      result: PaymentVerificationResult.active,
      // isActive: true,
    ));
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    // Create a fresh service instance for each test
    service = PaymentVerificationService(); // Added

    // Reset all mocks before each test
    reset(mockDatabaseSync); // Changed from env.mockDbSync
    reset(mockFlipperHttpClient); // Changed from env.mockFlipperHttpClient
    reset(mockPaymentVerificationService);
    reset(mockRouterService);
    reset(mockRepository);

    // Override ProxyService with mocks
    ProxyService.http = mockFlipperHttpClient; // Added

    // Stub common methods
    env.stubCommonMethods();

    // Default mock for activeBusiness
    when(() => mockDatabaseSync.activeBusiness()) // Changed from env.mockDbSync
        .thenAnswer((_) async =>
            models.Business(id: '1', name: 'Test Business', serverId: 1));

    // Default mock for getPaymentPlan
    when(() => mockDatabaseSync.getPaymentPlan(
          // Changed from env.mockDbSync
          businessId: any(named: 'businessId'),
          fetchOnline: any(named: 'fetchOnline'),
        )).thenAnswer((_) async => models.Plan(
          id: 'plan1',
          selectedPlan: 'Monthly',
          totalPrice: 1000,
          isYearlyPlan: false,
          paymentMethod: 'mobile_money',
        ));

    // Default mock for subscribeToRealtime
    when(() => mockRepository.subscribeToRealtime<models.Plan>(
          query: any(named: 'query'),
        )).thenAnswer((_) => Stream.fromIterable([
          [
            models.Plan(
              id: 'plan1',
              selectedPlan: 'Monthly',
              totalPrice: 1000,
              isYearlyPlan: false,
              paymentMethod: 'mobile_money',
            )
          ]
        ]));

    // Default mock for box.read
    when(() => ProxyService.box.readInt(key: any(named: 'key')))
        .thenReturn(null); // No custom phone number by default
    when(() => ProxyService.box.defaultCurrency()).thenReturn('RWF');
  });

  tearDown(() {
    service.dispose(); // Added
  });

  Widget _wrapWithMaterialApp(Widget widget) {
    return MaterialApp(
      home: widget,
    );
  }

  group('FailedPayment Widget Tests', () {
    testWidgets('renders loading state initially', (WidgetTester tester) async {
      when(() => env.mockDbSync.getPaymentPlan(
            businessId: any(named: 'businessId'),
            fetchOnline: any(named: 'fetchOnline'),
          )).thenAnswer((_) async {
        // Simulate a delay to keep loading state visible
        await Future.delayed(const Duration(seconds: 2));
        return models.Plan(
          id: 'plan1',
          selectedPlan: 'Monthly',
          totalPrice: 1000,
          isYearlyPlan: false,
          paymentMethod: 'mobile_money',
        );
      });

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading payment details...'), findsOneWidget);
      await tester.pumpAndSettle(); // Ensure all pending timers complete
    });

    testWidgets('renders main content after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle(); // Wait for initial data loading

      expect(find.text('Payment Issue'), findsOneWidget);
      expect(find.text('Payment Needs Attention'), findsOneWidget);
      expect(find.text('Mobile Money Payment'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Skip for Now'), findsOneWidget);
    });

    testWidgets('displays error message when plan loading fails',
        (WidgetTester tester) async {
      when(() => env.mockDbSync.getPaymentPlan(
            businessId: any(named: 'businessId'),
            fetchOnline: any(named: 'fetchOnline'),
          )).thenThrow(Exception('Failed to fetch plan'));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Error loading plan details:'), findsNWidgets(2));
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Failed to fetch plan'), findsOneWidget);
    });

    testWidgets(
        'phone number input appears when "Use different phone number" is toggled',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNothing); // Initially hidden

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('MTN Phone Number'), findsOneWidget);
    });

    testWidgets('phone number input formats correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final phoneNumberField = find.byType(TextFormField);
      await tester.enterText(phoneNumberField, '250781234567');
      await tester.pumpAndSettle();

      expect(find.text('250 78 123 4567'), findsOneWidget);
    });

    testWidgets('phone number input shows validation error for invalid number',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final phoneNumberField = find.byType(TextFormField);
      await tester.enterText(phoneNumberField, '123'); // Invalid prefix
      await tester.pumpAndSettle();

      expect(find.text('Phone number must start with 250'), findsOneWidget);

      await tester.enterText(
          phoneNumberField, '250771234567'); // Invalid MTN prefix
      await tester.pumpAndSettle();

      expect(find.text('Invalid MTN number prefix (must start with 78 or 79)'),
          findsOneWidget);
    });

    testWidgets('tapping "Skip for Now" navigates to FlipperAppRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip for Now'));
      await tester.pumpAndSettle();

      verify(() =>
              mockRouterService.navigateTo(any(that: isA<FlipperAppRoute>())))
          .called(1);
    });

    testWidgets('tapping "Try Again" processes payment and shows loading',
        (WidgetTester tester) async {
      // Mock the payment handler methods
      when(() => ProxyService.box.writeString(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => Future.value());
      when(() => ProxyService.box.defaultCurrency()).thenReturn('RWF');

      // Mock the handleMomoPayment method
      when(() => mockFlipperHttpClient.post(
                any(that: isA<Uri>()), // Positional argument for Uri
                body: any(named: 'body'),
              ))
          .thenAnswer((_) async => http.Response('{"status": "success"}', 200));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      // Tap "Try Again" button
      await tester.tap(find.text('Try Again'));
      await tester.pump(); // Pump to show loading indicator

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing...'), findsOneWidget);

      // Simulate payment success
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify that handleMomoPayment was called
      // Verify that handleMomoPayment was called
      verify(() => mockFlipperHttpClient.post(
            any(that: isA<Uri>()),
            body: any(named: 'body'),
          )).called(1);

      // Verify navigation to FlipperAppRoute on success
      verify(() =>
              mockRouterService.navigateTo(any(that: isA<FlipperAppRoute>())))
          .called(1);
    });

    testWidgets('tapping "Try Again" shows error snackbar on payment failure',
        (WidgetTester tester) async {
      when(() => env.mockDbSync.activeBusiness()).thenAnswer((_) async =>
          models.Business(id: '1', name: 'Test Business', serverId: 1));
      when(() => env.mockDbSync.getPaymentPlan(
            businessId: any(named: 'businessId'),
            fetchOnline: any(named: 'fetchOnline'),
          )).thenAnswer((_) async => models.Plan(
            id: 'plan1',
            selectedPlan: 'Monthly',
            totalPrice: 1000,
            isYearlyPlan: false,
            paymentMethod: 'mobile_money',
          ));
      when(() => mockRepository.subscribeToRealtime<models.Plan>(
            query: any(named: 'query'),
          )).thenAnswer((_) => Stream.fromIterable([
            [
              models.Plan(
                id: 'plan1',
                selectedPlan: 'Monthly',
                totalPrice: 1000,
                isYearlyPlan: false,
                paymentMethod: 'mobile_money',
              )
            ]
          ]));

      // Mock payment failure
      when(() => mockFlipperHttpClient.post(
            any(that: isA<Uri>()),
            body: any(named: 'body'),
          )).thenThrow(Exception('Payment gateway error'));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Try Again'));
      await tester.pump(); // Pump to show loading indicator
      await tester
          .pumpAndSettle(); // Wait for error to propagate and snackbar to appear

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
          find.textContaining(
              'Payment failed: Exception: Payment gateway error'),
          findsOneWidget);
      expect(find.byType(CircularProgressIndicator),
          findsNothing); // Loading should be gone
      expect(find.text('Try Again'),
          findsOneWidget); // Button should be re-enabled
    });

    testWidgets('payment method "card" hides phone number section',
        (WidgetTester tester) async {
      when(() => env.mockDbSync.getPaymentPlan(
            businessId: any(named: 'businessId'),
            fetchOnline: any(named: 'fetchOnline'),
          )).thenAnswer((_) async => models.Plan(
            id: 'plan1',
            selectedPlan: 'Monthly',
            totalPrice: 1000,
            isYearlyPlan: false,
            paymentMethod: 'card', // Set payment method to card
          ));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      expect(find.text('Mobile Money Payment'), findsNothing);
      expect(find.byType(SwitchListTile), findsNothing);
      expect(find.byType(TextFormField), findsNothing);
    });
  });
}
