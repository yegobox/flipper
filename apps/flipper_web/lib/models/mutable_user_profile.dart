import 'package:flipper_web/models/user_profile.dart';

/// A mutable version of the UserProfile model
/// This class allows modifying fields that are final in the original model
class MutableUserProfile {
  final String id;
  final String phoneNumber;
  final String token;
  final List<MutableTenant> tenants;
  final List<String> channels;
  final bool editId;
  final bool isExternal;
  final String ownership;
  final int groupId;
  final int pin;
  final bool external;

  MutableUserProfile({
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

  /// Create a mutable user profile from an immutable one
  factory MutableUserProfile.fromUserProfile(UserProfile profile) {
    return MutableUserProfile(
      id: profile.id,
      phoneNumber: profile.phoneNumber,
      token: profile.token,
      tenants: profile.tenants.map((e) => MutableTenant.fromTenant(e)).toList(),
      channels: List<String>.from(profile.channels),
      editId: profile.editId,
      isExternal: profile.isExternal,
      ownership: profile.ownership,
      groupId: profile.groupId,
      pin: profile.pin,
      external: profile.external,
    );
  }

  /// Convert back to an immutable UserProfile
  UserProfile toUserProfile() {
    return UserProfile(
      id: id,
      phoneNumber: phoneNumber,
      token: token,
      tenants: tenants.map((t) => t.toTenant()).toList(),
      channels: channels,
      editId: editId,
      isExternal: isExternal,
      ownership: ownership,
      groupId: groupId,
      pin: pin,
      external: external,
    );
  }

  /// Select a business as the default/active one
  void selectDefaultBusiness(String tenantId, String businessId) {
    final tenant = tenants.firstWhere((t) => t.id == tenantId);
    for (var business in tenant.businesses) {
      business.isDefault = business.id == businessId;
      business.active = business.id == businessId;
    }
  }

  /// Select a branch as the default/active one
  void selectDefaultBranch(String tenantId, String branchId) {
    final tenant = tenants.firstWhere((t) => t.id == tenantId);
    for (var branch in tenant.branches) {
      branch.isDefault = branch.id == branchId;
      branch.active = branch.id == branchId;
    }
  }

  /// Check if the profile has a default business and branch selected
  bool hasDefaultBusinessAndBranch() {
    for (var tenant in tenants) {
      bool hasDefaultBusiness = tenant.businesses.any((b) => b.isDefault);
      bool hasDefaultBranch = tenant.branches.any((b) => b.isDefault);
      if (hasDefaultBusiness && hasDefaultBranch) {
        return true;
      }
    }
    return false;
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
}

class MutableTenant {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String imageUrl;
  final List<dynamic> permissions;
  final List<MutableBranch> branches;
  final List<MutableBusiness> businesses;
  final int businessId;
  final bool nfcEnabled;
  final int userId;
  final int pin;
  bool isDefault; // Made mutable
  final String type;

  MutableTenant({
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

  factory MutableTenant.fromTenant(Tenant tenant) {
    return MutableTenant(
      id: tenant.id,
      name: tenant.name,
      phoneNumber: tenant.phoneNumber,
      email: tenant.email,
      imageUrl: tenant.imageUrl,
      permissions: tenant.permissions,
      branches: tenant.branches
          .map((e) => MutableBranch.fromBranch(e))
          .toList(),
      businesses: tenant.businesses
          .map((e) => MutableBusiness.fromBusiness(e))
          .toList(),
      businessId: tenant.businessId,
      nfcEnabled: tenant.nfcEnabled,
      userId: tenant.userId,
      pin: tenant.pin,
      isDefault: tenant.isDefault,
      type: tenant.type,
    );
  }

  Tenant toTenant() {
    return Tenant(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      imageUrl: imageUrl,
      permissions: permissions,
      branches: branches.map((b) => b.toBranch()).toList(),
      businesses: businesses.map((b) => b.toBusiness()).toList(),
      businessId: businessId,
      nfcEnabled: nfcEnabled,
      userId: userId,
      pin: pin,
      isDefault: isDefault,
      type: type,
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

class MutableBranch {
  final String id;
  final String description;
  final String name;
  final String longitude;
  final String latitude;
  final int businessId;
  final int serverId;
  bool active; // Added mutable field
  bool isDefault; // Added mutable field

  MutableBranch({
    required this.id,
    required this.description,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.businessId,
    required this.serverId,
    this.active = false,
    this.isDefault = false,
  });

  factory MutableBranch.fromBranch(Branch branch) {
    return MutableBranch(
      id: branch.id,
      description: branch.description,
      name: branch.name,
      longitude: branch.longitude,
      latitude: branch.latitude,
      businessId: branch.businessId,
      serverId: branch.serverId,
    );
  }

  Branch toBranch() {
    return Branch(
      id: id,
      description: description,
      name: name,
      longitude: longitude,
      latitude: latitude,
      businessId: businessId,
      serverId: serverId,
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

class MutableBusiness {
  final String id;
  final String name;
  final String country;
  final String currency;
  final String latitude;
  final String longitude;
  bool active; // Made mutable
  final String userId;
  final String phoneNumber;
  final int lastSeen;
  final bool backUpEnabled;
  final String fullName;
  final int tinNumber;
  final bool taxEnabled;
  final int businessTypeId;
  final int serverId;
  bool isDefault; // Made mutable
  final bool lastSubscriptionPaymentSucceeded;

  MutableBusiness({
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

  factory MutableBusiness.fromBusiness(Business business) {
    return MutableBusiness(
      id: business.id,
      name: business.name,
      country: business.country,
      currency: business.currency,
      latitude: business.latitude,
      longitude: business.longitude,
      active: business.active,
      userId: business.userId,
      phoneNumber: business.phoneNumber,
      lastSeen: business.lastSeen,
      backUpEnabled: business.backUpEnabled,
      fullName: business.fullName,
      tinNumber: business.tinNumber,
      taxEnabled: business.taxEnabled,
      businessTypeId: business.businessTypeId,
      serverId: business.serverId,
      isDefault: business.isDefault,
      lastSubscriptionPaymentSucceeded:
          business.lastSubscriptionPaymentSucceeded,
    );
  }

  Business toBusiness() {
    return Business(
      id: id,
      name: name,
      country: country,
      currency: currency,
      latitude: latitude,
      longitude: longitude,
      active: active,
      userId: userId,
      phoneNumber: phoneNumber,
      lastSeen: lastSeen,
      backUpEnabled: backUpEnabled,
      fullName: fullName,
      tinNumber: tinNumber,
      taxEnabled: taxEnabled,
      businessTypeId: businessTypeId,
      serverId: serverId,
      isDefault: isDefault,
      lastSubscriptionPaymentSucceeded: lastSubscriptionPaymentSucceeded,
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
