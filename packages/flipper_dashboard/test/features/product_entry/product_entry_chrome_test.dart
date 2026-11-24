import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_topbar.dart';
import 'package:flipper_dashboard/features/product_entry/product_entry_navigation.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/mobile_entry_style.dart';
import 'package:flipper_dashboard/features/product_entry/widgets/pricing_section.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../test_helpers/mocks.dart';

Widget _app(Widget home) => MaterialApp(
  localizationsDelegates: FlipperLocalizationDelegates.delegates,
  supportedLocales: FlipperLocalizationDelegates.supportedLocales,
  home: home,
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('ProductEditorTopBar', () {
    testWidgets('is a CustomAppBar titled with the live product name', (
      tester,
    ) async {
      final name = TextEditingController();
      addTearDown(name.dispose);
      var backs = 0;

      await tester.pumpWidget(
        _app(
          Scaffold(
            body: ProductEditorTopBar(
              isEditMode: false,
              isComposite: false,
              productNameController: name,
              onBack: () => backs++,
            ),
          ),
        ),
      );

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(find.text('Untitled product'), findsOneWidget);

      name.text = 'Mango juice';
      await tester.pump();
      expect(find.text('Mango juice'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(backs, 1);
    });

    testWidgets(
      'the top-bar back is disabled while saving; takes a close icon',
      (tester) async {
        var backs = 0;
        await tester.pumpWidget(
          _app(
            Scaffold(
              body: ProductEditorTopBar(
                isEditMode: true,
                isComposite: false,
                productName: 'Soap',
                onBack: () => backs++,
                isSaving: true,
                icon: Icons.close,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.arrow_back), findsNothing);
        await tester.tap(find.byIcon(Icons.close));
        expect(backs, 0);
      },
    );
  });

  group('product routes', () {
    late Widget Function(String?) realPage;
    setUp(() => realPage = productEntryPageBuilder);
    tearDown(() => productEntryPageBuilder = realPage);

    /// Pumps a launcher, then opens the editor through
    /// [openProductEntryScreen], with a light page in place of the editor.
    Future<ProviderContainer> openEditor(
      WidgetTester tester, {
      String? productId,
      bool comboBefore = false,
    }) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(isCompositeProvider.notifier).state = comboBefore;
      productEntryPageBuilder = (id) =>
          Scaffold(body: Text('editor ${id ?? 'new'}'));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _app(
            Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    openProductEntryScreen(context, productId: productId),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('opening the editor starts as a plain product, not a combo', (
      tester,
    ) async {
      final container = await openEditor(tester, comboBefore: true);

      expect(find.text('editor new'), findsOneWidget);
      expect(container.read(isCompositeProvider), isFalse);
    });

    testWidgets('system back cannot leave while saving', (tester) async {
      final container = await openEditor(tester, productId: 'p1');
      container.read(loadingProvider.notifier).startLoading();
      await tester.pump();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('editor p1'), findsOneWidget);

      container.read(loadingProvider.notifier).stopLoading();
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('editor p1'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('editing a combo reopens it as a combo', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      late WidgetRef widgetRef;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) {
              widgetRef = ref;
              return const SizedBox();
            },
          ),
        ),
      );

      showProductInItsOwnMode(
        widgetRef,
        Product(
          name: 'Lunch combo',
          color: '#000000',
          businessId: 'b',
          branchId: 'br',
          isComposite: true,
        ),
      );
      expect(container.read(isCompositeProvider), isTrue);

      showProductInItsOwnMode(
        widgetRef,
        Product(
          name: 'Soap',
          color: '#000000',
          businessId: 'b',
          branchId: 'br',
        ),
      );
      expect(container.read(isCompositeProvider), isFalse);
    });
  });

  testWidgets('phone prices show the business currency', (tester) async {
    final retail = TextEditingController();
    final supply = TextEditingController();
    addTearDown(retail.dispose);
    addTearDown(supply.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: _app(
          Scaffold(
            body: PricingSection(
              retailPriceController: retail,
              supplyPriceController: supply,
              model: MockScannViewModel(),
              isComposite: false,
              forceHorizontalPrices: true,
              currencySymbol: 'KES',
            ),
          ),
        ),
      ),
    );

    expect(find.text('KES '), findsNWidgets(2));
  });

  group('MobileEntryPrimaryButton', () {
    testWidgets('spins while busy and ignores taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: MobileEntryPrimaryButton(
              label: 'Save',
              isBusy: true,
              onPressed: () => taps++,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);
      await tester.tap(find.byType(ElevatedButton));
      expect(taps, 0);
    });

    testWidgets('fires when ready', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: MobileEntryPrimaryButton(
              label: 'Save',
              onPressed: () => taps++,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      expect(taps, 1);
    });
  });
}
