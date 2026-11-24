import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/rw_tax.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository/storage.dart';

// flutter test test/rw_tax_combo_stock_sync_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// Post-sale RRA stock sync reports a combo line as its components. That
// lookup runs unawaited after saveSales, so a failure in it must land in the
// sync's own error handling (logged, snapshot cleared) instead of escaping.

class _MockDb extends Mock implements DatabaseSyncInterface {}

class _MockBox extends Mock implements LocalStorage {}

class _MockKeyPad extends Mock implements KeyPadService {}

class _MockRepository extends Mock implements Repository {}

void main() {
  late _MockDb db;
  late _MockBox box;

  final transaction = ITransaction(
    id: 'txn-combo',
    branchId: 'b1',
    agentId: 'agent-1',
    status: 'completed',
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: 1500,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 11, 23),
    isIncome: true,
    isExpense: false,
    subTotal: 1500,
    taxAmount: 0,
  );

  setUp(() async {
    await getIt.reset();
    db = _MockDb();
    box = _MockBox();
    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<KeyPadService>(_MockKeyPad());
    getIt.registerSingleton<SyncStrategy>(
      SyncStrategy(capella: db, cloudSync: db),
      instanceName: 'strategy',
    );
    when(() => box.getBranchId()).thenReturn('b1');
    when(() => box.getBusinessId()).thenReturn('biz1');
    when(() => box.remove(key: any(named: 'key'))).thenReturn(null);
    when(
      () => db.ebm(
        branchId: any(named: 'branchId'),
        fetchRemote: any(named: 'fetchRemote'),
      ),
    ).thenAnswer(
      (_) async => Ebm(
        bhfId: '00',
        tinNumber: 999909695,
        dvcSrlNo: 'dvc',
        taxServerUrl: 'https://tax.example/',
        businessId: 'biz1',
        branchId: 'b1',
        mrc: 'mrc',
      ),
    );
  });

  tearDown(() async => getIt.reset());

  test('a failed combo lookup is caught and the snapshot cleared', () async {
    when(
      () => db.getProduct(
        id: any(named: 'id'),
        barCode: any(named: 'barCode'),
        branchId: any(named: 'branchId'),
        name: any(named: 'name'),
        businessId: any(named: 'businessId'),
      ),
    ).thenThrow(StateError('ditto closed'));

    await expectLater(
      RWTax().syncStockAfterSuccessfulSaveSales(
        receiptType: 'NS',
        items: [
          TransactionItem(
            id: 'combo-line',
            name: 'Breakfast',
            transactionId: transaction.id,
            branchId: 'b1',
            productId: 'combo',
            variantId: 'combo-v',
            itemTyCd: '3',
            qty: 1,
            price: 1500,
            prc: 1500,
            discount: 0,
            ttCatCd: null,
          ),
        ],
        transaction: transaction,
        highestInvcNo: 12,
        repository: _MockRepository(),
      ),
      completes,
    );

    verify(
      () => box.remove(key: rraSaleStockSnapshotBoxKey(transaction.id)),
    ).called(1);
  });

  test('without a repository the sync uses the app one', () async {
    // None is initialised under test, so reaching for it throws.
    await expectLater(
      RWTax().syncStockAfterSuccessfulSaveSales(
        receiptType: 'NS',
        items: const [],
        transaction: transaction,
        highestInvcNo: 12,
      ),
      throwsA(isA<StateError>()),
    );
  });
}
