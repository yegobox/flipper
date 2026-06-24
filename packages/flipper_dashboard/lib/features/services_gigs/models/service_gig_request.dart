import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';

class ServiceGigRequest {
  final String id;
  final String customerUserId;
  final String providerUserId;
  
  /// Customer details (denormalized for display)
  final String? customerDisplayName;
  final String? customerProfileImageUrl;
  final String? customerPhone;
  
  /// Provider details (denormalized for display)
  final String? providerDisplayName;
  final String? providerProfileImageUrl;
  final String? providerPhone;
  
  final String? requestedService;
  final String customerMessage;
  final String status;
  
  /// Timeline
  final DateTime acceptDeadlineAt;
  final DateTime? paymentDeadlineAt;
  final DateTime? acceptedAt;
  final DateTime? paidAt;
  final DateTime? providerStartedAt;
  final DateTime? providerCompletedAt;
  final DateTime? customerConfirmedAt;
  
  /// Customer business context
  final String? customerBusinessId;
  final String? customerBranchId;
  
  /// Payment details
  final int? paymentAmountRwf;
  final int? platformFeeRwf;
  final int? providerEarningsRwf;
  final String? mtnFinancialTransactionId;
  final String? mtnPaymentReference;
  final int? mtnSettledAmountRwf;
  
  /// Service execution
  final String? serviceLocation;
  final DateTime? scheduledDateTime;
  final String? specialInstructions;
  
  /// Communication
  final List<RequestMessage>? messages;
  
  /// Reviews (after completion)
  final String? customerReview;
  final int? customerRating;
  final DateTime? reviewSubmittedAt;
  final String? providerResponse;
  
  /// Cancellation
  final String? cancellationReason;
  final String? cancelledBy;
  final DateTime? cancelledAt;
  
  /// Provider payout dispatch (admin-only).
  final String providerPayoutStatus;
  final DateTime? providerPayoutDispatchedAt;
  final String? providerPayoutDispatchedBy;
  final String? providerPayoutReference;

  final DateTime createdAt;
  final DateTime updatedAt;

  const ServiceGigRequest({
    required this.id,
    required this.customerUserId,
    required this.providerUserId,
    this.customerDisplayName,
    this.customerProfileImageUrl,
    this.customerPhone,
    this.providerDisplayName,
    this.providerProfileImageUrl,
    this.providerPhone,
    this.requestedService,
    required this.customerMessage,
    required this.status,
    required this.acceptDeadlineAt,
    this.paymentDeadlineAt,
    this.acceptedAt,
    this.paidAt,
    this.providerStartedAt,
    this.providerCompletedAt,
    this.customerConfirmedAt,
    this.customerBusinessId,
    this.customerBranchId,
    this.paymentAmountRwf,
    this.platformFeeRwf,
    this.providerEarningsRwf,
    this.mtnFinancialTransactionId,
    this.mtnPaymentReference,
    this.mtnSettledAmountRwf,
    this.serviceLocation,
    this.scheduledDateTime,
    this.specialInstructions,
    this.messages,
    this.customerReview,
    this.customerRating,
    this.reviewSubmittedAt,
    this.providerResponse,
    this.cancellationReason,
    this.cancelledBy,
    this.cancelledAt,
    this.providerPayoutStatus = 'pending',
    this.providerPayoutDispatchedAt,
    this.providerPayoutDispatchedBy,
    this.providerPayoutReference,
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

  /// Service is in progress (paid and not yet completed).
  bool get isInProgress => 
      status == 'paid' || status == 'in_progress';

  /// Service has been completed.
  bool get isCompleted => status == 'completed';

  /// Request was cancelled.
  bool get isCancelled => status == 'cancelled';

  /// Request was declined.
  bool get isDeclined => status == 'declined';

  /// Request has expired.
  bool get isExpired => status == 'expired';

  /// Can customer leave a review.
  bool get canLeaveReview => 
      isCompleted && customerRating == null;

  /// Get time remaining for provider to accept.
  Duration? get timeRemainingForAccept {
    if (!canProviderRespond) return null;
    return acceptDeadlineAt.difference(DateTime.now().toUtc());
  }

  /// Get time remaining for customer to pay.
  Duration? get timeRemainingForPayment {
    if (!canCustomerPay) return null;
    return paymentDeadlineAt!.difference(DateTime.now().toUtc());
  }

  /// Format time remaining nicely.
  static String formatDuration(Duration? duration) {
    if (duration == null) return '';
    if (duration.isNegative) return 'Expired';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get status display label.
  String get statusLabel {
    switch (status) {
      case 'requested':
        return canProviderRespond ? 'Awaiting Provider Response' : 'Accept Window Expired';
      case 'pending_payment':
        return canCustomerPay ? 'Awaiting Payment' : 'Payment Window Expired';
      case 'paid':
        return 'Paid - Ready to Start';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'declined':
        return 'Declined by Provider';
      case 'expired':
        return 'Expired';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Get status color for UI.
  int get statusColor {
    switch (status) {
      case 'requested':
        return canProviderRespond ? 0xFF0D9488 : 0xFF6B7280;
      case 'pending_payment':
        return canCustomerPay ? 0xFFF59E0B : 0xFF6B7280;
      case 'paid':
      case 'in_progress':
        return 0xFF0D9488;
      case 'completed':
        return 0xFF10B981;
      case 'declined':
      case 'cancelled':
        return 0xFFEF4444;
      case 'expired':
        return 0xFF6B7280;
      default:
        return 0xFF6B7280;
    }
  }

  factory ServiceGigRequest.fromJson(Map<String, dynamic> json) {
    DateTime parseTs(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    List<RequestMessage>? parseMessages(dynamic v) {
      if (v == null) return null;
      if (v is List) {
        return v
            .where((e) => e != null)
            .map((e) => RequestMessage.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      return null;
    }

    return ServiceGigRequest(
      id: json['id']?.toString() ?? '',
      customerUserId: json['customer_user_id']?.toString() ?? '',
      providerUserId: json['provider_user_id']?.toString() ?? '',
      customerDisplayName: json['customer_display_name']?.toString(),
      customerProfileImageUrl: json['customer_profile_image_url']?.toString(),
      customerPhone: json['customer_phone']?.toString(),
      providerDisplayName: json['provider_display_name']?.toString(),
      providerProfileImageUrl: json['provider_profile_image_url']?.toString(),
      providerPhone: json['provider_phone']?.toString(),
      requestedService: json['requested_service']?.toString(),
      customerMessage: json['customer_message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'requested',
      acceptDeadlineAt: parseTs(json['accept_deadline_at']),
      paymentDeadlineAt: json['payment_deadline_at'] != null
          ? parseTs(json['payment_deadline_at'])
          : null,
      acceptedAt:
          json['accepted_at'] != null ? parseTs(json['accepted_at']) : null,
      paidAt: json['paid_at'] != null ? parseTs(json['paid_at']) : null,
      providerStartedAt: json['provider_started_at'] != null
          ? parseTs(json['provider_started_at'])
          : null,
      providerCompletedAt: json['provider_completed_at'] != null
          ? parseTs(json['provider_completed_at'])
          : null,
      customerConfirmedAt: json['customer_confirmed_at'] != null
          ? parseTs(json['customer_confirmed_at'])
          : null,
      customerBusinessId: json['customer_business_id']?.toString(),
      customerBranchId: json['customer_branch_id']?.toString(),
      paymentAmountRwf: json['payment_amount_rwf'] is int
          ? json['payment_amount_rwf']
          : int.tryParse(json['payment_amount_rwf']?.toString() ?? ''),
      platformFeeRwf: json['platform_fee_rwf'] is int
          ? json['platform_fee_rwf']
          : int.tryParse(json['platform_fee_rwf']?.toString() ?? ''),
      providerEarningsRwf: json['provider_earnings_rwf'] is int
          ? json['provider_earnings_rwf']
          : int.tryParse(json['provider_earnings_rwf']?.toString() ?? ''),
      mtnFinancialTransactionId:
          json['mtn_financial_transaction_id']?.toString(),
      mtnPaymentReference: json['mtn_payment_reference']?.toString(),
      mtnSettledAmountRwf: json['mtn_settled_amount_rwf'] is int
          ? json['mtn_settled_amount_rwf']
          : int.tryParse(json['mtn_settled_amount_rwf']?.toString() ?? ''),
      serviceLocation: json['service_location']?.toString(),
      scheduledDateTime: json['scheduled_date_time'] != null
          ? parseTs(json['scheduled_date_time'])
          : null,
      specialInstructions: json['special_instructions']?.toString(),
      messages: parseMessages(json['messages']),
      customerReview: json['customer_review']?.toString(),
      customerRating: json['customer_rating'] is int
          ? json['customer_rating']
          : int.tryParse(json['customer_rating']?.toString() ?? ''),
      reviewSubmittedAt: json['review_submitted_at'] != null
          ? parseTs(json['review_submitted_at'])
          : null,
      providerResponse: json['provider_response']?.toString(),
      cancellationReason: json['cancellation_reason']?.toString(),
      cancelledBy: json['cancelled_by']?.toString(),
      cancelledAt: json['cancelled_at'] != null
          ? parseTs(json['cancelled_at'])
          : null,
      providerPayoutStatus:
          json['provider_payout_status']?.toString() ?? 'pending',
      providerPayoutDispatchedAt: json['provider_payout_dispatched_at'] != null
          ? parseTs(json['provider_payout_dispatched_at'])
          : null,
      providerPayoutDispatchedBy:
          json['provider_payout_dispatched_by']?.toString(),
      providerPayoutReference: json['provider_payout_reference']?.toString(),
      createdAt: parseTs(json['created_at']),
      updatedAt: parseTs(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_user_id': customerUserId,
        'provider_user_id': providerUserId,
        'customer_display_name': customerDisplayName,
        'customer_profile_image_url': customerProfileImageUrl,
        'customer_phone': customerPhone,
        'provider_display_name': providerDisplayName,
        'provider_profile_image_url': providerProfileImageUrl,
        'provider_phone': providerPhone,
        'requested_service': requestedService,
        'customer_message': customerMessage,
        'status': status,
        'accept_deadline_at': acceptDeadlineAt.toIso8601String(),
        if (paymentDeadlineAt != null)
          'payment_deadline_at': paymentDeadlineAt!.toIso8601String(),
        if (acceptedAt != null) 'accepted_at': acceptedAt!.toIso8601String(),
        if (paidAt != null) 'paid_at': paidAt!.toIso8601String(),
        if (providerStartedAt != null)
          'provider_started_at': providerStartedAt!.toIso8601String(),
        if (providerCompletedAt != null)
          'provider_completed_at': providerCompletedAt!.toIso8601String(),
        if (customerConfirmedAt != null)
          'customer_confirmed_at': customerConfirmedAt!.toIso8601String(),
        'customer_business_id': customerBusinessId,
        'customer_branch_id': customerBranchId,
        'payment_amount_rwf': paymentAmountRwf,
        'platform_fee_rwf': platformFeeRwf,
        'provider_earnings_rwf': providerEarningsRwf,
        'mtn_financial_transaction_id': mtnFinancialTransactionId,
        'mtn_payment_reference': mtnPaymentReference,
        'mtn_settled_amount_rwf': mtnSettledAmountRwf,
        'service_location': serviceLocation,
        if (scheduledDateTime != null)
          'scheduled_date_time': scheduledDateTime!.toIso8601String(),
        'special_instructions': specialInstructions,
        if (messages != null)
          'messages': messages!.map((m) => m.toJson()).toList(),
        'customer_review': customerReview,
        'customer_rating': customerRating,
        if (reviewSubmittedAt != null)
          'review_submitted_at': reviewSubmittedAt!.toIso8601String(),
        'provider_response': providerResponse,
        'cancellation_reason': cancellationReason,
        'cancelled_by': cancelledBy,
        if (cancelledAt != null) 'cancelled_at': cancelledAt!.toIso8601String(),
        'provider_payout_status': providerPayoutStatus,
        if (providerPayoutDispatchedAt != null)
          'provider_payout_dispatched_at':
              providerPayoutDispatchedAt!.toIso8601String(),
        'provider_payout_dispatched_by': providerPayoutDispatchedBy,
        'provider_payout_reference': providerPayoutReference,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

/// Message in the request conversation
class RequestMessage {
  final String id;
  final String senderUserId;
  final String senderDisplayName;
  final String message;
  final DateTime sentAt;
  final bool isSystemMessage;

  const RequestMessage({
    required this.id,
    required this.senderUserId,
    required this.senderDisplayName,
    required this.message,
    required this.sentAt,
    this.isSystemMessage = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_user_id': senderUserId,
        'sender_display_name': senderDisplayName,
        'message': message,
        'sent_at': sentAt.toIso8601String(),
        'is_system_message': isSystemMessage,
      };

  factory RequestMessage.fromJson(Map<String, dynamic> json) {
    return RequestMessage(
      id: json['id']?.toString() ?? '',
      senderUserId: json['sender_user_id']?.toString() ?? '',
      senderDisplayName: json['sender_display_name']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      sentAt: json['sent_at'] is DateTime
          ? json['sent_at']
          : DateTime.parse(json['sent_at'].toString()),
      isSystemMessage: json['is_system_message'] ?? false,
    );
  }

  /// Compares [senderUserId] to the owning request’s ids (raw UUIDs). False for system messages or if [request] is null.
  bool isFromCustomer(ServiceGigRequest? request) {
    if (isSystemMessage || request == null) return false;
    return senderUserId == request.customerUserId;
  }

  /// Compares [senderUserId] to the owning request’s ids (raw UUIDs). False for system messages or if [request] is null.
  bool isFromProvider(ServiceGigRequest? request) {
    if (isSystemMessage || request == null) return false;
    return senderUserId == request.providerUserId;
  }
}

/// Service category for better organization
class ServiceCategory {
  final String id;
  final String name;
  final String icon;
  final String? description;
  final List<String> subcategories;
  final int providerCount;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.description,
    this.subcategories = const [],
    this.providerCount = 0,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'category',
      description: json['description']?.toString(),
      subcategories: (json['subcategories'] as List?)?.map((e) => e.toString()).toList() ?? [],
      providerCount: json['provider_count'] is int
          ? json['provider_count']
          : int.tryParse(json['provider_count']?.toString() ?? '0') ?? 0,
    );
  }

  /// True if [provider] tagged this category or any service line matches keywords.
  bool matchesProvider(ServiceGigProvider provider) {
    if (provider.serviceCategories.contains(id)) return true;
    for (final s in provider.services) {
      final line = s.toLowerCase();
      if (line.isEmpty) continue;
      if (name.toLowerCase().contains(line) || line.contains(name.toLowerCase())) {
        return true;
      }
      for (final sub in subcategories) {
        if (line.contains(sub.toLowerCase())) return true;
      }
    }
    return false;
  }

  static List<ServiceCategory> get defaultCategories => [
        const ServiceCategory(
          id: 'home_services',
          name: 'Home Services',
          icon: 'home_repair_service',
          subcategories: ['Plumbing', 'Electrical', 'Cleaning', 'Painting', 'Carpentry'],
        ),
        const ServiceCategory(
          id: 'beauty_wellness',
          name: 'Beauty & Wellness',
          icon: 'spa',
          subcategories: ['Hair Styling', 'Makeup', 'Massage', 'Nail Care'],
        ),
        const ServiceCategory(
          id: 'delivery_transport',
          name: 'Delivery & Transport',
          icon: 'local_shipping',
          subcategories: ['Package Delivery', 'Moving Help', 'Errands'],
        ),
        const ServiceCategory(
          id: 'tech_support',
          name: 'Tech Support',
          icon: 'devices',
          subcategories: ['Phone Repair', 'Computer Repair', 'Installation'],
        ),
        const ServiceCategory(
          id: 'events',
          name: 'Events',
          icon: 'celebration',
          subcategories: ['Photography', 'Catering', 'Decoration', 'Music/DJ'],
        ),
        const ServiceCategory(
          id: 'lessons',
          name: 'Lessons & Training',
          icon: 'school',
          subcategories: ['Tutoring', 'Music Lessons', 'Sports Coaching'],
        ),
        const ServiceCategory(
          id: 'healthcare',
          name: 'Healthcare',
          icon: 'medical_services',
          subcategories: ['Nursing', 'Elderly Care', 'Childcare'],
        ),
        const ServiceCategory(
          id: 'other',
          name: 'Other',
          icon: 'more_horiz',
        ),
      ];
}
