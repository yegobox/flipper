/// Local + remote shape for a Services hub provider profile.
class ServiceGigProvider {
  final String userId;
  final String? businessId;
  final String? branchId;
  final String displayName;
  final String bio;
  final List<String> services;
  final String? serviceArea;
  final String? phone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ServiceGigProvider({
    required this.userId,
    this.businessId,
    this.branchId,
    required this.displayName,
    required this.bio,
    required this.services,
    this.serviceArea,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'business_id': businessId,
        'branch_id': branchId,
        'display_name': displayName,
        'bio': bio,
        'services': services,
        'service_area': serviceArea,
        'phone': phone,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      };

  factory ServiceGigProvider.fromJson(Map<String, dynamic> json) {
    List<String> parseServices(dynamic v) {
      if (v == null) return [];
      if (v is List) {
        return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
      }
      return [];
    }

    DateTime? parseTs(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      return DateTime.tryParse(v.toString());
    }

    return ServiceGigProvider(
      userId: json['user_id']?.toString() ?? '',
      businessId: json['business_id']?.toString(),
      branchId: json['branch_id']?.toString(),
      displayName: json['display_name']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      services: parseServices(json['services']),
      serviceArea: json['service_area']?.toString(),
      phone: json['phone']?.toString(),
      createdAt: parseTs(json['created_at']),
      updatedAt: parseTs(json['updated_at']),
    );
  }

  ServiceGigProvider copyWith({
    String? displayName,
    String? bio,
    List<String>? services,
    String? serviceArea,
    String? phone,
    DateTime? updatedAt,
  }) {
    return ServiceGigProvider(
      userId: userId,
      businessId: businessId,
      branchId: branchId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      services: services ?? this.services,
      serviceArea: serviceArea ?? this.serviceArea,
      phone: phone ?? this.phone,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
