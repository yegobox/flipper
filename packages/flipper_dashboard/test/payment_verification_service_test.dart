import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_async/fake_async.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

void main() {
  group('PaymentVerificationService', () {
    late PaymentVerificationService service;
    late MockDatabaseSync mockDatabaseSync;
    late MockFlipperHttpClient mockHttpClient;
    late TestEnvironment env;

    setUp(() async {
      env = TestEnvironment();
      await env.init();

      mockDatabaseSync = env.mockDbSync;
      mockHttpClient = env.mockFlipperHttpClient;

      service = PaymentVerificationService();

      // Register fallback values for any() matchers
      registerFallbackValue(MockBusiness());
      registerFallbackValue(Uri());
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
            businessId: '1', fetchOnline: true)).thenAnswer((_) async => null);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(response.result, PaymentVerificationResult.noPlan);
        expect(
            response.errorMessage, 'No payment plan exists for this business');
        expect(response.requiresPaymentSetup, isTrue);
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
            fetchOnline: true)).thenAnswer((_) async => mockPlan);
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
      });

      test(
          'returns planExistsButInactive when hasActiveSubscription throws an error',
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
            fetchOnline: true)).thenAnswer((_) async => mockPlan);
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
            'Payment plan exists but subscription is not active');
        expect(response.plan, mockPlan);
        expect(response.exception, exception);
      });

      test('returns error on a generic exception', () async {
        // Arrange
        final exception = Exception('Database connection failed');
        when(() => mockDatabaseSync.activeBusiness()).thenThrow(exception);

        // Act
        final response = await service.verifyPaymentStatus();

        // Assert
        expect(response.result, PaymentVerificationResult.error);
        expect(response.hasError, isTrue);
        expect(response.errorMessage,
            'Failed to verify payment status: ${exception.toString()}');
        expect(response.exception, isA<Exception>());
      });
    });

    group('Periodic Verification', () {
      test('starts and stops periodic verification correctly', () {
        fakeAsync((async) {
          // Arrange
          expect(service.isTimerActive, isFalse);

          // Act
          service.startPeriodicVerification(intervalMinutes: 1);

          // Assert
          expect(service.isTimerActive, isTrue);

          // Act
          service.stopPeriodicVerification();

          // Assert
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
              fetchOnline: true)).thenAnswer((_) async => null);

          // Act
          service.startPeriodicVerification(intervalMinutes: 1);

          // Elapse time to trigger the timer
          async.elapse(Duration(minutes: 1));

          // Assert
          expect(capturedResponse, isNotNull);
          expect(capturedResponse!.result, PaymentVerificationResult.noPlan);

          service.stopPeriodicVerification();
        });
      });
    });

    group('isPaymentRequired', () {
      test('returns true when status is not active', () async {
        // Arrange
        final mockBusiness = MockBusiness();
        when(() => mockBusiness.id).thenReturn('1');
        when(() => mockDatabaseSync.activeBusiness())
            .thenAnswer((_) async => mockBusiness);
        when(() => mockDatabaseSync.getPaymentPlan(
            businessId: '1', fetchOnline: true)).thenAnswer((_) async => null);

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
            fetchOnline: true)).thenAnswer((_) async => mockPlan);
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
    });
  });
}
