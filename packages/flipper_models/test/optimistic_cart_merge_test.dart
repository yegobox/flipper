import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
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
}
