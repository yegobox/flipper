class ServiceGigRequest {
  final String id;
  final String customerUserId;
  final String providerUserId;
  final String? requestedService;
  final String customerMessage;
  final String status;
  final DateTime acceptDeadlineAt;
  final DateTime? paymentDeadlineAt;
  final DateTime? acceptedAt;
  final String? customerBusinessId;
  final String? customerBranchId;
  final int? paymentAmountRwf;
  final String? mtnFinancialTransactionId;
  final String? mtnPaymentReference;
  final int? mtnSettledAmountRwf;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceGigRequest({
    required this.id,
    required this.customerUserId,
    required this.providerUserId,
    this.requestedService,
    required this.customerMessage,
    required this.status,
    required this.acceptDeadlineAt,
    this.paymentDeadlineAt,
    this.acceptedAt,
    this.customerBusinessId,
    this.customerBranchId,
    this.paymentAmountRwf,
    this.mtnFinancialTransactionId,
    this.mtnPaymentReference,
    this.mtnSettledAmountRwf,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Provider can still accept (within server deadline).
  bool get canProviderRespond =>
      status == 'requested' && DateTime.now().toUtc().isBefore(acceptDeadlineAt);

  bool get isAwaitingPayment => status == 'pending_payment';

  /// Customer can still pay before [paymentDeadlineAt].
  bool get canCustomerPay {
    if (status != 'pending_payment' || paymentDeadlineAt == null) {
      return false;
    }
    return DateTime.now().toUtc().isBefore(paymentDeadlineAt!);
  }

  factory ServiceGigRequest.fromJson(Map<String, dynamic> json) {
    DateTime parseTs(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    return ServiceGigRequest(
      id: json['id']?.toString() ?? '',
      customerUserId: json['customer_user_id']?.toString() ?? '',
      providerUserId: json['provider_user_id']?.toString() ?? '',
      requestedService: json['requested_service']?.toString(),
      customerMessage: json['customer_message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'requested',
      acceptDeadlineAt: parseTs(json['accept_deadline_at']),
      paymentDeadlineAt: json['payment_deadline_at'] != null
          ? parseTs(json['payment_deadline_at'])
          : null,
      acceptedAt:
          json['accepted_at'] != null ? parseTs(json['accepted_at']) : null,
      customerBusinessId: json['customer_business_id']?.toString(),
      customerBranchId: json['customer_branch_id']?.toString(),
      paymentAmountRwf: json['payment_amount_rwf'] is int
          ? json['payment_amount_rwf'] as int
          : int.tryParse(json['payment_amount_rwf']?.toString() ?? ''),
      mtnFinancialTransactionId:
          json['mtn_financial_transaction_id']?.toString(),
      mtnPaymentReference: json['mtn_payment_reference']?.toString(),
      mtnSettledAmountRwf: json['mtn_settled_amount_rwf'] is int
          ? json['mtn_settled_amount_rwf'] as int
          : int.tryParse(json['mtn_settled_amount_rwf']?.toString() ?? ''),
      paidAt: json['paid_at'] != null ? parseTs(json['paid_at']) : null,
      createdAt: parseTs(json['created_at']),
      updatedAt: parseTs(json['updated_at']),
    );
  }
}
