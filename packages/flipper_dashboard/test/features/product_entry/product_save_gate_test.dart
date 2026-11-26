import 'package:flipper_dashboard/features/product_entry/product_save_gate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool canSave({
    bool isEditMode = false,
    bool isComposite = false,
    String name = 'Fanta',
    String retailText = '1000',
    bool hasCategory = true,
    bool hasComponents = false,
  }) => productCanSave(
    isEditMode: isEditMode,
    isComposite: isComposite,
    name: name,
    retailText: retailText,
    hasCategory: hasCategory,
    hasComponents: hasComponents,
  );

  group('new product', () {
    test('needs a name, a valid retail price and a category', () {
      expect(canSave(), isTrue);
      expect(canSave(name: '  '), isFalse);
      expect(canSave(retailText: ''), isFalse);
      expect(canSave(retailText: 'abc'), isFalse);
      expect(canSave(hasCategory: false), isFalse);
    });

    test('a combo needs components instead of a category', () {
      expect(
        canSave(isComposite: true, hasCategory: false, hasComponents: true),
        isTrue,
      );
      expect(canSave(isComposite: true, hasComponents: false), isFalse);
    });
  });

  group('editing', () {
    test('a name alone is enough (no category, blank price)', () {
      expect(
        canSave(isEditMode: true, retailText: '', hasCategory: false),
        isTrue,
      );
    });

    test('a valid price and no category is fine', () {
      expect(canSave(isEditMode: true, hasCategory: false), isTrue);
    });

    test('still needs a name, and a price that is a number', () {
      expect(canSave(isEditMode: true, name: ''), isFalse);
      expect(canSave(isEditMode: true, retailText: 'null'), isFalse);
    });

    test('a combo still needs a component', () {
      expect(
        canSave(isEditMode: true, isComposite: true, hasComponents: false),
        isFalse,
      );
      expect(
        canSave(
          isEditMode: true,
          isComposite: true,
          hasComponents: true,
          hasCategory: false,
          retailText: '',
        ),
        isTrue,
      );
    });
  });

  group('editedPrice', () {
    test('null when blank or unchanged, so each variant keeps its own', () {
      expect(editedPrice(text: '', loadedText: '1000.0'), isNull);
      expect(editedPrice(text: ' 1000.0 ', loadedText: '1000.0'), isNull);
    });

    test('the typed price when it changed', () {
      expect(editedPrice(text: '1200', loadedText: '1000.0'), 1200);
      expect(editedPrice(text: '500', loadedText: ''), 500);
    });
  });

  test('priceFieldText shows no price as blank, never "null"', () {
    expect(priceFieldText(null), '');
    expect(priceFieldText(1500.0), '1500.0');
  });
}
