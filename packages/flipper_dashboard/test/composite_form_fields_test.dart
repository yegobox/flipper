// flutter test test/composite_form_fields_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// The combo form's fields match the rest of the product editor: SKU and bar
// code sit side by side as editor inputs on one top line, the bar code is
// validated by the editor's own form, component lines keep their inputs
// across rebuilds, and the editor's switch rows flip from anywhere on the row.

import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/FieldCompositeActivated.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/pe_field.dart';
import 'package:flipper_dashboard/features/product_editor/widgets/product_editor_composite_toggle.dart';
import 'package:flipper_dashboard/features/product_entry/combo_save_values.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

Widget _app(Widget child, {ProviderContainer? container}) {
  final app = MaterialApp(
    localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
    supportedLocales: FlipperAppLocalizations.supportedLocales,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
  return container == null
      ? ProviderScope(child: app)
      : UncontrolledProviderScope(container: container, child: app);
}

VVariant _variant(String id, double supply) => VVariant(
  productName: 'P-$id',
  name: id,
  id: id,
  productId: 'p-$id',
  retailPrice: 9999,
  supplyPrice: supply,
);

void main() {
  group('Fieldcompositeactivated', () {
    late MockBox box;

    setUp(() async {
      await getIt.reset();
      box = MockBox();
      when(() => box.getBranchId()).thenReturn('b1');
      when(() => box.getBusinessId()).thenReturn('biz1');
      when(() => box.readString(key: any(named: 'key'))).thenReturn(null);
      getIt.registerSingleton<LocalStorage>(box);
    });

    tearDown(() async => getIt.reset());

    testWidgets('SKU and bar code are editor inputs on one top line', (
      tester,
    ) async {
      final sku = TextEditingController();
      final barcode = TextEditingController();
      addTearDown(sku.dispose);
      addTearDown(barcode.dispose);
      final form = GlobalKey<FormState>();

      await tester.pumpWidget(
        _app(
          Form(
            key: form,
            child: Fieldcompositeactivated(
              skuController: sku,
              barCodeController: barcode,
            ),
          ),
        ),
      );

      final inputs = find.byType(PeTextInput);
      expect(inputs, findsNWidgets(2));
      expect(find.byType(PeField), findsNWidgets(2));
      expect(
        tester.getTopLeft(inputs.at(0)).dy,
        tester.getTopLeft(inputs.at(1)).dy,
      );

      final l10n = FlipperAppLocalizations.of(
        tester.element(find.byType(Fieldcompositeactivated)),
      );
      // No device block in tests, so the SKU shows as pending.
      expect(find.text(l10n.skuPending), findsOneWidget);

      // The editor's form validates the bar code: empty blocks the save.
      expect(form.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text(l10n.compositeBarcodeRequired), findsOneWidget);

      // Typing a bar code clears the error straight away.
      await tester.enterText(inputs.at(1), '6001234');
      await tester.pump();
      expect(find.text(l10n.compositeBarcodeRequired), findsNothing);
      expect(form.currentState!.validate(), isTrue);

      // The SKU field types in capitals, monospaced.
      final skuField = tester.widget<TextField>(
        find.descendant(of: inputs.at(0), matching: find.byType(TextField)),
      );
      expect(skuField.textCapitalization, TextCapitalization.characters);

      // Upper-cased as typed on a hardware keyboard too, not just a hint.
      await tester.enterText(inputs.at(0), 'bev-1');
      await tester.pump();
      expect(sku.text, 'BEV-1');
    });

    testWidgets('no branch shows the no-branch message', (tester) async {
      when(() => box.getBranchId()).thenReturn(null);
      final sku = TextEditingController();
      final barcode = TextEditingController();
      addTearDown(sku.dispose);
      addTearDown(barcode.dispose);

      await tester.pumpWidget(
        _app(
          Fieldcompositeactivated(
            skuController: sku,
            barCodeController: barcode,
          ),
        ),
      );

      final l10n = FlipperAppLocalizations.of(
        tester.element(find.byType(Fieldcompositeactivated)),
      );
      expect(find.text(l10n.noBranchSelected), findsOneWidget);
      expect(find.byType(PeTextInput), findsNothing);
    });
  });

  group('PeTextInput', () {
    testWidgets('draws a leading icon, and a prefix wins over it', (
      tester,
    ) async {
      final c = TextEditingController();
      addTearDown(c.dispose);

      await tester.pumpWidget(
        _app(
          Column(
            children: [
              PeTextInput(controller: c, leadingIcon: Icons.search),
              PeTextInput(
                controller: c,
                prefix: 'RWF',
                leadingIcon: Icons.search,
                locked: true,
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('RWF'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('validates the controller text set by code', (tester) async {
      final c = TextEditingController();
      addTearDown(c.dispose);
      final form = GlobalKey<FormState>();
      String? seen;

      await tester.pumpWidget(
        _app(
          Form(
            key: form,
            child: PeTextInput(
              controller: c,
              validator: (value) {
                seen = value;
                return value == null || value.isEmpty ? 'required' : null;
              },
            ),
          ),
        ),
      );

      // Set without typing, as a loaded product or computed price does.
      c.text = 'from code';
      expect(form.currentState!.validate(), isTrue);
      expect(seen, 'from code');
    });
  });

  group('CompositeVariation', () {
    testWidgets('keeps a line\'s inputs across rebuilds, and disposes them', (
      tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(selectedVariantsLocalProvider.notifier);
      notifier.addVariant(variant: _variant('soda', 300));
      notifier.addVariant(variant: _variant('bread', 250));
      final supply = TextEditingController();
      addTearDown(supply.dispose);

      await tester.pumpWidget(
        _app(
          CompositeVariation(supplyPriceController: supply, currency: 'KES'),
          container: container,
        ),
      );
      await tester.pump();

      final state = tester.state<CompositeVariationState>(
        find.byType(CompositeVariation),
      );
      final soda = state.lineControllers['soda']!;
      expect(soda.quantity.text, '1');
      expect(soda.cost.text, '300');
      // Each line's cost wears the business currency, not a fixed RWF.
      expect(find.text('KES'), findsNWidgets(2));
      expect(find.text('RWF'), findsNothing);

      // A half-typed quantity survives the rebuild its own edit causes.
      await tester.enterText(
        find
            .descendant(
              of: find.byKey(const ValueKey('soda')),
              matching: find.byType(TextField),
            )
            .first,
        '3.',
      );
      await tester.pump();
      expect(identical(state.lineControllers['soda'], soda), isTrue);
      expect(soda.quantity.text, '3.');
      expect(soda.cost.text, '900');
      expect(double.parse(supply.text), 1150);

      // A quantity changed elsewhere is written back into the line.
      notifier.updateQuantity(_variant('soda', 300), 2);
      await tester.pump();
      expect(soda.quantity.text, '2');
      await tester.pump();
      expect(double.parse(supply.text), 850);

      // Deleting a line drops (and later disposes) its controllers.
      final bread = state.lineControllers['bread']!;
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('bread')),
          matching: find.byIcon(Icons.delete_outline),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(state.lineControllers.containsKey('bread'), isFalse);
      expect(() => bread.quantity.addListener(() {}), throwsFlutterError);
      expect(double.parse(supply.text), 600);

      // Unmounting disposes the rest.
      await tester.pumpWidget(const SizedBox());
      expect(() => soda.quantity.addListener(() {}), throwsFlutterError);
    });
  });

  group('Component cost text', () {
    test('keeps fractions, drops decimals on whole amounts', () {
      expect(CompositeVariationState.costText(1.25), '1.25');
      expect(CompositeVariationState.costText(62.5), '62.50');
      expect(CompositeVariationState.costText(1500), '1,500');
      expect(CompositeVariationState.costText(0), '0');
    });

    testWidgets('a fractional line cost shows its cents', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container
          .read(selectedVariantsLocalProvider.notifier)
          .addVariant(variant: _variant('gum', 1.25));
      final supply = TextEditingController();
      addTearDown(supply.dispose);

      await tester.pumpWidget(
        _app(
          CompositeVariation(supplyPriceController: supply, currency: 'USD'),
          container: container,
        ),
      );
      await tester.pump();

      final state = tester.state<CompositeVariationState>(
        find.byType(CompositeVariation),
      );
      expect(state.lineControllers['gum']!.cost.text, '1.25');
      expect(double.parse(supply.text), 1.25);
    });
  });

  group('readComboSaveValues', () {
    test('a later edit does not change what the save writes', () {
      final name = TextEditingController(text: 'Lunch combo');
      final retail = TextEditingController(text: '2500');
      final supply = TextEditingController(text: '1150.5');
      final sku = TextEditingController(text: ' LUN-00001 ');
      final barcode = TextEditingController(text: '6001');
      final country = TextEditingController();
      addTearDown(() {
        for (final c in [name, retail, supply, sku, barcode, country]) {
          c.dispose();
        }
      });

      final v = readComboSaveValues(
        name: name,
        retailPrice: retail,
        supplyPrice: supply,
        sku: sku,
        barcode: barcode,
        countryOfOrigin: country,
      );

      // The user types over the price while the save awaits.
      retail.text = 'abc';
      name.text = 'Other';

      expect(v.retailPrice, 2500);
      expect(v.supplyPrice, 1150.5);
      expect(v.name, 'Lunch combo');
      expect(v.sku, 'LUN-00001');
      expect(v.barcode, '6001');
      expect(v.countryOfOrigin, 'RW');
    });
  });

  group('ProductEditorSwitchRow', () {
    testWidgets('the whole row flips the switch and reads as a toggle', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      bool? flipped;

      await tester.pumpWidget(
        _app(
          ProductEditorSwitchRow(
            icon: Icons.factory_outlined,
            title: 'Made in production',
            hint: 'Made ahead in Production Output',
            value: false,
            onChanged: (value) => flipped = value,
          ),
        ),
      );

      // The title, not the switch knob.
      await tester.tap(find.text('Made in production'));
      expect(flipped, isTrue);

      expect(
        tester.getSemantics(find.byType(ProductEditorSwitchRow)),
        matchesSemantics(
          hasToggledState: true,
          isToggled: false,
          hasTapAction: true,
          label: 'Made in production\nMade ahead in Production Output',
        ),
      );
      handle.dispose();
    });
  });
}
