import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/mpos_customer_actions_provider.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_customer_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _FakeCustomers extends CustomersNotifier {
  _FakeCustomers(this.customers);
  final List<Customer> customers;

  @override
  AsyncValue<List<Customer>> build() => AsyncValue.data(customers);
}

class _FakeActions implements MposCustomerActions {
  final attached = <Customer>[];
  final added = <({String phone, String name})>[];

  @override
  Future<void> attach(Customer customer, ITransaction transaction) async {
    attached.add(customer);
  }

  @override
  Future<Customer> quickAdd({
    required String phone,
    required String name,
    required ITransaction transaction,
  }) async {
    added.add((phone: phone, name: name));
    return Customer(custNm: name.isEmpty ? phone : name, telNo: phone);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _sale = ITransaction(
  id: 'txn-1',
  branchId: 'branch-1',
  status: PENDING,
  transactionType: 'sale',
  paymentType: 'CASH',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 10, 10),
  isIncome: true,
  isExpense: false,
  agentId: 'agent-test',
  subTotal: 0,
);

final _jean = Customer(
  custNm: 'Jean Mugabo',
  telNo: '0788123456',
  branchId: 'branch-1',
  updatedAt: DateTime.utc(2026, 10, 9),
);
final _aline = Customer(
  custNm: 'Aline Keza',
  telNo: '0722555010',
  branchId: 'branch-1',
  updatedAt: DateTime.utc(2026, 10, 10),
);

Future<_FakeActions> _openSheet(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final actions = _FakeActions();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        customersProvider.overrideWith(() => _FakeCustomers([_jean, _aline])),
        mposCustomerActionsProvider.overrideWithValue(actions),
        customerPhoneNumberProvider.overrideWith((ref) => null),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => MposCustomerSheet.show(
                  context: context,
                  ref: ref,
                  transaction: _sale,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return actions;
}

Finder get _phoneField => find.descendant(
  of: find.byKey(const ValueKey('mposCustomerPhoneField')),
  matching: find.byType(TextField),
);

Finder get _nameField => find.descendant(
  of: find.byKey(const ValueKey('mposCustomerNameField')),
  matching: find.byType(TextField),
);

void main() {
  testWidgets('recent customers show before typing; one tap attaches', (
    tester,
  ) async {
    final actions = await _openSheet(tester);

    expect(find.text('RECENT'), findsOneWidget);
    // Newest first.
    expect(
      tester.getTopLeft(find.text('Aline Keza')).dy,
      lessThan(tester.getTopLeft(find.text('Jean Mugabo')).dy),
    );

    await tester.tap(find.text('Jean Mugabo'));
    await tester.pumpAndSettle();

    expect(actions.attached, [_jean]);
    expect(actions.added, isEmpty);
    expect(find.byType(MposCustomerSheetBody), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('a new phone alone adds and attaches the customer', (
    tester,
  ) async {
    final actions = await _openSheet(tester);

    expect(find.text('Enter a phone number'), findsOneWidget);
    await tester.enterText(_phoneField, '0733000111');
    await tester.pump();
    expect(
      find.text('No match. Add them with the button below.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Add 0733000111'));
    await tester.pumpAndSettle();

    expect(actions.added, [(phone: '0733000111', name: '')]);
    expect(find.byType(MposCustomerSheetBody), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('Done on the name field saves with the typed name', (
    tester,
  ) async {
    final actions = await _openSheet(tester);

    await tester.enterText(_phoneField, '0733000111');
    await tester.enterText(_nameField, 'Claude N');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(actions.added, [(phone: '0733000111', name: 'Claude N')]);
  });

  testWidgets('a known phone attaches that customer instead of a duplicate', (
    tester,
  ) async {
    final actions = await _openSheet(tester);

    await tester.enterText(_phoneField, '+250788123456');
    await tester.pump();

    expect(find.text('MATCHES'), findsOneWidget);
    await tester.tap(find.text('Use Jean Mugabo'));
    await tester.pumpAndSettle();

    expect(actions.attached, [_jean]);
    expect(actions.added, isEmpty);
  });

  testWidgets('fits a phone with the keyboard up', (tester) async {
    tester.view.viewInsets = const FakeViewPadding(bottom: 336);
    await _openSheet(tester);
    await tester.enterText(_phoneField, '0788');
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Enter a phone number'), findsOneWidget);
  });

  testWidgets('the add button stays disabled for a short number', (
    tester,
  ) async {
    final actions = await _openSheet(tester);

    await tester.enterText(_phoneField, '07881');
    await tester.pump();
    await tester.tap(find.text('Enter a phone number'));
    await tester.pumpAndSettle();

    expect(actions.added, isEmpty);
    expect(find.byType(MposCustomerSheetBody), findsOneWidget);
  });
}
