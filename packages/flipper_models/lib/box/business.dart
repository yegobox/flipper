// // To parse this JSON data, do
// //
// //     final business = businessFromJson(jsonString);
// library flipper_models;

// import 'dart:convert';

// import 'package:objectbox/objectbox.dart';

// Business sbusinessFromJson(String str) => Business.fromJson(json.decode(str));
// String sbusinessToJson(Business data) => json.encode(data.toJson());

// List<Business> businessFromJson(String str) =>
//     List<Business>.from(json.decode(str).map((x) => Business.fromJson(x)));

// String businessToJson(List<Business> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// /// A business object. which in some case act as contact
// /// in flipper we believe that to talk to business should be as easy as walk to the business to shop
// /// the conversation should be open and easy to track
// /// we give the business and customers the best way to keep this convesation open and convenient
// /// with that being said to talk to a business you do not need their phone number etc...
// /// you just need a name and maybe also be in same area(location)
// /// it is in this regards business is a contact
// /// again becase a business if found in a mix of being a business
// /// and a contact at the same time i.e. a person then it make sense to add bellow fields too!
// /// All possible roles user can have.
// enum Role { admin, agent, moderator, user }

// @Entity()
// @Sync()
// class Business {
//   Business(
//       {required this.id,
//       required this.name,
//       this.currency,
//       this.fcategoryId = 1,
//       required this.latitude,
//       required this.longitude,
//       this.userId,
//       this.typeId,
//       this.timeZone,
//       this.channels,
//       this.table = "businesses",
//       required this.country,
//       this.businessUrl,
//       this.hexColor,
//       this.imageUrl,
//       required this.type,
//       this.active = false,
//       this.metadata,
//       this.lastSeen,
//       this.firstName,
//       this.lastName,
//       this.deviceToken,
//       this.chatUid,
//       this.backUpEnabled = false,
//       this.subscriptionPlan,
//       this.nextBillingDate,
//       this.previousBillingDate,
//       this.isLastSubscriptionPaymentSucceeded,
//       this.backupFileId,
//       this.email,
//       this.lastDbBackup,
//       this.fullName,
//       this.role});

//   late String id;
//   String name;
//   String? currency;
//   int? fcategoryId;
//   String latitude;
//   String longitude;
//   String? userId;
//   String? typeId;
//   String? timeZone;

//   @Transient()
//   List<String>? channels;
//   String? table;
//   String country;
//   String? businessUrl;
//   String? hexColor;
//   String? imageUrl;
//   String type;
//   bool? active;
//   String? chatUid;

//   //@Transient() //even though this is needed for chat purpose, the objectbox db does not allow this type of data type
//   /// Additional custom metadata or attributes related to the user
//   /// Map<String, dynamic>? metadata;
//   /// as objectbox does not allow Map it will be required to convert the string to map before and after saving
//   String? metadata;

//   /// User [Role]
//   // Role? role;
//   /// as objectbox does not allow enum type it will be required to convert the string to enum before and after saving
//   String? role;

//   /// Timestamp when user was last visible, in ms
//   int? lastSeen;

//   /// First name of the user
//   String? firstName;

//   /// Remote image URL representing user's avatar
//   // String? imageUrl;
//   /// Last name of the user
//   String? lastName;
//   String? createdAt;
//   String? deviceToken;
//   bool? backUpEnabled;
//   String? subscriptionPlan;
//   String? nextBillingDate;
//   String? previousBillingDate;
//   bool? isLastSubscriptionPaymentSucceeded;
//   String? backupFileId;
//   String? email;
//   String? lastDbBackup;
//   String? fullName;
//   Business.fromJson(Map<String, dynamic> json)
//       : id = json["id"],
//         name = json["name"],
//         subscriptionPlan = json["subscriptionPlan"],
//         nextBillingDate = json["nextBillingDate"],
//         previousBillingDate = json["previousBillingDate"],
//         isLastSubscriptionPaymentSucceeded =
//             json["isLastSubscriptionPaymentSucceeded"],
//         backupFileId = json["backupFileId"],
//         email = json["email"],
//         lastDbBackup = json["lastDbBackup"],
//         fullName = json["fullName"],
//         chatUid = json["chatUid"],
//         deviceToken = json["deviceToken"],
//         currency = json["currency"],
//         backUpEnabled = json["backUpEnabled"],
//         // TODOwhen loading the fcategoryId it seems somehow fcategoryId is a string and we are expecting an int or maybe there is null returned!
//         // fcategoryId = json["fcategoryId"],
//         latitude = json["latitude"] ?? '1',
//         longitude = json["longitude"] ?? '1',
//         userId = json["userId"].toString(),
//         typeId = json["typeId"],
//         timeZone = json["timeZone"],
//         table = json["table"],
//         country = json["country"],
//         businessUrl = json["businessUrl"],
//         hexColor = json["hexColor"],
//         imageUrl = json["imageUrl"],
//         type = json["type"],
//         metadata = json["metadata"],
//         role = json["role"],
//         lastName = json["name"],
//         firstName = json["name"],
//         lastSeen = json["lastSeen"],
//         active = json["active"];

//   Map<String, dynamic> toJson() => {
//         "id": int.parse(id.toString()),
//         "name": name,
//         "deviceToken": deviceToken,
//         "backUpEnabled": backUpEnabled,
//         "subscriptionPlan": subscriptionPlan,
//         "nextBillingDate": nextBillingDate,
//         "previousBillingDate": previousBillingDate,
//         "isLastSubscriptionPaymentSucceeded":
//             isLastSubscriptionPaymentSucceeded,
//         "backupFileId": backupFileId,
//         "email": email,
//         "lastDbBackup": lastDbBackup,
//         "fullName": fullName,
//         "currency": currency,
//         "chatUid": chatUid,
//         "fcategoryId": fcategoryId.toString(),
//         "latitude": latitude,
//         "longitude": longitude,
//         "userId": userId.toString(),
//         "typeId": typeId,
//         "timeZone": timeZone,
//         "metadata": metadata,
//         "lastName": name,
//         "firstName": name,
//         "imageUrl": imageUrl,
//         "role": role,
//         "lastSeen": lastSeen,
//         "table": table,
//         "country": country,
//         "businessUrl": businessUrl,
//         "hexColor": hexColor,
//         "type": type,
//         "active": active,
//       };
// }
