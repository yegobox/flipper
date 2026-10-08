import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/data/books_bill_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ditto_store.dart';

/// Answers queries with fixed rows per collection.
class _Store extends FakeAccountingDittoStore {
  _Store(this.rows);

  final Map<String, List<Map<String, dynamic>>> rows;

  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async => rows[collection] ?? const [];
}

const _purchaseBill = {'_id': 'bill1', 'doc_kind': 'bill', 'purchase_id': 'p1'};

ProviderContainer _container(Map<String, List<Map<String, dynamic>>> rows) {
  final container = ProviderContainer(
    overrides: [billPaymentStoreProvider.overrideWithValue(_Store(rows))],
  );
  addTearDown(container.dispose);
  container.read(userProfileCacheProvider.notifier).state = UserProfile(
    id: 'user1',
    phoneNumber: '+250780000000',
    token: 't',
    tenants: const [],
  );
  container
      .read(selectedBranchProvider.notifier)
      .set(
        Branch(
          id: 'selected-branch',
          description: '',
          name: 'Main',
          longitude: '0',
          latitude: '0',
          businessId: 'biz',
          serverId: 1,
        ),
      );
  return container;
}

void main() {
  test("a purchase's bill pays out of that purchase's branch", () async {
    final container = _container({
      'accounting_documents': [_purchaseBill],
      'purchases': [
        {'_id': 'p1', 'branchId': 'purchase-branch'},
      ],
    });
    final cashOut = await container.read(booksBillCashOutProvider)('bill1');
    expect(cashOut!.branchId, 'purchase-branch');
    expect(cashOut.agentId, 'user1');
  });

  test('falls back to the selected branch when the purchase is not synced '
      'here', () async {
    final container = _container({
      'accounting_documents': [_purchaseBill],
    });
    final cashOut = await container.read(booksBillCashOutProvider)('bill1');
    expect(cashOut!.branchId, 'selected-branch');
  });

  test('a bill not raised from a purchase gets no cash-out', () async {
    final container = _container({
      'accounting_documents': [
        {'_id': 'bill2', 'doc_kind': 'bill'},
      ],
    });
    expect(await container.read(booksBillCashOutProvider)('bill2'), isNull);
  });
}
