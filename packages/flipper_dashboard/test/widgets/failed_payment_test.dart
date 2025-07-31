import 'package:flipper_dashboard/payment/FailedPayment.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/repository.dart';
import 'package:http/http.dart' as http;
import '../test_helpers/mocks.dart';
import '../test_helpers/setup.dart';

class MockPaymentVerificationService extends Mock
    implements PaymentVerificationService {}

class MockRepository extends Mock implements Repository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnvironment env;
  late MockPaymentVerificationService mockPaymentVerificationService;
  late MockRouterService mockRouterService;
  late MockRepository mockRepository;
  late PaymentVerificationService service;
  late MockDatabaseSync mockDatabaseSync;
  late MockFlipperHttpClient mockFlipperHttpClient;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();

    mockPaymentVerificationService = MockPaymentVerificationService();
    mockRouterService = MockRouterService();
    mockRepository = MockRepository();
    mockDatabaseSync = env.mockDbSync;
    mockFlipperHttpClient = env.mockFlipperHttpClient;

    registerFallbackValue(MockBusiness());
    registerFallbackValue(FakeHttpClient());
    registerFallbackValue(Uri());
    registerFallbackValue(MockPlan());
    registerFallbackValue(PaymentVerificationResponse(
      result: PaymentVerificationResult.active,
    ));
    registerFallbackValue(FlipperAppRoute());
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    service = PaymentVerificationService();

    reset(mockDatabaseSync);
    reset(mockFlipperHttpClient);
    reset(mockPaymentVerificationService);
    reset(mockRouterService);
    reset(mockRepository);

    ProxyService.http = mockFlipperHttpClient;
    env.stubCommonMethods();

    when(() => mockDatabaseSync.activeBusiness()).thenAnswer((_) async =>
        models.Business(id: '1', name: 'Test Business', serverId: 1));

    when(() => mockDatabaseSync.getPaymentPlan(
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

    when(() => ProxyService.box.readInt(key: any(named: 'key')))
        .thenReturn(null);
    when(() => ProxyService.box.defaultCurrency()).thenReturn('RWF');
  });

  tearDown(() {
    service.dispose();
  });

  Widget _wrapWithMaterialApp(Widget widget) {
    return MaterialApp(
      home: ScaffoldMessenger(
        child: widget,
      ),
    );
  }

  group('FailedPayment Widget Tests', () {
    testWidgets('renders loading state initially', (WidgetTester tester) async {
      when(() => env.mockDbSync.getPaymentPlan(
            businessId: any(named: 'businessId'),
            fetchOnline: any(named: 'fetchOnline'),
          )).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
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
      await tester.pumpAndSettle();
    });

    testWidgets('renders main content after loading',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

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
        find.descendant(
          of: find.byType(Container),
          matching: find.textContaining('Error loading plan details:'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'phone number input appears when "Use different phone number" is toggled',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNothing);

      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('MTN Phone Number'), findsOneWidget);
    });

    testWidgets('phone number input formats correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      // Ensure SwitchListTile is visible and tap it
      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify TextFormField is present
      final phoneNumberField = find.byType(TextFormField);
      expect(phoneNumberField, findsOneWidget);

      // Enter text
      await tester.enterText(phoneNumberField, '250781234567');
      await tester.pumpAndSettle();

      // Check the TextEditingController's text
      final textField = tester.widget<TextFormField>(phoneNumberField);
      expect(textField.controller?.text, '250 78 123 4567');
    });

    testWidgets('phone number input shows validation error for invalid number',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SwitchListTile), warnIfMissed: false);
      await tester.pumpAndSettle();

      final phoneNumberField = find.byType(TextFormField);
      expect(phoneNumberField, findsOneWidget);

      await tester.enterText(phoneNumberField, '123');
      await tester.pumpAndSettle();
      expect(find.text('Phone number must start with 250'), findsOneWidget);

      await tester.enterText(phoneNumberField, '250771234567');
      await tester.pumpAndSettle();
      expect(find.text('Invalid MTN number prefix (must start with 78 or 79)'),
          findsOneWidget);
    });

    testWidgets('tapping "Skip for Now" navigates to FlipperAppRoute',
        (WidgetTester tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Skip for Now'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip for Now'), warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(() =>
              mockRouterService.navigateTo(any(that: isA<FlipperAppRoute>())))
          .called(1);
    });

    testWidgets('tapping "Try Again" processes payment and shows loading',
        (WidgetTester tester) async {
      when(() => ProxyService.box.writeString(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => Future.value());
      when(() => ProxyService.box.defaultCurrency()).thenReturn('RWF');
      when(() => mockFlipperHttpClient.post(
                any(that: isA<Uri>()),
                body: any(named: 'body'),
              ))
          .thenAnswer((_) async => http.Response('{"status": "success"}', 200));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Try Again'));
      await tester.pump();
      await tester.tap(find.text('Try Again'), warnIfMissed: false);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Processing...'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 1));

      verify(() => mockFlipperHttpClient.post(
            any(that: isA<Uri>()),
            body: any(named: 'body'),
          )).called(1);
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
      when(() => mockFlipperHttpClient.post(
            any(that: isA<Uri>()),
            body: any(named: 'body'),
          )).thenThrow(Exception('Payment gateway error'));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Try Again'));
      await tester.pump();
      await tester.tap(find.text('Try Again'), warnIfMissed: false);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
          find.textContaining(
              'Payment failed: Exception: Payment gateway error'),
          findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Try Again'), findsOneWidget);
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
            paymentMethod: 'card',
          ));

      await tester.pumpWidget(_wrapWithMaterialApp(const FailedPayment()));
      await tester.pumpAndSettle();

      expect(find.text('Mobile Money Payment'), findsNothing);
      expect(find.byType(SwitchListTile), findsNothing);
      expect(find.byType(TextFormField), findsNothing);
    });
  });
}
