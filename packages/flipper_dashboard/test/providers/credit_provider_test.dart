import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/providers/credit_provider.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import '../test_helpers/setup.dart';
import '../test_helpers/mocks.dart';

/// flutter test test/providers/credit_provider_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;
  late MockBox mockBox;
  late MockDatabaseSync mockDbSync;
  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
    mockDbSync = env.mockDbSync;
    mockBox = env.mockBox;

    // Register fallback for Credit model
    registerFallbackValue(Credit(
      branchServerId: 1,
      id: 'fallback_credit',
      branchId: '1',
      credits: 0.0,
      businessId: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  });

  setUp(() {
    // Reset mocks before each test. These mocks are already initialized in setUpAll.
    reset(mockDbSync);
    reset(mockBox);

    // Ensure ProxyService uses these mocks for the current test.
    env.injectMocks();
    env.stubCommonMethods();

    // Default mock for getBranchId
    when(() => mockBox.getBranchId()).thenReturn(1);
  });

  group('creditStreamProvider', () {
    test('should emit credit data from ProxyService.strategy.credit', () async {
      final testBranchId = 1;
      final expectedCredit = Credit(
        branchServerId: 1,
        id: 'test_credit_id',
        branchId: testBranchId.toString(),
        credits: 100.0,
        businessId: 'test_business_id',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create a StreamController to control the stream emissions
      final controller = StreamController<Credit?>();
      when(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .thenAnswer((_) => controller.stream);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final emittedCredits = <Credit?>[];
      final sub = container.listen(
        creditStreamProvider(testBranchId),
        (previous, next) {
          emittedCredits.add(next.value);
        },
      );
      addTearDown(sub.close); // Close the subscription when the test ends

      // Emit the expected credit
      controller.add(expectedCredit);
      await container.pump(); // Process the stream emission

      // Verify the emitted data
      expect(emittedCredits, [expectedCredit]);

      // Verify that the correct method was called on the mock
      verify(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .called(1);

      await controller.close(); // Close the controller
    });

    test('should emit null if ProxyService.strategy.credit emits null',
        () async {
      final testBranchId = 1;

      final controller = StreamController<Credit?>();
      when(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .thenAnswer((_) => controller.stream);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final emittedCredits = <Credit?>[];
      final sub = container.listen(
        creditStreamProvider(testBranchId),
        (previous, next) {
          emittedCredits.add(next.value);
        },
      );
      addTearDown(sub.close);

      controller.add(null);
      await container.pump();

      expect(emittedCredits, [null]);

      await controller.close();
    });

    test('should handle errors from ProxyService.strategy.credit', () async {
      final testBranchId = 1;
      final errorMessage = 'Failed to fetch credit';

      final controller = StreamController<Credit?>();
      when(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .thenAnswer((_) => controller.stream);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      Object? capturedError;
      final sub = container.listen(
        creditStreamProvider(testBranchId),
        (previous, next) {
          if (next.hasError) {
            capturedError = next.error;
          }
        },
      );
      addTearDown(sub.close);

      controller.addError(Exception(errorMessage));
      await container.pump();

      expect(capturedError, isA<Exception>());
      expect((capturedError as Exception).toString(), contains(errorMessage));

      await controller.close();
    });
  });
}
