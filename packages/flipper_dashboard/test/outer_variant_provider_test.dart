import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart'; // Make sure this is correctly imported
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/cache/cache_export.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

// Mocks
class MockCacheManager extends Mock implements CacheManager {}

// A listener for observing provider state changes.
class ProviderListener<T> {
  final List<T> values = [];
  void call(T? previous, T next) {
    values.add(next);
  }
}

void main() {
  // Declare mock objects.
  late MockBox mockBox;
  late MockDatabaseSync mockDbSync;
  late MockCacheManager mockCacheManager;
  late TestEnvironment env;

  // Sample data for testing.
  final variant1 = Variant(id: '1', name: 'Apple', branchId: 1, taxTyCd: 'B');
  final variant2 = Variant(id: '2', name: 'Banana', branchId: 1, taxTyCd: 'B');
  final variant3 =
      Variant(id: '3', name: 'Apple Juice', branchId: 1, taxTyCd: 'C');
  final remoteVariant =
      Variant(id: '4', name: 'Remote Apple', branchId: 1, taxTyCd: 'A');

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() {
    env.restore();
  });

  setUp(() {
    env.injectMocks();
    mockBox = env.mockBox;
    mockDbSync = env.mockDbSync;
    mockCacheManager = MockCacheManager();

    // Register mocks that are not part of the environment's GetIt setup
    if (!GetIt.I.isRegistered<CacheManager>()) {
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
    } else {
      // If already registered, make sure to reset it for each test
      GetIt.I.unregister<CacheManager>();
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
    }

    // Set up default behaviors for mocks.
    when(() => mockBox.itemPerPage())
        .thenReturn(10); // Use a smaller number for pagination tests
    when(() => mockBox.vatEnabled()).thenReturn(true);
    when(() => mockCacheManager.initialize()).thenAnswer((_) async => true);
    when(() => mockCacheManager.saveStocksForVariants(any()))
        .thenAnswer((_) async {});

    // Default behavior for variant fetching.
    when(() => mockDbSync.variants(
          branchId: any(named: 'branchId'),
          name: any(named: 'name'),
          fetchRemote: any(named: 'fetchRemote'),
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          taxTyCds: any(named: 'taxTyCds'),
        )).thenAnswer((_) async => []); // Default to empty list
  });

  // Helper to create a ProviderContainer with overrides.
  ProviderContainer createContainer({
    List<Override> overrides = const [],
  }) {
    final container = ProviderContainer(overrides: overrides);
    addTearDown(container.dispose);
    return container;
  }

  group('OuterVariants Provider', () {
    test('initial build loads first page of variants from local strategy',
        () async {
      // Arrange
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage:
                10, // Must match what OuterVariants uses for initial load
            taxTyCds: ['A', 'B', 'C'],
            name: '', // Initial search string is empty
          )).thenAnswer((_) async => [variant1, variant2]);

      final container = createContainer();
      final listener = ProviderListener<AsyncValue<List<Variant>>>();

      // Act
      container.listen(
        outerVariantsProvider(1),
        listener,
        fireImmediately: true,
      );

      // Wait for the future to complete and the state to settle.
      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant1, variant2]);
      verify(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: '',
          )).called(1);
    });

    test('loadMore fetches the next page and appends variants', () async {
      // Arrange
      // For this specific test, let's make itemsPerPage = 1, so _hasMore remains true after fetching 1 item.
      when(() => mockBox.itemPerPage())
          .thenReturn(1); // <--- IMPORTANT CHANGE HERE

      // Mock initial load for page 0
      when(() => mockDbSync.variants(
                branchId: 1,
                fetchRemote: false,
                page: 0,
                itemsPerPage: 1, // Must match the mocked itemPerPage
                taxTyCds: ['A', 'B', 'C'],
                name: '',
              ))
          .thenAnswer(
              (_) async => [variant1]); // Returns one variant for page 0

      // Mock the next page load for page 1
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 1,
            itemsPerPage: 1, // Must match the mocked itemPerPage
            taxTyCds: ['A', 'B', 'C'],
            name: '',
          )).thenAnswer((_) async => [variant2]); // Returns another for page 1

      final container = createContainer();

      // Listen to the provider to keep it alive and observe state changes
      final listener = ProviderListener<AsyncValue<List<Variant>>>();
      container.listen(
        outerVariantsProvider(1),
        listener,
        fireImmediately: true,
      );

      // Wait for the initial build (page 0) to complete and data to be set
      await container.read(outerVariantsProvider(1).future);
      expect(container.read(outerVariantsProvider(1)).value,
          [variant1]); // Confirm initial state

      // Act
      // Call loadMore. It takes branchId as an argument but doesn't manage page itself.
      // The `OuterVariants` class internally handles the _currentPage increment.
      await container.read(outerVariantsProvider(1).notifier).loadMore();

      // Give Riverpod a moment to process the state update from loadMore
      await Future<void>.delayed(
          Duration.zero); // Allow microtasks to complete.

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant1, variant2]); // Expect both variants
      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 1, // Verify page 1 was requested
          itemsPerPage: 1, // Verify with the correct itemsPerPage
          taxTyCds: ['A', 'B', 'C'],
          name: '')).called(1); // Ensure it was called once for page 1
    });

    test('removeVariantById removes a variant from the state', () async {
      // Arrange
      when(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: '')).thenAnswer((_) async => [variant1, variant2]);

      final container = createContainer();
      // Wait for initial data load
      await container.read(outerVariantsProvider(1).future);
      expect(
          container.read(outerVariantsProvider(1)).value, [variant1, variant2]);

      // Act
      container.read(outerVariantsProvider(1).notifier).removeVariantById('1');

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant2]);
    });

    test('search filters variants from local strategy first', () async {
      // Arrange
      // Initial mock for an empty search string (how the provider builds initially)
      when(() => mockDbSync.variants(
                branchId: 1,
                fetchRemote: false,
                page: 0,
                itemsPerPage: 10,
                taxTyCds: ['A', 'B', 'C'],
                name: '', // Initial load uses empty string
              ))
          .thenAnswer((_) async =>
              []); // Assume initial load finds nothing or not relevant

      // Mock the behavior for a search term "Apple" for local strategy
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0, // Search should reset page to 0
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: 'Apple', // Expect this name
          )).thenAnswer((_) async => [variant1, variant3]);

      final searchString = 'Apple';
      final container = createContainer();

      // Get the SearchString notifier via Riverpod's container
      final searchStringNotifier =
          container.read(searchStringProvider.notifier);

      // Act: Emit the search string using the Riverpod-managed notifier
      searchStringNotifier.emitString(value: searchString);

      // Wait for the outerVariantsProvider to rebuild and fetch data based on the new search string.
      // The `build` method is reactive to `searchStringProvider`.
      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant1, variant3]);

      // Verify calls: initial empty search, then the specific "Apple" search (local)
      verifyInOrder([
        () => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: ''), // Initial build
        () => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0, // Reset to page 0 for search
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: 'Apple') // The actual search call
      ]);
      // Make sure no remote fetch was attempted for this case
      verifyNever(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: true,
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          taxTyCds: any(named: 'taxTyCds'),
          name: 'Apple'));
    });

    test(
        'search falls back to remote strategy if local returns empty with a search string',
        () async {
      // Arrange
      when(() => mockBox.itemPerPage()).thenReturn(10);

      // Mock the initial call with name: '' (from the first build)
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: '', // Initial load uses empty string
          )).thenAnswer((_) async => []);

      // Mocks for the search sequence (local then remote)
      final searchString = 'Remote';
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false, // Local attempt
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: searchString, // Expected search name
          )).thenAnswer((_) async => []); // Local returns empty

      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true, // Remote fallback
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: searchString, // Expected search name
          )).thenAnswer((_) async => [remoteVariant]); // Remote succeeds

      final container = createContainer();

      // Wait for initial build to complete first
      await container.read(outerVariantsProvider(1).future);

      final searchStringNotifier =
          container.read(searchStringProvider.notifier);

      // Act
      searchStringNotifier.emitString(value: searchString);
      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [remoteVariant]);

      // Verify individual calls instead of order
      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: '')).called(1); // Initial build

      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: searchString)).called(1); // Local search

      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: true,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: searchString)).called(1); // Remote fallback
    });

    test('provider handles errors during fetch gracefully', () async {
      // Arrange
      final exception = Exception('Failed to fetch');
      when(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: '')).thenThrow(exception);

      final container = createContainer();
      final listener = ProviderListener<AsyncValue<List<Variant>>>();

      // Act
      container.listen(
        outerVariantsProvider(1),
        listener,
        fireImmediately: true,
      );

      // Instead of awaiting .future (which re-throws), wait for Riverpod to settle
      // and update the state to AsyncError. A microtask delay is usually enough.
      await Future<void>.delayed(Duration.zero);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result, isA<AsyncError>());
      expect((result as AsyncError).error, equals(exception));

      // Optionally, check listener values to ensure it transitioned to error state
      expect(listener.values.last, isA<AsyncError>());
      expect((listener.values.last as AsyncError).error, equals(exception));
    });
  });

  group('OuterVariants Provider - VAT Disabled (Tax Type D)', () {
    late MockBox isolatedMockBox;
    late MockDatabaseSync isolatedMockDbSync;
    late MockCacheManager isolatedMockCacheManager;

    setUp(() {
      // Create fresh mocks for this group
      isolatedMockBox = MockBox();
      isolatedMockDbSync = MockDatabaseSync();
      isolatedMockCacheManager = MockCacheManager();

      // Clear and re-register with fresh mocks
      GetIt.I.reset();
      GetIt.I.registerSingleton<LocalStorage>(isolatedMockBox);
      GetIt.I.registerSingleton<DatabaseSyncInterface>(isolatedMockDbSync);
      GetIt.I.registerSingleton<CacheManager>(isolatedMockCacheManager);

      // Set up default behaviors for VAT disabled scenario
      when(() => isolatedMockBox.vatEnabled())
          .thenReturn(false); // VAT disabled
      when(() => isolatedMockBox.itemPerPage()).thenReturn(10);
      when(() => isolatedMockCacheManager.initialize())
          .thenAnswer((_) async => true);
      when(() => isolatedMockCacheManager.saveStocksForVariants(any()))
          .thenAnswer((_) async {});

      // Default behavior for variant fetching with tax type D
      when(() => isolatedMockDbSync.variants(
            branchId: any(named: 'branchId'),
            name: any(named: 'name'),
            fetchRemote: any(named: 'fetchRemote'),
            page: any(named: 'page'),
            itemsPerPage: any(named: 'itemsPerPage'),
            taxTyCds: ['D'], // Only tax type D
          )).thenAnswer((_) async => []);
    });

    tearDown(() {
      GetIt.I.reset();
    });
  });
}
