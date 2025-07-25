import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/retryable.model.dart';
import 'package:supabase_models/services/turbo_tax_service.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/turbo_tax_test_environment.dart';

// flutter test test/turbo_tax_service_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('TurboTaxService', () {
    late TurboTaxTestEnvironment env;
    late TurboTaxService turboTaxService;
    late MockBox mockBox;

    setUpAll(() async {
      await initializeDependenciesForTest();
      env = TurboTaxTestEnvironment();
      env.init();
    });

    setUp(() {
      env.injectMocks();
      env.stubCommonMethods();
      turboTaxService = TurboTaxService(env.mockRepository);
      mockBox = env.mockBox;
    });

    tearDown(() {
      env.restore();
    });

    test('stockIo returns true in proforma mode', () async {
      when(() => mockBox.isProformaMode()).thenReturn(true);

      final result = await turboTaxService.stockIo(
        serverUrl: 'https://test.flipper.rw',
        invoiceNumber: 1,
      );

      expect(result, isTrue);
    });

    test('stockIo returns true in training mode', () async {
      when(() => mockBox.isTrainingMode()).thenReturn(true);

      final result = await turboTaxService.stockIo(
        serverUrl: 'https://test.flipper.rw',
        invoiceNumber: 1,
      );

      expect(result, isTrue);
    });
    test('stockIo syncs variant with EBM', () async {
      final variant = Variant(
          id: '1', name: 'Test Variant', ebmSynced: false, itemCd: '123');
      when(() => mockBox.isProformaMode()).thenReturn(false);
      when(() => mockBox.isTrainingMode()).thenReturn(false);
      when(() => env.mockTaxApi
          .saveItem(
              variation: any(named: 'variation'),
              URI: any(named: 'URI'))).thenAnswer(
          (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'));
      when(() => env.mockTaxApi
          .saveStockMaster(
              variant: any(named: 'variant'),
              URI: any(named: 'URI'))).thenAnswer(
          (_) async => RwApiResponse(resultCd: '000', resultMsg: 'Success'));
      when(() => env.mockRepository.get<Retryable>(query: any(named: 'query')))
          .thenAnswer((_) async => []);

      final result = await turboTaxService.stockIo(
        variant: variant,
        serverUrl: 'https://test.flipper.rw',
        invoiceNumber: 1,
        sarTyCd: "06", // Adding sarTyCd for stock adjustment
      );

      expect(result, isTrue);
      verify(() => env.mockTaxApi.saveItem(
          variation: any(named: 'variation'),
          URI: any(named: 'URI'))).called(1);
      verify(() => env.mockTaxApi.saveStockMaster(
          variant: any(named: 'variant'), URI: any(named: 'URI'))).called(1);
    });
    test('stockIo handles failed sync', () async {
      final variant = Variant(
          id: '1', name: 'Test Variant', ebmSynced: false, itemCd: '123');
      when(() => mockBox.isProformaMode()).thenReturn(false);
      when(() => mockBox.isTrainingMode()).thenReturn(false);
      when(() => env.mockTaxApi.saveItem(
              variation: any(named: 'variation'), URI: any(named: 'URI')))
          .thenAnswer(
              (_) async => RwApiResponse(resultCd: '500', resultMsg: 'Error'));
      when(() => env.mockRepository.get<Retryable>(query: any(named: 'query')))
          .thenAnswer((_) async => []);
      when(() => env.mockRepository.upsert<Retryable>(any())).thenAnswer(
          (_) async => Retryable(
              entityId: variant.id,
              entityTable: "variants",
              lastFailureReason: "Error",
              retryCount: 1,
              createdAt: DateTime.now()));

      final result = await turboTaxService.stockIo(
        variant: variant,
        serverUrl: 'https://test.flipper.rw',
        invoiceNumber: 1,
        sarTyCd: "06", // Adding sarTyCd for stock adjustment
      );

      expect(result, isFalse);
      verify(() => env.mockTaxApi.saveItem(
          variation: any(named: 'variation'),
          URI: any(named: 'URI'))).called(1);
      verify(() => env.mockRepository.upsert<Retryable>(any())).called(1);
    });
    test('syncTransactionWithEbm syncs transaction with EBM', () async {
      final transaction = ITransaction(
          id: '1',
          cashReceived: 100,
          customerChangeDue: 0,
          updatedAt: DateTime.now(),
          isIncome: true,
          isExpense: false,
          paymentType: "CASH",
          branchId: 1,
          status: 'completed',
          transactionType: "NS",
          invoiceNumber: 123,
          sarTyCd: "11", // Adding sarTyCd for stock items
          items: [
            TransactionItem(
                id: '1',
                price: 10,
                qty: 1,
                name: "test",
                discount: 0,
                prc: 1,
                taxTyCd: "B")
          ]);
      when(() => mockBox.isProformaMode()).thenReturn(false);
      when(() => mockBox.isTrainingMode()).thenReturn(false);
      when(() => env.mockRepository
              .get<TransactionItem>(query: any(named: 'query')))
          .thenAnswer((_) async => [
                TransactionItem(
                    id: '1',
                    price: 10,
                    qty: 1,
                    name: "Test",
                    discount: 0,
                    prc: 1,
                    taxTyCd: "B")
              ]);
      when(() => env.mockRepository
              .get<Configurations>(query: any(named: 'query')))
          .thenAnswer((_) async =>
              [Configurations(id: '1', taxType: 'B', taxPercentage: 18)]);
      when(() => env.mockTaxApi.saveStockItems(
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
          .thenAnswer((_) async =>
              RwApiResponse(resultCd: '000', resultMsg: 'Success'));
      when(() => env.mockRepository.get<Retryable>(query: any(named: 'query')))
          .thenAnswer((_) async => []);

      final result = await turboTaxService.syncTransactionWithEbm(
        instance: transaction,
        serverUrl: 'https://test.flipper.rw',
      );

      expect(result, isTrue);
      verify(() => env.mockTaxApi.saveStockItems(
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
          )).called(2);
    });
  });
}
