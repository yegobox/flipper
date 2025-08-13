import 'package:flipper_dashboard/features/inventory_dashboard/widgets/expired_items_section.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/models/inventory_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/inventory_dashboard/widgets/expired_items_section_test.dart 
void main() {
  group('ExpiredItemsSection Tests', () {
    late List<InventoryItem> mockExpiredItems;
    late Function(InventoryItem) mockOnDeleteItem;
    late Function(BuildContext, InventoryItem) mockOnViewItemDetails;

    setUp(() {
      mockExpiredItems = [
        InventoryItem(
          id: 'item1',
          name: 'Expired Milk',
          category: 'Dairy',
          quantity: 5,
          expiryDate: DateTime.now().subtract(const Duration(days: 2)),
          location: 'Fridge A',
        ),
      ];

      mockOnDeleteItem = (item) {};
      mockOnViewItemDetails = (context, item) {};
    });

    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: mockExpiredItems,
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.text('Expired Items'), findsOneWidget);
    });

    testWidgets('shows View All button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: mockExpiredItems,
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('displays data table', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: mockExpiredItems,
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('displays expired items data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: mockExpiredItems,
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.text('Expired Milk'), findsOneWidget);
      expect(find.text('Dairy'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: mockExpiredItems,
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('handles empty list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: [],
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.text('Expired Items'), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExpiredItemsSection(
              expiredItems: mockExpiredItems,
              onDeleteItem: mockOnDeleteItem,
              onViewItemDetails: mockOnViewItemDetails,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}