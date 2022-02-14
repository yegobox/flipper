library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';

part 'business.g.dart';

BusinessSync businessFromJson(String str) =>
    BusinessSync.fromJson(json.decode(str));
String sbusinessToJson(BusinessSync data) => json.encode(data.toJson());

List<BusinessSync> businessesFromJson(String str) => List<BusinessSync>.from(
    json.decode(str).map((x) => BusinessSync.fromJson(x)));

String businessToJson(List<BusinessSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
      {this.id = 0,
      required this.name,
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
  late String name;
  late String? currency;
  late int? fcategoryId;
  late String latitude;
  late String longitude;
  late String? userId;
  late String? typeId;
  late String? timeZone;

  List<String>? channels;
  late String? table;
  late String country;
  late String? businessUrl;
  late String? hexColor;
  late String? imageUrl;
  late String type;
  late bool? active;
  late String? chatUid;

  //@Transient() //even though this is needed for chat purpose, the objectbox db does not allow this type of data type
  /// Additional custom metadata or attributes related to the user
  /// Map<String, dynamic>? metadata;
  /// as objectbox does not allow Map it will be required to convert the string to map before and after saving
  late String? metadata;

  /// User [Role]
  // Role? role;
  /// as objectbox does not allow enum type it will be required to convert the string to enum before and after saving
  late String? role;

  /// Timestamp when user was last visible, in ms
  late int? lastSeen;

  /// First name of the user
  late String? firstName;

  /// Remote image URL representing user's avatar
  // String? imageUrl;
  /// Last name of the user
  late String? lastName;
  late String? createdAt;
  late String? deviceToken;
  late bool? backUpEnabled;
  late String? subscriptionPlan;
  late String? nextBillingDate;
  late String? previousBillingDate;
  late bool? isLastSubscriptionPaymentSucceeded;
  late String? backupFileId;
  late String? email;
  late String? lastDbBackup;
  late String? fullName;
  BusinessSync.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        subscriptionPlan = json["subscriptionPlan"],
        nextBillingDate = json["nextBillingDate"],
        previousBillingDate = json["previousBillingDate"],
        isLastSubscriptionPaymentSucceeded =
            json["isLastSubscriptionPaymentSucceeded"],
        backupFileId = json["backupFileId"],
        email = json["email"],
        lastDbBackup = json["lastDbBackup"],
        fullName = json["fullName"],
        chatUid = json["chatUid"],
        deviceToken = json["deviceToken"],
        currency = json["currency"],
        backUpEnabled = json["backUpEnabled"],
        // TODOwhen loading the fcategoryId it seems somehow fcategoryId is a string and we are expecting an int or maybe there is null returned!
        // fcategoryId = json["fcategoryId"],
        latitude = json["latitude"] ?? '1',
        longitude = json["longitude"] ?? '1',
        userId = json["userId"].toString(),
        typeId = json["typeId"],
        timeZone = json["timeZone"],
        table = json["table"],
        country = json["country"],
        businessUrl = json["businessUrl"],
        hexColor = json["hexColor"],
        imageUrl = json["imageUrl"],
        type = json["type"],
        metadata = json["metadata"],
        role = json["role"],
        lastName = json["name"],
        firstName = json["name"],
        lastSeen = json["lastSeen"],
        active = json["active"];

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "deviceToken": deviceToken,
        "backUpEnabled": backUpEnabled,
        "subscriptionPlan": subscriptionPlan,
        "nextBillingDate": nextBillingDate,
        "previousBillingDate": previousBillingDate,
        "isLastSubscriptionPaymentSucceeded":
            isLastSubscriptionPaymentSucceeded,
        "backupFileId": backupFileId,
        "email": email,
        "lastDbBackup": lastDbBackup,
        "fullName": fullName,
        "currency": currency,
        "chatUid": chatUid,
        "fcategoryId": fcategoryId.toString(),
        "latitude": latitude,
        "longitude": longitude,
        "userId": userId.toString(),
        "typeId": typeId,
        "timeZone": timeZone,
        "metadata": metadata,
        "lastName": name,
        "firstName": name,
        "imageUrl": imageUrl,
        "role": role,
        "lastSeen": lastSeen,
        "table": table,
        "country": country,
        "businessUrl": businessUrl,
        "hexColor": hexColor,
        "type": type,
        "active": active,
      };
}
