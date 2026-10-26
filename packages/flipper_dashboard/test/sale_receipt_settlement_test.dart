import 'package:flipper_dashboard/utils/sale_receipt_settlement.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

// flutter test test/sale_receipt_settlement_test.dart

class _MockSync extends Mock implements DatabaseSyncInterface {}

const _id = 'tab-1';

ITransaction _tab({String? receiptType, int? receiptNumber}) => ITransaction(
  id: _id,
  branchId: 'b',
  agentId: 'agent-1',
  status: 'PARKED',
  transactionType: 'sale',
  paymentType: 'Cash',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 10, 26),
  isIncome: true,
  isExpense: false,
  subTotal: 3000,
  receiptType: receiptType,
  receiptNumber: receiptNumber,
);

void main() {
  late _MockSync sync;

  setUp(() async {
    await getIt.reset();
    // No business: a receipt that is not skipped stops before RRA.
    getIt.registerSingleton<LocalStorage>(MockBox());
    sync = _MockSync();
  });

  tearDown(() async => getIt.reset());

  test('only a signed sale receipt counts as filed', () {
    expect(
      saleAlreadyReceipted(_tab(receiptType: 'NS', receiptNumber: 41)),
      isTrue,
    );
    expect(
      saleAlreadyReceipted(_tab(receiptType: 'PS', receiptNumber: 2)),
      isTrue,
    );
    expect(
      saleAlreadyReceipted(_tab(receiptType: 'NS', receiptNumber: 0)),
      isFalse,
    );
    expect(saleAlreadyReceipted(_tab(receiptType: 'NS')), isFalse);
    expect(
      saleAlreadyReceipted(_tab(receiptType: 'NR', receiptNumber: 41)),
      isFalse,
    );
    expect(saleAlreadyReceipted(_tab()), isFalse);
  });

  /// A settle that filed the receipt and then failed, retried.
  test('a retried settle does not file the receipt again', () async {
    final stored = _tab(receiptType: 'NS', receiptNumber: 41)
      ..sarNo = '41'
      ..totalReceiptNumber = 41
      ..invoiceNumber = 41;
    when(() => sync.getTransaction(id: _id)).thenAnswer((_) async => stored);
    final retry = _tab();

    await issueSaleReceipt(
      sync: sync,
      transaction: retry,
      lines: const [],
      receiptContext: 'receipt',
    );

    verifyNever(
      () => sync.isTaxEnabled(
        businessId: any(named: 'businessId'),
        branchId: any(named: 'branchId'),
      ),
    );
    // The mode's write keeps what RRA signed.
    expect(retry.receiptType, 'NS');
    expect(retry.sarNo, '41');
    expect(retry.receiptNumber, 41);
    expect(retry.totalReceiptNumber, 41);
    expect(retry.invoiceNumber, 41);
  });

  test('a sale not yet receipted goes on to be filed', () async {
    when(() => sync.getTransaction(id: _id)).thenAnswer((_) async => _tab());
    final first = _tab();

    await issueSaleReceipt(
      sync: sync,
      transaction: first,
      lines: const [],
      receiptContext: 'receipt',
    );

    verify(() => sync.getTransaction(id: _id)).called(1);
    expect(first.receiptNumber, isNull);
  });
}
