import 'package:flipper_models/CoreSync.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';
// import 'test_helpers/turbo_tax_test_environment.dart';

// flutter test test/api_test.dart  --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
    registerFallbackValue(OfflineFirstGetPolicy.localOnly);
    registerFallbackValue(Query(where: []));
  });
  group('Purchase with Variants', () {
    late MockDatabaseSync mockDbSync;
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

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();
      mockDbSync = env.mockDbSync;
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

    // Tests that acceptPurchase correctly handles service items with code 3 after country code
    // - Verifies that service items (code 3) are processed without stock assignment
    // - Ensures a new itemCd is generated for service items
    // - Works with any two-character country code
    test('#acceptPurchase should handle service items with code 3 correctly',
        () async {
      // Create a service variant with itemCd starting with any two-character country code followed by 3
      final serviceVariant = _createTestVariant(
        id: "service_variant",
        name: "Service Item",
        currentStock: 0.0, // Services don't have stock
      );
      serviceVariant.itemCd =
          "KE3NTNO0001776"; // Service item code with different country code

      final testPurchase = _createTestPurchase(variants: [serviceVariant]);

      // Stub itemCode to verify it's called for service items
      when(() => mockDbSync.itemCode(
            countryCode: any(named: 'countryCode'),
            productType: any(named: 'productType'),
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).thenAnswer((_) async => "KE3NTNO0001777"); // New itemCd

      // Stub other required methods
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
            variants: [serviceVariant],
            bhfId: "00",
            rcptTyCd: "P",
            URI: "https://test.flipper.rw",
            pchsSttsCd: "02",
          )).called(1);

      // Verify itemCode was called to generate a new itemCd for the service item
      verify(() => mockDbSync.itemCode(
            countryCode: "KE",
            productType: "3",
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).called(1);

      // Verify updateVariant was called with null approvedQty for the service item
      verify(() => mockDbSync.updateVariant(
            updatables: [serviceVariant],
            purchase: testPurchase,
            approvedQty:
                null, // Key assertion: no stock assignment for services
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).called(1);

      // Verify updateIoFunc was called with null approvedQty
      verify(() => mockDbSync.updateIoFunc(
            variant: serviceVariant,
            purchase: testPurchase,
            approvedQty:
                null, // Key assertion: no stock assignment for services
          )).called(1);

      // Verify the itemCd was updated
      expect(serviceVariant.itemCd, "KE3NTNO0001777");
    });

    // Tests that acceptPurchase correctly handles service items with different country codes
    test(
        '#acceptPurchase should handle service items with different country codes',
        () async {
      // Create two service variants with different country codes
      final rwServiceVariant = _createTestVariant(
        id: "rw_service_variant",
        name: "RW Service Item",
        currentStock: 0.0,
      );
      rwServiceVariant.itemCd = "RW3NTNO0001776";

      final ugServiceVariant = _createTestVariant(
        id: "ug_service_variant",
        name: "UG Service Item",
        currentStock: 0.0,
      );
      ugServiceVariant.itemCd = "UG3NTNO0001777";

      final testPurchase =
          _createTestPurchase(variants: [rwServiceVariant, ugServiceVariant]);

      // Stub itemCode to verify it's called for service items with different country codes
      when(() => mockDbSync.itemCode(
            countryCode: "RW",
            productType: "3",
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).thenAnswer((_) async => "RW3NTNO0001778");

      when(() => mockDbSync.itemCode(
            countryCode: "UG",
            productType: "3",
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).thenAnswer((_) async => "UG3NTNO0001779");

      // Stub other required methods
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

      // Verify itemCode was called for both service variants with their respective country codes
      verify(() => mockDbSync.itemCode(
            countryCode: "RW",
            productType: "3",
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).called(1);

      verify(() => mockDbSync.itemCode(
            countryCode: "UG",
            productType: "3",
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).called(1);

      // Verify both service variants were processed with 0 approvedQty
      verify(() => mockDbSync.updateVariant(
            updatables: [rwServiceVariant],
            purchase: testPurchase,
            approvedQty: null,
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).called(1);

      verify(() => mockDbSync.updateVariant(
            updatables: [ugServiceVariant],
            purchase: testPurchase,
            approvedQty: null,
            invoiceNumber: any(named: 'invoiceNumber'),
            updateIo: any(named: 'updateIo'),
          )).called(1);

      // Verify the itemCds were updated
      expect(rwServiceVariant.itemCd, "RW3NTNO0001778");
      expect(ugServiceVariant.itemCd, "UG3NTNO0001779");
    });

    // Tests that acceptPurchase correctly extracts all components from itemCd
    test(
        '#acceptPurchase should extract all components from itemCd for new variants',
        () async {
      // Create a variant with a complete itemCd format
      final variant = _createTestVariant(
        id: "test_variant_with_complete_itemcd",
        name: "Test Variant with Complete ItemCd",
      );
      variant.itemCd =
          "UG2NTBA0000123"; // Country: UG, Type: 2, Packaging: NT, Quantity: BA

      final testPurchase = _createTestPurchase(variants: [variant]);

      // Mock itemCode to verify extracted components are passed correctly
      when(() => mockDbSync.itemCode(
            countryCode: any(named: 'countryCode'),
            productType: any(named: 'productType'),
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).thenAnswer((_) async => "UG2NTBA0000124");

      // Stub other required methods
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

      // Verify itemCode was called with the extracted components
      verify(() => mockDbSync.itemCode(
            countryCode: "UG", // Extracted from UG2NTBA0000123
            productType: "2", // Extracted from UG2NTBA0000123
            packagingUnit: "NT", // Extracted from UG2NTBA0000123
            quantityUnit: "BA", // Extracted from UG2NTBA0000123
            branchId: any(named: 'branchId'),
          )).called(1);
    });
  });

  group('Plan Management', () {
    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();
    });

    tearDown(() {
      env.restore();
    });

    Plan _createPlan({
      required String id,
      required bool isPaid,
      required DateTime createdAt,
    }) {
      return Plan(
        id: id,
        businessId: '1',
        paymentCompletedByUser: isPaid,
        createdAt: createdAt,
      );
    }

    test('keeps most recent paid plan when multiple plans exist', () async {
      final paidPlanRecent = _createPlan(
        id: 'paid_recent',
        isPaid: true,
        createdAt: DateTime.now(),
      );
      final paidPlanOld = _createPlan(
        id: 'paid_old',
        isPaid: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      final unpaidPlan = _createPlan(
        id: 'unpaid',
        isPaid: false,
        createdAt: DateTime.now(),
      );

      final mockRepository = MockRepository();
      when(() => mockRepository.get<Plan>(query: any(named: 'query')))
          .thenAnswer((_) async => [paidPlanRecent, paidPlanOld, unpaidPlan]);
      when(() => mockRepository.delete<Plan>(any()))
          .thenAnswer((_) async => true);

      final coreSync = CoreSync();
      // Replace the real repository with our mock
      coreSync.repository = mockRepository;

      await coreSync.cleanDuplicatePlans();

      final captured = verify(() => mockRepository.delete<Plan>(captureAny()))
          .captured
          .cast<Plan>();

      expect(captured.length, 2);
      expect(captured.any((p) => p.id == 'paid_old'), isTrue);
      expect(captured.any((p) => p.id == 'unpaid'), isTrue);
    });

    test('keeps most recent unpaid plan when only unpaid plans exist',
        () async {
      final unpaidPlanRecent = _createPlan(
        id: 'unpaid_recent',
        isPaid: false,
        createdAt: DateTime.now(),
      );
      final unpaidPlanOld = _createPlan(
        id: 'unpaid_old',
        isPaid: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      final mockRepository = MockRepository();
      when(() => mockRepository.get<Plan>(query: any(named: 'query')))
          .thenAnswer((_) async => [unpaidPlanRecent, unpaidPlanOld]);
      when(() => mockRepository.delete<Plan>(any()))
          .thenAnswer((_) async => true);

      final coreSync = CoreSync();
      coreSync.repository = mockRepository;

      await coreSync.cleanDuplicatePlans();

      final captured = verify(() => mockRepository.delete<Plan>(captureAny()))
          .captured
          .cast<Plan>();

      expect(captured.length, 1);
      expect(captured.first.id, 'unpaid_old');
    });

    test('does nothing when only one plan exists', () async {
      final singlePlan = _createPlan(
        id: 'single',
        isPaid: true,
        createdAt: DateTime.now(),
      );
      final mockRepository = MockRepository();

      when(() => mockRepository.get<Plan>(query: any(named: 'query')))
          .thenAnswer((_) async => [singlePlan]);

      final coreSync = CoreSync();
      coreSync.repository = mockRepository;

      await coreSync.cleanDuplicatePlans();

      verifyNever(() => mockRepository.delete<Plan>(any()));
    });

    test('does nothing when no plans exist', () async {
      final mockRepository = MockRepository();
      when(() => mockRepository.get<Plan>(query: any(named: 'query')))
          .thenAnswer((_) async => []);

      final coreSync = CoreSync();
      coreSync.repository = mockRepository;

      await coreSync.cleanDuplicatePlans();

      verifyNever(() => mockRepository.delete<Plan>(any()));
    });

    test('loads plan for a given business', () async {
      final businessId = 'test_business_id';
      final expectedPlan = _createPlan(
        id: 'plan_for_business',
        isPaid: true,
        createdAt: DateTime.now(),
      );
      expectedPlan.businessId = businessId;

      final mockRepository = MockRepository();
      when(() => mockRepository.get<Plan>(
              query: Query.where('businessId', businessId),
              policy: any(named: 'policy')))
          .thenAnswer((_) async => [expectedPlan]);

      final mockBox = MockBox();
      when(() => mockBox.getBusinessId())
          .thenReturn(1); // Mock a business ID for ProxyService.box

      final coreSync = CoreSync();
      coreSync.repository = mockRepository;

      final result = await coreSync.getPaymentPlan(businessId: businessId);

      expect(result, isA<Plan>());
      expect(result?.id, expectedPlan.id);
      expect(result?.businessId, expectedPlan.businessId);
    });
  });
  group('Transaction Date Filtering', () {
    late MockDatabaseSync mockDbSync;

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();
      mockDbSync = env.mockDbSync;
    });

    tearDown(() {
      env.restore();
    });

    test('#transactions should return ITransaction objects not timestamps',
        () async {
      final targetDate = DateTime(2025, 7, 29);
      final mockTransactions = [
        ITransaction(
          id: 'txn_1',
          lastTouched: DateTime(2025, 7, 29, 8, 30, 0),
          branchId: 1,
          status: 'complete',
          subTotal: 100.0,
          isOriginalTransaction: true,
          isExpense: false,
          transactionType: 'sale',
          paymentType: 'Cash',
          cashReceived: 100,
          customerChangeDue: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isIncome: true,
        ),
      ];

      when(() => mockDbSync.transactions(
            startDate: targetDate,
            endDate: targetDate,
            status: null,
            transactionType: null,
            branchId: 1,
            isCashOut: false,
            fetchRemote: false,
            id: null,
            isExpense: false,
            filterType: null,
            includeZeroSubTotal: false,
            includePending: false,
            skipOriginalTransactionCheck: false,
            forceRealData: true,
            receiptNumber: null,
          )).thenAnswer((_) async => mockTransactions);

      final result = await ProxyService.strategy.transactions(
        startDate: targetDate,
        endDate: targetDate,
        branchId: 1,
      );

      expect(result, isA<List<ITransaction>>());
      expect(result.length, 1);
      expect(result.first.id, 'txn_1');
      expect(result.first.lastTouched, isA<DateTime>());
    });

    test('#transactions should handle date filtering correctly', () async {
      final startDate = DateTime(2025, 7, 29);
      final endDate = DateTime(2025, 7, 30);

      when(() => mockDbSync.transactions(
            startDate: startDate,
            endDate: endDate,
            status: null,
            transactionType: null,
            branchId: 1,
            isCashOut: false,
            fetchRemote: false,
            id: null,
            isExpense: false,
            filterType: null,
            includeZeroSubTotal: false,
            includePending: false,
            skipOriginalTransactionCheck: false,
            forceRealData: true,
            receiptNumber: null,
          )).thenAnswer((_) async => []);

      await ProxyService.strategy.transactions(
        startDate: startDate,
        endDate: endDate,
        branchId: 1,
      );

      verify(() => mockDbSync.transactions(
            startDate: startDate,
            endDate: endDate,
            status: null,
            transactionType: null,
            branchId: 1,
            isCashOut: false,
            fetchRemote: false,
            id: null,
            isExpense: false,
            filterType: null,
            includeZeroSubTotal: false,
            includePending: false,
            skipOriginalTransactionCheck: false,
            forceRealData: true,
            receiptNumber: null,
          )).called(1);
    });
    test('#transactionsStream should handle date filtering', () async {
      final startDate = DateTime(2025, 7, 29);
      final endDate = DateTime(2025, 7, 30);

      when(() => mockDbSync.transactionsStream(
            startDate: startDate,
            endDate: endDate,
            status: null,
            transactionType: null,
            branchId: 1,
            isCashOut: false,
            id: null,
            removeAdjustmentTransactions: false,
            filterType: null,
            includePending: false,
            forceRealData: true,
            skipOriginalTransactionCheck: false,
          )).thenAnswer((_) => Stream.value([
            ITransaction(
              id: 'stream_txn_1',
              lastTouched: DateTime(2025, 7, 29, 12, 0, 0),
              branchId: 1,
              status: 'complete',
              subTotal: 100.0,
              isOriginalTransaction: true,
              isExpense: false,
              transactionType: 'sale',
              paymentType: 'Cash',
              cashReceived: 100,
              customerChangeDue: 0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isIncome: true,
            ),
          ]));

      final stream = ProxyService.strategy.transactionsStream(
        startDate: startDate,
        endDate: endDate,
        branchId: 1,
        removeAdjustmentTransactions: false,
        skipOriginalTransactionCheck: false,
      );

      final result = await stream.first;
      expect(result.length, 1);
      expect(result.first.id, 'stream_txn_1');
    });
  });
}
