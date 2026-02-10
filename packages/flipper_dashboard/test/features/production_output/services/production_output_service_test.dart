import 'package:flipper_dashboard/features/production_output/services/production_output_service.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Adjust import path based on file structure
import '../../../test_helpers/mocks.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:supabase_models/brick/models/sars.model.dart';

// flutter test test/features/production_output/services/production_output_service_test.dart  --dart-define=FLUTTER_TEST_ENV=true
// Create a proper mock that extends the class we want to mock
// and implements the interface we need.
class MockProductionOutputService extends Mock
    implements ProductionOutputService {}

class TestProductionOutputService extends ProductionOutputService {
  final List<WorkOrder> mockWorkOrders;

  TestProductionOutputService(this.mockWorkOrders);

  @override
  Future<List<WorkOrder>> getWorkOrders({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    return mockWorkOrders;
  }

  @override
  Future<void> updateWorkOrderStatus({
    required String workOrderId,
    required String status,
  }) async {
    // no-op or mock
  }
}

void main() {
  late TestProductionOutputService service;
  late MockSyncStrategy mockStrategy;
  late MockBox mockBox;
  late MockTaxApi mockTaxApi;
  late MockDatabaseSync mockDatabaseSync;

  setUpAll(() {
    registerFallbackValue(
      models.TransactionItem(
        name: 'Fallback Item',
        qty: 1,
        price: 100,
        discount: 0,
        prc: 100,
        ttCatCd: 'Test',
      ),
    );
    registerFallbackValue(
      models.Variant(
        name: 'Test',
        sku: 'SKU',
        productId: 'PID',
        unit: 'kg',
        productName: 'PName',
        branchId: 'BID',
        id: 'ID',
        itemStdNm: 'Standard Name',
        retailPrice: 100,
      ),
    );
    registerFallbackValue(DateTime.now());
  });

  setUp(() async {
    // Clear GetIt to avoid conflicts - must await this!
    await getIt.reset();

    // Register mocks needed by ProxyService getter lookups
    mockStrategy = MockSyncStrategy();
    mockBox = MockBox();
    mockTaxApi = MockTaxApi();
    mockDatabaseSync = MockDatabaseSync();

    // Register simple instances - these are what ProxyService.box, etc. look up
    getIt.registerSingleton<LocalStorage>(mockBox);
    getIt.registerSingleton<TaxApi>(mockTaxApi);
    getIt.registerSingleton<SyncStrategy>(
      mockStrategy,
      instanceName: 'strategy',
    );

    // Stub global getters
    when(() => mockStrategy.current).thenReturn(mockDatabaseSync);
    when(() => mockBox.getBranchId()).thenReturn('branch-1');

    // Stub updateWorkOrder which is called by updateWorkOrderStatus
    when(
      () => mockDatabaseSync.updateWorkOrder(
        workOrderId: any(named: 'workOrderId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) async {});

    // Default stub for updateStock as it is called on ProxyService.strategy (which returns mockDatabaseSync via .current)
    when(
      () => mockDatabaseSync.updateStock(
        stockId: any(named: 'stockId'),
        currentStock: any(named: 'currentStock'),
        appending: any(named: 'appending'),
        lastTouched: any(named: 'lastTouched'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockDatabaseSync.getVariant(id: any(named: 'id')),
    ).thenAnswer((_) async => null); // Default

    when(
      () => mockDatabaseSync.composites(productId: any(named: 'productId')),
    ).thenAnswer((_) async => []); // Default

    when(
      () => mockDatabaseSync.ebm(branchId: any(named: 'branchId')),
    ).thenAnswer((_) async => null); // Default

    when(
      () => mockDatabaseSync.getSar(branchId: any(named: 'branchId')),
    ).thenAnswer((_) async => null); // Default
  });

  group('ProductionOutputService - Auto Deduction', () {
    test('startWorkOrder deducts raw materials correctly', () async {
      const branchId = 'branch-1';
      const workOrderId = 'wo-1';
      const variantId = 'var-1';
      const ingredientVariantId = 'ing-var-1';
      const stockId = 'stock-1';
      const plannedQty = 10.0;
      const compositeQty = 2.0;

      final workOrder = WorkOrder(
        id: workOrderId,
        variantId: variantId,
        plannedQuantity: plannedQty,
        targetDate: DateTime.now(),
        status: 'pending',
        branchId: branchId,
        businessId: 'bus-1',
        createdAt: DateTime.now(),
        variantName: 'Finished Product',
      );

      service = TestProductionOutputService([workOrder]);

      final variant = models.Variant(
        id: variantId,
        productId: 'prod-finish',
        name: 'Finished Product',
        sku: 'SKU-F',
        unit: 'Item',
        productName: 'Finished Product',
        branchId: branchId,
        itemStdNm: 'Finished Product',
        retailPrice: 1000,
      );

      final composite = models.Composite(
        id: 'comp-1',
        productId: 'prod-finish',
        variantId: ingredientVariantId,
        qty: compositeQty,
        actualPrice: 100,
        businessId: 'bus-1',
        branchId: branchId,
      );

      final ingredientVariant = models.Variant(
        id: ingredientVariantId,
        productId: 'prod-raw',
        stockId: stockId,
        name: 'Raw Material',
        itemTyCd: '1',
        taxTyCd: 'B',
        supplyPrice: 50.0,
        sku: 'SKU-R',
        unit: 'kg',
        productName: 'Raw Material',
        branchId: branchId,
        itemStdNm: 'Raw Material',
        retailPrice: 100,
      );

      // Stubs
      when(
        () => mockDatabaseSync.getVariant(id: variantId),
      ).thenAnswer((_) async => variant);
      when(
        () => mockDatabaseSync.composites(productId: 'prod-finish'),
      ).thenAnswer((_) async => [composite]);
      when(
        () => mockDatabaseSync.getVariant(id: ingredientVariantId),
      ).thenAnswer((_) async => ingredientVariant);
      when(
        () => mockDatabaseSync.ebm(branchId: branchId),
      ).thenAnswer((_) async => null); // Disable EBM for simplicity first

      // Act
      await service.startWorkOrder(workOrderId);

      // Assert
      verify(
        () => mockDatabaseSync.updateStock(
          stockId: stockId,
          currentStock: -20.0, // 10 * 2
          appending: true, // Should be true
          lastTouched: any(named: 'lastTouched'),
        ),
      ).called(1);
    });

    test('startWorkOrder sends to RRA when EBM enabled', () async {
      const branchId = 'branch-1';
      const workOrderId = 'wo-1';
      const variantId = 'var-1';
      const ingredientVariantId = 'ing-var-1';
      const stockId = 'stock-1';

      final workOrder = WorkOrder(
        id: workOrderId,
        variantId: variantId,
        plannedQuantity: 10.0,
        targetDate: DateTime.now(),
        status: 'pending',
        branchId: branchId,
        businessId: 'bus-1',
        createdAt: DateTime.now(),
        variantName: 'Finished Product',
      );

      service = TestProductionOutputService([workOrder]);

      final variant = models.Variant(
        id: variantId,
        productId: 'prod-finish',
        name: 'Finished Product',
        sku: 'SKU-F',
        unit: 'Item',
        productName: 'Finished Product',
        branchId: branchId,
        itemStdNm: 'Finished Product',
        retailPrice: 1000,
      );
      final composite = models.Composite(
        id: 'comp-1',
        productId: 'prod-finish',
        variantId: ingredientVariantId,
        qty: 2.0,
        actualPrice: 100,
        businessId: 'bus-1',
        branchId: branchId,
        // active: true, // removed
      );
      final ingredientVariant = models.Variant(
        id: ingredientVariantId,
        productId: 'prod-raw',
        stockId: stockId,
        name: 'Raw Material',
        itemTyCd: '1',
        taxTyCd: 'B',
        supplyPrice: 50.0,
        sku: 'SKU-R',
        unit: 'kg',
        productName: 'Raw Material',
        branchId: branchId,
        itemStdNm: 'Raw Material',
        retailPrice: 100,
      );

      when(
        () => mockDatabaseSync.getVariant(id: variantId),
      ).thenAnswer((_) async => variant);
      when(
        () => mockDatabaseSync.composites(productId: 'prod-finish'),
      ).thenAnswer((_) async => [composite]);
      when(
        () => mockDatabaseSync.getVariant(id: ingredientVariantId),
      ).thenAnswer((_) async => ingredientVariant);

      // Mock EBM enabled
      final ebm = models.Ebm(
        id: 'ebm-1',
        tinNumber: 123456789,
        bhfId: '00',
        dvcSrlNo: 'DEVICE001',
        mrc: 'MRC001',
        taxServerUrl: 'http://tax',
        vatEnabled: true,
        businessId: 'bus-1',
        branchId: branchId,
      );
      when(
        () => mockDatabaseSync.ebm(branchId: branchId),
      ).thenAnswer((_) async => ebm);

      // Mock SAR for invoice numbering
      final sar = Sar(sarNo: 100, branchId: branchId);
      when(
        () => mockDatabaseSync.getSar(branchId: branchId),
      ).thenAnswer((_) async => sar);

      when(
        () => mockTaxApi.saveStockItems(
          items: any(named: 'items'),
          updateMaster: any(named: 'updateMaster'),
          tinNumber: any(named: 'tinNumber'),
          bhFId: any(named: 'bhFId'),
          sarTyCd: any(named: 'sarTyCd'),
          isStockIn: any(named: 'isStockIn'),
          sarNo: any(named: 'sarNo'),
          invoiceNumber: any(named: 'invoiceNumber'),
          totalSupplyPrice: any(named: 'totalSupplyPrice'),
          totalvat: any(named: 'totalvat'),
          totalAmount: any(named: 'totalAmount'),
          remark: any(named: 'remark'),
          ocrnDt: any(named: 'ocrnDt'),
          URI: any(named: 'URI'),
        ),
      ).thenAnswer(
        (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'),
      );

      when(
        () => mockTaxApi.saveStockMaster(
          variant: any(named: 'variant'),
          URI: any(named: 'URI'),
          stockMasterQty: any(named: 'stockMasterQty'),
        ),
      ).thenAnswer(
        (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'),
      );

      // Act
      await service.startWorkOrder(workOrderId);

      // Assert
      // Verify local stock update
      verify(
        () => mockDatabaseSync.updateStock(
          stockId: stockId,
          currentStock: -20.0,
          appending: true,
          lastTouched: any(named: 'lastTouched'),
        ),
      ).called(1);

      // Verify RRA call - use any() for parameters that might vary
      verify(
        () => mockTaxApi.saveStockItems(
          items: any(named: 'items'),
          updateMaster: any(named: 'updateMaster'),
          tinNumber: any(named: 'tinNumber'),
          bhFId: any(named: 'bhFId'),
          sarTyCd: '06',
          isStockIn: false,
          sarNo: any(named: 'sarNo'),
          invoiceNumber: any(named: 'invoiceNumber'),
          totalSupplyPrice: any(named: 'totalSupplyPrice'),
          totalvat: any(named: 'totalvat'),
          totalAmount: any(named: 'totalAmount'),
          remark: any(named: 'remark'),
          ocrnDt: any(named: 'ocrnDt'),
          URI: 'http://tax',
        ),
      ).called(1);
    });
  });
}
