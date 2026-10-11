import 'package:flipper_dashboard/providers/mpos_customer_actions_provider.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _FakeCapella implements DatabaseSyncInterface {
  Customer? added;
  String? addedToTransaction;
  Customer? assigned;

  @override
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  }) async {
    added = customer;
    addedToTransaction = transactionId;
    return customer;
  }

  @override
  Future<void> assignCustomerToTransaction({
    required Customer customer,
    required ITransaction transaction,
  }) async {
    assigned = customer;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeBox implements LocalStorage {
  final values = <String, String>{};

  @override
  String? getBranchId() => 'branch-1';

  @override
  Future<String?> bhfId() async => '00';

  @override
  Future<void> writeString({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  dynamic remove({required String key}) => values.remove(key);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ITransaction _sale() => ITransaction(
  id: 'txn-1',
  branchId: 'branch-1',
  status: PENDING,
  transactionType: 'sale',
  paymentType: 'CASH',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.now().toUtc(),
  isIncome: true,
  isExpense: false,
  agentId: 'agent-test',
  subTotal: 0,
);

void main() {
  late _FakeCapella capella;
  late _FakeBox box;
  late MposCustomerActions actions;

  setUp(() {
    capella = _FakeCapella();
    box = _FakeBox();
    actions = MposCustomerActions(capella: capella, box: box);
  });

  test(
    'a phone alone saves a customer on the sale, named by the phone',
    () async {
      box.values['customerTin'] = '123456789';

      final saved = await actions.quickAdd(
        phone: ' 0788123456 ',
        name: '  ',
        transaction: _sale(),
      );

      expect(capella.addedToTransaction, 'txn-1');
      expect(saved.telNo, '0788123456');
      expect(saved.custNm, '0788123456');
      expect(saved.branchId, 'branch-1');
      expect(box.values['customerName'], '0788123456');
      expect(box.values['currentSaleCustomerPhoneNumber'], '0788123456');
      // The left-over TIN from an earlier sale must not stick to this one.
      expect(box.values.containsKey('customerTin'), isFalse);
    },
  );

  test(
    'quick-added customers carry no TIN, so no purchase-code prompt',
    () async {
      final saved = await actions.quickAdd(
        phone: '0788123456',
        name: 'Jean',
        transaction: _sale(),
      );

      expect(saved.custNm, 'Jean');
      expect(saved.custTin, isEmpty);
    },
  );

  test('attaching an existing customer keeps their TIN for the sale', () async {
    final customer = Customer(
      custNm: 'Acme Ltd',
      telNo: '0722555010',
      custTin: '101234567',
      branchId: 'branch-1',
    );

    await actions.attach(customer, _sale());

    expect(capella.assigned, same(customer));
    expect(box.values['customerName'], 'Acme Ltd');
    expect(box.values['customerTin'], '101234567');
  });
}
