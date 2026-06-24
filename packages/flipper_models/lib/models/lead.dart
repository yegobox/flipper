class LeadSource {
  static const String walkIn = 'walkIn';
  static const String phoneReferral = 'phoneReferral';
  static const String gmail = 'gmail';
}

class LeadStatus {
  static const String newLead = 'new';
  static const String contacted = 'contacted';
  static const String quoted = 'quoted';
  static const String converted = 'converted';
  static const String lost = 'lost';
}

class LeadHeat {
  static const String hot = 'hot';
  static const String warm = 'warm';
  static const String cold = 'cold';
}

class Lead {
  final String id;
  final String branchId;
  final String? businessId;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastTouched;

  final String fullName;
  final String? phoneNumber;
  final String? emailAddress;

  final String source; // LeadSource.*
  final String status; // LeadStatus.*
  final String heat; // LeadHeat.*

  final String? productsInterestedIn;
  final num? estimatedValue;
  final String? notes;

  // Future proofing for Gmail/AI ingestion
  final String? externalThreadId;
  final num? aiConfidence;
  final Map<String, dynamic>? aiExtracted;

  const Lead({
    required this.id,
    required this.branchId,
    required this.businessId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastTouched,
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.source,
    required this.status,
    required this.heat,
    required this.productsInterestedIn,
    required this.estimatedValue,
    required this.notes,
    required this.externalThreadId,
    required this.aiConfidence,
    required this.aiExtracted,
  });

  Lead copyWith({
    String? id,
    String? branchId,
    String? businessId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastTouched,
    String? fullName,
    String? phoneNumber,
    String? emailAddress,
    String? source,
    String? status,
    String? heat,
    String? productsInterestedIn,
    num? estimatedValue,
    String? notes,
    String? externalThreadId,
    num? aiConfidence,
    Map<String, dynamic>? aiExtracted,
  }) {
    return Lead(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTouched: lastTouched ?? this.lastTouched,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      source: source ?? this.source,
      status: status ?? this.status,
      heat: heat ?? this.heat,
      productsInterestedIn: productsInterestedIn ?? this.productsInterestedIn,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      notes: notes ?? this.notes,
      externalThreadId: externalThreadId ?? this.externalThreadId,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      aiExtracted: aiExtracted ?? this.aiExtracted,
    );
  }

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now().toUtc();
    if (v is DateTime) return v.toUtc();
    final s = v.toString();
    return DateTime.tryParse(s)?.toUtc() ?? DateTime.now().toUtc();
  }

  factory Lead.fromDitto(Map<String, dynamic> doc) {
    final id = (doc['_id'] ?? doc['id']).toString();
    return Lead(
      id: id,
      branchId: (doc['branchId'] ?? '').toString(),
      businessId: doc['businessId']?.toString(),
      createdAt: _parseDate(doc['createdAt']),
      updatedAt: _parseDate(doc['updatedAt']),
      lastTouched: doc['lastTouched'] == null ? null : _parseDate(doc['lastTouched']),
      fullName: (doc['fullName'] ?? '').toString(),
      phoneNumber: doc['phoneNumber']?.toString(),
      emailAddress: doc['emailAddress']?.toString(),
      source: (doc['source'] ?? LeadSource.walkIn).toString(),
      status: (doc['status'] ?? LeadStatus.newLead).toString(),
      heat: (doc['heat'] ?? LeadHeat.warm).toString(),
      productsInterestedIn: doc['productsInterestedIn']?.toString(),
      estimatedValue: doc['estimatedValue'] as num?,
      notes: doc['notes']?.toString(),
      externalThreadId: doc['externalThreadId']?.toString(),
      aiConfidence: doc['aiConfidence'] as num?,
      aiExtracted: (doc['aiExtracted'] is Map)
          ? Map<String, dynamic>.from(doc['aiExtracted'] as Map)
          : null,
    );
  }

  Map<String, dynamic> toDitto() {
    return <String, dynamic>{
      '_id': id,
      'branchId': branchId,
      'businessId': businessId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
      'lastTouched': (lastTouched ?? updatedAt).toUtc().toIso8601String(),
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'source': source,
      'status': status,
      'heat': heat,
      'productsInterestedIn': productsInterestedIn,
      'estimatedValue': estimatedValue,
      'notes': notes,
      'externalThreadId': externalThreadId,
      'aiConfidence': aiConfidence,
      'aiExtracted': aiExtracted,
    };
  }
}

