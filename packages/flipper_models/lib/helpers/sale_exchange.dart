import 'package:supabase_models/brick/models/all_models.dart';
import 'package:uuid/uuid.dart';

/// Item exchange: a customer brings items back from a completed sale and takes
/// others. The original sale is never edited. The exchange writes two new
/// transactions sharing one `exchangeId`:
///
/// * the return — receiptType NR, `originalTransactionId` = the sale, only the
///   returned lines (marked `ignoreForReport`, like every NR copy). Readers
///   that total sales count it NEGATIVE ([exchangeSign]);
/// * the new sale — an ordinary NS sale.
///
/// Every rule here keys off `exchangeId`, so plain refunds (NR without it)
/// and ordinary sales read exactly as they did before this feature.
/// data-connector mirrors [isExchangeReturn] in
/// `src/accounting/semantics.rs` (`is_exchange_return`).

const _refundReceiptTypes = {'NR', 'CR', 'TR'};

/// True for the return transaction of an item exchange.
bool isExchangeReturn(ITransaction transaction) {
  final exchangeId = transaction.exchangeId;
  if (exchangeId == null || exchangeId.isEmpty) return false;
  final type = transaction.receiptType?.trim().toUpperCase();
  return type != null && _refundReceiptTypes.contains(type);
}

/// Records on an exchange return that RRA accepted it as [invoiceNumber].
///
/// Called the moment RRA answers 000, before any local receipt, counter or
/// PDF work, so the exchange can tell "RRA refused the return" (nothing is
/// kept) from "RRA has the return and a local step after it failed" (the
/// return must still be recorded). See [exchangeReturnSignedByRra].
void markExchangeReturnSigned(ITransaction transaction, int invoiceNumber) {
  if (!isExchangeReturn(transaction)) return;
  transaction
    ..ebmSynced = true
    ..receiptNumber = invoiceNumber
    ..totalReceiptNumber = invoiceNumber
    ..invoiceNumber = invoiceNumber;
}

/// True once RRA has accepted [transaction], an exchange return, even if
/// signing then threw (see [markExchangeReturnSigned]).
bool exchangeReturnSignedByRra(ITransaction transaction) =>
    isExchangeReturn(transaction) && transaction.ebmSynced == true;

/// -1 for an exchange return (its positive amounts are money going back),
/// +1 for everything else.
int exchangeSign(ITransaction transaction) =>
    isExchangeReturn(transaction) ? -1 : 1;

/// [transaction.subTotal] signed by [exchangeSign].
double signedSubTotal(ITransaction transaction) =>
    exchangeSign(transaction) * (transaction.subTotal?.toDouble() ?? 0);

double _roundMoney(double v) => (v * 100).round() / 100;

/// The part of a line [total] that belongs to units
/// `(alreadyReturned, alreadyReturned + returning]` of a [qty]-unit line.
///
/// Rounded cumulatively, so returning a line one unit at a time adds up to
/// [total] exactly — the returns reverse precisely what the sale booked.
double proRataShare({
  required num total,
  required num qty,
  required num alreadyReturned,
  required num returning,
}) {
  if (qty <= 0 || returning <= 0) return 0;
  final t = total.toDouble();
  final q = qty.toDouble();
  final upTo = (alreadyReturned + returning).toDouble().clamp(0, q);
  final before = alreadyReturned.toDouble().clamp(0, q);
  return _roundMoney(t * upTo / q) - _roundMoney(t * before / q);
}

/// What the customer actually paid for [item]: `totAmt` (after discount) when
/// recorded, else price × qty less the rate discount.
double paidLineTotal(TransactionItem item) {
  final tot = item.totAmt?.toDouble() ?? 0;
  if (tot > 0) return tot;
  final gross = item.price.toDouble() * item.qty.toDouble();
  final dcRt = item.dcRt?.toDouble() ?? 0;
  return gross * (1 - dcRt / 100);
}

/// A copy of [original] for [qty] returned units on the return transaction
/// [returnTransactionId]. Money and cost fields are the original's, pro-rata
/// (see [proRataShare]) — never today's price or cost — so the return
/// reverses exactly what the sale booked (revenue, VAT and COGS).
TransactionItem buildReturnLine({
  required TransactionItem original,
  required num alreadyReturned,
  required num qty,
  required String returnTransactionId,
  String? id,
}) {
  double share(num? total) => total == null
      ? 0
      : proRataShare(
          total: total,
          qty: original.qty,
          alreadyReturned: alreadyReturned,
          returning: qty,
        );

  final line = original.copyWith(
    id: id ?? const Uuid().v4(),
    transactionId: returnTransactionId,
    qty: qty,
    totAmt: share(paidLineTotal(original)),
    taxblAmt: original.taxblAmt == null ? null : share(original.taxblAmt),
    taxAmt: share(original.taxAmt ?? 0),
    dcAmt: original.dcAmt == null ? null : share(original.dcAmt),
    splyAmt: original.splyAmt == null ? null : share(original.splyAmt),
    discount: share(original.discount),
    // Line-level marker Flutter readers see: inventory movement counts these
    // as refunded units, the end-of-shift summary skips them.
    isRefunded: true,
    doneWithTransaction: true,
    active: true,
    createdAt: DateTime.now().toUtc(),
    updatedAt: DateTime.now().toUtc(),
    lastTouched: DateTime.now().toUtc(),
  );
  // Set after construction: the TransactionItem constructor drops its
  // `ignoreForReport` argument. Stored like every NR copy's lines.
  line.ignoreForReport = true;
  return line;
}

/// Units already returned per original line id, from the lines of earlier
/// exchange returns of the same sale. Returned lines are matched to the
/// original by variant, filling the original's lines in order, so a sale with
/// two lines of one variant still caps at their combined quantity.
Map<String, double> returnedQtyByOriginalLine({
  required List<TransactionItem> originalLines,
  required List<TransactionItem> priorReturnLines,
}) {
  final returnedByVariant = <String, double>{};
  for (final line in priorReturnLines) {
    final vid = line.variantId;
    if (vid == null) continue;
    returnedByVariant[vid] =
        (returnedByVariant[vid] ?? 0) + line.qty.toDouble();
  }
  final out = <String, double>{};
  for (final line in originalLines) {
    final vid = line.variantId;
    final remaining = vid == null ? 0.0 : (returnedByVariant[vid] ?? 0);
    final taken = remaining.clamp(0, line.qty.toDouble()).toDouble();
    out[line.id] = taken;
    if (vid != null) returnedByVariant[vid] = remaining - taken;
  }
  return out;
}

/// Totals of one exchange, in what-the-customer-sees terms.
class ExchangeTotals {
  const ExchangeTotals({required this.returned, required this.taken});

  /// Value of the items brought back (what was paid for them).
  final double returned;

  /// Value of the items taken instead.
  final double taken;

  /// Positive: the customer pays this. Negative: give this back.
  double get difference => _roundMoney(taken - returned);

  bool get customerPays => difference > 0;
  bool get giveBack => difference < 0;
}
