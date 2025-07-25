import 'dart:core';

import 'package:flipper_dashboard/Purchases.dart';
import 'package:flipper_dashboard/PurchaseTable.dart';
import 'package:flipper_models/providers/variants_provider.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/all_models.dart';

// flutter test test/purchases_test.dart --dart-define=FLUTTER_TEST_ENV=true
// Mock classes for dependencies
class MockGlobalKey extends Mock implements GlobalKey<FormState> {}

class MockTextEditingController extends Mock implements TextEditingController {}

class MockVariant extends Mock implements Variant {}

class MockPurchase extends Mock implements Purchase {}

// Mock functions for callbacks
class MockSaveItemName extends Mock {
  void call();
}

class MockAcceptPurchases extends Mock {
  Future<void> call({
    required List<Purchase> purchases,
    required String pchsSttsCd,
    required Purchase purchase,
    Variant? clickedVariant,
  });
}

class MockSelectSale extends Mock {
  void call(Variant? itemToAssign, Variant? itemFromPurchase);
}

void main() {
  group('Purchases Widget', () {
    late MockGlobalKey mockFormKey;
    late MockTextEditingController mockNameController;
    late MockTextEditingController mockSupplyPriceController;
    late MockTextEditingController mockRetailPriceController;
    late MockSaveItemName mockSaveItemName;
    late MockAcceptPurchases mockAcceptPurchases;
    late MockSelectSale mockSelectSale;
    late List<Variant> mockVariants;
    late List<Purchase> mockPurchases;

    setUpAll(() async {
      await initializeDependenciesForTest();
    });
    setUp(() {
      mockFormKey = MockGlobalKey();
      mockNameController = MockTextEditingController();
      mockSupplyPriceController = MockTextEditingController();
      mockRetailPriceController = MockTextEditingController();
      mockSaveItemName = MockSaveItemName();
      mockAcceptPurchases = MockAcceptPurchases();
      mockSelectSale = MockSelectSale();
      mockVariants = [MockVariant(), MockVariant()];
      mockPurchases = [MockPurchase(), MockPurchase()];
      when(() => mockPurchases[0].id).thenReturn('purchase_id_1');
      when(() => mockPurchases[1].id).thenReturn('purchase_id_2');
      when(() => mockPurchases[0].spplrNm).thenReturn('Supplier 1');
      when(() => mockPurchases[1].spplrNm).thenReturn('Supplier 2');
      when(() => mockPurchases[0].spplrInvcNo).thenReturn(123);
      when(() => mockPurchases[1].spplrInvcNo).thenReturn(456);
      when(() => mockPurchases[0].createdAt).thenReturn(DateTime.now());
      when(() => mockPurchases[1].createdAt).thenReturn(DateTime.now());
      when(() => mockPurchases[0].totAmt).thenReturn(100.0);
      when(() => mockPurchases[1].totAmt).thenReturn(200.0);
      when(() => mockPurchases[0].variants).thenReturn([]);
      when(() => mockPurchases[1].variants).thenReturn([]);

      // Register fallbacks for any() if needed, though for simple types it's often automatic
      registerFallbackValue(MockPurchase());
      registerFallbackValue(MockVariant());
      registerFallbackValue([]); // For List<Purchase> and List<Variant>
    });

    testWidgets('should render PurchaseTable', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            variantProvider(branchId: 1).overrideWith(
              (ref) async => <Variant>[],
            ),
          ],
          child: MaterialApp(
            home: Purchases(
              formKey: mockFormKey,
              nameController: mockNameController,
              supplyPriceController: mockSupplyPriceController,
              retailPriceController: mockRetailPriceController,
              saveItemName: mockSaveItemName,
              acceptPurchases: mockAcceptPurchases.call,
              selectSale: mockSelectSale.call,
              variants: mockVariants,
              purchases: mockPurchases,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PurchaseTable), findsOneWidget);
    });

    testWidgets('should pass correct properties to PurchaseTable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            variantProvider(branchId: 1).overrideWith(
              (ref) => <Variant>[], // Provide an empty list of variants
            ),
          ],
          child: MaterialApp(
            home: Purchases(
              formKey: mockFormKey,
              nameController: mockNameController,
              supplyPriceController: mockSupplyPriceController,
              retailPriceController: mockRetailPriceController,
              saveItemName: mockSaveItemName,
              acceptPurchases: mockAcceptPurchases.call,
              selectSale: mockSelectSale.call,
              variants: mockVariants,
              purchases: mockPurchases,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final purchaseTable =
          tester.widget<PurchaseTable>(find.byType(PurchaseTable));

      expect(purchaseTable.purchases, mockPurchases);
      expect(purchaseTable.nameController, mockNameController);
      expect(purchaseTable.supplyPriceController, mockSupplyPriceController);
      expect(purchaseTable.retailPriceController, mockRetailPriceController);
      expect(purchaseTable.saveItemName, mockSaveItemName);
      expect(purchaseTable.acceptPurchases, mockAcceptPurchases.call);
      expect(purchaseTable.selectSale, mockSelectSale.call);
      expect(purchaseTable.variants, mockVariants);
    });
  });
}
