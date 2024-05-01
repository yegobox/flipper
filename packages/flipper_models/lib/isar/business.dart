library flipper_models;

import 'package:flipper_services/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:pocketbase/pocketbase.dart';
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
@Collection()
class IBusiness extends IJsonSerializable {
  IBusiness({
    required this.id,
    required this.action,
    required this.encryptionKey,
    this.name,
    this.currency,
    this.categoryId = "1",
    this.latitude,
    this.longitude,
    this.userId,
    this.timeZone,
    this.channels,
    this.country,
    this.businessUrl,
    this.hexColor,
    this.imageUrl,
    this.type,
    this.active = false,
    this.metadata,
    this.lastSeen,
    this.firstName,
    this.lastName,
    this.deviceToken,
    this.chatUid,
    this.backUpEnabled = false,
    this.subscriptionPlan,
    this.nextBillingDate,
    this.previousBillingDate,
    this.isLastSubscriptionPaymentSucceeded,
    this.backupFileId,
    this.email,
    this.lastDbBackup,
    this.fullName,
    this.role,
    this.tinNumber,
    this.bhfId,
    this.dvcSrlNo,
    this.adrs,
    this.taxEnabled,
    this.taxServerUrl,
    this.isDefault,
    this.businessTypeId,
    this.deletedAt,
  });

  IBusiness.copy(IBusiness original,
      {bool? active, String? action, String? encryptionKey, String? name})
      : id = original.id,
        name = name ?? original.name,
        action = action ?? original.action,
        encryptionKey = encryptionKey ?? original.encryptionKey,
        active = active ?? original.active;
  Id? id;
  String? name;
  String? currency;
  String? categoryId;
  String? latitude;
  String? longitude;
  @Index()
  int? userId;
  String? timeZone;
  List<String>? channels;
  String? country;
  String? businessUrl;
  String? hexColor;
  String? imageUrl;
  String? type;
  bool? active;
  String? chatUid;
  String? metadata;
  String? role;
  int? lastSeen;
  String? firstName;
  String? lastName;
  String? createdAt;
  String? deviceToken;
  bool? backUpEnabled;
  String? subscriptionPlan;
  String? nextBillingDate;
  String? previousBillingDate;
  bool? isLastSubscriptionPaymentSucceeded;
  String? backupFileId;
  String? email;
  String? lastDbBackup;
  String? fullName;
  int? tinNumber;
  String? bhfId;
  String? dvcSrlNo;
  // address
  String? adrs;
  bool? taxEnabled;
  String? taxServerUrl;
  bool? isDefault;
  int? businessTypeId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  @Index()
  DateTime? deletedAt;

  String encryptionKey;

  factory IBusiness.fromRecord(RecordModel record) =>
      IBusiness.fromJson(record.toJson());

  factory IBusiness.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local
    json['lastTouched'] ??= json['lastTouched'].toString().isEmpty
        ? DateTime.now()
        : json['lastTouched'];
    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.created;
    if (json['userId'] is String) {
      json['userId'] = int.tryParse(json['userId']) ?? json['userId'];
    }

    return _$BusinessFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$BusinessToJson(this);
}
