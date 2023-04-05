library flipper_models;

import 'dart:convert';

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
Business fromJson(String str) => Business.fromJson(json.decode(str));
String toJson(Business data) => json.encode(data.toJson());
List<Business> listFromJson(String str) =>
    List<Business>.from(json.decode(str).map((x) => Business.fromJson(x)));

@Collection()
class Business {
  Business(
      {this.name,
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
      this.id,
      this.businessTypeId});
  Id? id = Isar.autoIncrement;
  String? name;
  String? currency;
  String? categoryId;
  String? latitude;
  String? longitude;
  @Index()
  String? userId;
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
        "categoryId": categoryId.toString(),
        "latitude": latitude,
        "longitude": longitude,
        "userId": userId.toString(),
        "timeZone": timeZone,
        "metadata": metadata,
        "lastName": name,
        "firstName": name,
        "imageUrl": imageUrl,
        "role": role,
        "lastSeen": lastSeen,
        "country": country,
        "businessUrl": businessUrl,
        "hexColor": hexColor,
        "type": type,
        "active": active,
        "tinNumber": tinNumber,
        "bhfId": bhfId,
        "dvcSrlNo": dvcSrlNo,
        "adrs": adrs,
        "taxEnabled": taxEnabled,
        "taxServerUrl": taxServerUrl,
        "isDefault": isDefault,
        "businessTypeId": businessTypeId,
      };
  Business.fromJson(Map<dynamic, dynamic> json)
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
        latitude = json["latitude"] ?? '1',
        longitude = json["longitude"] ?? '1',
        userId = json["userId"],
        timeZone = json["timeZone"],
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
        active = json["active"],
        tinNumber = json["tinNumber"],
        bhfId = json["bhfId"],
        dvcSrlNo = json["dvcSrlNo"],
        adrs = json["adrs"],
        taxEnabled = json["taxEnabled"],
        taxServerUrl = json["taxServerUrl"],
        businessTypeId = json["businessTypeId"],
        isDefault = json["isDefault"];
}
