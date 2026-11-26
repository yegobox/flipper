import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/features/product_entry/combo_component_diff.dart';
import 'package:flipper_dashboard/features/product_entry/combo_edit.dart';
import 'package:flipper_dashboard/features/product_entry/combo_save_values.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_helpers/mocks.dart';

/// The rows written through the fake strategy, in order.
class _Writes {
  final saved = <Composite>[];
  final deleted = <String>[];
  final renamed = <String>[];
}

Variant _variant(String id, {String? name, double? retail, double? supply}) =>
    Variant(
      id: id,
      name: name ?? id,
      productName: name ?? id,
      productId: 'p-$id',
      retailPrice: retail,
      supplyPrice: supply,
      branchId: 'branch-1',
    );

VariantState _line(String id, double qty) => VariantState(
  variant: VVariant(
    productName: id,
    id: id,
    productId: 'p-$id',
    retailPrice: 0,
  ),
  quantity: qty,
);

const _values = (
  name: 'Lunch combo',
  retailPrice: 5000.0,
  supplyPrice: 0.0,
  sku: '',
  barcode: '123',
  countryOfOrigin: 'RW',
);

void main() {
  late MockDatabaseSync strategy;
  late _Writes writes;

  setUpAll(() => registerFallbackValue(Composite()));

  setUp(() {
    strategy = MockDatabaseSync();
    writes = _Writes();
    when(
      () => strategy.saveComposite(composite: any(named: 'composite')),
    ).thenAnswer((inv) async {
      writes.saved.add(inv.namedArguments[#composite] as Composite);
    });
    when(
      () => strategy.flipperDelete(
        id: any(named: 'id'),
        endPoint: any(named: 'endPoint'),
      ),
    ).thenAnswer((inv) async {
      expect(inv.namedArguments[#endPoint], 'composite');
      writes.deleted.add(inv.namedArguments[#id] as String);
      return true;
    });
    when(
      () => strategy.updateProduct(
        productId: any(named: 'productId'),
        branchId: any(named: 'branchId'),
        businessId: any(named: 'businessId'),
        name: any(named: 'name'),
        isComposite: any(named: 'isComposite'),
      ),
    ).thenAnswer((inv) async {
      expect(inv.namedArguments[#isComposite], isTrue);
      writes.renamed.add(inv.namedArguments[#name] as String);
    });
  });

  group('loadComboComponents', () {
    void savedRows(List<Composite> rows) {
      when(
        () => strategy.composites(productId: 'combo', localOnly: true),
      ).thenAnswer((_) async => rows);
    }

    test('loads each component once, with its saved quantity', () async {
      savedRows([
        Composite(id: 'c1', variantId: 'rice', qty: 2),
        Composite(id: 'c2', variantId: 'beans'),
        Composite(id: 'c3', variantId: 'rice', qty: 2),
      ]);
      when(
        () => strategy.getVariant(id: 'rice'),
      ).thenAnswer((_) async => _variant('rice', retail: 800, supply: 500));
      when(
        () => strategy.getVariant(id: 'beans'),
      ).thenAnswer((_) async => _variant('beans'));

      final combo = await loadComboComponents(
        strategy: strategy,
        productId: 'combo',
      );

      expect(combo.lines.map((l) => (l.variant.id, l.quantity)), [
        ('rice', 2.0),
        ('beans', 1.0),
      ]);
      expect(combo.lines.first.variant.supplyPrice, 500);
      expect(combo.lines.last.variant.retailPrice, 0, reason: 'no price → 0');
      // Both rice rows are kept, so the save can delete the extra one.
      expect(combo.saved.map((s) => s.id), ['c1', 'c2', 'c3']);
      verify(() => strategy.getVariant(id: 'rice')).called(1);
    });

    test('a component not on this device is left out of both lists', () async {
      savedRows([
        Composite(id: 'c1', variantId: 'rice', qty: 1),
        Composite(id: 'c2', variantId: 'ghost', qty: 1),
        Composite(id: 'c3', variantId: 'ghost', qty: 1),
        Composite(id: 'c4', variantId: null),
      ]);
      when(
        () => strategy.getVariant(id: 'rice'),
      ).thenAnswer((_) async => _variant('rice'));
      when(
        () => strategy.getVariant(id: 'ghost'),
      ).thenAnswer((_) async => null);

      final combo = await loadComboComponents(
        strategy: strategy,
        productId: 'combo',
      );

      expect(combo.lines.map((l) => l.variant.id), ['rice']);
      expect(combo.saved.map((s) => s.id), ['c1']);
      verify(() => strategy.getVariant(id: 'ghost')).called(1);
    });
  });

  group('updateComboInPlace', () {
    const saved = <SavedComboComponent>[
      (id: 'c1', variantId: 'rice', qty: 1),
      (id: 'c2', variantId: 'beans', qty: 2),
    ];

    Future<({ComboComponentChanges changes, List<String> itemTypes})> save({
      required List<VariantState> lines,
      List<SavedComboComponent> savedRows = saved,
      Variant? comboVariant,
      ComboSaveValues values = _values,
      bool madeInProduction = false,
      double? retailPrice,
    }) async {
      final itemTypes = <String>[];
      final changes = await updateComboInPlace(
        strategy: strategy,
        productId: 'combo',
        branchId: 'branch-1',
        businessId: 'biz-1',
        comboVariant: comboVariant ?? _variant('combo-v', retail: 4000),
        values: values,
        madeInProduction: madeInProduction,
        saved: savedRows,
        lines: lines,
        retailPrice: retailPrice,
        updateVariant: (itemType) async => itemTypes.add(itemType),
      );
      return (changes: changes, itemTypes: itemTypes);
    }

    test('rename only: rewrites the same rows, deletes nothing', () async {
      await save(lines: [_line('rice', 1), _line('beans', 2)]);

      expect(writes.saved.map((c) => (c.id, c.variantId, c.qty)), [
        ('c1', 'rice', 1.0),
        ('c2', 'beans', 2.0),
      ]);
      expect(writes.deleted, isEmpty);
      expect(writes.renamed, ['Lunch combo']);
      for (final row in writes.saved) {
        expect(row.productId, 'combo');
        expect(row.branchId, 'branch-1');
        expect(row.businessId, 'biz-1');
        expect(row.actualPrice, 4000, reason: 'price unchanged: own price');
      }
    });

    test('a quantity change keeps the row id', () async {
      await save(lines: [_line('rice', 3), _line('beans', 2)]);

      expect(writes.saved.first.id, 'c1');
      expect(writes.saved.first.qty, 3);
      expect(writes.deleted, isEmpty);
    });

    test('a removed line is deleted once; a new line gets a new row', () async {
      await save(lines: [_line('rice', 1), _line('meat', 1)]);

      expect(writes.deleted, ['c2']);
      final meat = writes.saved.singleWhere((c) => c.variantId == 'meat');
      expect(meat.id, isNot(anyOf('c1', 'c2')));
    });

    test('a component saved twice loses the extra row', () async {
      await save(
        lines: [_line('rice', 1), _line('beans', 2)],
        savedRows: [...saved, (id: 'c3', variantId: 'rice', qty: 1)],
      );

      expect(writes.deleted, ['c3']);
      expect(writes.saved.map((c) => c.id), ['c1', 'c2']);
    });

    test('a changed price reaches the component rows', () async {
      await save(lines: [_line('rice', 1)], retailPrice: 6000);

      expect(writes.saved.single.actualPrice, 6000);
    });

    test(
      'updates the combo variant from the form, never re-creating it',
      () async {
        final comboVariant = _variant('combo-v', retail: 4000)
          ..sku = 'CMB-00001';

        final result = await save(
          lines: [_line('rice', 1)],
          comboVariant: comboVariant,
          madeInProduction: true,
        );

        expect(result.itemTypes, ['2'], reason: 'one update, made ahead');
        expect(comboVariant.name, 'Lunch combo');
        expect(comboVariant.bcd, '123');
        expect(comboVariant.itemTyCd, '2');
        expect(
          comboVariant.sku,
          'CMB-00001',
          reason: 'blank SKU keeps its own',
        );
        verifyNever(
          () => strategy.addVariant(
            variations: any(named: 'variations'),
            branchId: any(named: 'branchId'),
            skipRRaCall: any(named: 'skipRRaCall'),
          ),
        );
      },
    );
  });

  group('applyComboForm', () {
    test('a typed SKU replaces the old one; sold as made is a service', () {
      final v = _variant('combo-v')..sku = 'OLD-1';
      final itemType = applyComboForm(
        v,
        values: (
          name: 'Combo',
          retailPrice: 1.0,
          supplyPrice: 0.0,
          sku: 'NEW-1',
          barcode: '',
          countryOfOrigin: 'RW',
        ),
        madeInProduction: false,
      );
      expect(itemType, '3');
      expect(v.sku, 'NEW-1');
      expect(v.itemTyCd, '3');
    });
  });
}
