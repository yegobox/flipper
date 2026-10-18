import 'dart:typed_data';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_dashboard/services/transaction_refund_helpers.dart';
import 'package:flipper_dashboard/utils/ebm_receipt_gate.dart';
import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/sale_exchange.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_models/sync/shift_operations.dart';
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
  SaleExchangeException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Records an item exchange on a completed sale. See `sale_exchange.dart` in
/// flipper_models for the model: the original is never edited; a return
/// (NR) and a new sale (NS) are written, sharing one `exchangeId`.
///
/// Order matters, so a failure never leaves half an exchange behind:
/// 1. the new sale is drafted (invisible: [exchangeDraftStatus]);
/// 2. on EBM branches RRA signs the return — if it refuses, nothing is kept;
/// 3. the return is written, its stock put back and the shift credited;
/// 4. the new sale is completed, its stock taken out, and signed.
class SaleExchangeService {
  SaleExchangeService({
    BranchServices services = const BranchServices(),
    Future<bool> Function()? ebmWillSign,
    Talker? talker,
  }) : _services = services,
       _ebmWillSign = ebmWillSign ?? ebmWillSignReceipt,
       _talker = talker ?? TalkerFlutter.init();

  final BranchServices _services;
  final Future<bool> Function() _ebmWillSign;
  final Talker _talker;

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

  Future<bool> hasExchanges(ITransaction original) async =>
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

    // --- What comes back -------------------------------------------------
    final exchangeable = await exchangeableLines(original);
    final byId = {for (final e in exchangeable) e.line.id: e};
    final picks = request.returns.entries.where((e) => e.value > 0).toList();
    if (picks.isEmpty) throw SaleExchangeException(l10n.exchangeChooseReturn);
    final takes = request.takes.where((t) => t.qty > 0).toList();
    if (takes.isEmpty) throw SaleExchangeException(l10n.exchangeChooseTake);

    final exchangeId = const Uuid().v4();
    final returnId = const Uuid().v4();
    final returnLines = <TransactionItem>[];
    for (final pick in picks) {
      final e = byId[pick.key];
      if (e == null || pick.value > e.returnable + 1e-9) {
        throw SaleExchangeException(l10n.exchangeMoreThanBought);
      }
      returnLines.add(
        buildReturnLine(
          original: e.line,
          alreadyReturned: e.alreadyReturned,
          qty: pick.value,
          returnTransactionId: returnId,
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

    final userId = box.getUserId();
    final shift = userId == null
        ? null
        : await ShiftOperations().getCurrentShift(userId: userId);
    final now = DateTime.now().toUtc();
    final vat = await _ebmWillSign();

    // --- 1. Draft the new sale (not visible anywhere yet) ----------------
    var sale = ITransaction(
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
      shiftId: shift?.id,
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
      shiftId: shift?.id,
      customerId: original.customerId,
      customerName: original.customerName,
      customerTin: original.customerTin,
      customerPhone: original.customerPhone,
      customerBhfId: original.customerBhfId,
      remark: 'exchange',
      ebmSynced: false,
    );

    final receipts = <Uint8List>[];
    if (vat) {
      try {
        final signed = await TaxController(object: ret).handleReceipt(
          filterType: FilterType.NR,
          purchaseCode: request.purchaseCode,
          transactionItems: returnLines,
          persistReceiptTransactionFields: false,
          deferPresentation: true,
        );
        if (signed.response.resultCd != '000') {
          throw StateError('RRA ${signed.response.resultCd}');
        }
        if (signed.bytes != null) receipts.add(signed.bytes!);
      } catch (e, s) {
        _talker.error('Exchange return not signed: $e', s);
        await _discardDraft(sale);
        throw SaleExchangeException(l10n.exchangeRraFailed);
      }
    }

    // From here the return is real (RRA has it on EBM branches). A failure
    // can no longer be undone, so it is reported as a partial save.
    try {
      await _commitReturn(ret, returnLines, now);
      sale = await _completeSale(
        sale: sale,
        saleLines: saleLines,
        original: original,
        request: request,
        branchId: branchId,
        exchangeId: exchangeId,
      );
      // Stock goes out before RRA hears about it, as at the POS: the stock
      // report sent with the signed sale then carries the new on-hand level.
      if (vat) {
        await persistPreSaleStockSnapshot(
          transactionItems: saleLines,
          transactionId: sale.id,
        );
      }
      await applyDeferredSaleStockDeduction(
        transactionItems: saleLines,
        allowSellingBelowStock: await _allowSellingBelowStock(businessId),
        isProformaOrTraining: false,
        transactionId: sale.id,
      );
    } catch (e, s) {
      _talker.error('Exchange $exchangeId partly saved: $e', s);
      throw SaleExchangeException(l10n.exchangePartlySaved);
    }

    var saleSigned = true;
    if (vat) {
      final bytes = await signSale(sale, lines: saleLines);
      saleSigned = bytes != null;
      if (bytes != null && bytes.isNotEmpty) receipts.add(bytes);
    } else {
      receipts.addAll(
        await _nonFiscalReceipts([(ret, returnLines), (sale, saleLines)]),
      );
    }

    _talker.info(
      'Exchange $exchangeId on ${original.id}: back $returnedValue, '
      'out ${sale.subTotal}, signed=$saleSigned',
    );
    return SaleExchangeResult(
      returnTransaction: ret,
      saleTransaction: sale,
      totals: ExchangeTotals(
        returned: returnedValue,
        taken: sale.subTotal?.toDouble() ?? 0,
      ),
      receipts: receipts,
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
        amountTotal: take.total,
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

  /// Writes the return, puts its stock back and credits the shift.
  Future<void> _commitReturn(
    ITransaction ret,
    List<TransactionItem> lines,
    DateTime now,
  ) async {
    // Lines before the row: adding a line to an existing row would also add
    // its amount to the row's subTotal, which is already final.
    for (final line in lines) {
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
    await _capella.addTransaction(transaction: ret);
    await _restoreStock(lines);
    try {
      await _capella.updateShiftTotals(
        transactionAmount: ret.subTotal?.toDouble() ?? 0,
        isRefund: true,
      );
    } catch (e) {
      _talker.warning('Exchange: shift refund total skipped: $e');
    }
  }

  /// Completes the drafted sale the way checkout does: totals and shift via
  /// collectPayment, then one full write with the exchange's own payment.
  Future<ITransaction> _completeSale({
    required ITransaction sale,
    required List<TransactionItem> saleLines,
    required ITransaction original,
    required SaleExchangeRequest request,
    required String branchId,
    required String exchangeId,
  }) async {
    final takenValue = saleLines.fold<double>(
      0,
      (s, l) => s + paidLineTotal(l),
    );
    final completed = await _capella.collectPayment(
      cashReceived: takenValue,
      transaction: sale,
      paymentType: request.paymentMethod,
      discount: 0,
      branchId: branchId,
      bhfId: (await _services.box.bhfId()) ?? '00',
      isProformaMode: false,
      isTrainingMode: false,
      transactionType: TransactionType.sale,
      isIncome: true,
      customerName: original.customerName,
      customerTin: original.customerTin,
      customerPhone: original.customerPhone,
      countryCode: '',
      completionStatus: COMPLETE,
      preloadedLineItems: saleLines,
      skipTransactionPersist: true,
      skipPersonalGoalAutoSweep: true,
    );
    // collectPayment prefers the POS's selected payment type; the exchange's
    // own settlement method is what the books and the till must show.
    completed
      ..status = COMPLETE
      ..paymentType = request.paymentMethod
      ..receiptType = TransactionReceptType.NS
      ..exchangeId = exchangeId
      ..cashReceived = completed.subTotal
      ..customerChangeDue = 0
      ..remainingBalance = 0
      ..updatedAt = DateTime.now().toUtc()
      ..lastTouched = DateTime.now().toUtc();
    await _capella.addTransaction(transaction: completed);
    await _capella.markItemAsDoneWithTransaction(
      inactiveItems: saleLines,
      pendingTransaction: completed,
      ignoreForReport: false,
      isDoneWithTransaction: true,
    );
    await _capella.savePaymentType(
      amount: completed.subTotal?.toDouble() ?? takenValue,
      transactionId: completed.id,
      paymentMethod: request.paymentMethod,
      singlePaymentOnly: false,
    );
    return completed;
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
      final signed = await TaxController(object: sale).handleReceipt(
        filterType: FilterType.NS,
        transactionItems: items,
        deferPresentation: true,
      );
      if (signed.response.resultCd != '000') return null;
      return signed.bytes ?? Uint8List(0);
    } catch (e, s) {
      _talker.error('Exchange sale not signed: $e', s);
      return null;
    }
  }

  Future<void> _restoreStock(List<TransactionItem> lines) async {
    for (final line in lines) {
      final variantId = line.variantId;
      if (variantId == null) continue;
      final variant = await _capella.getVariant(id: variantId);
      if (variant == null || variant.itemTyCd == '3') continue;
      final stockId = variant.stockId;
      if (stockId == null || stockId.isEmpty) continue;
      await _capella.updateStock(
        stockId: stockId,
        currentStock: line.qty.toDouble(),
        appending: true,
      );
    }
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
