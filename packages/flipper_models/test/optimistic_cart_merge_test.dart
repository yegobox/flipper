import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bootstrap pending merges into real pending transaction id', () {
    const realTxnId = 'txn-real-123';
    final variant = Variant(
      id: 'var-1',
      name: 'Test SKU',
      retailPrice: 1000,
      branchId: 'branch-1',
    );

    final optimistic = OptimisticCartState(
      activeTransactionId: OptimisticCartBootstrap.txnId,
      pendingQtyByVariantId: {'var-1': 1},
      variantSnapshotByVariantId: {'var-1': variant},
    );

    final merged = mergeTransactionItemsWithOptimisticCart(
      streamItems: const [],
      optimistic: optimistic,
      transactionId: realTxnId,
    );

    expect(merged, hasLength(1));
    expect(merged.first.variantId, 'var-1');
    expect(merged.first.qty, 1);
    expect(merged.first.transactionId, realTxnId);
    expect(OptimisticCartIds.isOptimistic(merged.first.id), isTrue);
  });

  test('preferBootstrapWhilePending uses bootstrap merge id even with real txn', () {
    expect(
      cartTransactionIdForMergeIds(
        pendingTransactionId: 'txn-real-123',
        optimisticTransactionId: 'txn-real-123',
        preferBootstrapWhilePending: true,
      ),
      OptimisticCartBootstrap.txnId,
    );
  });

  test('pending ghost merges with cached persisted stream rows', () {
    const realTxnId = 'txn-real-123';
    final variant1 = Variant(
      id: 'var-1',
      name: 'SKU 1',
      retailPrice: 1000,
      branchId: 'branch-1',
    );
    final variant2 = Variant(
      id: 'var-2',
      name: 'SKU 2',
      retailPrice: 2000,
      branchId: 'branch-1',
    );

    final persisted = TransactionItem(
      id: 'ti-1',
      ttCatCd: 'TT',
      name: 'SKU 1',
      qty: 1,
      price: 1000,
      discount: 0,
      prc: 1000,
      branchId: 'branch-1',
      transactionId: realTxnId,
      variantId: 'var-1',
    );

    final optimistic = OptimisticCartState(
      activeTransactionId: realTxnId,
      pendingQtyByVariantId: {'var-2': 1},
      variantSnapshotByVariantId: {'var-2': variant2},
      lastStreamQtySumByVariantId: {'var-1': 1},
    );

    final merged = mergeTransactionItemsWithOptimisticCart(
      streamItems: [persisted],
      optimistic: optimistic,
      transactionId: realTxnId,
    );

    expect(merged, hasLength(2));
    expect(
      merged.map((i) => i.variantId).toSet(),
      {'var-1', 'var-2'},
    );
    expect(
      merged.firstWhere((i) => i.variantId == 'var-2').qty,
      1,
    );
    expect(
      OptimisticCartIds.isOptimistic(
        merged.firstWhere((i) => i.variantId == 'var-2').id,
      ),
      isTrue,
    );
  });
}
