import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _item({
  required String id,
  String? transactionId,
  bool active = true,
  double qty = 1,
}) {
  return TransactionItem(
    id: id,
    ttCatCd: 'TT',
    name: 'Item $id',
    transactionId: transactionId,
    variantId: 'var-$id',
    qty: qty,
    price: 10,
    discount: 0,
    prc: 10,
    branchId: 'branch-1',
    active: active,
  );
}

void main() {
  group('checkoutLineItemsForTransaction', () {
    test('uses stream rows when merged cart is empty', () {
      final stream = [
        _item(id: '1', transactionId: 'txn-a'),
        _item(id: '2', transactionId: 'txn-a'),
      ];
      final result = checkoutLineItemsForTransaction(
        mergedCart: const [],
        transactionId: 'txn-a',
        streamItems: stream,
      );
      expect(result.length, 2);
    });

    test('accepts stream rows with missing transactionId link', () {
      final stream = [_item(id: '1', transactionId: null)];
      final result = checkoutLineItemsForTransaction(
        mergedCart: const [],
        transactionId: 'txn-a',
        streamItems: stream,
      );
      expect(result.length, 1);
    });
  });

  group('resolveMobileCheckoutLineItems', () {
    test('prefers scoped stream when no optimistic pending', () {
      final result = resolveMobileCheckoutLineItems(
        transactionId: 'txn-a',
        mergedCart: const [],
        scopedStreamItems: [_item(id: '1', transactionId: 'txn-a')],
        hasOptimisticPendingForTxn: false,
      );
      expect(result.length, 1);
    });

    test('uses merged path when optimistic pending', () {
      final merged = [
        _item(
          id: OptimisticCartIds.ghostLineId(
            transactionId: 'txn-a',
            variantId: 'v1',
          ),
          transactionId: 'txn-a',
        ),
      ];
      final result = resolveMobileCheckoutLineItems(
        transactionId: 'txn-a',
        mergedCart: merged,
        scopedStreamItems: const [],
        hasOptimisticPendingForTxn: true,
      );
      expect(result.length, 1);
      expect(OptimisticCartIds.isOptimistic(result.first.id), isTrue);
    });
  });
}
