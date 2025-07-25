import 'package:flipper_dashboard/PurchaseTable.dart';
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'purchases_test.dart';

class MockTalker extends Mock implements Talker {}

// flutter test test/
// Helper function to create a test purchase
MockPurchase _createMockPurchase({
  String id = "test_purchase_id",
  String spplrNm = "Test Supplier",
  int spplrInvcNo = 1,
  double totAmt = 0.0,
  List<Variant>? variants,
  DateTime? createdAt,
}) {
  final mockPurchase = MockPurchase();
  when(() => mockPurchase.id).thenReturn(id);
  when(() => mockPurchase.spplrNm).thenReturn(spplrNm);
  when(() => mockPurchase.spplrInvcNo).thenReturn(spplrInvcNo);
  when(() => mockPurchase.createdAt).thenReturn(createdAt ?? DateTime.now());
  when(() => mockPurchase.totAmt).thenReturn(totAmt);
  when(() => mockPurchase.variants).thenReturn(variants ?? []);
  return mockPurchase;
}

// Helper function to create a test variant
MockVariant _createMockVariant({
  String id = "test_variant_id",
  String name = "Test Variant",
  String pchsSttsCd = "01",
}) {
  final mockVariant = MockVariant();
  when(() => mockVariant.id).thenReturn(id);
  when(() => mockVariant.name).thenReturn(name);
  when(() => mockVariant.pchsSttsCd).thenReturn(pchsSttsCd);
  return mockVariant;
}

void main() {
  group('PurchaseTable Widget', () {
    late MockTextEditingController mockNameController;
    late MockTextEditingController mockSupplyPriceController;
    late MockTextEditingController mockRetailPriceController;
    late MockSaveItemName mockSaveItemName;
    late MockAcceptPurchases mockAcceptPurchases;
    late MockSelectSale mockSelectSale;
    late List<Variant> mockVariants;
    late List<Purchase> mockPurchases;
    late MockTalker mockTalker;

    setUpAll(() async {
      await initializeDependenciesForTest();
    });

    setUp(() {
      mockNameController = MockTextEditingController();
      mockSupplyPriceController = MockTextEditingController();
      mockRetailPriceController = MockTextEditingController();
      mockSaveItemName = MockSaveItemName();
      mockAcceptPurchases = MockAcceptPurchases();
      mockSelectSale = MockSelectSale();
      mockTalker = MockTalker();

      mockVariants = [
        _createMockVariant(
            id: 'variant_id_1', name: 'Variant A', pchsSttsCd: '01'),
        _createMockVariant(
            id: 'variant_id_2', name: 'Variant B', pchsSttsCd: '01'),
      ];
      mockPurchases = [
        _createMockPurchase(
          id: 'purchase_id_1',
          spplrNm: 'Supplier A',
          spplrInvcNo: 1001,
          totAmt: 500.0,
          variants: [
            _createMockVariant(
                id: 'variant_in_purchase_1',
                name: 'Variant X',
                pchsSttsCd: '01')
          ],
        ),
        _createMockPurchase(
          id: 'purchase_id_2',
          spplrNm: 'Supplier B',
          spplrInvcNo: 1002,
          totAmt: 750.0,
          variants: [
            _createMockVariant(
                id: 'variant_in_purchase_2',
                name: 'Variant Y',
                pchsSttsCd: '01')
          ],
        ),
      ];

      // Register fallbacks for any() if needed
      registerFallbackValue(_createMockPurchase());
      registerFallbackValue(_createMockVariant());
      registerFallbackValue(<Purchase>[]);
      registerFallbackValue(<Variant>[]);
      registerFallbackValue(StackTrace.current);
      registerFallbackValue(Exception('test exception'));
    });

    testWidgets('should render PurchaseTable with initial state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            variantProvider(branchId: 1).overrideWith(
              (ref) async => mockVariants, // Provide mock variants
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              // Added Scaffold to provide Material ancestor
              body: PurchaseTable(
                nameController: mockNameController,
                supplyPriceController: mockSupplyPriceController,
                retailPriceController: mockRetailPriceController,
                saveItemName: mockSaveItemName.call,
                acceptPurchases: mockAcceptPurchases.call,
                selectSale: mockSelectSale.call,
                variants: mockVariants,
                purchases: mockPurchases,
              ),
            ),
          ),
        ),
      );

      await tester
          .pumpAndSettle(); // Wait for all animations and futures to complete

      expect(find.byType(PurchaseTable), findsOneWidget);
      expect(find.text('Filter by Status'), findsOneWidget);
      expect(find.text('Supplier: Supplier A (1)'), findsOneWidget);
      expect(find.text('Invoice: 1001'), findsOneWidget);
    });

    testWidgets('should filter purchases by status',
        (WidgetTester tester) async {
      // Create a purchase with status '02' (Approved)
      final approvedVariant = _createMockVariant(pchsSttsCd: '02');

      final approvedPurchase = _createMockPurchase(
        id: 'approved_purchase_id',
        spplrNm: 'Approved Supplier',
        spplrInvcNo: 2001,
        totAmt: 300.0,
        variants: [approvedVariant],
      );

      // Add the approved purchase to the list
      mockPurchases.add(approvedPurchase);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            variantProvider(branchId: 1).overrideWith(
              (ref) async => mockVariants,
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: PurchaseTable(
                nameController: mockNameController,
                supplyPriceController: mockSupplyPriceController,
                retailPriceController: mockRetailPriceController,
                saveItemName: mockSaveItemName.call,
                acceptPurchases: mockAcceptPurchases.call,
                selectSale: mockSelectSale.call,
                variants: mockVariants,
                purchases: mockPurchases,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially, only 'Waiting' purchases should be visible (default filter '01')
      expect(find.text('Supplier: Supplier A (1)'), findsOneWidget);
      expect(find.text('Supplier: Approved Supplier (1)'), findsNothing);

      // Change filter to 'Approved'
      await tester.tap(find.byType(DropdownButtonFormField<String?>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Approved').last); // Tap the 'Approved' option
      await tester.pumpAndSettle();

      // Now, only 'Approved' purchases should be visible
      expect(find.text('Supplier: Supplier A (1)'), findsNothing);
      expect(find.text('Supplier: Approved Supplier (1)'), findsOneWidget);
    });
  });
}
