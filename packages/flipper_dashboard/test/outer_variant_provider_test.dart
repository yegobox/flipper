import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/sync/interfaces/database_sync_interface.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/cache/cache_export.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

// flutter test test/outer_variant_provider_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
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
    // Use mocks from the TestEnvironment
    mockBox = env.mockBox;
    mockDbSync = env.mockDbSync;
    mockCacheManager = MockCacheManager();

    // Register mocks that are not part of the environment's GetIt setup
    if (!GetIt.I.isRegistered<CacheManager>()) {
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
    }

    // Set up default behaviors for mocks.
    when(() => mockBox.itemPerPage()).thenReturn(10);
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
        )).thenAnswer((_) async => []);
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
            itemsPerPage: 10,
            taxTyCds: ['A', 'B', 'C'],
            name: '',
          )).thenAnswer((_) async => [variant1, variant2]);

      final container = createContainer();
      final listener = ProviderListener<AsyncValue<List<Variant>>>();

      // Act
      container.listen(
        outerVariantsProvider(1),
        listener,
        fireImmediately: true,
      );

      // Wait for the future to complete.
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
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: '',
          )).thenAnswer((_) async => [variant1]);

      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 1,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: '',
          )).thenAnswer((_) async => [variant2]);

      final container = createContainer();
      await container.read(outerVariantsProvider(1).future);

      // Act
      await container.read(outerVariantsProvider(1).notifier).loadMore(1);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant1, variant2]);
      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 1,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: '')).called(1);
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
      await container.read(outerVariantsProvider(1).future);

      // Act
      container.read(outerVariantsProvider(1).notifier).removeVariantById('1');

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant2]);
    });

    test('search filters variants from local strategy first', () async {
      // Arrange
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: 'Apple',
          )).thenAnswer((_) async => [variant1, variant3]);

      final container = createContainer(overrides: [
        searchStringProvider.overrideWith(() => SearchString()),
      ]);

      // Act
      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [variant1, variant3]);
      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: 'Apple')).called(1);
    });

    test(
        'search falls back to remote strategy if local returns empty with a search string',
        () async {
      // Arrange
      // Local search returns empty
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: false,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: 'Remote',
          )).thenAnswer((_) async => []);

      // Remote search returns a variant
      when(() => mockDbSync.variants(
            branchId: 1,
            fetchRemote: true,
            page: 0,
            itemsPerPage: 10,
            taxTyCds: any(named: 'taxTyCds'),
            name: 'Remote',
          )).thenAnswer((_) async => [remoteVariant]);

      final container = createContainer(overrides: [
        searchStringProvider.overrideWith(() => SearchString()),
      ]);

      // Act
      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result.value, [remoteVariant]);

      // Verify both local and remote calls were made.
      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: false,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: 'Remote')).called(1);
      verify(() => mockDbSync.variants(
          branchId: 1,
          fetchRemote: true,
          page: 0,
          itemsPerPage: 10,
          taxTyCds: any(named: 'taxTyCds'),
          name: 'Remote')).called(1);
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

      await container.read(outerVariantsProvider(1).future);

      // Assert
      final result = container.read(outerVariantsProvider(1));
      expect(result, isA<AsyncError>());
      expect((result as AsyncError).error, equals(exception));
    });
  });
}
