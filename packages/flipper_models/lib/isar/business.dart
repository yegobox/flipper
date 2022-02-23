library flipper_models;

import 'package:isar/isar.dart';

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

@Collection()
class BusinessSync {
  BusinessSync(
      {required this.name,
      this.currency,
      this.fcategoryId = 1,
      required this.latitude,
      required this.longitude,
      this.userId,
      this.typeId,
      this.timeZone,
      this.channels,
      this.table = "businesses",
      required this.country,
      this.businessUrl,
      this.hexColor,
      this.imageUrl,
      required this.type,
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
      this.role});
  late int id = Isar.autoIncrement;
  String name;
  String? currency;
  int? fcategoryId;
  String latitude;
  String longitude;
  String? userId;
  String? typeId;
  String? timeZone;

  List<String>? channels;
  String? table;
  String country;
  String? businessUrl;
  String? hexColor;
  String? imageUrl;
  String type;
  bool? active;
  String? chatUid;

  //@Transient() //even though this is needed for chat purpose, the objectbox db does not allow this type of data type
  /// Additional custom metadata or attributes red to the user
  /// Map<String, dynamic>? metadata;
  /// as objectbox does not allow Map it will be required to convert the string to map before and after saving
  String? metadata;

  /// User [Role]
  // Role? role;
  /// as objectbox does not allow enum type it will be required to convert the string to enum before and after saving
  String? role;

  /// Timestamp when user was last visible, in ms
  int? lastSeen;

  /// First name of the user
  String? firstName;

  /// Remote image URL representing user's avatar
  // String? imageUrl;
  /// Last name of the user
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
}
