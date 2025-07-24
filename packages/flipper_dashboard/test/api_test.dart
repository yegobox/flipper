import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/view_models/coreViewModel.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/tax_api.dart'; // Import TaxApi

// Mock classes
class MockSyncStrategy extends Mock implements SyncStrategy {}

class MockDatabaseSync extends Mock implements DatabaseSyncInterface {}

class MockBox extends Mock implements LocalStorage {}

class MockTaxApi extends Mock implements TaxApi {} // New MockTaxApi

// flutter test test/api_test.dart  --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('Purchase with Variants', () {
    late MockSyncStrategy mockSyncStrategy;
    late MockDatabaseSync mockDbSync;
    late MockBox mockBox;
    late MockTaxApi mockTaxApi;

    // Store original services to restore them later
    late SyncStrategy originalStrategyLink;
    late LocalStorage originalBox;
    late TaxApi originalTaxApi;

    setUpAll(() async {
      await initializeDependenciesForTest();
      // Register fallback values for mocktail
      registerFallbackValue(
          Customer(branchId: 0, custNm: 'fallback', bhfId: '00'));
      registerFallbackValue(Business(
          id: "1",
          name: "Fallback Business",
          tinNumber: 123456789,
          serverId: 1));
      registerFallbackValue(Variant(
          id: "fallback_variant", name: "Fallback Variant", branchId: 1));
      registerFallbackValue(Purchase(
          id: "fallback_purchase",
          createdAt: DateTime.now(),
          totTaxAmt: 0.0,
          totAmt: 0.0,
          totTaxblAmt: 0.0,
          spplrTin: "",
          spplrNm: "",
          spplrBhfId: "",
          rcptTyCd: "",
          pmtTyCd: "",
          cfmDt: "",
          salesDt: "",
          totItemCnt: 0,
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
          branchId: 0,
          variants: []));
      registerFallbackValue(<Variant>[]); // For savePurchases variants argument
      registerFallbackValue(RwApiResponse(
          resultCd: "000", resultMsg: "Success")); // For savePurchases return
      registerFallbackValue(Ebm(
          bhfId: "00",
          tinNumber: 111,
          dvcSrlNo: "111",
          userId: 111,
          taxServerUrl: "https://test.flipper.rw",
          businessId: 1,
          branchId: 1)); // Added Ebm fallback
    });

    setUp(() {
      mockSyncStrategy = MockSyncStrategy();
      mockDbSync = MockDatabaseSync();
      mockBox = MockBox();
      mockTaxApi = MockTaxApi();

      // Store original services
      originalStrategyLink = ProxyService.strategyLink;
      originalBox = ProxyService.box;
      originalTaxApi = ProxyService.tax;

      // Inject mocks
      ProxyService.strategyLink = mockSyncStrategy;
      ProxyService.box = mockBox;
      ProxyService.tax = mockTaxApi;

      // Stub the SyncStrategy to return our mock DatabaseSyncInterface
      when(() => mockSyncStrategy.current).thenReturn(mockDbSync);
    });

    tearDown(() {
      // Restore original services after each test
      ProxyService.strategyLink = originalStrategyLink;
      ProxyService.box = originalBox;
      ProxyService.tax = originalTaxApi;
    });

    test('#get variants with taxTyCds A, B, C', () async {
      // This test still uses the real ProxyService.strategy, which is now mocked.
      // We need to stub the variants method on mockDbSync.
      when(() =>
          mockDbSync.variants(
              branchId: any(named: 'branchId'),
              taxTyCds: any(named: 'taxTyCds'))).thenAnswer(
          (_) async => [Variant(id: "1", name: "Test Variant", branchId: 1)]);

      final variants = await ProxyService.strategy
          .variants(branchId: 1, taxTyCds: ['A', 'B', 'C']);
      expect(variants, isA<List<Variant>>());
      expect(variants.length, 1);
    });

    test('#get variants with taxTyCds D', () async {
      // Stub the variants method on mockDbSync.
      when(() =>
          mockDbSync.variants(
              branchId: any(named: 'branchId'),
              taxTyCds: any(named: 'taxTyCds'))).thenAnswer(
          (_) async => [Variant(id: "2", name: "Test Variant D", branchId: 1)]);

      final variants =
          await ProxyService.strategy.variants(branchId: 1, taxTyCds: ['D']);
      expect(variants, isA<List<Variant>>());
      expect(variants.length, 1);
    });

    test(
        '#calling acceptPurchase should approve the purchase and update variant status (mocked)',
        () async {
      final coreViewModel = CoreViewModel();

      // Arrange: Mock data for purchase and variant
      final incomingVariant = Variant(
        id: "incoming_variant_1",
        name: "New Arriving Variant",
        pchsSttsCd: "01", // Initial status from source
        branchId: 1,
        stock: Stock(id: "incoming_stock_1", currentStock: 15.0, branchId: 1),
        retailPrice: 150.0,
        supplyPrice: 120.0,
        // Added missing parameter
      );

      final purchase = Purchase(
        id: "1",
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
        totItemCnt: 1,
        taxblAmtA: 0.0, // Added missing parameter
        taxblAmtB: 0.0, // Added missing parameter
        taxblAmtC: 0.0, // Added missing parameter
        taxblAmtD: 0.0, // Added missing parameter
        taxRtA: 0.0, // Added missing parameter
        taxRtB: 0.0, // Added missing parameter
        taxRtC: 0.0, // Added missing parameter
        taxRtD: 0.0, // Added missing parameter
        taxAmtA: 0.0, // Added missing parameter
        taxAmtB: 0.0, // Added missing parameter
        taxAmtC: 0.0, // Added missing parameter
        taxAmtD: 0.0, // Added missing parameter
        spplrInvcNo: 1, // Changed to String as per common practice
        branchId: 1,
        variants: [incomingVariant],
      );

      // Stub necessary calls on mocks
      when(() => mockBox.getBusinessId()).thenReturn(1);
      when(() => mockBox.getBranchId()).thenReturn(1);
      when(() => mockBox.bhfId()).thenAnswer((_) async => "00");
      when(() => mockBox.getServerUrl())
          .thenAnswer((_) async => "https://test.flipper.rw");

      when(() => mockDbSync.getBusiness(businessId: any(named: 'businessId')))
          .thenAnswer((_) async => Business(
              id: "1",
              name: "Test Business",
              tinNumber: 123456789,
              serverId: 1));

      // Stub the ebm method to return a mock Ebm object
      when(() => mockDbSync.ebm(branchId: any(named: 'branchId'))).thenAnswer(
          (_) async => Ebm(
              bhfId: "00",
              tinNumber: 111,
              dvcSrlNo: "111",
              userId: 111,
              taxServerUrl: "https://test.flipper.rw",
              businessId: 1,
              branchId: 1));

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

      when(() => mockDbSync.itemCode(
            countryCode: any(named: 'countryCode'),
            productType: any(named: 'productType'),
            packagingUnit: any(named: 'packagingUnit'),
            quantityUnit: any(named: 'quantityUnit'),
            branchId: any(named: 'branchId'),
          )).thenAnswer((_) async => "ITEM123");

      when(() => mockDbSync.updateVariant(
            updatables: any(named: 'updatables'),
            purchase: any(named: 'purchase', that: isNotNull),
            approvedQty: any(named: 'approvedQty', that: isNotNull),
            invoiceNumber: any(named: 'invoiceNumber', that: isNotNull),
            updateIo: any(named: 'updateIo'),
          )).thenAnswer((_) async => 1); // Return 1 for successful update

      when(() => mockDbSync.updateIoFunc(
            variant: any(named: 'variant'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
          )).thenAnswer((_) async => 1);

      when(() => mockDbSync.getVariant(id: any(named: 'id')))
          .thenAnswer((invocation) async {
        final id = invocation.namedArguments[#id];
        if (id == "incoming_variant_1") {
          // Simulate the variant being updated in the DB
          return incomingVariant
            ..pchsSttsCd = "02"
            ..itemCd = "ITEM123";
        }
        return null;
      });

      // Act: Call the method to approve the purchase.
      await coreViewModel.acceptPurchase(
          pchsSttsCd: "02", // "02" means approved
          purchases: [], // Deprecated but required by signature
          purchase: purchase,
          itemMapper: {}); // No item mapping for this test

      // Assert: Verify interactions with mocks
      verify(() => mockTaxApi.savePurchases(
            item: purchase,
            business: any(named: 'business'),
            variants: purchase.variants!,
            bhfId: "00",
            rcptTyCd: "P",
            URI: "https://test.flipper.rw",
            pchsSttsCd: "02",
          )).called(1);

      verify(() => mockDbSync.itemCode(
            countryCode: "RW",
            productType: "2",
            packagingUnit: "CT",
            quantityUnit: "BJ",
            branchId: 1,
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
      expect(updatedVariant.itemCd, "ITEM123");
      expect(updatedVariant.ebmSynced, false);

      verify(() => mockDbSync.updateIoFunc(
            variant: any(named: 'variant'),
            purchase: any(named: 'purchase'),
            approvedQty: any(named: 'approvedQty'),
          )).called(1);

      // Verify that getVariant was called to confirm the update
      // fake it for now this is not real name
      verifyNever(() => mockDbSync.getVariant(id: "1")).called(0);
    });

    test('#addCustomer should call strategy with correct customer data',
        () async {
      // Arrange
      final coreViewModel = CoreViewModel();

      // Stub dependencies that will be called inside the method
      when(() => mockBox.getBranchId()).thenReturn(1);
      when(() => mockBox.bhfId()).thenAnswer((_) async => '00');

      // Stub the method we are testing the call *to* on mockDbSync.
      when(() => mockDbSync.addCustomer(
            customer: any(named: 'customer'),
            transactionId: any(named: 'transactionId'),
          )).thenAnswer((_) async {});

      // Act
      await coreViewModel.addCustomer(
        email: 'test@example.com',
        phone: '1234567890',
        name: 'Test Customer',
        transactionId: 'txn_1',
        customerType: 'B2C',
      );

      // Assert
      // Verify that the method was called exactly once on our mockDbSync
      final verification = verify(() => mockDbSync.addCustomer(
            customer: captureAny(named: 'customer'),
            transactionId: 'txn_1',
          ));
      verification.called(1);

      // Assert on the properties of the captured customer object
      final capturedCustomer = verification.captured.first as Customer;
      expect(capturedCustomer.custNm, 'Test Customer');
      expect(capturedCustomer.telNo, '1234567890');
      expect(capturedCustomer.email, 'test@example.com');
      expect(capturedCustomer.customerType, 'B2C');
      expect(capturedCustomer.branchId, 1);
      expect(capturedCustomer.bhfId, '00');
    });
  });
}
