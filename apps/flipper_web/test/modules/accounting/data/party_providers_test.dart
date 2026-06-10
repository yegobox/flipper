import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_documents_repository.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';
import '../../../helpers/fake_accounting_repository.dart';
import '../../../helpers/fake_party_repository.dart';

const _branchId = 'branch-1';

Party _party({
  String id = 'p-1',
  String name = 'Karake Retail',
  PartyKind kind = PartyKind.customer,
}) =>
    Party(
      id: id,
      name: name,
      phone: '0788123456',
      email: 'a@b.rw',
      tin: '123456789',
      branchId: _branchId,
      customerType: 'Business',
      kind: kind,
    );

AccountingContact _extension({
  String id = 'C-1',
  String? partyId = 'p-1',
  String uuid = 'ext-uuid-1',
  String terms = 'Net 15',
  String contact = 'Jean-Paul',
}) =>
    AccountingContact(
      id: id,
      name: 'ignored-by-join',
      contact: contact,
      phone: '',
      email: '',
      tin: '',
      since: 'Mar 2024',
      terms: terms,
      balance: 0,
      uuid: uuid,
      partyId: partyId,
    );

ProviderContainer _container({
  List<Party> parties = const [],
  List<AccountingContact> extensions = const [],
  List<Map<String, dynamic>> transactions = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      partyRepositoryProvider.overrideWithValue(
        FakePartyRepository(parties: List.of(parties)),
      ),
      partyBranchIdProvider.overrideWithValue(_branchId),
      accountingDocumentsRepositoryProvider.overrideWithValue(
        FakeAccountingDocumentsRepository(
          customerContacts: List.of(extensions),
        ),
      ),
      accountingRepositoryProvider.overrideWithValue(
        FakeAccountingRepository(transactions: transactions, items: const []),
      ),
      accountingLedgerRepositoryProvider.overrideWithValue(
        FakeAccountingLedgerRepository(),
      ),
      accountingBranchIdProvider.overrideWithValue(_branchId),
      accountingBusinessIdProvider.overrideWithValue('biz-test'),
    ],
  );
  container.listen(customerPartiesStreamProvider, (_, __) {});
  container.listen(customersStreamProvider, (_, __) {});
  container.listen(rawTransactionStreamProvider, (_, __) {});
  return container;
}

void main() {
  group('accountingCustomersProvider (party + extension join)', () {
    test('party identity overlays extension extras', () async {
      final container = _container(
        parties: [_party()],
        extensions: [_extension()],
      );
      addTearDown(container.dispose);
      await container.read(customerPartiesStreamProvider.future);
      await container.read(customersStreamProvider.future);

      final customers = container.read(accountingCustomersProvider);
      expect(customers.length, 1);
      final c = customers.single;
      // Identity from the canonical party row.
      expect(c.name, 'Karake Retail');
      expect(c.phone, '0788123456');
      expect(c.tin, '123456789');
      expect(c.partyId, 'p-1');
      // Extras from the extension record.
      expect(c.terms, 'Net 15');
      expect(c.contact, 'Jean-Paul');
      expect(c.since, 'Mar 2024');
      expect(c.uuid, 'ext-uuid-1');
    });

    test('party without extension gets defaults', () async {
      final container = _container(parties: [_party()]);
      addTearDown(container.dispose);
      await container.read(customerPartiesStreamProvider.future);
      await container.read(customersStreamProvider.future);

      final c = container.read(accountingCustomersProvider).single;
      expect(c.partyId, 'p-1');
      expect(c.terms, 'Net 30');
      expect(c.since, '—');
      expect(c.uuid, isNull);
    });

    test('legacy extension-only rows (no partyId) still listed', () async {
      final container = _container(
        extensions: [
          _extension(partyId: null).copyWith(name: 'Legacy Contact'),
        ],
      );
      addTearDown(container.dispose);
      await container.read(customerPartiesStreamProvider.future);
      await container.read(customersStreamProvider.future);

      final customers = container.read(accountingCustomersProvider);
      expect(customers.length, 1);
      expect(customers.single.name, 'Legacy Contact');
      expect(customers.single.partyId, isNull);
    });

    test('aging-derived rows still appear with fromAging and balance', () async {
      final container = _container(
        parties: [_party()],
        transactions: [
          {
            'id': 'txn-loan',
            'status': 'parked',
            'sub_total': 200000,
            'tax_amount': 0,
            'payment_type': 'CASH',
            'is_expense': false,
            'is_loan': true,
            'remaining_balance': 75000,
            'created_at': DateTime.now().toIso8601String(),
            'customer_name': 'Walk-in Debtor',
            'receipt_number': '9',
          },
        ],
      );
      addTearDown(container.dispose);
      await container.read(customerPartiesStreamProvider.future);
      await container.read(customersStreamProvider.future);
      await container.read(rawTransactionStreamProvider.future);

      final customers = container.read(accountingCustomersProvider);
      expect(customers.length, 2);
      final aging =
          customers.firstWhere((c) => c.name == 'Walk-in Debtor');
      expect(aging.fromAging, isTrue);
      expect(aging.balance, 75000);
      final persisted =
          customers.firstWhere((c) => c.name == 'Karake Retail');
      expect(persisted.partyId, 'p-1');
    });

    test('no demo seed contacts when stores are empty', () async {
      final container = _container();
      addTearDown(container.dispose);
      await container.read(customerPartiesStreamProvider.future);
      await container.read(customersStreamProvider.future);

      expect(container.read(accountingCustomersProvider), isEmpty);
    });
  });
}
