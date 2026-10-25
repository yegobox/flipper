import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_order_accept.dart';
import 'package:flipper_models/online_shop/online_order_ticket.dart';
import 'package:flipper_models/online_shop/online_shop_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

import 'online_order_test.dart' show orderDoc;

/// Records the POS writes the ticket writer makes.
class _FakeDb implements DatabaseSyncInterface {
  _FakeDb({this.known = const {'v1', 'v2'}});

  final Set<String> known;
  final lines = <(String variantId, double qty, double price)>[];
  String? parkedName;
  String? parkedNote;
  final log = <String>[];

  @override
  Future<bool> saveTransactionItem({
    double? compositePrice,
    required Variant variation,
    required double amountTotal,
    required bool ignoreForReport,
    required bool customItem,
    required bool doneWithTransaction,
    required ITransaction pendingTransaction,
    required double currentStock,
    bool useTransactionItemForQty = false,
    required bool partOfComposite,
    double? updatableQty,
    TransactionItem? item,
    int? invoiceNumber,
    String? sarTyCd,
    bool updatePendingTransactionSubtotal = true,
  }) async {
    lines.add((variation.id, updatableQty ?? 1, amountTotal));
    log.add('line ${variation.id}');
    return true;
  }

  @override
  Future<void> parkSaleTicketFast({
    required ITransaction transaction,
    required String ticketName,
    required String ticketNote,
    String? customerId,
    bool sendToKitchen = false,
  }) async {
    parkedName = ticketName;
    parkedNote = ticketNote;
    log.add('park');
  }

  /// `getVariant` has a dozen optional lookups; only `id` matters here.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getVariant) {
      final id = invocation.namedArguments[#id] as String?;
      return Future<Variant?>.value(
        known.contains(id) ? Variant(id: id, name: id!, branchId: 'br1') : null,
      );
    }
    throw UnimplementedError(invocation.memberName.toString());
  }
}

class _FakeClient extends OnlineShopClient {
  _FakeClient(this.log, {this.acceptResponse})
    : super(baseUrl: () async => 'https://unused.test/');

  final List<String> log;
  final OnlineOrder? acceptResponse;
  final calls = <(OnlineOrderAction, String?)>[];
  bool conflictOnAccept = false;

  @override
  Future<OnlineOrder> updateOrder({
    required String branchId,
    required String orderId,
    required OnlineOrderAction action,
    String? ticketTransactionId,
    String? smsId,
  }) async {
    if (action == OnlineOrderAction.accept && conflictOnAccept) {
      throw const OnlineShopException('invalid_transition', statusCode: 409);
    }
    calls.add((action, ticketTransactionId));
    log.add(action.wire);
    return acceptResponse ?? OnlineOrder.fromDitto(orderDoc());
  }
}

void main() {
  late _FakeDb db;
  late List<String> log;
  late ITransaction minted;

  OnlineOrderTicketWriter writer() => OnlineOrderTicketWriter(
    db: db,
    createTransaction: ({required branchId, required order}) async {
      log.add('create');
      return minted = ITransaction(
        branchId: branchId,
        status: 'pending',
        transactionType: 'Sale',
        paymentType: 'Cash',
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime(2026),
        isIncome: true,
        isExpense: false,
        agentId: 'u1',
      );
    },
  );

  setUp(() {
    db = _FakeDb();
    log = db.log;
  });

  test('accept → park lines → link ticket, in that order', () async {
    final client = _FakeClient(log);
    final id = await acceptOnlineOrder(
      client: client,
      writer: writer(),
      branchId: 'br1',
      order: OnlineOrder.fromDitto(orderDoc()),
      paidNote: 'PAID',
    );
    expect(log, [
      'accept',
      'create',
      'line v1',
      'line v2',
      'park',
      'link_ticket',
    ]);
    expect(id, minted.id);
    expect(db.lines, [('v1', 2.0, 1000.0), ('v2', 1.0, 3000.0)]);
    expect(db.parkedName, 'Online #12 – Aline');
    expect(client.calls.last, (OnlineOrderAction.linkTicket, minted.id));
  });

  test('an order paid by the time it is accepted gets the paid note', () async {
    final client = _FakeClient(
      log,
      acceptResponse: OnlineOrder.fromDitto(
        orderDoc(status: 'accepted', paymentStatus: 'paid'),
      ),
    );
    await acceptOnlineOrder(
      client: client,
      writer: writer(),
      branchId: 'br1',
      order: OnlineOrder.fromDitto(orderDoc()),
      paidNote: 'Paid by MoMo',
    );
    expect(db.parkedNote, startsWith('Paid by MoMo'));
  });

  test('a 409 on accept makes no ticket', () async {
    final client = _FakeClient(log)..conflictOnAccept = true;
    await expectLater(
      acceptOnlineOrder(
        client: client,
        writer: writer(),
        branchId: 'br1',
        order: OnlineOrder.fromDitto(orderDoc()),
        paidNote: 'PAID',
      ),
      throwsA(isA<OnlineShopException>()),
    );
    expect(log, isEmpty);
  });

  test('a variant missing from this device stops before parking', () async {
    db = _FakeDb(known: {'v1'});
    log = db.log;
    final client = _FakeClient(log);
    await expectLater(
      createOnlineOrderTicket(
        client: client,
        writer: writer(),
        branchId: 'br1',
        order: OnlineOrder.fromDitto(orderDoc(status: 'accepted')),
        paidNote: 'PAID',
      ),
      throwsStateError,
    );
    expect(log, ['create', 'line v1']);
    expect(db.parkedName, isNull);
    expect(client.calls, isEmpty);
  });
}
