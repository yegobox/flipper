import 'package:flipper_dashboard/features/product_entry/combo_component_diff.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const saved = <SavedComboComponent>[
    (id: 'c1', variantId: 'rice', qty: 1),
    (id: 'c2', variantId: 'beans', qty: 2),
  ];

  test('unchanged lines rewrite the same rows and delete nothing', () {
    final changes = planComboComponentChanges(
      saved: saved,
      lines: [(variantId: 'rice', qty: 1), (variantId: 'beans', qty: 2)],
    );
    expect(changes.upserts, [
      (id: 'c1', variantId: 'rice', qty: 1.0),
      (id: 'c2', variantId: 'beans', qty: 2.0),
    ]);
    expect(changes.deleteIds, isEmpty);
  });

  test('a quantity change updates the saved row in place', () {
    final changes = planComboComponentChanges(
      saved: saved,
      lines: [(variantId: 'rice', qty: 3), (variantId: 'beans', qty: 2)],
    );
    expect(changes.upserts.first, (id: 'c1', variantId: 'rice', qty: 3.0));
    expect(changes.deleteIds, isEmpty);
  });

  test('a new line gets a new row, a removed line is deleted', () {
    final changes = planComboComponentChanges(
      saved: saved,
      lines: [(variantId: 'rice', qty: 1), (variantId: 'meat', qty: 1)],
    );
    expect(changes.upserts, [
      (id: 'c1', variantId: 'rice', qty: 1.0),
      (id: null, variantId: 'meat', qty: 1.0),
    ]);
    expect(changes.deleteIds, ['c2']);
  });

  test('a component saved twice keeps one row and deletes the other', () {
    final changes = planComboComponentChanges(
      saved: [...saved, (id: 'c3', variantId: 'rice', qty: 1)],
      lines: [(variantId: 'rice', qty: 1), (variantId: 'beans', qty: 2)],
    );
    expect(changes.upserts.map((u) => u.id), ['c1', 'c2']);
    expect(changes.deleteIds, ['c3']);
  });

  test('a combo with no saved rows writes every line as new', () {
    final changes = planComboComponentChanges(
      saved: const [],
      lines: [(variantId: 'rice', qty: 1)],
    );
    expect(changes.upserts, [(id: null, variantId: 'rice', qty: 1.0)]);
    expect(changes.deleteIds, isEmpty);
  });
}
