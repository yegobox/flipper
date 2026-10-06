// Adding items to a till ticket being collected (settling).
//
// The customer at the till asks for more items, so the collector taps the
// catalog. Those lines must land on the collected ticket — not on whichever
// PENDING row the pending-cart observer emitted last, which is how they used to
// end up on a brand-new transaction.
//
// Run from `flipper/packages/flipper_models`:
//   flutter test test/settling_ticket_add_items_test.dart

import 'dart:async';

import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

const _branchId = 'b1';
const _ticketId = 'ticket-collected';
const _otherCartId = 'cart-fresh-pending';

ITransaction _txn(String id, {String status = PENDING}) => ITransaction(
  id: id,
  branchId: _branchId,
  status: status,
  transactionType: 'sale',
  paymentType: 'Cash',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 1, 1),
  isIncome: true,
  isExpense: false,
  agentId: 'collector',
  ticketName: id == _ticketId ? 'Till · ABCDE' : null,
);

TransactionItem _line(String id, String variantId) => TransactionItem(
  id: id,
  name: 'Item $id',
  qty: 1,
  price: 100,
  discount: 0,
  prc: 100,
  ttCatCd: 'B',
  active: true,
  transactionId: _ticketId,
  variantId: variantId,
  branchId: _branchId,
);

SettlingTillTicket _settling({ITransaction? snapshot}) => SettlingTillTicket(
  transactionId: _ticketId,
  displayRef: 'ABCDE',
  creatorName: 'Staff',
  createdAt: DateTime.utc(2026, 1, 1),
  branchId: _branchId,
  ticketName: 'Till · ABCDE',
  ticketSnapshot: snapshot ?? _txn(_ticketId),
);

/// [readPosCartTransactionIdFast] takes a [Ref]; run it inside a provider.
final _tapTargetProbe = Provider.autoDispose<String?>(
  (ref) => readPosCartTransactionIdFast(ref, isExpense: false),
);

final _expenseTapTargetProbe = Provider.autoDispose<String?>(
  (ref) => readPosCartTransactionIdFast(ref, isExpense: true),
);

void main() {
  group('tap target while collecting a ticket', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          posCartIsExpenseProvider.overrideWith((ref) => false),
          // Row not loaded yet: the Collect snapshot has to stand in.
          transactionByIdProvider(
            _ticketId,
          ).overrideWith((ref) => const Stream<ITransaction?>.empty()),
        ],
      );
      // The pending-cart cache has drifted onto a freshly minted cart.
      container.read(cachedPendingSaleTransactionProvider.notifier).state =
          _txn(_otherCartId);
    });

    tearDown(() => container.dispose());

    test('targets the collected ticket, not the cached pending cart', () {
      container.read(settlingTillTicketProvider.notifier).state = _settling();

      expect(container.read(_tapTargetProbe), _ticketId);
      expect(
        readSettlingCartTransactionContainer(container, isExpense: false)?.id,
        _ticketId,
      );
    });

    test('uses the normal pending cart when nothing is being collected', () {
      expect(container.read(_tapTargetProbe), _otherCartId);
      expect(
        readSettlingCartTransactionContainer(container, isExpense: false),
        isNull,
      );
    });

    test('lets go of a ticket that already left PENDING', () {
      container.read(settlingTillTicketProvider.notifier).state = _settling(
        snapshot: _txn(_ticketId, status: COMPLETE),
      );

      expect(container.read(_tapTargetProbe), _otherCartId);
    });

    test('never routes a purchase into a till ticket', () {
      container.read(settlingTillTicketProvider.notifier).state = _settling();
      container.read(cachedPendingPurchaseTransactionProvider.notifier).state =
          _txn('purchase-cart');

      expect(container.read(_expenseTapTargetProbe), 'purchase-cart');
    });
  });

  group('cache sync keeps a pinned cart', () {
    late StreamController<ITransaction> pending;
    late ProviderContainer container;

    setUp(() {
      pending = StreamController<ITransaction>.broadcast();
      container = ProviderContainer(
        overrides: [
          pendingTransactionStreamProvider(
            isExpense: false,
          ).overrideWith((ref) => pending.stream),
        ],
      );
    });

    tearDown(() async {
      container.dispose();
      await pending.close();
    });

    Future<void> emit(ITransaction txn) async {
      pending.add(txn);
      // Stream delivery, then the microtask-scheduled cache write.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
    }

    test('ignores emissions that are not the pinned cart', () async {
      final sync = Provider.autoDispose<void>(
        (ref) => listenCachedPendingCartTransactionSync(ref, isExpense: false),
      );
      final sub = container.listen(sync, (_, _) {});
      addTearDown(sub.close);

      container.read(pinnedPosCartTransactionIdProvider.notifier).state =
          _ticketId;
      container.read(cachedPendingSaleTransactionProvider.notifier).state =
          _txn(_ticketId);

      await emit(_txn(_otherCartId));
      expect(
        container.read(cachedPendingSaleTransactionProvider)?.id,
        _ticketId,
      );

      await emit(_txn(_ticketId));
      expect(
        container.read(cachedPendingSaleTransactionProvider)?.id,
        _ticketId,
      );

      // Once the ticket is paid or parked the pin goes, and the next cart is
      // adopted as before.
      container.read(pinnedPosCartTransactionIdProvider.notifier).state = null;
      await emit(_txn(_otherCartId));
      expect(
        container.read(cachedPendingSaleTransactionProvider)?.id,
        _otherCartId,
      );
    });
  });

  group('settling cart display', () {
    late ProviderContainer container;
    final variant = Variant(
      id: 'var-added',
      name: 'Added SKU',
      retailPrice: 250,
      branchId: _branchId,
    );

    setUp(() {
      container = ProviderContainer(
        overrides: [
          posCartIsExpenseProvider.overrideWith((ref) => false),
          transactionItemsStreamProvider(
            transactionId: _ticketId,
            branchId: _branchId,
          ).overrideWith((ref) => Stream.value([_line('l1', 'var-original')])),
        ],
      );
      container.read(settlingTillTicketProvider.notifier).state = _settling();
    });

    tearDown(() => container.dispose());

    Future<List<TransactionItem>> displayed() async {
      final sub = container.listen(posCartDisplayItemsProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(
        transactionItemsStreamProvider(
          transactionId: _ticketId,
          branchId: _branchId,
        ).future,
      );
      return container.read(posCartDisplayItemsProvider);
    }

    test('shows a line tapped onto the ticket before Ditto has it', () async {
      container
          .read(optimisticCartProvider.notifier)
          .addPendingLine(transactionId: _ticketId, variant: variant);

      final lines = await displayed();
      expect(
        lines.map((l) => l.variantId),
        containsAll(<String>['var-original', 'var-added']),
      );
    });

    test('ignores a ghost that belongs to a different cart', () async {
      container
          .read(optimisticCartProvider.notifier)
          .addPendingLine(transactionId: _otherCartId, variant: variant);

      final lines = await displayed();
      expect(lines.map((l) => l.variantId), ['var-original']);
    });
  });
}
