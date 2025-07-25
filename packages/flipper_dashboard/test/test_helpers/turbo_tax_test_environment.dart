import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/local_notification_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/retryable.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'mocks.dart';

class MockRepository extends Mock implements Repository {}

class MockRetryable extends Mock implements Retryable {}

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

class TurboTaxTestEnvironment {
  late MockRepository mockRepository;
  late MockSyncStrategy mockSyncStrategy;
  late MockLNotification mockNotification;
  late MockDatabaseSync mockDbSync;
  late MockBox mockBox;
  late MockRetryable mockRetryable;
  late MockTaxApi mockTaxApi;

  late SyncStrategy originalStrategyLink;
  late LocalStorage originalBox;
  late TaxApi originalTaxApi;
  late LocalNotificationService originalNotification;

  void init() {
    mockRepository = MockRepository();
    mockSyncStrategy = MockSyncStrategy();
    mockDbSync = MockDatabaseSync();
    mockBox = MockBox();
    mockTaxApi = MockTaxApi();
    mockRetryable = MockRetryable();
    mockNotification = MockLNotification();

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
    registerFallbackValue(ITransaction(
      id: 'fallback_transaction',
      status: 'pending',
      branchId: 1,
      invoiceNumber: 1,
      items: [],
      isIncome: true,
      isExpense: false,
      paymentType: 'CASH',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      transactionType: 'NS',
    ));
    registerFallbackValue(TransactionItem(
        id: 'fallback_item',
        price: 0.0,
        qty: 0.0,
        name: 'fallback_item',
        discount: 0,
        prc: 1));
    registerFallbackValue(Configurations(
        id: 'fallback_config', taxType: 'A', taxPercentage: 0.0));
    registerFallbackValue(Retryable(
      entityId: 'fallback_entity_id',
      entityTable: 'fallback_entity_table',
      lastFailureReason: 'fallback_reason',
      retryCount: 0,
      createdAt: DateTime.now(),
    ));
    registerFallbackValue(ICustomer(
      id: 'fallback_customer_id',
      custNm: 'Fallback Customer',
      email: 'fallback@example.com',
      telNo: '123-456-7890',
      branchId: 1,
      custNo: '123',
      custTin: '123456789',
      ebmSynced: false,
    ));
  }

  void injectMocks() {
    // Store original ProxyService components
    originalStrategyLink = ProxyService.strategyLink;
    originalBox = ProxyService.box;
    originalTaxApi = ProxyService.tax;

    // Inject mocks into ProxyService
    ProxyService.strategyLink = mockSyncStrategy;
    ProxyService.box = mockBox;
    ProxyService.tax = mockTaxApi;
    ProxyService.notification = mockNotification;

    // Stub the current property of mockSyncStrategy
    when(() => mockSyncStrategy.current).thenReturn(mockDbSync);
    when(() => mockNotification.sendLocalNotification(
        body: any(named: 'body'),
        userName: any(named: 'userName'))).thenAnswer((_) async => {});
  }

  void restore() {
    // Restore original ProxyService components
    ProxyService.strategyLink = originalStrategyLink;
    ProxyService.box = originalBox;
    ProxyService.tax = originalTaxApi;
  }

  void stubCommonMethods() {
    // Stub common methods for mockBox and mockTaxApi as needed for TurboTaxService tests
    when(() => mockBox.isProformaMode()).thenReturn(false);
    when(() => mockBox.isTrainingMode()).thenReturn(false);
    when(() => mockBox.getBusinessId()).thenReturn(1);
    when(() => mockBox.getBranchId()).thenReturn(1);
    when(() => mockBox.bhfId()).thenAnswer((_) async => "00");
    when(() => mockBox.tin()).thenReturn(123456789);
    when(() => mockBox.vatEnabled()).thenReturn(true);

    // Stub common methods for mockDbSync if TurboTaxService directly calls them
    when(() => mockDbSync.getBusiness(businessId: any(named: 'businessId')))
        .thenAnswer((_) async => Business(
            id: "1", name: "Test Business", tinNumber: 123456789, serverId: 1));
    when(() => mockDbSync.manageTransaction(
          transactionType: any(named: 'transactionType'),
          isExpense: any(named: 'isExpense'),
          status: any(named: 'status'),
          branchId: any(named: 'branchId'),
        )).thenAnswer((_) async => ITransaction(
          invoiceNumber: 1,
          items: [],
          isIncome: true,
          isExpense: false,
          paymentType: 'CASH',
          cashReceived: 0,
          customerChangeDue: 0,
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
          transactionType: 'NS',
          branchId: 1,
          id: 'test_transaction',
          status: 'pending',
        ));
    when(() => mockDbSync.assignTransaction(
          variant: any(named: 'variant'),
          purchase: any(named: 'purchase'),
          doneWithTransaction: any(named: 'doneWithTransaction'),
          invoiceNumber: any(named: 'invoiceNumber'),
          updatableQty: any(named: 'updatableQty'),
          pendingTransaction: any(named: 'pendingTransaction'),
          business: any(named: 'business'),
          randomNumber: any(named: 'randomNumber'),
          sarTyCd: any(named: 'sarTyCd'),
        )).thenAnswer((_) async => ITransaction(
          id: 'test_transaction',
          status: 'pending',
          branchId: 1,
          transactionType: 'NS',
          invoiceNumber: 1,
          items: [],
          isIncome: true,
          isExpense: false,
          paymentType: 'CASH',
          cashReceived: 0,
          customerChangeDue: 0,
          updatedAt: DateTime.now(),
          createdAt: DateTime.now(),
        ));
    when(() => mockRepository.get<Retryable>(query: any(named: 'query')))
        .thenAnswer((_) async => []);
    when(() => mockRepository.upsert<Retryable>(any()))
        .thenAnswer((_) async => Retryable(
              entityId: 'test',
              entityTable: 'test',
              lastFailureReason: 'test',
              retryCount: 1,
              createdAt: DateTime.now(),
            ));
    when(() => mockRepository.delete<Retryable>(any()))
        .thenAnswer((_) async => true);

    when(() => mockRepository.get<TransactionItem>(query: any(named: 'query')))
        .thenAnswer((_) async => []);
    when(() => mockRepository.get<Configurations>(query: any(named: 'query')))
        .thenAnswer((_) async =>
            [Configurations(id: '1', taxType: 'B', taxPercentage: 18)]);

    when(() => mockTaxApi.saveItem(
              variation: any(named: 'variation'),
              URI: any(named: 'URI'),
            ))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'));
    when(() => mockTaxApi.saveStockMaster(
              variant: any(named: 'variant'),
              URI: any(named: 'URI'),
              approvedQty: any(named: 'approvedQty'),
            ))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'));
    when(() => mockTaxApi.saveStockItems(
              transaction: any(named: 'transaction'),
              tinNumber: any(named: 'tinNumber'),
              bhFId: any(named: 'bhFId'),
              customerName: any(named: 'customerName'),
              custTin: any(named: 'custTin'),
              invoiceNumber: any(named: 'invoiceNumber'),
              approvedQty: any(named: 'approvedQty'),
              regTyCd: any(named: 'regTyCd'),
              sarNo: any(named: 'sarNo'),
              sarTyCd: any(named: 'sarTyCd'),
              custBhfId: any(named: 'custBhfId'),
              totalSupplyPrice: any(named: 'totalSupplyPrice'),
              totalvat: any(named: 'totalvat'),
              totalAmount: any(named: 'totalAmount'),
              remark: any(named: 'remark'),
              ocrnDt: any(named: 'ocrnDt'),
              URI: any(named: 'URI'),
            ))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'));
    when(() => mockTaxApi.saveCustomer(
              customer: any(named: 'customer'),
              URI: any(named: 'URI'),
            ))
        .thenAnswer(
            (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'));
  }
}
