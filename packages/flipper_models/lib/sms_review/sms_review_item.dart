/// A bank or mobile-money SMS waiting for review in the Cash Book.
///
/// Written to Ditto `sms_transactions` by the data-connector
/// (`data-connector/src/sms/writer.rs`) when a paired SMS Bridge phone
/// forwards a transaction message. One item per money movement: a provider
/// charge is its own item (`kind == 'fee'`) with `parentId` pointing at the
/// principal.
class SmsReviewItem {
  const SmsReviewItem({
    required this.id,
    required this.businessId,
    required this.branchId,
    required this.kind,
    required this.direction,
    required this.amount,
    required this.description,
    required this.providerLabel,
    required this.paymentType,
    required this.bankAccountCode,
    required this.status,
    this.fee = 0,
    this.currency = 'RWF',
    this.reference,
    this.counterpartyName,
    this.counterpartyAccount,
    this.occurredAt,
    this.lineDate,
    this.suggestedCategory,
    this.bankLineId,
    this.confidence,
    this.parentId,
  });

  static const collection = 'sms_transactions';

  /// Statuses. Only [pending] items are listed for review.
  static const pending = 'pending_review';
  static const confirming = 'confirming';
  static const confirmed = 'confirmed';
  static const ignored = 'ignored';

  /// Money moved between the business's own accounts: the bank line stays,
  /// but nothing goes to the Cash Book.
  static const transfer = 'transfer';

  final String id;
  final String businessId;
  final String branchId;

  /// `principal` or `fee`.
  final String kind;

  /// `credit` (money in) or `debit` (money out).
  final String direction;
  final int amount;

  /// On a principal: the charge taken with it (its own item), for display.
  final int fee;
  final String currency;
  final String? reference;
  final String? counterpartyName;

  /// Masked to the last 4 digits by the connector.
  final String? counterpartyAccount;

  /// `YYYY-MM-DDTHH:MM:SS`, local time, as read from the SMS.
  final String? occurredAt;

  /// `YYYY-MM-DD`; always set, falls back to the day the SMS arrived.
  final String? lineDate;
  final String description;
  final String providerLabel;

  /// Flipper payment method the movement is recorded with, chosen so the
  /// journal entry posts to the same account the bank line sits on.
  final String paymentType;
  final String bankAccountCode;
  final String? suggestedCategory;
  final String? bankLineId;

  /// `high`, `medium` or `low` (keyword fallback: check against the SMS).
  final String? confidence;
  final String? parentId;
  final String status;

  bool get isIncome => direction == 'credit';
  bool get isFee => kind == 'fee';
  bool get isLowConfidence => confidence == 'low';

  /// The Cash Book movement name `completeCashMovement` expects
  /// (`TransactionType.cashIn` / `cashOut`).
  String get movementName => isIncome ? 'Cash In' : 'Cash Out';

  /// When the money moved, for back-dating the movement. Prefers the SMS's
  /// own timestamp, then its date; null when neither parses.
  DateTime? get occurredAtDate =>
      DateTime.tryParse(occurredAt ?? '') ?? DateTime.tryParse(lineDate ?? '');

  factory SmsReviewItem.fromDitto(Map<String, dynamic> doc) {
    String? text(String key) {
      final v = doc[key];
      if (v == null) return null;
      final s = v.toString();
      return s.isEmpty ? null : s;
    }

    int number(String key) {
      final v = doc[key];
      if (v is num) return v.round();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return SmsReviewItem(
      id: text('_id') ?? text('id') ?? '',
      businessId: text('businessId') ?? '',
      branchId: text('branchId') ?? '',
      kind: text('kind') ?? 'principal',
      direction: text('direction') ?? 'debit',
      amount: number('amount'),
      fee: number('fee'),
      currency: text('currency') ?? 'RWF',
      reference: text('reference'),
      counterpartyName: text('counterpartyName'),
      counterpartyAccount: text('counterpartyAccount'),
      occurredAt: text('occurredAt'),
      lineDate: text('lineDate'),
      description: text('description') ?? '',
      providerLabel: text('providerLabel') ?? '',
      paymentType: text('paymentType') ?? 'BANK TRANSFER',
      bankAccountCode: text('bankAccountCode') ?? '1020',
      suggestedCategory: text('suggestedCategory'),
      bankLineId: text('bankLineId'),
      confidence: text('confidence'),
      parentId: text('parentId'),
      status: text('status') ?? pending,
    );
  }
}
