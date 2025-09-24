import 'dart:convert';

class UserProfile {
  final String id;
  final String phoneNumber;
  final String token;
  final List<Tenant> tenants;
  final List<String> channels;
  final bool editId;
  final bool isExternal;
  final String ownership;
  final int? groupId;
  final int? pin; // Changed to nullable
  final bool external;

  UserProfile({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.tenants,
    required this.channels,
    required this.editId,
    required this.isExternal,
    required this.ownership,
    required this.groupId,
    required this.pin,
    required this.external,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserProfile(
      id: id ?? json['id'],
      phoneNumber: json['phoneNumber'],
      token: json['token'],
      tenants: (json['tenants'] as List)
          .map((e) => Tenant.fromJson(e))
          .toList(),
      channels: List<String>.from(json['channels']),
      editId: json['editId'],
      isExternal: json['isExternal'],
      ownership: json['ownership'],
      groupId: json['groupId'],
      pin: json['pin'], // Now accepts null
      external: json['external'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'token': token,
      'tenants': tenants.map((t) => t.toJson()).toList(),
      'channels': channels,
      'editId': editId,
      'isExternal': isExternal,
      'ownership': ownership,
      'groupId': groupId,
      'pin': pin,
      'external': external,
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
  final int businessId;
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
    required this.businessId,
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
      branches: (json['branches'] as List)
          .map((e) => Branch.fromJson(e))
          .toList(),
      businesses: (json['businesses'] as List)
          .map((e) => Business.fromJson(e))
          .toList(),
      businessId: json['businessId'],
      nfcEnabled: json['nfcEnabled'],
      userId: json['userId'],
      pin: json['pin'],
      isDefault: json['is_default'],
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
  final int businessId;
  final int serverId;

  Branch({
    required this.id,
    required this.description,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.businessId,
    required this.serverId,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      businessId: json['businessId'],
      serverId: json['serverId'],
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
    return Business(
      id: json['id'],
      name: json['name'],
      country: json['country'],
      currency: json['currency'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      active: json['active'],
      userId: json['userId'],
      phoneNumber: json['phoneNumber'],
      lastSeen: json['lastSeen'],
      backUpEnabled: json['backUpEnabled'],
      fullName: json['fullName'],
      tinNumber: json['tinNumber'],
      taxEnabled: json['taxEnabled'],
      businessTypeId: json['businessTypeId'],
      serverId: json['serverId'],
      isDefault: json['is_default'],
      lastSubscriptionPaymentSucceeded:
          json['lastSubscriptionPaymentSucceeded'],
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
