import 'package:flipper_dashboard/transaction_item_adder_persist.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// flutter test test/transaction_item_adder_persist_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// A cart line whose save returns false is rolled back, and the add reports
// failure. The failure is seen inside the write lock, where a `return` leaves
// only the lock's callback, so it used to report success.

class _MockDb extends Mock implements DatabaseSyncInterface {}

class _FakeContext extends Fake implements BuildContext {}

final _refProvider = Provider<Ref>((ref) => ref);

void main() {
  late _MockDb db;

  final pending = ITransaction(
    id: 'txn-pending',
    branchId: 'b1',
    agentId: 'agent-1',
    status: PENDING,
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 11, 23),
    isIncome: true,
    isExpense: false,
    subTotal: 0,
  );
  final variant = Variant(
    id: 'combo-v',
    name: 'Breakfast',
    branchId: 'b1',
    retailPrice: 1500,
  );
  final pendingProv = Provider<AsyncValue<ITransaction>>(
    (ref) => AsyncData(pending),
  );

  setUpAll(() {
    registerFallbackValue(variant);
    registerFallbackValue(pending);
  });

  setUp(() async {
    await getIt.reset();
    db = _MockDb();
    getIt.registerSingleton<SyncStrategy>(
      SyncStrategy(capella: db, cloudSync: db),
      instanceName: 'strategy',
    );
  });

  tearDown(() async => getIt.reset());

  test('a save that returns false reports the add as failed', () async {
    when(
      () => db.saveTransactionItem(
        variation: any(named: 'variation'),
        amountTotal: any(named: 'amountTotal'),
        ignoreForReport: any(named: 'ignoreForReport'),
        customItem: any(named: 'customItem'),
        doneWithTransaction: any(named: 'doneWithTransaction'),
        pendingTransaction: any(named: 'pendingTransaction'),
        currentStock: any(named: 'currentStock'),
        partOfComposite: any(named: 'partOfComposite'),
        compositePrice: any(named: 'compositePrice'),
        updatableQty: any(named: 'updatableQty'),
        item: any(named: 'item'),
        invoiceNumber: any(named: 'invoiceNumber'),
        sarTyCd: any(named: 'sarTyCd'),
        useTransactionItemForQty: any(named: 'useTransactionItemForQty'),
        updatePendingTransactionSubtotal: any(
          named: 'updatePendingTransactionSubtotal',
        ),
      ),
    ).thenAnswer((_) async => false);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final added = await persistItemToTransaction(
      ref: container.read(_refProvider),
      context: _FakeContext(),
      variant: variant,
      // Ordering skips the stock check, which is not under test here.
      isOrdering: true,
      pendingProv: pendingProv,
      pendingTransaction: pending,
      sessionAtStart: 0,
      cartOptimismApplied: false,
    );

    expect(added, isFalse);
  });
}
