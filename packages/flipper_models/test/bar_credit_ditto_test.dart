// Puts a bar tab on credit against a real local Ditto store in
// DQL_STRICT_MODE, as production does. `flutter test` has no Ditto native
// library, so this skips unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/bar_credit_ditto_test.dart
import 'dart:async';
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/capella/mixins/bar_mixin.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:talker/talker.dart';

const _branch = 'branch-1';

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

class _BarSync with CapellaBarMixin {
  _BarSync(this.ditto);

  final Ditto ditto;

  @override
  dynamic get dittoHandle => ditto;

  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  final Talker talker = Talker();
}

class _FakeBox extends Mock implements LocalStorage {
  @override
  String? getBranchId() => _branch;
  @override
  String? getBusinessId() => 'biz1';
  @override
  String? paymentType() => 'Cash';
  @override
  bool isProformaMode() => false;
  @override
  bool isTrainingMode() => false;
}

const _table = BarTable(
  id: 'table-1',
  branchId: _branch,
  zoneId: 'zone-1',
  zoneName: 'Main Bar',
  name: 'B4',
  seats: 2,
);

void main() {
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;

  test(
    'a tab on credit leaves the floor and reaches the credit list',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await getIt.reset();
      getIt.registerSingleton<LocalStorage>(_FakeBox());
      ITransactionDittoAdapter.instance.overrideBranchIdProvider(() => _branch);
      ITransactionDittoAdapter.instance.overrideBusinessIdProvider(
        () => 'biz1',
      );
      final dir = await Directory.systemTemp.createTemp('ditto_bar_credit');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      final ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeee50',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      await ditto.store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
      final sync = _BarSync(ditto);

      final tab = await sync.openBarTab(
        branchId: _branch,
        table: _table,
        cashierTenantId: 'c1',
        cashierName: 'Richie',
      );
      await ditto.store.execute(
        'INSERT INTO transaction_items DOCUMENTS (:doc)',
        arguments: {
          'doc': {
            '_id': 'line-1',
            'id': 'line-1',
            'transactionId': tab.id,
            'branchId': _branch,
            'name': 'Beer',
            'qty': 1,
            'price': 3500,
            'variantId': 'v1',
            'active': true,
            'doneWithTransaction': false,
          },
        },
      );
      expect(
        (await sync.barTabsStream(branchId: _branch).first).map((t) => t.id),
        [tab.id],
      );
      final credit = sync.barCreditTabsStream(branchId: _branch);
      final seen = <List<String>>[];
      final first = Completer<void>();
      final parked = Completer<void>();
      final sub = credit.listen((l) {
        final ids = l.map((t) => t.id).toList();
        seen.add(ids);
        if (!first.isCompleted) first.complete();
        if (ids.contains(tab.id) && !parked.isCompleted) parked.complete();
      });
      // Listening before the tab goes on credit: nothing is owed yet.
      await first.future.timeout(const Duration(seconds: 10));
      expect(seen.first, isEmpty);

      await sync.parkBarTabAsLoan(
        transaction: tab,
        lines: await sync.barTabLines(transactionId: tab.id),
        customerId: 'cust-1',
        customerName: 'Aline',
        customerPhone: '788000000',
        dueDate: DateTime.utc(2026, 11, 9),
      );
      // The observer, not a later query, delivers the new loan.
      await parked.future.timeout(const Duration(seconds: 10));

      final stored = (await ditto.store.execute(
        'SELECT * FROM transactions WHERE _id = :id',
        arguments: {'id': tab.id},
      )).items.single.value;

      expect(stored['isLoan'], isTrue);
      expect(stored['tableId'], isNull);
      expect(await sync.barTabsStream(branchId: _branch).first, isEmpty);
      expect(
        (await sync.barCreditTabsStream(branchId: _branch).first).map(
          (t) => t.id,
        ),
        [tab.id],
      );
      // The floor button listens before the tab goes on credit.
      expect(seen.last, [tab.id]);

      await sub.cancel();
      await ditto.close();
      ITransactionDittoAdapter.instance.resetOverrides();
      await getIt.reset();
    },
  );
}
