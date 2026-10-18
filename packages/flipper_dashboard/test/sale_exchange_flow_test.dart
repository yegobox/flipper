import 'package:flipper_dashboard/features/exchange/sale_exchange_flow.dart';
import 'package:flipper_dashboard/services/sale_exchange_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _phone = Size(390, 844);
const _desktop = Size(1280, 800);

TransactionItem _line(String id, String name, num price, {num qty = 1}) =>
    TransactionItem(
      id: id,
      name: name,
      variantId: 'v-$id',
      qty: qty,
      price: price,
      prc: price,
      discount: 0,
      ttCatCd: 'B',
      totAmt: price * qty,
    );

Variant _variant(String id, String name, double price) =>
    Variant(id: id, name: name, branchId: 'b1', retailPrice: price);

ITransaction _sale({String? customerTin}) => ITransaction(
  branchId: 'b1',
  status: 'completed',
  transactionType: 'Sale',
  receiptType: 'NS',
  paymentType: 'CASH',
  subTotal: 10000,
  cashReceived: 10000,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 10, 18),
  isIncome: true,
  isExpense: false,
  agentId: 'a1',
  customerTin: customerTin,
);

/// Answers the flow from memory: no Ditto, no RRA.
class _FakeService extends SaleExchangeService {
  _FakeService({required this.lines, required this.catalog});

  final List<ExchangeableLine> lines;
  final List<Variant> catalog;
  SaleExchangeRequest? executed;

  /// Thrown by [execute] instead of saving, when set.
  Object? executeError;
  final resumed = <String>[];

  @override
  Future<List<ExchangeableLine>> exchangeableLines(
    ITransaction original,
  ) async => lines;

  @override
  Future<List<({Variant variant, double? onHand})>> searchVariants(
    String query,
  ) async => [
    for (final v in catalog)
      if (v.name.toLowerCase().contains(query.toLowerCase()))
        (
          variant: v,
          onHand: switch (v.id) {
            'sold-out' => 0.0,
            'last-one' => 1.0,
            _ => 10.0,
          },
        ),
  ];

  @override
  Future<SaleExchangeResult> resumeExchange(String exchangeId) async {
    resumed.add(exchangeId);
    return SaleExchangeResult(
      returnTransaction: _sale(),
      saleTransaction: _sale(),
      totals: const ExchangeTotals(returned: 4000, taken: 5500),
      receipts: const [],
      saleSigned: true,
    );
  }

  @override
  Future<SaleExchangeResult> execute(SaleExchangeRequest request) async {
    executed = request;
    final error = executeError;
    if (error != null) throw error;
    final back = lines
        .where((l) => request.returns.containsKey(l.line.id))
        .fold<double>(
          0,
          (s, l) => s + l.unitValue * request.returns[l.line.id]!,
        );
    final taken = request.takes.fold<double>(0, (s, t) => s + t.total);
    return SaleExchangeResult(
      returnTransaction: _sale(),
      saleTransaction: _sale(),
      totals: ExchangeTotals(returned: back, taken: taken),
      receipts: const [],
      saleSigned: true,
    );
  }
}

Future<_FakeService> _open(
  WidgetTester tester, {
  required Size size,
  List<ExchangeableLine>? lines,
  ITransaction? sale,
  bool vat = false,
  Object? executeError,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final service = _FakeService(
    lines:
        lines ??
        [
          ExchangeableLine(line: _line('a', 'Shirt', 6000), alreadyReturned: 0),
          ExchangeableLine(line: _line('b', 'Shoes', 4000), alreadyReturned: 0),
        ],
    catalog: [
      _variant('boots', 'Boots', 5500),
      _variant('socks', 'Socks', 3000),
      _variant('belt', 'Belt', 4000),
      _variant('sold-out', 'Sold out hat', 2000),
      _variant('last-one', 'Last scarf', 2500),
    ],
  )..executeError = executeError;
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showSaleExchangeFlow(
                context,
                transaction: sale ?? _sale(),
                currency: 'RWF',
                service: service,
                ebmWillSign: () async => vat,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return service;
}

Future<void> _tapPlusOn(WidgetTester tester, Key cardKey) async {
  await tester.tap(
    find.descendant(of: find.byKey(cardKey), matching: find.byIcon(Icons.add)),
  );
  await tester.pumpAndSettle();
}

Future<void> _next(WidgetTester tester) async {
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();
}

Future<void> _take(WidgetTester tester, String query, String id) async {
  await tester.enterText(find.byKey(const ValueKey('exchange-search')), query);
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey('result-$id')));
  await tester.pumpAndSettle();
}

void main() {
  for (final (label, size) in [('phone', _phone), ('desktop', _desktop)]) {
    group('on $label', () {
      testWidgets('walks the three steps; customer pays the difference', (
        tester,
      ) async {
        final service = await _open(tester, size: size);

        expect(find.text('Step 1 of 3'), findsOneWidget);
        expect(
          find.text('What is the customer bringing back?'),
          findsOneWidget,
        );
        // Nothing chosen yet: Next is off and says why.
        expect(
          find.text('Choose at least one item the customer is bringing back'),
          findsOneWidget,
        );
        await _tapPlusOn(tester, const ValueKey('back-b'));
        expect(
          find.text('Choose at least one item the customer is bringing back'),
          findsNothing,
        );
        await _next(tester);

        expect(find.text('What are they taking instead?'), findsOneWidget);
        expect(find.text('No items chosen yet'), findsOneWidget);
        await _take(tester, 'boo', 'boots');
        await _next(tester);

        expect(find.text('Money'), findsOneWidget);
        expect(find.text('Customer pays RWF 1,500'), findsOneWidget);
        expect(
          find.text('Bringing back RWF 4,000 · Taking RWF 5,500'),
          findsOneWidget,
        );
        await tester.tap(find.text('Confirm exchange'));
        await tester.pumpAndSettle();

        expect(find.text('Exchange done'), findsOneWidget);
        expect(service.executed!.returns, {'b': 1});
        expect(service.executed!.takes.single.variant.id, 'boots');
        expect(service.executed!.paymentMethod, 'CASH');
      });

      testWidgets('cheaper item: give the difference back', (tester) async {
        await _open(tester, size: size);
        await _tapPlusOn(tester, const ValueKey('back-b'));
        await _next(tester);
        await _take(tester, 'soc', 'socks');
        await _next(tester);
        expect(find.text('Give back to customer RWF 1,000'), findsOneWidget);
        expect(find.text('How is the money paid?'), findsOneWidget);
      });

      testWidgets('same price: nothing to pay, no payment question', (
        tester,
      ) async {
        await _open(tester, size: size);
        await _tapPlusOn(tester, const ValueKey('back-b'));
        await _next(tester);
        await _take(tester, 'bel', 'belt');
        await _next(tester);
        expect(find.text('Nothing to pay'), findsOneWidget);
        expect(find.text('How is the money paid?'), findsNothing);
      });
    });
  }

  testWidgets('phones get a sheet, desktop a dialog', (tester) async {
    await _open(tester, size: _phone);
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
  });

  testWidgets('desktop gets a dialog', (tester) async {
    await _open(tester, size: _desktop);
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('a single-item sale is pre-selected', (tester) async {
    await _open(
      tester,
      size: _phone,
      lines: [
        ExchangeableLine(line: _line('a', 'Shirt', 6000), alreadyReturned: 0),
      ],
    );
    expect(
      find.text('Choose at least one item the customer is bringing back'),
      findsNothing,
    );
  });

  testWidgets('already exchanged items cannot be chosen', (tester) async {
    await _open(
      tester,
      size: _phone,
      lines: [
        ExchangeableLine(line: _line('a', 'Shirt', 6000), alreadyReturned: 1),
        ExchangeableLine(line: _line('b', 'Shoes', 4000), alreadyReturned: 0),
      ],
    );
    expect(find.text('Already exchanged'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('back-a')),
        matching: find.byIcon(Icons.add),
      ),
      findsNothing,
    );
  });

  testWidgets('out-of-stock items cannot be taken', (tester) async {
    await _open(tester, size: _phone);
    await _tapPlusOn(tester, const ValueKey('back-b'));
    await _next(tester);
    await tester.enterText(
      find.byKey(const ValueKey('exchange-search')),
      'hat',
    );
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    expect(find.text('Out of stock'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('result-sold-out')));
    await tester.pumpAndSettle();
    expect(find.text('No items chosen yet'), findsOneWidget);
  });

  testWidgets('part of a unit can come back; it is not "already exchanged"', (
    tester,
  ) async {
    final service = await _open(
      tester,
      size: _phone,
      lines: [
        ExchangeableLine(
          line: _line('a', 'Rice', 2000, qty: 0.5),
          alreadyReturned: 0,
        ),
        ExchangeableLine(line: _line('b', 'Shoes', 4000), alreadyReturned: 0),
      ],
    );
    expect(find.text('Already exchanged'), findsNothing);
    await _tapPlusOn(tester, const ValueKey('back-a'));
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('back-a')),
        matching: find.text('0.50'),
      ),
      findsOneWidget,
    );
    await _next(tester);
    await _take(tester, 'soc', 'socks');
    await _next(tester);
    await tester.tap(find.text('Confirm exchange'));
    await tester.pumpAndSettle();
    expect(service.executed!.returns, {'a': 0.5});
  });

  testWidgets('tapping a search result never takes more than is on hand', (
    tester,
  ) async {
    await _open(tester, size: _phone);
    await _tapPlusOn(tester, const ValueKey('back-b'));
    await _next(tester);
    await _take(tester, 'sca', 'last-one');
    await tester.tap(find.byKey(const ValueKey('result-last-one')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('take-last-one')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
  });

  Future<void> confirmWith(WidgetTester tester, Object error) async {
    await _open(tester, size: _phone, executeError: error);
    await _tapPlusOn(tester, const ValueKey('back-b'));
    await _next(tester);
    await _take(tester, 'boo', 'boots');
    await _next(tester);
    await tester.tap(find.text('Confirm exchange'));
    await tester.pumpAndSettle();
  }

  testWidgets('an unexpected error says nothing changed', (tester) async {
    await confirmWith(tester, StateError('boom'));
    expect(
      find.text('Something went wrong. Nothing was changed. Try again.'),
      findsOneWidget,
    );
    expect(find.text('Confirm exchange'), findsOneWidget);
  });

  testWidgets('a partial save can only be finished, not confirmed again', (
    tester,
  ) async {
    await confirmWith(
      tester,
      SaleExchangeException(
        FlipperL10n.current.exchangePartlySaved,
        resumableExchangeId: 'x1',
      ),
    );
    expect(find.text(FlipperL10n.current.exchangePartlySaved), findsOneWidget);
    expect(find.text('Confirm exchange'), findsNothing);
    await tester.tap(find.text('Finish exchange'));
    await tester.pumpAndSettle();
    expect(find.text('Exchange done'), findsOneWidget);
  });

  testWidgets('opened to finish an exchange, it resumes that one', (
    tester,
  ) async {
    tester.view.physicalSize = _phone;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final service = _FakeService(lines: const [], catalog: const []);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showSaleExchangeFlow(
                context,
                transaction: _sale(),
                currency: 'RWF',
                service: service,
                ebmWillSign: () async => false,
                resumeExchangeId: 'x9',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(service.resumed, ['x9']);
    expect(find.text('Exchange done'), findsOneWidget);
  });

  group('purchase code', () {
    Future<void> toMoney(WidgetTester tester) async {
      await _tapPlusOn(tester, const ValueKey('back-b'));
      await _next(tester);
      await _take(tester, 'boo', 'boots');
      await _next(tester);
    }

    testWidgets('asked on EBM when the customer has a TIN', (tester) async {
      await _open(
        tester,
        size: _phone,
        sale: _sale(customerTin: '123456789'),
        vat: true,
      );
      await toMoney(tester);
      expect(
        find.byKey(const ValueKey('exchange-purchase-code')),
        findsOneWidget,
      );
      expect(find.text('Confirm exchange'), findsOneWidget);
      // Confirm stays off until the code is typed.
      final confirm = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Confirm exchange'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(confirm.onPressed, isNull);
    });

    testWidgets('never asked without a TIN', (tester) async {
      await _open(tester, size: _phone, vat: true);
      await toMoney(tester);
      expect(
        find.byKey(const ValueKey('exchange-purchase-code')),
        findsNothing,
      );
    });

    testWidgets('never asked off EBM', (tester) async {
      await _open(
        tester,
        size: _phone,
        sale: _sale(customerTin: '123'),
      );
      await toMoney(tester);
      expect(
        find.byKey(const ValueKey('exchange-purchase-code')),
        findsNothing,
      );
    });
  });
}
