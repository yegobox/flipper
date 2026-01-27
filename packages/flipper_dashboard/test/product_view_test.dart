import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
      const key = Key('test-key');
      const favIndex = 'test-fav-index';
      const existingFavs = ['fav1', 'fav2'];
      
      final widget = ProductView.favoriteMode(
        key: key,
        favIndex: favIndex,
        existingFavs: existingFavs,
      );
      
      expect(widget.key, equals(key));
      expect(widget.favIndex, equals(favIndex));
      expect(widget.existingFavs, equals(existingFavs));
    });

    test('ProductView normalMode creates widget with null favIndex', () {
      const key = Key('normal-mode-key');
      
      final widget = ProductView.normalMode(key: key);
      
      expect(widget.key, equals(key));
      expect(widget.favIndex, isNull);
      expect(widget.existingFavs, isEmpty);
    });

    test('ProductView favoriteMode creates widget with provided values', () {
      const key = Key('favorite-mode-key');
      const favIndex = 'my-favorite';
      const existingFavs = ['existing-fav'];
      
      final widget = ProductView.favoriteMode(
        key: key,
        favIndex: favIndex,
        existingFavs: existingFavs,
      );
      
      expect(widget.key, equals(key));
      expect(widget.favIndex, equals(favIndex));
      expect(widget.existingFavs, equals(existingFavs));
    });

    test('ViewMode enum has correct values', () {
      expect(ViewMode.values, contains(ViewMode.products));
      expect(ViewMode.values, contains(ViewMode.stocks));
      expect(ViewMode.values.length, equals(2));
      
      expect(ViewMode.products.toString(), contains('products'));
      expect(ViewMode.stocks.toString(), contains('stocks'));
    });

    testWidgets('ProductView builds without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ProductView.normalMode(),
          ),
        ),
      );

      // Verify that the widget builds without throwing
      expect(find.byType(ProductView), findsOneWidget);
    });

    testWidgets('ProductView in favorite mode builds without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ProductView.favoriteMode(
              favIndex: 'test-fav',
              existingFavs: ['existing'],
            ),
          ),
        ),
      );

      expect(find.byType(ProductView), findsOneWidget);
    });

    test('ProductView class exists and is instantiable', () {
      expect(ProductView, isNotNull);
    });

    test('ViewMode enum can be accessed', () {
      expect(ViewMode.products, isNotNull);
      expect(ViewMode.stocks, isNotNull);
    });
  });
}