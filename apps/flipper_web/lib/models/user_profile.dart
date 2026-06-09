import 'dart:convert';

class UserProfile {
  final String id;
  final String phoneNumber;
  final String token;
  final List<Tenant> tenants;
  final int? pin;

  UserProfile({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.tenants,
    this.pin,
  });

  /// True when at least one tenant has a business to select.
  bool get hasBusinesses =>
      tenants.any((tenant) => tenant.businesses.isNotEmpty);

  factory UserProfile.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserProfile(
      id: id ?? json['id'].toString(),
      phoneNumber: json['phoneNumber'],
      token: json['token'],
      tenants: (json['tenants'] as List)
          .map((e) => Tenant.fromJson(e))
          .toList(),
      pin: json['pin'],
    );
  }

  /// Parses POST `/v2/api/user` (flipper-turbo `get_user_with_nested_data`).
  /// The API returns top-level `businesses` with snake_case keys, not `tenants`.
  factory UserProfile.fromApiResponse(
    Map<String, dynamic> json, {
    String? sessionUserId,
  }) {
    if (json['tenants'] is List) {
      return UserProfile.fromJson(json, id: sessionUserId);
    }

    final id = (json['id'] ?? sessionUserId).toString();
    final phoneNumber =
        (json['phone_number'] ?? json['phoneNumber'] ?? '').toString();
    final pin = json['pin'] is int
        ? json['pin'] as int
        : int.tryParse('${json['pin']}');
    final token = (json['token'] ?? '').toString();

    final businessesRaw = json['businesses'] as List? ?? [];
    final businesses = <Business>[];
    final branches = <Branch>[];

    for (final entry in businessesRaw) {
      final map = Map<String, dynamic>.from(entry as Map);
      final businessId = map['id'].toString();
      businesses.add(
        Business.fromApiJson(map, fallbackPhone: phoneNumber),
      );
      final branchesRaw = map['branches'] as List? ?? [];
      for (final branchEntry in branchesRaw) {
        branches.add(
          Branch.fromApiJson(
            Map<String, dynamic>.from(branchEntry as Map),
            businessId: businessId,
          ),
        );
      }
    }

    final tenants = businesses.isEmpty
        ? <Tenant>[]
        : [
            Tenant(
              id: id,
              name: businesses.first.name,
              phoneNumber: phoneNumber,
              email: '',
              imageUrl: '',
              permissions: const [],
              branches: branches,
              businesses: businesses,
              nfcEnabled: false,
              userId: int.tryParse(id) ?? pin ?? 0,
              pin: pin ?? int.tryParse(id) ?? 0,
              isDefault: true,
              type: (json['ownership'] ?? 'User').toString(),
            ),
          ];

    return UserProfile(
      id: id,
      phoneNumber: phoneNumber,
      token: token,
      tenants: tenants,
      pin: pin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'token': token,
      'tenants': tenants.map((t) => t.toJson()).toList(),
      'pin': pin,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Tenant {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String imageUrl;
  final List<dynamic> permissions;
  final List<Branch> branches;
  final List<Business> businesses;
  final String? businessId;
  final bool nfcEnabled;
  final int userId;
  final int pin;
  final bool isDefault;
  final String type;

  Tenant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.imageUrl,
    required this.permissions,
    required this.branches,
    required this.businesses,
    this.businessId,
    required this.nfcEnabled,
    required this.userId,
    required this.pin,
    required this.isDefault,
    required this.type,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'] ?? 'null',
      imageUrl: json['imageUrl'] ?? 'null',
      permissions: json['permissions'] ?? [],
      branches: (json['branches'] as List? ?? [])
          .map((e) => Branch.fromJson(e))
          .toList(),
      businesses: (json['businesses'] as List? ?? [])
          .map((e) => Business.fromJson(e))
          .toList(),
      businessId: json['businessId'] as String?,
      nfcEnabled: json['nfcEnabled'] ?? false,
      userId: json['userId'] as int,
      pin: json['pin'] as int,
      isDefault: json['is_default'] ?? false,
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'imageUrl': imageUrl,
      'permissions': permissions,
      'branches': branches.map((b) => b.toJson()).toList(),
      'businesses': businesses.map((b) => b.toJson()).toList(),
      'businessId': businessId,
      'nfcEnabled': nfcEnabled,
      'userId': userId,
      'pin': pin,
      'is_default': isDefault,
      'type': type,
    };
  }
}

class Branch {
  final String id;
  final String description;
  final String name;
  final String longitude;
  final String latitude;
  final String businessId;
  final int serverId;
  final bool active;
  final bool isDefault;

  Branch({
    required this.id,
    required this.description,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.businessId,
    required this.serverId,
    this.active = true,
    this.isDefault = false,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch.fromApiJson(json);
  }

  factory Branch.fromApiJson(
    Map<String, dynamic> json, {
    String? businessId,
  }) {
    return Branch(
      id: json['id'].toString(),
      description: json['description']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      longitude: _asString(json['longitude']),
      latitude: _asString(json['latitude']),
      businessId:
          businessId ??
          json['business_id']?.toString() ??
          json['businessId']?.toString() ??
          '',
      serverId: _asInt(json['server_id'] ?? json['serverId']),
      active: json['active'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'businessId': businessId,
      'serverId': serverId,
      'active': active,
      'is_default': isDefault,
    };
  }
}

class Business {
  final String id;
  final String name;
  final String country;
  final String currency;
  final String latitude;
  final String longitude;
  final bool active;
  final String userId;
  final String phoneNumber;
  final int lastSeen;
  final bool backUpEnabled;
  final String fullName;
  final int tinNumber;
  final bool taxEnabled;
  final int businessTypeId;
  final int serverId;
  final bool isDefault;
  final bool lastSubscriptionPaymentSucceeded;

  Business({
    required this.id,
    required this.name,
    required this.country,
    required this.currency,
    required this.latitude,
    required this.longitude,
    required this.active,
    required this.userId,
    required this.phoneNumber,
    required this.lastSeen,
    required this.backUpEnabled,
    required this.fullName,
    required this.tinNumber,
    required this.taxEnabled,
    required this.businessTypeId,
    required this.serverId,
    required this.isDefault,
    required this.lastSubscriptionPaymentSucceeded,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business.fromApiJson(json);
  }

  factory Business.fromApiJson(
    Map<String, dynamic> json, {
    String? fallbackPhone,
  }) {
    return Business(
      id: json['id'].toString(),
      name: json['name']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      currency: json['currency']?.toString() ?? '',
      latitude: _asString(json['latitude']),
      longitude: _asString(json['longitude']),
      active: json['active'] as bool? ?? true,
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      phoneNumber:
          json['phoneNumber']?.toString() ?? fallbackPhone ?? '',
      lastSeen: _asInt(json['lastSeen']),
      backUpEnabled: json['backUpEnabled'] as bool? ?? false,
      fullName: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      tinNumber: _asInt(json['tinNumber']),
      taxEnabled: json['taxEnabled'] as bool? ?? false,
      businessTypeId: _asInt(json['businessTypeId']),
      serverId: _asInt(json['server_id'] ?? json['serverId']),
      isDefault: json['is_default'] as bool? ?? false,
      lastSubscriptionPaymentSucceeded:
          json['lastSubscriptionPaymentSucceeded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'currency': currency,
      'latitude': latitude,
      'longitude': longitude,
      'active': active,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'lastSeen': lastSeen,
      'backUpEnabled': backUpEnabled,
      'fullName': fullName,
      'tinNumber': tinNumber,
      'taxEnabled': taxEnabled,
      'businessTypeId': businessTypeId,
      'serverId': serverId,
      'is_default': isDefault,
      'lastSubscriptionPaymentSucceeded': lastSubscriptionPaymentSucceeded,
    };
  }
}

String _asString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
