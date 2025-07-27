import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/tax_api.dart';

import 'mocks.dart'; // Import TaxApi

class TestEnvironment {
  late MockSyncStrategy mockSyncStrategy;
  late MockDatabaseSync mockDbSync;
  late MockBox mockBox;
  late MockTaxApi mockTaxApi;

  late SyncStrategy originalStrategyLink;
  late LocalStorage originalBox;
  late TaxApi originalTaxApi;

  Future<void> init() async {
    await initializeDependenciesForTest();

    mockSyncStrategy = MockSyncStrategy();
    mockDbSync = MockDatabaseSync();
    mockBox = MockBox();
    mockTaxApi = MockTaxApi();

    // Register fallback values once
    registerFallbackValue(
        Customer(branchId: 0, custNm: 'fallback', bhfId: '00'));
    registerFallbackValue(Business(
        id: "1", name: "Fallback Business", tinNumber: 123456789, serverId: 1));
    registerFallbackValue(
        Variant(id: "fallback_variant", name: "Fallback Variant", branchId: 1));
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
    registerFallbackValue(<Variant>[]);
    registerFallbackValue(RwApiResponse(resultCd: "000", resultMsg: "Success"));
    registerFallbackValue(Ebm(
        bhfId: "00",
        tinNumber: 111,
        dvcSrlNo: "111",
        userId: 111,
        taxServerUrl: "https://test.flipper.rw",
        businessId: 1,
        branchId: 1));
    registerFallbackValue(Plan());
  }

  void injectMocks() {
    // Store original
    originalStrategyLink = ProxyService.strategyLink;
    originalBox = ProxyService.box;
    originalTaxApi = ProxyService.tax;

    // Inject mocks
    ProxyService.strategyLink = mockSyncStrategy;
    ProxyService.box = mockBox;
    ProxyService.tax = mockTaxApi;

    when(() => mockSyncStrategy.current).thenReturn(mockDbSync);
  }

  void restore() {
    ProxyService.strategyLink = originalStrategyLink;
    ProxyService.box = originalBox;
    ProxyService.tax = originalTaxApi;
  }

  void stubCommonMethods() {
    when(() => mockBox.getBusinessId()).thenReturn(1);
    when(() => mockBox.getBranchId()).thenReturn(1);
    when(() => mockBox.bhfId()).thenAnswer((_) async => "00");
    when(() => mockBox.getServerUrl())
        .thenAnswer((_) async => "https://test.flipper.rw");

    when(() => mockDbSync.getBusiness(businessId: any(named: 'businessId')))
        .thenAnswer(
      (_) async => Business(
          id: "1", name: "Test Business", tinNumber: 123456789, serverId: 1),
    );

    when(() => mockDbSync.ebm(branchId: any(named: 'branchId'))).thenAnswer(
      (_) async => Ebm(
          bhfId: "00",
          tinNumber: 111,
          dvcSrlNo: "111",
          userId: 111,
          taxServerUrl: "https://test.flipper.rw",
          businessId: 1,
          branchId: 1),
    );

    when(() => mockDbSync.itemCode(
          countryCode: any(named: 'countryCode'),
          productType: any(named: 'productType'),
          packagingUnit: any(named: 'packagingUnit'),
          quantityUnit: any(named: 'quantityUnit'),
          branchId: any(named: 'branchId'),
        )).thenAnswer((_) async => "ITEM123");
  }
}
