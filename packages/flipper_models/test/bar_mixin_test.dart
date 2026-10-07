import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/capella/mixins/bar_mixin.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

// flutter test test/bar_mixin_test.dart

const _branch = 'branch-1';

/// Exercises [CapellaBarMixin] against an in-memory store.
class _BarSync with CapellaBarMixin {
  _BarSync(this.fake);

  final FakeDitto fake;

  @override
  dynamic get dittoHandle => fake;

  /// Never reached: [dittoHandle] is overridden above.
  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  final Talker talker = Talker();
}

/// Minimal box: opening a tab only asks for the default payment type and the
/// sale mode its receipt type comes from.
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
  zoneName: 'Terrace',
  name: 'T1',
  seats: 4,
);

void main() {
  late FakeDitto ditto;
  late _BarSync sync;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<LocalStorage>(_FakeBox());
    ITransactionDittoAdapter.instance.overrideBranchIdProvider(() => _branch);
    ITransactionDittoAdapter.instance.overrideBusinessIdProvider(() => 'biz1');
    ditto = FakeDitto();
    sync = _BarSync(ditto);
  });

  tearDown(() async {
    ITransactionDittoAdapter.instance.resetOverrides();
    await getIt.reset();
  });

  group('Transaction Report fields', () {
    test('an open tab carries a receipt type and a local report date',
        () async {
      final tab = await sync.openBarTab(
        branchId: _branch,
        table: _table,
        cashierTenantId: 'c1',
        cashierName: 'Richie',
      );

      final stored = ditto.store.collections['transactions']![tab.id]!;
      // Regression: a null receiptType crashed the Z/X report and left the
      // report's Type column blank for every bar tab.
      expect(stored['receiptType'], TransactionReceptType.NS);
      // Report windows are local wall clock compared as strings; a UTC stamp
      // files the hours after midnight under the previous day.
      expect(stored['createdAt'] as String, isNot(endsWith('Z')));
    });

    test('a settled tab is reported on the day it is paid, with its lines',
        () async {
      final tab = await sync.openBarTab(
        branchId: _branch,
        table: _table,
        cashierTenantId: 'c1',
        cashierName: 'Richie',
      );

      // A tab opened before midnight, with a round ordered then too.
      const lastNight = '2026-01-10T22:30:00.000';
      ditto.store.collections['transactions']![tab.id]!['createdAt'] =
          lastNight;
      ditto.store.seed('transaction_items', {
        '_id': 'line-1',
        'id': 'line-1',
        'transactionId': tab.id,
        'branchId': _branch,
        'name': 'Beer',
        'qty': 2,
        'price': 1500,
        'variantId': 'v1',
        'active': true,
        'doneWithTransaction': false,
        'createdAt': lastNight,
      });

      final open = await sync.barTabForTableById(tab.id);
      final before = DateTime.now();
      final settled = await sync.settleBarTab(
        transaction: open!,
        lines: await sync.barTabLines(transactionId: tab.id),
        paymentType: 'Cash',
        cashReceived: 3000,
        customerChangeDue: 0,
      );

      expect(settled.status, COMPLETE);
      expect(settled.createdAt!.isUtc, isFalse);
      expect(settled.createdAt!.isBefore(before), isFalse);

      final stored = ditto.store.collections['transactions']![tab.id]!;
      expect(stored['createdAt'], settled.createdAt!.toIso8601String());

      final line = ditto.store.collections['transaction_items']!['line-1']!;
      expect(line['createdAt'], settled.createdAt!.toIso8601String());
    });
  });
}
