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

      // Mock the stream from ProxyService.strategy.credit
      when(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .thenAnswer((_) => Stream.value(expectedCredit));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final creditStream = container.read(creditStreamProvider(testBranchId));

      // Expect the loading state first
      expect(creditStream.isLoading, true);

      // Wait for the first emission
      await container.pump(); // Advance time to allow stream to emit

      // Verify the emitted data
      expect(creditStream.value, expectedCredit);

      // Verify that the correct method was called on the mock
      verify(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .called(1);
    });

    test('should emit null if ProxyService.strategy.credit emits null',
        () async {
      final testBranchId = 1;

      // Mock the stream to emit null
      when(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .thenAnswer((_) => Stream.value(null));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final creditStream = container.read(creditStreamProvider(testBranchId));

      // Expect the loading state first
      expect(creditStream.isLoading, true);

      // Wait for the first emission
      await container.pump();

      // Verify the emitted data is null
      expect(creditStream.value, null);
    });

    test('should handle errors from ProxyService.strategy.credit', () async {
      final testBranchId = 1;
      final errorMessage = 'Failed to fetch credit';

      // Mock the stream to emit an error
      when(() => mockDbSync.credit(branchId: testBranchId.toString()))
          .thenAnswer((_) => Stream.error(Exception(errorMessage)));

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final creditStream = container.read(creditStreamProvider(testBranchId));

      // Expect the loading state first
      expect(creditStream.isLoading, true);

      // Wait for the error to be emitted
      await container.pump();

      // Verify that an error state is emitted
      expect(creditStream.hasError, true);
      expect(creditStream.error, isA<Exception>());
      expect(
          (creditStream.error as Exception).toString(), contains(errorMessage));
    });
  });
}
