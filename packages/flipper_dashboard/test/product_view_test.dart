import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/product_view.dart';

void main() {
  group('ProductView Tests', () {
    test('ProductView widget can be instantiated in normal mode', () {
      final widget = ProductView.normalMode();

      expect(widget, isNotNull);
      expect(widget.favIndex, isNull);
      expect(widget.existingFavs, isEmpty);
    });

    test('ProductView widget can be instantiated in favorite mode', () {
      final widget = ProductView.favoriteMode(
        favIndex: 'favorite-123',
        existingFavs: ['fav1', 'fav2', 'fav3'],
      );

      expect(widget, isNotNull);
      expect(widget.favIndex, equals('favorite-123'));
      expect(widget.existingFavs, equals(['fav1', 'fav2', 'fav3']));
    });

    test('ProductView widget properties are correctly assigned', () {
      const favIndex = 'test-fav-index';
      const existingFavs = ['fav1', 'fav2'];

      final widget = ProductView.favoriteMode(
        favIndex: favIndex,
        existingFavs: existingFavs,
      );

      expect(widget.favIndex, equals(favIndex));
      expect(widget.existingFavs, equals(existingFavs));
    });

    test('ProductView normalMode creates widget with null favIndex', () {
      final widget = ProductView.normalMode();

      expect(widget.favIndex, isNull);
      expect(widget.existingFavs, isEmpty);
    });

    test('ProductView favoriteMode creates widget with provided values', () {
      const favIndex = 'my-favorite';
      const existingFavs = ['existing-fav'];

      final widget = ProductView.favoriteMode(
        favIndex: favIndex,
        existingFavs: existingFavs,
      );

      expect(widget.favIndex, equals(favIndex));
      expect(widget.existingFavs, equals(existingFavs));
    });

    test('ProductView class exists and is accessible', () {
      expect(ProductView, isNotNull);
    });

    test('ProductView normalMode with key', () {
      const key = Key('product-view-key');
      final widget = ProductView.normalMode(key: key);

      expect(widget.key, equals(key));
      expect(widget.favIndex, isNull);
    });

    test('ProductView favoriteMode with key', () {
      const key = Key('product-view-fav-key');
      final widget = ProductView.favoriteMode(
        key: key,
        favIndex: 'test-fav',
        existingFavs: ['fav1'],
      );

      expect(widget.key, equals(key));
      expect(widget.favIndex, equals('test-fav'));
    });

    test('ProductView favoriteMode with empty existingFavs', () {
      final widget = ProductView.favoriteMode(
        favIndex: 'fav-index',
        existingFavs: [],
      );

      expect(widget.favIndex, equals('fav-index'));
      expect(widget.existingFavs, isEmpty);
    });

    test('ProductView favoriteMode with many existingFavs', () {
      final existingFavs = List<String>.generate(100, (i) => 'fav-$i');
      final widget = ProductView.favoriteMode(
        favIndex: 'fav-index',
        existingFavs: existingFavs,
      );

      expect(widget.existingFavs.length, equals(100));
      expect(widget.existingFavs.first, equals('fav-0'));
      expect(widget.existingFavs.last, equals('fav-99'));
    });

    test('ProductView can create state', () {
      final widget = ProductView.normalMode();

      expect(widget.createState, isNotNull);
    });

    test('ProductView is a StatefulWidget', () {
      final widget = ProductView.normalMode();

      expect(widget, isA<StatefulWidget>());
    });
  });

  group('ViewMode Enum Tests', () {
    test('ViewMode enum has correct values', () {
      expect(ViewMode.values, contains(ViewMode.products));
      expect(ViewMode.values, contains(ViewMode.stocks));
      expect(ViewMode.values.length, equals(2));

      expect(ViewMode.products.toString(), contains('products'));
      expect(ViewMode.stocks.toString(), contains('stocks'));
    });

    test('ViewMode enum can be accessed', () {
      expect(ViewMode.products, isNotNull);
      expect(ViewMode.stocks, isNotNull);
    });

    test('ViewMode enum values are distinct', () {
      expect(ViewMode.products != ViewMode.stocks, isTrue);
    });

    test('ViewMode enum index values are correct', () {
      expect(ViewMode.products.index, equals(0));
      expect(ViewMode.stocks.index, equals(1));
    });

    test('ViewMode enum name property', () {
      expect(ViewMode.products.name, equals('products'));
      expect(ViewMode.stocks.name, equals('stocks'));
    });

    test('ViewMode values can be iterated', () {
      final modes = <ViewMode>[];
      for (final mode in ViewMode.values) {
        modes.add(mode);
      }
      expect(modes.length, equals(2));
      expect(modes, containsAll([ViewMode.products, ViewMode.stocks]));
    });

    test('ViewMode can be used in switch statement', () {
      String getModeName(ViewMode mode) {
        switch (mode) {
          case ViewMode.products:
            return 'Products View';
          case ViewMode.stocks:
            return 'Stocks View';
        }
      }

      expect(getModeName(ViewMode.products), equals('Products View'));
      expect(getModeName(ViewMode.stocks), equals('Stocks View'));
    });

    test('ViewMode equality comparison', () {
      expect(ViewMode.products == ViewMode.products, isTrue);
      expect(ViewMode.stocks == ViewMode.stocks, isTrue);
      expect(ViewMode.products == ViewMode.stocks, isFalse);
    });

    test('ViewMode hashCode is consistent', () {
      expect(ViewMode.products.hashCode, equals(ViewMode.products.hashCode));
      expect(ViewMode.stocks.hashCode, equals(ViewMode.stocks.hashCode));
    });

    test('ViewMode values list is immutable behavior', () {
      final values1 = ViewMode.values;
      final values2 = ViewMode.values;
      expect(values1.length, equals(values2.length));
    });
  });
}
