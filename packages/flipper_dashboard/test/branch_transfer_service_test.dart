import 'package:flipper_dashboard/services/branch_transfer_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionItem _line(String id) => TransactionItem(
  id: id,
  name: 'Soap',
  transactionId: 't1',
  variantId: 'v1',
  branchId: 'b1',
  qty: 2,
  price: 500,
  discount: 0,
  prc: 500,
  ttCatCd: 'B',
  active: true,
);

void main() {
  testWidgets(
    'a cart with unsaved lines is refused before anything is written',
    (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      );

      // No ProxyService is set up: the guard has to fire before the first
      // store call, or this test would fail on that call instead.
      await expectLater(
        BranchTransferService().confirmBranchTransfer(
          context: context,
          items: [_line('saved-1'), _line('${OptimisticCartIds.prefix}t1:v1')],
          sourceBranchId: 'b1',
          destinationBranchId: 'b2',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            FlipperL10n.current.branchTransferCartStillSaving,
          ),
        ),
      );
    },
  );
}
