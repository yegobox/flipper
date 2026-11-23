import 'package:flipper_dashboard/services/transaction_refund_service.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:talker_flutter/talker_flutter.dart';

// flutter test test/transaction_refund_restore_stock_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// A refunded combo returns its components' stock. A component can move a
// fraction per combo (Composite.qty 0.5), and a full refund must put back
// exactly what the sale took instead of truncating it to whole units.

class _MockDb extends Mock implements DatabaseSyncInterface {}

class _MockBox extends Mock implements LocalStorage {}

TransactionItem _line(
  String id, {
  required String variantId,
  String? productId,
  String itemTyCd = '2',
  num qty = 1,
}) => TransactionItem(
  id: id,
  name: id,
  transactionId: 'txn-1',
  branchId: 'b1',
  productId: productId,
  variantId: variantId,
  itemTyCd: itemTyCd,
  qty: qty,
  price: 1000,
  prc: 1000,
  discount: 0,
  ttCatCd: null,
);

Variant _variant(String id, {String itemTyCd = '2', String? stockId}) =>
    Variant(
      id: id,
      name: id,
      branchId: 'b1',
      productId: 'p-$id',
      itemTyCd: itemTyCd,
      retailPrice: 500,
      stockId: stockId,
    );

void main() {
  late _MockDb db;
  late _MockBox box;
  final restored = <String, double>{};

  setUp(() async {
    await getIt.reset();
    db = _MockDb();
    box = _MockBox();
    restored.clear();
    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<SyncStrategy>(
      SyncStrategy(capella: db, cloudSync: db),
      instanceName: 'strategy',
    );
    when(() => box.getBusinessId()).thenReturn('biz1');
    when(() => box.getBranchId()).thenReturn('b1');

    final soda = _variant('soda', stockId: 'stock-soda');
    final tea = _variant('tea', stockId: 'stock-tea');
    when(() => db.transactionItems(transactionId: 'txn-1')).thenAnswer(
      (_) async => [
        _line(
          'combo-line',
          variantId: 'combo-v',
          productId: 'combo',
          itemTyCd: '3',
          qty: 3,
        ),
        _line('tea-line', variantId: 'tea', qty: 2),
      ],
    );
    when(
      () => db.getProduct(id: 'combo', branchId: 'b1', businessId: 'biz1'),
    ).thenAnswer(
      (_) async => Product(
        id: 'combo',
        name: 'Breakfast',
        color: '#000',
        businessId: 'biz1',
        branchId: 'b1',
        isComposite: true,
      ),
    );
    when(() => db.composites(productId: 'combo', localOnly: true)).thenAnswer(
      (_) async => [Composite(productId: 'combo', variantId: 'soda', qty: 0.5)],
    );
    when(
      () => db.batchGetVariantsByIds(['soda']),
    ).thenAnswer((_) async => {'soda': soda});
    when(() => db.getVariant(id: 'soda')).thenAnswer((_) async => soda);
    when(() => db.getVariant(id: 'tea')).thenAnswer((_) async => tea);
    when(
      () => db.updateStock(
        stockId: any(named: 'stockId'),
        currentStock: any(named: 'currentStock'),
        appending: true,
      ),
    ).thenAnswer((inv) async {
      restored[inv.namedArguments[#stockId] as String] =
          inv.namedArguments[#currentStock] as double;
    });
  });

  tearDown(() async => getIt.reset());

  test('a full refund restores the fraction each component moved', () async {
    await TransactionRefundService(talker: Talker()).restoreStock(
      transactionId: 'txn-1',
      refundAmount: 5000,
      originalTotal: 5000,
    );
    // 3 combos x 0.5 soda each; the plain line as sold.
    expect(restored, {'stock-soda': 1.5, 'stock-tea': 2.0});
  });

  test('a partial refund still restores whole units', () async {
    await TransactionRefundService(talker: Talker()).restoreStock(
      transactionId: 'txn-1',
      refundAmount: 2500,
      originalTotal: 5000,
    );
    // Half of (1 + 2) whole units, largest remainder first.
    expect(restored.values.fold<double>(0, (s, q) => s + q), 2);
    expect(restored.values.every((q) => q == q.roundToDouble()), isTrue);
  });
}
