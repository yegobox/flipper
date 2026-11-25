import 'dart:async';

import 'package:flipper_models/db_model_export.dart' show ITransaction;
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_services/constants.dart' show PENDING;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _Host extends ConsumerStatefulWidget {
  const _Host({required this.onRef});

  final void Function(WidgetRef ref) onRef;

  @override
  ConsumerState<_Host> createState() => _HostState();
}

class _HostState extends ConsumerState<_Host> {
  @override
  void initState() {
    super.initState();
    widget.onRef(ref);
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

ITransaction _pendingCart([String id = 'cart-1']) => ITransaction(
  id: id,
  branchId: 'br',
  status: PENDING,
  transactionType: 'Sale',
  paymentType: 'CASH',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime(2026, 10, 22),
  isIncome: true,
  isExpense: false,
  agentId: 'a',
);

void main() {
  // The mobile home's POS warm-up schedules this from a Ditto callback. When
  // the home is gone by then (switching to personal mode swaps the shell),
  // the scheduled write used a dead `ref` and threw "Using ref when a widget
  // is about to or has been unmounted is unsafe".
  testWidgets('a write scheduled for an unmounted widget is dropped', (
    tester,
  ) async {
    late WidgetRef captured;
    await tester.pumpWidget(
      ProviderScope(child: _Host(onRef: (ref) => captured = ref)),
    );
    await tester.pumpWidget(const ProviderScope(child: SizedBox()));
    expect(captured.context.mounted, isFalse);

    scheduleWriteCachedPendingCartTransactionWidget(
      captured,
      isExpense: false,
      transaction: _pendingCart(),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  // Same race for a provider's Ref: `posCartStreamReconciliationProvider`
  // schedules the write from its body, rebuilds (or the scope is torn down
  // when Android destroys the activity) before the microtask runs, and the
  // old Ref threw UnmountedRefException. The rebuild schedules its own write.
  test('a write scheduled by a rebuilt provider is dropped', () async {
    final cartId = StateProvider<String>((ref) => 'cart-1');
    final writer = Provider<void>((ref) {
      scheduleWriteCachedPendingCartTransaction(
        ref,
        isExpense: false,
        transaction: _pendingCart(ref.watch(cartId)),
      );
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final errors = <Object>[];

    await runZonedGuarded(() async {
      container.listen(writer, (_, _) {});
      container.read(cartId.notifier).state = 'cart-2';
      container.read(writer); // rebuild before the first microtask runs
      await Future<void>.delayed(Duration.zero);
    }, (e, _) => errors.add(e));

    expect(errors, isEmpty);
    expect(
      container.read(cachedPendingCartTransactionProvider(false))?.id,
      'cart-2',
    );
  });
}
