import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// LocalStorage key holding every unfinished exchange intent of this device,
/// as a JSON map exchangeId → [SaleExchangeIntent]. Allow-listed in
/// `SharedPreferenceStorage._allowedKeys`.
const String saleExchangeIntentsBoxKey = 'saleExchangeIntents';

/// One returned line: rebuilt with `buildReturnLine` from the original sale's
/// line, which never changes, so the rebuilt line carries exactly the money
/// RRA signed.
class ExchangeIntentLine {
  const ExchangeIntentLine({
    required this.id,
    required this.originalLineId,
    required this.alreadyReturned,
    required this.qty,
    required this.total,
  });

  /// The return line's own id (kept so a rewrite finds what was written).
  final String id;
  final String originalLineId;
  final double alreadyReturned;
  final double qty;

  /// The line's value when the intent was written, for checking the rebuild.
  final double total;

  Map<String, dynamic> toJson() => {
    'id': id,
    'originalLineId': originalLineId,
    'alreadyReturned': alreadyReturned,
    'qty': qty,
    'total': total,
  };

  factory ExchangeIntentLine.fromJson(Map<String, dynamic> json) =>
      ExchangeIntentLine(
        id: json['id'] as String,
        originalLineId: json['originalLineId'] as String,
        alreadyReturned: (json['alreadyReturned'] as num).toDouble(),
        qty: (json['qty'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
      );
}

/// What an exchange needs to be finished after a restart, saved before RRA
/// is asked to sign its return and removed once the exchange is complete.
///
/// The new sale's draft and lines are already in the store when it is
/// written; the return exists nowhere else until its row is written, so the
/// intent carries the return itself ([ret], updated with RRA's numbers the
/// moment RRA accepts it) and how far writing it got.
class SaleExchangeIntent {
  SaleExchangeIntent({
    required this.exchangeId,
    required this.ret,
    required this.lines,
    required this.saleId,
    required this.paymentMethod,
    required this.branchId,
    required this.businessId,
    required this.vat,
    this.purchaseCode,
    Set<String>? restoredLineIds,
    this.shiftRefunded = false,
  }) : restoredLineIds = restoredLineIds ?? {};

  final String exchangeId;

  /// The return transaction (see [returnToJson] for what is kept).
  final ITransaction ret;
  final List<ExchangeIntentLine> lines;

  /// The draft new sale (status `exchangeDraft`).
  final String saleId;
  final String paymentMethod;
  final String branchId;
  final String businessId;

  /// True when RRA signs this exchange (an EBM branch).
  final bool vat;

  /// Sent again if the return has to be signed again (see [signed]).
  final String? purchaseCode;

  final Set<String> restoredLineIds;
  bool shiftRefunded;

  String get originalTransactionId => ret.originalTransactionId ?? '';

  /// False while RRA's answer is unknown: written before signing, the intent
  /// is only marked signed once RRA accepted the return.
  bool get signed => !vat || ret.ebmSynced == true;

  Map<String, dynamic> toJson() => {
    'exchangeId': exchangeId,
    'ret': returnToJson(ret),
    'lines': [for (final l in lines) l.toJson()],
    'saleId': saleId,
    'paymentMethod': paymentMethod,
    'branchId': branchId,
    'businessId': businessId,
    'vat': vat,
    'purchaseCode': purchaseCode,
    'restoredLineIds': restoredLineIds.toList(),
    'shiftRefunded': shiftRefunded,
  };

  factory SaleExchangeIntent.fromJson(Map<String, dynamic> json) =>
      SaleExchangeIntent(
        exchangeId: json['exchangeId'] as String,
        ret: returnFromJson(Map<String, dynamic>.from(json['ret'] as Map)),
        lines: [
          for (final l in json['lines'] as List)
            ExchangeIntentLine.fromJson(Map<String, dynamic>.from(l as Map)),
        ],
        saleId: json['saleId'] as String,
        paymentMethod: json['paymentMethod'] as String,
        branchId: json['branchId'] as String,
        businessId: json['businessId'] as String,
        vat: json['vat'] as bool,
        purchaseCode: json['purchaseCode'] as String?,
        restoredLineIds: {
          for (final id in (json['restoredLineIds'] as List? ?? const []))
            id as String,
        },
        shiftRefunded: json['shiftRefunded'] as bool? ?? false,
      );

  /// Every field the exchange sets on its return, plus what signing adds.
  static Map<String, dynamic> returnToJson(ITransaction t) => {
    'id': t.id,
    'branchId': t.branchId,
    'status': t.status,
    'transactionType': t.transactionType,
    'receiptType': t.receiptType,
    'paymentType': t.paymentType,
    'subTotal': t.subTotal,
    'taxAmount': t.taxAmount,
    'cashReceived': t.cashReceived,
    'customerChangeDue': t.customerChangeDue,
    'createdAt': t.createdAt?.toIso8601String(),
    'updatedAt': t.updatedAt?.toIso8601String(),
    'lastTouched': t.lastTouched?.toIso8601String(),
    'lastPaymentDate': t.lastPaymentDate?.toIso8601String(),
    'isIncome': t.isIncome,
    'isExpense': t.isExpense,
    'isOriginalTransaction': t.isOriginalTransaction,
    'originalTransactionId': t.originalTransactionId,
    'exchangeId': t.exchangeId,
    'invoiceNumber': t.invoiceNumber,
    'receiptNumber': t.receiptNumber,
    'totalReceiptNumber': t.totalReceiptNumber,
    'sarNo': t.sarNo,
    'agentId': t.agentId,
    'shiftId': t.shiftId,
    'customerId': t.customerId,
    'customerName': t.customerName,
    'customerTin': t.customerTin,
    'customerPhone': t.customerPhone,
    'customerBhfId': t.customerBhfId,
    'remark': t.remark,
    'ebmSynced': t.ebmSynced,
    'receiptPrinted': t.receiptPrinted,
  };

  static ITransaction returnFromJson(Map<String, dynamic> j) {
    DateTime? date(String key) =>
        j[key] == null ? null : DateTime.tryParse(j[key] as String);
    return ITransaction(
      id: j['id'] as String,
      branchId: j['branchId'] as String?,
      status: j['status'] as String?,
      transactionType: j['transactionType'] as String?,
      receiptType: j['receiptType'] as String?,
      paymentType: j['paymentType'] as String?,
      subTotal: (j['subTotal'] as num?)?.toDouble(),
      taxAmount: j['taxAmount'] as num?,
      cashReceived: (j['cashReceived'] as num?)?.toDouble(),
      customerChangeDue: (j['customerChangeDue'] as num?)?.toDouble(),
      createdAt: date('createdAt'),
      updatedAt: date('updatedAt'),
      lastTouched: date('lastTouched'),
      lastPaymentDate: date('lastPaymentDate'),
      isIncome: j['isIncome'] as bool?,
      isExpense: j['isExpense'] as bool?,
      isOriginalTransaction: j['isOriginalTransaction'] as bool?,
      originalTransactionId: j['originalTransactionId'] as String?,
      exchangeId: j['exchangeId'] as String?,
      invoiceNumber: j['invoiceNumber'] as int?,
      receiptNumber: j['receiptNumber'] as int?,
      totalReceiptNumber: j['totalReceiptNumber'] as int?,
      sarNo: j['sarNo'] as String?,
      agentId: j['agentId'] as String?,
      shiftId: j['shiftId'] as String?,
      customerId: j['customerId'] as String?,
      customerName: j['customerName'] as String?,
      customerTin: j['customerTin'] as String?,
      customerPhone: j['customerPhone'] as String?,
      customerBhfId: j['customerBhfId'] as String?,
      remark: j['remark'] as String?,
      ebmSynced: j['ebmSynced'] as bool?,
      receiptPrinted: j['receiptPrinted'] as bool?,
    );
  }
}

/// This device's unfinished exchange intents, in LocalStorage.
///
/// LocalStorage, not a synced Ditto collection: it is written to a local JSON
/// file on every write (so it survives a crash or restart) and is never
/// pulled by another device. That is wanted: only the device that asked RRA
/// to sign the return may finish it, or two tills could write it twice.
class SaleExchangeIntentStore {
  const SaleExchangeIntentStore(this._box);

  final LocalStorage _box;

  Map<String, SaleExchangeIntent> all() {
    final raw = _box.readString(key: saleExchangeIntentsBoxKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return {
      for (final e in decoded.entries)
        e.key: SaleExchangeIntent.fromJson(
          Map<String, dynamic>.from(e.value as Map),
        ),
    };
  }

  SaleExchangeIntent? get(String exchangeId) => all()[exchangeId];

  Future<void> save(SaleExchangeIntent intent) async {
    final intents = all()..[intent.exchangeId] = intent;
    await _write(intents);
  }

  Future<void> remove(String exchangeId) async {
    final intents = all();
    if (intents.remove(exchangeId) == null) return;
    await _write(intents);
  }

  Future<void> _write(Map<String, SaleExchangeIntent> intents) async {
    if (intents.isEmpty) {
      await _box.remove(key: saleExchangeIntentsBoxKey);
      return;
    }
    await _box.writeString(
      key: saleExchangeIntentsBoxKey,
      value: jsonEncode({
        for (final e in intents.entries) e.key: e.value.toJson(),
      }),
    );
  }
}
