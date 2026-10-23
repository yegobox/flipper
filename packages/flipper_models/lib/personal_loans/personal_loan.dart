/// Loans a personal-mode user took (bank, SACCO, MoMo loan, family) and the
/// repayments made on them. Ditto-only collections, one doc per loan and one
/// per repayment, scoped by business. See `docs/personal_mode.md`.
///
/// A loan is described by whatever the user remembers. Every field but the
/// lender and the monthly payment is optional: someone who only knows "I pay
/// 150,000 a month until December 2027" can still see what is left.
library;

const String kPersonalLoansCollection = 'personal_loans';
const String kPersonalLoanPaymentsCollection = 'personal_loan_payments';

/// Category name a repayment is recorded under (a branch `Category` row, like
/// the other personal suggestions), and the one a received loan is.
const String kLoanRepaymentCategory = 'Loan repayment';
const String kLoanReceivedCategory = 'Loan received';

DateTime? _date(Object? v) =>
    v is String && v.trim().isNotEmpty ? DateTime.tryParse(v.trim()) : null;

double? _num(Object? v) => switch (v) {
  num n => n.toDouble(),
  String s => double.tryParse(s.trim()),
  _ => null,
};

String? _text(Object? v) {
  final s = v?.toString().trim();
  return s == null || s.isEmpty ? null : s;
}

String? _iso(DateTime? d) => d?.toIso8601String();

class PersonalLoan {
  const PersonalLoan({
    required this.id,
    required this.businessId,
    required this.branchId,
    required this.lender,
    required this.createdAt,
    this.monthlyPayment,
    this.annualRatePct,
    this.principal,
    this.startDate,
    this.endDate,
    this.termMonths,
    this.balance,
    this.balanceAt,
    this.currency = 'RWF',
    this.note,
    this.closedAt,
  });

  final String id;
  final String businessId;
  final String branchId;

  /// Who lent it: "BK", "Umurenge SACCO", "MoKash", "My brother".
  final String lender;

  /// The installment. Derived from [principal] and [termMonths] when absent.
  final double? monthlyPayment;

  /// Interest per year, in percent (16 = 16%). Null or 0: no interest.
  final double? annualRatePct;

  /// The amount borrowed, with [startDate] when the user knows it.
  final double? principal;
  final DateTime? startDate;

  /// When the user expects to finish paying (month precision is enough).
  final DateTime? endDate;
  final int? termMonths;

  /// What was owed on [balanceAt]: a balance the user entered ("I still owe
  /// 1.2M today"), which wins over anything estimated.
  final double? balance;
  final DateTime? balanceAt;

  final String currency;
  final String? note;
  final DateTime createdAt;

  /// Set when the user marks the loan cleared.
  final DateTime? closedAt;

  bool get isOpen => closedAt == null;

  factory PersonalLoan.fromDitto(Map<String, dynamic> d) => PersonalLoan(
    id: _text(d['_id']) ?? _text(d['id']) ?? '',
    businessId: _text(d['businessId']) ?? '',
    branchId: _text(d['branchId']) ?? '',
    lender: _text(d['lender']) ?? '',
    monthlyPayment: _num(d['monthlyPayment']),
    annualRatePct: _num(d['annualRatePct']),
    principal: _num(d['principal']),
    startDate: _date(d['startDate']),
    endDate: _date(d['endDate']),
    termMonths: _num(d['termMonths'])?.round(),
    balance: _num(d['balance']),
    balanceAt: _date(d['balanceAt']),
    currency: _text(d['currency']) ?? 'RWF',
    note: _text(d['note']),
    createdAt: _date(d['createdAt']) ?? DateTime.now(),
    closedAt: _date(d['closedAt']),
  );

  Map<String, dynamic> toDitto() => {
    '_id': id,
    'id': id,
    'businessId': businessId,
    'branchId': branchId,
    'lender': lender,
    'monthlyPayment': monthlyPayment,
    'annualRatePct': annualRatePct,
    'principal': principal,
    'startDate': _iso(startDate),
    'endDate': _iso(endDate),
    'termMonths': termMonths,
    'balance': balance,
    'balanceAt': _iso(balanceAt),
    'currency': currency,
    'note': note,
    'createdAt': _iso(createdAt),
    'closedAt': _iso(closedAt),
    'lastTouched': DateTime.now().toUtc().toIso8601String(),
  };

  PersonalLoan copyWith({
    String? lender,
    double? monthlyPayment,
    double? annualRatePct,
    double? principal,
    DateTime? startDate,
    DateTime? endDate,
    int? termMonths,
    double? balance,
    DateTime? balanceAt,
    String? note,
    DateTime? closedAt,
    bool clearClosed = false,
  }) => PersonalLoan(
    id: id,
    businessId: businessId,
    branchId: branchId,
    lender: lender ?? this.lender,
    monthlyPayment: monthlyPayment ?? this.monthlyPayment,
    annualRatePct: annualRatePct ?? this.annualRatePct,
    principal: principal ?? this.principal,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    termMonths: termMonths ?? this.termMonths,
    balance: balance ?? this.balance,
    balanceAt: balanceAt ?? this.balanceAt,
    currency: currency,
    note: note ?? this.note,
    createdAt: createdAt,
    closedAt: clearClosed ? null : (closedAt ?? this.closedAt),
  );
}

/// One repayment. Recorded with the Cash Out it came from ([transactionId])
/// so the money also counts as spending, or on its own.
class PersonalLoanPayment {
  const PersonalLoanPayment({
    required this.id,
    required this.loanId,
    required this.businessId,
    required this.amount,
    required this.paidAt,
    this.transactionId,
    this.source = 'manual',
  });

  final String id;
  final String loanId;
  final String businessId;
  final double amount;
  final DateTime paidAt;
  final String? transactionId;

  /// `manual`, `form` (money-out form) or `sms` (confirmed bank/MoMo SMS).
  final String source;

  factory PersonalLoanPayment.fromDitto(Map<String, dynamic> d) =>
      PersonalLoanPayment(
        id: _text(d['_id']) ?? _text(d['id']) ?? '',
        loanId: _text(d['loanId']) ?? '',
        businessId: _text(d['businessId']) ?? '',
        amount: _num(d['amount']) ?? 0,
        paidAt: _date(d['paidAt']) ?? DateTime.now(),
        transactionId: _text(d['transactionId']),
        source: _text(d['source']) ?? 'manual',
      );

  Map<String, dynamic> toDitto() => {
    '_id': id,
    'id': id,
    'loanId': loanId,
    'businessId': businessId,
    'amount': amount,
    'paidAt': _iso(paidAt),
    'transactionId': transactionId,
    'source': source,
    'lastTouched': DateTime.now().toUtc().toIso8601String(),
  };
}
