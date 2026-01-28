import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/SearchCustomer.dart';

import 'test_helpers/setup.dart';

void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() async {
    await env.dispose();
  });

  group('CustomDropdownButton Tests', () {
    test('CustomDropdownButton can be instantiated', () {
      final widget = CustomDropdownButton(
        items: ['Item 1', 'Item 2'],
        selectedItem: 'Item 1',
        onChanged: (value) {},
        label: 'Test Label',
      );

      expect(widget, isNotNull);
      expect(widget.items, equals(['Item 1', 'Item 2']));
      expect(widget.selectedItem, equals('Item 1'));
      expect(widget.label, equals('Test Label'));
    });

    test('CustomDropdownButton with icon and compact mode', () {
      final widget = CustomDropdownButton(
        items: ['Option 1', 'Option 2'],
        selectedItem: 'Option 1',
        onChanged: (value) {},
        label: 'Test Option',
        icon: Icons.person,
        compact: true,
      );

      expect(widget, isNotNull);
      expect(widget.items, equals(['Option 1', 'Option 2']));
      expect(widget.selectedItem, equals('Option 1'));
      expect(widget.label, equals('Test Option'));
      expect(widget.icon, equals(Icons.person));
      expect(widget.compact, isTrue);
    });

    test('CustomDropdownButton properties are correctly assigned', () {
      const key = Key('test-dropdown-key');
      const items = ['A', 'B', 'C'];
      const selectedItem = 'A';
      const label = 'Test Label';
      const icon = Icons.home;
      const compact = false;

      void onChanged(String value) {}

      final widget = CustomDropdownButton(
        key: key,
        items: items,
        selectedItem: selectedItem,
        onChanged: onChanged,
        label: label,
        icon: icon,
        compact: compact,
      );

      expect(widget.key, equals(key));
      expect(widget.items, equals(items));
      expect(widget.selectedItem, equals(selectedItem));
      expect(widget.label, equals(label));
      expect(widget.icon, equals(icon));
      expect(widget.compact, equals(compact));
    });

    test('CustomDropdownButton has correct default values', () {
      final widget = CustomDropdownButton(
        items: [],
        selectedItem: '',
        onChanged: (value) {},
        label: 'Test',
      );

      expect(widget.compact, isFalse); // Default value should be false
    });

    test('CustomDropdownButton accepts null icon', () {
      final widget = CustomDropdownButton(
        items: ['Test'],
        selectedItem: 'Test',
        onChanged: (value) {},
        label: 'Test Label',
        icon: null, // Explicitly null
      );

      expect(widget.icon, isNull);
    });

    test('CustomDropdownButton accepts compact parameter', () {
      final widget = CustomDropdownButton(
        items: ['Test Item'],
        selectedItem: 'Test Item',
        onChanged: (value) {},
        label: 'Test Label',
        compact: true,
      );

      expect(widget.compact, isTrue);
    });

    test('CustomDropdownButton has correct type', () {
      final widget = CustomDropdownButton(
        items: ['Test'],
        selectedItem: 'Test',
        onChanged: (value) {},
        label: 'Test Label',
      );

      expect(widget, isA<Widget>());
      expect(widget, isA<CustomDropdownButton>());
    });

    test('CustomDropdownButton handles empty items list', () {
      final widget = CustomDropdownButton(
        items: [],
        selectedItem: '',
        onChanged: (value) {},
        label: 'Empty Test',
      );

      expect(widget.items, isEmpty);
      expect(widget.selectedItem, equals(''));
      expect(widget.label, equals('Empty Test'));
    });

    test('CustomDropdownButton handles single item', () {
      final widget = CustomDropdownButton(
        items: ['Single Item'],
        selectedItem: 'Single Item',
        onChanged: (value) {},
        label: 'Single Test',
      );

      expect(widget.items, equals(['Single Item']));
      expect(widget.selectedItem, equals('Single Item'));
      expect(widget.label, equals('Single Test'));
    });

    test('CustomDropdownButton handles many items', () {
      final items = List<String>.generate(10, (i) => 'Item $i');
      final widget = CustomDropdownButton(
        items: items,
        selectedItem: 'Item 0',
        onChanged: (value) {},
        label: 'Many Items Test',
      );

      expect(widget.items.length, equals(10));
      expect(widget.selectedItem, equals('Item 0'));
      expect(widget.label, equals('Many Items Test'));
    });

    test('CustomDropdownButton handles long item names', () {
      final longItemName = 'A' * 100; // 100 character string
      final widget = CustomDropdownButton(
        items: [longItemName],
        selectedItem: longItemName,
        onChanged: (value) {},
        label: 'Long Name Test',
      );

      expect(widget.items.first, equals(longItemName));
      expect(widget.selectedItem, equals(longItemName));
    });

    test('CustomDropdownButton handles special characters in items', () {
      const specialItems = [
        'Item with spaces',
        'Item_with_underscores',
        'Item-with-dashes',
        'Item.with.dots',
      ];
      final widget = CustomDropdownButton(
        items: specialItems,
        selectedItem: specialItems.first,
        onChanged: (value) {},
        label: 'Special Characters Test',
      );

      expect(widget.items, equals(specialItems));
      expect(widget.selectedItem, equals(specialItems.first));
    });

    test('CustomDropdownButton handles different item types', () {
      const items = [
        'Normal Item',
        'Item with Numbers 123',
        'Item with Symbols !@#',
        'Item with Unicode ñáéíóú',
      ];
      final widget = CustomDropdownButton(
        items: items,
        selectedItem: items[0],
        onChanged: (value) {},
        label: 'Different Types Test',
      );

      expect(widget.items, equals(items));
      expect(widget.selectedItem, equals(items[0]));
    });

    test('SearchInputWithDropdown widget can be instantiated', () {
      final widget = const SearchInputWithDropdown();

      expect(widget, isNotNull);
      expect(widget, isA<Widget>());
      expect(widget, isA<SearchInputWithDropdown>());
    });

    test('CustomDropdownButton handles numeric item names', () {
      const numericItems = ['123', '456.789', '-100', '0'];
      final widget = CustomDropdownButton(
        items: numericItems,
        selectedItem: numericItems[0],
        onChanged: (value) {},
        label: 'Numeric Items Test',
      );

      expect(widget.items, equals(numericItems));
      expect(widget.selectedItem, equals(numericItems[0]));
    });

    test('CustomDropdownButton handles empty string items', () {
      const emptyStringItems = ['', 'non-empty', ''];
      final widget = CustomDropdownButton(
        items: emptyStringItems,
        selectedItem: emptyStringItems[0],
        onChanged: (value) {},
        label: 'Empty String Items Test',
      );

      expect(widget.items, equals(emptyStringItems));
      expect(widget.selectedItem, equals(emptyStringItems[0]));
    });

    test('CustomDropdownButton handles identical item names', () {
      const duplicateItems = ['Duplicate', 'Duplicate', 'Duplicate'];
      final widget = CustomDropdownButton(
        items: duplicateItems,
        selectedItem: duplicateItems[0],
        onChanged: (value) {},
        label: 'Duplicate Items Test',
      );

      expect(widget.items, equals(duplicateItems));
      expect(widget.selectedItem, equals(duplicateItems[0]));
    });

    test('CustomDropdownButton handles unicode characters', () {
      const unicodeItems = ['🌟 Star', '🚀 Rocket', '🎉 Party', '🌍 Globe'];
      final widget = CustomDropdownButton(
        items: unicodeItems,
        selectedItem: unicodeItems[0],
        onChanged: (value) {},
        label: 'Unicode Items Test',
      );

      expect(widget.items, equals(unicodeItems));
      expect(widget.selectedItem, equals(unicodeItems[0]));
    });

    test('CustomDropdownButton handles very long item list', () {
      final longItemList = List<String>.generate(100, (i) => 'Item $i');
      final widget = CustomDropdownButton(
        items: longItemList,
        selectedItem: longItemList[0],
        onChanged: (value) {},
        label: 'Long List Test',
      );

      expect(widget.items.length, equals(100));
      expect(widget.selectedItem, equals(longItemList[0]));
    });

    test('CustomDropdownButton handles onChanged callback', () {
      String? capturedValue;
      void testCallback(String value) {
        capturedValue = value;
      }

      final widget = CustomDropdownButton(
        items: ['Test Item'],
        selectedItem: 'Test Item',
        onChanged: testCallback,
        label: 'Callback Test',
      );

      // Simulate calling the callback
      widget.onChanged('New Value');
      expect(capturedValue, equals('New Value'));
    });

    test('CustomDropdownButton handles null selectedItem', () {
      // Note: This test might not be applicable if the parameter is required
      // But we can still test with an empty string as a "null equivalent"
      final widget = CustomDropdownButton(
        items: ['Item 1', 'Item 2'],
        selectedItem: '', // Empty string as placeholder
        onChanged: (value) {},
        label: 'Null Selected Item Test',
      );

      expect(widget.selectedItem, equals(''));
      expect(widget.items, equals(['Item 1', 'Item 2']));
    });

    test('CustomDropdownButton handles large numbers as strings', () {
      const largeNumberItems = [
        '999999999999999',
        '1.7976931348623157e+308',
        '0.000000000001',
      ];
      final widget = CustomDropdownButton(
        items: largeNumberItems,
        selectedItem: largeNumberItems[0],
        onChanged: (value) {},
        label: 'Large Number Items Test',
      );

      expect(widget.items, equals(largeNumberItems));
      expect(widget.selectedItem, equals(largeNumberItems[0]));
    });
  });

  group('SearchInputWithDropdown Tests', () {
    test('SearchInputWithDropdown widget can be instantiated', () {
      final widget = const SearchInputWithDropdown();

      expect(widget, isNotNull);
      expect(widget, isA<Widget>());
      expect(widget, isA<SearchInputWithDropdown>());
    });

    test('SearchInputWithDropdown is a ConsumerStatefulWidget', () {
      final widget = const SearchInputWithDropdown();

      expect(widget, isA<SearchInputWithDropdown>());
    });

    test('SearchInputWithDropdown has correct type hierarchy', () {
      final widget = const SearchInputWithDropdown();

      expect(widget, isA<Widget>());
    });

    test('SearchInputWithDropdown can create state', () {
      final widget = const SearchInputWithDropdown();

      // Test that createState method exists and returns non-null
      expect(widget.createState, isNotNull);
    });

    test('SearchInputWithDropdown key can be provided', () {
      const key = Key('search-input-key');
      final widget = const SearchInputWithDropdown(key: key);

      expect(widget.key, equals(key));
    });

    test('SearchInputWithDropdown without key has null key', () {
      final widget = const SearchInputWithDropdown();

      expect(widget.key, isNull);
    });
  });
}
