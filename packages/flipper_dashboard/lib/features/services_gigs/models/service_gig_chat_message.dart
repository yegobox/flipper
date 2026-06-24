class ServiceGigChatMessage {
  final String id;
  final String requestId;
  final String senderUserId;
  final String body;
  final DateTime createdAt;

  const ServiceGigChatMessage({
    required this.id,
    required this.requestId,
    required this.senderUserId,
    required this.body,
    required this.createdAt,
  });

  factory ServiceGigChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime parseTs(dynamic v) {
      if (v is DateTime) return v;
      return DateTime.parse(v.toString());
    }

    return ServiceGigChatMessage(
      id: json['id']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      senderUserId: json['sender_user_id']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      createdAt: parseTs(json['created_at']),
    );
  }
}

/// Aggregated earnings for provider dashboard (from paid / in-progress / completed rows).
class ProviderGigEarningsSummary {
  final int fundedJobCount;
  final int totalPaymentRwf;

  const ProviderGigEarningsSummary({
    required this.fundedJobCount,
    required this.totalPaymentRwf,
  });
}
