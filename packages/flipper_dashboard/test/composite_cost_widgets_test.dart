// flutter test test/composite_cost_widgets_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// A combo's cost is built from its components' cost (supply) prices, never
// their selling prices: picking a component in search carries its supply
// price, and the combo form totals supply price × quantity.

import 'dart:async';

import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/SearchProduct.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/models/paged_variants.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/language_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

class _MockDb extends Mock implements DatabaseSyncInterface {}

class _MockSettingsService extends Mock implements SettingsService {}

class _MockLanguage extends Mock implements Language {}

class _MockKeyPadService extends Mock implements KeyPadService {}

class _MockProductService extends Mock implements ProductService {}

class _MockAppService extends Mock implements AppService {}

Widget _app(ProviderContainer container, Widget child) =>
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );

void main() {
  test('a component line costs its supply price, not its selling price', () {
    final state = VariantState(
      variant: VVariant(
        productName: 'Soda',
        id: 'soda',
        productId: 'p-soda',
        retailPrice: 9999,
        supplyPrice: 300,
      ),
      quantity: 2,
    );
    expect(state.cost, 600);
  });

  testWidgets('the combo form totals its components at cost', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(selectedVariantsLocalProvider.notifier);
    notifier.addVariant(
      variant: VVariant(
        productName: 'Soda',
        id: 'soda',
        productId: 'p-soda',
        retailPrice: 9999,
        supplyPrice: 300,
      ),
    );
    notifier.addVariant(
      variant: VVariant(
        productName: 'Bread',
        id: 'bread',
        productId: 'p-bread',
        retailPrice: 9999,
        supplyPrice: 250,
      ),
    );
    final supply = TextEditingController();
    addTearDown(supply.dispose);

    await tester.pumpWidget(
      _app(
        container,
        CompositeVariation(supplyPriceController: supply, currency: 'KES'),
      ),
    );
    await tester.pump();

    expect(double.parse(supply.text), 550);
  });

  group('SearchProduct', () {
    late _MockDb db;

    setUp(() async {
      await getIt.reset();
      db = _MockDb();
      final box = MockBox();
      when(() => box.vatEnabled()).thenReturn(true);
      when(() => box.getBranchId()).thenReturn('b1');
      when(() => box.readString(key: any(named: 'key'))).thenReturn(null);
      getIt.registerSingleton<LocalStorage>(box);
      // SearchProduct builds a CoreViewModel, which looks these up.
      getIt
        ..registerSingleton<SettingsService>(_MockSettingsService())
        ..registerSingleton<Language>(_MockLanguage())
        ..registerSingleton<KeyPadService>(_MockKeyPadService())
        ..registerSingleton<ProductService>(_MockProductService())
        ..registerSingleton<AppService>(_MockAppService());
      getIt.registerSingleton<SyncStrategy>(
        SyncStrategy(capella: db, cloudSync: db),
        instanceName: 'strategy',
      );
    });

    tearDown(() async => getIt.reset());

    testWidgets('picking a component carries its supply price', (tester) async {
      when(
        () => db.variants(
          taxTyCds: any(named: 'taxTyCds'),
          name: any(named: 'name'),
          branchId: any(named: 'branchId'),
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          countTotal: any(named: 'countTotal'),
        ),
      ).thenAnswer(
        (_) async => PagedVariants(
          variants: [
            Variant(
              id: 'soda',
              name: 'Soda 50cl',
              productName: 'Soda',
              productId: 'p-soda',
              branchId: 'b1',
              retailPrice: 9999,
              supplyPrice: 300,
            ),
          ],
        ),
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_app(container, const SearchProduct()));
      await tester.enterText(find.byType(TextField), 'soda');
      await tester.pump(searchProductDebounce);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Soda 50cl'));
      await tester.pumpAndSettle();

      final picked = container.read(selectedVariantsLocalProvider).single;
      expect(picked.variant.supplyPrice, 300);
      expect(picked.cost, 300);
    });

    Variant hit(String id, {String? name}) => Variant(
      id: id,
      name: name ?? id,
      productName: 'P',
      productId: 'p-$id',
      branchId: 'b1',
      retailPrice: 100,
      supplyPrice: 50,
    );

    void answer(Future<PagedVariants> Function(String name) reply) {
      when(
        () => db.variants(
          taxTyCds: any(named: 'taxTyCds'),
          name: any(named: 'name'),
          branchId: any(named: 'branchId'),
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          countTotal: any(named: 'countTotal'),
        ),
      ).thenAnswer((inv) => reply(inv.namedArguments[#name] as String));
    }

    testWidgets('waits for typing to pause, then asks once, capped', (
      tester,
    ) async {
      answer(
        (_) async => PagedVariants(
          variants: [for (var i = 0; i < 30; i++) hit('Item $i')],
        ),
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(_app(container, const SearchProduct()));

      for (final typed in ['s', 'so', 'sod', 'soda']) {
        await tester.enterText(find.byType(TextField), typed);
        await tester.pump(const Duration(milliseconds: 100));
      }
      verifyNever(
        () => db.variants(
          taxTyCds: any(named: 'taxTyCds'),
          name: any(named: 'name'),
          branchId: any(named: 'branchId'),
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          countTotal: any(named: 'countTotal'),
        ),
      );
      await tester.pump(searchProductDebounce);
      await tester.pump();

      verify(
        () => db.variants(
          taxTyCds: any(named: 'taxTyCds'),
          name: 'soda',
          branchId: 'b1',
          page: 0,
          itemsPerPage: searchProductResultLimit,
          countTotal: false,
        ),
      ).called(1);
      // Even a store that ignores the page size lists no more than the cap.
      expect(
        find.textContaining('Item '),
        findsNWidgets(searchProductResultLimit),
      );

      // Clearing the box clears the list without asking again.
      await tester.enterText(find.byType(TextField), '');
      await tester.pump(searchProductDebounce);
      expect(find.textContaining('Item '), findsNothing);
    });

    testWidgets('a slower, older answer cannot overwrite a newer one', (
      tester,
    ) async {
      final slow = Completer<PagedVariants>();
      answer(
        (name) => name == 'old'
            ? slow.future
            : Future.value(PagedVariants(variants: [hit('Newer')])),
      );
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(_app(container, const SearchProduct()));

      await tester.enterText(find.byType(TextField), 'old');
      await tester.pump(searchProductDebounce);
      await tester.enterText(find.byType(TextField), 'new');
      await tester.pump(searchProductDebounce);
      await tester.pump();
      expect(find.text('Newer'), findsOneWidget);

      slow.complete(PagedVariants(variants: [hit('Older')]));
      await tester.pump();
      expect(find.text('Older'), findsNothing);
      expect(find.text('Newer'), findsOneWidget);
    });

    testWidgets('an answer after the search is gone is dropped', (
      tester,
    ) async {
      final slow = Completer<PagedVariants>();
      answer((_) => slow.future);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(_app(container, const SearchProduct()));

      await tester.enterText(find.byType(TextField), 'soda');
      await tester.pump(searchProductDebounce);
      await tester.pumpWidget(const SizedBox());
      slow.complete(PagedVariants(variants: [hit('Late')]));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('leaving before the pause ends never queries', (tester) async {
      answer((_) async => PagedVariants(variants: [hit('Soda')]));
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(_app(container, const SearchProduct()));

      await tester.enterText(find.byType(TextField), 'soda');
      await tester.pumpWidget(const SizedBox());
      await tester.pump(searchProductDebounce);
      verifyNever(
        () => db.variants(
          taxTyCds: any(named: 'taxTyCds'),
          name: any(named: 'name'),
          branchId: any(named: 'branchId'),
          page: any(named: 'page'),
          itemsPerPage: any(named: 'itemsPerPage'),
          countTotal: any(named: 'countTotal'),
        ),
      );
    });

    testWidgets('no branch, no query', (tester) async {
      when(() => ProxyService.box.getBranchId()).thenReturn(null);
      answer((_) async => PagedVariants(variants: [hit('Soda')]));
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await tester.pumpWidget(_app(container, const SearchProduct()));

      await tester.enterText(find.byType(TextField), 'soda');
      await tester.pump(searchProductDebounce);
      await tester.pump();
      expect(find.text('Soda'), findsNothing);
    });
  });
}
