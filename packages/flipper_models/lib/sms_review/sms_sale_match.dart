import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_services/payment_methods.dart';

/// How far from the SMS's own time a till sale can be and still be offered
/// as the sale the SMS pays for.
const smsSaleMatchWindow = Duration(hours: 2);

/// A completed sale that an incoming SMS may already be paying for.
class SmsSaleCandidate {
  const SmsSaleCandidate({
    required this.transactionId,
    required this.amount,
    required this.paymentType,
    this.createdAt,
    this.receiptType,
    this.isExpense = false,
    this.invoiceNumber,
    this.customerName,
  });

  final String transactionId;
  final double amount;
  final String paymentType;
  final DateTime? createdAt;
  final String? receiptType;
  final bool isExpense;
  final int? invoiceNumber;
  final String? customerName;

  factory SmsSaleCandidate.fromDitto(Map<String, dynamic> doc) {
    final amount = doc['subTotal'];
    final invoice = doc['invoiceNumber'];
    return SmsSaleCandidate(
      transactionId: (doc['_id'] ?? doc['id'] ?? '').toString(),
      amount: amount is num ? amount.toDouble() : 0,
      paymentType: doc['paymentType']?.toString() ?? '',
      createdAt: DateTime.tryParse(doc['createdAt']?.toString() ?? ''),
      receiptType: doc['receiptType']?.toString(),
      isExpense: doc['isExpense'] == true,
      invoiceNumber: invoice is num ? invoice.toInt() : null,
      customerName: doc['customerName']?.toString(),
    );
  }
}

/// Whether [item] can be linked to a sale at all: money in, not a charge,
/// with a time to match against.
bool smsCanMatchSale(SmsReviewItem item) =>
    item.isIncome && !item.isFee && item.occurredAtDate != null;

/// The sales [item] may already be paying for, nearest in time first.
///
/// A sale qualifies when it is money in for exactly the SMS's amount, was
/// paid with the same tender (every mobile-money spelling counts as one), and
/// is within [smsSaleMatchWindow] of the SMS. Cash Book movements are not
/// sales, and a sale already linked to another SMS ([linkedTransactionIds])
/// is never offered twice.
List<SmsSaleCandidate> smsMatchingSales(
  SmsReviewItem item,
  Iterable<SmsSaleCandidate> candidates, {
  Set<String> linkedTransactionIds = const {},
}) {
  final at = item.occurredAtDate;
  if (!smsCanMatchSale(item) || at == null) return const [];
  final tender = canonicalPaymentMethod(item.paymentType).toUpperCase();
  final matches = candidates.where((c) {
    if (c.transactionId.isEmpty) return false;
    if (linkedTransactionIds.contains(c.transactionId)) return false;
    if (c.isExpense) return false;
    if (c.receiptType == 'Cash In' || c.receiptType == 'Cash Out') {
      return false;
    }
    if (c.amount.round() != item.amount) return false;
    if (canonicalPaymentMethod(c.paymentType).toUpperCase() != tender) {
      return false;
    }
    final created = c.createdAt;
    return created != null &&
        created.difference(at).abs() <= smsSaleMatchWindow;
  }).toList();
  matches.sort(
    (a, b) => a.createdAt!
        .difference(at)
        .abs()
        .compareTo(b.createdAt!.difference(at).abs()),
  );
  return matches;
}
