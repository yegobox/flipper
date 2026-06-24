import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_models/tax_api.dart';

import 'mocks.dart'; // Import TaxApi

class TestEnvironment {
  late MockSyncStrategy mockSyncStrategy;
  late MockDatabaseSync mockDbSync;
  late MockBox mockBox;
  late MockFlipperHttpClient mockFlipperHttpClient;
  late MockTaxApi mockTaxApi;

  // No longer need to store originals as we'll use getIt.reset() or allowReassignment

  Future<void> init() async {
    await initializeDependenciesForTest();

    mockSyncStrategy = MockSyncStrategy();
    mockDbSync = MockDatabaseSync();
    mockBox = MockBox();
    mockFlipperHttpClient = MockFlipperHttpClient();
    mockTaxApi = MockTaxApi();

    // Register fallback values once
    registerFallbackValue(
      Customer(branchId: "0", custNm: 'fallback', bhfId: '00'),
    );
    registerFallbackValue(
      Business(
        id: "1",
        name: "Fallback Business",
        tinNumber: 123456789,
        serverId: 1,
      ),
    );
    registerFallbackValue(
      Variant(id: "fallback_variant", name: "Fallback Variant", branchId: "1"),
    );
    registerFallbackValue(
      Purchase(
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
        branchId: "0",
        variants: [],
      ),
    );
    registerFallbackValue(<Variant>[]);
    registerFallbackValue(RwApiResponse(resultCd: "000", resultMsg: "Success"));
    registerFallbackValue(
      Ebm(
        mrc: "123",
        bhfId: "00",
        tinNumber: 111,
        dvcSrlNo: "111",
        userId: "111",
        taxServerUrl: "https://test.flipper.rw",
        businessId: "1",
        branchId: "1",
      ),
    );
    registerFallbackValue(Plan());
  }

  void injectMocks() {
    // Inject mocks into GetIt
    if (getIt.isRegistered<SyncStrategy>(instanceName: 'strategy')) {
      getIt.unregister<SyncStrategy>(instanceName: 'strategy');
    }
    getIt.registerSingleton<SyncStrategy>(
      mockSyncStrategy,
      instanceName: 'strategy',
    );

    if (getIt.isRegistered<LocalStorage>()) {
      getIt.unregister<LocalStorage>();
    }
    getIt.registerSingleton<LocalStorage>(mockBox);

    if (getIt.isRegistered<TaxApi>()) {
      getIt.unregister<TaxApi>();
    }
    getIt.registerSingleton<TaxApi>(mockTaxApi);

    // Also inject HttpClient into ProxyService directly as it's a getter now too
    if (getIt.isRegistered<HttpClientInterface>()) {
      getIt.unregister<HttpClientInterface>();
    }
    getIt.registerSingleton<HttpClientInterface>(mockFlipperHttpClient);

    when(() => mockSyncStrategy.current).thenReturn(mockDbSync);
  }

  void restore() {
    // In the new architecture, we rely on GetIt.reset() in initializeDependenciesForTest
    // which is called in each test's setUpAll via env.init().
    // If we need per-test restoration, we would need to re-run the locators init.
  }

  void stubCommonMethods() {
    when(() => mockBox.getBusinessId()).thenReturn("1");
    when(() => mockBox.getBranchId()).thenReturn("1");
    when(() => mockBox.bhfId()).thenAnswer((_) async => "00");
    when(
      () => mockBox.getServerUrl(),
    ).thenAnswer((_) async => "https://test.flipper.rw");

    when(
      () => mockDbSync.getBusiness(businessId: any(named: 'businessId')),
    ).thenAnswer(
      (_) async => Business(
        id: "1",
        name: "Test Business",
        tinNumber: 123456789,
        serverId: 1,
      ),
    );

    when(() => mockDbSync.ebm(branchId: any(named: 'branchId'))).thenAnswer(
      (_) async => Ebm(
        mrc: "123",
        bhfId: "00",
        tinNumber: 111,
        dvcSrlNo: "111",
        userId: "111",
        taxServerUrl: "https://test.flipper.rw",
        businessId: "1",
        branchId: "1",
      ),
    );

    when(
      () => mockDbSync.itemCode(
        countryCode: any(named: 'countryCode'),
        productType: any(named: 'productType'),
        packagingUnit: any(named: 'packagingUnit'),
        quantityUnit: any(named: 'quantityUnit'),
        branchId: any(named: 'branchId'),
      ),
    ).thenAnswer((_) async => "ITEM123");
  }

  Future<void> dispose() async {
    await resetDependencies();
  }
}
