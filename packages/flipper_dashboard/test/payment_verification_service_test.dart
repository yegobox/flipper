import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flipper_services/proxy.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

// flutter test test/payment_verification_service_test.dart  --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('PaymentVerificationService', () {
    late PaymentVerificationService service;
    late MockDatabaseSync mockDatabaseSync;
    late MockFlipperHttpClient mockHttpClient;
    late TestEnvironment env;

    setUpAll(() async {
      env = TestEnvironment();
      await env.init();

      mockDatabaseSync = env.mockDbSync;
      mockHttpClient = env.mockFlipperHttpClient;

      // Register fallback values for any() matchers
      registerFallbackValue(MockBusiness());
      registerFallbackValue(FakeHttpClient());
      registerFallbackValue(Uri());
    });

    setUp(() {
      // Create a fresh service instance for each test
      service = PaymentVerificationService();

      // Reset all mocks before each test
      reset(mockDatabaseSync);
      reset(mockHttpClient);

      // Override ProxyService with mocks
      ProxyService.http = mockHttpClient;
    });

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();
    });

    tearDown(() {
      service.dispose();
    });

    group('verifyPaymentStatus', () {
      test('returns error when no active business is found', () async {
        // Arrange
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => null);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(response.result, PaymentVerificationResult.error);
        expect(response.errorMessage, 'No active business found');
        expect(response.hasError, isTrue);
      });

      test('returns noPlan when getPaymentPlan returns null', () async {
        // Arrange
        final mockBusiness = MockBusiness();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => null);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(response.result, PaymentVerificationResult.noPlan);
        expect(
            response.errorMessage, 'No payment plan exists for this business');
        expect(response.requiresPaymentSetup, isTrue);

        // Verify the methods were called in the expected order
        verify(() => mockDatabaseSync.activeBusiness()).called(1);
        verify(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).called(1);

        // Verify hasActiveSubscription was never called since plan was null
        verifyNever(() => mockDatabaseSync.hasActiveSubscription(
              businessId: any(named: 'businessId'),
              flipperHttpClient: any(named: 'flipperHttpClient'),
              fetchRemote: any(named: 'fetchRemote'),
            ));
      });

      test('returns active when subscription is valid', () async {
        // Arrange
        final mockBusiness = MockBusiness();
        final mockPlan = MockPlan();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => mockPlan);
        when(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).thenAnswer((_) async => true);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(response.result, PaymentVerificationResult.active);
        expect(response.isActive, isTrue);
        expect(response.plan, mockPlan);

        // Verify all methods were called in the expected order
        verify(() => mockDatabaseSync.activeBusiness()).called(1);
        verify(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).called(1);
        verify(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).called(1);
      });

      test(
          'returns planExistsButInactive when hasActiveSubscription throws PaymentIncompleteException',
          () async {
        // Arrange
        final mockBusiness = MockBusiness();
        final mockPlan = MockPlan();
        final exception = PaymentIncompleteException('Payment failed');
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => mockPlan);
        when(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).thenThrow(exception);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(
            response.result, PaymentVerificationResult.planExistsButInactive);
        expect(response.requiresPaymentResolution, isTrue);
        expect(response.errorMessage, 'Payment incomplete: Payment failed');
        expect(response.plan, mockPlan);
        expect(response.exception, exception);

        // Verify all methods were called
        verify(() => mockDatabaseSync.activeBusiness()).called(1);
        verify(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).called(1);
        verify(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).called(1);
      });

      test(
          'returns planExistsButInactive when hasActiveSubscription throws other exception',
          () async {
        // Arrange
        final mockBusiness = MockBusiness();
        final mockPlan = MockPlan();
        final exception = Exception('Network error');
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => mockPlan);
        when(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).thenThrow(exception);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(
            response.result, PaymentVerificationResult.planExistsButInactive);
        expect(response.requiresPaymentResolution, isTrue);
        expect(response.errorMessage,
            'Error checking subscription status: Exception: Network error');
        expect(response.plan, mockPlan);
        expect(response.exception, isA<Exception>());
      });

      test('returns error on a generic exception from activeBusiness',
          () async {
        // Arrange
        final exception = Exception('Database connection failed');
        when(() => mockDatabaseSync.activeBusiness()).thenThrow(exception);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(response.result, PaymentVerificationResult.error);
        expect(response.hasError, isTrue);
        expect(response.errorMessage,
            'Failed to verify payment status: Exception: Database connection failed');
        expect(response.exception, isA<Exception>());
      });
    });

    group('Periodic Verification', () {
      test('starts and stops periodic verification correctly', () {
        fakeAsync((async) {
          // Arrange
          expect(service.isTimerActive, isFalse);

          // Act - Start periodic verification
          service.startPeriodicVerification(intervalMinutes: 1);

          // Assert - Timer should be active
          expect(service.isTimerActive, isTrue);

          // Act - Stop periodic verification
          service.stopPeriodicVerification();

          // Assert - Timer should be inactive
          expect(service.isTimerActive, isFalse);
        });
      });

      test('callback is invoked on periodic check', () {
        fakeAsync((async) {
          // Arrange
          PaymentVerificationResponse? capturedResponse;
          service.setPaymentStatusChangeCallback((response) {
            capturedResponse = response;
          });

          final mockBusiness = MockBusiness();
          when(() => mockBusiness.id).thenReturn('1');
          when(() => mockDatabaseSync.activeBusiness())
              .thenAnswer((_) async => mockBusiness);
          when(() => mockDatabaseSync.getPaymentPlan(
                businessId: '1',
                fetchOnline: true,
              )).thenAnswer((_) async => null);

          // Act - Start periodic verification with 1 minute interval
          service.startPeriodicVerification(intervalMinutes: 1);

          // Flush initial microtasks to ensure timer is set up
          async.flushMicrotasks();

          // Advance time by 1 minute to trigger the timer
          async.elapse(Duration(minutes: 1));

          // Flush microtasks to complete the async callback
          async.flushMicrotasks();

          // Assert
          expect(capturedResponse, isNotNull,
              reason: 'Callback should have been called after timer elapsed');
          expect(capturedResponse!.result, PaymentVerificationResult.noPlan);
          expect(capturedResponse!.errorMessage,
              'No payment plan exists for this business');

          // Cleanup
          service.stopPeriodicVerification();
          expect(service.isTimerActive, isFalse);
        });
      });

      test('periodic verification handles errors gracefully', () {
        fakeAsync((async) {
          // Arrange
          PaymentVerificationResponse? capturedResponse;
          service.setPaymentStatusChangeCallback((response) {
            capturedResponse = response;
          });

          // Mock an exception to be thrown
          when(() => mockDatabaseSync.activeBusiness())
              .thenThrow(Exception('Database error'));

          // Act
          service.startPeriodicVerification(intervalMinutes: 1);
          async.flushMicrotasks();
          async.elapse(Duration(minutes: 1));
          async.flushMicrotasks();

          // Assert
          expect(capturedResponse, isNotNull,
              reason: 'Callback should have been called even with errors');
          expect(capturedResponse!.result, PaymentVerificationResult.error);
          expect(capturedResponse!.hasError, isTrue);

          // Cleanup
          service.stopPeriodicVerification();
        });
      });
    });

    group('isPaymentRequired', () {
      test('returns true when status is not active (e.g., noPlan)', () async {
        // Arrange
        final mockBusiness = MockBusiness();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => null);

        // Act
        final result = await service.isPaymentRequired();

        // Assert
        expect(result, isTrue);
      });

      test(
          'returns true when status is not active (e.g., planExistsButInactive)',
          () async {
        // Arrange
        final mockBusiness = MockBusiness();
        final mockPlan = MockPlan();
        final exception = PaymentIncompleteException('Payment failed');
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => mockPlan);
        when(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).thenThrow(exception);

        // Act
        final result = await service.isPaymentRequired();

        // Assert
        expect(result, isTrue);
      });

      test('returns false when status is active', () async {
        // Arrange
        final mockBusiness = MockBusiness();
        final mockPlan = MockPlan();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => mockPlan);
        when(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).thenAnswer((_) async => true);

        // Act
        final result = await service.isPaymentRequired();

        // Assert
        expect(result, isFalse);
      });

      test('returns true when an error occurs', () async {
        // Arrange
        when(() => mockDatabaseSync.activeBusiness())
            .thenThrow(Exception('Database error'));

        // Act
        final result = await service.isPaymentRequired();

        // Assert
        expect(result, isTrue); // Payment required when we can't verify status
      });
    });

    group('forcePaymentVerification', () {
      test(
          'returns verification response and logs warning for non-active status',
          () async {
        // Arrange
        final mockBusiness = MockBusiness();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => null);

        // Act
        final response = await service.forcePaymentVerification();

        // Assert
        expect(response.result, PaymentVerificationResult.noPlan);
        expect(response.isActive, isFalse);
      });

      test('returns active response for valid subscription', () async {
        // Arrange
        final mockBusiness = MockBusiness();
        final mockPlan = MockPlan();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
              businessId: '1',
              fetchOnline: true,
            )).thenAnswer((_) async => mockPlan);
        when(() => mockDatabaseSync.hasActiveSubscription(
              businessId: '1',
              flipperHttpClient: mockHttpClient,
              fetchRemote: true,
            )).thenAnswer((_) async => true);

        // Act
        final response = await service.forcePaymentVerification();

        // Assert
        expect(response.result, PaymentVerificationResult.active);
        expect(response.isActive, isTrue);
        expect(response.plan, mockPlan);
      });
    });
  });
}
