import 'dart:async';
import 'dart:typed_data';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/services/sale_exchange_intent.dart';
import 'package:flipper_dashboard/services/sale_exchange_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// The Ditto store as the exchange sees it, in memory. Writes behave like
/// Capella's: `saveTransactionItem` prices a line as amountTotal (the unit
/// price) × qty, `collectPayment` totals price × qty, INSERTs of an existing
/// line fail, and transaction writes are upserts.
class _Store implements CapellaSync {
  final txns = <String, ITransaction>{};
  final items = <String, TransactionItem>{};
  final paymentRows = <String, ({double amount, String method})>{};
  final stockLevels = <String, double>{};
  final variantRows = <String, Variant>{};
  final calls = <Symbol, int>{};

  /// This device's LocalStorage, which survives a restart like the store.
  final prefs = <String, String>{};

  /// Methods that throw the next N times they are called.
  final failNext = <Symbol, int>{};

  /// Methods that throw on their Nth call (1-based).
  final failOnCall = <Symbol, int>{};

  List<TransactionItem> linesOf(String id) =>
      items.values.where((l) => l.transactionId == id).toList();

  @override
  dynamic noSuchMethod(Invocation i) {
    final name = i.memberName;
    calls[name] = (calls[name] ?? 0) + 1;
    final left = failNext[name] ?? 0;
    if (left > 0 || failOnCall[name] == calls[name]) {
      if (left > 0) failNext[name] = left - 1;
      return Future<Never>.error(StateError('injected $name failure'));
    }
    T arg<T>(Symbol s) => i.namedArguments[s] as T;

    switch (name) {
      case #transactionItems:
        final id = arg<String?>(#transactionId);
        return Future<List<TransactionItem>>.value(
          id == null ? items.values.toList() : linesOf(id),
        );
      case #exchangeReturnsForSale:
        final id = arg<String>(#originalTransactionId);
        return Future<List<ITransaction>>.value(
          txns.values
              .where(
                (t) => t.originalTransactionId == id && isExchangeReturn(t),
              )
              .toList(),
        );
      case #exchangeLegs:
        final id = arg<String>(#exchangeId);
        return Future<List<ITransaction>>.value(
          txns.values.where((t) => t.exchangeId == id).toList(),
        );
      case #addTransaction:
        final t = arg<ITransaction>(#transaction);
        txns[t.id] = t.copyWith();
        return Future<void>.value();
      case #deleteTransaction:
        final t = arg<ITransaction>(#transaction);
        txns.remove(t.id);
        items.removeWhere((_, l) => l.transactionId == t.id);
        return Future<bool>.value(true);
      case #saveTransactionItem:
        final v = arg<Variant>(#variation);
        final unit = arg<double>(#amountTotal);
        final qty = arg<double>(#updatableQty);
        final sale = arg<ITransaction>(#pendingTransaction);
        final pricing = SaleLinePricing.compute(unitPrice: unit, qty: qty);
        final line = TransactionItem(
          name: v.name,
          transactionId: sale.id,
          variantId: v.id,
          qty: qty,
          price: unit,
          prc: v.retailPrice ?? 0,
          totAmt: pricing.totAmt,
          discount: pricing.discount,
          taxAmt: pricing.taxAmt,
          taxblAmt: pricing.taxblAmt,
          ttCatCd: 'B',
          branchId: sale.branchId!,
        );
        items[line.id] = line;
        return Future<bool>.value(true);
      case #addTransactionItem:
        final line = arg<TransactionItem>(#item);
        if (items.containsKey(line.id)) {
          return Future<void>.error(StateError('duplicate line ${line.id}'));
        }
        items[line.id] = line;
        return Future<void>.value();
      case #getVariant:
        return Future<Variant?>.value(variantRows[arg<String>(#id)]);
      case #updateStock:
        final id = arg<String>(#stockId);
        stockLevels[id] = (stockLevels[id] ?? 0) + arg<double>(#currentStock);
        return Future<void>.value();
      case #updateShiftTotals:
        return Future<Shift>.error(StateError('no shift in tests'));
      case #collectPayment:
        final t = arg<ITransaction>(#transaction);
        final lines = arg<List<TransactionItem>>(#preloadedLineItems);
        t.subTotal = SaleLinePricing.cartNetSubtotal([
          for (final l in lines)
            (
              unitPrice: l.price.toDouble(),
              qty: l.qty.toDouble(),
              dcAmt: null,
              dcRt: null,
            ),
        ]);
        return Future<ITransaction>.value(t);
      case #markItemAsDoneWithTransaction:
        return Future<void>.value();
      case #savePaymentType:
        paymentRows[arg<String>(#transactionId)] = (
          amount: arg<double>(#amount),
          method: arg<String>(#paymentMethod),
        );
        return Future<void>.value();
    }
    return super.noSuchMethod(i);
  }
}

class _Box implements LocalStorage {
  _Box(this.prefs);
  final Map<String, String> prefs;

  @override
  String? getBranchId() => 'b1';
  @override
  String? getBusinessId() => 'biz1';
  @override
  String? getUserId() => null;
  @override
  bool isProformaMode() => false;
  @override
  bool isTrainingMode() => false;
  @override
  Future<String?> bhfId() async => '00';
  @override
  String? readString({required String key}) => prefs[key];
  @override
  Future<void> writeString({
    required String key,
    required String value,
  }) async => prefs[key] = value;
  @override
  Future<void> remove({required String key}) async => prefs.remove(key);
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Services extends BranchServices {
  _Services(this.store) : _box = _Box(store.prefs);
  final _Store store;
  final _Box _box;

  @override
  LocalStorage get box => _box;
  @override
  DatabaseSyncInterface get strategy => store;
}

const _shirtLineId = 'line-shirt';

/// A completed sale of two shirts at 6,000 each.
ITransaction _seedSale(_Store store) {
  final sale = ITransaction(
    branchId: 'b1',
    status: COMPLETE,
    transactionType: 'Sale',
    receiptType: 'NS',
    paymentType: 'CASH',
    subTotal: 12000,
    cashReceived: 12000,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 10, 18),
    isIncome: true,
    isExpense: false,
    agentId: 'a1',
  );
  store.txns[sale.id] = sale;
  store.items[_shirtLineId] = TransactionItem(
    id: _shirtLineId,
    name: 'Shirt',
    transactionId: sale.id,
    variantId: 'v-shirt',
    qty: 2,
    price: 6000,
    prc: 6000,
    discount: 0,
    ttCatCd: 'B',
    totAmt: 12000,
    branchId: 'b1',
  );
  store.variantRows['v-shirt'] = Variant(
    id: 'v-shirt',
    name: 'Shirt',
    branchId: 'b1',
    retailPrice: 6000,
    stockId: 'stock-shirt',
  );
  return sale;
}

final _socks = Variant(
  id: 'v-socks',
  name: 'Socks',
  branchId: 'b1',
  retailPrice: 1000,
);

/// RRA as the exchange sees it. Accepting a return stamps it the way rw_tax
/// does (and tells the exchange at once).
class _Rra {
  int returnCalls = 0;
  int saleCalls = 0;
  int invoiceNo = 100;
  String returnCode = '000';

  /// Never answers: the app stops while RRA is being asked.
  bool hangBeforeAnswer = false;

  /// Accepts the return, then never returns: the app stops while building
  /// the receipt.
  bool hangAfterAccept = false;

  Future<({String? resultCd, Uint8List? bytes})> sign({
    required ITransaction transaction,
    required List<TransactionItem> items,
    required bool isReturn,
    String? purchaseCode,
  }) async {
    if (!isReturn) {
      saleCalls++;
      return (resultCd: '000', bytes: Uint8List.fromList([2]));
    }
    returnCalls++;
    if (hangBeforeAnswer) return Completer<Never>().future;
    if (returnCode != '000') return (resultCd: returnCode, bytes: null);
    markExchangeReturnSigned(transaction, invoiceNo++);
    await notifyExchangeReturnSigned(transaction);
    if (hangAfterAccept) return Completer<Never>().future;
    return (resultCd: '000', bytes: Uint8List.fromList([1]));
  }
}

SaleExchangeService _service(
  _Store store, {
  List<String>? deducted,
  _Rra? rra,
}) => SaleExchangeService(
  services: _Services(store),
  ebmWillSign: () async => rra != null,
  sign: rra?.sign,
  deductSaleStock:
      ({
        required List<TransactionItem> lines,
        required String transactionId,
        required bool vat,
        required String businessId,
      }) async => deducted?.add(transactionId),
);

SaleExchangeRequest _request(ITransaction original, {double takeQty = 2}) =>
    SaleExchangeRequest(
      original: original,
      returns: const {_shirtLineId: 1},
      takes: [ExchangeTake(variant: _socks, qty: takeQty)],
      paymentMethod: 'CASH',
    );

void main() {
  final l10n = FlipperL10n.current;

  test('a take of 2 is priced at its unit price, not unit × 2 × 2', () async {
    final store = _Store();
    final original = _seedSale(store);

    final result = await _service(store).execute(_request(original));

    final sale = result.saleTransaction;
    final lines = store.linesOf(sale.id);
    expect(lines, hasLength(1));
    expect(lines.single.qty, 2);
    expect(lines.single.price, 1000);
    expect(lines.single.totAmt, 2000);
    expect(sale.subTotal, 2000);
    expect(store.txns[sale.id]!.status, COMPLETE);
    expect(store.paymentRows[sale.id]?.amount, 2000);
    expect(result.totals.returned, 6000);
    expect(result.totals.taken, 2000);
    expect(result.totals.difference, -4000);
  });

  test('a failed read before any write reports nothing changed', () async {
    final store = _Store();
    final original = _seedSale(store);
    store.failNext[#exchangeReturnsForSale] = 1;

    await expectLater(
      _service(store).execute(_request(original)),
      throwsA(
        isA<SaleExchangeException>()
            .having(
              (e) => e.message,
              'message',
              l10n.exchangeFailedNothingChanged,
            )
            .having((e) => e.resumableExchangeId, 'resumable', isNull),
      ),
    );
    expect(store.txns, hasLength(1));
    expect(store.items, hasLength(1));
  });

  test('a partly saved exchange is finished without repeating work', () async {
    final store = _Store();
    final original = _seedSale(store);
    final deducted = <String>[];
    final service = _service(store, deducted: deducted);
    store.failNext[#savePaymentType] = 1;

    late SaleExchangeException failure;
    try {
      await service.execute(_request(original));
      fail('expected a partial save');
    } on SaleExchangeException catch (e) {
      failure = e;
    }
    expect(failure.message, l10n.exchangePartlySaved);
    final id = failure.resumableExchangeId;
    expect(id, isNotNull);
    final draft = store.txns.values.singleWhere(
      (t) => t.exchangeId == id && !isExchangeReturn(t),
    );
    expect(draft.status, exchangeDraftStatus);
    expect(await service.unfinishedExchangeId(original), id);

    final result = await service.resumeExchange(id!);

    expect(store.txns[result.saleTransaction.id]!.status, COMPLETE);
    expect(store.paymentRows[result.saleTransaction.id]?.amount, 2000);
    expect(store.calls[#collectPayment], 1);
    expect(store.calls[#addTransactionItem], 1);
    expect(store.stockLevels['stock-shirt'], 1);
    expect(deducted, [result.saleTransaction.id]);
    expect(await service.unfinishedExchangeId(original), isNull);
  });

  test(
    'a draft left by an earlier session is finished from the store',
    () async {
      final store = _Store();
      final original = _seedSale(store);
      store.failNext[#markItemAsDoneWithTransaction] = 1;
      String? id;
      try {
        await _service(store).execute(_request(original));
      } on SaleExchangeException catch (e) {
        id = e.resumableExchangeId;
      }
      expect(id, isNotNull);

      // A new service: nothing in memory, only what was written.
      final later = _service(store);
      expect(await later.unfinishedExchangeId(original), id);
      final result = await later.resumeExchange(id!);

      expect(store.txns[result.saleTransaction.id]!.status, COMPLETE);
      expect(result.totals.returned, 6000);
      expect(result.totals.taken, 2000);
      // Payment was collected (and the shift credited) once, before the crash.
      expect(store.calls[#collectPayment], 1);
      expect(store.stockLevels['stock-shirt'], 1);
    },
  );

  test(
    'a failure while writing the return is retried in the session',
    () async {
      final store = _Store();
      final original = _seedSale(store);
      final service = _service(store);
      store.failNext[#updateStock] = 1;

      String? id;
      try {
        await service.execute(_request(original));
      } on SaleExchangeException catch (e) {
        id = e.resumableExchangeId;
      }
      expect(id, isNotNull);
      // The return row is written last, so it is not there yet.
      expect(store.txns.values.where(isExchangeReturn), isEmpty);

      final result = await service.resumeExchange(id!);

      expect(store.txns[result.returnTransaction.id], isNotNull);
      expect(store.calls[#addTransactionItem], 1);
      expect(store.stockLevels['stock-shirt'], 1);
      expect(store.txns[result.saleTransaction.id]!.status, COMPLETE);
    },
  );

  group('restart recovery (EBM)', () {
    Map<String, SaleExchangeIntent> intents(_Store store) =>
        SaleExchangeIntentStore(_Box(store.prefs)).all();

    /// Starts an exchange that never comes back (the app is killed), and
    /// returns the id of the exchange it left behind.
    Future<String> killedMidExchange(_Store store, _Rra rra) async {
      final original = store.txns.values.single;
      unawaited(
        _service(
          store,
          rra: rra,
        ).execute(_request(original)).then<void>((_) {}, onError: (_) {}),
      );
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
      return intents(store).keys.single;
    }

    test('a return RRA signed but never written is finished once after a '
        'restart', () async {
      final store = _Store();
      final original = _seedSale(store);
      final rra = _Rra();
      final deducted = <String>[];
      // _commitReturn fails at the return row (the draft sale was the first
      // addTransaction): lines written, stock back, shift credited.
      store.failOnCall[#addTransaction] = 2;

      String? id;
      try {
        await _service(
          store,
          rra: rra,
          deducted: deducted,
        ).execute(_request(original));
        fail('expected a partial save');
      } on SaleExchangeException catch (e) {
        expect(e.message, l10n.exchangePartlySaved);
        id = e.resumableExchangeId;
      }
      expect(id, isNotNull);
      expect(rra.returnCalls, 1);
      expect(store.txns.values.where(isExchangeReturn), isEmpty);
      expect(store.stockLevels['stock-shirt'], 1);
      final saved = intents(store)[id]!;
      expect(saved.signed, isTrue);
      expect(saved.ret.invoiceNumber, 100);
      expect(saved.restoredLineIds, hasLength(1));
      expect(saved.shiftRefunded, isTrue);

      // Restart: a new service, nothing in memory.
      final later = _service(store, rra: rra, deducted: deducted);
      expect(await later.hasExchanges(original), isTrue);
      expect(await later.unfinishedExchangeId(original), id);
      final result = await later.resumeExchange(id!);

      // RRA was not asked again for the return; the new sale was signed.
      expect(rra.returnCalls, 1);
      expect(rra.saleCalls, 1);
      expect(result.saleSigned, isTrue);
      final returns = store.txns.values.where(isExchangeReturn).toList();
      expect(returns, hasLength(1));
      expect(returns.single.id, result.returnTransaction.id);
      expect(returns.single.invoiceNumber, 100);
      expect(returns.single.ebmSynced, isTrue);
      expect(returns.single.subTotal, 6000);
      final returnLines = store.linesOf(returns.single.id);
      expect(returnLines, hasLength(1));
      expect(returnLines.single.qty, 1);
      expect(returnLines.single.totAmt, 6000);
      expect(store.calls[#addTransactionItem], 1);
      final sales = store.txns.values
          .where((t) => t.exchangeId == id && !isExchangeReturn(t))
          .toList();
      expect(sales, hasLength(1));
      expect(sales.single.status, COMPLETE);
      expect(store.paymentRows, hasLength(1));
      expect(store.paymentRows[sales.single.id]?.amount, 2000);
      expect(store.calls[#collectPayment], 1);
      // Stock: one shirt back exactly once, the socks out exactly once.
      expect(store.stockLevels['stock-shirt'], 1);
      expect(store.calls[#updateStock], 1);
      expect(deducted, [sales.single.id]);
      // Done: the intent is gone and nothing is offered any more.
      expect(intents(store), isEmpty);
      expect(await later.unfinishedExchangeId(original), isNull);
    });

    test(
      'a return accepted while the app stopped is not signed twice',
      () async {
        final store = _Store();
        _seedSale(store);
        final rra = _Rra()..hangAfterAccept = true;
        final id = await killedMidExchange(store, rra);
        // Saved the moment RRA accepted, before the receipt was built.
        expect(intents(store)[id]!.signed, isTrue);

        rra.hangAfterAccept = false;
        final result = await _service(store, rra: rra).resumeExchange(id);

        expect(rra.returnCalls, 1);
        expect(result.returnTransaction.invoiceNumber, 100);
        expect(store.txns.values.where(isExchangeReturn), hasLength(1));
        expect(intents(store), isEmpty);
      },
    );

    test('a return RRA never answered is signed on finish', () async {
      final store = _Store();
      final original = _seedSale(store);
      final rra = _Rra()..hangBeforeAnswer = true;
      final id = await killedMidExchange(store, rra);
      expect(intents(store)[id]!.signed, isFalse);

      rra.hangBeforeAnswer = false;
      final later = _service(store, rra: rra);
      expect(await later.unfinishedExchangeId(original), id);
      final result = await later.resumeExchange(id);

      expect(rra.returnCalls, 2);
      expect(result.receipts, hasLength(2));
      expect(store.txns[result.returnTransaction.id]?.ebmSynced, isTrue);
      expect(store.txns[result.saleTransaction.id]?.status, COMPLETE);
      expect(intents(store), isEmpty);
    });

    test('a return RRA refuses on finish is dropped with its draft', () async {
      final store = _Store();
      final original = _seedSale(store);
      final rra = _Rra()..hangBeforeAnswer = true;
      final id = await killedMidExchange(store, rra);

      rra
        ..hangBeforeAnswer = false
        ..returnCode = '910';
      await expectLater(
        _service(store, rra: rra).resumeExchange(id),
        throwsA(
          isA<SaleExchangeException>().having(
            (e) => e.message,
            'message',
            l10n.exchangeRraFailed,
          ),
        ),
      );
      expect(store.txns.keys, [original.id]);
      expect(intents(store), isEmpty);
      expect(await _service(store).unfinishedExchangeId(original), isNull);
    });

    test('RRA refusing the return at confirm keeps nothing', () async {
      final store = _Store();
      final original = _seedSale(store);
      final rra = _Rra()..returnCode = '910';

      await expectLater(
        _service(store, rra: rra).execute(_request(original)),
        throwsA(isA<SaleExchangeException>()),
      );
      expect(store.txns.keys, [original.id]);
      expect(store.items.keys, [_shirtLineId]);
      expect(intents(store), isEmpty);
    });

    test('a stale intent of a finished exchange is cleared', () async {
      final store = _Store();
      final original = _seedSale(store);
      final result = await _service(
        store,
        rra: _Rra(),
      ).execute(_request(original));
      // As if the app stopped after completing, before removing the intent.
      final box = SaleExchangeIntentStore(_Box(store.prefs));
      await box.save(
        SaleExchangeIntent(
          exchangeId: result.saleTransaction.exchangeId!,
          ret: result.returnTransaction,
          lines: const [],
          saleId: result.saleTransaction.id,
          paymentMethod: 'CASH',
          branchId: 'b1',
          businessId: 'biz1',
          vat: true,
        ),
      );

      expect(await _service(store).unfinishedExchangeId(original), isNull);
      expect(intents(store), isEmpty);
    });
  });
}
