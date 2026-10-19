import 'dart:typed_data';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/services/sale_exchange_intent.dart';
import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flipper_dashboard/utils/ebm_receipt_gate.dart';
import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_models/sync/shift_operations.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart'
    show rraSaleStockSnapshotBoxKey;
import 'package:flipper_services/constants.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

/// Status of the new-sale transaction while its lines are being added. Not
/// `pending`: the POS adopts the newest pending row as its cart, and an
/// exchange must never take over the cashier's open cart.
const String exchangeDraftStatus = 'exchangeDraft';

/// One line of the original sale and how many of its units the customer can
/// still bring back.
class ExchangeableLine {
  const ExchangeableLine({required this.line, required this.alreadyReturned});

  final TransactionItem line;
  final double alreadyReturned;

  double get returnable =>
      (line.qty.toDouble() - alreadyReturned).clamp(0, double.infinity);

  /// What the customer paid for one unit of this line.
  double get unitValue =>
      line.qty == 0 ? 0 : paidLineTotal(line) / line.qty.toDouble();
}

/// An item the customer takes instead.
class ExchangeTake {
  const ExchangeTake({required this.variant, required this.qty});

  final Variant variant;
  final double qty;

  double get unitPrice => variant.retailPrice?.toDouble() ?? 0;
  double get total => unitPrice * qty;
}

class SaleExchangeRequest {
  const SaleExchangeRequest({
    required this.original,
    required this.returns,
    required this.takes,
    required this.paymentMethod,
    this.purchaseCode,
  });

  final ITransaction original;

  /// Original line id → units brought back.
  final Map<String, double> returns;
  final List<ExchangeTake> takes;

  /// How the difference is settled (Cash, MoMo, …). Both new transactions
  /// carry it, so only that account moves, by exactly the difference.
  final String paymentMethod;

  /// RRA purchase code, required when the sale was to a customer TIN.
  final String? purchaseCode;
}

class SaleExchangeResult {
  const SaleExchangeResult({
    required this.returnTransaction,
    required this.saleTransaction,
    required this.totals,
    required this.receipts,
    required this.saleSigned,
  });

  final ITransaction returnTransaction;
  final ITransaction saleTransaction;
  final ExchangeTotals totals;

  /// Receipt PDFs, return first. Printed together by the caller.
  final List<Uint8List> receipts;

  /// False when the return was signed by RRA but the new sale was not; the
  /// sale detail then offers "Finish exchange" ([SaleExchangeService.signSale]).
  final bool saleSigned;
}

class SaleExchangeException implements Exception {
  SaleExchangeException(this.message, {this.resumableExchangeId});
  final String message;

  /// Set when the return is recorded but the new sale is not finished:
  /// [SaleExchangeService.resumeExchange] with this id completes it.
  final String? resumableExchangeId;
  @override
  String toString() => message;
}

/// Takes the new sale's items out of stock. Injectable for tests; the
/// default does what checkout does (see [SaleExchangeService]).
typedef ExchangeSaleStockDeduction =
    Future<void> Function({
      required List<TransactionItem> lines,
      required String transactionId,
      required bool vat,
      required String businessId,
    });

/// Asks RRA to sign one leg of an exchange (the return when [isReturn]).
/// Injectable for tests; the default goes through [TaxController].
typedef ExchangeReceiptSigner =
    Future<({String? resultCd, Uint8List? bytes})> Function({
      required ITransaction transaction,
      required List<TransactionItem> items,
      required bool isReturn,
      String? purchaseCode,
    });

/// An exchange whose return RRA already has, and how far its local writes
/// got. Every step checks it, so finishing it again never repeats work.
class _PendingExchange {
  _PendingExchange({
    required this.exchangeId,
    required this.ret,
    required this.returnLines,
    required this.sale,
    required this.saleLines,
    required this.paymentMethod,
    required this.branchId,
    required this.businessId,
    required this.vat,
    required this.receipts,
    this.intent,
    this.returnCommitted = false,
  }) {
    final saved = intent;
    if (saved != null) {
      restoredLineIds.addAll(saved.restoredLineIds);
      shiftRefunded = saved.shiftRefunded;
    }
  }

  final String exchangeId;
  final ITransaction ret;
  final List<TransactionItem> returnLines;
  ITransaction sale;
  final List<TransactionItem> saleLines;
  final String paymentMethod;
  final String branchId;
  final String businessId;
  final bool vat;
  final List<Uint8List> receipts;

  /// The saved intent while the return row is not written (see
  /// [SaleExchangeIntent]); its progress is saved with every step.
  final SaleExchangeIntent? intent;

  bool returnCommitted;
  final Set<String> restoredLineIds = {};
  bool shiftRefunded = false;
  bool saleStockDeducted = false;
}

/// Records an item exchange on a completed sale. See `sale_exchange.dart` in
/// flipper_models for the model: the original is never edited; a return
/// (NR) and a new sale (NS) are written, sharing one `exchangeId`.
///
/// Order matters, so a failure never leaves half an exchange behind:
/// 1. the new sale is drafted (invisible: [exchangeDraftStatus]);
/// 2. on EBM branches RRA signs the return — if it refuses, nothing is kept.
///    Once RRA has accepted it the exchange is always carried through, even
///    if building its receipt fails afterwards;
/// 3. the return's lines are written, its stock put back, the shift
///    credited, and then the return row itself (so a return row means the
///    return is complete);
/// 4. the new sale is completed: totals and payment, stock out, and only then
///    its status, so a sale still in [exchangeDraftStatus] is unfinished;
/// 5. on EBM branches the new sale is signed ("Finish exchange" if not).
///
/// Before 2, an exchange intent is saved on this device
/// ([SaleExchangeIntent]): the return as RRA will sign it, updated with RRA's
/// numbers the moment RRA accepts it, then with each step of 3. It is removed
/// once the exchange is complete (or RRA refused the return).
///
/// If 3 or 4 fail the exchange is partly saved. [resumeExchange] finishes
/// it: in the same session from what is in memory; later from the return row
/// and the draft sale (found by `exchangeId`), or, when the return row was
/// never written, from the intent and the draft sale (see
/// [unfinishedExchangeId]).
class SaleExchangeService {
  SaleExchangeService({
    BranchServices services = const BranchServices(),
    Future<bool> Function()? ebmWillSign,
    ExchangeSaleStockDeduction? deductSaleStock,
    ExchangeReceiptSigner? sign,
    Talker? talker,
  }) : _services = services,
       _ebmWillSign = ebmWillSign ?? ebmWillSignReceipt,
       _deductSaleStockOverride = deductSaleStock,
       _sign = sign ?? _signWithRra,
       _talker = talker ?? TalkerFlutter.init();

  final BranchServices _services;
  final Future<bool> Function() _ebmWillSign;
  final ExchangeSaleStockDeduction? _deductSaleStockOverride;
  final ExchangeReceiptSigner _sign;
  final Talker _talker;

  SaleExchangeIntentStore get _intents =>
      SaleExchangeIntentStore(_services.box);

  /// Exchanges of this session past the point of no return (the return is
  /// signed, or about to be written) and not finished yet.
  final Map<String, _PendingExchange> _pending = {};

  CapellaSync get _capella => _services.strategy as CapellaSync;

  /// Why [transaction] cannot be exchanged, or null when it can.
  static String? blockReason(ITransaction transaction) {
    final l10n = FlipperL10n.current;
    final type = transaction.receiptType?.trim().toUpperCase();
    final movement =
        transaction.transactionType == TransactionType.cashIn ||
        transaction.transactionType == TransactionType.cashOut;
    if ((type != null && type.isNotEmpty && type != 'NS') ||
        transaction.isExpense == true ||
        movement ||
        isExchangeReturn(transaction)) {
      return l10n.exchangeOnlyNormalSales;
    }
    return refundBlockReason(transaction);
  }

  /// The sale's lines with how much of each can still come back.
  Future<List<ExchangeableLine>> exchangeableLines(
    ITransaction original,
  ) async {
    final lines = (await _capella.transactionItems(
      transactionId: original.id,
    )).where((l) => l.qty > 0).toList();
    final priorLines = await priorReturnLines(original);
    final returned = returnedQtyByOriginalLine(
      originalLines: lines,
      priorReturnLines: priorLines,
    );
    return [
      for (final line in lines)
        ExchangeableLine(line: line, alreadyReturned: returned[line.id] ?? 0),
    ];
  }

  /// Lines of every earlier exchange return of [original].
  Future<List<TransactionItem>> priorReturnLines(ITransaction original) async {
    final returns = await _capella.exchangeReturnsForSale(
      originalTransactionId: original.id,
    );
    final out = <TransactionItem>[];
    for (final r in returns) {
      out.addAll(await _capella.transactionItems(transactionId: r.id));
    }
    return out;
  }

  /// Also true while an exchange of [original] is saved only as an intent:
  /// RRA may already hold its return.
  Future<bool> hasExchanges(ITransaction original) async =>
      _intents.all().values.any(
        (i) => i.originalTransactionId == original.id,
      ) ||
      (await _capella.exchangeReturnsForSale(
        originalTransactionId: original.id,
      )).isNotEmpty;

  Future<SaleExchangeResult> execute(SaleExchangeRequest request) async {
    final l10n = FlipperL10n.current;
    final original = request.original;
    final reason = blockReason(original);
    if (reason != null) throw SaleExchangeException(reason);
    final box = _services.box;
    if (box.isProformaMode() || box.isTrainingMode()) {
      throw SaleExchangeException(l10n.exchangeNotInTrainingOrProforma);
    }
    final branchId = box.getBranchId();
    final businessId = box.getBusinessId();
    if (branchId == null || businessId == null) {
      throw SaleExchangeException(l10n.exchangeFailedNothingChanged);
    }

    // --- Reads: nothing is written yet, so a failure changes nothing --------
    final userId = box.getUserId();
    final List<ExchangeableLine> exchangeable;
    final String? shiftId;
    final bool vat;
    try {
      exchangeable = await exchangeableLines(original);
      shiftId = userId == null
          ? null
          : (await ShiftOperations().getCurrentShift(userId: userId))?.id;
      vat = await _ebmWillSign();
    } catch (e, s) {
      _talker.error('Exchange lookup failed: $e', s);
      throw SaleExchangeException(l10n.exchangeFailedNothingChanged);
    }

    // --- What comes back -------------------------------------------------
    final byId = {for (final e in exchangeable) e.line.id: e};
    final picks = request.returns.entries.where((e) => e.value > 0).toList();
    if (picks.isEmpty) throw SaleExchangeException(l10n.exchangeChooseReturn);
    final takes = request.takes.where((t) => t.qty > 0).toList();
    if (takes.isEmpty) throw SaleExchangeException(l10n.exchangeChooseTake);

    final exchangeId = const Uuid().v4();
    final returnId = const Uuid().v4();
    final returnLines = <TransactionItem>[];
    final intentLines = <ExchangeIntentLine>[];
    for (final pick in picks) {
      final e = byId[pick.key];
      if (e == null || pick.value > e.returnable + 1e-9) {
        throw SaleExchangeException(l10n.exchangeMoreThanBought);
      }
      final line = buildReturnLine(
        original: e.line,
        alreadyReturned: e.alreadyReturned,
        qty: pick.value,
        returnTransactionId: returnId,
      );
      returnLines.add(line);
      intentLines.add(
        ExchangeIntentLine(
          id: line.id,
          originalLineId: e.line.id,
          alreadyReturned: e.alreadyReturned,
          qty: pick.value,
          total: line.totAmt?.toDouble() ?? 0,
        ),
      );
    }
    final returnedValue = returnLines.fold<double>(
      0,
      (s, l) => s + (l.totAmt?.toDouble() ?? 0),
    );
    final returnedTax = returnLines.fold<double>(
      0,
      (s, l) => s + (l.taxAmt?.toDouble() ?? 0),
    );

    final now = DateTime.now().toUtc();

    // --- 1. Draft the new sale (not visible anywhere yet) ----------------
    final sale = ITransaction(
      branchId: branchId,
      status: exchangeDraftStatus,
      transactionType: TransactionType.sale,
      receiptType: TransactionReceptType.NS,
      paymentType: request.paymentMethod,
      subTotal: 0,
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: now,
      createdAt: now,
      lastTouched: now,
      isIncome: true,
      isExpense: false,
      isOriginalTransaction: true,
      exchangeId: exchangeId,
      agentId: userId ?? original.agentId ?? '',
      shiftId: shiftId,
      customerId: original.customerId,
      customerName: original.customerName,
      customerTin: original.customerTin,
      customerPhone: original.customerPhone,
      customerBhfId: original.customerBhfId,
    );
    final List<TransactionItem> saleLines;
    try {
      saleLines = await _draftSaleLines(sale, takes);
    } catch (e, s) {
      _talker.error('Exchange draft failed: $e', s);
      await _discardDraft(sale);
      throw SaleExchangeException(l10n.exchangeFailedNothingChanged);
    }

    // --- 2. Return: RRA signs first on EBM branches ----------------------
    final ret = ITransaction(
      id: returnId,
      branchId: branchId,
      status: COMPLETE,
      transactionType: TransactionReceptType.NR,
      receiptType: TransactionReceptType.NR,
      paymentType: request.paymentMethod,
      subTotal: returnedValue,
      taxAmount: returnedTax,
      cashReceived: returnedValue,
      customerChangeDue: 0,
      updatedAt: now,
      createdAt: now,
      lastTouched: now,
      isIncome: true,
      isExpense: false,
      isOriginalTransaction: false,
      originalTransactionId: original.id,
      exchangeId: exchangeId,
      // RRA's orgInvcNo while signing; replaced by the return's own number.
      invoiceNumber: vat ? original.invoiceNumber : null,
      agentId: userId ?? original.agentId ?? '',
      shiftId: shiftId,
      customerId: original.customerId,
      customerName: original.customerName,
      customerTin: original.customerTin,
      customerPhone: original.customerPhone,
      customerBhfId: original.customerBhfId,
      remark: 'exchange',
      ebmSynced: false,
    );

    // Saved before RRA is asked, so a restart at any later point still knows
    // the return (see [SaleExchangeIntent]).
    final intent = SaleExchangeIntent(
      exchangeId: exchangeId,
      ret: ret,
      lines: intentLines,
      saleId: sale.id,
      paymentMethod: request.paymentMethod,
      branchId: branchId,
      businessId: businessId,
      vat: vat,
      purchaseCode: request.purchaseCode,
    );
    try {
      await _intents.save(intent);
    } catch (e, s) {
      _talker.error('Exchange intent not saved: $e', s);
      await _discardDraft(sale);
      throw SaleExchangeException(l10n.exchangeFailedNothingChanged);
    }

    final receipts = <Uint8List>[];
    if (vat && !await _signReturn(intent, returnLines, receipts: receipts)) {
      await _discardDraft(sale);
      await _dropIntent(exchangeId);
      throw SaleExchangeException(l10n.exchangeRraFailed);
    }

    // From here the return is real (RRA has it on EBM branches). A failure
    // can no longer be undone: it is a partial save, finished by
    // [resumeExchange].
    final pending = _PendingExchange(
      exchangeId: exchangeId,
      ret: ret,
      returnLines: returnLines,
      sale: sale,
      saleLines: saleLines,
      paymentMethod: request.paymentMethod,
      branchId: branchId,
      businessId: businessId,
      vat: vat,
      receipts: receipts,
      intent: intent,
    );
    _pending[exchangeId] = pending;
    return _finish(pending);
  }

  /// Asks RRA to sign the return of [intent]; true once RRA accepted it.
  ///
  /// The intent is saved again the moment RRA answers 000 (rw_tax calls
  /// [notifyExchangeReturnSigned] before any receipt or PDF work) and once
  /// more when signing returns, so a crash after RRA accepted the return
  /// still leaves it marked signed.
  Future<bool> _signReturn(
    SaleExchangeIntent intent,
    List<TransactionItem> lines, {
    required List<Uint8List> receipts,
  }) async {
    final ret = intent.ret;
    watchExchangeReturnSigning(intent.exchangeId, (_) => _intents.save(intent));
    try {
      final signed = await _sign(
        transaction: ret,
        items: lines,
        isReturn: true,
        purchaseCode: intent.purchaseCode,
      );
      if (signed.resultCd != '000') {
        throw StateError('RRA ${signed.resultCd}');
      }
      if (signed.bytes != null) receipts.add(signed.bytes!);
    } catch (e, s) {
      if (!exchangeReturnSignedByRra(ret)) {
        _talker.error('Exchange return not signed: $e', s);
        return false;
      }
      // RRA accepted the return; only a local step after it (receipt
      // record or PDF) failed. The return is fiscal now, so it is written
      // like any other: dropping it would leave RRA's record unmatched.
      _talker.error(
        'Exchange ${intent.exchangeId}: return signed by RRA, receipt not '
        'built: $e',
        s,
      );
    } finally {
      watchExchangeReturnSigning(intent.exchangeId, null);
    }
    // RRA has the return: record it, whatever happens next.
    await _saveIntent(intent);
    return true;
  }

  static Future<({String? resultCd, Uint8List? bytes})> _signWithRra({
    required ITransaction transaction,
    required List<TransactionItem> items,
    required bool isReturn,
    String? purchaseCode,
  }) async {
    final signed = await TaxController(object: transaction).handleReceipt(
      filterType: isReturn ? FilterType.NR : FilterType.NS,
      purchaseCode: purchaseCode,
      transactionItems: items,
      // The return row is written after signing (see [_commitReturn]).
      persistReceiptTransactionFields: !isReturn,
      deferPresentation: true,
    );
    return (resultCd: signed.response.resultCd, bytes: signed.bytes);
  }

  /// Saves the progress of [intent]. A failed save is logged, not thrown:
  /// the step it records is done, and the session still knows it.
  Future<void> _saveIntent(SaleExchangeIntent? intent) async {
    if (intent == null) return;
    try {
      await _intents.save(intent);
    } catch (e, s) {
      _talker.error('Exchange ${intent.exchangeId} intent not saved: $e', s);
    }
  }

  Future<void> _dropIntent(String exchangeId) async {
    try {
      await _intents.remove(exchangeId);
    } catch (e) {
      _talker.warning('Exchange $exchangeId intent not removed: $e');
    }
  }

  /// Finishes an exchange that was only partly saved (see
  /// [SaleExchangeException.resumableExchangeId] and [unfinishedExchangeId]).
  /// Steps already done are not repeated.
  Future<SaleExchangeResult> resumeExchange(String exchangeId) async {
    final l10n = FlipperL10n.current;
    var pending = _pending[exchangeId];
    if (pending == null) {
      try {
        pending = await _loadPending(exchangeId);
      } on SaleExchangeException {
        rethrow;
      } catch (e, s) {
        _talker.error('Exchange $exchangeId not loaded: $e', s);
        throw SaleExchangeException(
          l10n.exchangePartlySaved,
          resumableExchangeId: exchangeId,
        );
      }
      if (pending == null) {
        // No return row and no intent, or no draft sale left to finish.
        throw SaleExchangeException(l10n.exchangeNothingToFinish);
      }
      _pending[exchangeId] = pending;
    }
    return _finish(pending);
  }

  /// Rebuilds an exchange whose return row was never written from its saved
  /// intent and the draft sale. A return RRA may not have signed (the app
  /// stopped while RRA was being asked) is signed first; if RRA refuses it,
  /// the exchange is dropped as if confirming had failed.
  Future<_PendingExchange?> _loadFromIntent(
    String exchangeId,
    List<ITransaction> legs,
  ) async {
    final intent = _intents.get(exchangeId);
    final sale = legs.where(_isDraftSale).firstOrNull;
    if (intent == null || sale == null) return null;
    final saleLines = await _capella.transactionItems(transactionId: sale.id);
    if (saleLines.isEmpty) return null;
    final originalLines = {
      for (final l in await _capella.transactionItems(
        transactionId: intent.originalTransactionId,
      ))
        l.id: l,
    };
    final returnLines = <TransactionItem>[];
    for (final l in intent.lines) {
      final original = originalLines[l.originalLineId];
      if (original == null) {
        throw StateError('original line ${l.originalLineId} not found');
      }
      returnLines.add(
        buildReturnLine(
          original: original,
          alreadyReturned: l.alreadyReturned,
          qty: l.qty,
          returnTransactionId: intent.ret.id,
          id: l.id,
        ),
      );
    }
    final receipts = <Uint8List>[];
    if (!intent.signed &&
        !await _signReturn(intent, returnLines, receipts: receipts)) {
      await _discardDraft(sale);
      await _dropIntent(exchangeId);
      throw SaleExchangeException(FlipperL10n.current.exchangeRraFailed);
    }
    return _PendingExchange(
      exchangeId: exchangeId,
      ret: intent.ret,
      returnLines: returnLines,
      sale: sale,
      saleLines: saleLines,
      paymentMethod: intent.paymentMethod,
      branchId: intent.branchId,
      businessId: intent.businessId,
      vat: intent.vat,
      receipts: receipts,
      intent: intent,
    );
  }

  /// The exchange of [transaction] (one of its legs, or the sale it was made
  /// on) whose return is recorded but whose new sale is still a draft.
  Future<String?> unfinishedExchangeId(ITransaction transaction) async {
    // Partly saved in this session: known even before its return row exists.
    for (final p in _pending.values) {
      if (p.exchangeId == transaction.exchangeId ||
          p.ret.originalTransactionId == transaction.id) {
        return p.exchangeId;
      }
    }
    // Saved only as an intent (no return row yet), e.g. after a restart.
    for (final intent in _intents.all().values) {
      if (intent.exchangeId != transaction.exchangeId &&
          intent.originalTransactionId != transaction.id) {
        continue;
      }
      final legs = await _capella.exchangeLegs(exchangeId: intent.exchangeId);
      if (legs.any(_isDraftSale)) return intent.exchangeId;
      // Finished, or dropped after RRA refused it: nothing left to do.
      await _dropIntent(intent.exchangeId);
    }
    final ids = <String>{};
    final own = transaction.exchangeId;
    if (own != null && own.isNotEmpty) {
      ids.add(own);
    } else {
      for (final r in await _capella.exchangeReturnsForSale(
        originalTransactionId: transaction.id,
      )) {
        final id = r.exchangeId;
        if (id != null && id.isNotEmpty) ids.add(id);
      }
    }
    for (final id in ids) {
      final legs = await _capella.exchangeLegs(exchangeId: id);
      if (legs.any(isExchangeReturn) && legs.any(_isDraftSale)) return id;
    }
    return null;
  }

  static bool _isDraftSale(ITransaction t) =>
      !isExchangeReturn(t) && t.status == exchangeDraftStatus;

  /// Rebuilds an unfinished exchange from what was written: the return row
  /// (written last, so it is complete) and the draft sale with its lines; or,
  /// with no return row yet, from the saved intent ([_loadFromIntent]).
  Future<_PendingExchange?> _loadPending(String exchangeId) async {
    final legs = await _capella.exchangeLegs(exchangeId: exchangeId);
    final ret = legs.where(isExchangeReturn).firstOrNull;
    final sale = legs.where(_isDraftSale).firstOrNull;
    if (ret == null) return _loadFromIntent(exchangeId, legs);
    if (sale == null) return null;
    final saleLines = await _capella.transactionItems(transactionId: sale.id);
    if (saleLines.isEmpty) return null;
    final businessId = _services.box.getBusinessId();
    final branchId = sale.branchId ?? _services.box.getBranchId();
    if (businessId == null || branchId == null) return null;
    return _PendingExchange(
      exchangeId: exchangeId,
      ret: ret,
      returnLines: await _capella.transactionItems(transactionId: ret.id),
      sale: sale,
      saleLines: saleLines,
      paymentMethod: sale.paymentType ?? ret.paymentType ?? 'CASH',
      branchId: branchId,
      businessId: businessId,
      vat: await _ebmWillSign(),
      receipts: [],
      returnCommitted: true,
    );
  }

  /// Steps 3–5 of [execute]; safe to run again after a failure.
  Future<SaleExchangeResult> _finish(_PendingExchange p) async {
    try {
      await _commitReturn(p);
      await _completeSale(p);
    } catch (e, s) {
      _talker.error('Exchange ${p.exchangeId} partly saved: $e', s);
      throw SaleExchangeException(
        FlipperL10n.current.exchangePartlySaved,
        resumableExchangeId: p.exchangeId,
      );
    }
    _pending.remove(p.exchangeId);
    await _dropIntent(p.exchangeId);

    final sale = p.sale;
    var saleSigned = true;
    if (p.vat) {
      final bytes = await signSale(sale, lines: p.saleLines);
      saleSigned = bytes != null;
      if (bytes != null && bytes.isNotEmpty) p.receipts.add(bytes);
    } else {
      p.receipts.addAll(
        await _nonFiscalReceipts([(p.ret, p.returnLines), (sale, p.saleLines)]),
      );
    }

    final returned = p.ret.subTotal?.toDouble() ?? 0;
    _talker.info(
      'Exchange ${p.exchangeId} on ${p.ret.originalTransactionId}: '
      'back $returned, out ${sale.subTotal}, signed=$saleSigned',
    );
    return SaleExchangeResult(
      returnTransaction: p.ret,
      saleTransaction: sale,
      totals: ExchangeTotals(
        returned: returned,
        taken: sale.subTotal?.toDouble() ?? 0,
      ),
      receipts: List.of(p.receipts),
      saleSigned: saleSigned,
    );
  }

  /// Writes [sale] as an invisible draft and adds the items taken, priced
  /// and taxed exactly as the POS would.
  Future<List<TransactionItem>> _draftSaleLines(
    ITransaction sale,
    List<ExchangeTake> takes,
  ) async {
    await _capella.addTransaction(transaction: sale);
    for (final take in takes) {
      final stockId = take.variant.stockId;
      final stock = stockId == null
          ? null
          : await _capella.getStockById(id: stockId);
      final ok = await _capella.saveTransactionItem(
        variation: take.variant,
        // The UNIT price: saveTransactionItem prices the line as
        // amountTotal × updatableQty (SaleLinePricing.compute).
        amountTotal: take.unitPrice,
        ignoreForReport: false,
        customItem: false,
        doneWithTransaction: false,
        pendingTransaction: sale,
        currentStock: stock?.currentStock?.toDouble() ?? 0,
        useTransactionItemForQty: true,
        updatableQty: take.qty,
        partOfComposite: false,
        // collectPayment computes the total from the lines.
        updatePendingTransactionSubtotal: false,
      );
      if (!ok) throw StateError('saveTransactionItem failed');
    }
    final lines = await _capella.transactionItems(transactionId: sale.id);
    if (lines.isEmpty) throw StateError('no sale lines');
    return lines;
  }

  /// Writes the return's lines, puts their stock back, credits the shift,
  /// then writes the return row. The row comes last so that a return row
  /// always means a complete return ([_loadPending] relies on it).
  Future<void> _commitReturn(_PendingExchange p) async {
    if (p.returnCommitted) return;
    final ret = p.ret;
    final now = ret.lastTouched ?? DateTime.now().toUtc();
    final written = {
      for (final l in await _capella.transactionItems(transactionId: ret.id))
        l.id,
    };
    // Lines before the row: adding a line to an existing row would also add
    // its amount to the row's subTotal, which is already final.
    for (final line in p.returnLines) {
      if (written.contains(line.id)) continue;
      await _capella.addTransactionItem(
        transaction: ret,
        item: line,
        partOfComposite: line.partOfComposite ?? false,
        lastTouched: now,
        discount: line.discount.toDouble(),
        quantity: line.qty.toDouble(),
        currentStock: 0,
        amountTotal: line.totAmt?.toDouble() ?? 0,
        name: line.name,
        ignoreForReport: true,
      );
    }
    for (final line in p.returnLines) {
      if (p.restoredLineIds.contains(line.id)) continue;
      await _restoreLineStock(line);
      p.restoredLineIds.add(line.id);
      p.intent?.restoredLineIds.add(line.id);
      await _saveIntent(p.intent);
    }
    if (!p.shiftRefunded) {
      try {
        await _capella.updateShiftTotals(
          transactionAmount: ret.subTotal?.toDouble() ?? 0,
          isRefund: true,
        );
      } catch (e) {
        _talker.warning('Exchange: shift refund total skipped: $e');
      }
      p.shiftRefunded = true;
      p.intent?.shiftRefunded = true;
      await _saveIntent(p.intent);
    }
    await _capella.addTransaction(transaction: ret);
    p.returnCommitted = true;
  }

  /// Completes the drafted sale the way checkout does: totals and shift via
  /// collectPayment, the exchange's own payment, stock out — and only then
  /// the COMPLETE status, so a draft sale is always an unfinished one.
  Future<void> _completeSale(_PendingExchange p) async {
    var sale = p.sale;
    if (sale.status == COMPLETE) return;
    final now = DateTime.now().toUtc();
    // lastPaymentDate marks "payment collected": collectPayment also adds
    // the sale to the shift, which must happen once.
    if (sale.lastPaymentDate == null) {
      final takenValue = p.saleLines.fold<double>(
        0,
        (s, l) => s + paidLineTotal(l),
      );
      final collected = await _capella.collectPayment(
        cashReceived: takenValue,
        transaction: sale,
        paymentType: p.paymentMethod,
        discount: 0,
        branchId: p.branchId,
        bhfId: (await _services.box.bhfId()) ?? '00',
        isProformaMode: false,
        isTrainingMode: false,
        transactionType: TransactionType.sale,
        isIncome: true,
        customerName: sale.customerName,
        customerTin: sale.customerTin,
        customerPhone: sale.customerPhone,
        countryCode: '',
        completionStatus: COMPLETE,
        preloadedLineItems: p.saleLines,
        skipTransactionPersist: true,
        skipPersonalGoalAutoSweep: true,
      );
      // collectPayment prefers the POS's selected payment type; the
      // exchange's own settlement method is what the books and till show.
      collected
        ..status = exchangeDraftStatus
        ..paymentType = p.paymentMethod
        ..receiptType = TransactionReceptType.NS
        ..exchangeId = p.exchangeId
        ..cashReceived = collected.subTotal
        ..customerChangeDue = 0
        ..remainingBalance = 0
        ..lastPaymentDate = now
        ..lastPaymentAmount = collected.subTotal
        ..updatedAt = now
        ..lastTouched = now;
      await _capella.addTransaction(transaction: collected);
      sale = p.sale = collected;
    }
    await _capella.markItemAsDoneWithTransaction(
      inactiveItems: p.saleLines,
      pendingTransaction: sale,
      ignoreForReport: false,
      isDoneWithTransaction: true,
    );
    // One tender row per exchange sale; replacing it keeps a retry from
    // recording the payment twice.
    await _capella.savePaymentType(
      amount: sale.subTotal?.toDouble() ?? 0,
      transactionId: sale.id,
      paymentMethod: p.paymentMethod,
      singlePaymentOnly: true,
    );
    if (!p.saleStockDeducted) {
      await (_deductSaleStockOverride ?? _deductSaleStock)(
        lines: p.saleLines,
        transactionId: sale.id,
        vat: p.vat,
        businessId: p.businessId,
      );
      p.saleStockDeducted = true;
    }
    sale
      ..status = COMPLETE
      ..updatedAt = now
      ..lastTouched = now;
    await _capella.addTransaction(transaction: sale);
  }

  /// Stock goes out before RRA hears about it, as at the POS: the stock
  /// report sent with the signed sale then carries the new on-hand level.
  /// Lines already taken out (quantityShipped, or the pre-sale snapshot of an
  /// earlier attempt) are skipped by [applyDeferredSaleStockDeduction].
  Future<void> _deductSaleStock({
    required List<TransactionItem> lines,
    required String transactionId,
    required bool vat,
    required String businessId,
  }) async {
    if (vat &&
        _services.box.readString(
              key: rraSaleStockSnapshotBoxKey(transactionId),
            ) ==
            null) {
      await persistPreSaleStockSnapshot(
        transactionItems: lines,
        transactionId: transactionId,
      );
    }
    await applyDeferredSaleStockDeduction(
      transactionItems: lines,
      allowSellingBelowStock: await _allowSellingBelowStock(businessId),
      isProformaOrTraining: false,
      transactionId: transactionId,
    );
  }

  /// Items matching [query] with what is on hand (null for services, which
  /// are never out of stock).
  Future<List<({Variant variant, double? onHand})>> searchVariants(
    String query,
  ) async {
    final branchId = _services.box.getBranchId();
    if (branchId == null || query.trim().isEmpty) return const [];
    final paged = await _capella.variants(
      branchId: branchId,
      name: query.trim(),
      itemsPerPage: 20,
      countTotal: false,
    );
    final variants = paged.variants.whereType<Variant>().toList();
    final stockIds = [
      for (final v in variants)
        if (v.itemTyCd != '3' && (v.stockId?.isNotEmpty ?? false)) v.stockId!,
    ];
    final stocks = stockIds.isEmpty
        ? const <String, Stock>{}
        : await _capella.batchGetStocksByIds(stockIds);
    return [
      for (final v in variants)
        (
          variant: v,
          onHand: v.itemTyCd == '3'
              ? null
              : (stocks[v.stockId]?.currentStock?.toDouble() ??
                    v.stock?.currentStock?.toDouble() ??
                    0),
        ),
    ];
  }

  /// Signs the new sale of an exchange (also "Finish exchange" when RRA was
  /// unreachable the first time). Returns the receipt, or null if not signed.
  Future<Uint8List?> signSale(
    ITransaction sale, {
    List<TransactionItem>? lines,
  }) async {
    try {
      final items =
          lines ?? await _capella.transactionItems(transactionId: sale.id);
      final signed = await _sign(
        transaction: sale,
        items: items,
        isReturn: false,
      );
      if (signed.resultCd != '000') return null;
      return signed.bytes ?? Uint8List(0);
    } catch (e, s) {
      _talker.error('Exchange sale not signed: $e', s);
      return null;
    }
  }

  Future<void> _restoreLineStock(TransactionItem line) async {
    final variantId = line.variantId;
    if (variantId == null) return;
    final variant = await _capella.getVariant(id: variantId);
    if (variant == null || variant.itemTyCd == '3') return;
    final stockId = variant.stockId;
    if (stockId == null || stockId.isEmpty) return;
    await _capella.updateStock(
      stockId: stockId,
      currentStock: line.qty.toDouble(),
      appending: true,
    );
  }

  Future<List<Uint8List>> _nonFiscalReceipts(
    List<(ITransaction, List<TransactionItem>)> legs,
  ) async {
    final out = <Uint8List>[];
    for (final (txn, items) in legs) {
      try {
        final bytes = await TaxController(object: txn)
            .buildNonFiscalReceiptPdfBytes(
              transaction: txn,
              transactionItems: items,
              deferPresentation: true,
            );
        if (bytes != null) out.add(bytes);
      } catch (e) {
        _talker.warning('Exchange receipt not built: $e');
      }
    }
    return out;
  }

  Future<bool> _allowSellingBelowStock(String businessId) async {
    try {
      final setting = await _capella.getSetting(businessId: businessId);
      return setting?.allowSellingBelowStock ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _discardDraft(ITransaction draft) async {
    try {
      await _capella.deleteTransaction(transaction: draft);
    } catch (e) {
      _talker.warning('Exchange draft not removed: $e');
    }
  }
}
