// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'schemas.dart';

// // **************************************************************************
// // RealmObjectGenerator
// // **************************************************************************

// // ignore_for_file: type=lint
// class Branch extends _Branch with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Branch(
//     ObjectId realmId, {
//     int? id,
//     int? serverId,
//     bool? active,
//     String? description,
//     String? name,
//     int? businessId,
//     String? longitude,
//     String? latitude,
//     String? location,
//     bool isDefault = false,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     bool? isOnline = false,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Branch>({
//         'isDefault': false,
//         'isOnline': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'serverId', serverId);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'description', description);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'longitude', longitude);
//     RealmObjectBase.set(this, 'latitude', latitude);
//     RealmObjectBase.set(this, 'location', location);
//     RealmObjectBase.set(this, 'isDefault', isDefault);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'isOnline', isOnline);
//   }

//   Branch._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get serverId => RealmObjectBase.get<int>(this, 'serverId') as int?;
//   @override
//   set serverId(int? value) => RealmObjectBase.set(this, 'serverId', value);

//   @override
//   bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
//   @override
//   set active(bool? value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   String? get description =>
//       RealmObjectBase.get<String>(this, 'description') as String?;
//   @override
//   set description(String? value) =>
//       RealmObjectBase.set(this, 'description', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get longitude =>
//       RealmObjectBase.get<String>(this, 'longitude') as String?;
//   @override
//   set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

//   @override
//   String? get latitude =>
//       RealmObjectBase.get<String>(this, 'latitude') as String?;
//   @override
//   set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

//   @override
//   String? get location =>
//       RealmObjectBase.get<String>(this, 'location') as String?;
//   @override
//   set location(String? value) => RealmObjectBase.set(this, 'location', value);

//   @override
//   bool get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool;
//   @override
//   set isDefault(bool value) => RealmObjectBase.set(this, 'isDefault', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   bool? get isOnline => RealmObjectBase.get<bool>(this, 'isOnline') as bool?;
//   @override
//   set isOnline(bool? value) => RealmObjectBase.set(this, 'isOnline', value);

//   @override
//   Stream<RealmObjectChanges<Branch>> get changes =>
//       RealmObjectBase.getChanges<Branch>(this);

//   @override
//   Stream<RealmObjectChanges<Branch>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Branch>(this, keyPaths);

//   @override
//   Branch freeze() => RealmObjectBase.freezeObject<Branch>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'serverId': serverId,
//       'active': active,
//       'description': description,
//       'name': name,
//       'businessId': businessId,
//       'longitude': longitude,
//       'latitude': latitude,
//       'location': location,
//       'isDefault': isDefault,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'isOnline': isOnline,
//     };
//   }

//   static EJsonValue _toEJson(Branch value) => value;
//   static Branch _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Branch(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           serverId: fromEJson(ejson['serverId']),
//           active: fromEJson(ejson['active']),
//           description: fromEJson(ejson['description']),
//           name: fromEJson(ejson['name']),
//           businessId: fromEJson(ejson['businessId']),
//           longitude: fromEJson(ejson['longitude']),
//           latitude: fromEJson(ejson['latitude']),
//           location: fromEJson(ejson['location']),
//           isDefault: fromEJson(ejson['isDefault'], defaultValue: false),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           isOnline: fromEJson(ejson['isOnline'], defaultValue: false),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Branch._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Branch, 'Branch', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('serverId', RealmPropertyType.int, optional: true),
//       SchemaProperty('active', RealmPropertyType.bool, optional: true),
//       SchemaProperty('description', RealmPropertyType.string, optional: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('longitude', RealmPropertyType.string, optional: true),
//       SchemaProperty('latitude', RealmPropertyType.string, optional: true),
//       SchemaProperty('location', RealmPropertyType.string, optional: true),
//       SchemaProperty('isDefault', RealmPropertyType.bool),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('isOnline', RealmPropertyType.bool, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Location extends _Location
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Location(
//     ObjectId realmId, {
//     int? id,
//     int? serverId,
//     bool? active,
//     String? description,
//     String? name,
//     int? businessId,
//     String? longitude,
//     String? latitude,
//     String? location,
//     bool isDefault = false,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     bool? isOnline = false,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Location>({
//         'isDefault': false,
//         'isOnline': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'serverId', serverId);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'description', description);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'longitude', longitude);
//     RealmObjectBase.set(this, 'latitude', latitude);
//     RealmObjectBase.set(this, 'location', location);
//     RealmObjectBase.set(this, 'isDefault', isDefault);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'isOnline', isOnline);
//   }

//   Location._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get serverId => RealmObjectBase.get<int>(this, 'serverId') as int?;
//   @override
//   set serverId(int? value) => RealmObjectBase.set(this, 'serverId', value);

//   @override
//   bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
//   @override
//   set active(bool? value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   String? get description =>
//       RealmObjectBase.get<String>(this, 'description') as String?;
//   @override
//   set description(String? value) =>
//       RealmObjectBase.set(this, 'description', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get longitude =>
//       RealmObjectBase.get<String>(this, 'longitude') as String?;
//   @override
//   set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

//   @override
//   String? get latitude =>
//       RealmObjectBase.get<String>(this, 'latitude') as String?;
//   @override
//   set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

//   @override
//   String? get location =>
//       RealmObjectBase.get<String>(this, 'location') as String?;
//   @override
//   set location(String? value) => RealmObjectBase.set(this, 'location', value);

//   @override
//   bool get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool;
//   @override
//   set isDefault(bool value) => RealmObjectBase.set(this, 'isDefault', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   bool? get isOnline => RealmObjectBase.get<bool>(this, 'isOnline') as bool?;
//   @override
//   set isOnline(bool? value) => RealmObjectBase.set(this, 'isOnline', value);

//   @override
//   Stream<RealmObjectChanges<Location>> get changes =>
//       RealmObjectBase.getChanges<Location>(this);

//   @override
//   Stream<RealmObjectChanges<Location>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Location>(this, keyPaths);

//   @override
//   Location freeze() => RealmObjectBase.freezeObject<Location>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'serverId': serverId,
//       'active': active,
//       'description': description,
//       'name': name,
//       'businessId': businessId,
//       'longitude': longitude,
//       'latitude': latitude,
//       'location': location,
//       'isDefault': isDefault,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'isOnline': isOnline,
//     };
//   }

//   static EJsonValue _toEJson(Location value) => value;
//   static Location _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Location(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           serverId: fromEJson(ejson['serverId']),
//           active: fromEJson(ejson['active']),
//           description: fromEJson(ejson['description']),
//           name: fromEJson(ejson['name']),
//           businessId: fromEJson(ejson['businessId']),
//           longitude: fromEJson(ejson['longitude']),
//           latitude: fromEJson(ejson['latitude']),
//           location: fromEJson(ejson['location']),
//           isDefault: fromEJson(ejson['isDefault'], defaultValue: false),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           isOnline: fromEJson(ejson['isOnline'], defaultValue: false),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Location._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Location, 'Location', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('serverId', RealmPropertyType.int, optional: true),
//       SchemaProperty('active', RealmPropertyType.bool, optional: true),
//       SchemaProperty('description', RealmPropertyType.string, optional: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('longitude', RealmPropertyType.string, optional: true),
//       SchemaProperty('latitude', RealmPropertyType.string, optional: true),
//       SchemaProperty('location', RealmPropertyType.string, optional: true),
//       SchemaProperty('isDefault', RealmPropertyType.bool),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('isOnline', RealmPropertyType.bool, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Business extends _Business
//     with RealmEntity, RealmObjectBase, RealmObject {
//   Business(
//     ObjectId id, {
//     int? serverId,
//     String? name,
//     String? currency,
//     String? categoryId,
//     String? latitude,
//     String? longitude,
//     int? userId,
//     String? timeZone,
//     String? country,
//     String? businessUrl,
//     String? hexColor,
//     String? imageUrl,
//     String? type,
//     bool? active,
//     String? chatUid,
//     String? metadata,
//     String? role,
//     int? lastSeen,
//     String? firstName,
//     String? lastName,
//     String? createdAt,
//     String? deviceToken,
//     bool? backUpEnabled,
//     String? subscriptionPlan,
//     String? nextBillingDate,
//     String? previousBillingDate,
//     bool? isLastSubscriptionPaymentSucceeded,
//     String? backupFileId,
//     String? email,
//     String? lastDbBackup,
//     String? fullName,
//     int? tinNumber,
//     String? bhfId,
//     String? dvcSrlNo,
//     String? adrs,
//     bool? taxEnabled,
//     String? taxServerUrl,
//     bool? isDefault,
//     int? businessTypeId,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     String? encryptionKey,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, 'serverId', serverId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'currency', currency);
//     RealmObjectBase.set(this, 'categoryId', categoryId);
//     RealmObjectBase.set(this, 'latitude', latitude);
//     RealmObjectBase.set(this, 'longitude', longitude);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'timeZone', timeZone);
//     RealmObjectBase.set(this, 'country', country);
//     RealmObjectBase.set(this, 'businessUrl', businessUrl);
//     RealmObjectBase.set(this, 'hexColor', hexColor);
//     RealmObjectBase.set(this, 'imageUrl', imageUrl);
//     RealmObjectBase.set(this, 'type', type);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'chatUid', chatUid);
//     RealmObjectBase.set(this, 'metadata', metadata);
//     RealmObjectBase.set(this, 'role', role);
//     RealmObjectBase.set(this, 'lastSeen', lastSeen);
//     RealmObjectBase.set(this, 'firstName', firstName);
//     RealmObjectBase.set(this, 'lastName', lastName);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'deviceToken', deviceToken);
//     RealmObjectBase.set(this, 'backUpEnabled', backUpEnabled);
//     RealmObjectBase.set(this, 'subscriptionPlan', subscriptionPlan);
//     RealmObjectBase.set(this, 'nextBillingDate', nextBillingDate);
//     RealmObjectBase.set(this, 'previousBillingDate', previousBillingDate);
//     RealmObjectBase.set(this, 'isLastSubscriptionPaymentSucceeded',
//         isLastSubscriptionPaymentSucceeded);
//     RealmObjectBase.set(this, 'backupFileId', backupFileId);
//     RealmObjectBase.set(this, 'email', email);
//     RealmObjectBase.set(this, 'lastDbBackup', lastDbBackup);
//     RealmObjectBase.set(this, 'fullName', fullName);
//     RealmObjectBase.set(this, 'tinNumber', tinNumber);
//     RealmObjectBase.set(this, 'bhfId', bhfId);
//     RealmObjectBase.set(this, 'dvcSrlNo', dvcSrlNo);
//     RealmObjectBase.set(this, 'adrs', adrs);
//     RealmObjectBase.set(this, 'taxEnabled', taxEnabled);
//     RealmObjectBase.set(this, 'taxServerUrl', taxServerUrl);
//     RealmObjectBase.set(this, 'isDefault', isDefault);
//     RealmObjectBase.set(this, 'businessTypeId', businessTypeId);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'encryptionKey', encryptionKey);
//   }

//   Business._();

//   @override
//   ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
//   @override
//   set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   int? get serverId => RealmObjectBase.get<int>(this, 'serverId') as int?;
//   @override
//   set serverId(int? value) => RealmObjectBase.set(this, 'serverId', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   String? get currency =>
//       RealmObjectBase.get<String>(this, 'currency') as String?;
//   @override
//   set currency(String? value) => RealmObjectBase.set(this, 'currency', value);

//   @override
//   String? get categoryId =>
//       RealmObjectBase.get<String>(this, 'categoryId') as String?;
//   @override
//   set categoryId(String? value) =>
//       RealmObjectBase.set(this, 'categoryId', value);

//   @override
//   String? get latitude =>
//       RealmObjectBase.get<String>(this, 'latitude') as String?;
//   @override
//   set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

//   @override
//   String? get longitude =>
//       RealmObjectBase.get<String>(this, 'longitude') as String?;
//   @override
//   set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get timeZone =>
//       RealmObjectBase.get<String>(this, 'timeZone') as String?;
//   @override
//   set timeZone(String? value) => RealmObjectBase.set(this, 'timeZone', value);

//   @override
//   String? get country =>
//       RealmObjectBase.get<String>(this, 'country') as String?;
//   @override
//   set country(String? value) => RealmObjectBase.set(this, 'country', value);

//   @override
//   String? get businessUrl =>
//       RealmObjectBase.get<String>(this, 'businessUrl') as String?;
//   @override
//   set businessUrl(String? value) =>
//       RealmObjectBase.set(this, 'businessUrl', value);

//   @override
//   String? get hexColor =>
//       RealmObjectBase.get<String>(this, 'hexColor') as String?;
//   @override
//   set hexColor(String? value) => RealmObjectBase.set(this, 'hexColor', value);

//   @override
//   String? get imageUrl =>
//       RealmObjectBase.get<String>(this, 'imageUrl') as String?;
//   @override
//   set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

//   @override
//   String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
//   @override
//   set type(String? value) => RealmObjectBase.set(this, 'type', value);

//   @override
//   bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
//   @override
//   set active(bool? value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   String? get chatUid =>
//       RealmObjectBase.get<String>(this, 'chatUid') as String?;
//   @override
//   set chatUid(String? value) => RealmObjectBase.set(this, 'chatUid', value);

//   @override
//   String? get metadata =>
//       RealmObjectBase.get<String>(this, 'metadata') as String?;
//   @override
//   set metadata(String? value) => RealmObjectBase.set(this, 'metadata', value);

//   @override
//   String? get role => RealmObjectBase.get<String>(this, 'role') as String?;
//   @override
//   set role(String? value) => RealmObjectBase.set(this, 'role', value);

//   @override
//   int? get lastSeen => RealmObjectBase.get<int>(this, 'lastSeen') as int?;
//   @override
//   set lastSeen(int? value) => RealmObjectBase.set(this, 'lastSeen', value);

//   @override
//   String? get firstName =>
//       RealmObjectBase.get<String>(this, 'firstName') as String?;
//   @override
//   set firstName(String? value) => RealmObjectBase.set(this, 'firstName', value);

//   @override
//   String? get lastName =>
//       RealmObjectBase.get<String>(this, 'lastName') as String?;
//   @override
//   set lastName(String? value) => RealmObjectBase.set(this, 'lastName', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get deviceToken =>
//       RealmObjectBase.get<String>(this, 'deviceToken') as String?;
//   @override
//   set deviceToken(String? value) =>
//       RealmObjectBase.set(this, 'deviceToken', value);

//   @override
//   bool? get backUpEnabled =>
//       RealmObjectBase.get<bool>(this, 'backUpEnabled') as bool?;
//   @override
//   set backUpEnabled(bool? value) =>
//       RealmObjectBase.set(this, 'backUpEnabled', value);

//   @override
//   String? get subscriptionPlan =>
//       RealmObjectBase.get<String>(this, 'subscriptionPlan') as String?;
//   @override
//   set subscriptionPlan(String? value) =>
//       RealmObjectBase.set(this, 'subscriptionPlan', value);

//   @override
//   String? get nextBillingDate =>
//       RealmObjectBase.get<String>(this, 'nextBillingDate') as String?;
//   @override
//   set nextBillingDate(String? value) =>
//       RealmObjectBase.set(this, 'nextBillingDate', value);

//   @override
//   String? get previousBillingDate =>
//       RealmObjectBase.get<String>(this, 'previousBillingDate') as String?;
//   @override
//   set previousBillingDate(String? value) =>
//       RealmObjectBase.set(this, 'previousBillingDate', value);

//   @override
//   bool? get isLastSubscriptionPaymentSucceeded =>
//       RealmObjectBase.get<bool>(this, 'isLastSubscriptionPaymentSucceeded')
//           as bool?;
//   @override
//   set isLastSubscriptionPaymentSucceeded(bool? value) =>
//       RealmObjectBase.set(this, 'isLastSubscriptionPaymentSucceeded', value);

//   @override
//   String? get backupFileId =>
//       RealmObjectBase.get<String>(this, 'backupFileId') as String?;
//   @override
//   set backupFileId(String? value) =>
//       RealmObjectBase.set(this, 'backupFileId', value);

//   @override
//   String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
//   @override
//   set email(String? value) => RealmObjectBase.set(this, 'email', value);

//   @override
//   String? get lastDbBackup =>
//       RealmObjectBase.get<String>(this, 'lastDbBackup') as String?;
//   @override
//   set lastDbBackup(String? value) =>
//       RealmObjectBase.set(this, 'lastDbBackup', value);

//   @override
//   String? get fullName =>
//       RealmObjectBase.get<String>(this, 'fullName') as String?;
//   @override
//   set fullName(String? value) => RealmObjectBase.set(this, 'fullName', value);

//   @override
//   int? get tinNumber => RealmObjectBase.get<int>(this, 'tinNumber') as int?;
//   @override
//   set tinNumber(int? value) => RealmObjectBase.set(this, 'tinNumber', value);

//   @override
//   String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
//   @override
//   set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

//   @override
//   String? get dvcSrlNo =>
//       RealmObjectBase.get<String>(this, 'dvcSrlNo') as String?;
//   @override
//   set dvcSrlNo(String? value) => RealmObjectBase.set(this, 'dvcSrlNo', value);

//   @override
//   String? get adrs => RealmObjectBase.get<String>(this, 'adrs') as String?;
//   @override
//   set adrs(String? value) => RealmObjectBase.set(this, 'adrs', value);

//   @override
//   bool? get taxEnabled =>
//       RealmObjectBase.get<bool>(this, 'taxEnabled') as bool?;
//   @override
//   set taxEnabled(bool? value) => RealmObjectBase.set(this, 'taxEnabled', value);

//   @override
//   String? get taxServerUrl =>
//       RealmObjectBase.get<String>(this, 'taxServerUrl') as String?;
//   @override
//   set taxServerUrl(String? value) =>
//       RealmObjectBase.set(this, 'taxServerUrl', value);

//   @override
//   bool? get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool?;
//   @override
//   set isDefault(bool? value) => RealmObjectBase.set(this, 'isDefault', value);

//   @override
//   int? get businessTypeId =>
//       RealmObjectBase.get<int>(this, 'businessTypeId') as int?;
//   @override
//   set businessTypeId(int? value) =>
//       RealmObjectBase.set(this, 'businessTypeId', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   String? get encryptionKey =>
//       RealmObjectBase.get<String>(this, 'encryptionKey') as String?;
//   @override
//   set encryptionKey(String? value) =>
//       RealmObjectBase.set(this, 'encryptionKey', value);

//   @override
//   Stream<RealmObjectChanges<Business>> get changes =>
//       RealmObjectBase.getChanges<Business>(this);

//   @override
//   Stream<RealmObjectChanges<Business>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Business>(this, keyPaths);

//   @override
//   Business freeze() => RealmObjectBase.freezeObject<Business>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       'serverId': serverId,
//       'name': name,
//       'currency': currency,
//       'categoryId': categoryId,
//       'latitude': latitude,
//       'longitude': longitude,
//       'userId': userId,
//       'timeZone': timeZone,
//       'country': country,
//       'businessUrl': businessUrl,
//       'hexColor': hexColor,
//       'imageUrl': imageUrl,
//       'type': type,
//       'active': active,
//       'chatUid': chatUid,
//       'metadata': metadata,
//       'role': role,
//       'lastSeen': lastSeen,
//       'firstName': firstName,
//       'lastName': lastName,
//       'createdAt': createdAt,
//       'deviceToken': deviceToken,
//       'backUpEnabled': backUpEnabled,
//       'subscriptionPlan': subscriptionPlan,
//       'nextBillingDate': nextBillingDate,
//       'previousBillingDate': previousBillingDate,
//       'isLastSubscriptionPaymentSucceeded':
//           isLastSubscriptionPaymentSucceeded,
//       'backupFileId': backupFileId,
//       'email': email,
//       'lastDbBackup': lastDbBackup,
//       'fullName': fullName,
//       'tinNumber': tinNumber,
//       'bhfId': bhfId,
//       'dvcSrlNo': dvcSrlNo,
//       'adrs': adrs,
//       'taxEnabled': taxEnabled,
//       'taxServerUrl': taxServerUrl,
//       'isDefault': isDefault,
//       'businessTypeId': businessTypeId,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'encryptionKey': encryptionKey,
//     };
//   }

//   static EJsonValue _toEJson(Business value) => value;
//   static Business _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         'id': EJsonValue id,
//       } =>
//         Business(
//           fromEJson(id),
//           serverId: fromEJson(ejson['serverId']),
//           name: fromEJson(ejson['name']),
//           currency: fromEJson(ejson['currency']),
//           categoryId: fromEJson(ejson['categoryId']),
//           latitude: fromEJson(ejson['latitude']),
//           longitude: fromEJson(ejson['longitude']),
//           userId: fromEJson(ejson['userId']),
//           timeZone: fromEJson(ejson['timeZone']),
//           country: fromEJson(ejson['country']),
//           businessUrl: fromEJson(ejson['businessUrl']),
//           hexColor: fromEJson(ejson['hexColor']),
//           imageUrl: fromEJson(ejson['imageUrl']),
//           type: fromEJson(ejson['type']),
//           active: fromEJson(ejson['active']),
//           chatUid: fromEJson(ejson['chatUid']),
//           metadata: fromEJson(ejson['metadata']),
//           role: fromEJson(ejson['role']),
//           lastSeen: fromEJson(ejson['lastSeen']),
//           firstName: fromEJson(ejson['firstName']),
//           lastName: fromEJson(ejson['lastName']),
//           createdAt: fromEJson(ejson['createdAt']),
//           deviceToken: fromEJson(ejson['deviceToken']),
//           backUpEnabled: fromEJson(ejson['backUpEnabled']),
//           subscriptionPlan: fromEJson(ejson['subscriptionPlan']),
//           nextBillingDate: fromEJson(ejson['nextBillingDate']),
//           previousBillingDate: fromEJson(ejson['previousBillingDate']),
//           isLastSubscriptionPaymentSucceeded:
//               fromEJson(ejson['isLastSubscriptionPaymentSucceeded']),
//           backupFileId: fromEJson(ejson['backupFileId']),
//           email: fromEJson(ejson['email']),
//           lastDbBackup: fromEJson(ejson['lastDbBackup']),
//           fullName: fromEJson(ejson['fullName']),
//           tinNumber: fromEJson(ejson['tinNumber']),
//           bhfId: fromEJson(ejson['bhfId']),
//           dvcSrlNo: fromEJson(ejson['dvcSrlNo']),
//           adrs: fromEJson(ejson['adrs']),
//           taxEnabled: fromEJson(ejson['taxEnabled']),
//           taxServerUrl: fromEJson(ejson['taxServerUrl']),
//           isDefault: fromEJson(ejson['isDefault']),
//           businessTypeId: fromEJson(ejson['businessTypeId']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           encryptionKey: fromEJson(ejson['encryptionKey']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Business._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Business, 'Business', [
//       SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
//       SchemaProperty('serverId', RealmPropertyType.int, optional: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('currency', RealmPropertyType.string, optional: true),
//       SchemaProperty('categoryId', RealmPropertyType.string, optional: true),
//       SchemaProperty('latitude', RealmPropertyType.string, optional: true),
//       SchemaProperty('longitude', RealmPropertyType.string, optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('timeZone', RealmPropertyType.string, optional: true),
//       SchemaProperty('country', RealmPropertyType.string, optional: true),
//       SchemaProperty('businessUrl', RealmPropertyType.string, optional: true),
//       SchemaProperty('hexColor', RealmPropertyType.string, optional: true),
//       SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
//       SchemaProperty('type', RealmPropertyType.string, optional: true),
//       SchemaProperty('active', RealmPropertyType.bool, optional: true),
//       SchemaProperty('chatUid', RealmPropertyType.string, optional: true),
//       SchemaProperty('metadata', RealmPropertyType.string, optional: true),
//       SchemaProperty('role', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastSeen', RealmPropertyType.int, optional: true),
//       SchemaProperty('firstName', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastName', RealmPropertyType.string, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('deviceToken', RealmPropertyType.string, optional: true),
//       SchemaProperty('backUpEnabled', RealmPropertyType.bool, optional: true),
//       SchemaProperty('subscriptionPlan', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('nextBillingDate', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('previousBillingDate', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty(
//           'isLastSubscriptionPaymentSucceeded', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('backupFileId', RealmPropertyType.string, optional: true),
//       SchemaProperty('email', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastDbBackup', RealmPropertyType.string, optional: true),
//       SchemaProperty('fullName', RealmPropertyType.string, optional: true),
//       SchemaProperty('tinNumber', RealmPropertyType.int, optional: true),
//       SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
//       SchemaProperty('dvcSrlNo', RealmPropertyType.string, optional: true),
//       SchemaProperty('adrs', RealmPropertyType.string, optional: true),
//       SchemaProperty('taxEnabled', RealmPropertyType.bool, optional: true),
//       SchemaProperty('taxServerUrl', RealmPropertyType.string, optional: true),
//       SchemaProperty('isDefault', RealmPropertyType.bool, optional: true),
//       SchemaProperty('businessTypeId', RealmPropertyType.int, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('encryptionKey', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Category extends _Category
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Category(
//     ObjectId realmId, {
//     int? id,
//     bool? active,
//     bool focused = false,
//     String? name,
//     int? branchId,
//     DateTime? deletedAt,
//     DateTime? lastTouched,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Category>({
//         'focused': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'focused', focused);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//   }

//   Category._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
//   @override
//   set active(bool? value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   bool get focused => RealmObjectBase.get<bool>(this, 'focused') as bool;
//   @override
//   set focused(bool value) => RealmObjectBase.set(this, 'focused', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   Stream<RealmObjectChanges<Category>> get changes =>
//       RealmObjectBase.getChanges<Category>(this);

//   @override
//   Stream<RealmObjectChanges<Category>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Category>(this, keyPaths);

//   @override
//   Category freeze() => RealmObjectBase.freezeObject<Category>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'active': active,
//       'focused': focused,
//       'name': name,
//       'branchId': branchId,
//       'deletedAt': deletedAt,
//       'lastTouched': lastTouched,
//     };
//   }

//   static EJsonValue _toEJson(Category value) => value;
//   static Category _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Category(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           active: fromEJson(ejson['active']),
//           focused: fromEJson(ejson['focused'], defaultValue: false),
//           name: fromEJson(ejson['name']),
//           branchId: fromEJson(ejson['branchId']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Category._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Category, 'Category', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('active', RealmPropertyType.bool, optional: true),
//       SchemaProperty('focused', RealmPropertyType.bool),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class PColor extends _PColor with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   PColor(
//     ObjectId realmId, {
//     int? id,
//     String? name,
//     Iterable<String> colors = const [],
//     int? branchId,
//     bool active = false,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<PColor>({
//         'active': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set<RealmList<String>>(
//         this, 'colors', RealmList<String>(colors));
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   PColor._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   RealmList<String> get colors =>
//       RealmObjectBase.get<String>(this, 'colors') as RealmList<String>;
//   @override
//   set colors(covariant RealmList<String> value) =>
//       throw RealmUnsupportedSetError();

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   bool get active => RealmObjectBase.get<bool>(this, 'active') as bool;
//   @override
//   set active(bool value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<PColor>> get changes =>
//       RealmObjectBase.getChanges<PColor>(this);

//   @override
//   Stream<RealmObjectChanges<PColor>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<PColor>(this, keyPaths);

//   @override
//   PColor freeze() => RealmObjectBase.freezeObject<PColor>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'name': name,
//       'colors': colors,
//       'branchId': branchId,
//       'active': active,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(PColor value) => value;
//   static PColor _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         PColor(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           name: fromEJson(ejson['name']),
//           colors: fromEJson(ejson['colors']),
//           branchId: fromEJson(ejson['branchId']),
//           active: fromEJson(ejson['active'], defaultValue: false),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(PColor._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, PColor, 'PColor', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('colors', RealmPropertyType.string,
//           collectionType: RealmCollectionType.list),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('active', RealmPropertyType.bool),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Conversation extends _Conversation
//     with RealmEntity, RealmObjectBase, RealmObject {
//   Conversation(
//     ObjectId realmId, {
//     int? id,
//     String? userName,
//     String? body,
//     String? avatar,
//     String? channelType,
//     String? fromNumber,
//     String? toNumber,
//     String? createdAt,
//     String? messageType,
//     String? phoneNumberId,
//     String? messageId,
//     String? respondedBy,
//     String? conversationId,
//     String? businessPhoneNumber,
//     int? businessId,
//     DateTime? scheduledAt,
//     bool? delivered,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'userName', userName);
//     RealmObjectBase.set(this, 'body', body);
//     RealmObjectBase.set(this, 'avatar', avatar);
//     RealmObjectBase.set(this, 'channelType', channelType);
//     RealmObjectBase.set(this, 'fromNumber', fromNumber);
//     RealmObjectBase.set(this, 'toNumber', toNumber);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'messageType', messageType);
//     RealmObjectBase.set(this, 'phoneNumberId', phoneNumberId);
//     RealmObjectBase.set(this, 'messageId', messageId);
//     RealmObjectBase.set(this, 'respondedBy', respondedBy);
//     RealmObjectBase.set(this, 'conversationId', conversationId);
//     RealmObjectBase.set(this, 'businessPhoneNumber', businessPhoneNumber);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'scheduledAt', scheduledAt);
//     RealmObjectBase.set(this, 'delivered', delivered);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   Conversation._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get userName =>
//       RealmObjectBase.get<String>(this, 'userName') as String?;
//   @override
//   set userName(String? value) => RealmObjectBase.set(this, 'userName', value);

//   @override
//   String? get body => RealmObjectBase.get<String>(this, 'body') as String?;
//   @override
//   set body(String? value) => RealmObjectBase.set(this, 'body', value);

//   @override
//   String? get avatar => RealmObjectBase.get<String>(this, 'avatar') as String?;
//   @override
//   set avatar(String? value) => RealmObjectBase.set(this, 'avatar', value);

//   @override
//   String? get channelType =>
//       RealmObjectBase.get<String>(this, 'channelType') as String?;
//   @override
//   set channelType(String? value) =>
//       RealmObjectBase.set(this, 'channelType', value);

//   @override
//   String? get fromNumber =>
//       RealmObjectBase.get<String>(this, 'fromNumber') as String?;
//   @override
//   set fromNumber(String? value) =>
//       RealmObjectBase.set(this, 'fromNumber', value);

//   @override
//   String? get toNumber =>
//       RealmObjectBase.get<String>(this, 'toNumber') as String?;
//   @override
//   set toNumber(String? value) => RealmObjectBase.set(this, 'toNumber', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get messageType =>
//       RealmObjectBase.get<String>(this, 'messageType') as String?;
//   @override
//   set messageType(String? value) =>
//       RealmObjectBase.set(this, 'messageType', value);

//   @override
//   String? get phoneNumberId =>
//       RealmObjectBase.get<String>(this, 'phoneNumberId') as String?;
//   @override
//   set phoneNumberId(String? value) =>
//       RealmObjectBase.set(this, 'phoneNumberId', value);

//   @override
//   String? get messageId =>
//       RealmObjectBase.get<String>(this, 'messageId') as String?;
//   @override
//   set messageId(String? value) => RealmObjectBase.set(this, 'messageId', value);

//   @override
//   String? get respondedBy =>
//       RealmObjectBase.get<String>(this, 'respondedBy') as String?;
//   @override
//   set respondedBy(String? value) =>
//       RealmObjectBase.set(this, 'respondedBy', value);

//   @override
//   String? get conversationId =>
//       RealmObjectBase.get<String>(this, 'conversationId') as String?;
//   @override
//   set conversationId(String? value) =>
//       RealmObjectBase.set(this, 'conversationId', value);

//   @override
//   String? get businessPhoneNumber =>
//       RealmObjectBase.get<String>(this, 'businessPhoneNumber') as String?;
//   @override
//   set businessPhoneNumber(String? value) =>
//       RealmObjectBase.set(this, 'businessPhoneNumber', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   DateTime? get scheduledAt =>
//       RealmObjectBase.get<DateTime>(this, 'scheduledAt') as DateTime?;
//   @override
//   set scheduledAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'scheduledAt', value);

//   @override
//   bool? get delivered => RealmObjectBase.get<bool>(this, 'delivered') as bool?;
//   @override
//   set delivered(bool? value) => RealmObjectBase.set(this, 'delivered', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<Conversation>> get changes =>
//       RealmObjectBase.getChanges<Conversation>(this);

//   @override
//   Stream<RealmObjectChanges<Conversation>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Conversation>(this, keyPaths);

//   @override
//   Conversation freeze() => RealmObjectBase.freezeObject<Conversation>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'userName': userName,
//       'body': body,
//       'avatar': avatar,
//       'channelType': channelType,
//       'fromNumber': fromNumber,
//       'toNumber': toNumber,
//       'createdAt': createdAt,
//       'messageType': messageType,
//       'phoneNumberId': phoneNumberId,
//       'messageId': messageId,
//       'respondedBy': respondedBy,
//       'conversationId': conversationId,
//       'businessPhoneNumber': businessPhoneNumber,
//       'businessId': businessId,
//       'scheduledAt': scheduledAt,
//       'delivered': delivered,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(Conversation value) => value;
//   static Conversation _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Conversation(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           userName: fromEJson(ejson['userName']),
//           body: fromEJson(ejson['body']),
//           avatar: fromEJson(ejson['avatar']),
//           channelType: fromEJson(ejson['channelType']),
//           fromNumber: fromEJson(ejson['fromNumber']),
//           toNumber: fromEJson(ejson['toNumber']),
//           createdAt: fromEJson(ejson['createdAt']),
//           messageType: fromEJson(ejson['messageType']),
//           phoneNumberId: fromEJson(ejson['phoneNumberId']),
//           messageId: fromEJson(ejson['messageId']),
//           respondedBy: fromEJson(ejson['respondedBy']),
//           conversationId: fromEJson(ejson['conversationId']),
//           businessPhoneNumber: fromEJson(ejson['businessPhoneNumber']),
//           businessId: fromEJson(ejson['businessId']),
//           scheduledAt: fromEJson(ejson['scheduledAt']),
//           delivered: fromEJson(ejson['delivered']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Conversation._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, Conversation, 'Conversation', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('userName', RealmPropertyType.string, optional: true),
//       SchemaProperty('body', RealmPropertyType.string, optional: true),
//       SchemaProperty('avatar', RealmPropertyType.string, optional: true),
//       SchemaProperty('channelType', RealmPropertyType.string, optional: true),
//       SchemaProperty('fromNumber', RealmPropertyType.string, optional: true),
//       SchemaProperty('toNumber', RealmPropertyType.string, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('messageType', RealmPropertyType.string, optional: true),
//       SchemaProperty('phoneNumberId', RealmPropertyType.string, optional: true),
//       SchemaProperty('messageId', RealmPropertyType.string, optional: true),
//       SchemaProperty('respondedBy', RealmPropertyType.string, optional: true),
//       SchemaProperty('conversationId', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('businessPhoneNumber', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('scheduledAt', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('delivered', RealmPropertyType.bool, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Counter extends _Counter with RealmEntity, RealmObjectBase, RealmObject {
//   Counter(
//     ObjectId realmId, {
//     int? id,
//     int? businessId,
//     int? branchId,
//     String? receiptType,
//     int? totRcptNo,
//     int? curRcptNo,
//     int? invcNo,
//     DateTime? lastTouched,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'receiptType', receiptType);
//     RealmObjectBase.set(this, 'totRcptNo', totRcptNo);
//     RealmObjectBase.set(this, 'curRcptNo', curRcptNo);
//     RealmObjectBase.set(this, 'invcNo', invcNo);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//   }

//   Counter._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   String? get receiptType =>
//       RealmObjectBase.get<String>(this, 'receiptType') as String?;
//   @override
//   set receiptType(String? value) =>
//       RealmObjectBase.set(this, 'receiptType', value);

//   @override
//   int? get totRcptNo => RealmObjectBase.get<int>(this, 'totRcptNo') as int?;
//   @override
//   set totRcptNo(int? value) => RealmObjectBase.set(this, 'totRcptNo', value);

//   @override
//   int? get curRcptNo => RealmObjectBase.get<int>(this, 'curRcptNo') as int?;
//   @override
//   set curRcptNo(int? value) => RealmObjectBase.set(this, 'curRcptNo', value);

//   @override
//   int? get invcNo => RealmObjectBase.get<int>(this, 'invcNo') as int?;
//   @override
//   set invcNo(int? value) => RealmObjectBase.set(this, 'invcNo', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   Stream<RealmObjectChanges<Counter>> get changes =>
//       RealmObjectBase.getChanges<Counter>(this);

//   @override
//   Stream<RealmObjectChanges<Counter>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Counter>(this, keyPaths);

//   @override
//   Counter freeze() => RealmObjectBase.freezeObject<Counter>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'businessId': businessId,
//       'branchId': branchId,
//       'receiptType': receiptType,
//       'totRcptNo': totRcptNo,
//       'curRcptNo': curRcptNo,
//       'invcNo': invcNo,
//       'lastTouched': lastTouched,
//     };
//   }

//   static EJsonValue _toEJson(Counter value) => value;
//   static Counter _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Counter(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           businessId: fromEJson(ejson['businessId']),
//           branchId: fromEJson(ejson['branchId']),
//           receiptType: fromEJson(ejson['receiptType']),
//           totRcptNo: fromEJson(ejson['totRcptNo']),
//           curRcptNo: fromEJson(ejson['curRcptNo']),
//           invcNo: fromEJson(ejson['invcNo']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Counter._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Counter, 'Counter', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
//       SchemaProperty('totRcptNo', RealmPropertyType.int, optional: true),
//       SchemaProperty('curRcptNo', RealmPropertyType.int, optional: true),
//       SchemaProperty('invcNo', RealmPropertyType.int, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Customer extends _Customer
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Customer(
//     ObjectId realmId, {
//     int? id,
//     String? custNm,
//     String? email,
//     String? telNo,
//     String? adrs,
//     int? branchId,
//     DateTime? updatedAt,
//     String? custNo,
//     String? custTin,
//     String? regrNm,
//     String? regrId,
//     String modrNm = "284746303937",
//     String? modrId,
//     bool ebmSynced = false,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     int? tin,
//     String? bhfId,
//     String? useYn,
//     String? customerType,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Customer>({
//         'modrNm': "284746303937",
//         'ebmSynced': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'custNm', custNm);
//     RealmObjectBase.set(this, 'email', email);
//     RealmObjectBase.set(this, 'telNo', telNo);
//     RealmObjectBase.set(this, 'adrs', adrs);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'updatedAt', updatedAt);
//     RealmObjectBase.set(this, 'custNo', custNo);
//     RealmObjectBase.set(this, 'custTin', custTin);
//     RealmObjectBase.set(this, 'regrNm', regrNm);
//     RealmObjectBase.set(this, 'regrId', regrId);
//     RealmObjectBase.set(this, 'modrNm', modrNm);
//     RealmObjectBase.set(this, 'modrId', modrId);
//     RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'tin', tin);
//     RealmObjectBase.set(this, 'bhfId', bhfId);
//     RealmObjectBase.set(this, 'useYn', useYn);
//     RealmObjectBase.set(this, 'customerType', customerType);
//   }

//   Customer._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get custNm => RealmObjectBase.get<String>(this, 'custNm') as String?;
//   @override
//   set custNm(String? value) => RealmObjectBase.set(this, 'custNm', value);

//   @override
//   String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
//   @override
//   set email(String? value) => RealmObjectBase.set(this, 'email', value);

//   @override
//   String? get telNo => RealmObjectBase.get<String>(this, 'telNo') as String?;
//   @override
//   set telNo(String? value) => RealmObjectBase.set(this, 'telNo', value);

//   @override
//   String? get adrs => RealmObjectBase.get<String>(this, 'adrs') as String?;
//   @override
//   set adrs(String? value) => RealmObjectBase.set(this, 'adrs', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   DateTime? get updatedAt =>
//       RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
//   @override
//   set updatedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'updatedAt', value);

//   @override
//   String? get custNo => RealmObjectBase.get<String>(this, 'custNo') as String?;
//   @override
//   set custNo(String? value) => RealmObjectBase.set(this, 'custNo', value);

//   @override
//   String? get custTin =>
//       RealmObjectBase.get<String>(this, 'custTin') as String?;
//   @override
//   set custTin(String? value) => RealmObjectBase.set(this, 'custTin', value);

//   @override
//   String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
//   @override
//   set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

//   @override
//   String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
//   @override
//   set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

//   @override
//   String get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String;
//   @override
//   set modrNm(String value) => RealmObjectBase.set(this, 'modrNm', value);

//   @override
//   String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
//   @override
//   set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

//   @override
//   bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
//   @override
//   set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
//   @override
//   set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

//   @override
//   String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
//   @override
//   set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

//   @override
//   String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
//   @override
//   set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

//   @override
//   String? get customerType =>
//       RealmObjectBase.get<String>(this, 'customerType') as String?;
//   @override
//   set customerType(String? value) =>
//       RealmObjectBase.set(this, 'customerType', value);

//   @override
//   Stream<RealmObjectChanges<Customer>> get changes =>
//       RealmObjectBase.getChanges<Customer>(this);

//   @override
//   Stream<RealmObjectChanges<Customer>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Customer>(this, keyPaths);

//   @override
//   Customer freeze() => RealmObjectBase.freezeObject<Customer>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'custNm': custNm,
//       'email': email,
//       'telNo': telNo,
//       'adrs': adrs,
//       'branchId': branchId,
//       'updatedAt': updatedAt,
//       'custNo': custNo,
//       'custTin': custTin,
//       'regrNm': regrNm,
//       'regrId': regrId,
//       'modrNm': modrNm,
//       'modrId': modrId,
//       'ebmSynced': ebmSynced,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'tin': tin,
//       'bhfId': bhfId,
//       'useYn': useYn,
//       'customerType': customerType,
//     };
//   }

//   static EJsonValue _toEJson(Customer value) => value;
//   static Customer _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Customer(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           custNm: fromEJson(ejson['custNm']),
//           email: fromEJson(ejson['email']),
//           telNo: fromEJson(ejson['telNo']),
//           adrs: fromEJson(ejson['adrs']),
//           branchId: fromEJson(ejson['branchId']),
//           updatedAt: fromEJson(ejson['updatedAt']),
//           custNo: fromEJson(ejson['custNo']),
//           custTin: fromEJson(ejson['custTin']),
//           regrNm: fromEJson(ejson['regrNm']),
//           regrId: fromEJson(ejson['regrId']),
//           modrNm: fromEJson(ejson['modrNm'], defaultValue: "284746303937"),
//           modrId: fromEJson(ejson['modrId']),
//           ebmSynced: fromEJson(ejson['ebmSynced'], defaultValue: false),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           tin: fromEJson(ejson['tin']),
//           bhfId: fromEJson(ejson['bhfId']),
//           useYn: fromEJson(ejson['useYn']),
//           customerType: fromEJson(ejson['customerType']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Customer._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Customer, 'Customer', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('custNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('email', RealmPropertyType.string, optional: true),
//       SchemaProperty('telNo', RealmPropertyType.string, optional: true),
//       SchemaProperty('adrs', RealmPropertyType.string, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('custNo', RealmPropertyType.string, optional: true),
//       SchemaProperty('custTin', RealmPropertyType.string, optional: true),
//       SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('regrId', RealmPropertyType.string, optional: true),
//       SchemaProperty('modrNm', RealmPropertyType.string),
//       SchemaProperty('modrId', RealmPropertyType.string, optional: true),
//       SchemaProperty('ebmSynced', RealmPropertyType.bool),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('tin', RealmPropertyType.int, optional: true),
//       SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
//       SchemaProperty('useYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('customerType', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Device extends _Device with RealmEntity, RealmObjectBase, RealmObject {
//   Device(
//     ObjectId realmId, {
//     int? id,
//     String? linkingCode,
//     String? deviceName,
//     String? deviceVersion,
//     bool? pubNubPublished,
//     String? phone,
//     int? branchId,
//     int? businessId,
//     int? userId,
//     String? defaultApp,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'linkingCode', linkingCode);
//     RealmObjectBase.set(this, 'deviceName', deviceName);
//     RealmObjectBase.set(this, 'deviceVersion', deviceVersion);
//     RealmObjectBase.set(this, 'pubNubPublished', pubNubPublished);
//     RealmObjectBase.set(this, 'phone', phone);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'defaultApp', defaultApp);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   Device._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get linkingCode =>
//       RealmObjectBase.get<String>(this, 'linkingCode') as String?;
//   @override
//   set linkingCode(String? value) =>
//       RealmObjectBase.set(this, 'linkingCode', value);

//   @override
//   String? get deviceName =>
//       RealmObjectBase.get<String>(this, 'deviceName') as String?;
//   @override
//   set deviceName(String? value) =>
//       RealmObjectBase.set(this, 'deviceName', value);

//   @override
//   String? get deviceVersion =>
//       RealmObjectBase.get<String>(this, 'deviceVersion') as String?;
//   @override
//   set deviceVersion(String? value) =>
//       RealmObjectBase.set(this, 'deviceVersion', value);

//   @override
//   bool? get pubNubPublished =>
//       RealmObjectBase.get<bool>(this, 'pubNubPublished') as bool?;
//   @override
//   set pubNubPublished(bool? value) =>
//       RealmObjectBase.set(this, 'pubNubPublished', value);

//   @override
//   String? get phone => RealmObjectBase.get<String>(this, 'phone') as String?;
//   @override
//   set phone(String? value) => RealmObjectBase.set(this, 'phone', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get defaultApp =>
//       RealmObjectBase.get<String>(this, 'defaultApp') as String?;
//   @override
//   set defaultApp(String? value) =>
//       RealmObjectBase.set(this, 'defaultApp', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<Device>> get changes =>
//       RealmObjectBase.getChanges<Device>(this);

//   @override
//   Stream<RealmObjectChanges<Device>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Device>(this, keyPaths);

//   @override
//   Device freeze() => RealmObjectBase.freezeObject<Device>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'linkingCode': linkingCode,
//       'deviceName': deviceName,
//       'deviceVersion': deviceVersion,
//       'pubNubPublished': pubNubPublished,
//       'phone': phone,
//       'branchId': branchId,
//       'businessId': businessId,
//       'userId': userId,
//       'defaultApp': defaultApp,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(Device value) => value;
//   static Device _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Device(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           linkingCode: fromEJson(ejson['linkingCode']),
//           deviceName: fromEJson(ejson['deviceName']),
//           deviceVersion: fromEJson(ejson['deviceVersion']),
//           pubNubPublished: fromEJson(ejson['pubNubPublished']),
//           phone: fromEJson(ejson['phone']),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           userId: fromEJson(ejson['userId']),
//           defaultApp: fromEJson(ejson['defaultApp']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Device._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Device, 'Device', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('linkingCode', RealmPropertyType.string, optional: true),
//       SchemaProperty('deviceName', RealmPropertyType.string, optional: true),
//       SchemaProperty('deviceVersion', RealmPropertyType.string, optional: true),
//       SchemaProperty('pubNubPublished', RealmPropertyType.bool, optional: true),
//       SchemaProperty('phone', RealmPropertyType.string, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('defaultApp', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Discount extends _Discount
//     with RealmEntity, RealmObjectBase, RealmObject {
//   Discount(
//     ObjectId realmId,
//     String name,
//     int branchId, {
//     int? id,
//     double? amount,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'amount', amount);
//     RealmObjectBase.set(this, 'branchId', branchId);
//   }

//   Discount._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String get name => RealmObjectBase.get<String>(this, 'name') as String;
//   @override
//   set name(String value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   double? get amount => RealmObjectBase.get<double>(this, 'amount') as double?;
//   @override
//   set amount(double? value) => RealmObjectBase.set(this, 'amount', value);

//   @override
//   int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
//   @override
//   set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   Stream<RealmObjectChanges<Discount>> get changes =>
//       RealmObjectBase.getChanges<Discount>(this);

//   @override
//   Stream<RealmObjectChanges<Discount>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Discount>(this, keyPaths);

//   @override
//   Discount freeze() => RealmObjectBase.freezeObject<Discount>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'name': name,
//       'amount': amount,
//       'branchId': branchId,
//     };
//   }

//   static EJsonValue _toEJson(Discount value) => value;
//   static Discount _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//         'name': EJsonValue name,
//         'branchId': EJsonValue branchId,
//       } =>
//         Discount(
//           fromEJson(realmId),
//           fromEJson(name),
//           fromEJson(branchId),
//           id: fromEJson(ejson['id']),
//           amount: fromEJson(ejson['amount']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Discount._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Discount, 'Discount', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('name', RealmPropertyType.string),
//       SchemaProperty('amount', RealmPropertyType.double, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Drawers extends _Drawers with RealmEntity, RealmObjectBase, RealmObject {
//   Drawers(
//     ObjectId realmId, {
//     int? id,
//     double? openingBalance,
//     double? closingBalance,
//     String? openingDateTime,
//     String? closingDateTime,
//     int? csSaleCount,
//     String? tradeName,
//     double? totalNsSaleIncome,
//     double? totalCsSaleIncome,
//     int? nrSaleCount,
//     int? nsSaleCount,
//     int? trSaleCount,
//     int? psSaleCount,
//     int? incompleteSale,
//     int? otherTransactions,
//     String? paymentMode,
//     int? cashierId,
//     bool? open,
//     DateTime? deletedAt,
//     int? businessId,
//     int? branchId,
//   }) {
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, 'openingBalance', openingBalance);
//     RealmObjectBase.set(this, 'closingBalance', closingBalance);
//     RealmObjectBase.set(this, 'openingDateTime', openingDateTime);
//     RealmObjectBase.set(this, 'closingDateTime', closingDateTime);
//     RealmObjectBase.set(this, 'csSaleCount', csSaleCount);
//     RealmObjectBase.set(this, 'tradeName', tradeName);
//     RealmObjectBase.set(this, 'totalNsSaleIncome', totalNsSaleIncome);
//     RealmObjectBase.set(this, 'totalCsSaleIncome', totalCsSaleIncome);
//     RealmObjectBase.set(this, 'nrSaleCount', nrSaleCount);
//     RealmObjectBase.set(this, 'nsSaleCount', nsSaleCount);
//     RealmObjectBase.set(this, 'trSaleCount', trSaleCount);
//     RealmObjectBase.set(this, 'psSaleCount', psSaleCount);
//     RealmObjectBase.set(this, 'incompleteSale', incompleteSale);
//     RealmObjectBase.set(this, 'otherTransactions', otherTransactions);
//     RealmObjectBase.set(this, 'paymentMode', paymentMode);
//     RealmObjectBase.set(this, 'cashierId', cashierId);
//     RealmObjectBase.set(this, 'open', open);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//   }

//   Drawers._();

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   double? get openingBalance =>
//       RealmObjectBase.get<double>(this, 'openingBalance') as double?;
//   @override
//   set openingBalance(double? value) =>
//       RealmObjectBase.set(this, 'openingBalance', value);

//   @override
//   double? get closingBalance =>
//       RealmObjectBase.get<double>(this, 'closingBalance') as double?;
//   @override
//   set closingBalance(double? value) =>
//       RealmObjectBase.set(this, 'closingBalance', value);

//   @override
//   String? get openingDateTime =>
//       RealmObjectBase.get<String>(this, 'openingDateTime') as String?;
//   @override
//   set openingDateTime(String? value) =>
//       RealmObjectBase.set(this, 'openingDateTime', value);

//   @override
//   String? get closingDateTime =>
//       RealmObjectBase.get<String>(this, 'closingDateTime') as String?;
//   @override
//   set closingDateTime(String? value) =>
//       RealmObjectBase.set(this, 'closingDateTime', value);

//   @override
//   int? get csSaleCount => RealmObjectBase.get<int>(this, 'csSaleCount') as int?;
//   @override
//   set csSaleCount(int? value) =>
//       RealmObjectBase.set(this, 'csSaleCount', value);

//   @override
//   String? get tradeName =>
//       RealmObjectBase.get<String>(this, 'tradeName') as String?;
//   @override
//   set tradeName(String? value) => RealmObjectBase.set(this, 'tradeName', value);

//   @override
//   double? get totalNsSaleIncome =>
//       RealmObjectBase.get<double>(this, 'totalNsSaleIncome') as double?;
//   @override
//   set totalNsSaleIncome(double? value) =>
//       RealmObjectBase.set(this, 'totalNsSaleIncome', value);

//   @override
//   double? get totalCsSaleIncome =>
//       RealmObjectBase.get<double>(this, 'totalCsSaleIncome') as double?;
//   @override
//   set totalCsSaleIncome(double? value) =>
//       RealmObjectBase.set(this, 'totalCsSaleIncome', value);

//   @override
//   int? get nrSaleCount => RealmObjectBase.get<int>(this, 'nrSaleCount') as int?;
//   @override
//   set nrSaleCount(int? value) =>
//       RealmObjectBase.set(this, 'nrSaleCount', value);

//   @override
//   int? get nsSaleCount => RealmObjectBase.get<int>(this, 'nsSaleCount') as int?;
//   @override
//   set nsSaleCount(int? value) =>
//       RealmObjectBase.set(this, 'nsSaleCount', value);

//   @override
//   int? get trSaleCount => RealmObjectBase.get<int>(this, 'trSaleCount') as int?;
//   @override
//   set trSaleCount(int? value) =>
//       RealmObjectBase.set(this, 'trSaleCount', value);

//   @override
//   int? get psSaleCount => RealmObjectBase.get<int>(this, 'psSaleCount') as int?;
//   @override
//   set psSaleCount(int? value) =>
//       RealmObjectBase.set(this, 'psSaleCount', value);

//   @override
//   int? get incompleteSale =>
//       RealmObjectBase.get<int>(this, 'incompleteSale') as int?;
//   @override
//   set incompleteSale(int? value) =>
//       RealmObjectBase.set(this, 'incompleteSale', value);

//   @override
//   int? get otherTransactions =>
//       RealmObjectBase.get<int>(this, 'otherTransactions') as int?;
//   @override
//   set otherTransactions(int? value) =>
//       RealmObjectBase.set(this, 'otherTransactions', value);

//   @override
//   String? get paymentMode =>
//       RealmObjectBase.get<String>(this, 'paymentMode') as String?;
//   @override
//   set paymentMode(String? value) =>
//       RealmObjectBase.set(this, 'paymentMode', value);

//   @override
//   int? get cashierId => RealmObjectBase.get<int>(this, 'cashierId') as int?;
//   @override
//   set cashierId(int? value) => RealmObjectBase.set(this, 'cashierId', value);

//   @override
//   bool? get open => RealmObjectBase.get<bool>(this, 'open') as bool?;
//   @override
//   set open(bool? value) => RealmObjectBase.set(this, 'open', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   Stream<RealmObjectChanges<Drawers>> get changes =>
//       RealmObjectBase.getChanges<Drawers>(this);

//   @override
//   Stream<RealmObjectChanges<Drawers>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Drawers>(this, keyPaths);

//   @override
//   Drawers freeze() => RealmObjectBase.freezeObject<Drawers>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       '_id': realmId,
//       'id': id,
//       'openingBalance': openingBalance,
//       'closingBalance': closingBalance,
//       'openingDateTime': openingDateTime,
//       'closingDateTime': closingDateTime,
//       'csSaleCount': csSaleCount,
//       'tradeName': tradeName,
//       'totalNsSaleIncome': totalNsSaleIncome,
//       'totalCsSaleIncome': totalCsSaleIncome,
//       'nrSaleCount': nrSaleCount,
//       'nsSaleCount': nsSaleCount,
//       'trSaleCount': trSaleCount,
//       'psSaleCount': psSaleCount,
//       'incompleteSale': incompleteSale,
//       'otherTransactions': otherTransactions,
//       'paymentMode': paymentMode,
//       'cashierId': cashierId,
//       'open': open,
//       'deletedAt': deletedAt,
//       'businessId': businessId,
//       'branchId': branchId,
//     };
//   }

//   static EJsonValue _toEJson(Drawers value) => value;
//   static Drawers _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Drawers(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           openingBalance: fromEJson(ejson['openingBalance']),
//           closingBalance: fromEJson(ejson['closingBalance']),
//           openingDateTime: fromEJson(ejson['openingDateTime']),
//           closingDateTime: fromEJson(ejson['closingDateTime']),
//           csSaleCount: fromEJson(ejson['csSaleCount']),
//           tradeName: fromEJson(ejson['tradeName']),
//           totalNsSaleIncome: fromEJson(ejson['totalNsSaleIncome']),
//           totalCsSaleIncome: fromEJson(ejson['totalCsSaleIncome']),
//           nrSaleCount: fromEJson(ejson['nrSaleCount']),
//           nsSaleCount: fromEJson(ejson['nsSaleCount']),
//           trSaleCount: fromEJson(ejson['trSaleCount']),
//           psSaleCount: fromEJson(ejson['psSaleCount']),
//           incompleteSale: fromEJson(ejson['incompleteSale']),
//           otherTransactions: fromEJson(ejson['otherTransactions']),
//           paymentMode: fromEJson(ejson['paymentMode']),
//           cashierId: fromEJson(ejson['cashierId']),
//           open: fromEJson(ejson['open']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           businessId: fromEJson(ejson['businessId']),
//           branchId: fromEJson(ejson['branchId']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Drawers._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Drawers, 'Drawers', [
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('openingBalance', RealmPropertyType.double,
//           optional: true),
//       SchemaProperty('closingBalance', RealmPropertyType.double,
//           optional: true),
//       SchemaProperty('openingDateTime', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('closingDateTime', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('csSaleCount', RealmPropertyType.int, optional: true),
//       SchemaProperty('tradeName', RealmPropertyType.string, optional: true),
//       SchemaProperty('totalNsSaleIncome', RealmPropertyType.double,
//           optional: true),
//       SchemaProperty('totalCsSaleIncome', RealmPropertyType.double,
//           optional: true),
//       SchemaProperty('nrSaleCount', RealmPropertyType.int, optional: true),
//       SchemaProperty('nsSaleCount', RealmPropertyType.int, optional: true),
//       SchemaProperty('trSaleCount', RealmPropertyType.int, optional: true),
//       SchemaProperty('psSaleCount', RealmPropertyType.int, optional: true),
//       SchemaProperty('incompleteSale', RealmPropertyType.int, optional: true),
//       SchemaProperty('otherTransactions', RealmPropertyType.int,
//           optional: true),
//       SchemaProperty('paymentMode', RealmPropertyType.string, optional: true),
//       SchemaProperty('cashierId', RealmPropertyType.int, optional: true),
//       SchemaProperty('open', RealmPropertyType.bool, optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class EBM extends _EBM with RealmEntity, RealmObjectBase, RealmObject {
//   EBM(
//     ObjectId realmId,
//     String bhfId,
//     int tinNumber,
//     String dvcSrlNo,
//     int userId,
//     int businessId,
//     int branchId,
//     String action, {
//     int? id,
//     String? taxServerUrl,
//     DateTime? lastTouched,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'bhfId', bhfId);
//     RealmObjectBase.set(this, 'tinNumber', tinNumber);
//     RealmObjectBase.set(this, 'dvcSrlNo', dvcSrlNo);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'taxServerUrl', taxServerUrl);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'action', action);
//   }

//   EBM._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String;
//   @override
//   set bhfId(String value) => RealmObjectBase.set(this, 'bhfId', value);

//   @override
//   int get tinNumber => RealmObjectBase.get<int>(this, 'tinNumber') as int;
//   @override
//   set tinNumber(int value) => RealmObjectBase.set(this, 'tinNumber', value);

//   @override
//   String get dvcSrlNo =>
//       RealmObjectBase.get<String>(this, 'dvcSrlNo') as String;
//   @override
//   set dvcSrlNo(String value) => RealmObjectBase.set(this, 'dvcSrlNo', value);

//   @override
//   int get userId => RealmObjectBase.get<int>(this, 'userId') as int;
//   @override
//   set userId(int value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get taxServerUrl =>
//       RealmObjectBase.get<String>(this, 'taxServerUrl') as String?;
//   @override
//   set taxServerUrl(String? value) =>
//       RealmObjectBase.set(this, 'taxServerUrl', value);

//   @override
//   int get businessId => RealmObjectBase.get<int>(this, 'businessId') as int;
//   @override
//   set businessId(int value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
//   @override
//   set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   String get action => RealmObjectBase.get<String>(this, 'action') as String;
//   @override
//   set action(String value) => RealmObjectBase.set(this, 'action', value);

//   @override
//   Stream<RealmObjectChanges<EBM>> get changes =>
//       RealmObjectBase.getChanges<EBM>(this);

//   @override
//   Stream<RealmObjectChanges<EBM>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<EBM>(this, keyPaths);

//   @override
//   EBM freeze() => RealmObjectBase.freezeObject<EBM>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'bhfId': bhfId,
//       'tinNumber': tinNumber,
//       'dvcSrlNo': dvcSrlNo,
//       'userId': userId,
//       'taxServerUrl': taxServerUrl,
//       'businessId': businessId,
//       'branchId': branchId,
//       'lastTouched': lastTouched,
//       'action': action,
//     };
//   }

//   static EJsonValue _toEJson(EBM value) => value;
//   static EBM _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//         'bhfId': EJsonValue bhfId,
//         'tinNumber': EJsonValue tinNumber,
//         'dvcSrlNo': EJsonValue dvcSrlNo,
//         'userId': EJsonValue userId,
//         'businessId': EJsonValue businessId,
//         'branchId': EJsonValue branchId,
//         'action': EJsonValue action,
//       } =>
//         EBM(
//           fromEJson(realmId),
//           fromEJson(bhfId),
//           fromEJson(tinNumber),
//           fromEJson(dvcSrlNo),
//           fromEJson(userId),
//           fromEJson(businessId),
//           fromEJson(branchId),
//           fromEJson(action),
//           id: fromEJson(ejson['id']),
//           taxServerUrl: fromEJson(ejson['taxServerUrl']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(EBM._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, EBM, 'EBM', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('bhfId', RealmPropertyType.string),
//       SchemaProperty('tinNumber', RealmPropertyType.int),
//       SchemaProperty('dvcSrlNo', RealmPropertyType.string),
//       SchemaProperty('userId', RealmPropertyType.int),
//       SchemaProperty('taxServerUrl', RealmPropertyType.string, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int),
//       SchemaProperty('branchId', RealmPropertyType.int),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('action', RealmPropertyType.string),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Favorite extends _Favorite
//     with RealmEntity, RealmObjectBase, RealmObject {
//   Favorite(
//     ObjectId realmId, {
//     int? id,
//     int? favIndex,
//     int? productId,
//     int? branchId,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'favIndex', favIndex);
//     RealmObjectBase.set(this, 'productId', productId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   Favorite._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get favIndex => RealmObjectBase.get<int>(this, 'favIndex') as int?;
//   @override
//   set favIndex(int? value) => RealmObjectBase.set(this, 'favIndex', value);

//   @override
//   int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
//   @override
//   set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<Favorite>> get changes =>
//       RealmObjectBase.getChanges<Favorite>(this);

//   @override
//   Stream<RealmObjectChanges<Favorite>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Favorite>(this, keyPaths);

//   @override
//   Favorite freeze() => RealmObjectBase.freezeObject<Favorite>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'favIndex': favIndex,
//       'productId': productId,
//       'branchId': branchId,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(Favorite value) => value;
//   static Favorite _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Favorite(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           favIndex: fromEJson(ejson['favIndex']),
//           productId: fromEJson(ejson['productId']),
//           branchId: fromEJson(ejson['branchId']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Favorite._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Favorite, 'Favorite', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('favIndex', RealmPropertyType.int, optional: true),
//       SchemaProperty('productId', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Product(
//     ObjectId realmId, {
//     int? id,
//     String? name,
//     String? description,
//     String? taxId,
//     String color = "#e74c3c",
//     int? businessId,
//     int? branchId,
//     String? supplierId,
//     int? categoryId,
//     String? createdAt,
//     String? unit,
//     String? imageUrl,
//     String? expiryDate,
//     String? barCode,
//     bool nfcEnabled = false,
//     int? bindedToTenantId,
//     bool isFavorite = false,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     String? spplrNm,
//     bool? isComposite = false,
//     Iterable<Composite> composites = const [],
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Product>({
//         'color': "#e74c3c",
//         'nfcEnabled': false,
//         'isFavorite': false,
//         'isComposite': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'description', description);
//     RealmObjectBase.set(this, 'taxId', taxId);
//     RealmObjectBase.set(this, 'color', color);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'supplierId', supplierId);
//     RealmObjectBase.set(this, 'categoryId', categoryId);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'unit', unit);
//     RealmObjectBase.set(this, 'imageUrl', imageUrl);
//     RealmObjectBase.set(this, 'expiryDate', expiryDate);
//     RealmObjectBase.set(this, 'barCode', barCode);
//     RealmObjectBase.set(this, 'nfcEnabled', nfcEnabled);
//     RealmObjectBase.set(this, 'bindedToTenantId', bindedToTenantId);
//     RealmObjectBase.set(this, 'isFavorite', isFavorite);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'spplrNm', spplrNm);
//     RealmObjectBase.set(this, 'isComposite', isComposite);
//     RealmObjectBase.set<RealmList<Composite>>(
//         this, 'composites', RealmList<Composite>(composites));
//   }

//   Product._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   String? get description =>
//       RealmObjectBase.get<String>(this, 'description') as String?;
//   @override
//   set description(String? value) =>
//       RealmObjectBase.set(this, 'description', value);

//   @override
//   String? get taxId => RealmObjectBase.get<String>(this, 'taxId') as String?;
//   @override
//   set taxId(String? value) => RealmObjectBase.set(this, 'taxId', value);

//   @override
//   String get color => RealmObjectBase.get<String>(this, 'color') as String;
//   @override
//   set color(String value) => RealmObjectBase.set(this, 'color', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   String? get supplierId =>
//       RealmObjectBase.get<String>(this, 'supplierId') as String?;
//   @override
//   set supplierId(String? value) =>
//       RealmObjectBase.set(this, 'supplierId', value);

//   @override
//   int? get categoryId => RealmObjectBase.get<int>(this, 'categoryId') as int?;
//   @override
//   set categoryId(int? value) => RealmObjectBase.set(this, 'categoryId', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
//   @override
//   set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

//   @override
//   String? get imageUrl =>
//       RealmObjectBase.get<String>(this, 'imageUrl') as String?;
//   @override
//   set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

//   @override
//   String? get expiryDate =>
//       RealmObjectBase.get<String>(this, 'expiryDate') as String?;
//   @override
//   set expiryDate(String? value) =>
//       RealmObjectBase.set(this, 'expiryDate', value);

//   @override
//   String? get barCode =>
//       RealmObjectBase.get<String>(this, 'barCode') as String?;
//   @override
//   set barCode(String? value) => RealmObjectBase.set(this, 'barCode', value);

//   @override
//   bool get nfcEnabled => RealmObjectBase.get<bool>(this, 'nfcEnabled') as bool;
//   @override
//   set nfcEnabled(bool value) => RealmObjectBase.set(this, 'nfcEnabled', value);

//   @override
//   int? get bindedToTenantId =>
//       RealmObjectBase.get<int>(this, 'bindedToTenantId') as int?;
//   @override
//   set bindedToTenantId(int? value) =>
//       RealmObjectBase.set(this, 'bindedToTenantId', value);

//   @override
//   bool get isFavorite => RealmObjectBase.get<bool>(this, 'isFavorite') as bool;
//   @override
//   set isFavorite(bool value) => RealmObjectBase.set(this, 'isFavorite', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   String? get spplrNm =>
//       RealmObjectBase.get<String>(this, 'spplrNm') as String?;
//   @override
//   set spplrNm(String? value) => RealmObjectBase.set(this, 'spplrNm', value);

//   @override
//   bool? get isComposite =>
//       RealmObjectBase.get<bool>(this, 'isComposite') as bool?;
//   @override
//   set isComposite(bool? value) =>
//       RealmObjectBase.set(this, 'isComposite', value);

//   @override
//   RealmList<Composite> get composites =>
//       RealmObjectBase.get<Composite>(this, 'composites')
//           as RealmList<Composite>;
//   @override
//   set composites(covariant RealmList<Composite> value) =>
//       throw RealmUnsupportedSetError();

//   @override
//   Stream<RealmObjectChanges<Product>> get changes =>
//       RealmObjectBase.getChanges<Product>(this);

//   @override
//   Stream<RealmObjectChanges<Product>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Product>(this, keyPaths);

//   @override
//   Product freeze() => RealmObjectBase.freezeObject<Product>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'name': name,
//       'description': description,
//       'taxId': taxId,
//       'color': color,
//       'businessId': businessId,
//       'branchId': branchId,
//       'supplierId': supplierId,
//       'categoryId': categoryId,
//       'createdAt': createdAt,
//       'unit': unit,
//       'imageUrl': imageUrl,
//       'expiryDate': expiryDate,
//       'barCode': barCode,
//       'nfcEnabled': nfcEnabled,
//       'bindedToTenantId': bindedToTenantId,
//       'isFavorite': isFavorite,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'spplrNm': spplrNm,
//       'isComposite': isComposite,
//       'composites': composites,
//     };
//   }

//   static EJsonValue _toEJson(Product value) => value;
//   static Product _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Product(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           name: fromEJson(ejson['name']),
//           description: fromEJson(ejson['description']),
//           taxId: fromEJson(ejson['taxId']),
//           color: fromEJson(ejson['color'], defaultValue: "#e74c3c"),
//           businessId: fromEJson(ejson['businessId']),
//           branchId: fromEJson(ejson['branchId']),
//           supplierId: fromEJson(ejson['supplierId']),
//           categoryId: fromEJson(ejson['categoryId']),
//           createdAt: fromEJson(ejson['createdAt']),
//           unit: fromEJson(ejson['unit']),
//           imageUrl: fromEJson(ejson['imageUrl']),
//           expiryDate: fromEJson(ejson['expiryDate']),
//           barCode: fromEJson(ejson['barCode']),
//           nfcEnabled: fromEJson(ejson['nfcEnabled'], defaultValue: false),
//           bindedToTenantId: fromEJson(ejson['bindedToTenantId']),
//           isFavorite: fromEJson(ejson['isFavorite'], defaultValue: false),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           spplrNm: fromEJson(ejson['spplrNm']),
//           isComposite: fromEJson(ejson['isComposite'], defaultValue: false),
//           composites: fromEJson(ejson['composites'], defaultValue: const []),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Product._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Product, 'Product', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('description', RealmPropertyType.string, optional: true),
//       SchemaProperty('taxId', RealmPropertyType.string, optional: true),
//       SchemaProperty('color', RealmPropertyType.string),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('supplierId', RealmPropertyType.string, optional: true),
//       SchemaProperty('categoryId', RealmPropertyType.int, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('unit', RealmPropertyType.string, optional: true),
//       SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
//       SchemaProperty('expiryDate', RealmPropertyType.string, optional: true),
//       SchemaProperty('barCode', RealmPropertyType.string, optional: true),
//       SchemaProperty('nfcEnabled', RealmPropertyType.bool),
//       SchemaProperty('bindedToTenantId', RealmPropertyType.int, optional: true),
//       SchemaProperty('isFavorite', RealmPropertyType.bool),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('spplrNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('isComposite', RealmPropertyType.bool, optional: true),
//       SchemaProperty('composites', RealmPropertyType.object,
//           linkTarget: 'Composite', collectionType: RealmCollectionType.list),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Receipt extends _Receipt with RealmEntity, RealmObjectBase, RealmObject {
//   Receipt(
//     ObjectId realmId, {
//     int? id,
//     String? resultCd,
//     String? resultMsg,
//     String? resultDt,
//     int? rcptNo,
//     String? intrlData,
//     String? rcptSign,
//     int? totRcptNo,
//     String? vsdcRcptPbctDate,
//     String? sdcId,
//     String? mrcNo,
//     String? qrCode,
//     String? receiptType,
//     int? branchId,
//     int? transactionId,
//     DateTime? lastTouched,
//     int? invcNo,
//     DateTime? whenCreated,
//     int? invoiceNumber,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'resultCd', resultCd);
//     RealmObjectBase.set(this, 'resultMsg', resultMsg);
//     RealmObjectBase.set(this, 'resultDt', resultDt);
//     RealmObjectBase.set(this, 'rcptNo', rcptNo);
//     RealmObjectBase.set(this, 'intrlData', intrlData);
//     RealmObjectBase.set(this, 'rcptSign', rcptSign);
//     RealmObjectBase.set(this, 'totRcptNo', totRcptNo);
//     RealmObjectBase.set(this, 'vsdcRcptPbctDate', vsdcRcptPbctDate);
//     RealmObjectBase.set(this, 'sdcId', sdcId);
//     RealmObjectBase.set(this, 'mrcNo', mrcNo);
//     RealmObjectBase.set(this, 'qrCode', qrCode);
//     RealmObjectBase.set(this, 'receiptType', receiptType);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'transactionId', transactionId);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'invcNo', invcNo);
//     RealmObjectBase.set(this, 'whenCreated', whenCreated);
//     RealmObjectBase.set(this, 'invoiceNumber', invoiceNumber);
//   }

//   Receipt._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get resultCd =>
//       RealmObjectBase.get<String>(this, 'resultCd') as String?;
//   @override
//   set resultCd(String? value) => RealmObjectBase.set(this, 'resultCd', value);

//   @override
//   String? get resultMsg =>
//       RealmObjectBase.get<String>(this, 'resultMsg') as String?;
//   @override
//   set resultMsg(String? value) => RealmObjectBase.set(this, 'resultMsg', value);

//   @override
//   String? get resultDt =>
//       RealmObjectBase.get<String>(this, 'resultDt') as String?;
//   @override
//   set resultDt(String? value) => RealmObjectBase.set(this, 'resultDt', value);

//   @override
//   int? get rcptNo => RealmObjectBase.get<int>(this, 'rcptNo') as int?;
//   @override
//   set rcptNo(int? value) => RealmObjectBase.set(this, 'rcptNo', value);

//   @override
//   String? get intrlData =>
//       RealmObjectBase.get<String>(this, 'intrlData') as String?;
//   @override
//   set intrlData(String? value) => RealmObjectBase.set(this, 'intrlData', value);

//   @override
//   String? get rcptSign =>
//       RealmObjectBase.get<String>(this, 'rcptSign') as String?;
//   @override
//   set rcptSign(String? value) => RealmObjectBase.set(this, 'rcptSign', value);

//   @override
//   int? get totRcptNo => RealmObjectBase.get<int>(this, 'totRcptNo') as int?;
//   @override
//   set totRcptNo(int? value) => RealmObjectBase.set(this, 'totRcptNo', value);

//   @override
//   String? get vsdcRcptPbctDate =>
//       RealmObjectBase.get<String>(this, 'vsdcRcptPbctDate') as String?;
//   @override
//   set vsdcRcptPbctDate(String? value) =>
//       RealmObjectBase.set(this, 'vsdcRcptPbctDate', value);

//   @override
//   String? get sdcId => RealmObjectBase.get<String>(this, 'sdcId') as String?;
//   @override
//   set sdcId(String? value) => RealmObjectBase.set(this, 'sdcId', value);

//   @override
//   String? get mrcNo => RealmObjectBase.get<String>(this, 'mrcNo') as String?;
//   @override
//   set mrcNo(String? value) => RealmObjectBase.set(this, 'mrcNo', value);

//   @override
//   String? get qrCode => RealmObjectBase.get<String>(this, 'qrCode') as String?;
//   @override
//   set qrCode(String? value) => RealmObjectBase.set(this, 'qrCode', value);

//   @override
//   String? get receiptType =>
//       RealmObjectBase.get<String>(this, 'receiptType') as String?;
//   @override
//   set receiptType(String? value) =>
//       RealmObjectBase.set(this, 'receiptType', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get transactionId =>
//       RealmObjectBase.get<int>(this, 'transactionId') as int?;
//   @override
//   set transactionId(int? value) =>
//       RealmObjectBase.set(this, 'transactionId', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   int? get invcNo => RealmObjectBase.get<int>(this, 'invcNo') as int?;
//   @override
//   set invcNo(int? value) => RealmObjectBase.set(this, 'invcNo', value);

//   @override
//   DateTime? get whenCreated =>
//       RealmObjectBase.get<DateTime>(this, 'whenCreated') as DateTime?;
//   @override
//   set whenCreated(DateTime? value) =>
//       RealmObjectBase.set(this, 'whenCreated', value);

//   @override
//   int? get invoiceNumber =>
//       RealmObjectBase.get<int>(this, 'invoiceNumber') as int?;
//   @override
//   set invoiceNumber(int? value) =>
//       RealmObjectBase.set(this, 'invoiceNumber', value);

//   @override
//   Stream<RealmObjectChanges<Receipt>> get changes =>
//       RealmObjectBase.getChanges<Receipt>(this);

//   @override
//   Stream<RealmObjectChanges<Receipt>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Receipt>(this, keyPaths);

//   @override
//   Receipt freeze() => RealmObjectBase.freezeObject<Receipt>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'resultCd': resultCd,
//       'resultMsg': resultMsg,
//       'resultDt': resultDt,
//       'rcptNo': rcptNo,
//       'intrlData': intrlData,
//       'rcptSign': rcptSign,
//       'totRcptNo': totRcptNo,
//       'vsdcRcptPbctDate': vsdcRcptPbctDate,
//       'sdcId': sdcId,
//       'mrcNo': mrcNo,
//       'qrCode': qrCode,
//       'receiptType': receiptType,
//       'branchId': branchId,
//       'transactionId': transactionId,
//       'lastTouched': lastTouched,
//       'invcNo': invcNo,
//       'whenCreated': whenCreated,
//       'invoiceNumber': invoiceNumber,
//     };
//   }

//   static EJsonValue _toEJson(Receipt value) => value;
//   static Receipt _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Receipt(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           resultCd: fromEJson(ejson['resultCd']),
//           resultMsg: fromEJson(ejson['resultMsg']),
//           resultDt: fromEJson(ejson['resultDt']),
//           rcptNo: fromEJson(ejson['rcptNo']),
//           intrlData: fromEJson(ejson['intrlData']),
//           rcptSign: fromEJson(ejson['rcptSign']),
//           totRcptNo: fromEJson(ejson['totRcptNo']),
//           vsdcRcptPbctDate: fromEJson(ejson['vsdcRcptPbctDate']),
//           sdcId: fromEJson(ejson['sdcId']),
//           mrcNo: fromEJson(ejson['mrcNo']),
//           qrCode: fromEJson(ejson['qrCode']),
//           receiptType: fromEJson(ejson['receiptType']),
//           branchId: fromEJson(ejson['branchId']),
//           transactionId: fromEJson(ejson['transactionId']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           invcNo: fromEJson(ejson['invcNo']),
//           whenCreated: fromEJson(ejson['whenCreated']),
//           invoiceNumber: fromEJson(ejson['invoiceNumber']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Receipt._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Receipt, 'Receipt', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('resultCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('resultMsg', RealmPropertyType.string, optional: true),
//       SchemaProperty('resultDt', RealmPropertyType.string, optional: true),
//       SchemaProperty('rcptNo', RealmPropertyType.int, optional: true),
//       SchemaProperty('intrlData', RealmPropertyType.string, optional: true),
//       SchemaProperty('rcptSign', RealmPropertyType.string, optional: true),
//       SchemaProperty('totRcptNo', RealmPropertyType.int, optional: true),
//       SchemaProperty('vsdcRcptPbctDate', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('sdcId', RealmPropertyType.string, optional: true),
//       SchemaProperty('mrcNo', RealmPropertyType.string, optional: true),
//       SchemaProperty('qrCode', RealmPropertyType.string, optional: true),
//       SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('transactionId', RealmPropertyType.int, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('invcNo', RealmPropertyType.int, optional: true),
//       SchemaProperty('whenCreated', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('invoiceNumber', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Setting extends _Setting with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Setting(
//     ObjectId realmId, {
//     int? id,
//     String? email,
//     int? userId,
//     bool? openReceiptFileOSaleComplete,
//     bool? autoPrint,
//     bool? sendDailyReport,
//     String? defaultLanguage,
//     bool? attendnaceDocCreated,
//     bool? isAttendanceEnabled,
//     String? type,
//     bool? enrolledInBot,
//     String? deviceToken,
//     String? businessPhoneNumber,
//     bool? autoRespond,
//     String? token,
//     bool hasPin = false,
//     int? businessId,
//     String? createdAt,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Setting>({
//         'hasPin': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'email', email);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(
//         this, 'openReceiptFileOSaleComplete', openReceiptFileOSaleComplete);
//     RealmObjectBase.set(this, 'autoPrint', autoPrint);
//     RealmObjectBase.set(this, 'sendDailyReport', sendDailyReport);
//     RealmObjectBase.set(this, 'defaultLanguage', defaultLanguage);
//     RealmObjectBase.set(this, 'attendnaceDocCreated', attendnaceDocCreated);
//     RealmObjectBase.set(this, 'isAttendanceEnabled', isAttendanceEnabled);
//     RealmObjectBase.set(this, 'type', type);
//     RealmObjectBase.set(this, 'enrolledInBot', enrolledInBot);
//     RealmObjectBase.set(this, 'deviceToken', deviceToken);
//     RealmObjectBase.set(this, 'businessPhoneNumber', businessPhoneNumber);
//     RealmObjectBase.set(this, 'autoRespond', autoRespond);
//     RealmObjectBase.set(this, 'token', token);
//     RealmObjectBase.set(this, 'hasPin', hasPin);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   Setting._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
//   @override
//   set email(String? value) => RealmObjectBase.set(this, 'email', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   bool? get openReceiptFileOSaleComplete =>
//       RealmObjectBase.get<bool>(this, 'openReceiptFileOSaleComplete') as bool?;
//   @override
//   set openReceiptFileOSaleComplete(bool? value) =>
//       RealmObjectBase.set(this, 'openReceiptFileOSaleComplete', value);

//   @override
//   bool? get autoPrint => RealmObjectBase.get<bool>(this, 'autoPrint') as bool?;
//   @override
//   set autoPrint(bool? value) => RealmObjectBase.set(this, 'autoPrint', value);

//   @override
//   bool? get sendDailyReport =>
//       RealmObjectBase.get<bool>(this, 'sendDailyReport') as bool?;
//   @override
//   set sendDailyReport(bool? value) =>
//       RealmObjectBase.set(this, 'sendDailyReport', value);

//   @override
//   String? get defaultLanguage =>
//       RealmObjectBase.get<String>(this, 'defaultLanguage') as String?;
//   @override
//   set defaultLanguage(String? value) =>
//       RealmObjectBase.set(this, 'defaultLanguage', value);

//   @override
//   bool? get attendnaceDocCreated =>
//       RealmObjectBase.get<bool>(this, 'attendnaceDocCreated') as bool?;
//   @override
//   set attendnaceDocCreated(bool? value) =>
//       RealmObjectBase.set(this, 'attendnaceDocCreated', value);

//   @override
//   bool? get isAttendanceEnabled =>
//       RealmObjectBase.get<bool>(this, 'isAttendanceEnabled') as bool?;
//   @override
//   set isAttendanceEnabled(bool? value) =>
//       RealmObjectBase.set(this, 'isAttendanceEnabled', value);

//   @override
//   String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
//   @override
//   set type(String? value) => RealmObjectBase.set(this, 'type', value);

//   @override
//   bool? get enrolledInBot =>
//       RealmObjectBase.get<bool>(this, 'enrolledInBot') as bool?;
//   @override
//   set enrolledInBot(bool? value) =>
//       RealmObjectBase.set(this, 'enrolledInBot', value);

//   @override
//   String? get deviceToken =>
//       RealmObjectBase.get<String>(this, 'deviceToken') as String?;
//   @override
//   set deviceToken(String? value) =>
//       RealmObjectBase.set(this, 'deviceToken', value);

//   @override
//   String? get businessPhoneNumber =>
//       RealmObjectBase.get<String>(this, 'businessPhoneNumber') as String?;
//   @override
//   set businessPhoneNumber(String? value) =>
//       RealmObjectBase.set(this, 'businessPhoneNumber', value);

//   @override
//   bool? get autoRespond =>
//       RealmObjectBase.get<bool>(this, 'autoRespond') as bool?;
//   @override
//   set autoRespond(bool? value) =>
//       RealmObjectBase.set(this, 'autoRespond', value);

//   @override
//   String? get token => RealmObjectBase.get<String>(this, 'token') as String?;
//   @override
//   set token(String? value) => RealmObjectBase.set(this, 'token', value);

//   @override
//   bool get hasPin => RealmObjectBase.get<bool>(this, 'hasPin') as bool;
//   @override
//   set hasPin(bool value) => RealmObjectBase.set(this, 'hasPin', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<Setting>> get changes =>
//       RealmObjectBase.getChanges<Setting>(this);

//   @override
//   Stream<RealmObjectChanges<Setting>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Setting>(this, keyPaths);

//   @override
//   Setting freeze() => RealmObjectBase.freezeObject<Setting>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'email': email,
//       'userId': userId,
//       'openReceiptFileOSaleComplete': openReceiptFileOSaleComplete,
//       'autoPrint': autoPrint,
//       'sendDailyReport': sendDailyReport,
//       'defaultLanguage': defaultLanguage,
//       'attendnaceDocCreated': attendnaceDocCreated,
//       'isAttendanceEnabled': isAttendanceEnabled,
//       'type': type,
//       'enrolledInBot': enrolledInBot,
//       'deviceToken': deviceToken,
//       'businessPhoneNumber': businessPhoneNumber,
//       'autoRespond': autoRespond,
//       'token': token,
//       'hasPin': hasPin,
//       'businessId': businessId,
//       'createdAt': createdAt,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(Setting value) => value;
//   static Setting _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Setting(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           email: fromEJson(ejson['email']),
//           userId: fromEJson(ejson['userId']),
//           openReceiptFileOSaleComplete:
//               fromEJson(ejson['openReceiptFileOSaleComplete']),
//           autoPrint: fromEJson(ejson['autoPrint']),
//           sendDailyReport: fromEJson(ejson['sendDailyReport']),
//           defaultLanguage: fromEJson(ejson['defaultLanguage']),
//           attendnaceDocCreated: fromEJson(ejson['attendnaceDocCreated']),
//           isAttendanceEnabled: fromEJson(ejson['isAttendanceEnabled']),
//           type: fromEJson(ejson['type']),
//           enrolledInBot: fromEJson(ejson['enrolledInBot']),
//           deviceToken: fromEJson(ejson['deviceToken']),
//           businessPhoneNumber: fromEJson(ejson['businessPhoneNumber']),
//           autoRespond: fromEJson(ejson['autoRespond']),
//           token: fromEJson(ejson['token']),
//           hasPin: fromEJson(ejson['hasPin'], defaultValue: false),
//           businessId: fromEJson(ejson['businessId']),
//           createdAt: fromEJson(ejson['createdAt']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Setting._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Setting, 'Setting', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('email', RealmPropertyType.string, optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('openReceiptFileOSaleComplete', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('autoPrint', RealmPropertyType.bool, optional: true),
//       SchemaProperty('sendDailyReport', RealmPropertyType.bool, optional: true),
//       SchemaProperty('defaultLanguage', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('attendnaceDocCreated', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('isAttendanceEnabled', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('type', RealmPropertyType.string, optional: true),
//       SchemaProperty('enrolledInBot', RealmPropertyType.bool, optional: true),
//       SchemaProperty('deviceToken', RealmPropertyType.string, optional: true),
//       SchemaProperty('businessPhoneNumber', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('autoRespond', RealmPropertyType.bool, optional: true),
//       SchemaProperty('token', RealmPropertyType.string, optional: true),
//       SchemaProperty('hasPin', RealmPropertyType.bool),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Stock extends _Stock with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Stock(
//     ObjectId? realmId, {
//     int? id,
//     int? tin,
//     String? bhfId,
//     int? branchId,
//     int? variantId,
//     double currentStock = 0.0,
//     double lowStock = 0,
//     bool? canTrackingStock = true,
//     bool? showLowStockAlert = true,
//     int? productId,
//     bool? active,
//     double value = 0.0,
//     double rsdQty = 0.0,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     bool ebmSynced = false,
//     bool cloudSynced = true,
//     Variant? variant,
//     double? initialStock,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Stock>({
//         'currentStock': 0.0,
//         'lowStock': 0,
//         'canTrackingStock': true,
//         'showLowStockAlert': true,
//         'value': 0.0,
//         'rsdQty': 0.0,
//         'ebmSynced': false,
//         'cloudSynced': true,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'tin', tin);
//     RealmObjectBase.set(this, 'bhfId', bhfId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'variantId', variantId);
//     RealmObjectBase.set(this, 'currentStock', currentStock);
//     RealmObjectBase.set(this, 'lowStock', lowStock);
//     RealmObjectBase.set(this, 'canTrackingStock', canTrackingStock);
//     RealmObjectBase.set(this, 'showLowStockAlert', showLowStockAlert);
//     RealmObjectBase.set(this, 'productId', productId);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'value', value);
//     RealmObjectBase.set(this, 'rsdQty', rsdQty);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
//     RealmObjectBase.set(this, 'cloudSynced', cloudSynced);
//     RealmObjectBase.set(this, 'variant', variant);
//     RealmObjectBase.set(this, 'initialStock', initialStock);
//   }

//   Stock._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId? get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
//   @override
//   set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
//   @override
//   set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

//   @override
//   String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
//   @override
//   set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get variantId => RealmObjectBase.get<int>(this, 'variantId') as int?;
//   @override
//   set variantId(int? value) => RealmObjectBase.set(this, 'variantId', value);

//   @override
//   double get currentStock =>
//       RealmObjectBase.get<double>(this, 'currentStock') as double;
//   @override
//   set currentStock(double value) =>
//       RealmObjectBase.set(this, 'currentStock', value);

//   @override
//   double get lowStock =>
//       RealmObjectBase.get<double>(this, 'lowStock') as double;
//   @override
//   set lowStock(double value) => RealmObjectBase.set(this, 'lowStock', value);

//   @override
//   bool? get canTrackingStock =>
//       RealmObjectBase.get<bool>(this, 'canTrackingStock') as bool?;
//   @override
//   set canTrackingStock(bool? value) =>
//       RealmObjectBase.set(this, 'canTrackingStock', value);

//   @override
//   bool? get showLowStockAlert =>
//       RealmObjectBase.get<bool>(this, 'showLowStockAlert') as bool?;
//   @override
//   set showLowStockAlert(bool? value) =>
//       RealmObjectBase.set(this, 'showLowStockAlert', value);

//   @override
//   int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
//   @override
//   set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

//   @override
//   bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
//   @override
//   set active(bool? value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   double get value => RealmObjectBase.get<double>(this, 'value') as double;
//   @override
//   set value(double value) => RealmObjectBase.set(this, 'value', value);

//   @override
//   double get rsdQty => RealmObjectBase.get<double>(this, 'rsdQty') as double;
//   @override
//   set rsdQty(double value) => RealmObjectBase.set(this, 'rsdQty', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
//   @override
//   set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

//   @override
//   bool get cloudSynced =>
//       RealmObjectBase.get<bool>(this, 'cloudSynced') as bool;
//   @override
//   set cloudSynced(bool value) =>
//       RealmObjectBase.set(this, 'cloudSynced', value);

//   @override
//   Variant? get variant =>
//       RealmObjectBase.get<Variant>(this, 'variant') as Variant?;
//   @override
//   set variant(covariant Variant? value) =>
//       RealmObjectBase.set(this, 'variant', value);

//   @override
//   double? get initialStock =>
//       RealmObjectBase.get<double>(this, 'initialStock') as double?;
//   @override
//   set initialStock(double? value) =>
//       RealmObjectBase.set(this, 'initialStock', value);

//   @override
//   Stream<RealmObjectChanges<Stock>> get changes =>
//       RealmObjectBase.getChanges<Stock>(this);

//   @override
//   Stream<RealmObjectChanges<Stock>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Stock>(this, keyPaths);

//   @override
//   Stock freeze() => RealmObjectBase.freezeObject<Stock>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'tin': tin,
//       'bhfId': bhfId,
//       'branchId': branchId,
//       'variantId': variantId,
//       'currentStock': currentStock,
//       'lowStock': lowStock,
//       'canTrackingStock': canTrackingStock,
//       'showLowStockAlert': showLowStockAlert,
//       'productId': productId,
//       'active': active,
//       'value': value,
//       'rsdQty': rsdQty,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'ebmSynced': ebmSynced,
//       'cloudSynced': cloudSynced,
//       'variant': variant,
//       'initialStock': initialStock,
//     };
//   }

//   static EJsonValue _toEJson(Stock value) => value;
//   static Stock _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Stock(
//           fromEJson(ejson['_id']),
//           id: fromEJson(ejson['id']),
//           tin: fromEJson(ejson['tin']),
//           bhfId: fromEJson(ejson['bhfId']),
//           branchId: fromEJson(ejson['branchId']),
//           variantId: fromEJson(ejson['variantId']),
//           currentStock: fromEJson(ejson['currentStock'], defaultValue: 0.0),
//           lowStock: fromEJson(ejson['lowStock'], defaultValue: 0),
//           canTrackingStock:
//               fromEJson(ejson['canTrackingStock'], defaultValue: true),
//           showLowStockAlert:
//               fromEJson(ejson['showLowStockAlert'], defaultValue: true),
//           productId: fromEJson(ejson['productId']),
//           active: fromEJson(ejson['active']),
//           value: fromEJson(ejson['value'], defaultValue: 0.0),
//           rsdQty: fromEJson(ejson['rsdQty'], defaultValue: 0.0),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           ebmSynced: fromEJson(ejson['ebmSynced'], defaultValue: false),
//           cloudSynced: fromEJson(ejson['cloudSynced'], defaultValue: true),
//           variant: fromEJson(ejson['variant']),
//           initialStock: fromEJson(ejson['initialStock']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Stock._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Stock, 'Stock', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', optional: true, primaryKey: true),
//       SchemaProperty('tin', RealmPropertyType.int, optional: true),
//       SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('variantId', RealmPropertyType.int, optional: true),
//       SchemaProperty('currentStock', RealmPropertyType.double),
//       SchemaProperty('lowStock', RealmPropertyType.double),
//       SchemaProperty('canTrackingStock', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('showLowStockAlert', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('productId', RealmPropertyType.int, optional: true),
//       SchemaProperty('active', RealmPropertyType.bool, optional: true),
//       SchemaProperty('value', RealmPropertyType.double),
//       SchemaProperty('rsdQty', RealmPropertyType.double),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('ebmSynced', RealmPropertyType.bool),
//       SchemaProperty('cloudSynced', RealmPropertyType.bool),
//       SchemaProperty('variant', RealmPropertyType.object,
//           optional: true, linkTarget: 'Variant'),
//       SchemaProperty('initialStock', RealmPropertyType.double, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Variant extends _Variant with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Variant(
//     ObjectId realmId, {
//     int? id,
//     DateTime? deletedAt,
//     String? name,
//     String? color,
//     String? sku,
//     int? productId,
//     String? unit,
//     String? productName,
//     int? branchId,
//     String? taxName = "",
//     double taxPercentage = 0.0,
//     bool isTaxExempted = false,
//     int? itemSeq,
//     String? isrccCd = "",
//     String? isrccNm = "",
//     int? isrcRt = 0,
//     int? isrcAmt = 0,
//     String? taxTyCd = "B",
//     String? bcd = "",
//     String? itemClsCd,
//     String? itemTyCd,
//     String? itemStdNm = "",
//     String? orgnNatCd = "",
//     String? pkg = "1",
//     String? itemCd = "",
//     String? pkgUnitCd = "CT",
//     String? qtyUnitCd = "BX",
//     String? itemNm,
//     double qty = 0.0,
//     double prc = 0.0,
//     double splyAmt = 0.0,
//     int? tin,
//     String? bhfId,
//     double? dftPrc = 0,
//     String? addInfo = "",
//     String? isrcAplcbYn = "",
//     String? useYn = "",
//     String? regrId,
//     String? regrNm,
//     String? modrId,
//     String? modrNm,
//     DateTime? lastTouched,
//     double supplyPrice = 0.0,
//     double retailPrice = 0.0,
//     String? spplrItemClsCd,
//     String? spplrItemCd,
//     String? spplrItemNm,
//     bool ebmSynced = false,
//     String taxType = "B",
//     Iterable<int> branchIds = const [],
//     Stock? stock,
//     double dcRt = 0.0,
//     DateTime? expirationDate,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Variant>({
//         'taxName': "",
//         'taxPercentage': 0.0,
//         'isTaxExempted': false,
//         'isrccCd': "",
//         'isrccNm': "",
//         'isrcRt': 0,
//         'isrcAmt': 0,
//         'taxTyCd': "B",
//         'bcd': "",
//         'itemStdNm': "",
//         'orgnNatCd': "",
//         'pkg': "1",
//         'itemCd': "",
//         'pkgUnitCd': "CT",
//         'qtyUnitCd': "BX",
//         'qty': 0.0,
//         'prc': 0.0,
//         'splyAmt': 0.0,
//         'dftPrc': 0,
//         'addInfo': "",
//         'isrcAplcbYn': "",
//         'useYn': "",
//         'supplyPrice': 0.0,
//         'retailPrice': 0.0,
//         'ebmSynced': false,
//         'taxType': "B",
//         'dcRt': 0.0,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'color', color);
//     RealmObjectBase.set(this, 'sku', sku);
//     RealmObjectBase.set(this, 'productId', productId);
//     RealmObjectBase.set(this, 'unit', unit);
//     RealmObjectBase.set(this, 'productName', productName);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'taxName', taxName);
//     RealmObjectBase.set(this, 'taxPercentage', taxPercentage);
//     RealmObjectBase.set(this, 'isTaxExempted', isTaxExempted);
//     RealmObjectBase.set(this, 'itemSeq', itemSeq);
//     RealmObjectBase.set(this, 'isrccCd', isrccCd);
//     RealmObjectBase.set(this, 'isrccNm', isrccNm);
//     RealmObjectBase.set(this, 'isrcRt', isrcRt);
//     RealmObjectBase.set(this, 'isrcAmt', isrcAmt);
//     RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
//     RealmObjectBase.set(this, 'bcd', bcd);
//     RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
//     RealmObjectBase.set(this, 'itemTyCd', itemTyCd);
//     RealmObjectBase.set(this, 'itemStdNm', itemStdNm);
//     RealmObjectBase.set(this, 'orgnNatCd', orgnNatCd);
//     RealmObjectBase.set(this, 'pkg', pkg);
//     RealmObjectBase.set(this, 'itemCd', itemCd);
//     RealmObjectBase.set(this, 'pkgUnitCd', pkgUnitCd);
//     RealmObjectBase.set(this, 'qtyUnitCd', qtyUnitCd);
//     RealmObjectBase.set(this, 'itemNm', itemNm);
//     RealmObjectBase.set(this, 'qty', qty);
//     RealmObjectBase.set(this, 'prc', prc);
//     RealmObjectBase.set(this, 'splyAmt', splyAmt);
//     RealmObjectBase.set(this, 'tin', tin);
//     RealmObjectBase.set(this, 'bhfId', bhfId);
//     RealmObjectBase.set(this, 'dftPrc', dftPrc);
//     RealmObjectBase.set(this, 'addInfo', addInfo);
//     RealmObjectBase.set(this, 'isrcAplcbYn', isrcAplcbYn);
//     RealmObjectBase.set(this, 'useYn', useYn);
//     RealmObjectBase.set(this, 'regrId', regrId);
//     RealmObjectBase.set(this, 'regrNm', regrNm);
//     RealmObjectBase.set(this, 'modrId', modrId);
//     RealmObjectBase.set(this, 'modrNm', modrNm);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'supplyPrice', supplyPrice);
//     RealmObjectBase.set(this, 'retailPrice', retailPrice);
//     RealmObjectBase.set(this, 'spplrItemClsCd', spplrItemClsCd);
//     RealmObjectBase.set(this, 'spplrItemCd', spplrItemCd);
//     RealmObjectBase.set(this, 'spplrItemNm', spplrItemNm);
//     RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
//     RealmObjectBase.set(this, 'taxType', taxType);
//     RealmObjectBase.set<RealmList<int>>(
//         this, 'branchIds', RealmList<int>(branchIds));
//     RealmObjectBase.set(this, 'stock', stock);
//     RealmObjectBase.set(this, 'dcRt', dcRt);
//     RealmObjectBase.set(this, 'expirationDate', expirationDate);
//   }

//   Variant._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   String? get color => RealmObjectBase.get<String>(this, 'color') as String?;
//   @override
//   set color(String? value) => RealmObjectBase.set(this, 'color', value);

//   @override
//   String? get sku => RealmObjectBase.get<String>(this, 'sku') as String?;
//   @override
//   set sku(String? value) => RealmObjectBase.set(this, 'sku', value);

//   @override
//   int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
//   @override
//   set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

//   @override
//   String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
//   @override
//   set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

//   @override
//   String? get productName =>
//       RealmObjectBase.get<String>(this, 'productName') as String?;
//   @override
//   set productName(String? value) =>
//       RealmObjectBase.set(this, 'productName', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   String? get taxName =>
//       RealmObjectBase.get<String>(this, 'taxName') as String?;
//   @override
//   set taxName(String? value) => RealmObjectBase.set(this, 'taxName', value);

//   @override
//   double get taxPercentage =>
//       RealmObjectBase.get<double>(this, 'taxPercentage') as double;
//   @override
//   set taxPercentage(double value) =>
//       RealmObjectBase.set(this, 'taxPercentage', value);

//   @override
//   bool get isTaxExempted =>
//       RealmObjectBase.get<bool>(this, 'isTaxExempted') as bool;
//   @override
//   set isTaxExempted(bool value) =>
//       RealmObjectBase.set(this, 'isTaxExempted', value);

//   @override
//   int? get itemSeq => RealmObjectBase.get<int>(this, 'itemSeq') as int?;
//   @override
//   set itemSeq(int? value) => RealmObjectBase.set(this, 'itemSeq', value);

//   @override
//   String? get isrccCd =>
//       RealmObjectBase.get<String>(this, 'isrccCd') as String?;
//   @override
//   set isrccCd(String? value) => RealmObjectBase.set(this, 'isrccCd', value);

//   @override
//   String? get isrccNm =>
//       RealmObjectBase.get<String>(this, 'isrccNm') as String?;
//   @override
//   set isrccNm(String? value) => RealmObjectBase.set(this, 'isrccNm', value);

//   @override
//   int? get isrcRt => RealmObjectBase.get<int>(this, 'isrcRt') as int?;
//   @override
//   set isrcRt(int? value) => RealmObjectBase.set(this, 'isrcRt', value);

//   @override
//   int? get isrcAmt => RealmObjectBase.get<int>(this, 'isrcAmt') as int?;
//   @override
//   set isrcAmt(int? value) => RealmObjectBase.set(this, 'isrcAmt', value);

//   @override
//   String? get taxTyCd =>
//       RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
//   @override
//   set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

//   @override
//   String? get bcd => RealmObjectBase.get<String>(this, 'bcd') as String?;
//   @override
//   set bcd(String? value) => RealmObjectBase.set(this, 'bcd', value);

//   @override
//   String? get itemClsCd =>
//       RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
//   @override
//   set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

//   @override
//   String? get itemTyCd =>
//       RealmObjectBase.get<String>(this, 'itemTyCd') as String?;
//   @override
//   set itemTyCd(String? value) => RealmObjectBase.set(this, 'itemTyCd', value);

//   @override
//   String? get itemStdNm =>
//       RealmObjectBase.get<String>(this, 'itemStdNm') as String?;
//   @override
//   set itemStdNm(String? value) => RealmObjectBase.set(this, 'itemStdNm', value);

//   @override
//   String? get orgnNatCd =>
//       RealmObjectBase.get<String>(this, 'orgnNatCd') as String?;
//   @override
//   set orgnNatCd(String? value) => RealmObjectBase.set(this, 'orgnNatCd', value);

//   @override
//   String? get pkg => RealmObjectBase.get<String>(this, 'pkg') as String?;
//   @override
//   set pkg(String? value) => RealmObjectBase.set(this, 'pkg', value);

//   @override
//   String? get itemCd => RealmObjectBase.get<String>(this, 'itemCd') as String?;
//   @override
//   set itemCd(String? value) => RealmObjectBase.set(this, 'itemCd', value);

//   @override
//   String? get pkgUnitCd =>
//       RealmObjectBase.get<String>(this, 'pkgUnitCd') as String?;
//   @override
//   set pkgUnitCd(String? value) => RealmObjectBase.set(this, 'pkgUnitCd', value);

//   @override
//   String? get qtyUnitCd =>
//       RealmObjectBase.get<String>(this, 'qtyUnitCd') as String?;
//   @override
//   set qtyUnitCd(String? value) => RealmObjectBase.set(this, 'qtyUnitCd', value);

//   @override
//   String? get itemNm => RealmObjectBase.get<String>(this, 'itemNm') as String?;
//   @override
//   set itemNm(String? value) => RealmObjectBase.set(this, 'itemNm', value);

//   @override
//   double get qty => RealmObjectBase.get<double>(this, 'qty') as double;
//   @override
//   set qty(double value) => RealmObjectBase.set(this, 'qty', value);

//   @override
//   double get prc => RealmObjectBase.get<double>(this, 'prc') as double;
//   @override
//   set prc(double value) => RealmObjectBase.set(this, 'prc', value);

//   @override
//   double get splyAmt => RealmObjectBase.get<double>(this, 'splyAmt') as double;
//   @override
//   set splyAmt(double value) => RealmObjectBase.set(this, 'splyAmt', value);

//   @override
//   int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
//   @override
//   set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

//   @override
//   String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
//   @override
//   set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

//   @override
//   double? get dftPrc => RealmObjectBase.get<double>(this, 'dftPrc') as double?;
//   @override
//   set dftPrc(double? value) => RealmObjectBase.set(this, 'dftPrc', value);

//   @override
//   String? get addInfo =>
//       RealmObjectBase.get<String>(this, 'addInfo') as String?;
//   @override
//   set addInfo(String? value) => RealmObjectBase.set(this, 'addInfo', value);

//   @override
//   String? get isrcAplcbYn =>
//       RealmObjectBase.get<String>(this, 'isrcAplcbYn') as String?;
//   @override
//   set isrcAplcbYn(String? value) =>
//       RealmObjectBase.set(this, 'isrcAplcbYn', value);

//   @override
//   String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
//   @override
//   set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

//   @override
//   String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
//   @override
//   set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

//   @override
//   String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
//   @override
//   set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

//   @override
//   String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
//   @override
//   set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

//   @override
//   String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
//   @override
//   set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   double get supplyPrice =>
//       RealmObjectBase.get<double>(this, 'supplyPrice') as double;
//   @override
//   set supplyPrice(double value) =>
//       RealmObjectBase.set(this, 'supplyPrice', value);

//   @override
//   double get retailPrice =>
//       RealmObjectBase.get<double>(this, 'retailPrice') as double;
//   @override
//   set retailPrice(double value) =>
//       RealmObjectBase.set(this, 'retailPrice', value);

//   @override
//   String? get spplrItemClsCd =>
//       RealmObjectBase.get<String>(this, 'spplrItemClsCd') as String?;
//   @override
//   set spplrItemClsCd(String? value) =>
//       RealmObjectBase.set(this, 'spplrItemClsCd', value);

//   @override
//   String? get spplrItemCd =>
//       RealmObjectBase.get<String>(this, 'spplrItemCd') as String?;
//   @override
//   set spplrItemCd(String? value) =>
//       RealmObjectBase.set(this, 'spplrItemCd', value);

//   @override
//   String? get spplrItemNm =>
//       RealmObjectBase.get<String>(this, 'spplrItemNm') as String?;
//   @override
//   set spplrItemNm(String? value) =>
//       RealmObjectBase.set(this, 'spplrItemNm', value);

//   @override
//   bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
//   @override
//   set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

//   @override
//   String get taxType => RealmObjectBase.get<String>(this, 'taxType') as String;
//   @override
//   set taxType(String value) => RealmObjectBase.set(this, 'taxType', value);

//   @override
//   RealmList<int> get branchIds =>
//       RealmObjectBase.get<int>(this, 'branchIds') as RealmList<int>;
//   @override
//   set branchIds(covariant RealmList<int> value) =>
//       throw RealmUnsupportedSetError();

//   @override
//   Stock? get stock => RealmObjectBase.get<Stock>(this, 'stock') as Stock?;
//   @override
//   set stock(covariant Stock? value) =>
//       RealmObjectBase.set(this, 'stock', value);

//   @override
//   double get dcRt => RealmObjectBase.get<double>(this, 'dcRt') as double;
//   @override
//   set dcRt(double value) => RealmObjectBase.set(this, 'dcRt', value);

//   @override
//   DateTime? get expirationDate =>
//       RealmObjectBase.get<DateTime>(this, 'expirationDate') as DateTime?;
//   @override
//   set expirationDate(DateTime? value) =>
//       RealmObjectBase.set(this, 'expirationDate', value);

//   @override
//   Stream<RealmObjectChanges<Variant>> get changes =>
//       RealmObjectBase.getChanges<Variant>(this);

//   @override
//   Stream<RealmObjectChanges<Variant>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Variant>(this, keyPaths);

//   @override
//   Variant freeze() => RealmObjectBase.freezeObject<Variant>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'deletedAt': deletedAt,
//       'name': name,
//       'color': color,
//       'sku': sku,
//       'productId': productId,
//       'unit': unit,
//       'productName': productName,
//       'branchId': branchId,
//       'taxName': taxName,
//       'taxPercentage': taxPercentage,
//       'isTaxExempted': isTaxExempted,
//       'itemSeq': itemSeq,
//       'isrccCd': isrccCd,
//       'isrccNm': isrccNm,
//       'isrcRt': isrcRt,
//       'isrcAmt': isrcAmt,
//       'taxTyCd': taxTyCd,
//       'bcd': bcd,
//       'itemClsCd': itemClsCd,
//       'itemTyCd': itemTyCd,
//       'itemStdNm': itemStdNm,
//       'orgnNatCd': orgnNatCd,
//       'pkg': pkg,
//       'itemCd': itemCd,
//       'pkgUnitCd': pkgUnitCd,
//       'qtyUnitCd': qtyUnitCd,
//       'itemNm': itemNm,
//       'qty': qty,
//       'prc': prc,
//       'splyAmt': splyAmt,
//       'tin': tin,
//       'bhfId': bhfId,
//       'dftPrc': dftPrc,
//       'addInfo': addInfo,
//       'isrcAplcbYn': isrcAplcbYn,
//       'useYn': useYn,
//       'regrId': regrId,
//       'regrNm': regrNm,
//       'modrId': modrId,
//       'modrNm': modrNm,
//       'lastTouched': lastTouched,
//       'supplyPrice': supplyPrice,
//       'retailPrice': retailPrice,
//       'spplrItemClsCd': spplrItemClsCd,
//       'spplrItemCd': spplrItemCd,
//       'spplrItemNm': spplrItemNm,
//       'ebmSynced': ebmSynced,
//       'taxType': taxType,
//       'branchIds': branchIds,
//       'stock': stock,
//       'dcRt': dcRt,
//       'expirationDate': expirationDate,
//     };
//   }

//   static EJsonValue _toEJson(Variant value) => value;
//   static Variant _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Variant(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           name: fromEJson(ejson['name']),
//           color: fromEJson(ejson['color']),
//           sku: fromEJson(ejson['sku']),
//           productId: fromEJson(ejson['productId']),
//           unit: fromEJson(ejson['unit']),
//           productName: fromEJson(ejson['productName']),
//           branchId: fromEJson(ejson['branchId']),
//           taxName: fromEJson(ejson['taxName'], defaultValue: ""),
//           taxPercentage: fromEJson(ejson['taxPercentage'], defaultValue: 0.0),
//           isTaxExempted: fromEJson(ejson['isTaxExempted'], defaultValue: false),
//           itemSeq: fromEJson(ejson['itemSeq']),
//           isrccCd: fromEJson(ejson['isrccCd'], defaultValue: ""),
//           isrccNm: fromEJson(ejson['isrccNm'], defaultValue: ""),
//           isrcRt: fromEJson(ejson['isrcRt'], defaultValue: 0),
//           isrcAmt: fromEJson(ejson['isrcAmt'], defaultValue: 0),
//           taxTyCd: fromEJson(ejson['taxTyCd'], defaultValue: "B"),
//           bcd: fromEJson(ejson['bcd'], defaultValue: ""),
//           itemClsCd: fromEJson(ejson['itemClsCd']),
//           itemTyCd: fromEJson(ejson['itemTyCd']),
//           itemStdNm: fromEJson(ejson['itemStdNm'], defaultValue: ""),
//           orgnNatCd: fromEJson(ejson['orgnNatCd'], defaultValue: ""),
//           pkg: fromEJson(ejson['pkg'], defaultValue: "1"),
//           itemCd: fromEJson(ejson['itemCd'], defaultValue: ""),
//           pkgUnitCd: fromEJson(ejson['pkgUnitCd'], defaultValue: "CT"),
//           qtyUnitCd: fromEJson(ejson['qtyUnitCd'], defaultValue: "BX"),
//           itemNm: fromEJson(ejson['itemNm']),
//           qty: fromEJson(ejson['qty'], defaultValue: 0.0),
//           prc: fromEJson(ejson['prc'], defaultValue: 0.0),
//           splyAmt: fromEJson(ejson['splyAmt'], defaultValue: 0.0),
//           tin: fromEJson(ejson['tin']),
//           bhfId: fromEJson(ejson['bhfId']),
//           dftPrc: fromEJson(ejson['dftPrc'], defaultValue: 0),
//           addInfo: fromEJson(ejson['addInfo'], defaultValue: ""),
//           isrcAplcbYn: fromEJson(ejson['isrcAplcbYn'], defaultValue: ""),
//           useYn: fromEJson(ejson['useYn'], defaultValue: ""),
//           regrId: fromEJson(ejson['regrId']),
//           regrNm: fromEJson(ejson['regrNm']),
//           modrId: fromEJson(ejson['modrId']),
//           modrNm: fromEJson(ejson['modrNm']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           supplyPrice: fromEJson(ejson['supplyPrice'], defaultValue: 0.0),
//           retailPrice: fromEJson(ejson['retailPrice'], defaultValue: 0.0),
//           spplrItemClsCd: fromEJson(ejson['spplrItemClsCd']),
//           spplrItemCd: fromEJson(ejson['spplrItemCd']),
//           spplrItemNm: fromEJson(ejson['spplrItemNm']),
//           ebmSynced: fromEJson(ejson['ebmSynced'], defaultValue: false),
//           taxType: fromEJson(ejson['taxType'], defaultValue: "B"),
//           branchIds: fromEJson(ejson['branchIds']),
//           stock: fromEJson(ejson['stock']),
//           dcRt: fromEJson(ejson['dcRt'], defaultValue: 0.0),
//           expirationDate: fromEJson(ejson['expirationDate']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Variant._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Variant, 'Variant', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('color', RealmPropertyType.string, optional: true),
//       SchemaProperty('sku', RealmPropertyType.string, optional: true),
//       SchemaProperty('productId', RealmPropertyType.int, optional: true),
//       SchemaProperty('unit', RealmPropertyType.string, optional: true),
//       SchemaProperty('productName', RealmPropertyType.string, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('taxName', RealmPropertyType.string, optional: true),
//       SchemaProperty('taxPercentage', RealmPropertyType.double),
//       SchemaProperty('isTaxExempted', RealmPropertyType.bool),
//       SchemaProperty('itemSeq', RealmPropertyType.int, optional: true),
//       SchemaProperty('isrccCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('isrccNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('isrcRt', RealmPropertyType.int, optional: true),
//       SchemaProperty('isrcAmt', RealmPropertyType.int, optional: true),
//       SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('bcd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemTyCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemStdNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('orgnNatCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('pkg', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('pkgUnitCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('qtyUnitCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('qty', RealmPropertyType.double),
//       SchemaProperty('prc', RealmPropertyType.double),
//       SchemaProperty('splyAmt', RealmPropertyType.double),
//       SchemaProperty('tin', RealmPropertyType.int, optional: true),
//       SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
//       SchemaProperty('dftPrc', RealmPropertyType.double, optional: true),
//       SchemaProperty('addInfo', RealmPropertyType.string, optional: true),
//       SchemaProperty('isrcAplcbYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('useYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('regrId', RealmPropertyType.string, optional: true),
//       SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('modrId', RealmPropertyType.string, optional: true),
//       SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('supplyPrice', RealmPropertyType.double),
//       SchemaProperty('retailPrice', RealmPropertyType.double),
//       SchemaProperty('spplrItemClsCd', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('spplrItemCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('spplrItemNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('ebmSynced', RealmPropertyType.bool),
//       SchemaProperty('taxType', RealmPropertyType.string),
//       SchemaProperty('branchIds', RealmPropertyType.int,
//           collectionType: RealmCollectionType.list),
//       SchemaProperty('stock', RealmPropertyType.object,
//           optional: true, linkTarget: 'Stock'),
//       SchemaProperty('dcRt', RealmPropertyType.double),
//       SchemaProperty('expirationDate', RealmPropertyType.timestamp,
//           optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class StockRequest extends _StockRequest
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   StockRequest(
//     ObjectId realmId, {
//     int? id,
//     int? mainBranchId,
//     int? subBranchId,
//     DateTime? createdAt,
//     String? status,
//     DateTime? deliveryDate,
//     String? deliveryNote,
//     String? orderNote,
//     bool? customerReceivedOrder = false,
//     bool? driverRequestDeliveryConfirmation = false,
//     int? driverId,
//     Iterable<TransactionItem> items = const [],
//     DateTime? updatedAt,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<StockRequest>({
//         'customerReceivedOrder': false,
//         'driverRequestDeliveryConfirmation': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'mainBranchId', mainBranchId);
//     RealmObjectBase.set(this, 'subBranchId', subBranchId);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'status', status);
//     RealmObjectBase.set(this, 'deliveryDate', deliveryDate);
//     RealmObjectBase.set(this, 'deliveryNote', deliveryNote);
//     RealmObjectBase.set(this, 'orderNote', orderNote);
//     RealmObjectBase.set(this, 'customerReceivedOrder', customerReceivedOrder);
//     RealmObjectBase.set(this, 'driverRequestDeliveryConfirmation',
//         driverRequestDeliveryConfirmation);
//     RealmObjectBase.set(this, 'driverId', driverId);
//     RealmObjectBase.set<RealmList<TransactionItem>>(
//         this, 'items', RealmList<TransactionItem>(items));
//     RealmObjectBase.set(this, 'updatedAt', updatedAt);
//   }

//   StockRequest._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get mainBranchId =>
//       RealmObjectBase.get<int>(this, 'mainBranchId') as int?;
//   @override
//   set mainBranchId(int? value) =>
//       RealmObjectBase.set(this, 'mainBranchId', value);

//   @override
//   int? get subBranchId => RealmObjectBase.get<int>(this, 'subBranchId') as int?;
//   @override
//   set subBranchId(int? value) =>
//       RealmObjectBase.set(this, 'subBranchId', value);

//   @override
//   DateTime? get createdAt =>
//       RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
//   @override
//   set createdAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get status => RealmObjectBase.get<String>(this, 'status') as String?;
//   @override
//   set status(String? value) => RealmObjectBase.set(this, 'status', value);

//   @override
//   DateTime? get deliveryDate =>
//       RealmObjectBase.get<DateTime>(this, 'deliveryDate') as DateTime?;
//   @override
//   set deliveryDate(DateTime? value) =>
//       RealmObjectBase.set(this, 'deliveryDate', value);

//   @override
//   String? get deliveryNote =>
//       RealmObjectBase.get<String>(this, 'deliveryNote') as String?;
//   @override
//   set deliveryNote(String? value) =>
//       RealmObjectBase.set(this, 'deliveryNote', value);

//   @override
//   String? get orderNote =>
//       RealmObjectBase.get<String>(this, 'orderNote') as String?;
//   @override
//   set orderNote(String? value) => RealmObjectBase.set(this, 'orderNote', value);

//   @override
//   bool? get customerReceivedOrder =>
//       RealmObjectBase.get<bool>(this, 'customerReceivedOrder') as bool?;
//   @override
//   set customerReceivedOrder(bool? value) =>
//       RealmObjectBase.set(this, 'customerReceivedOrder', value);

//   @override
//   bool? get driverRequestDeliveryConfirmation =>
//       RealmObjectBase.get<bool>(this, 'driverRequestDeliveryConfirmation')
//           as bool?;
//   @override
//   set driverRequestDeliveryConfirmation(bool? value) =>
//       RealmObjectBase.set(this, 'driverRequestDeliveryConfirmation', value);

//   @override
//   int? get driverId => RealmObjectBase.get<int>(this, 'driverId') as int?;
//   @override
//   set driverId(int? value) => RealmObjectBase.set(this, 'driverId', value);

//   @override
//   RealmList<TransactionItem> get items =>
//       RealmObjectBase.get<TransactionItem>(this, 'items')
//           as RealmList<TransactionItem>;
//   @override
//   set items(covariant RealmList<TransactionItem> value) =>
//       throw RealmUnsupportedSetError();

//   @override
//   DateTime? get updatedAt =>
//       RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
//   @override
//   set updatedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'updatedAt', value);

//   @override
//   Stream<RealmObjectChanges<StockRequest>> get changes =>
//       RealmObjectBase.getChanges<StockRequest>(this);

//   @override
//   Stream<RealmObjectChanges<StockRequest>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<StockRequest>(this, keyPaths);

//   @override
//   StockRequest freeze() => RealmObjectBase.freezeObject<StockRequest>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'mainBranchId': mainBranchId,
//       'subBranchId': subBranchId,
//       'createdAt': createdAt,
//       'status': status,
//       'deliveryDate': deliveryDate,
//       'deliveryNote': deliveryNote,
//       'orderNote': orderNote,
//       'customerReceivedOrder': customerReceivedOrder,
//       'driverRequestDeliveryConfirmation':
//           driverRequestDeliveryConfirmation,
//       'driverId': driverId,
//       'items': items,
//       'updatedAt': updatedAt,
//     };
//   }

//   static EJsonValue _toEJson(StockRequest value) => value;
//   static StockRequest _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         StockRequest(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           mainBranchId: fromEJson(ejson['mainBranchId']),
//           subBranchId: fromEJson(ejson['subBranchId']),
//           createdAt: fromEJson(ejson['createdAt']),
//           status: fromEJson(ejson['status']),
//           deliveryDate: fromEJson(ejson['deliveryDate']),
//           deliveryNote: fromEJson(ejson['deliveryNote']),
//           orderNote: fromEJson(ejson['orderNote']),
//           customerReceivedOrder:
//               fromEJson(ejson['customerReceivedOrder'], defaultValue: false),
//           driverRequestDeliveryConfirmation: fromEJson(
//               ejson['driverRequestDeliveryConfirmation'],
//               defaultValue: false),
//           driverId: fromEJson(ejson['driverId']),
//           items: fromEJson(ejson['items']),
//           updatedAt: fromEJson(ejson['updatedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(StockRequest._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, StockRequest, 'StockRequest', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('mainBranchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('subBranchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('status', RealmPropertyType.string, optional: true),
//       SchemaProperty('deliveryDate', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deliveryNote', RealmPropertyType.string, optional: true),
//       SchemaProperty('orderNote', RealmPropertyType.string, optional: true),
//       SchemaProperty('customerReceivedOrder', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty(
//           'driverRequestDeliveryConfirmation', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('driverId', RealmPropertyType.int, optional: true),
//       SchemaProperty('items', RealmPropertyType.object,
//           linkTarget: 'TransactionItem',
//           collectionType: RealmCollectionType.list),
//       SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class TransactionItem extends _TransactionItem
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   TransactionItem(
//     ObjectId realmId, {
//     int? id,
//     String? name,
//     int? quantityRequested,
//     int? quantityApproved,
//     int? quantityShipped,
//     int? transactionId,
//     int? variantId,
//     double qty = 0.0,
//     double price = 0.0,
//     double discount = 0.0,
//     String? type,
//     double remainingStock = 0.0,
//     String? createdAt,
//     String? updatedAt,
//     bool isTaxExempted = false,
//     bool isRefunded = false,
//     bool? doneWithTransaction,
//     bool? active,
//     double dcRt = 0.0,
//     double dcAmt = 0.0,
//     double taxblAmt = 0.0,
//     double taxAmt = 0.0,
//     double totAmt = 0.0,
//     int? itemSeq,
//     String? isrccCd,
//     String? isrccNm = "",
//     int? isrcRt = 0,
//     int? isrcAmt = 0,
//     String? taxTyCd,
//     String? bcd,
//     String? itemClsCd,
//     String? itemTyCd,
//     String? itemStdNm,
//     String? orgnNatCd,
//     String? pkg,
//     String? itemCd,
//     String? pkgUnitCd = "CT",
//     String? qtyUnitCd = "BX",
//     String? itemNm,
//     double prc = 0.0,
//     double splyAmt = 0.0,
//     int? tin,
//     String? bhfId,
//     double? dftPrc,
//     String? addInfo,
//     String? isrcAplcbYn,
//     String? useYn,
//     String? regrId,
//     String? regrNm,
//     String? modrId,
//     String? modrNm,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     int? branchId,
//     bool ebmSynced = false,
//     bool partOfComposite = false,
//     double compositePrice = 0,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<TransactionItem>({
//         'qty': 0.0,
//         'price': 0.0,
//         'discount': 0.0,
//         'remainingStock': 0.0,
//         'isTaxExempted': false,
//         'isRefunded': false,
//         'dcRt': 0.0,
//         'dcAmt': 0.0,
//         'taxblAmt': 0.0,
//         'taxAmt': 0.0,
//         'totAmt': 0.0,
//         'isrccNm': "",
//         'isrcRt': 0,
//         'isrcAmt': 0,
//         'pkgUnitCd': "CT",
//         'qtyUnitCd': "BX",
//         'prc': 0.0,
//         'splyAmt': 0.0,
//         'ebmSynced': false,
//         'partOfComposite': false,
//         'compositePrice': 0,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'quantityRequested', quantityRequested);
//     RealmObjectBase.set(this, 'quantityApproved', quantityApproved);
//     RealmObjectBase.set(this, 'quantityShipped', quantityShipped);
//     RealmObjectBase.set(this, 'transactionId', transactionId);
//     RealmObjectBase.set(this, 'variantId', variantId);
//     RealmObjectBase.set(this, 'qty', qty);
//     RealmObjectBase.set(this, 'price', price);
//     RealmObjectBase.set(this, 'discount', discount);
//     RealmObjectBase.set(this, 'type', type);
//     RealmObjectBase.set(this, 'remainingStock', remainingStock);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'updatedAt', updatedAt);
//     RealmObjectBase.set(this, 'isTaxExempted', isTaxExempted);
//     RealmObjectBase.set(this, 'isRefunded', isRefunded);
//     RealmObjectBase.set(this, 'doneWithTransaction', doneWithTransaction);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'dcRt', dcRt);
//     RealmObjectBase.set(this, 'dcAmt', dcAmt);
//     RealmObjectBase.set(this, 'taxblAmt', taxblAmt);
//     RealmObjectBase.set(this, 'taxAmt', taxAmt);
//     RealmObjectBase.set(this, 'totAmt', totAmt);
//     RealmObjectBase.set(this, 'itemSeq', itemSeq);
//     RealmObjectBase.set(this, 'isrccCd', isrccCd);
//     RealmObjectBase.set(this, 'isrccNm', isrccNm);
//     RealmObjectBase.set(this, 'isrcRt', isrcRt);
//     RealmObjectBase.set(this, 'isrcAmt', isrcAmt);
//     RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
//     RealmObjectBase.set(this, 'bcd', bcd);
//     RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
//     RealmObjectBase.set(this, 'itemTyCd', itemTyCd);
//     RealmObjectBase.set(this, 'itemStdNm', itemStdNm);
//     RealmObjectBase.set(this, 'orgnNatCd', orgnNatCd);
//     RealmObjectBase.set(this, 'pkg', pkg);
//     RealmObjectBase.set(this, 'itemCd', itemCd);
//     RealmObjectBase.set(this, 'pkgUnitCd', pkgUnitCd);
//     RealmObjectBase.set(this, 'qtyUnitCd', qtyUnitCd);
//     RealmObjectBase.set(this, 'itemNm', itemNm);
//     RealmObjectBase.set(this, 'prc', prc);
//     RealmObjectBase.set(this, 'splyAmt', splyAmt);
//     RealmObjectBase.set(this, 'tin', tin);
//     RealmObjectBase.set(this, 'bhfId', bhfId);
//     RealmObjectBase.set(this, 'dftPrc', dftPrc);
//     RealmObjectBase.set(this, 'addInfo', addInfo);
//     RealmObjectBase.set(this, 'isrcAplcbYn', isrcAplcbYn);
//     RealmObjectBase.set(this, 'useYn', useYn);
//     RealmObjectBase.set(this, 'regrId', regrId);
//     RealmObjectBase.set(this, 'regrNm', regrNm);
//     RealmObjectBase.set(this, 'modrId', modrId);
//     RealmObjectBase.set(this, 'modrNm', modrNm);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
//     RealmObjectBase.set(this, 'partOfComposite', partOfComposite);
//     RealmObjectBase.set(this, 'compositePrice', compositePrice);
//   }

//   TransactionItem._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   int? get quantityRequested =>
//       RealmObjectBase.get<int>(this, 'quantityRequested') as int?;
//   @override
//   set quantityRequested(int? value) =>
//       RealmObjectBase.set(this, 'quantityRequested', value);

//   @override
//   int? get quantityApproved =>
//       RealmObjectBase.get<int>(this, 'quantityApproved') as int?;
//   @override
//   set quantityApproved(int? value) =>
//       RealmObjectBase.set(this, 'quantityApproved', value);

//   @override
//   int? get quantityShipped =>
//       RealmObjectBase.get<int>(this, 'quantityShipped') as int?;
//   @override
//   set quantityShipped(int? value) =>
//       RealmObjectBase.set(this, 'quantityShipped', value);

//   @override
//   int? get transactionId =>
//       RealmObjectBase.get<int>(this, 'transactionId') as int?;
//   @override
//   set transactionId(int? value) =>
//       RealmObjectBase.set(this, 'transactionId', value);

//   @override
//   int? get variantId => RealmObjectBase.get<int>(this, 'variantId') as int?;
//   @override
//   set variantId(int? value) => RealmObjectBase.set(this, 'variantId', value);

//   @override
//   double get qty => RealmObjectBase.get<double>(this, 'qty') as double;
//   @override
//   set qty(double value) => RealmObjectBase.set(this, 'qty', value);

//   @override
//   double get price => RealmObjectBase.get<double>(this, 'price') as double;
//   @override
//   set price(double value) => RealmObjectBase.set(this, 'price', value);

//   @override
//   double get discount =>
//       RealmObjectBase.get<double>(this, 'discount') as double;
//   @override
//   set discount(double value) => RealmObjectBase.set(this, 'discount', value);

//   @override
//   String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
//   @override
//   set type(String? value) => RealmObjectBase.set(this, 'type', value);

//   @override
//   double get remainingStock =>
//       RealmObjectBase.get<double>(this, 'remainingStock') as double;
//   @override
//   set remainingStock(double value) =>
//       RealmObjectBase.set(this, 'remainingStock', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get updatedAt =>
//       RealmObjectBase.get<String>(this, 'updatedAt') as String?;
//   @override
//   set updatedAt(String? value) => RealmObjectBase.set(this, 'updatedAt', value);

//   @override
//   bool get isTaxExempted =>
//       RealmObjectBase.get<bool>(this, 'isTaxExempted') as bool;
//   @override
//   set isTaxExempted(bool value) =>
//       RealmObjectBase.set(this, 'isTaxExempted', value);

//   @override
//   bool get isRefunded => RealmObjectBase.get<bool>(this, 'isRefunded') as bool;
//   @override
//   set isRefunded(bool value) => RealmObjectBase.set(this, 'isRefunded', value);

//   @override
//   bool? get doneWithTransaction =>
//       RealmObjectBase.get<bool>(this, 'doneWithTransaction') as bool?;
//   @override
//   set doneWithTransaction(bool? value) =>
//       RealmObjectBase.set(this, 'doneWithTransaction', value);

//   @override
//   bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
//   @override
//   set active(bool? value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   double get dcRt => RealmObjectBase.get<double>(this, 'dcRt') as double;
//   @override
//   set dcRt(double value) => RealmObjectBase.set(this, 'dcRt', value);

//   @override
//   double get dcAmt => RealmObjectBase.get<double>(this, 'dcAmt') as double;
//   @override
//   set dcAmt(double value) => RealmObjectBase.set(this, 'dcAmt', value);

//   @override
//   double get taxblAmt =>
//       RealmObjectBase.get<double>(this, 'taxblAmt') as double;
//   @override
//   set taxblAmt(double value) => RealmObjectBase.set(this, 'taxblAmt', value);

//   @override
//   double get taxAmt => RealmObjectBase.get<double>(this, 'taxAmt') as double;
//   @override
//   set taxAmt(double value) => RealmObjectBase.set(this, 'taxAmt', value);

//   @override
//   double get totAmt => RealmObjectBase.get<double>(this, 'totAmt') as double;
//   @override
//   set totAmt(double value) => RealmObjectBase.set(this, 'totAmt', value);

//   @override
//   int? get itemSeq => RealmObjectBase.get<int>(this, 'itemSeq') as int?;
//   @override
//   set itemSeq(int? value) => RealmObjectBase.set(this, 'itemSeq', value);

//   @override
//   String? get isrccCd =>
//       RealmObjectBase.get<String>(this, 'isrccCd') as String?;
//   @override
//   set isrccCd(String? value) => RealmObjectBase.set(this, 'isrccCd', value);

//   @override
//   String? get isrccNm =>
//       RealmObjectBase.get<String>(this, 'isrccNm') as String?;
//   @override
//   set isrccNm(String? value) => RealmObjectBase.set(this, 'isrccNm', value);

//   @override
//   int? get isrcRt => RealmObjectBase.get<int>(this, 'isrcRt') as int?;
//   @override
//   set isrcRt(int? value) => RealmObjectBase.set(this, 'isrcRt', value);

//   @override
//   int? get isrcAmt => RealmObjectBase.get<int>(this, 'isrcAmt') as int?;
//   @override
//   set isrcAmt(int? value) => RealmObjectBase.set(this, 'isrcAmt', value);

//   @override
//   String? get taxTyCd =>
//       RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
//   @override
//   set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

//   @override
//   String? get bcd => RealmObjectBase.get<String>(this, 'bcd') as String?;
//   @override
//   set bcd(String? value) => RealmObjectBase.set(this, 'bcd', value);

//   @override
//   String? get itemClsCd =>
//       RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
//   @override
//   set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

//   @override
//   String? get itemTyCd =>
//       RealmObjectBase.get<String>(this, 'itemTyCd') as String?;
//   @override
//   set itemTyCd(String? value) => RealmObjectBase.set(this, 'itemTyCd', value);

//   @override
//   String? get itemStdNm =>
//       RealmObjectBase.get<String>(this, 'itemStdNm') as String?;
//   @override
//   set itemStdNm(String? value) => RealmObjectBase.set(this, 'itemStdNm', value);

//   @override
//   String? get orgnNatCd =>
//       RealmObjectBase.get<String>(this, 'orgnNatCd') as String?;
//   @override
//   set orgnNatCd(String? value) => RealmObjectBase.set(this, 'orgnNatCd', value);

//   @override
//   String? get pkg => RealmObjectBase.get<String>(this, 'pkg') as String?;
//   @override
//   set pkg(String? value) => RealmObjectBase.set(this, 'pkg', value);

//   @override
//   String? get itemCd => RealmObjectBase.get<String>(this, 'itemCd') as String?;
//   @override
//   set itemCd(String? value) => RealmObjectBase.set(this, 'itemCd', value);

//   @override
//   String? get pkgUnitCd =>
//       RealmObjectBase.get<String>(this, 'pkgUnitCd') as String?;
//   @override
//   set pkgUnitCd(String? value) => RealmObjectBase.set(this, 'pkgUnitCd', value);

//   @override
//   String? get qtyUnitCd =>
//       RealmObjectBase.get<String>(this, 'qtyUnitCd') as String?;
//   @override
//   set qtyUnitCd(String? value) => RealmObjectBase.set(this, 'qtyUnitCd', value);

//   @override
//   String? get itemNm => RealmObjectBase.get<String>(this, 'itemNm') as String?;
//   @override
//   set itemNm(String? value) => RealmObjectBase.set(this, 'itemNm', value);

//   @override
//   double get prc => RealmObjectBase.get<double>(this, 'prc') as double;
//   @override
//   set prc(double value) => RealmObjectBase.set(this, 'prc', value);

//   @override
//   double get splyAmt => RealmObjectBase.get<double>(this, 'splyAmt') as double;
//   @override
//   set splyAmt(double value) => RealmObjectBase.set(this, 'splyAmt', value);

//   @override
//   int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
//   @override
//   set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

//   @override
//   String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
//   @override
//   set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

//   @override
//   double? get dftPrc => RealmObjectBase.get<double>(this, 'dftPrc') as double?;
//   @override
//   set dftPrc(double? value) => RealmObjectBase.set(this, 'dftPrc', value);

//   @override
//   String? get addInfo =>
//       RealmObjectBase.get<String>(this, 'addInfo') as String?;
//   @override
//   set addInfo(String? value) => RealmObjectBase.set(this, 'addInfo', value);

//   @override
//   String? get isrcAplcbYn =>
//       RealmObjectBase.get<String>(this, 'isrcAplcbYn') as String?;
//   @override
//   set isrcAplcbYn(String? value) =>
//       RealmObjectBase.set(this, 'isrcAplcbYn', value);

//   @override
//   String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
//   @override
//   set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

//   @override
//   String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
//   @override
//   set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

//   @override
//   String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
//   @override
//   set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

//   @override
//   String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
//   @override
//   set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

//   @override
//   String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
//   @override
//   set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
//   @override
//   set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

//   @override
//   bool get partOfComposite =>
//       RealmObjectBase.get<bool>(this, 'partOfComposite') as bool;
//   @override
//   set partOfComposite(bool value) =>
//       RealmObjectBase.set(this, 'partOfComposite', value);

//   @override
//   double get compositePrice =>
//       RealmObjectBase.get<double>(this, 'compositePrice') as double;
//   @override
//   set compositePrice(double value) =>
//       RealmObjectBase.set(this, 'compositePrice', value);

//   @override
//   Stream<RealmObjectChanges<TransactionItem>> get changes =>
//       RealmObjectBase.getChanges<TransactionItem>(this);

//   @override
//   Stream<RealmObjectChanges<TransactionItem>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<TransactionItem>(this, keyPaths);

//   @override
//   TransactionItem freeze() =>
//       RealmObjectBase.freezeObject<TransactionItem>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'name': name,
//       'quantityRequested': quantityRequested,
//       'quantityApproved': quantityApproved,
//       'quantityShipped': quantityShipped,
//       'transactionId': transactionId,
//       'variantId': variantId,
//       'qty': qty,
//       'price': price,
//       'discount': discount,
//       'type': type,
//       'remainingStock': remainingStock,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'isTaxExempted': isTaxExempted,
//       'isRefunded': isRefunded,
//       'doneWithTransaction': doneWithTransaction,
//       'active': active,
//       'dcRt': dcRt,
//       'dcAmt': dcAmt,
//       'taxblAmt': taxblAmt,
//       'taxAmt': taxAmt,
//       'totAmt': totAmt,
//       'itemSeq': itemSeq,
//       'isrccCd': isrccCd,
//       'isrccNm': isrccNm,
//       'isrcRt': isrcRt,
//       'isrcAmt': isrcAmt,
//       'taxTyCd': taxTyCd,
//       'bcd': bcd,
//       'itemClsCd': itemClsCd,
//       'itemTyCd': itemTyCd,
//       'itemStdNm': itemStdNm,
//       'orgnNatCd': orgnNatCd,
//       'pkg': pkg,
//       'itemCd': itemCd,
//       'pkgUnitCd': pkgUnitCd,
//       'qtyUnitCd': qtyUnitCd,
//       'itemNm': itemNm,
//       'prc': prc,
//       'splyAmt': splyAmt,
//       'tin': tin,
//       'bhfId': bhfId,
//       'dftPrc': dftPrc,
//       'addInfo': addInfo,
//       'isrcAplcbYn': isrcAplcbYn,
//       'useYn': useYn,
//       'regrId': regrId,
//       'regrNm': regrNm,
//       'modrId': modrId,
//       'modrNm': modrNm,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'branchId': branchId,
//       'ebmSynced': ebmSynced,
//       'partOfComposite': partOfComposite,
//       'compositePrice': compositePrice,
//     };
//   }

//   static EJsonValue _toEJson(TransactionItem value) => value;
//   static TransactionItem _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         TransactionItem(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           name: fromEJson(ejson['name']),
//           quantityRequested: fromEJson(ejson['quantityRequested']),
//           quantityApproved: fromEJson(ejson['quantityApproved']),
//           quantityShipped: fromEJson(ejson['quantityShipped']),
//           transactionId: fromEJson(ejson['transactionId']),
//           variantId: fromEJson(ejson['variantId']),
//           qty: fromEJson(ejson['qty'], defaultValue: 0.0),
//           price: fromEJson(ejson['price'], defaultValue: 0.0),
//           discount: fromEJson(ejson['discount'], defaultValue: 0.0),
//           type: fromEJson(ejson['type']),
//           remainingStock: fromEJson(ejson['remainingStock'], defaultValue: 0.0),
//           createdAt: fromEJson(ejson['createdAt']),
//           updatedAt: fromEJson(ejson['updatedAt']),
//           isTaxExempted: fromEJson(ejson['isTaxExempted'], defaultValue: false),
//           isRefunded: fromEJson(ejson['isRefunded'], defaultValue: false),
//           doneWithTransaction: fromEJson(ejson['doneWithTransaction']),
//           active: fromEJson(ejson['active']),
//           dcRt: fromEJson(ejson['dcRt'], defaultValue: 0.0),
//           dcAmt: fromEJson(ejson['dcAmt'], defaultValue: 0.0),
//           taxblAmt: fromEJson(ejson['taxblAmt'], defaultValue: 0.0),
//           taxAmt: fromEJson(ejson['taxAmt'], defaultValue: 0.0),
//           totAmt: fromEJson(ejson['totAmt'], defaultValue: 0.0),
//           itemSeq: fromEJson(ejson['itemSeq']),
//           isrccCd: fromEJson(ejson['isrccCd']),
//           isrccNm: fromEJson(ejson['isrccNm'], defaultValue: ""),
//           isrcRt: fromEJson(ejson['isrcRt'], defaultValue: 0),
//           isrcAmt: fromEJson(ejson['isrcAmt'], defaultValue: 0),
//           taxTyCd: fromEJson(ejson['taxTyCd']),
//           bcd: fromEJson(ejson['bcd']),
//           itemClsCd: fromEJson(ejson['itemClsCd']),
//           itemTyCd: fromEJson(ejson['itemTyCd']),
//           itemStdNm: fromEJson(ejson['itemStdNm']),
//           orgnNatCd: fromEJson(ejson['orgnNatCd']),
//           pkg: fromEJson(ejson['pkg']),
//           itemCd: fromEJson(ejson['itemCd']),
//           pkgUnitCd: fromEJson(ejson['pkgUnitCd'], defaultValue: "CT"),
//           qtyUnitCd: fromEJson(ejson['qtyUnitCd'], defaultValue: "BX"),
//           itemNm: fromEJson(ejson['itemNm']),
//           prc: fromEJson(ejson['prc'], defaultValue: 0.0),
//           splyAmt: fromEJson(ejson['splyAmt'], defaultValue: 0.0),
//           tin: fromEJson(ejson['tin']),
//           bhfId: fromEJson(ejson['bhfId']),
//           dftPrc: fromEJson(ejson['dftPrc']),
//           addInfo: fromEJson(ejson['addInfo']),
//           isrcAplcbYn: fromEJson(ejson['isrcAplcbYn']),
//           useYn: fromEJson(ejson['useYn']),
//           regrId: fromEJson(ejson['regrId']),
//           regrNm: fromEJson(ejson['regrNm']),
//           modrId: fromEJson(ejson['modrId']),
//           modrNm: fromEJson(ejson['modrNm']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           branchId: fromEJson(ejson['branchId']),
//           ebmSynced: fromEJson(ejson['ebmSynced'], defaultValue: false),
//           partOfComposite:
//               fromEJson(ejson['partOfComposite'], defaultValue: false),
//           compositePrice: fromEJson(ejson['compositePrice'], defaultValue: 0),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(TransactionItem._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, TransactionItem, 'TransactionItem', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('quantityRequested', RealmPropertyType.int,
//           optional: true),
//       SchemaProperty('quantityApproved', RealmPropertyType.int, optional: true),
//       SchemaProperty('quantityShipped', RealmPropertyType.int, optional: true),
//       SchemaProperty('transactionId', RealmPropertyType.int, optional: true),
//       SchemaProperty('variantId', RealmPropertyType.int, optional: true),
//       SchemaProperty('qty', RealmPropertyType.double),
//       SchemaProperty('price', RealmPropertyType.double),
//       SchemaProperty('discount', RealmPropertyType.double),
//       SchemaProperty('type', RealmPropertyType.string, optional: true),
//       SchemaProperty('remainingStock', RealmPropertyType.double),
//       SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('updatedAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('isTaxExempted', RealmPropertyType.bool),
//       SchemaProperty('isRefunded', RealmPropertyType.bool),
//       SchemaProperty('doneWithTransaction', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('active', RealmPropertyType.bool, optional: true),
//       SchemaProperty('dcRt', RealmPropertyType.double),
//       SchemaProperty('dcAmt', RealmPropertyType.double),
//       SchemaProperty('taxblAmt', RealmPropertyType.double),
//       SchemaProperty('taxAmt', RealmPropertyType.double),
//       SchemaProperty('totAmt', RealmPropertyType.double),
//       SchemaProperty('itemSeq', RealmPropertyType.int, optional: true),
//       SchemaProperty('isrccCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('isrccNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('isrcRt', RealmPropertyType.int, optional: true),
//       SchemaProperty('isrcAmt', RealmPropertyType.int, optional: true),
//       SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('bcd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemTyCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemStdNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('orgnNatCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('pkg', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('pkgUnitCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('qtyUnitCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('prc', RealmPropertyType.double),
//       SchemaProperty('splyAmt', RealmPropertyType.double),
//       SchemaProperty('tin', RealmPropertyType.int, optional: true),
//       SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
//       SchemaProperty('dftPrc', RealmPropertyType.double, optional: true),
//       SchemaProperty('addInfo', RealmPropertyType.string, optional: true),
//       SchemaProperty('isrcAplcbYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('useYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('regrId', RealmPropertyType.string, optional: true),
//       SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('modrId', RealmPropertyType.string, optional: true),
//       SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('ebmSynced', RealmPropertyType.bool),
//       SchemaProperty('partOfComposite', RealmPropertyType.bool),
//       SchemaProperty('compositePrice', RealmPropertyType.double),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class ITransaction extends _ITransaction
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   ITransaction(
//     ObjectId realmId, {
//     int? id,
//     String? reference,
//     String? categoryId,
//     String? transactionNumber,
//     int? branchId,
//     String? status,
//     String? transactionType,
//     double subTotal = 0.0,
//     String? paymentType,
//     double cashReceived = 0.0,
//     double customerChangeDue = 0.0,
//     String? createdAt,
//     String? receiptType,
//     String? updatedAt,
//     int? customerId,
//     String? customerType,
//     String? note,
//     DateTime? lastTouched,
//     String? ticketName,
//     DateTime? deletedAt,
//     int? supplierId,
//     bool ebmSynced = false,
//     bool isIncome = false,
//     bool isExpense = false,
//     bool isRefunded = false,
//     String? customerName,
//     String? customerTin,
//     String? remark,
//     String? customerBhfId,
//     String? sarTyCd,
//     int? receiptNumber,
//     int? totalReceiptNumber,
//     int? invoiceNumber,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<ITransaction>({
//         'subTotal': 0.0,
//         'cashReceived': 0.0,
//         'customerChangeDue': 0.0,
//         'ebmSynced': false,
//         'isIncome': false,
//         'isExpense': false,
//         'isRefunded': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'reference', reference);
//     RealmObjectBase.set(this, 'categoryId', categoryId);
//     RealmObjectBase.set(this, 'transactionNumber', transactionNumber);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'status', status);
//     RealmObjectBase.set(this, 'transactionType', transactionType);
//     RealmObjectBase.set(this, 'subTotal', subTotal);
//     RealmObjectBase.set(this, 'paymentType', paymentType);
//     RealmObjectBase.set(this, 'cashReceived', cashReceived);
//     RealmObjectBase.set(this, 'customerChangeDue', customerChangeDue);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'receiptType', receiptType);
//     RealmObjectBase.set(this, 'updatedAt', updatedAt);
//     RealmObjectBase.set(this, 'customerId', customerId);
//     RealmObjectBase.set(this, 'customerType', customerType);
//     RealmObjectBase.set(this, 'note', note);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'ticketName', ticketName);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'supplierId', supplierId);
//     RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
//     RealmObjectBase.set(this, 'isIncome', isIncome);
//     RealmObjectBase.set(this, 'isExpense', isExpense);
//     RealmObjectBase.set(this, 'isRefunded', isRefunded);
//     RealmObjectBase.set(this, 'customerName', customerName);
//     RealmObjectBase.set(this, 'customerTin', customerTin);
//     RealmObjectBase.set(this, 'remark', remark);
//     RealmObjectBase.set(this, 'customerBhfId', customerBhfId);
//     RealmObjectBase.set(this, 'sarTyCd', sarTyCd);
//     RealmObjectBase.set(this, 'receiptNumber', receiptNumber);
//     RealmObjectBase.set(this, 'totalReceiptNumber', totalReceiptNumber);
//     RealmObjectBase.set(this, 'invoiceNumber', invoiceNumber);
//   }

//   ITransaction._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get reference =>
//       RealmObjectBase.get<String>(this, 'reference') as String?;
//   @override
//   set reference(String? value) => RealmObjectBase.set(this, 'reference', value);

//   @override
//   String? get categoryId =>
//       RealmObjectBase.get<String>(this, 'categoryId') as String?;
//   @override
//   set categoryId(String? value) =>
//       RealmObjectBase.set(this, 'categoryId', value);

//   @override
//   String? get transactionNumber =>
//       RealmObjectBase.get<String>(this, 'transactionNumber') as String?;
//   @override
//   set transactionNumber(String? value) =>
//       RealmObjectBase.set(this, 'transactionNumber', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   String? get status => RealmObjectBase.get<String>(this, 'status') as String?;
//   @override
//   set status(String? value) => RealmObjectBase.set(this, 'status', value);

//   @override
//   String? get transactionType =>
//       RealmObjectBase.get<String>(this, 'transactionType') as String?;
//   @override
//   set transactionType(String? value) =>
//       RealmObjectBase.set(this, 'transactionType', value);

//   @override
//   double get subTotal =>
//       RealmObjectBase.get<double>(this, 'subTotal') as double;
//   @override
//   set subTotal(double value) => RealmObjectBase.set(this, 'subTotal', value);

//   @override
//   String? get paymentType =>
//       RealmObjectBase.get<String>(this, 'paymentType') as String?;
//   @override
//   set paymentType(String? value) =>
//       RealmObjectBase.set(this, 'paymentType', value);

//   @override
//   double get cashReceived =>
//       RealmObjectBase.get<double>(this, 'cashReceived') as double;
//   @override
//   set cashReceived(double value) =>
//       RealmObjectBase.set(this, 'cashReceived', value);

//   @override
//   double get customerChangeDue =>
//       RealmObjectBase.get<double>(this, 'customerChangeDue') as double;
//   @override
//   set customerChangeDue(double value) =>
//       RealmObjectBase.set(this, 'customerChangeDue', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get receiptType =>
//       RealmObjectBase.get<String>(this, 'receiptType') as String?;
//   @override
//   set receiptType(String? value) =>
//       RealmObjectBase.set(this, 'receiptType', value);

//   @override
//   String? get updatedAt =>
//       RealmObjectBase.get<String>(this, 'updatedAt') as String?;
//   @override
//   set updatedAt(String? value) => RealmObjectBase.set(this, 'updatedAt', value);

//   @override
//   int? get customerId => RealmObjectBase.get<int>(this, 'customerId') as int?;
//   @override
//   set customerId(int? value) => RealmObjectBase.set(this, 'customerId', value);

//   @override
//   String? get customerType =>
//       RealmObjectBase.get<String>(this, 'customerType') as String?;
//   @override
//   set customerType(String? value) =>
//       RealmObjectBase.set(this, 'customerType', value);

//   @override
//   String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
//   @override
//   set note(String? value) => RealmObjectBase.set(this, 'note', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   String? get ticketName =>
//       RealmObjectBase.get<String>(this, 'ticketName') as String?;
//   @override
//   set ticketName(String? value) =>
//       RealmObjectBase.set(this, 'ticketName', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   int? get supplierId => RealmObjectBase.get<int>(this, 'supplierId') as int?;
//   @override
//   set supplierId(int? value) => RealmObjectBase.set(this, 'supplierId', value);

//   @override
//   bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
//   @override
//   set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

//   @override
//   bool get isIncome => RealmObjectBase.get<bool>(this, 'isIncome') as bool;
//   @override
//   set isIncome(bool value) => RealmObjectBase.set(this, 'isIncome', value);

//   @override
//   bool get isExpense => RealmObjectBase.get<bool>(this, 'isExpense') as bool;
//   @override
//   set isExpense(bool value) => RealmObjectBase.set(this, 'isExpense', value);

//   @override
//   bool get isRefunded => RealmObjectBase.get<bool>(this, 'isRefunded') as bool;
//   @override
//   set isRefunded(bool value) => RealmObjectBase.set(this, 'isRefunded', value);

//   @override
//   String? get customerName =>
//       RealmObjectBase.get<String>(this, 'customerName') as String?;
//   @override
//   set customerName(String? value) =>
//       RealmObjectBase.set(this, 'customerName', value);

//   @override
//   String? get customerTin =>
//       RealmObjectBase.get<String>(this, 'customerTin') as String?;
//   @override
//   set customerTin(String? value) =>
//       RealmObjectBase.set(this, 'customerTin', value);

//   @override
//   String? get remark => RealmObjectBase.get<String>(this, 'remark') as String?;
//   @override
//   set remark(String? value) => RealmObjectBase.set(this, 'remark', value);

//   @override
//   String? get customerBhfId =>
//       RealmObjectBase.get<String>(this, 'customerBhfId') as String?;
//   @override
//   set customerBhfId(String? value) =>
//       RealmObjectBase.set(this, 'customerBhfId', value);

//   @override
//   String? get sarTyCd =>
//       RealmObjectBase.get<String>(this, 'sarTyCd') as String?;
//   @override
//   set sarTyCd(String? value) => RealmObjectBase.set(this, 'sarTyCd', value);

//   @override
//   int? get receiptNumber =>
//       RealmObjectBase.get<int>(this, 'receiptNumber') as int?;
//   @override
//   set receiptNumber(int? value) =>
//       RealmObjectBase.set(this, 'receiptNumber', value);

//   @override
//   int? get totalReceiptNumber =>
//       RealmObjectBase.get<int>(this, 'totalReceiptNumber') as int?;
//   @override
//   set totalReceiptNumber(int? value) =>
//       RealmObjectBase.set(this, 'totalReceiptNumber', value);

//   @override
//   int? get invoiceNumber =>
//       RealmObjectBase.get<int>(this, 'invoiceNumber') as int?;
//   @override
//   set invoiceNumber(int? value) =>
//       RealmObjectBase.set(this, 'invoiceNumber', value);

//   @override
//   Stream<RealmObjectChanges<ITransaction>> get changes =>
//       RealmObjectBase.getChanges<ITransaction>(this);

//   @override
//   Stream<RealmObjectChanges<ITransaction>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<ITransaction>(this, keyPaths);

//   @override
//   ITransaction freeze() => RealmObjectBase.freezeObject<ITransaction>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'reference': reference,
//       'categoryId': categoryId,
//       'transactionNumber': transactionNumber,
//       'branchId': branchId,
//       'status': status,
//       'transactionType': transactionType,
//       'subTotal': subTotal,
//       'paymentType': paymentType,
//       'cashReceived': cashReceived,
//       'customerChangeDue': customerChangeDue,
//       'createdAt': createdAt,
//       'receiptType': receiptType,
//       'updatedAt': updatedAt,
//       'customerId': customerId,
//       'customerType': customerType,
//       'note': note,
//       'lastTouched': lastTouched,
//       'ticketName': ticketName,
//       'deletedAt': deletedAt,
//       'supplierId': supplierId,
//       'ebmSynced': ebmSynced,
//       'isIncome': isIncome,
//       'isExpense': isExpense,
//       'isRefunded': isRefunded,
//       'customerName': customerName,
//       'customerTin': customerTin,
//       'remark': remark,
//       'customerBhfId': customerBhfId,
//       'sarTyCd': sarTyCd,
//       'receiptNumber': receiptNumber,
//       'totalReceiptNumber': totalReceiptNumber,
//       'invoiceNumber': invoiceNumber,
//     };
//   }

//   static EJsonValue _toEJson(ITransaction value) => value;
//   static ITransaction _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         ITransaction(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           reference: fromEJson(ejson['reference']),
//           categoryId: fromEJson(ejson['categoryId']),
//           transactionNumber: fromEJson(ejson['transactionNumber']),
//           branchId: fromEJson(ejson['branchId']),
//           status: fromEJson(ejson['status']),
//           transactionType: fromEJson(ejson['transactionType']),
//           subTotal: fromEJson(ejson['subTotal'], defaultValue: 0.0),
//           paymentType: fromEJson(ejson['paymentType']),
//           cashReceived: fromEJson(ejson['cashReceived'], defaultValue: 0.0),
//           customerChangeDue:
//               fromEJson(ejson['customerChangeDue'], defaultValue: 0.0),
//           createdAt: fromEJson(ejson['createdAt']),
//           receiptType: fromEJson(ejson['receiptType']),
//           updatedAt: fromEJson(ejson['updatedAt']),
//           customerId: fromEJson(ejson['customerId']),
//           customerType: fromEJson(ejson['customerType']),
//           note: fromEJson(ejson['note']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           ticketName: fromEJson(ejson['ticketName']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           supplierId: fromEJson(ejson['supplierId']),
//           ebmSynced: fromEJson(ejson['ebmSynced'], defaultValue: false),
//           isIncome: fromEJson(ejson['isIncome'], defaultValue: false),
//           isExpense: fromEJson(ejson['isExpense'], defaultValue: false),
//           isRefunded: fromEJson(ejson['isRefunded'], defaultValue: false),
//           customerName: fromEJson(ejson['customerName']),
//           customerTin: fromEJson(ejson['customerTin']),
//           remark: fromEJson(ejson['remark']),
//           customerBhfId: fromEJson(ejson['customerBhfId']),
//           sarTyCd: fromEJson(ejson['sarTyCd']),
//           receiptNumber: fromEJson(ejson['receiptNumber']),
//           totalReceiptNumber: fromEJson(ejson['totalReceiptNumber']),
//           invoiceNumber: fromEJson(ejson['invoiceNumber']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(ITransaction._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, ITransaction, 'ITransaction', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('reference', RealmPropertyType.string, optional: true),
//       SchemaProperty('categoryId', RealmPropertyType.string, optional: true),
//       SchemaProperty('transactionNumber', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int,
//           optional: true, indexType: RealmIndexType.regular),
//       SchemaProperty('status', RealmPropertyType.string,
//           optional: true, indexType: RealmIndexType.regular),
//       SchemaProperty('transactionType', RealmPropertyType.string,
//           optional: true, indexType: RealmIndexType.regular),
//       SchemaProperty('subTotal', RealmPropertyType.double),
//       SchemaProperty('paymentType', RealmPropertyType.string, optional: true),
//       SchemaProperty('cashReceived', RealmPropertyType.double),
//       SchemaProperty('customerChangeDue', RealmPropertyType.double),
//       SchemaProperty('createdAt', RealmPropertyType.string,
//           optional: true, indexType: RealmIndexType.regular),
//       SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
//       SchemaProperty('updatedAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('customerId', RealmPropertyType.int,
//           optional: true, indexType: RealmIndexType.regular),
//       SchemaProperty('customerType', RealmPropertyType.string, optional: true),
//       SchemaProperty('note', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('ticketName', RealmPropertyType.string, optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('supplierId', RealmPropertyType.int, optional: true),
//       SchemaProperty('ebmSynced', RealmPropertyType.bool),
//       SchemaProperty('isIncome', RealmPropertyType.bool),
//       SchemaProperty('isExpense', RealmPropertyType.bool),
//       SchemaProperty('isRefunded', RealmPropertyType.bool),
//       SchemaProperty('customerName', RealmPropertyType.string, optional: true),
//       SchemaProperty('customerTin', RealmPropertyType.string, optional: true),
//       SchemaProperty('remark', RealmPropertyType.string, optional: true),
//       SchemaProperty('customerBhfId', RealmPropertyType.string, optional: true),
//       SchemaProperty('sarTyCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('receiptNumber', RealmPropertyType.int, optional: true),
//       SchemaProperty('totalReceiptNumber', RealmPropertyType.int,
//           optional: true),
//       SchemaProperty('invoiceNumber', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class IUnit extends _IUnit with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   IUnit(
//     ObjectId realmId, {
//     int? id,
//     int? branchId,
//     String? name,
//     String? value,
//     bool active = false,
//     DateTime? lastTouched,
//     String? createdAt,
//     DateTime? deletedAt,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<IUnit>({
//         'active': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'value', value);
//     RealmObjectBase.set(this, 'active', active);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   IUnit._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   String? get value => RealmObjectBase.get<String>(this, 'value') as String?;
//   @override
//   set value(String? value) => RealmObjectBase.set(this, 'value', value);

//   @override
//   bool get active => RealmObjectBase.get<bool>(this, 'active') as bool;
//   @override
//   set active(bool value) => RealmObjectBase.set(this, 'active', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   String? get createdAt =>
//       RealmObjectBase.get<String>(this, 'createdAt') as String?;
//   @override
//   set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<IUnit>> get changes =>
//       RealmObjectBase.getChanges<IUnit>(this);

//   @override
//   Stream<RealmObjectChanges<IUnit>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<IUnit>(this, keyPaths);

//   @override
//   IUnit freeze() => RealmObjectBase.freezeObject<IUnit>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'branchId': branchId,
//       'name': name,
//       'value': value,
//       'active': active,
//       'lastTouched': lastTouched,
//       'createdAt': createdAt,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(IUnit value) => value;
//   static IUnit _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         IUnit(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           branchId: fromEJson(ejson['branchId']),
//           name: fromEJson(ejson['name']),
//           value: fromEJson(ejson['value']),
//           active: fromEJson(ejson['active'], defaultValue: false),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           createdAt: fromEJson(ejson['createdAt']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(IUnit._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, IUnit, 'IUnit', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('value', RealmPropertyType.string, optional: true),
//       SchemaProperty('active', RealmPropertyType.bool),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Voucher extends _Voucher with RealmEntity, RealmObjectBase, RealmObject {
//   Voucher(
//     ObjectId realmId, {
//     int? id,
//     int? value,
//     int? interval,
//     bool? used,
//     int? createdAt,
//     int? usedAt,
//     String? descriptor,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'value', value);
//     RealmObjectBase.set(this, 'interval', interval);
//     RealmObjectBase.set(this, 'used', used);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'usedAt', usedAt);
//     RealmObjectBase.set(this, 'descriptor', descriptor);
//   }

//   Voucher._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get value => RealmObjectBase.get<int>(this, 'value') as int?;
//   @override
//   set value(int? value) => RealmObjectBase.set(this, 'value', value);

//   @override
//   int? get interval => RealmObjectBase.get<int>(this, 'interval') as int?;
//   @override
//   set interval(int? value) => RealmObjectBase.set(this, 'interval', value);

//   @override
//   bool? get used => RealmObjectBase.get<bool>(this, 'used') as bool?;
//   @override
//   set used(bool? value) => RealmObjectBase.set(this, 'used', value);

//   @override
//   int? get createdAt => RealmObjectBase.get<int>(this, 'createdAt') as int?;
//   @override
//   set createdAt(int? value) => RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   int? get usedAt => RealmObjectBase.get<int>(this, 'usedAt') as int?;
//   @override
//   set usedAt(int? value) => RealmObjectBase.set(this, 'usedAt', value);

//   @override
//   String? get descriptor =>
//       RealmObjectBase.get<String>(this, 'descriptor') as String?;
//   @override
//   set descriptor(String? value) =>
//       RealmObjectBase.set(this, 'descriptor', value);

//   @override
//   Stream<RealmObjectChanges<Voucher>> get changes =>
//       RealmObjectBase.getChanges<Voucher>(this);

//   @override
//   Stream<RealmObjectChanges<Voucher>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Voucher>(this, keyPaths);

//   @override
//   Voucher freeze() => RealmObjectBase.freezeObject<Voucher>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'value': value,
//       'interval': interval,
//       'used': used,
//       'createdAt': createdAt,
//       'usedAt': usedAt,
//       'descriptor': descriptor,
//     };
//   }

//   static EJsonValue _toEJson(Voucher value) => value;
//   static Voucher _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Voucher(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           value: fromEJson(ejson['value']),
//           interval: fromEJson(ejson['interval']),
//           used: fromEJson(ejson['used']),
//           createdAt: fromEJson(ejson['createdAt']),
//           usedAt: fromEJson(ejson['usedAt']),
//           descriptor: fromEJson(ejson['descriptor']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Voucher._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Voucher, 'Voucher', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('value', RealmPropertyType.int, optional: true),
//       SchemaProperty('interval', RealmPropertyType.int, optional: true),
//       SchemaProperty('used', RealmPropertyType.bool, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.int, optional: true),
//       SchemaProperty('usedAt', RealmPropertyType.int, optional: true),
//       SchemaProperty('descriptor', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Tenant extends _Tenant with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Tenant(
//     ObjectId realmId, {
//     int? id,
//     String? name,
//     String? phoneNumber,
//     String? email,
//     bool nfcEnabled = false,
//     int? businessId,
//     int? userId,
//     String? imageUrl,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//     int? pin,
//     bool? sessionActive,
//     bool? isDefault,
//     bool isLongPressed = false,
//     String type = "Agent",
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Tenant>({
//         'nfcEnabled': false,
//         'isLongPressed': false,
//         'type': "Agent",
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
//     RealmObjectBase.set(this, 'email', email);
//     RealmObjectBase.set(this, 'nfcEnabled', nfcEnabled);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'imageUrl', imageUrl);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//     RealmObjectBase.set(this, 'pin', pin);
//     RealmObjectBase.set(this, 'sessionActive', sessionActive);
//     RealmObjectBase.set(this, 'isDefault', isDefault);
//     RealmObjectBase.set(this, 'isLongPressed', isLongPressed);
//     RealmObjectBase.set(this, 'type', type);
//   }

//   Tenant._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   String? get phoneNumber =>
//       RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
//   @override
//   set phoneNumber(String? value) =>
//       RealmObjectBase.set(this, 'phoneNumber', value);

//   @override
//   String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
//   @override
//   set email(String? value) => RealmObjectBase.set(this, 'email', value);

//   @override
//   bool get nfcEnabled => RealmObjectBase.get<bool>(this, 'nfcEnabled') as bool;
//   @override
//   set nfcEnabled(bool value) => RealmObjectBase.set(this, 'nfcEnabled', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get imageUrl =>
//       RealmObjectBase.get<String>(this, 'imageUrl') as String?;
//   @override
//   set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   int? get pin => RealmObjectBase.get<int>(this, 'pin') as int?;
//   @override
//   set pin(int? value) => RealmObjectBase.set(this, 'pin', value);

//   @override
//   bool? get sessionActive =>
//       RealmObjectBase.get<bool>(this, 'sessionActive') as bool?;
//   @override
//   set sessionActive(bool? value) =>
//       RealmObjectBase.set(this, 'sessionActive', value);

//   @override
//   bool? get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool?;
//   @override
//   set isDefault(bool? value) => RealmObjectBase.set(this, 'isDefault', value);

//   @override
//   bool get isLongPressed =>
//       RealmObjectBase.get<bool>(this, 'isLongPressed') as bool;
//   @override
//   set isLongPressed(bool value) =>
//       RealmObjectBase.set(this, 'isLongPressed', value);

//   @override
//   String get type => RealmObjectBase.get<String>(this, 'type') as String;
//   @override
//   set type(String value) => RealmObjectBase.set(this, 'type', value);

//   @override
//   Stream<RealmObjectChanges<Tenant>> get changes =>
//       RealmObjectBase.getChanges<Tenant>(this);

//   @override
//   Stream<RealmObjectChanges<Tenant>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Tenant>(this, keyPaths);

//   @override
//   Tenant freeze() => RealmObjectBase.freezeObject<Tenant>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'name': name,
//       'phoneNumber': phoneNumber,
//       'email': email,
//       'nfcEnabled': nfcEnabled,
//       'businessId': businessId,
//       'userId': userId,
//       'imageUrl': imageUrl,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//       'pin': pin,
//       'sessionActive': sessionActive,
//       'isDefault': isDefault,
//       'isLongPressed': isLongPressed,
//       'type': type,
//     };
//   }

//   static EJsonValue _toEJson(Tenant value) => value;
//   static Tenant _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Tenant(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           name: fromEJson(ejson['name']),
//           phoneNumber: fromEJson(ejson['phoneNumber']),
//           email: fromEJson(ejson['email']),
//           nfcEnabled: fromEJson(ejson['nfcEnabled'], defaultValue: false),
//           businessId: fromEJson(ejson['businessId']),
//           userId: fromEJson(ejson['userId']),
//           imageUrl: fromEJson(ejson['imageUrl']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//           pin: fromEJson(ejson['pin']),
//           sessionActive: fromEJson(ejson['sessionActive']),
//           isDefault: fromEJson(ejson['isDefault']),
//           isLongPressed: fromEJson(ejson['isLongPressed'], defaultValue: false),
//           type: fromEJson(ejson['type'], defaultValue: "Agent"),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Tenant._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Tenant, 'Tenant', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
//       SchemaProperty('email', RealmPropertyType.string, optional: true),
//       SchemaProperty('nfcEnabled', RealmPropertyType.bool),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('pin', RealmPropertyType.int, optional: true),
//       SchemaProperty('sessionActive', RealmPropertyType.bool, optional: true),
//       SchemaProperty('isDefault', RealmPropertyType.bool, optional: true),
//       SchemaProperty('isLongPressed', RealmPropertyType.bool),
//       SchemaProperty('type', RealmPropertyType.string),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Pin extends _Pin with RealmEntity, RealmObjectBase, RealmObject {
//   Pin(
//     ObjectId? realmId, {
//     int? id,
//     int? userId,
//     String? phoneNumber,
//     int? pin,
//     int? branchId,
//     int? businessId,
//     String? ownerName,
//     String? tokenUid,
//     String? uid,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
//     RealmObjectBase.set(this, 'pin', pin);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'ownerName', ownerName);
//     RealmObjectBase.set(this, 'tokenUid', tokenUid);
//     RealmObjectBase.set(this, 'uid', uid);
//   }

//   Pin._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId? get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
//   @override
//   set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get phoneNumber =>
//       RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
//   @override
//   set phoneNumber(String? value) =>
//       RealmObjectBase.set(this, 'phoneNumber', value);

//   @override
//   int? get pin => RealmObjectBase.get<int>(this, 'pin') as int?;
//   @override
//   set pin(int? value) => RealmObjectBase.set(this, 'pin', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get ownerName =>
//       RealmObjectBase.get<String>(this, 'ownerName') as String?;
//   @override
//   set ownerName(String? value) => RealmObjectBase.set(this, 'ownerName', value);

//   @override
//   String? get tokenUid =>
//       RealmObjectBase.get<String>(this, 'tokenUid') as String?;
//   @override
//   set tokenUid(String? value) => RealmObjectBase.set(this, 'tokenUid', value);

//   @override
//   String? get uid => RealmObjectBase.get<String>(this, 'uid') as String?;
//   @override
//   set uid(String? value) => RealmObjectBase.set(this, 'uid', value);

//   @override
//   Stream<RealmObjectChanges<Pin>> get changes =>
//       RealmObjectBase.getChanges<Pin>(this);

//   @override
//   Stream<RealmObjectChanges<Pin>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Pin>(this, keyPaths);

//   @override
//   Pin freeze() => RealmObjectBase.freezeObject<Pin>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'userId': userId,
//       'phoneNumber': phoneNumber,
//       'pin': pin,
//       'branchId': branchId,
//       'businessId': businessId,
//       'ownerName': ownerName,
//       'tokenUid': tokenUid,
//       'uid': uid,
//     };
//   }

//   static EJsonValue _toEJson(Pin value) => value;
//   static Pin _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Pin(
//           fromEJson(ejson['_id']),
//           id: fromEJson(ejson['id']),
//           userId: fromEJson(ejson['userId']),
//           phoneNumber: fromEJson(ejson['phoneNumber']),
//           pin: fromEJson(ejson['pin']),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           ownerName: fromEJson(ejson['ownerName']),
//           tokenUid: fromEJson(ejson['tokenUid']),
//           uid: fromEJson(ejson['uid']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Pin._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Pin, 'Pin', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', optional: true, primaryKey: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
//       SchemaProperty('pin', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('ownerName', RealmPropertyType.string, optional: true),
//       SchemaProperty('tokenUid', RealmPropertyType.string, optional: true),
//       SchemaProperty('uid', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class LPermission extends _LPermission
//     with RealmEntity, RealmObjectBase, RealmObject {
//   LPermission(
//     ObjectId? realmId, {
//     int? id,
//     String? name,
//     int? userId,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'name', name);
//     RealmObjectBase.set(this, 'userId', userId);
//   }

//   LPermission._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId? get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
//   @override
//   set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
//   @override
//   set name(String? value) => RealmObjectBase.set(this, 'name', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   Stream<RealmObjectChanges<LPermission>> get changes =>
//       RealmObjectBase.getChanges<LPermission>(this);

//   @override
//   Stream<RealmObjectChanges<LPermission>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<LPermission>(this, keyPaths);

//   @override
//   LPermission freeze() => RealmObjectBase.freezeObject<LPermission>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'name': name,
//       'userId': userId,
//     };
//   }

//   static EJsonValue _toEJson(LPermission value) => value;
//   static LPermission _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         LPermission(
//           fromEJson(ejson['_id']),
//           id: fromEJson(ejson['id']),
//           name: fromEJson(ejson['name']),
//           userId: fromEJson(ejson['userId']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(LPermission._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, LPermission, 'LPermission', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', optional: true, primaryKey: true),
//       SchemaProperty('name', RealmPropertyType.string, optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Token extends _Token with RealmEntity, RealmObjectBase, RealmObject {
//   Token(
//     ObjectId? realmId, {
//     int? id,
//     String? type,
//     String? token,
//     DateTime? validFrom,
//     DateTime? validUntil,
//     int? businessId,
//     DateTime? lastTouched,
//     DateTime? deletedAt,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'type', type);
//     RealmObjectBase.set(this, 'token', token);
//     RealmObjectBase.set(this, 'validFrom', validFrom);
//     RealmObjectBase.set(this, 'validUntil', validUntil);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'deletedAt', deletedAt);
//   }

//   Token._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId? get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
//   @override
//   set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
//   @override
//   set type(String? value) => RealmObjectBase.set(this, 'type', value);

//   @override
//   String? get token => RealmObjectBase.get<String>(this, 'token') as String?;
//   @override
//   set token(String? value) => RealmObjectBase.set(this, 'token', value);

//   @override
//   DateTime? get validFrom =>
//       RealmObjectBase.get<DateTime>(this, 'validFrom') as DateTime?;
//   @override
//   set validFrom(DateTime? value) =>
//       RealmObjectBase.set(this, 'validFrom', value);

//   @override
//   DateTime? get validUntil =>
//       RealmObjectBase.get<DateTime>(this, 'validUntil') as DateTime?;
//   @override
//   set validUntil(DateTime? value) =>
//       RealmObjectBase.set(this, 'validUntil', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   DateTime? get deletedAt =>
//       RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
//   @override
//   set deletedAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'deletedAt', value);

//   @override
//   Stream<RealmObjectChanges<Token>> get changes =>
//       RealmObjectBase.getChanges<Token>(this);

//   @override
//   Stream<RealmObjectChanges<Token>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Token>(this, keyPaths);

//   @override
//   Token freeze() => RealmObjectBase.freezeObject<Token>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'type': type,
//       'token': token,
//       'validFrom': validFrom,
//       'validUntil': validUntil,
//       'businessId': businessId,
//       'lastTouched': lastTouched,
//       'deletedAt': deletedAt,
//     };
//   }

//   static EJsonValue _toEJson(Token value) => value;
//   static Token _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Token(
//           fromEJson(ejson['_id']),
//           id: fromEJson(ejson['id']),
//           type: fromEJson(ejson['type']),
//           token: fromEJson(ejson['token']),
//           validFrom: fromEJson(ejson['validFrom']),
//           validUntil: fromEJson(ejson['validUntil']),
//           businessId: fromEJson(ejson['businessId']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           deletedAt: fromEJson(ejson['deletedAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Token._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Token, 'Token', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', optional: true, primaryKey: true),
//       SchemaProperty('type', RealmPropertyType.string, optional: true),
//       SchemaProperty('token', RealmPropertyType.string, optional: true),
//       SchemaProperty('validFrom', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('validUntil', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Activity extends _Activity
//     with RealmEntity, RealmObjectBase, RealmObject {
//   Activity(
//     ObjectId realmId,
//     String action, {
//     int? id,
//     DateTime? timestamp,
//     DateTime? lastTouched,
//     int? userId,
//     String? event,
//     RealmValue details = const RealmValue.nullValue(),
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'timestamp', timestamp);
//     RealmObjectBase.set(this, 'lastTouched', lastTouched);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'event', event);
//     RealmObjectBase.set(this, 'details', details);
//     RealmObjectBase.set(this, 'action', action);
//   }

//   Activity._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   DateTime? get timestamp =>
//       RealmObjectBase.get<DateTime>(this, 'timestamp') as DateTime?;
//   @override
//   set timestamp(DateTime? value) =>
//       RealmObjectBase.set(this, 'timestamp', value);

//   @override
//   DateTime? get lastTouched =>
//       RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
//   @override
//   set lastTouched(DateTime? value) =>
//       RealmObjectBase.set(this, 'lastTouched', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get event => RealmObjectBase.get<String>(this, 'event') as String?;
//   @override
//   set event(String? value) => RealmObjectBase.set(this, 'event', value);

//   @override
//   RealmValue get details =>
//       RealmObjectBase.get<RealmValue>(this, 'details') as RealmValue;
//   @override
//   set details(RealmValue value) => RealmObjectBase.set(this, 'details', value);

//   @override
//   String get action => RealmObjectBase.get<String>(this, 'action') as String;
//   @override
//   set action(String value) => RealmObjectBase.set(this, 'action', value);

//   @override
//   Stream<RealmObjectChanges<Activity>> get changes =>
//       RealmObjectBase.getChanges<Activity>(this);

//   @override
//   Stream<RealmObjectChanges<Activity>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Activity>(this, keyPaths);

//   @override
//   Activity freeze() => RealmObjectBase.freezeObject<Activity>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'timestamp': timestamp,
//       'lastTouched': lastTouched,
//       'userId': userId,
//       'event': event,
//       'details': details,
//       'action': action,
//     };
//   }

//   static EJsonValue _toEJson(Activity value) => value;
//   static Activity _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//         'action': EJsonValue action,
//       } =>
//         Activity(
//           fromEJson(realmId),
//           fromEJson(action),
//           id: fromEJson(ejson['id']),
//           timestamp: fromEJson(ejson['timestamp']),
//           lastTouched: fromEJson(ejson['lastTouched']),
//           userId: fromEJson(ejson['userId']),
//           event: fromEJson(ejson['event']),
//           details: fromEJson(ejson['details']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Activity._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Activity, 'Activity', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('timestamp', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('lastTouched', RealmPropertyType.timestamp,
//           optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('event', RealmPropertyType.string, optional: true),
//       SchemaProperty('details', RealmPropertyType.mixed, optional: true),
//       SchemaProperty('action', RealmPropertyType.string),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class UnversalProduct extends _UnversalProduct
//     with RealmEntity, RealmObjectBase, RealmObject {
//   UnversalProduct(
//     ObjectId realmId, {
//     int? id,
//     String? itemClsCd,
//     String? itemClsNm,
//     int? itemClsLvl,
//     String? taxTyCd,
//     String? mjrTgYn,
//     String? useYn,
//     int? businessId,
//     int? branchId,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
//     RealmObjectBase.set(this, 'itemClsNm', itemClsNm);
//     RealmObjectBase.set(this, 'itemClsLvl', itemClsLvl);
//     RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
//     RealmObjectBase.set(this, 'mjrTgYn', mjrTgYn);
//     RealmObjectBase.set(this, 'useYn', useYn);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//   }

//   UnversalProduct._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get itemClsCd =>
//       RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
//   @override
//   set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

//   @override
//   String? get itemClsNm =>
//       RealmObjectBase.get<String>(this, 'itemClsNm') as String?;
//   @override
//   set itemClsNm(String? value) => RealmObjectBase.set(this, 'itemClsNm', value);

//   @override
//   int? get itemClsLvl => RealmObjectBase.get<int>(this, 'itemClsLvl') as int?;
//   @override
//   set itemClsLvl(int? value) => RealmObjectBase.set(this, 'itemClsLvl', value);

//   @override
//   String? get taxTyCd =>
//       RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
//   @override
//   set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

//   @override
//   String? get mjrTgYn =>
//       RealmObjectBase.get<String>(this, 'mjrTgYn') as String?;
//   @override
//   set mjrTgYn(String? value) => RealmObjectBase.set(this, 'mjrTgYn', value);

//   @override
//   String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
//   @override
//   set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   Stream<RealmObjectChanges<UnversalProduct>> get changes =>
//       RealmObjectBase.getChanges<UnversalProduct>(this);

//   @override
//   Stream<RealmObjectChanges<UnversalProduct>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<UnversalProduct>(this, keyPaths);

//   @override
//   UnversalProduct freeze() =>
//       RealmObjectBase.freezeObject<UnversalProduct>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'itemClsCd': itemClsCd,
//       'itemClsNm': itemClsNm,
//       'itemClsLvl': itemClsLvl,
//       'taxTyCd': taxTyCd,
//       'mjrTgYn': mjrTgYn,
//       'useYn': useYn,
//       'businessId': businessId,
//       'branchId': branchId,
//     };
//   }

//   static EJsonValue _toEJson(UnversalProduct value) => value;
//   static UnversalProduct _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         UnversalProduct(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           itemClsCd: fromEJson(ejson['itemClsCd']),
//           itemClsNm: fromEJson(ejson['itemClsNm']),
//           itemClsLvl: fromEJson(ejson['itemClsLvl']),
//           taxTyCd: fromEJson(ejson['taxTyCd']),
//           mjrTgYn: fromEJson(ejson['mjrTgYn']),
//           useYn: fromEJson(ejson['useYn']),
//           businessId: fromEJson(ejson['businessId']),
//           branchId: fromEJson(ejson['branchId']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(UnversalProduct._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, UnversalProduct, 'UnversalProduct', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemClsNm', RealmPropertyType.string, optional: true),
//       SchemaProperty('itemClsLvl', RealmPropertyType.int, optional: true),
//       SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
//       SchemaProperty('mjrTgYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('useYn', RealmPropertyType.string, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Configurations extends _Configurations
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Configurations(
//     ObjectId realmId, {
//     int? id,
//     String? taxType = "B",
//     double? taxPercentage = 18.0,
//     int? businessId,
//     int? branchId,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Configurations>({
//         'taxType': "B",
//         'taxPercentage': 18.0,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'taxType', taxType);
//     RealmObjectBase.set(this, 'taxPercentage', taxPercentage);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//   }

//   Configurations._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get taxType =>
//       RealmObjectBase.get<String>(this, 'taxType') as String?;
//   @override
//   set taxType(String? value) => RealmObjectBase.set(this, 'taxType', value);

//   @override
//   double? get taxPercentage =>
//       RealmObjectBase.get<double>(this, 'taxPercentage') as double?;
//   @override
//   set taxPercentage(double? value) =>
//       RealmObjectBase.set(this, 'taxPercentage', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   Stream<RealmObjectChanges<Configurations>> get changes =>
//       RealmObjectBase.getChanges<Configurations>(this);

//   @override
//   Stream<RealmObjectChanges<Configurations>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Configurations>(this, keyPaths);

//   @override
//   Configurations freeze() => RealmObjectBase.freezeObject<Configurations>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'taxType': taxType,
//       'taxPercentage': taxPercentage,
//       'businessId': businessId,
//       'branchId': branchId,
//     };
//   }

//   static EJsonValue _toEJson(Configurations value) => value;
//   static Configurations _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Configurations(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           taxType: fromEJson(ejson['taxType'], defaultValue: "B"),
//           taxPercentage: fromEJson(ejson['taxPercentage'], defaultValue: 18.0),
//           businessId: fromEJson(ejson['businessId']),
//           branchId: fromEJson(ejson['branchId']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Configurations._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, Configurations, 'Configurations', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('taxType', RealmPropertyType.string, optional: true),
//       SchemaProperty('taxPercentage', RealmPropertyType.double, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class AppNotification extends _AppNotification
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   AppNotification(
//     ObjectId realmId, {
//     int? id,
//     bool completed = false,
//     String? type = 'transaction',
//     String? message,
//     int? identifier,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<AppNotification>({
//         'completed': false,
//         'type': 'transaction',
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'completed', completed);
//     RealmObjectBase.set(this, 'type', type);
//     RealmObjectBase.set(this, 'message', message);
//     RealmObjectBase.set(this, 'identifier', identifier);
//   }

//   AppNotification._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   bool get completed => RealmObjectBase.get<bool>(this, 'completed') as bool;
//   @override
//   set completed(bool value) => RealmObjectBase.set(this, 'completed', value);

//   @override
//   String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
//   @override
//   set type(String? value) => RealmObjectBase.set(this, 'type', value);

//   @override
//   String? get message =>
//       RealmObjectBase.get<String>(this, 'message') as String?;
//   @override
//   set message(String? value) => RealmObjectBase.set(this, 'message', value);

//   @override
//   int? get identifier => RealmObjectBase.get<int>(this, 'identifier') as int?;
//   @override
//   set identifier(int? value) => RealmObjectBase.set(this, 'identifier', value);

//   @override
//   Stream<RealmObjectChanges<AppNotification>> get changes =>
//       RealmObjectBase.getChanges<AppNotification>(this);

//   @override
//   Stream<RealmObjectChanges<AppNotification>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<AppNotification>(this, keyPaths);

//   @override
//   AppNotification freeze() =>
//       RealmObjectBase.freezeObject<AppNotification>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'completed': completed,
//       'type': type,
//       'message': message,
//       'identifier': identifier,
//     };
//   }

//   static EJsonValue _toEJson(AppNotification value) => value;
//   static AppNotification _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         AppNotification(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           completed: fromEJson(ejson['completed'], defaultValue: false),
//           type: fromEJson(ejson['type'], defaultValue: 'transaction'),
//           message: fromEJson(ejson['message']),
//           identifier: fromEJson(ejson['identifier']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(AppNotification._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, AppNotification, 'AppNotification', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('completed', RealmPropertyType.bool),
//       SchemaProperty('type', RealmPropertyType.string, optional: true),
//       SchemaProperty('message', RealmPropertyType.string, optional: true),
//       SchemaProperty('identifier', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Assets extends _Assets with RealmEntity, RealmObjectBase, RealmObject {
//   Assets(
//     ObjectId realmId, {
//     int? id,
//     int? branchId,
//     int? businessId,
//     String? assetName,
//     int? productId,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'assetName', assetName);
//     RealmObjectBase.set(this, 'productId', productId);
//   }

//   Assets._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get assetName =>
//       RealmObjectBase.get<String>(this, 'assetName') as String?;
//   @override
//   set assetName(String? value) => RealmObjectBase.set(this, 'assetName', value);

//   @override
//   int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
//   @override
//   set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

//   @override
//   Stream<RealmObjectChanges<Assets>> get changes =>
//       RealmObjectBase.getChanges<Assets>(this);

//   @override
//   Stream<RealmObjectChanges<Assets>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Assets>(this, keyPaths);

//   @override
//   Assets freeze() => RealmObjectBase.freezeObject<Assets>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'branchId': branchId,
//       'businessId': businessId,
//       'assetName': assetName,
//       'productId': productId,
//     };
//   }

//   static EJsonValue _toEJson(Assets value) => value;
//   static Assets _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Assets(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           assetName: fromEJson(ejson['assetName']),
//           productId: fromEJson(ejson['productId']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Assets._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Assets, 'Assets', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('assetName', RealmPropertyType.string, optional: true),
//       SchemaProperty('productId', RealmPropertyType.int, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Composite extends _Composite
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Composite(
//     ObjectId realmId, {
//     int? id,
//     int? productId,
//     int? variantId,
//     double? qty = 1.0,
//     int? branchId,
//     int? businessId,
//     double? actualPrice = 0,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Composite>({
//         'qty': 1.0,
//         'actualPrice': 0,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'productId', productId);
//     RealmObjectBase.set(this, 'variantId', variantId);
//     RealmObjectBase.set(this, 'qty', qty);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'actualPrice', actualPrice);
//   }

//   Composite._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
//   @override
//   set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

//   @override
//   int? get variantId => RealmObjectBase.get<int>(this, 'variantId') as int?;
//   @override
//   set variantId(int? value) => RealmObjectBase.set(this, 'variantId', value);

//   @override
//   double? get qty => RealmObjectBase.get<double>(this, 'qty') as double?;
//   @override
//   set qty(double? value) => RealmObjectBase.set(this, 'qty', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   double? get actualPrice =>
//       RealmObjectBase.get<double>(this, 'actualPrice') as double?;
//   @override
//   set actualPrice(double? value) =>
//       RealmObjectBase.set(this, 'actualPrice', value);

//   @override
//   Stream<RealmObjectChanges<Composite>> get changes =>
//       RealmObjectBase.getChanges<Composite>(this);

//   @override
//   Stream<RealmObjectChanges<Composite>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Composite>(this, keyPaths);

//   @override
//   Composite freeze() => RealmObjectBase.freezeObject<Composite>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'productId': productId,
//       'variantId': variantId,
//       'qty': qty,
//       'branchId': branchId,
//       'businessId': businessId,
//       'actualPrice': actualPrice,
//     };
//   }

//   static EJsonValue _toEJson(Composite value) => value;
//   static Composite _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Composite(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           productId: fromEJson(ejson['productId']),
//           variantId: fromEJson(ejson['variantId']),
//           qty: fromEJson(ejson['qty'], defaultValue: 1.0),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           actualPrice: fromEJson(ejson['actualPrice'], defaultValue: 0),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Composite._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Composite, 'Composite', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('productId', RealmPropertyType.int, optional: true),
//       SchemaProperty('variantId', RealmPropertyType.int, optional: true),
//       SchemaProperty('qty', RealmPropertyType.double, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('actualPrice', RealmPropertyType.double, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class SKU extends _SKU with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   SKU(
//     ObjectId realmId, {
//     int? id,
//     int? sku = 1000,
//     int? branchId,
//     int? businessId,
//     bool? consumed = false,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<SKU>({
//         'sku': 1000,
//         'consumed': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'sku', sku);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'consumed', consumed);
//   }

//   SKU._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get sku => RealmObjectBase.get<int>(this, 'sku') as int?;
//   @override
//   set sku(int? value) => RealmObjectBase.set(this, 'sku', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   bool? get consumed => RealmObjectBase.get<bool>(this, 'consumed') as bool?;
//   @override
//   set consumed(bool? value) => RealmObjectBase.set(this, 'consumed', value);

//   @override
//   Stream<RealmObjectChanges<SKU>> get changes =>
//       RealmObjectBase.getChanges<SKU>(this);

//   @override
//   Stream<RealmObjectChanges<SKU>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<SKU>(this, keyPaths);

//   @override
//   SKU freeze() => RealmObjectBase.freezeObject<SKU>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'sku': sku,
//       'branchId': branchId,
//       'businessId': businessId,
//       'consumed': consumed,
//     };
//   }

//   static EJsonValue _toEJson(SKU value) => value;
//   static SKU _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         SKU(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           sku: fromEJson(ejson['sku'], defaultValue: 1000),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           consumed: fromEJson(ejson['consumed'], defaultValue: false),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(SKU._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, SKU, 'SKU', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('sku', RealmPropertyType.int, optional: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('consumed', RealmPropertyType.bool, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Report extends _Report with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   Report(
//     ObjectId realmId, {
//     int? id,
//     int? branchId,
//     int? businessId,
//     String? filename,
//     String? s3Url,
//     bool? downloaded = false,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<Report>({
//         'downloaded': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'filename', filename);
//     RealmObjectBase.set(this, 's3Url', s3Url);
//     RealmObjectBase.set(this, 'downloaded', downloaded);
//   }

//   Report._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get filename =>
//       RealmObjectBase.get<String>(this, 'filename') as String?;
//   @override
//   set filename(String? value) => RealmObjectBase.set(this, 'filename', value);

//   @override
//   String? get s3Url => RealmObjectBase.get<String>(this, 's3Url') as String?;
//   @override
//   set s3Url(String? value) => RealmObjectBase.set(this, 's3Url', value);

//   @override
//   bool? get downloaded =>
//       RealmObjectBase.get<bool>(this, 'downloaded') as bool?;
//   @override
//   set downloaded(bool? value) => RealmObjectBase.set(this, 'downloaded', value);

//   @override
//   Stream<RealmObjectChanges<Report>> get changes =>
//       RealmObjectBase.getChanges<Report>(this);

//   @override
//   Stream<RealmObjectChanges<Report>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Report>(this, keyPaths);

//   @override
//   Report freeze() => RealmObjectBase.freezeObject<Report>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'branchId': branchId,
//       'businessId': businessId,
//       'filename': filename,
//       's3Url': s3Url,
//       'downloaded': downloaded,
//     };
//   }

//   static EJsonValue _toEJson(Report value) => value;
//   static Report _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Report(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           filename: fromEJson(ejson['filename']),
//           s3Url: fromEJson(ejson['s3Url']),
//           downloaded: fromEJson(ejson['downloaded'], defaultValue: false),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Report._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Report, 'Report', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('filename', RealmPropertyType.string, optional: true),
//       SchemaProperty('s3Url', RealmPropertyType.string, optional: true),
//       SchemaProperty('downloaded', RealmPropertyType.bool, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class Access extends _Access with RealmEntity, RealmObjectBase, RealmObject {
//   Access(
//     ObjectId realmId, {
//     int? id,
//     int? branchId,
//     int? businessId,
//     int? userId,
//     String? featureName,
//     String? userType,
//     String? accessLevel,
//     DateTime? createdAt,
//     DateTime? expiresAt,
//     String? status,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'userId', userId);
//     RealmObjectBase.set(this, 'featureName', featureName);
//     RealmObjectBase.set(this, 'userType', userType);
//     RealmObjectBase.set(this, 'accessLevel', accessLevel);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'expiresAt', expiresAt);
//     RealmObjectBase.set(this, 'status', status);
//   }

//   Access._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
//   @override
//   set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

//   @override
//   String? get featureName =>
//       RealmObjectBase.get<String>(this, 'featureName') as String?;
//   @override
//   set featureName(String? value) =>
//       RealmObjectBase.set(this, 'featureName', value);

//   @override
//   String? get userType =>
//       RealmObjectBase.get<String>(this, 'userType') as String?;
//   @override
//   set userType(String? value) => RealmObjectBase.set(this, 'userType', value);

//   @override
//   String? get accessLevel =>
//       RealmObjectBase.get<String>(this, 'accessLevel') as String?;
//   @override
//   set accessLevel(String? value) =>
//       RealmObjectBase.set(this, 'accessLevel', value);

//   @override
//   DateTime? get createdAt =>
//       RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
//   @override
//   set createdAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   DateTime? get expiresAt =>
//       RealmObjectBase.get<DateTime>(this, 'expiresAt') as DateTime?;
//   @override
//   set expiresAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'expiresAt', value);

//   @override
//   String? get status => RealmObjectBase.get<String>(this, 'status') as String?;
//   @override
//   set status(String? value) => RealmObjectBase.set(this, 'status', value);

//   @override
//   Stream<RealmObjectChanges<Access>> get changes =>
//       RealmObjectBase.getChanges<Access>(this);

//   @override
//   Stream<RealmObjectChanges<Access>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<Access>(this, keyPaths);

//   @override
//   Access freeze() => RealmObjectBase.freezeObject<Access>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'branchId': branchId,
//       'businessId': businessId,
//       'userId': userId,
//       'featureName': featureName,
//       'userType': userType,
//       'accessLevel': accessLevel,
//       'createdAt': createdAt,
//       'expiresAt': expiresAt,
//       'status': status,
//     };
//   }

//   static EJsonValue _toEJson(Access value) => value;
//   static Access _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         Access(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           userId: fromEJson(ejson['userId']),
//           featureName: fromEJson(ejson['featureName']),
//           userType: fromEJson(ejson['userType']),
//           accessLevel: fromEJson(ejson['accessLevel']),
//           createdAt: fromEJson(ejson['createdAt']),
//           expiresAt: fromEJson(ejson['expiresAt']),
//           status: fromEJson(ejson['status']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(Access._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, Access, 'Access', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('userId', RealmPropertyType.int, optional: true),
//       SchemaProperty('featureName', RealmPropertyType.string, optional: true),
//       SchemaProperty('userType', RealmPropertyType.string, optional: true),
//       SchemaProperty('accessLevel', RealmPropertyType.string, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('expiresAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('status', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class PaymentPlan extends _PaymentPlan
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   PaymentPlan(
//     ObjectId realmId, {
//     int? id,
//     int? businessId,
//     String? selectedPlan,
//     int? additionalDevices,
//     bool? isYearlyPlan,
//     double? totalPrice,
//     DateTime? createdAt,
//     bool? paymentCompletedByUser = false,
//     int? payStackCustomerId,
//     String? rule,
//     String? paymentMethod,
//     String? customerCode,
//     String? payStackPlanId,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<PaymentPlan>({
//         'paymentCompletedByUser': false,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'selectedPlan', selectedPlan);
//     RealmObjectBase.set(this, 'additionalDevices', additionalDevices);
//     RealmObjectBase.set(this, 'isYearlyPlan', isYearlyPlan);
//     RealmObjectBase.set(this, 'totalPrice', totalPrice);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'paymentCompletedByUser', paymentCompletedByUser);
//     RealmObjectBase.set(this, 'payStackCustomerId', payStackCustomerId);
//     RealmObjectBase.set(this, 'rule', rule);
//     RealmObjectBase.set(this, 'paymentMethod', paymentMethod);
//     RealmObjectBase.set(this, 'customerCode', customerCode);
//     RealmObjectBase.set(this, 'payStackPlanId', payStackPlanId);
//   }

//   PaymentPlan._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get selectedPlan =>
//       RealmObjectBase.get<String>(this, 'selectedPlan') as String?;
//   @override
//   set selectedPlan(String? value) =>
//       RealmObjectBase.set(this, 'selectedPlan', value);

//   @override
//   int? get additionalDevices =>
//       RealmObjectBase.get<int>(this, 'additionalDevices') as int?;
//   @override
//   set additionalDevices(int? value) =>
//       RealmObjectBase.set(this, 'additionalDevices', value);

//   @override
//   bool? get isYearlyPlan =>
//       RealmObjectBase.get<bool>(this, 'isYearlyPlan') as bool?;
//   @override
//   set isYearlyPlan(bool? value) =>
//       RealmObjectBase.set(this, 'isYearlyPlan', value);

//   @override
//   double? get totalPrice =>
//       RealmObjectBase.get<double>(this, 'totalPrice') as double?;
//   @override
//   set totalPrice(double? value) =>
//       RealmObjectBase.set(this, 'totalPrice', value);

//   @override
//   DateTime? get createdAt =>
//       RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
//   @override
//   set createdAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   bool? get paymentCompletedByUser =>
//       RealmObjectBase.get<bool>(this, 'paymentCompletedByUser') as bool?;
//   @override
//   set paymentCompletedByUser(bool? value) =>
//       RealmObjectBase.set(this, 'paymentCompletedByUser', value);

//   @override
//   int? get payStackCustomerId =>
//       RealmObjectBase.get<int>(this, 'payStackCustomerId') as int?;
//   @override
//   set payStackCustomerId(int? value) =>
//       RealmObjectBase.set(this, 'payStackCustomerId', value);

//   @override
//   String? get rule => RealmObjectBase.get<String>(this, 'rule') as String?;
//   @override
//   set rule(String? value) => RealmObjectBase.set(this, 'rule', value);

//   @override
//   String? get paymentMethod =>
//       RealmObjectBase.get<String>(this, 'paymentMethod') as String?;
//   @override
//   set paymentMethod(String? value) =>
//       RealmObjectBase.set(this, 'paymentMethod', value);

//   @override
//   String? get customerCode =>
//       RealmObjectBase.get<String>(this, 'customerCode') as String?;
//   @override
//   set customerCode(String? value) =>
//       RealmObjectBase.set(this, 'customerCode', value);

//   @override
//   String? get payStackPlanId =>
//       RealmObjectBase.get<String>(this, 'payStackPlanId') as String?;
//   @override
//   set payStackPlanId(String? value) =>
//       RealmObjectBase.set(this, 'payStackPlanId', value);

//   @override
//   Stream<RealmObjectChanges<PaymentPlan>> get changes =>
//       RealmObjectBase.getChanges<PaymentPlan>(this);

//   @override
//   Stream<RealmObjectChanges<PaymentPlan>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<PaymentPlan>(this, keyPaths);

//   @override
//   PaymentPlan freeze() => RealmObjectBase.freezeObject<PaymentPlan>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'businessId': businessId,
//       'selectedPlan': selectedPlan,
//       'additionalDevices': additionalDevices,
//       'isYearlyPlan': isYearlyPlan,
//       'totalPrice': totalPrice,
//       'createdAt': createdAt,
//       'paymentCompletedByUser': paymentCompletedByUser,
//       'payStackCustomerId': payStackCustomerId,
//       'rule': rule,
//       'paymentMethod': paymentMethod,
//       'customerCode': customerCode,
//       'payStackPlanId': payStackPlanId,
//     };
//   }

//   static EJsonValue _toEJson(PaymentPlan value) => value;
//   static PaymentPlan _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         PaymentPlan(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           businessId: fromEJson(ejson['businessId']),
//           selectedPlan: fromEJson(ejson['selectedPlan']),
//           additionalDevices: fromEJson(ejson['additionalDevices']),
//           isYearlyPlan: fromEJson(ejson['isYearlyPlan']),
//           totalPrice: fromEJson(ejson['totalPrice']),
//           createdAt: fromEJson(ejson['createdAt']),
//           paymentCompletedByUser:
//               fromEJson(ejson['paymentCompletedByUser'], defaultValue: false),
//           payStackCustomerId: fromEJson(ejson['payStackCustomerId']),
//           rule: fromEJson(ejson['rule']),
//           paymentMethod: fromEJson(ejson['paymentMethod']),
//           customerCode: fromEJson(ejson['customerCode']),
//           payStackPlanId: fromEJson(ejson['payStackPlanId']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(PaymentPlan._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, PaymentPlan, 'PaymentPlan', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('selectedPlan', RealmPropertyType.string, optional: true),
//       SchemaProperty('additionalDevices', RealmPropertyType.int,
//           optional: true),
//       SchemaProperty('isYearlyPlan', RealmPropertyType.bool, optional: true),
//       SchemaProperty('totalPrice', RealmPropertyType.double, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('paymentCompletedByUser', RealmPropertyType.bool,
//           optional: true),
//       SchemaProperty('payStackCustomerId', RealmPropertyType.int,
//           optional: true),
//       SchemaProperty('rule', RealmPropertyType.string, optional: true),
//       SchemaProperty('paymentMethod', RealmPropertyType.string, optional: true),
//       SchemaProperty('customerCode', RealmPropertyType.string, optional: true),
//       SchemaProperty('payStackPlanId', RealmPropertyType.string,
//           optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class FlipperSaleCompaign extends _FlipperSaleCompaign
//     with RealmEntity, RealmObjectBase, RealmObject {
//   FlipperSaleCompaign(
//     ObjectId realmId, {
//     int? id,
//     int? compaignId,
//     int? discountRate,
//     DateTime? createdAt,
//     String? couponCode,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'compaignId', compaignId);
//     RealmObjectBase.set(this, 'discountRate', discountRate);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//     RealmObjectBase.set(this, 'couponCode', couponCode);
//   }

//   FlipperSaleCompaign._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get compaignId => RealmObjectBase.get<int>(this, 'compaignId') as int?;
//   @override
//   set compaignId(int? value) => RealmObjectBase.set(this, 'compaignId', value);

//   @override
//   int? get discountRate =>
//       RealmObjectBase.get<int>(this, 'discountRate') as int?;
//   @override
//   set discountRate(int? value) =>
//       RealmObjectBase.set(this, 'discountRate', value);

//   @override
//   DateTime? get createdAt =>
//       RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
//   @override
//   set createdAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   String? get couponCode =>
//       RealmObjectBase.get<String>(this, 'couponCode') as String?;
//   @override
//   set couponCode(String? value) =>
//       RealmObjectBase.set(this, 'couponCode', value);

//   @override
//   Stream<RealmObjectChanges<FlipperSaleCompaign>> get changes =>
//       RealmObjectBase.getChanges<FlipperSaleCompaign>(this);

//   @override
//   Stream<RealmObjectChanges<FlipperSaleCompaign>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<FlipperSaleCompaign>(this, keyPaths);

//   @override
//   FlipperSaleCompaign freeze() =>
//       RealmObjectBase.freezeObject<FlipperSaleCompaign>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'compaignId': compaignId,
//       'discountRate': discountRate,
//       'createdAt': createdAt,
//       'couponCode': couponCode,
//     };
//   }

//   static EJsonValue _toEJson(FlipperSaleCompaign value) => value;
//   static FlipperSaleCompaign _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         FlipperSaleCompaign(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           compaignId: fromEJson(ejson['compaignId']),
//           discountRate: fromEJson(ejson['discountRate']),
//           createdAt: fromEJson(ejson['createdAt']),
//           couponCode: fromEJson(ejson['couponCode']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(FlipperSaleCompaign._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, FlipperSaleCompaign, 'FlipperSaleCompaign', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('compaignId', RealmPropertyType.int, optional: true),
//       SchemaProperty('discountRate', RealmPropertyType.int, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
//       SchemaProperty('couponCode', RealmPropertyType.string, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class TransactionPaymentRecord extends _TransactionPaymentRecord
//     with RealmEntity, RealmObjectBase, RealmObject {
//   static var _defaultsSet = false;

//   TransactionPaymentRecord(
//     ObjectId realmId, {
//     int? id,
//     int? transactionId,
//     double? amount = 0.0,
//     String? paymentMethod,
//     DateTime? createdAt,
//   }) {
//     if (!_defaultsSet) {
//       _defaultsSet = RealmObjectBase.setDefaults<TransactionPaymentRecord>({
//         'amount': 0.0,
//       });
//     }
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'transactionId', transactionId);
//     RealmObjectBase.set(this, 'amount', amount);
//     RealmObjectBase.set(this, 'paymentMethod', paymentMethod);
//     RealmObjectBase.set(this, 'createdAt', createdAt);
//   }

//   TransactionPaymentRecord._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get transactionId =>
//       RealmObjectBase.get<int>(this, 'transactionId') as int?;
//   @override
//   set transactionId(int? value) =>
//       RealmObjectBase.set(this, 'transactionId', value);

//   @override
//   double? get amount => RealmObjectBase.get<double>(this, 'amount') as double?;
//   @override
//   set amount(double? value) => RealmObjectBase.set(this, 'amount', value);

//   @override
//   String? get paymentMethod =>
//       RealmObjectBase.get<String>(this, 'paymentMethod') as String?;
//   @override
//   set paymentMethod(String? value) =>
//       RealmObjectBase.set(this, 'paymentMethod', value);

//   @override
//   DateTime? get createdAt =>
//       RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime?;
//   @override
//   set createdAt(DateTime? value) =>
//       RealmObjectBase.set(this, 'createdAt', value);

//   @override
//   Stream<RealmObjectChanges<TransactionPaymentRecord>> get changes =>
//       RealmObjectBase.getChanges<TransactionPaymentRecord>(this);

//   @override
//   Stream<RealmObjectChanges<TransactionPaymentRecord>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<TransactionPaymentRecord>(this, keyPaths);

//   @override
//   TransactionPaymentRecord freeze() =>
//       RealmObjectBase.freezeObject<TransactionPaymentRecord>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'transactionId': transactionId,
//       'amount': amount,
//       'paymentMethod': paymentMethod,
//       'createdAt': createdAt,
//     };
//   }

//   static EJsonValue _toEJson(TransactionPaymentRecord value) => value;
//   static TransactionPaymentRecord _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         TransactionPaymentRecord(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           transactionId: fromEJson(ejson['transactionId']),
//           amount: fromEJson(ejson['amount'], defaultValue: 0.0),
//           paymentMethod: fromEJson(ejson['paymentMethod']),
//           createdAt: fromEJson(ejson['createdAt']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(TransactionPaymentRecord._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(ObjectType.realmObject, TransactionPaymentRecord,
//         'TransactionPaymentRecord', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('transactionId', RealmPropertyType.int, optional: true),
//       SchemaProperty('amount', RealmPropertyType.double, optional: true),
//       SchemaProperty('paymentMethod', RealmPropertyType.string, optional: true),
//       SchemaProperty('createdAt', RealmPropertyType.timestamp, optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class DeletedObject extends _DeletedObject
//     with RealmEntity, RealmObjectBase, RealmObject {
//   DeletedObject(
//     ObjectId realmId, {
//     int? id,
//     int? branchId,
//     int? businessId,
//     String? objectName,
//     String? objectId,
//     int? deviceCount,
//     int? expectedDeviceCount,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'branchId', branchId);
//     RealmObjectBase.set(this, 'businessId', businessId);
//     RealmObjectBase.set(this, 'objectName', objectName);
//     RealmObjectBase.set(this, 'objectId', objectId);
//     RealmObjectBase.set(this, 'deviceCount', deviceCount);
//     RealmObjectBase.set(this, 'expectedDeviceCount', expectedDeviceCount);
//   }

//   DeletedObject._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
//   @override
//   set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

//   @override
//   int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
//   @override
//   set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

//   @override
//   String? get objectName =>
//       RealmObjectBase.get<String>(this, 'objectName') as String?;
//   @override
//   set objectName(String? value) =>
//       RealmObjectBase.set(this, 'objectName', value);

//   @override
//   String? get objectId =>
//       RealmObjectBase.get<String>(this, 'objectId') as String?;
//   @override
//   set objectId(String? value) => RealmObjectBase.set(this, 'objectId', value);

//   @override
//   int? get deviceCount => RealmObjectBase.get<int>(this, 'deviceCount') as int?;
//   @override
//   set deviceCount(int? value) =>
//       RealmObjectBase.set(this, 'deviceCount', value);

//   @override
//   int? get expectedDeviceCount =>
//       RealmObjectBase.get<int>(this, 'expectedDeviceCount') as int?;
//   @override
//   set expectedDeviceCount(int? value) =>
//       RealmObjectBase.set(this, 'expectedDeviceCount', value);

//   @override
//   Stream<RealmObjectChanges<DeletedObject>> get changes =>
//       RealmObjectBase.getChanges<DeletedObject>(this);

//   @override
//   Stream<RealmObjectChanges<DeletedObject>> changesFor(
//           [List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<DeletedObject>(this, keyPaths);

//   @override
//   DeletedObject freeze() => RealmObjectBase.freezeObject<DeletedObject>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'branchId': branchId,
//       'businessId': businessId,
//       'objectName': objectName,
//       'objectId': objectId,
//       'deviceCount': deviceCount,
//       'expectedDeviceCount': expectedDeviceCount,
//     };
//   }

//   static EJsonValue _toEJson(DeletedObject value) => value;
//   static DeletedObject _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         DeletedObject(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           branchId: fromEJson(ejson['branchId']),
//           businessId: fromEJson(ejson['businessId']),
//           objectName: fromEJson(ejson['objectName']),
//           objectId: fromEJson(ejson['objectId']),
//           deviceCount: fromEJson(ejson['deviceCount']),
//           expectedDeviceCount: fromEJson(ejson['expectedDeviceCount']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(DeletedObject._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, DeletedObject, 'DeletedObject', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('branchId', RealmPropertyType.int, optional: true),
//       SchemaProperty('businessId', RealmPropertyType.int, optional: true),
//       SchemaProperty('objectName', RealmPropertyType.string, optional: true),
//       SchemaProperty('objectId', RealmPropertyType.string, optional: true),
//       SchemaProperty('deviceCount', RealmPropertyType.int, optional: true),
//       SchemaProperty('expectedDeviceCount', RealmPropertyType.int,
//           optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }

// class DataMapper extends _DataMapper
//     with RealmEntity, RealmObjectBase, RealmObject {
//   DataMapper(
//     ObjectId realmId, {
//     int? id,
//     String? tableName,
//     String? objectId,
//     String? deviceIdentifier,
//     int? syncDevices,
//     int? deviceDownloadedObject,
//   }) {
//     RealmObjectBase.set(this, 'id', id);
//     RealmObjectBase.set(this, '_id', realmId);
//     RealmObjectBase.set(this, 'tableName', tableName);
//     RealmObjectBase.set(this, 'objectId', objectId);
//     RealmObjectBase.set(this, 'deviceIdentifier', deviceIdentifier);
//     RealmObjectBase.set(this, 'syncDevices', syncDevices);
//     RealmObjectBase.set(this, 'deviceDownloadedObject', deviceDownloadedObject);
//   }

//   DataMapper._();

//   @override
//   int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
//   @override
//   set id(int? value) => RealmObjectBase.set(this, 'id', value);

//   @override
//   ObjectId get realmId =>
//       RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
//   @override
//   set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

//   @override
//   String? get tableName =>
//       RealmObjectBase.get<String>(this, 'tableName') as String?;
//   @override
//   set tableName(String? value) => RealmObjectBase.set(this, 'tableName', value);

//   @override
//   String? get objectId =>
//       RealmObjectBase.get<String>(this, 'objectId') as String?;
//   @override
//   set objectId(String? value) => RealmObjectBase.set(this, 'objectId', value);

//   @override
//   String? get deviceIdentifier =>
//       RealmObjectBase.get<String>(this, 'deviceIdentifier') as String?;
//   @override
//   set deviceIdentifier(String? value) =>
//       RealmObjectBase.set(this, 'deviceIdentifier', value);

//   @override
//   int? get syncDevices => RealmObjectBase.get<int>(this, 'syncDevices') as int?;
//   @override
//   set syncDevices(int? value) =>
//       RealmObjectBase.set(this, 'syncDevices', value);

//   @override
//   int? get deviceDownloadedObject =>
//       RealmObjectBase.get<int>(this, 'deviceDownloadedObject') as int?;
//   @override
//   set deviceDownloadedObject(int? value) =>
//       RealmObjectBase.set(this, 'deviceDownloadedObject', value);

//   @override
//   Stream<RealmObjectChanges<DataMapper>> get changes =>
//       RealmObjectBase.getChanges<DataMapper>(this);

//   @override
//   Stream<RealmObjectChanges<DataMapper>> changesFor([List<String>? keyPaths]) =>
//       RealmObjectBase.getChangesFor<DataMapper>(this, keyPaths);

//   @override
//   DataMapper freeze() => RealmObjectBase.freezeObject<DataMapper>(this);

//   EJsonValue toEJson() {
//     return <String, dynamic>{
//       'id': id,
//       '_id': realmId,
//       'tableName': tableName,
//       'objectId': objectId,
//       'deviceIdentifier': deviceIdentifier,
//       'syncDevices': syncDevices,
//       'deviceDownloadedObject': deviceDownloadedObject,
//     };
//   }

//   static EJsonValue _toEJson(DataMapper value) => value;
//   static DataMapper _fromEJson(EJsonValue ejson) {
//     if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
//     return switch (ejson) {
//       {
//         '_id': EJsonValue realmId,
//       } =>
//         DataMapper(
//           fromEJson(realmId),
//           id: fromEJson(ejson['id']),
//           tableName: fromEJson(ejson['tableName']),
//           objectId: fromEJson(ejson['objectId']),
//           deviceIdentifier: fromEJson(ejson['deviceIdentifier']),
//           syncDevices: fromEJson(ejson['syncDevices']),
//           deviceDownloadedObject: fromEJson(ejson['deviceDownloadedObject']),
//         ),
//       _ => raiseInvalidEJson(ejson),
//     };
//   }

//   static final schema = () {
//     RealmObjectBase.registerFactory(DataMapper._);
//     register(_toEJson, _fromEJson);
//     return const SchemaObject(
//         ObjectType.realmObject, DataMapper, 'DataMapper', [
//       SchemaProperty('id', RealmPropertyType.int, optional: true),
//       SchemaProperty('realmId', RealmPropertyType.objectid,
//           mapTo: '_id', primaryKey: true),
//       SchemaProperty('tableName', RealmPropertyType.string, optional: true),
//       SchemaProperty('objectId', RealmPropertyType.string, optional: true),
//       SchemaProperty('deviceIdentifier', RealmPropertyType.string,
//           optional: true),
//       SchemaProperty('syncDevices', RealmPropertyType.int, optional: true),
//       SchemaProperty('deviceDownloadedObject', RealmPropertyType.int,
//           optional: true),
//     ]);
//   }();

//   @override
//   SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
// }
