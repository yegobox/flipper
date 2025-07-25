import 'dart:async';

import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/view_models/coreViewModel.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_services/proxy.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

void main() {
  group('Purchase with Variants', () {
    late TestEnvironment env;
    late MockDatabaseSync mockDbSync;
    late MockBox mockBox;
    late MockTaxApi mockTaxApi;
    late CoreViewModel coreViewModel;

    // Helper function to create a test variant
    Variant _createTestVariant({
      String id = "test_variant",
      String name = "Test Variant",
      String pchsSttsCd = "01",
      int branchId = 1,
      double currentStock = 15.0,
      double retailPrice = 150.0,
      double supplyPrice = 120.0,
    }) {
      return Variant(
        id: id,
        name: name,
        pchsSttsCd: pchsSttsCd,
        branchId: branchId,
        stock: Stock(
            id: "${id}_stock", currentStock: currentStock, branchId: branchId),
        retailPrice: retailPrice,
        supplyPrice: supplyPrice,
      );
    }

    // Helper function to create a test purchase
    Purchase _createTestPurchase({
      String id = "test_purchase",
      int branchId = 1,
      required List<Variant> variants,
    }) {
      return Purchase(
        id: id,
        createdAt: DateTime.now(),
        totTaxAmt: 1,
        totAmt: 1,
        totTaxblAmt: 1,
        spplrTin: "1",
        spplrNm: "Test Supplier",
        spplrBhfId: "00",
        rcptTyCd: "P",
        pmtTyCd: "C",
        cfmDt: DateTime.now().toIso8601String(),
        salesDt: DateTime.now().toIso8601String(),
        totItemCnt: variants.length,
        taxblAmtA: 0.0,
        taxblAmtB: 0.0,
        taxblAmtC: 0.0,
        taxblAmtD: 0.0,
        taxRtA: 0.0,
        taxRtB: 0.0,
        taxRtC: 0.0,
        taxRtD: 0.0,
        taxAmtA: 0.0,
        taxAmtB: 0.0,
        taxAmtC: 0.0,
        taxAmtD: 0.0,
        spplrInvcNo: 1,
        branchId: branchId,
        variants: variants,
      );
    }

    setUpAll(() async {
      env = TestEnvironment();
      await env.init();
    });

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();
      mockDbSync = env.mockDbSync;
      mockBox = env.mockBox;
      mockTaxApi = env.mockTaxApi;
      coreViewModel = CoreViewModel();
    });

    tearDown(() {
      env.restore();
    });

    test('#get variants with taxTyCds A, B, C', () async {
      when(() => mockDbSync.variants(
            branchId: any(named: 'branchId'),
            taxTyCds: any(named: 'taxTyCds'),
          )).thenAnswer((_) async => [_createTestVariant()]);

      final variants = await ProxyService.strategy
          .variants(branchId: 1, taxTyCds: ['A', 'B', 'C']);

      expect(variants, isA<List<Variant>>());
      expect(variants.length, 1);
    });

    test('#get variants with taxTyCds D', () async {
      when(() => mockDbSync.variants(
                branchId: any(named: 'branchId'),
                taxTyCds: any(named: 'taxTyCds'),
              ))
          .thenAnswer((_) async =>
              [_createTestVariant(id: "variant_d", name: "Variant D")]);

      final variants =
          await ProxyService.strategy.variants(branchId: 1, taxTyCds: ['D']);

      expect(variants, isA<List<Variant>>());
      expect(variants.length, 1);
      expect(variants.first.id, "variant_d");
    });

    // Tests that acceptPurchase correctly approves a purchase and updates the variant status.
    // - Verifies that the tax API's savePurchases is called with correct details.
    // - Ensures that the variant's purchase status code (pchsSttsCd) is updated to '02' (approved).
    test(
        '#acceptPurchase should approve the purchase and update variant status',
        () async {
      final testVariant = _createTestVariant();
      final testPurchase = _createTestPurchase(variants: [testVariant]);

      // Stub specific methods for this test
      when(() => mockTaxApi.savePurchases(
                item: any(named: 'item'),
                business: any(named: 'business'),
                variants: any(named: 'variants'),
                bhfId: any(named: 'bhfId'),
                rcptTyCd: any(named: 'rcptTyCd'),
                URI: any(named: 'URI'),
                pchsSttsCd: any(named: 'pchsSttsCd'),
              ))
          .thenAnswer((_) async =>
              RwApiResponse(resultCd: "000", resultMsg: "Success"));

      when(() => mockDbSync.updateVariant(
            updatables: any(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).thenAnswer((_) async => 1);

      when(() => mockDbSync.updateIoFunc(
            variant: any(named: 'variant'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
          )).thenAnswer((_) async => 1);

      // Act
      await coreViewModel.acceptPurchase(
        pchsSttsCd: "02",
        purchases: [],
        purchase: testPurchase,
        itemMapper: {},
      );

      // Assert
      verify(() => mockTaxApi.savePurchases(
            item: testPurchase,
            business: any(named: 'business'),
            variants: [testVariant],
            bhfId: "00",
            rcptTyCd: "P",
            URI: "https://test.flipper.rw",
            pchsSttsCd: "02",
          )).called(1);

      final capturedUpdateVariant = verify(() => mockDbSync.updateVariant(
            updatables: captureAny(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).captured;

      expect(capturedUpdateVariant.length, greaterThanOrEqualTo(1));
      final updatedVariant =
          (capturedUpdateVariant.first as List<Variant>).first;
      expect(updatedVariant.pchsSttsCd, "02");
    });

    // Tests that acceptPurchase correctly handles variant mappings.
    // - Verifies that getVariant is called to retrieve the existing variant.
    // - Ensures that updateStock is called to merge the stock of the incoming variant with the existing mapped variant.
    test('#acceptPurchase should handle variant mappings', () async {
      final incomingVariant = _createTestVariant();
      final testPurchase = _createTestPurchase(variants: [incomingVariant]);
      final itemMapper = {
        "existing_variant_1": incomingVariant,
      };

      // Stub getVariant to return a different existing variant
      when(() => mockDbSync.getVariant(id: "existing_variant_1")).thenAnswer(
        (_) async => _createTestVariant(
          id: "existing_variant_1",
          currentStock: 5.0, // Different stock to test merging
        ),
      );

      // Stub updateStock for the variant mapping scenario
      when(() => mockDbSync.updateStock(
            stockId: any(named: 'stockId'),
            appending: any(named: 'appending'),
            rsdQty: any(named: 'rsdQty'),
            initialStock: any(named: 'initialStock'),
            currentStock: any(named: 'currentStock'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      // Act
      await coreViewModel.acceptPurchase(
        pchsSttsCd: "02",
        purchases: [],
        purchase: testPurchase,
        itemMapper: itemMapper,
      );

      // Assert
      verify(() => mockDbSync.getVariant(id: "existing_variant_1")).called(1);
      verify(() => mockDbSync.updateStock(
            stockId: "existing_variant_1_stock",
            appending: true,
            rsdQty: 15.0,
            initialStock: 15.0,
            currentStock: 15.0,
            value: 15.0 * 150.0,
          )).called(1);
    });

    test('#addCustomer should call strategy with correct customer data',
        () async {
      // Stub addCustomer
      when(() => mockDbSync.addCustomer(
            customer: any(named: 'customer'),
            transactionId: any(named: 'transactionId'),
          )).thenAnswer((_) async => null);

      // Act
      await coreViewModel.addCustomer(
        email: 'test@example.com',
        phone: '1234567890',
        name: 'Test Customer',
        transactionId: 'txn_1',
        customerType: 'B2C',
      );

      // Assert
      final verification = verify(() => mockDbSync.addCustomer(
            customer: captureAny(named: 'customer'),
            transactionId: 'txn_1',
          ));
      verification.called(1);

      final capturedCustomer = verification.captured.first as Customer;
      expect(capturedCustomer.custNm, 'Test Customer');
      expect(capturedCustomer.telNo, '1234567890');
      expect(capturedCustomer.email, 'test@example.com');
      expect(capturedCustomer.customerType, 'B2C');
      expect(capturedCustomer.branchId, 1);
      expect(capturedCustomer.bhfId, '00');
    });

    // Add more test cases here following the same pattern
    // Tests that acceptPurchase correctly handles an empty variant list.
    // - Verifies that the tax API's savePurchases is never called.
    // - Ensures that no variant updates are attempted.
    test('#acceptPurchase should handle empty variant list', () async {
      // Create a purchase with empty variants list
      final emptyPurchase = _createTestPurchase(variants: []);

      // Clear any previous interactions
      clearInteractions(mockTaxApi);
      clearInteractions(mockDbSync);

      // Act
      await coreViewModel.acceptPurchase(
        pchsSttsCd: "02",
        purchases: [],
        purchase: emptyPurchase,
        itemMapper: {},
      );

      // Assert - Verify tax service was not called
      verifyNever(() => mockTaxApi.savePurchases(
            item: any(named: 'item'),
            business: any(named: 'business'),
            variants: any(named: 'variants'),
            bhfId: any(named: 'bhfId'),
            rcptTyCd: any(named: 'rcptTyCd'),
            URI: any(named: 'URI'),
            pchsSttsCd: any(named: 'pchsSttsCd'),
          ));

      // Verify no variant updates were attempted
      verifyNever(() => mockDbSync.updateVariant(
            updatables: any(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          ));
    });

    // Tests that acceptPurchase correctly handles tax service failure and rolls back changes.
    // - Verifies that a PurchaseAcceptanceException is thrown when the tax service fails.
    // - Ensures that no database updates are made if the tax service reporting fails.
    test(
        '#acceptPurchase should handle tax service failure and rollback changes',
        () async {
      final testVariant = _createTestVariant();
      final testPurchase = _createTestPurchase(variants: [testVariant]);

      // Clear previous interactions
      clearInteractions(mockDbSync);
      clearInteractions(mockTaxApi);

      // Setup mock to return an error response immediately
      when(() => mockTaxApi.savePurchases(
                item: any(named: 'item'),
                business: any(named: 'business'),
                variants: any(named: 'variants'),
                bhfId: any(named: 'bhfId'),
                rcptTyCd: any(named: 'rcptTyCd'),
                URI: any(named: 'URI'),
                pchsSttsCd: any(named: 'pchsSttsCd'),
              ))
          .thenAnswer(
              (_) async => RwApiResponse(resultCd: "500", resultMsg: "Error"));

      // Act & Assert
      await expectLater(
        () async {
          await coreViewModel.acceptPurchase(
            pchsSttsCd: "02",
            purchases: [],
            purchase: testPurchase,
            itemMapper: {},
          );
        },
        throwsA(isA<PurchaseAcceptanceException>()),
      );

      // Verify the call was made
      verify(() => mockTaxApi.savePurchases(
            item: testPurchase,
            business: any(named: 'business'),
            variants: [testVariant],
            bhfId: "00",
            rcptTyCd: "P",
            URI: "https://test.flipper.rw",
            pchsSttsCd: "02",
          )).called(1);

      // Verify no database updates were made
      verifyNever(() => mockDbSync.updateVariant(
            updatables: any(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          ));
    });

    test('#updateVariant should call strategy with correct variant data',
        () async {
      final testVariant =
          _createTestVariant(id: "variant_to_update", name: "Updated Variant");

      // Stub updateVariant
      when(() => mockDbSync.updateVariant(
            updatables: any(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).thenAnswer((_) async => 1);

      // Act
      await ProxyService.strategy.updateVariant(
        updatables: [testVariant],
        purchase: null,
        approvedQty: null,
        invoiceNumber: null,
        updateIo: false,
      );

      // Assert
      final verification = verify(() => mockDbSync.updateVariant(
            updatables: captureAny(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          ));
      verification.called(1);

      final capturedUpdatables = verification.captured.first as List<Variant>;
      expect(capturedUpdatables.length, 1);
      expect(capturedUpdatables.first.id, "variant_to_update");
    });

    // Tests that updateIoFunc is called when a new variant is processed during purchase acceptance.
    // - Simulates a successful purchase acceptance that triggers the _processNewVariant logic.
    // - Verifies that mockDbSync.updateIoFunc is called exactly once with the correct variant, purchase, and approvedQty.
    test('#acceptPurchase calls updateIoFunc for new variants', () async {
      final testVariant = _createTestVariant();
      final testPurchase = _createTestPurchase(variants: [testVariant]);

      // Stub specific methods for this test
      when(() => mockTaxApi.savePurchases(
                item: any(named: 'item'),
                business: any(named: 'business'),
                variants: any(named: 'variants'),
                bhfId: any(named: 'bhfId'),
                rcptTyCd: any(named: 'rcptTyCd'),
                URI: any(named: 'URI'),
                pchsSttsCd: any(named: 'pchsSttsCd'),
              ))
          .thenAnswer((_) async =>
              RwApiResponse(resultCd: "000", resultMsg: "Success"));

      when(() => mockDbSync.updateVariant(
            updatables: any(named: 'updatables'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).thenAnswer((_) async => 1);

      when(() => mockDbSync.updateIoFunc(
            variant: any(named: 'variant'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
          )).thenAnswer((_) async => 1);

      // Act
      await coreViewModel.acceptPurchase(
        pchsSttsCd: "02",
        purchases: [],
        purchase: testPurchase,
        itemMapper: {},
      );

      // Assert that updateIoFunc was called exactly once
      verify(() => mockDbSync.updateIoFunc(
            variant: testVariant,
            purchase: testPurchase,
            approvedQty: testVariant.stock?.currentStock,
          )).called(1);
    });
  });
}
