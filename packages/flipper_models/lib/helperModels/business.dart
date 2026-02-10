library flipper_models;

import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_services/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';

part 'business.g.dart';

/// A business object. which in some case act as contact
/// in flipper we believe that to talk to business should be as easy as walk to the business to shop
/// the conversation should be open and easy to track
/// we give the business and customers the best way to keep this convesation open and convenient
/// with that being said to talk to a business you do not need their phone number etc...
/// you just need a name and maybe also be in same area(location)
/// it is in this regards business is a contact
/// again becase a business if found in a mix of being a business
/// and a contact at the same time i.e. a person then it make sense to add bellow fields too!
/// All possible roles user can have.

@JsonSerializable()
class IBusiness extends IJsonSerializable {
  IBusiness({
    required this.id,
    this.serverId,
    this.name,
    this.currency,
    this.categoryId,
    this.latitude,
    this.longitude,
    required this.userId,
    this.timeZone,
    this.channels,
    this.country,
    this.businessUrl,
    this.hexColor,
    this.imageUrl,
    this.type,
    this.referredBy,
    this.createdAt,
    this.updatedAt,
    this.metadata,
    this.role,
    this.lastSeen,
    this.firstName,
    this.lastName,
    this.reported,
    this.phoneNumber,
    this.deviceToken,
    this.chatUid,
    this.backUpEnabled,
    this.subscriptionPlan,
    this.nextBillingDate,
    this.previousBillingDate,
    this.isLastSubscriptionPaymentSucceeded,
    this.backupFileId,
    this.email,
    this.lastDbBackup,
    this.fullName,
    this.referralCode,
    this.authId,
    this.tinNumber,
    this.dvcSrlNo,
    this.bhfId,
    this.adrs,
    this.taxEnabled,
    this.isDefault,
    this.businessTypeId,
    this.encryptionKey,
    this.businessDefault,
    this.lastSubscriptionPaymentSucceeded,
    this.validCurrency,
    this.branches,
    this.isOwner,
  });

  IBusiness.copy(
    IBusiness original, {
    bool? active,
    String? encryptionKey,
    String? name,
  }) : id = original.id,
       serverId = original.serverId,
       name = name ?? original.name,
       encryptionKey = encryptionKey ?? original.encryptionKey,
       backUpEnabled = original.backUpEnabled,
       businessDefault = original.businessDefault,
       businessTypeId = original.businessTypeId,
       country = original.country,
       createdAt = original.createdAt,
       currency = original.currency,
       fullName = original.fullName,
       isDefault = original.isDefault,
       isLastSubscriptionPaymentSucceeded =
           original.isLastSubscriptionPaymentSucceeded,
       lastSeen = original.lastSeen,
       lastSubscriptionPaymentSucceeded =
           original.lastSubscriptionPaymentSucceeded,
       latitude = original.latitude,
       longitude = original.longitude,
       phoneNumber = original.phoneNumber,
       referredBy = original.referredBy,
       taxEnabled = original.taxEnabled,
       tinNumber = original.tinNumber,
       type = original.type,
       branches = original.branches,
       isOwner = original.isOwner,
       userId = original.userId,
       validCurrency = original.validCurrency;
  String id;
  int? serverId;
  String? name;
  String? currency;
  dynamic categoryId;
  num? latitude;
  num? longitude;
  dynamic userId;
  dynamic timeZone;
  dynamic channels;
  String? country;
  dynamic businessUrl;
  dynamic hexColor;
  dynamic imageUrl;
  String? type;
  String? referredBy;
  DateTime? createdAt;
  dynamic updatedAt;
  dynamic metadata;
  dynamic role;
  int? lastSeen;
  dynamic firstName;
  dynamic lastName;
  dynamic reported;
  String? phoneNumber;
  dynamic deviceToken;
  dynamic chatUid;
  bool? backUpEnabled;
  dynamic subscriptionPlan;
  dynamic nextBillingDate;
  dynamic previousBillingDate;
  bool? isLastSubscriptionPaymentSucceeded;
  dynamic backupFileId;
  dynamic email;
  dynamic lastDbBackup;
  String? fullName;
  dynamic referralCode;
  dynamic authId;
  int? tinNumber;
  dynamic dvcSrlNo;
  dynamic bhfId;
  dynamic adrs;
  bool? taxEnabled;
  bool? isDefault;
  String? businessTypeId;
  String? encryptionKey;
  bool? businessDefault;
  bool? lastSubscriptionPaymentSucceeded;
  bool? validCurrency;
  List<IBranch>? branches;
  bool? isOwner;

  factory IBusiness.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.created;

    // Handle snake_case vs camelCase
    if (json.containsKey('user_id') && !json.containsKey('userId')) {
      json['userId'] = json['user_id'];
    }
    if (json.containsKey('is_owner') && !json.containsKey('isOwner')) {
      json['isOwner'] = json['is_owner'];
    }

    // Ensure lastTouched is an ISO-8601 string, setting it if null or empty
    json['lastTouched'] ??=
        (json['lastTouched'] == null || json['lastTouched'].toString().isEmpty)
        ? DateTime.now().toIso8601String()
        : json['lastTouched'];

    if (json['userId'] is String) {
      json['userId'] = int.tryParse(json['userId']) ?? json['userId'];
    }

    // Handle numeric fields that might come as strings from API
    if (json['latitude'] is String) {
      json['latitude'] = num.tryParse(json['latitude']);
    }
    if (json['longitude'] is String) {
      json['longitude'] = num.tryParse(json['longitude']);
    }
    if (json['serverId'] is String) {
      json['serverId'] = int.tryParse(json['serverId']);
    }
    if (json['lastSeen'] is String) {
      json['lastSeen'] = int.tryParse(json['lastSeen']);
    }
    if (json['tinNumber'] is String) {
      json['tinNumber'] = int.tryParse(json['tinNumber']);
    }

    return _$IBusinessFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$IBusinessToJson(this);
}
