// Runs the Kitchen Display's `kitchen_orders` DQL against a real local Ditto
// store in DQL_STRICT_MODE, as production does. `flutter test` has no Ditto
// native library, so this skips unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/kitchen_orders_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/models/kitchen_order.dart';
import 'package:flipper_models/sync/utils/kitchen_orders_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  _FakePaths(this.dir);
  final String dir;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir;
  @override
  Future<String?> getApplicationSupportPath() async => dir;
  @override
  Future<String?> getTemporaryPath() async => dir;
}

void main() {
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;
  const branch = 'b1';

  late dynamic store;

  Future<void> ticket(
    String id, {
    String status = 'parked',
    String? ticketName = 'Table 1',
    double subTotal = 5000,
    String branchId = branch,
    bool isLoan = false,
    String? dueDate,
  }) async {
    await store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {
        'doc': {
          '_id': id,
          'id': id,
          'branchId': branchId,
          'status': status,
          'ticketName': ticketName,
          'subTotal': subTotal,
          'isOriginalTransaction': true,
          'transactionType': 'Sale',
          'isLoan': isLoan,
          'dueDate': dueDate,
        },
      },
    );
  }

  Future<String?> statusOf(String id) async {
    final r = await store.execute(
      'SELECT * FROM transactions WHERE _id = :id',
      arguments: {'id': id},
    );
    return r.items.first.value['status'] as String?;
  }

  setUpAll(() async {
    if (!hasDitto) return;
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('ditto_kitchen_orders');
    PathProviderPlatform.instance = _FakePaths(dir.path);
    await Ditto.init();
    final ditto = await Ditto.open(
      DittoConfig(
        databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeef',
        connect: const DittoConfigConnectSmallPeersOnly(),
        persistenceDirectory: dir.path,
      ),
    );
    store = ditto.store;
    await store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
  });

  final skip = hasDitto
      ? false
      : 'set LIBDITTOFFI_PATH to run against a real Ditto store';

  test(
    'only sent tickets are active; moving never touches ticket status',
    skip: skip,
    () async {
      await ticket('plain');
      await ticket('sent');
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'sent',
        branchId: branch,
        sentBy: 'u1',
      );

      var active = await activeKitchenOrdersOnStore(store, branch);
      expect(active.map((o) => o.transactionId), ['sent']);
      expect(active.single.stage, KitchenStage.incoming);

      for (final stage in [KitchenStage.inProgress, KitchenStage.ready]) {
        await updateKitchenStageOnStore(
          store,
          transactionId: 'sent',
          stage: stage,
          dueDate: DateTime.utc(2026, 9, 25, 13),
        );
        expect(await statusOf('sent'), 'parked', reason: '$stage');
      }
      active = await activeKitchenOrdersOnStore(store, branch);
      expect(active.single.stage, KitchenStage.ready);
      expect(active.single.dueDate, DateTime.utc(2026, 9, 25, 13));

      await updateKitchenStageOnStore(
        store,
        transactionId: 'sent',
        stage: KitchenStage.served,
      );
      expect(await activeKitchenOrdersOnStore(store, branch), isEmpty);
      expect(await statusOf('sent'), 'parked');
    },
  );

  test(
    're-sending keeps the stage; re-sending a served order restarts it',
    skip: skip,
    () async {
      await ticket('again');
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'again',
        branchId: branch,
      );
      await updateKitchenStageOnStore(
        store,
        transactionId: 'again',
        stage: KitchenStage.inProgress,
      );
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'again',
        branchId: branch,
      );
      expect(
        (await kitchenOrderOnStore(store, 'again'))!.stage,
        KitchenStage.inProgress,
      );

      await updateKitchenStageOnStore(
        store,
        transactionId: 'again',
        stage: KitchenStage.served,
      );
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'again',
        branchId: branch,
      );
      expect(
        (await kitchenOrderOnStore(store, 'again'))!.stage,
        KitchenStage.incoming,
      );
    },
  );

  test('a paid ticket stays on the display until served', skip: skip, () async {
    await ticket('paid');
    await sendTicketToKitchenOnStore(
      store,
      transactionId: 'paid',
      branchId: branch,
    );
    await store.execute(
      "UPDATE transactions SET status = 'completed' WHERE _id = 'paid'",
    );
    final active = await activeKitchenOrdersOnStore(store, branch);
    expect(active.map((o) => o.transactionId), contains('paid'));

    final tickets = await store.execute(
      kitchenTicketsDql,
      arguments: {
        'ids': ['paid'],
      },
    );
    expect(tickets.items.single.value['status'], 'completed');
  });

  test(
    'legacy repair returns stranded tickets to parked, skips MoMo rows',
    skip: skip,
    () async {
      await ticket('stuck_cooking', status: 'inProgress');
      await ticket('stuck_ready', status: 'waiting');
      await ticket('momo', status: 'waiting', ticketName: null);
      await ticket('other_branch', status: 'inProgress', branchId: 'b2');

      final repaired = await repairLegacyKitchenStatusesOnStore(
        store,
        branchId: branch,
      );
      expect(repaired, 2);
      expect(await statusOf('stuck_cooking'), 'parked');
      expect(await statusOf('stuck_ready'), 'parked');
      expect(await statusOf('momo'), 'waiting');
      expect(await statusOf('other_branch'), 'inProgress');

      expect(
        (await kitchenOrderOnStore(store, 'stuck_cooking'))!.stage,
        KitchenStage.inProgress,
      );
      expect(
        (await kitchenOrderOnStore(store, 'stuck_ready'))!.stage,
        KitchenStage.ready,
      );
      expect(await kitchenOrderOnStore(store, 'momo'), isNull);

      // Idempotent.
      expect(
        await repairLegacyKitchenStatusesOnStore(store, branchId: branch),
        0,
      );
    },
  );

  test(
    'serving stamps servedAt and tags the ticket for the cashier',
    skip: skip,
    () async {
      await ticket('to_serve');
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'to_serve',
        branchId: branch,
      );
      final at = DateTime.utc(2026, 9, 25, 14);
      await updateKitchenStageOnStore(
        store,
        transactionId: 'to_serve',
        stage: KitchenStage.served,
        now: at,
      );
      final served = (await kitchenOrderOnStore(store, 'to_serve'))!;
      expect(served.stage, KitchenStage.served);
      expect(served.servedAt, at);
      expect(await statusOf('to_serve'), 'parked');

      Future<List<String>> tagged(DateTime since) async {
        final r = await store.execute(
          kitchenTicketTagsDql,
          arguments: kitchenTicketTagsArgs(branch, since),
        );
        return kitchenOrdersFromResult(r).map((o) => o.transactionId).toList();
      }

      // Served inside the window: tagged. Window starting after it: not.
      expect(
        await tagged(at.subtract(const Duration(hours: 1))),
        contains('to_serve'),
      );
      expect(
        await tagged(at.add(const Duration(hours: 1))),
        isNot(contains('to_serve')),
      );
      // Still-active orders are tagged regardless of the window.
      await ticket('cooking');
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'cooking',
        branchId: branch,
      );
      expect(
        await tagged(at.add(const Duration(days: 30))),
        contains('cooking'),
      );
    },
  );

  test(
    'serving a ticket stranded on a kitchen status returns it to parked',
    skip: skip,
    () async {
      await ticket('stranded_serve', status: 'waiting');
      await store.execute(
        'INSERT INTO kitchen_orders DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {
          'doc': const KitchenOrder(
            transactionId: 'stranded_serve',
            branchId: branch,
            stage: KitchenStage.ready,
          ).toDitto(),
        },
      );
      await updateKitchenStageOnStore(
        store,
        transactionId: 'stranded_serve',
        stage: KitchenStage.served,
      );
      expect(await statusOf('stranded_serve'), 'parked');

      // A paid ticket is never reopened by serving it.
      await ticket('paid_serve', status: 'completed');
      await sendTicketToKitchenOnStore(
        store,
        transactionId: 'paid_serve',
        branchId: branch,
      );
      await updateKitchenStageOnStore(
        store,
        transactionId: 'paid_serve',
        stage: KitchenStage.served,
      );
      expect(await statusOf('paid_serve'), 'completed');
    },
  );

  test(
    'repair keeps a kitchen due date but never copies a loan due date',
    skip: skip,
    () async {
      await ticket(
        'stuck_timed',
        status: 'inProgress',
        dueDate: '2026-09-25T12:30:00.000Z',
      );
      await ticket(
        'stuck_loan',
        status: 'inProgress',
        isLoan: true,
        dueDate: '2026-10-09T00:00:00.000Z',
      );
      await repairLegacyKitchenStatusesOnStore(store, branchId: branch);

      expect(
        (await kitchenOrderOnStore(store, 'stuck_timed'))!.dueDate,
        DateTime.utc(2026, 9, 25, 12, 30),
      );
      final loan = (await kitchenOrderOnStore(store, 'stuck_loan'))!;
      expect(loan.dueDate, isNull);
      expect(await statusOf('stuck_loan'), 'parked');
    },
  );
}
