import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/cache/cache_export.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

// Mocks
class MockCacheManager extends Mock implements CacheManager {}

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

    if (!GetIt.I.isRegistered<CacheManager>()) {
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
    } else {
      GetIt.I.unregister<CacheManager>();
      GetIt.I.registerSingleton<CacheManager>(mockCacheManager);
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

    // test('subsequent search refines in-memory list without remote fetch',
    //     () async {
    //   // Arrange
    //   when(() => mockDbSync.variants(
    //             branchId: 1,
    //             fetchRemote: true,
    //             page: 0,
    //             itemsPerPage: 10,
    //             taxTyCds: any(named: 'taxTyCds'),
    //             name: '',
    //             scanMode: false,
    //           ))
    //       .thenAnswer(
    //           (_) async => [variant1, variant2, variant3, remoteVariant]);

    //   final container = createContainer();
    //   await container.read(outerVariantsProvider(1).future);

    //   // Act: First search
    //   container.read(searchStringProvider.notifier).emitString(value: 'Apple');
    //   await Future.delayed(
    //       const Duration(milliseconds: 350)); // Allow debounce to trigger

    //   // Assert: First search results
    //   expect(container.read(outerVariantsProvider(1)).value,
    //       containsAll([variant1, variant3, remoteVariant]));

    //   // Act: Refine search
    //   container
    //       .read(searchStringProvider.notifier)
    //       .emitString(value: 'Apple J');
    //   await Future.delayed(const Duration(milliseconds: 350));

    //   // Assert: Refined search results
    //   expect(container.read(outerVariantsProvider(1)).value, [variant3]);

    //   // Verify that the remote fetch was only called for the initial search, not the refinement
    //   verify(() => mockDbSync.variants(
    //         branchId: 1,
    //         fetchRemote: true,
    //         page: 0,
    //         itemsPerPage: 10,
    //         taxTyCds: any(named: 'taxTyCds'),
    //         name: '',
    //         scanMode: false,
    //       )).called(1);
    // });
  });
}
