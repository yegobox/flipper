import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/cache/cache_export.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

// flutter test test/outer_variant_provider_test.dart
// Mocks
class MockCacheManager extends Mock implements CacheManager {}

class MockCrash extends TalkerObserver implements Crash {
  @override
  Future<void> initializeFlutterFire() async {}

  @override
  Future<void> testAsyncErrorOnInit() async {}

  @override
  Future<void> log(data) async {}

  @override
  void reportError(error, stackTrace) {}
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
  final excludedVariant =
      Variant(id: '5', name: 'Excluded Item', branchId: 1, taxTyCd: 'D');

  setUpAll(() async {
    env = TestEnvironment();
    // Skip full initialization to avoid Supabase platform plugin errors
    // await env.init();

    // Initialize only what we need for this test
    env.mockSyncStrategy = MockSyncStrategy();
    env.mockDbSync = MockDatabaseSync();
    env.mockBox = MockBox();
    env.mockFlipperHttpClient = MockFlipperHttpClient();
    env.mockTaxApi = MockTaxApi();

    // Set up fallback values
    registerFallbackValue(
        Customer(branchId: 0, custNm: 'fallback', bhfId: '00'));
    registerFallbackValue(Business(
        id: "1", name: "Fallback Business", tinNumber: 123456789, serverId: 1));
    registerFallbackValue(
        Variant(id: "fallback_variant", name: "Fallback Variant", branchId: 1));
    registerFallbackValue(<Variant>[]);
  });

  tearDownAll(() {
    // Only restore if we have original values
    try {
      env.restore();
    } catch (e) {
      // Ignore restore errors in test-only setup
    }
  });

  setUp(() {
    // Manually inject mocks without full ProxyService setup
    mockBox = env.mockBox;
    mockDbSync = env.mockDbSync;
    mockCacheManager = MockCacheManager();

    // Set up ProxyService mocks directly
    try {
      ProxyService.strategyLink = env.mockSyncStrategy;
      ProxyService.box = mockBox;
      ProxyService.tax = env.mockTaxApi;
    } catch (e) {
      // Ignore ProxyService setup errors in test environment
    }

    when(() => env.mockSyncStrategy.current).thenReturn(mockDbSync);

    if (!GetIt.I.isRegistered<CacheManager>()) {
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
    } else {
      GetIt.I.unregister<CacheManager>();
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
    }

    // Register Crash service to fix CI/CD issue
    if (!GetIt.I.isRegistered<Crash>()) {
      GetIt.I.registerSingleton<Crash>(MockCrash());
    }

    when(() => mockBox.itemPerPage()).thenReturn(10);
    when(() => mockBox.vatEnabled()).thenReturn(true);
    when(() => mockCacheManager.initialize()).thenAnswer((_) async => true);
    when(() => mockCacheManager.saveStocksForVariants(any()))
        .thenAnswer((_) async {});

    when(() => mockDbSync.variants(
          branchId: any(named: 'branchId'),
          name: any(named: 'name'),
          fetchRemote: any(named: 'fetchRemote'),
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          taxTyCds: any(named: 'taxTyCds'),
          scanMode: any(named: 'scanMode'),
        )).thenAnswer((_) async => []);
  });

  ProviderContainer createContainer({
    List<Override> overrides = const [],
  }) {
    final container = ProviderContainer(overrides: overrides);
    addTearDown(container.dispose);
    return container;
  }

  group('OuterVariants Provider', () {
    test('initial build loads variants using remote-first strategy', () async {
      // Arrange
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: '',
            scanMode: false,
          )).thenAnswer((_) async => [variant1, variant2]);

      final container = createContainer();

      // Act
      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant1, variant2]);
      verify(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: '',
            scanMode: false,
          )).called(1);
    });

    test('subsequent search refines in-memory list without remote fetch',
        () async {
      // Arrange
      when(() => mockDbSync.variants(
                branchId: 1,
                fetchRemote: true,
                page: 0,
                itemsPerPage: 10,
                taxTyCds: any(named: 'taxTyCds'),
                name: '',
                scanMode: false,
              ))
          .thenAnswer((_) async =>
              [variant1, variant2, variant3, remoteVariant, excludedVariant]);

      final container = createContainer();

      // Load initial data
      await container.read(outerVariantsProvider(1).future);

      // Act: First search - this should immediately filter the loaded data
      container.read(searchStringProvider.notifier).emitString(value: 'Apple');

      // Wait for the provider to rebuild with the search filter
      await container.read(outerVariantsProvider(1).future);

      // Assert: First search results (should contain variants with "Apple" in name and valid taxTyCd)
      final firstSearchResult = container.read(outerVariantsProvider(1)).value;
      expect(firstSearchResult, isNotNull);
      expect(
          firstSearchResult,
          hasLength(
              3)); // variant1, variant3, remoteVariant (excludedVariant filtered out by taxTyCd)
      expect(firstSearchResult!.map((v) => v.name),
          containsAll(['Apple', 'Apple Juice', 'Remote Apple']));
      expect(
          firstSearchResult.every((v) => ['A', 'B', 'C'].contains(v.taxTyCd)),
          isTrue);

      // Act: Refine search - this should further filter the in-memory results
      container
          .read(searchStringProvider.notifier)
          .emitString(value: 'Apple J');

      // Wait for the provider to rebuild with the refined filter
      await container.read(outerVariantsProvider(1).future);

      // Assert: Refined search results (should only contain "Apple Juice")
      final refinedSearchResult =
          container.read(outerVariantsProvider(1)).value;
      expect(refinedSearchResult, isNotNull);
      expect(refinedSearchResult, hasLength(1));
      expect(refinedSearchResult!.first.name, 'Apple Juice');
      expect(refinedSearchResult.first.taxTyCd, 'C');

      // Verify that the remote fetch was only called once for initial load
      verify(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: '',
            scanMode: false,
          )).called(1);
    });

    test('clears search returns to full list', () async {
      // Arrange
      when(() => mockDbSync.variants(
                branchId: 1,
                fetchRemote: true,
                page: 0,
                itemsPerPage: 10,
                taxTyCds: any(named: 'taxTyCds'),
                name: '',
                scanMode: false,
              ))
          .thenAnswer(
              (_) async => [variant1, variant2, variant3, excludedVariant]);

      final container = createContainer();

      // Load initial data
      await container.read(outerVariantsProvider(1).future);

      // Apply search filter
      container.read(searchStringProvider.notifier).emitString(value: 'Apple');
      await container.read(outerVariantsProvider(1).future);

      // Verify filtered results
      final filteredResult = container.read(outerVariantsProvider(1)).value;
      expect(
          filteredResult,
          hasLength(
              2)); // variant1 and variant3 (excludedVariant filtered out by taxTyCd)

      // Act: Clear search
      container.read(searchStringProvider.notifier).emitString(value: '');
      await container.read(outerVariantsProvider(1).future);

      // Assert: Should return to full list (but still filtered by taxTyCd)
      final clearedResult = container.read(outerVariantsProvider(1)).value;
      expect(
          clearedResult,
          hasLength(
              3)); // variant1, variant2, variant3 (excludedVariant still filtered out)
      expect(clearedResult, containsAll([variant1, variant2, variant3]));
      expect(clearedResult!.every((v) => ['A', 'B', 'C'].contains(v.taxTyCd)),
          isTrue);
    });

    test('filters variants by taxTyCd when VAT is disabled', () async {
      // Arrange - VAT disabled, should only show taxTyCd 'D'
      when(() => mockBox.vatEnabled()).thenReturn(false);

      final vatDisabledVariant = Variant(
          id: '6', name: 'VAT Disabled Item', branchId: 1, taxTyCd: 'D');

      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['D'], // Should request only 'D' variants
            name: '',
            scanMode: false,
          )).thenAnswer((_) async => [variant1, variant2, vatDisabledVariant]);

      final container = createContainer();

      // Load initial data
      await container.read(outerVariantsProvider(1).future);

      // Assert: Should only show variants with taxTyCd 'D'
      final result = container.read(outerVariantsProvider(1)).value;
      expect(result, hasLength(1));
      expect(result!.first.taxTyCd, 'D');
      expect(result.first.name, 'VAT Disabled Item');

      // Verify the correct taxTyCds were passed to the fetch
      verify(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: ['D'],
            name: '',
            scanMode: false,
          )).called(1);
    });
  });
}

/// real test above is failing due to realm download 
// void main() {
//   group('OuterVariants Provider', () {
//     expect(1, 1);
//   });
// }
