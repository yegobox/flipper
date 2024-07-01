// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Branch extends _Branch with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Branch(
    ObjectId id, {
    int? serverId,
    bool? active,
    String? description,
    String? name,
    int? businessId,
    String? longitude,
    String? latitude,
    bool isDefault = false,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Branch>({
        'isDefault': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'serverId', serverId);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'isDefault', isDefault);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  Branch._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get serverId => RealmObjectBase.get<int>(this, 'serverId') as int?;
  @override
  set serverId(int? value) => RealmObjectBase.set(this, 'serverId', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  String? get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String?;
  @override
  set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  String? get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String?;
  @override
  set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  bool get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool;
  @override
  set isDefault(bool value) => RealmObjectBase.set(this, 'isDefault', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<Branch>> get changes =>
      RealmObjectBase.getChanges<Branch>(this);

  @override
  Stream<RealmObjectChanges<Branch>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Branch>(this, keyPaths);

  @override
  Branch freeze() => RealmObjectBase.freezeObject<Branch>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'serverId': serverId.toEJson(),
      'active': active.toEJson(),
      'description': description.toEJson(),
      'name': name.toEJson(),
      'businessId': businessId.toEJson(),
      'longitude': longitude.toEJson(),
      'latitude': latitude.toEJson(),
      'isDefault': isDefault.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Branch value) => value.toEJson();
  static Branch _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'serverId': EJsonValue serverId,
        'active': EJsonValue active,
        'description': EJsonValue description,
        'name': EJsonValue name,
        'businessId': EJsonValue businessId,
        'longitude': EJsonValue longitude,
        'latitude': EJsonValue latitude,
        'isDefault': EJsonValue isDefault,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
      } =>
        Branch(
          fromEJson(id),
          serverId: fromEJson(serverId),
          active: fromEJson(active),
          description: fromEJson(description),
          name: fromEJson(name),
          businessId: fromEJson(businessId),
          longitude: fromEJson(longitude),
          latitude: fromEJson(latitude),
          isDefault: fromEJson(isDefault),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Branch._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Branch, 'Branch', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('serverId', RealmPropertyType.int, optional: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('longitude', RealmPropertyType.string, optional: true),
      SchemaProperty('latitude', RealmPropertyType.string, optional: true),
      SchemaProperty('isDefault', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Business extends _Business
    with RealmEntity, RealmObjectBase, RealmObject {
  Business(
    ObjectId id, {
    int? serverId,
    String? name,
    String? currency,
    String? categoryId,
    String? latitude,
    String? longitude,
    int? userId,
    String? timeZone,
    String? country,
    String? businessUrl,
    String? hexColor,
    String? imageUrl,
    String? type,
    bool? active,
    String? chatUid,
    String? metadata,
    String? role,
    int? lastSeen,
    String? firstName,
    String? lastName,
    String? createdAt,
    String? deviceToken,
    bool? backUpEnabled,
    String? subscriptionPlan,
    String? nextBillingDate,
    String? previousBillingDate,
    bool? isLastSubscriptionPaymentSucceeded,
    String? backupFileId,
    String? email,
    String? lastDbBackup,
    String? fullName,
    int? tinNumber,
    String? bhfId,
    String? dvcSrlNo,
    String? adrs,
    bool? taxEnabled,
    String? taxServerUrl,
    bool? isDefault,
    int? businessTypeId,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
    String? encryptionKey,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'serverId', serverId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'currency', currency);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'timeZone', timeZone);
    RealmObjectBase.set(this, 'country', country);
    RealmObjectBase.set(this, 'businessUrl', businessUrl);
    RealmObjectBase.set(this, 'hexColor', hexColor);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'chatUid', chatUid);
    RealmObjectBase.set(this, 'metadata', metadata);
    RealmObjectBase.set(this, 'role', role);
    RealmObjectBase.set(this, 'lastSeen', lastSeen);
    RealmObjectBase.set(this, 'firstName', firstName);
    RealmObjectBase.set(this, 'lastName', lastName);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'deviceToken', deviceToken);
    RealmObjectBase.set(this, 'backUpEnabled', backUpEnabled);
    RealmObjectBase.set(this, 'subscriptionPlan', subscriptionPlan);
    RealmObjectBase.set(this, 'nextBillingDate', nextBillingDate);
    RealmObjectBase.set(this, 'previousBillingDate', previousBillingDate);
    RealmObjectBase.set(this, 'isLastSubscriptionPaymentSucceeded',
        isLastSubscriptionPaymentSucceeded);
    RealmObjectBase.set(this, 'backupFileId', backupFileId);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'lastDbBackup', lastDbBackup);
    RealmObjectBase.set(this, 'fullName', fullName);
    RealmObjectBase.set(this, 'tinNumber', tinNumber);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'dvcSrlNo', dvcSrlNo);
    RealmObjectBase.set(this, 'adrs', adrs);
    RealmObjectBase.set(this, 'taxEnabled', taxEnabled);
    RealmObjectBase.set(this, 'taxServerUrl', taxServerUrl);
    RealmObjectBase.set(this, 'isDefault', isDefault);
    RealmObjectBase.set(this, 'businessTypeId', businessTypeId);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'encryptionKey', encryptionKey);
  }

  Business._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  int? get serverId => RealmObjectBase.get<int>(this, 'serverId') as int?;
  @override
  set serverId(int? value) => RealmObjectBase.set(this, 'serverId', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get currency =>
      RealmObjectBase.get<String>(this, 'currency') as String?;
  @override
  set currency(String? value) => RealmObjectBase.set(this, 'currency', value);

  @override
  String? get categoryId =>
      RealmObjectBase.get<String>(this, 'categoryId') as String?;
  @override
  set categoryId(String? value) =>
      RealmObjectBase.set(this, 'categoryId', value);

  @override
  String? get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String?;
  @override
  set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  String? get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String?;
  @override
  set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get timeZone =>
      RealmObjectBase.get<String>(this, 'timeZone') as String?;
  @override
  set timeZone(String? value) => RealmObjectBase.set(this, 'timeZone', value);

  @override
  String? get country =>
      RealmObjectBase.get<String>(this, 'country') as String?;
  @override
  set country(String? value) => RealmObjectBase.set(this, 'country', value);

  @override
  String? get businessUrl =>
      RealmObjectBase.get<String>(this, 'businessUrl') as String?;
  @override
  set businessUrl(String? value) =>
      RealmObjectBase.set(this, 'businessUrl', value);

  @override
  String? get hexColor =>
      RealmObjectBase.get<String>(this, 'hexColor') as String?;
  @override
  set hexColor(String? value) => RealmObjectBase.set(this, 'hexColor', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  String? get chatUid =>
      RealmObjectBase.get<String>(this, 'chatUid') as String?;
  @override
  set chatUid(String? value) => RealmObjectBase.set(this, 'chatUid', value);

  @override
  String? get metadata =>
      RealmObjectBase.get<String>(this, 'metadata') as String?;
  @override
  set metadata(String? value) => RealmObjectBase.set(this, 'metadata', value);

  @override
  String? get role => RealmObjectBase.get<String>(this, 'role') as String?;
  @override
  set role(String? value) => RealmObjectBase.set(this, 'role', value);

  @override
  int? get lastSeen => RealmObjectBase.get<int>(this, 'lastSeen') as int?;
  @override
  set lastSeen(int? value) => RealmObjectBase.set(this, 'lastSeen', value);

  @override
  String? get firstName =>
      RealmObjectBase.get<String>(this, 'firstName') as String?;
  @override
  set firstName(String? value) => RealmObjectBase.set(this, 'firstName', value);

  @override
  String? get lastName =>
      RealmObjectBase.get<String>(this, 'lastName') as String?;
  @override
  set lastName(String? value) => RealmObjectBase.set(this, 'lastName', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get deviceToken =>
      RealmObjectBase.get<String>(this, 'deviceToken') as String?;
  @override
  set deviceToken(String? value) =>
      RealmObjectBase.set(this, 'deviceToken', value);

  @override
  bool? get backUpEnabled =>
      RealmObjectBase.get<bool>(this, 'backUpEnabled') as bool?;
  @override
  set backUpEnabled(bool? value) =>
      RealmObjectBase.set(this, 'backUpEnabled', value);

  @override
  String? get subscriptionPlan =>
      RealmObjectBase.get<String>(this, 'subscriptionPlan') as String?;
  @override
  set subscriptionPlan(String? value) =>
      RealmObjectBase.set(this, 'subscriptionPlan', value);

  @override
  String? get nextBillingDate =>
      RealmObjectBase.get<String>(this, 'nextBillingDate') as String?;
  @override
  set nextBillingDate(String? value) =>
      RealmObjectBase.set(this, 'nextBillingDate', value);

  @override
  String? get previousBillingDate =>
      RealmObjectBase.get<String>(this, 'previousBillingDate') as String?;
  @override
  set previousBillingDate(String? value) =>
      RealmObjectBase.set(this, 'previousBillingDate', value);

  @override
  bool? get isLastSubscriptionPaymentSucceeded =>
      RealmObjectBase.get<bool>(this, 'isLastSubscriptionPaymentSucceeded')
          as bool?;
  @override
  set isLastSubscriptionPaymentSucceeded(bool? value) =>
      RealmObjectBase.set(this, 'isLastSubscriptionPaymentSucceeded', value);

  @override
  String? get backupFileId =>
      RealmObjectBase.get<String>(this, 'backupFileId') as String?;
  @override
  set backupFileId(String? value) =>
      RealmObjectBase.set(this, 'backupFileId', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get lastDbBackup =>
      RealmObjectBase.get<String>(this, 'lastDbBackup') as String?;
  @override
  set lastDbBackup(String? value) =>
      RealmObjectBase.set(this, 'lastDbBackup', value);

  @override
  String? get fullName =>
      RealmObjectBase.get<String>(this, 'fullName') as String?;
  @override
  set fullName(String? value) => RealmObjectBase.set(this, 'fullName', value);

  @override
  int? get tinNumber => RealmObjectBase.get<int>(this, 'tinNumber') as int?;
  @override
  set tinNumber(int? value) => RealmObjectBase.set(this, 'tinNumber', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  String? get dvcSrlNo =>
      RealmObjectBase.get<String>(this, 'dvcSrlNo') as String?;
  @override
  set dvcSrlNo(String? value) => RealmObjectBase.set(this, 'dvcSrlNo', value);

  @override
  String? get adrs => RealmObjectBase.get<String>(this, 'adrs') as String?;
  @override
  set adrs(String? value) => RealmObjectBase.set(this, 'adrs', value);

  @override
  bool? get taxEnabled =>
      RealmObjectBase.get<bool>(this, 'taxEnabled') as bool?;
  @override
  set taxEnabled(bool? value) => RealmObjectBase.set(this, 'taxEnabled', value);

  @override
  String? get taxServerUrl =>
      RealmObjectBase.get<String>(this, 'taxServerUrl') as String?;
  @override
  set taxServerUrl(String? value) =>
      RealmObjectBase.set(this, 'taxServerUrl', value);

  @override
  bool? get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool?;
  @override
  set isDefault(bool? value) => RealmObjectBase.set(this, 'isDefault', value);

  @override
  int? get businessTypeId =>
      RealmObjectBase.get<int>(this, 'businessTypeId') as int?;
  @override
  set businessTypeId(int? value) =>
      RealmObjectBase.set(this, 'businessTypeId', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get encryptionKey =>
      RealmObjectBase.get<String>(this, 'encryptionKey') as String?;
  @override
  set encryptionKey(String? value) =>
      RealmObjectBase.set(this, 'encryptionKey', value);

  @override
  Stream<RealmObjectChanges<Business>> get changes =>
      RealmObjectBase.getChanges<Business>(this);

  @override
  Stream<RealmObjectChanges<Business>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Business>(this, keyPaths);

  @override
  Business freeze() => RealmObjectBase.freezeObject<Business>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'serverId': serverId.toEJson(),
      'name': name.toEJson(),
      'currency': currency.toEJson(),
      'categoryId': categoryId.toEJson(),
      'latitude': latitude.toEJson(),
      'longitude': longitude.toEJson(),
      'userId': userId.toEJson(),
      'timeZone': timeZone.toEJson(),
      'country': country.toEJson(),
      'businessUrl': businessUrl.toEJson(),
      'hexColor': hexColor.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'type': type.toEJson(),
      'active': active.toEJson(),
      'chatUid': chatUid.toEJson(),
      'metadata': metadata.toEJson(),
      'role': role.toEJson(),
      'lastSeen': lastSeen.toEJson(),
      'firstName': firstName.toEJson(),
      'lastName': lastName.toEJson(),
      'createdAt': createdAt.toEJson(),
      'deviceToken': deviceToken.toEJson(),
      'backUpEnabled': backUpEnabled.toEJson(),
      'subscriptionPlan': subscriptionPlan.toEJson(),
      'nextBillingDate': nextBillingDate.toEJson(),
      'previousBillingDate': previousBillingDate.toEJson(),
      'isLastSubscriptionPaymentSucceeded':
          isLastSubscriptionPaymentSucceeded.toEJson(),
      'backupFileId': backupFileId.toEJson(),
      'email': email.toEJson(),
      'lastDbBackup': lastDbBackup.toEJson(),
      'fullName': fullName.toEJson(),
      'tinNumber': tinNumber.toEJson(),
      'bhfId': bhfId.toEJson(),
      'dvcSrlNo': dvcSrlNo.toEJson(),
      'adrs': adrs.toEJson(),
      'taxEnabled': taxEnabled.toEJson(),
      'taxServerUrl': taxServerUrl.toEJson(),
      'isDefault': isDefault.toEJson(),
      'businessTypeId': businessTypeId.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'encryptionKey': encryptionKey.toEJson(),
    };
  }

  static EJsonValue _toEJson(Business value) => value.toEJson();
  static Business _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'serverId': EJsonValue serverId,
        'name': EJsonValue name,
        'currency': EJsonValue currency,
        'categoryId': EJsonValue categoryId,
        'latitude': EJsonValue latitude,
        'longitude': EJsonValue longitude,
        'userId': EJsonValue userId,
        'timeZone': EJsonValue timeZone,
        'country': EJsonValue country,
        'businessUrl': EJsonValue businessUrl,
        'hexColor': EJsonValue hexColor,
        'imageUrl': EJsonValue imageUrl,
        'type': EJsonValue type,
        'active': EJsonValue active,
        'chatUid': EJsonValue chatUid,
        'metadata': EJsonValue metadata,
        'role': EJsonValue role,
        'lastSeen': EJsonValue lastSeen,
        'firstName': EJsonValue firstName,
        'lastName': EJsonValue lastName,
        'createdAt': EJsonValue createdAt,
        'deviceToken': EJsonValue deviceToken,
        'backUpEnabled': EJsonValue backUpEnabled,
        'subscriptionPlan': EJsonValue subscriptionPlan,
        'nextBillingDate': EJsonValue nextBillingDate,
        'previousBillingDate': EJsonValue previousBillingDate,
        'isLastSubscriptionPaymentSucceeded': EJsonValue
            isLastSubscriptionPaymentSucceeded,
        'backupFileId': EJsonValue backupFileId,
        'email': EJsonValue email,
        'lastDbBackup': EJsonValue lastDbBackup,
        'fullName': EJsonValue fullName,
        'tinNumber': EJsonValue tinNumber,
        'bhfId': EJsonValue bhfId,
        'dvcSrlNo': EJsonValue dvcSrlNo,
        'adrs': EJsonValue adrs,
        'taxEnabled': EJsonValue taxEnabled,
        'taxServerUrl': EJsonValue taxServerUrl,
        'isDefault': EJsonValue isDefault,
        'businessTypeId': EJsonValue businessTypeId,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
        'encryptionKey': EJsonValue encryptionKey,
      } =>
        Business(
          fromEJson(id),
          serverId: fromEJson(serverId),
          name: fromEJson(name),
          currency: fromEJson(currency),
          categoryId: fromEJson(categoryId),
          latitude: fromEJson(latitude),
          longitude: fromEJson(longitude),
          userId: fromEJson(userId),
          timeZone: fromEJson(timeZone),
          country: fromEJson(country),
          businessUrl: fromEJson(businessUrl),
          hexColor: fromEJson(hexColor),
          imageUrl: fromEJson(imageUrl),
          type: fromEJson(type),
          active: fromEJson(active),
          chatUid: fromEJson(chatUid),
          metadata: fromEJson(metadata),
          role: fromEJson(role),
          lastSeen: fromEJson(lastSeen),
          firstName: fromEJson(firstName),
          lastName: fromEJson(lastName),
          createdAt: fromEJson(createdAt),
          deviceToken: fromEJson(deviceToken),
          backUpEnabled: fromEJson(backUpEnabled),
          subscriptionPlan: fromEJson(subscriptionPlan),
          nextBillingDate: fromEJson(nextBillingDate),
          previousBillingDate: fromEJson(previousBillingDate),
          isLastSubscriptionPaymentSucceeded:
              fromEJson(isLastSubscriptionPaymentSucceeded),
          backupFileId: fromEJson(backupFileId),
          email: fromEJson(email),
          lastDbBackup: fromEJson(lastDbBackup),
          fullName: fromEJson(fullName),
          tinNumber: fromEJson(tinNumber),
          bhfId: fromEJson(bhfId),
          dvcSrlNo: fromEJson(dvcSrlNo),
          adrs: fromEJson(adrs),
          taxEnabled: fromEJson(taxEnabled),
          taxServerUrl: fromEJson(taxServerUrl),
          isDefault: fromEJson(isDefault),
          businessTypeId: fromEJson(businessTypeId),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
          encryptionKey: fromEJson(encryptionKey),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Business._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Business, 'Business', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('serverId', RealmPropertyType.int, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('currency', RealmPropertyType.string, optional: true),
      SchemaProperty('categoryId', RealmPropertyType.string, optional: true),
      SchemaProperty('latitude', RealmPropertyType.string, optional: true),
      SchemaProperty('longitude', RealmPropertyType.string, optional: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
      SchemaProperty('timeZone', RealmPropertyType.string, optional: true),
      SchemaProperty('country', RealmPropertyType.string, optional: true),
      SchemaProperty('businessUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('hexColor', RealmPropertyType.string, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('chatUid', RealmPropertyType.string, optional: true),
      SchemaProperty('metadata', RealmPropertyType.string, optional: true),
      SchemaProperty('role', RealmPropertyType.string, optional: true),
      SchemaProperty('lastSeen', RealmPropertyType.int, optional: true),
      SchemaProperty('firstName', RealmPropertyType.string, optional: true),
      SchemaProperty('lastName', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('deviceToken', RealmPropertyType.string, optional: true),
      SchemaProperty('backUpEnabled', RealmPropertyType.bool, optional: true),
      SchemaProperty('subscriptionPlan', RealmPropertyType.string,
          optional: true),
      SchemaProperty('nextBillingDate', RealmPropertyType.string,
          optional: true),
      SchemaProperty('previousBillingDate', RealmPropertyType.string,
          optional: true),
      SchemaProperty(
          'isLastSubscriptionPaymentSucceeded', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('backupFileId', RealmPropertyType.string, optional: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('lastDbBackup', RealmPropertyType.string, optional: true),
      SchemaProperty('fullName', RealmPropertyType.string, optional: true),
      SchemaProperty('tinNumber', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('dvcSrlNo', RealmPropertyType.string, optional: true),
      SchemaProperty('adrs', RealmPropertyType.string, optional: true),
      SchemaProperty('taxEnabled', RealmPropertyType.bool, optional: true),
      SchemaProperty('taxServerUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('isDefault', RealmPropertyType.bool, optional: true),
      SchemaProperty('businessTypeId', RealmPropertyType.int, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('encryptionKey', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Category extends _Category
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Category(
    ObjectId realmId, {
    int? id,
    bool? active,
    bool focused = false,
    String? name,
    int? branchId,
    DateTime? deletedAt,
    DateTime? lastTouched,
    String? action,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Category>({
        'focused': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'focused', focused);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
  }

  Category._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  bool get focused => RealmObjectBase.get<bool>(this, 'focused') as bool;
  @override
  set focused(bool value) => RealmObjectBase.set(this, 'focused', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<Category>> get changes =>
      RealmObjectBase.getChanges<Category>(this);

  @override
  Stream<RealmObjectChanges<Category>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Category>(this, keyPaths);

  @override
  Category freeze() => RealmObjectBase.freezeObject<Category>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'active': active.toEJson(),
      'focused': focused.toEJson(),
      'name': name.toEJson(),
      'branchId': branchId.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(Category value) => value.toEJson();
  static Category _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'active': EJsonValue active,
        'focused': EJsonValue focused,
        'name': EJsonValue name,
        'branchId': EJsonValue branchId,
        'deletedAt': EJsonValue deletedAt,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
      } =>
        Category(
          fromEJson(realmId),
          id: fromEJson(id),
          active: fromEJson(active),
          focused: fromEJson(focused),
          name: fromEJson(name),
          branchId: fromEJson(branchId),
          deletedAt: fromEJson(deletedAt),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Category._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Category, 'Category', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('focused', RealmPropertyType.bool),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class PColor extends _PColor with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  PColor(
    ObjectId realmId, {
    int? id,
    String? name,
    Iterable<String> colors = const [],
    int? branchId,
    bool active = false,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<PColor>({
        'active': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<String>>(
        this, 'colors', RealmList<String>(colors));
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  PColor._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<String> get colors =>
      RealmObjectBase.get<String>(this, 'colors') as RealmList<String>;
  @override
  set colors(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  bool get active => RealmObjectBase.get<bool>(this, 'active') as bool;
  @override
  set active(bool value) => RealmObjectBase.set(this, 'active', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<PColor>> get changes =>
      RealmObjectBase.getChanges<PColor>(this);

  @override
  Stream<RealmObjectChanges<PColor>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<PColor>(this, keyPaths);

  @override
  PColor freeze() => RealmObjectBase.freezeObject<PColor>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'colors': colors.toEJson(),
      'branchId': branchId.toEJson(),
      'active': active.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(PColor value) => value.toEJson();
  static PColor _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'colors': EJsonValue colors,
        'branchId': EJsonValue branchId,
        'active': EJsonValue active,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
      } =>
        PColor(
          fromEJson(realmId),
          id: fromEJson(id),
          name: fromEJson(name),
          colors: fromEJson(colors),
          branchId: fromEJson(branchId),
          active: fromEJson(active),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(PColor._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, PColor, 'PColor', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('colors', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('active', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Conversation extends _Conversation
    with RealmEntity, RealmObjectBase, RealmObject {
  Conversation(
    ObjectId realmId, {
    int? id,
    String? userName,
    String? body,
    String? avatar,
    String? channelType,
    String? fromNumber,
    String? toNumber,
    String? createdAt,
    String? messageType,
    String? phoneNumberId,
    String? messageId,
    String? respondedBy,
    String? conversationId,
    String? businessPhoneNumber,
    int? businessId,
    DateTime? scheduledAt,
    bool? delivered,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'userName', userName);
    RealmObjectBase.set(this, 'body', body);
    RealmObjectBase.set(this, 'avatar', avatar);
    RealmObjectBase.set(this, 'channelType', channelType);
    RealmObjectBase.set(this, 'fromNumber', fromNumber);
    RealmObjectBase.set(this, 'toNumber', toNumber);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'messageType', messageType);
    RealmObjectBase.set(this, 'phoneNumberId', phoneNumberId);
    RealmObjectBase.set(this, 'messageId', messageId);
    RealmObjectBase.set(this, 'respondedBy', respondedBy);
    RealmObjectBase.set(this, 'conversationId', conversationId);
    RealmObjectBase.set(this, 'businessPhoneNumber', businessPhoneNumber);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'scheduledAt', scheduledAt);
    RealmObjectBase.set(this, 'delivered', delivered);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  Conversation._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get userName =>
      RealmObjectBase.get<String>(this, 'userName') as String?;
  @override
  set userName(String? value) => RealmObjectBase.set(this, 'userName', value);

  @override
  String? get body => RealmObjectBase.get<String>(this, 'body') as String?;
  @override
  set body(String? value) => RealmObjectBase.set(this, 'body', value);

  @override
  String? get avatar => RealmObjectBase.get<String>(this, 'avatar') as String?;
  @override
  set avatar(String? value) => RealmObjectBase.set(this, 'avatar', value);

  @override
  String? get channelType =>
      RealmObjectBase.get<String>(this, 'channelType') as String?;
  @override
  set channelType(String? value) =>
      RealmObjectBase.set(this, 'channelType', value);

  @override
  String? get fromNumber =>
      RealmObjectBase.get<String>(this, 'fromNumber') as String?;
  @override
  set fromNumber(String? value) =>
      RealmObjectBase.set(this, 'fromNumber', value);

  @override
  String? get toNumber =>
      RealmObjectBase.get<String>(this, 'toNumber') as String?;
  @override
  set toNumber(String? value) => RealmObjectBase.set(this, 'toNumber', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get messageType =>
      RealmObjectBase.get<String>(this, 'messageType') as String?;
  @override
  set messageType(String? value) =>
      RealmObjectBase.set(this, 'messageType', value);

  @override
  String? get phoneNumberId =>
      RealmObjectBase.get<String>(this, 'phoneNumberId') as String?;
  @override
  set phoneNumberId(String? value) =>
      RealmObjectBase.set(this, 'phoneNumberId', value);

  @override
  String? get messageId =>
      RealmObjectBase.get<String>(this, 'messageId') as String?;
  @override
  set messageId(String? value) => RealmObjectBase.set(this, 'messageId', value);

  @override
  String? get respondedBy =>
      RealmObjectBase.get<String>(this, 'respondedBy') as String?;
  @override
  set respondedBy(String? value) =>
      RealmObjectBase.set(this, 'respondedBy', value);

  @override
  String? get conversationId =>
      RealmObjectBase.get<String>(this, 'conversationId') as String?;
  @override
  set conversationId(String? value) =>
      RealmObjectBase.set(this, 'conversationId', value);

  @override
  String? get businessPhoneNumber =>
      RealmObjectBase.get<String>(this, 'businessPhoneNumber') as String?;
  @override
  set businessPhoneNumber(String? value) =>
      RealmObjectBase.set(this, 'businessPhoneNumber', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  DateTime? get scheduledAt =>
      RealmObjectBase.get<DateTime>(this, 'scheduledAt') as DateTime?;
  @override
  set scheduledAt(DateTime? value) =>
      RealmObjectBase.set(this, 'scheduledAt', value);

  @override
  bool? get delivered => RealmObjectBase.get<bool>(this, 'delivered') as bool?;
  @override
  set delivered(bool? value) => RealmObjectBase.set(this, 'delivered', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<Conversation>> get changes =>
      RealmObjectBase.getChanges<Conversation>(this);

  @override
  Stream<RealmObjectChanges<Conversation>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Conversation>(this, keyPaths);

  @override
  Conversation freeze() => RealmObjectBase.freezeObject<Conversation>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'userName': userName.toEJson(),
      'body': body.toEJson(),
      'avatar': avatar.toEJson(),
      'channelType': channelType.toEJson(),
      'fromNumber': fromNumber.toEJson(),
      'toNumber': toNumber.toEJson(),
      'createdAt': createdAt.toEJson(),
      'messageType': messageType.toEJson(),
      'phoneNumberId': phoneNumberId.toEJson(),
      'messageId': messageId.toEJson(),
      'respondedBy': respondedBy.toEJson(),
      'conversationId': conversationId.toEJson(),
      'businessPhoneNumber': businessPhoneNumber.toEJson(),
      'businessId': businessId.toEJson(),
      'scheduledAt': scheduledAt.toEJson(),
      'delivered': delivered.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Conversation value) => value.toEJson();
  static Conversation _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'userName': EJsonValue userName,
        'body': EJsonValue body,
        'avatar': EJsonValue avatar,
        'channelType': EJsonValue channelType,
        'fromNumber': EJsonValue fromNumber,
        'toNumber': EJsonValue toNumber,
        'createdAt': EJsonValue createdAt,
        'messageType': EJsonValue messageType,
        'phoneNumberId': EJsonValue phoneNumberId,
        'messageId': EJsonValue messageId,
        'respondedBy': EJsonValue respondedBy,
        'conversationId': EJsonValue conversationId,
        'businessPhoneNumber': EJsonValue businessPhoneNumber,
        'businessId': EJsonValue businessId,
        'scheduledAt': EJsonValue scheduledAt,
        'delivered': EJsonValue delivered,
        'lastTouched': EJsonValue lastTouched,
        'deletedAt': EJsonValue deletedAt,
      } =>
        Conversation(
          fromEJson(realmId),
          id: fromEJson(id),
          userName: fromEJson(userName),
          body: fromEJson(body),
          avatar: fromEJson(avatar),
          channelType: fromEJson(channelType),
          fromNumber: fromEJson(fromNumber),
          toNumber: fromEJson(toNumber),
          createdAt: fromEJson(createdAt),
          messageType: fromEJson(messageType),
          phoneNumberId: fromEJson(phoneNumberId),
          messageId: fromEJson(messageId),
          respondedBy: fromEJson(respondedBy),
          conversationId: fromEJson(conversationId),
          businessPhoneNumber: fromEJson(businessPhoneNumber),
          businessId: fromEJson(businessId),
          scheduledAt: fromEJson(scheduledAt),
          delivered: fromEJson(delivered),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Conversation._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Conversation, 'Conversation', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('userName', RealmPropertyType.string, optional: true),
      SchemaProperty('body', RealmPropertyType.string, optional: true),
      SchemaProperty('avatar', RealmPropertyType.string, optional: true),
      SchemaProperty('channelType', RealmPropertyType.string, optional: true),
      SchemaProperty('fromNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('toNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('messageType', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumberId', RealmPropertyType.string, optional: true),
      SchemaProperty('messageId', RealmPropertyType.string, optional: true),
      SchemaProperty('respondedBy', RealmPropertyType.string, optional: true),
      SchemaProperty('conversationId', RealmPropertyType.string,
          optional: true),
      SchemaProperty('businessPhoneNumber', RealmPropertyType.string,
          optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('scheduledAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('delivered', RealmPropertyType.bool, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Counter extends _Counter with RealmEntity, RealmObjectBase, RealmObject {
  Counter(
    ObjectId realmId, {
    int? id,
    int? businessId,
    int? branchId,
    String? receiptType,
    int? totRcptNo,
    int? curRcptNo,
    int? invcNo,
    DateTime? lastTouched,
    String? action,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'receiptType', receiptType);
    RealmObjectBase.set(this, 'totRcptNo', totRcptNo);
    RealmObjectBase.set(this, 'curRcptNo', curRcptNo);
    RealmObjectBase.set(this, 'invcNo', invcNo);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
  }

  Counter._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get receiptType =>
      RealmObjectBase.get<String>(this, 'receiptType') as String?;
  @override
  set receiptType(String? value) =>
      RealmObjectBase.set(this, 'receiptType', value);

  @override
  int? get totRcptNo => RealmObjectBase.get<int>(this, 'totRcptNo') as int?;
  @override
  set totRcptNo(int? value) => RealmObjectBase.set(this, 'totRcptNo', value);

  @override
  int? get curRcptNo => RealmObjectBase.get<int>(this, 'curRcptNo') as int?;
  @override
  set curRcptNo(int? value) => RealmObjectBase.set(this, 'curRcptNo', value);

  @override
  int? get invcNo => RealmObjectBase.get<int>(this, 'invcNo') as int?;
  @override
  set invcNo(int? value) => RealmObjectBase.set(this, 'invcNo', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<Counter>> get changes =>
      RealmObjectBase.getChanges<Counter>(this);

  @override
  Stream<RealmObjectChanges<Counter>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Counter>(this, keyPaths);

  @override
  Counter freeze() => RealmObjectBase.freezeObject<Counter>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
      'receiptType': receiptType.toEJson(),
      'totRcptNo': totRcptNo.toEJson(),
      'curRcptNo': curRcptNo.toEJson(),
      'invcNo': invcNo.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(Counter value) => value.toEJson();
  static Counter _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
        'receiptType': EJsonValue receiptType,
        'totRcptNo': EJsonValue totRcptNo,
        'curRcptNo': EJsonValue curRcptNo,
        'invcNo': EJsonValue invcNo,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
      } =>
        Counter(
          fromEJson(realmId),
          id: fromEJson(id),
          businessId: fromEJson(businessId),
          branchId: fromEJson(branchId),
          receiptType: fromEJson(receiptType),
          totRcptNo: fromEJson(totRcptNo),
          curRcptNo: fromEJson(curRcptNo),
          invcNo: fromEJson(invcNo),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Counter._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Counter, 'Counter', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
      SchemaProperty('totRcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('curRcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('invcNo', RealmPropertyType.int, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Customer extends _Customer
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Customer(
    ObjectId realmId, {
    int? id,
    String? custNm,
    String? email,
    String? telNo,
    String? adrs,
    int? branchId,
    DateTime? updatedAt,
    String? custNo,
    String? custTin,
    String? regrNm,
    String? regrId,
    String modrNm = "284746303937",
    String? modrId,
    bool ebmSynced = false,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
    int? tin,
    String? bhfId,
    String? useYn,
    String? customerType,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Customer>({
        'modrNm': "284746303937",
        'ebmSynced': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'custNm', custNm);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'telNo', telNo);
    RealmObjectBase.set(this, 'adrs', adrs);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'custNo', custNo);
    RealmObjectBase.set(this, 'custTin', custTin);
    RealmObjectBase.set(this, 'regrNm', regrNm);
    RealmObjectBase.set(this, 'regrId', regrId);
    RealmObjectBase.set(this, 'modrNm', modrNm);
    RealmObjectBase.set(this, 'modrId', modrId);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'customerType', customerType);
  }

  Customer._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get custNm => RealmObjectBase.get<String>(this, 'custNm') as String?;
  @override
  set custNm(String? value) => RealmObjectBase.set(this, 'custNm', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get telNo => RealmObjectBase.get<String>(this, 'telNo') as String?;
  @override
  set telNo(String? value) => RealmObjectBase.set(this, 'telNo', value);

  @override
  String? get adrs => RealmObjectBase.get<String>(this, 'adrs') as String?;
  @override
  set adrs(String? value) => RealmObjectBase.set(this, 'adrs', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  DateTime? get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime?;
  @override
  set updatedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  String? get custNo => RealmObjectBase.get<String>(this, 'custNo') as String?;
  @override
  set custNo(String? value) => RealmObjectBase.set(this, 'custNo', value);

  @override
  String? get custTin =>
      RealmObjectBase.get<String>(this, 'custTin') as String?;
  @override
  set custTin(String? value) => RealmObjectBase.set(this, 'custTin', value);

  @override
  String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
  @override
  set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

  @override
  String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
  @override
  set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

  @override
  String get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String;
  @override
  set modrNm(String value) => RealmObjectBase.set(this, 'modrNm', value);

  @override
  String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
  @override
  set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

  @override
  bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
  @override
  set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  String? get customerType =>
      RealmObjectBase.get<String>(this, 'customerType') as String?;
  @override
  set customerType(String? value) =>
      RealmObjectBase.set(this, 'customerType', value);

  @override
  Stream<RealmObjectChanges<Customer>> get changes =>
      RealmObjectBase.getChanges<Customer>(this);

  @override
  Stream<RealmObjectChanges<Customer>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Customer>(this, keyPaths);

  @override
  Customer freeze() => RealmObjectBase.freezeObject<Customer>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'custNm': custNm.toEJson(),
      'email': email.toEJson(),
      'telNo': telNo.toEJson(),
      'adrs': adrs.toEJson(),
      'branchId': branchId.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'custNo': custNo.toEJson(),
      'custTin': custTin.toEJson(),
      'regrNm': regrNm.toEJson(),
      'regrId': regrId.toEJson(),
      'modrNm': modrNm.toEJson(),
      'modrId': modrId.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'tin': tin.toEJson(),
      'bhfId': bhfId.toEJson(),
      'useYn': useYn.toEJson(),
      'customerType': customerType.toEJson(),
    };
  }

  static EJsonValue _toEJson(Customer value) => value.toEJson();
  static Customer _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'custNm': EJsonValue custNm,
        'email': EJsonValue email,
        'telNo': EJsonValue telNo,
        'adrs': EJsonValue adrs,
        'branchId': EJsonValue branchId,
        'updatedAt': EJsonValue updatedAt,
        'custNo': EJsonValue custNo,
        'custTin': EJsonValue custTin,
        'regrNm': EJsonValue regrNm,
        'regrId': EJsonValue regrId,
        'modrNm': EJsonValue modrNm,
        'modrId': EJsonValue modrId,
        'ebmSynced': EJsonValue ebmSynced,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
        'tin': EJsonValue tin,
        'bhfId': EJsonValue bhfId,
        'useYn': EJsonValue useYn,
        'customerType': EJsonValue customerType,
      } =>
        Customer(
          fromEJson(realmId),
          id: fromEJson(id),
          custNm: fromEJson(custNm),
          email: fromEJson(email),
          telNo: fromEJson(telNo),
          adrs: fromEJson(adrs),
          branchId: fromEJson(branchId),
          updatedAt: fromEJson(updatedAt),
          custNo: fromEJson(custNo),
          custTin: fromEJson(custTin),
          regrNm: fromEJson(regrNm),
          regrId: fromEJson(regrId),
          modrNm: fromEJson(modrNm),
          modrId: fromEJson(modrId),
          ebmSynced: fromEJson(ebmSynced),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
          tin: fromEJson(tin),
          bhfId: fromEJson(bhfId),
          useYn: fromEJson(useYn),
          customerType: fromEJson(customerType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Customer._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Customer, 'Customer', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('custNm', RealmPropertyType.string, optional: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('telNo', RealmPropertyType.string, optional: true),
      SchemaProperty('adrs', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('custNo', RealmPropertyType.string, optional: true),
      SchemaProperty('custTin', RealmPropertyType.string, optional: true),
      SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('regrId', RealmPropertyType.string, optional: true),
      SchemaProperty('modrNm', RealmPropertyType.string),
      SchemaProperty('modrId', RealmPropertyType.string, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('customerType', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Device extends _Device with RealmEntity, RealmObjectBase, RealmObject {
  Device(
    ObjectId realmId, {
    int? id,
    String? linkingCode,
    String? deviceName,
    String? deviceVersion,
    bool? pubNubPublished,
    String? phone,
    int? branchId,
    int? businessId,
    int? userId,
    String? defaultApp,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'linkingCode', linkingCode);
    RealmObjectBase.set(this, 'deviceName', deviceName);
    RealmObjectBase.set(this, 'deviceVersion', deviceVersion);
    RealmObjectBase.set(this, 'pubNubPublished', pubNubPublished);
    RealmObjectBase.set(this, 'phone', phone);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'defaultApp', defaultApp);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'action', action);
  }

  Device._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get linkingCode =>
      RealmObjectBase.get<String>(this, 'linkingCode') as String?;
  @override
  set linkingCode(String? value) =>
      RealmObjectBase.set(this, 'linkingCode', value);

  @override
  String? get deviceName =>
      RealmObjectBase.get<String>(this, 'deviceName') as String?;
  @override
  set deviceName(String? value) =>
      RealmObjectBase.set(this, 'deviceName', value);

  @override
  String? get deviceVersion =>
      RealmObjectBase.get<String>(this, 'deviceVersion') as String?;
  @override
  set deviceVersion(String? value) =>
      RealmObjectBase.set(this, 'deviceVersion', value);

  @override
  bool? get pubNubPublished =>
      RealmObjectBase.get<bool>(this, 'pubNubPublished') as bool?;
  @override
  set pubNubPublished(bool? value) =>
      RealmObjectBase.set(this, 'pubNubPublished', value);

  @override
  String? get phone => RealmObjectBase.get<String>(this, 'phone') as String?;
  @override
  set phone(String? value) => RealmObjectBase.set(this, 'phone', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get defaultApp =>
      RealmObjectBase.get<String>(this, 'defaultApp') as String?;
  @override
  set defaultApp(String? value) =>
      RealmObjectBase.set(this, 'defaultApp', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<Device>> get changes =>
      RealmObjectBase.getChanges<Device>(this);

  @override
  Stream<RealmObjectChanges<Device>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Device>(this, keyPaths);

  @override
  Device freeze() => RealmObjectBase.freezeObject<Device>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'linkingCode': linkingCode.toEJson(),
      'deviceName': deviceName.toEJson(),
      'deviceVersion': deviceVersion.toEJson(),
      'pubNubPublished': pubNubPublished.toEJson(),
      'phone': phone.toEJson(),
      'branchId': branchId.toEJson(),
      'businessId': businessId.toEJson(),
      'userId': userId.toEJson(),
      'defaultApp': defaultApp.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(Device value) => value.toEJson();
  static Device _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'linkingCode': EJsonValue linkingCode,
        'deviceName': EJsonValue deviceName,
        'deviceVersion': EJsonValue deviceVersion,
        'pubNubPublished': EJsonValue pubNubPublished,
        'phone': EJsonValue phone,
        'branchId': EJsonValue branchId,
        'businessId': EJsonValue businessId,
        'userId': EJsonValue userId,
        'defaultApp': EJsonValue defaultApp,
        'lastTouched': EJsonValue lastTouched,
        'deletedAt': EJsonValue deletedAt,
        'action': EJsonValue action,
      } =>
        Device(
          fromEJson(realmId),
          id: fromEJson(id),
          linkingCode: fromEJson(linkingCode),
          deviceName: fromEJson(deviceName),
          deviceVersion: fromEJson(deviceVersion),
          pubNubPublished: fromEJson(pubNubPublished),
          phone: fromEJson(phone),
          branchId: fromEJson(branchId),
          businessId: fromEJson(businessId),
          userId: fromEJson(userId),
          defaultApp: fromEJson(defaultApp),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
          action: fromEJson(action),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Device._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Device, 'Device', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('linkingCode', RealmPropertyType.string, optional: true),
      SchemaProperty('deviceName', RealmPropertyType.string, optional: true),
      SchemaProperty('deviceVersion', RealmPropertyType.string, optional: true),
      SchemaProperty('pubNubPublished', RealmPropertyType.bool, optional: true),
      SchemaProperty('phone', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
      SchemaProperty('defaultApp', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Discount extends _Discount
    with RealmEntity, RealmObjectBase, RealmObject {
  Discount(
    ObjectId realmId,
    String name,
    int branchId, {
    int? id,
    double? amount,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'branchId', branchId);
  }

  Discount._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  double? get amount => RealmObjectBase.get<double>(this, 'amount') as double?;
  @override
  set amount(double? value) => RealmObjectBase.set(this, 'amount', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  Stream<RealmObjectChanges<Discount>> get changes =>
      RealmObjectBase.getChanges<Discount>(this);

  @override
  Stream<RealmObjectChanges<Discount>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Discount>(this, keyPaths);

  @override
  Discount freeze() => RealmObjectBase.freezeObject<Discount>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'amount': amount.toEJson(),
      'branchId': branchId.toEJson(),
    };
  }

  static EJsonValue _toEJson(Discount value) => value.toEJson();
  static Discount _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'amount': EJsonValue amount,
        'branchId': EJsonValue branchId,
      } =>
        Discount(
          fromEJson(realmId),
          fromEJson(name),
          fromEJson(branchId),
          id: fromEJson(id),
          amount: fromEJson(amount),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Discount._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Discount, 'Discount', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('amount', RealmPropertyType.double, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Drawers extends _Drawers with RealmEntity, RealmObjectBase, RealmObject {
  Drawers(
    ObjectId realmId, {
    int? id,
    double? openingBalance,
    double? closingBalance,
    String? openingDateTime,
    String? closingDateTime,
    int? csSaleCount,
    String? tradeName,
    double? totalNsSaleIncome,
    double? totalCsSaleIncome,
    int? nrSaleCount,
    int? nsSaleCount,
    int? trSaleCount,
    int? psSaleCount,
    int? incompleteSale,
    int? otherTransactions,
    String? paymentMode,
    int? cashierId,
    bool? open,
    DateTime? deletedAt,
  }) {
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'openingBalance', openingBalance);
    RealmObjectBase.set(this, 'closingBalance', closingBalance);
    RealmObjectBase.set(this, 'openingDateTime', openingDateTime);
    RealmObjectBase.set(this, 'closingDateTime', closingDateTime);
    RealmObjectBase.set(this, 'csSaleCount', csSaleCount);
    RealmObjectBase.set(this, 'tradeName', tradeName);
    RealmObjectBase.set(this, 'totalNsSaleIncome', totalNsSaleIncome);
    RealmObjectBase.set(this, 'totalCsSaleIncome', totalCsSaleIncome);
    RealmObjectBase.set(this, 'nrSaleCount', nrSaleCount);
    RealmObjectBase.set(this, 'nsSaleCount', nsSaleCount);
    RealmObjectBase.set(this, 'trSaleCount', trSaleCount);
    RealmObjectBase.set(this, 'psSaleCount', psSaleCount);
    RealmObjectBase.set(this, 'incompleteSale', incompleteSale);
    RealmObjectBase.set(this, 'otherTransactions', otherTransactions);
    RealmObjectBase.set(this, 'paymentMode', paymentMode);
    RealmObjectBase.set(this, 'cashierId', cashierId);
    RealmObjectBase.set(this, 'open', open);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  Drawers._();

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  double? get openingBalance =>
      RealmObjectBase.get<double>(this, 'openingBalance') as double?;
  @override
  set openingBalance(double? value) =>
      RealmObjectBase.set(this, 'openingBalance', value);

  @override
  double? get closingBalance =>
      RealmObjectBase.get<double>(this, 'closingBalance') as double?;
  @override
  set closingBalance(double? value) =>
      RealmObjectBase.set(this, 'closingBalance', value);

  @override
  String? get openingDateTime =>
      RealmObjectBase.get<String>(this, 'openingDateTime') as String?;
  @override
  set openingDateTime(String? value) =>
      RealmObjectBase.set(this, 'openingDateTime', value);

  @override
  String? get closingDateTime =>
      RealmObjectBase.get<String>(this, 'closingDateTime') as String?;
  @override
  set closingDateTime(String? value) =>
      RealmObjectBase.set(this, 'closingDateTime', value);

  @override
  int? get csSaleCount => RealmObjectBase.get<int>(this, 'csSaleCount') as int?;
  @override
  set csSaleCount(int? value) =>
      RealmObjectBase.set(this, 'csSaleCount', value);

  @override
  String? get tradeName =>
      RealmObjectBase.get<String>(this, 'tradeName') as String?;
  @override
  set tradeName(String? value) => RealmObjectBase.set(this, 'tradeName', value);

  @override
  double? get totalNsSaleIncome =>
      RealmObjectBase.get<double>(this, 'totalNsSaleIncome') as double?;
  @override
  set totalNsSaleIncome(double? value) =>
      RealmObjectBase.set(this, 'totalNsSaleIncome', value);

  @override
  double? get totalCsSaleIncome =>
      RealmObjectBase.get<double>(this, 'totalCsSaleIncome') as double?;
  @override
  set totalCsSaleIncome(double? value) =>
      RealmObjectBase.set(this, 'totalCsSaleIncome', value);

  @override
  int? get nrSaleCount => RealmObjectBase.get<int>(this, 'nrSaleCount') as int?;
  @override
  set nrSaleCount(int? value) =>
      RealmObjectBase.set(this, 'nrSaleCount', value);

  @override
  int? get nsSaleCount => RealmObjectBase.get<int>(this, 'nsSaleCount') as int?;
  @override
  set nsSaleCount(int? value) =>
      RealmObjectBase.set(this, 'nsSaleCount', value);

  @override
  int? get trSaleCount => RealmObjectBase.get<int>(this, 'trSaleCount') as int?;
  @override
  set trSaleCount(int? value) =>
      RealmObjectBase.set(this, 'trSaleCount', value);

  @override
  int? get psSaleCount => RealmObjectBase.get<int>(this, 'psSaleCount') as int?;
  @override
  set psSaleCount(int? value) =>
      RealmObjectBase.set(this, 'psSaleCount', value);

  @override
  int? get incompleteSale =>
      RealmObjectBase.get<int>(this, 'incompleteSale') as int?;
  @override
  set incompleteSale(int? value) =>
      RealmObjectBase.set(this, 'incompleteSale', value);

  @override
  int? get otherTransactions =>
      RealmObjectBase.get<int>(this, 'otherTransactions') as int?;
  @override
  set otherTransactions(int? value) =>
      RealmObjectBase.set(this, 'otherTransactions', value);

  @override
  String? get paymentMode =>
      RealmObjectBase.get<String>(this, 'paymentMode') as String?;
  @override
  set paymentMode(String? value) =>
      RealmObjectBase.set(this, 'paymentMode', value);

  @override
  int? get cashierId => RealmObjectBase.get<int>(this, 'cashierId') as int?;
  @override
  set cashierId(int? value) => RealmObjectBase.set(this, 'cashierId', value);

  @override
  bool? get open => RealmObjectBase.get<bool>(this, 'open') as bool?;
  @override
  set open(bool? value) => RealmObjectBase.set(this, 'open', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<Drawers>> get changes =>
      RealmObjectBase.getChanges<Drawers>(this);

  @override
  Stream<RealmObjectChanges<Drawers>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Drawers>(this, keyPaths);

  @override
  Drawers freeze() => RealmObjectBase.freezeObject<Drawers>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': realmId.toEJson(),
      'id': id.toEJson(),
      'openingBalance': openingBalance.toEJson(),
      'closingBalance': closingBalance.toEJson(),
      'openingDateTime': openingDateTime.toEJson(),
      'closingDateTime': closingDateTime.toEJson(),
      'csSaleCount': csSaleCount.toEJson(),
      'tradeName': tradeName.toEJson(),
      'totalNsSaleIncome': totalNsSaleIncome.toEJson(),
      'totalCsSaleIncome': totalCsSaleIncome.toEJson(),
      'nrSaleCount': nrSaleCount.toEJson(),
      'nsSaleCount': nsSaleCount.toEJson(),
      'trSaleCount': trSaleCount.toEJson(),
      'psSaleCount': psSaleCount.toEJson(),
      'incompleteSale': incompleteSale.toEJson(),
      'otherTransactions': otherTransactions.toEJson(),
      'paymentMode': paymentMode.toEJson(),
      'cashierId': cashierId.toEJson(),
      'open': open.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Drawers value) => value.toEJson();
  static Drawers _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue realmId,
        'id': EJsonValue id,
        'openingBalance': EJsonValue openingBalance,
        'closingBalance': EJsonValue closingBalance,
        'openingDateTime': EJsonValue openingDateTime,
        'closingDateTime': EJsonValue closingDateTime,
        'csSaleCount': EJsonValue csSaleCount,
        'tradeName': EJsonValue tradeName,
        'totalNsSaleIncome': EJsonValue totalNsSaleIncome,
        'totalCsSaleIncome': EJsonValue totalCsSaleIncome,
        'nrSaleCount': EJsonValue nrSaleCount,
        'nsSaleCount': EJsonValue nsSaleCount,
        'trSaleCount': EJsonValue trSaleCount,
        'psSaleCount': EJsonValue psSaleCount,
        'incompleteSale': EJsonValue incompleteSale,
        'otherTransactions': EJsonValue otherTransactions,
        'paymentMode': EJsonValue paymentMode,
        'cashierId': EJsonValue cashierId,
        'open': EJsonValue open,
        'deletedAt': EJsonValue deletedAt,
      } =>
        Drawers(
          fromEJson(realmId),
          id: fromEJson(id),
          openingBalance: fromEJson(openingBalance),
          closingBalance: fromEJson(closingBalance),
          openingDateTime: fromEJson(openingDateTime),
          closingDateTime: fromEJson(closingDateTime),
          csSaleCount: fromEJson(csSaleCount),
          tradeName: fromEJson(tradeName),
          totalNsSaleIncome: fromEJson(totalNsSaleIncome),
          totalCsSaleIncome: fromEJson(totalCsSaleIncome),
          nrSaleCount: fromEJson(nrSaleCount),
          nsSaleCount: fromEJson(nsSaleCount),
          trSaleCount: fromEJson(trSaleCount),
          psSaleCount: fromEJson(psSaleCount),
          incompleteSale: fromEJson(incompleteSale),
          otherTransactions: fromEJson(otherTransactions),
          paymentMode: fromEJson(paymentMode),
          cashierId: fromEJson(cashierId),
          open: fromEJson(open),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Drawers._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Drawers, 'Drawers', [
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('openingBalance', RealmPropertyType.double,
          optional: true),
      SchemaProperty('closingBalance', RealmPropertyType.double,
          optional: true),
      SchemaProperty('openingDateTime', RealmPropertyType.string,
          optional: true),
      SchemaProperty('closingDateTime', RealmPropertyType.string,
          optional: true),
      SchemaProperty('csSaleCount', RealmPropertyType.int, optional: true),
      SchemaProperty('tradeName', RealmPropertyType.string, optional: true),
      SchemaProperty('totalNsSaleIncome', RealmPropertyType.double,
          optional: true),
      SchemaProperty('totalCsSaleIncome', RealmPropertyType.double,
          optional: true),
      SchemaProperty('nrSaleCount', RealmPropertyType.int, optional: true),
      SchemaProperty('nsSaleCount', RealmPropertyType.int, optional: true),
      SchemaProperty('trSaleCount', RealmPropertyType.int, optional: true),
      SchemaProperty('psSaleCount', RealmPropertyType.int, optional: true),
      SchemaProperty('incompleteSale', RealmPropertyType.int, optional: true),
      SchemaProperty('otherTransactions', RealmPropertyType.int,
          optional: true),
      SchemaProperty('paymentMode', RealmPropertyType.string, optional: true),
      SchemaProperty('cashierId', RealmPropertyType.int, optional: true),
      SchemaProperty('open', RealmPropertyType.bool, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class EBM extends _EBM with RealmEntity, RealmObjectBase, RealmObject {
  EBM(
    ObjectId realmId,
    String bhfId,
    int tinNumber,
    String dvcSrlNo,
    int userId,
    int businessId,
    int branchId,
    String action, {
    int? id,
    String? taxServerUrl,
    DateTime? lastTouched,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'tinNumber', tinNumber);
    RealmObjectBase.set(this, 'dvcSrlNo', dvcSrlNo);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'taxServerUrl', taxServerUrl);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
  }

  EBM._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String;
  @override
  set bhfId(String value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  int get tinNumber => RealmObjectBase.get<int>(this, 'tinNumber') as int;
  @override
  set tinNumber(int value) => RealmObjectBase.set(this, 'tinNumber', value);

  @override
  String get dvcSrlNo =>
      RealmObjectBase.get<String>(this, 'dvcSrlNo') as String;
  @override
  set dvcSrlNo(String value) => RealmObjectBase.set(this, 'dvcSrlNo', value);

  @override
  int get userId => RealmObjectBase.get<int>(this, 'userId') as int;
  @override
  set userId(int value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get taxServerUrl =>
      RealmObjectBase.get<String>(this, 'taxServerUrl') as String?;
  @override
  set taxServerUrl(String? value) =>
      RealmObjectBase.set(this, 'taxServerUrl', value);

  @override
  int get businessId => RealmObjectBase.get<int>(this, 'businessId') as int;
  @override
  set businessId(int value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<EBM>> get changes =>
      RealmObjectBase.getChanges<EBM>(this);

  @override
  Stream<RealmObjectChanges<EBM>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<EBM>(this, keyPaths);

  @override
  EBM freeze() => RealmObjectBase.freezeObject<EBM>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'bhfId': bhfId.toEJson(),
      'tinNumber': tinNumber.toEJson(),
      'dvcSrlNo': dvcSrlNo.toEJson(),
      'userId': userId.toEJson(),
      'taxServerUrl': taxServerUrl.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(EBM value) => value.toEJson();
  static EBM _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'bhfId': EJsonValue bhfId,
        'tinNumber': EJsonValue tinNumber,
        'dvcSrlNo': EJsonValue dvcSrlNo,
        'userId': EJsonValue userId,
        'taxServerUrl': EJsonValue taxServerUrl,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
      } =>
        EBM(
          fromEJson(realmId),
          fromEJson(bhfId),
          fromEJson(tinNumber),
          fromEJson(dvcSrlNo),
          fromEJson(userId),
          fromEJson(businessId),
          fromEJson(branchId),
          fromEJson(action),
          id: fromEJson(id),
          taxServerUrl: fromEJson(taxServerUrl),
          lastTouched: fromEJson(lastTouched),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(EBM._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, EBM, 'EBM', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('bhfId', RealmPropertyType.string),
      SchemaProperty('tinNumber', RealmPropertyType.int),
      SchemaProperty('dvcSrlNo', RealmPropertyType.string),
      SchemaProperty('userId', RealmPropertyType.int),
      SchemaProperty('taxServerUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Favorite extends _Favorite
    with RealmEntity, RealmObjectBase, RealmObject {
  Favorite(
    ObjectId realmId, {
    int? id,
    int? favIndex,
    int? productId,
    int? branchId,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'favIndex', favIndex);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  Favorite._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get favIndex => RealmObjectBase.get<int>(this, 'favIndex') as int?;
  @override
  set favIndex(int? value) => RealmObjectBase.set(this, 'favIndex', value);

  @override
  int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
  @override
  set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<Favorite>> get changes =>
      RealmObjectBase.getChanges<Favorite>(this);

  @override
  Stream<RealmObjectChanges<Favorite>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Favorite>(this, keyPaths);

  @override
  Favorite freeze() => RealmObjectBase.freezeObject<Favorite>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'favIndex': favIndex.toEJson(),
      'productId': productId.toEJson(),
      'branchId': branchId.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Favorite value) => value.toEJson();
  static Favorite _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'favIndex': EJsonValue favIndex,
        'productId': EJsonValue productId,
        'branchId': EJsonValue branchId,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
      } =>
        Favorite(
          fromEJson(realmId),
          id: fromEJson(id),
          favIndex: fromEJson(favIndex),
          productId: fromEJson(productId),
          branchId: fromEJson(branchId),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Favorite._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Favorite, 'Favorite', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('favIndex', RealmPropertyType.int, optional: true),
      SchemaProperty('productId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Product extends _Product with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Product(
    ObjectId realmId, {
    int? id,
    String? name,
    String? description,
    String? taxId,
    String color = "#e74c3c",
    int? businessId,
    int? branchId,
    String? supplierId,
    int? categoryId,
    String? createdAt,
    String? unit,
    String? imageUrl,
    String? expiryDate,
    String? barCode,
    bool nfcEnabled = false,
    int? bindedToTenantId,
    bool isFavorite = false,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
    String? spplrNm,
    bool? isComposite = false,
    Iterable<Composite> composites = const [],
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Product>({
        'color': "#e74c3c",
        'nfcEnabled': false,
        'isFavorite': false,
        'isComposite': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'taxId', taxId);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'supplierId', supplierId);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'expiryDate', expiryDate);
    RealmObjectBase.set(this, 'barCode', barCode);
    RealmObjectBase.set(this, 'nfcEnabled', nfcEnabled);
    RealmObjectBase.set(this, 'bindedToTenantId', bindedToTenantId);
    RealmObjectBase.set(this, 'isFavorite', isFavorite);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'spplrNm', spplrNm);
    RealmObjectBase.set(this, 'isComposite', isComposite);
    RealmObjectBase.set<RealmList<Composite>>(
        this, 'composites', RealmList<Composite>(composites));
  }

  Product._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;
  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get taxId => RealmObjectBase.get<String>(this, 'taxId') as String?;
  @override
  set taxId(String? value) => RealmObjectBase.set(this, 'taxId', value);

  @override
  String get color => RealmObjectBase.get<String>(this, 'color') as String;
  @override
  set color(String value) => RealmObjectBase.set(this, 'color', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get supplierId =>
      RealmObjectBase.get<String>(this, 'supplierId') as String?;
  @override
  set supplierId(String? value) =>
      RealmObjectBase.set(this, 'supplierId', value);

  @override
  int? get categoryId => RealmObjectBase.get<int>(this, 'categoryId') as int?;
  @override
  set categoryId(int? value) => RealmObjectBase.set(this, 'categoryId', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
  @override
  set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  String? get expiryDate =>
      RealmObjectBase.get<String>(this, 'expiryDate') as String?;
  @override
  set expiryDate(String? value) =>
      RealmObjectBase.set(this, 'expiryDate', value);

  @override
  String? get barCode =>
      RealmObjectBase.get<String>(this, 'barCode') as String?;
  @override
  set barCode(String? value) => RealmObjectBase.set(this, 'barCode', value);

  @override
  bool get nfcEnabled => RealmObjectBase.get<bool>(this, 'nfcEnabled') as bool;
  @override
  set nfcEnabled(bool value) => RealmObjectBase.set(this, 'nfcEnabled', value);

  @override
  int? get bindedToTenantId =>
      RealmObjectBase.get<int>(this, 'bindedToTenantId') as int?;
  @override
  set bindedToTenantId(int? value) =>
      RealmObjectBase.set(this, 'bindedToTenantId', value);

  @override
  bool get isFavorite => RealmObjectBase.get<bool>(this, 'isFavorite') as bool;
  @override
  set isFavorite(bool value) => RealmObjectBase.set(this, 'isFavorite', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get spplrNm =>
      RealmObjectBase.get<String>(this, 'spplrNm') as String?;
  @override
  set spplrNm(String? value) => RealmObjectBase.set(this, 'spplrNm', value);

  @override
  bool? get isComposite =>
      RealmObjectBase.get<bool>(this, 'isComposite') as bool?;
  @override
  set isComposite(bool? value) =>
      RealmObjectBase.set(this, 'isComposite', value);

  @override
  RealmList<Composite> get composites =>
      RealmObjectBase.get<Composite>(this, 'composites')
          as RealmList<Composite>;
  @override
  set composites(covariant RealmList<Composite> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Product>> get changes =>
      RealmObjectBase.getChanges<Product>(this);

  @override
  Stream<RealmObjectChanges<Product>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Product>(this, keyPaths);

  @override
  Product freeze() => RealmObjectBase.freezeObject<Product>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'description': description.toEJson(),
      'taxId': taxId.toEJson(),
      'color': color.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
      'supplierId': supplierId.toEJson(),
      'categoryId': categoryId.toEJson(),
      'createdAt': createdAt.toEJson(),
      'unit': unit.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'expiryDate': expiryDate.toEJson(),
      'barCode': barCode.toEJson(),
      'nfcEnabled': nfcEnabled.toEJson(),
      'bindedToTenantId': bindedToTenantId.toEJson(),
      'isFavorite': isFavorite.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'spplrNm': spplrNm.toEJson(),
      'isComposite': isComposite.toEJson(),
      'composites': composites.toEJson(),
    };
  }

  static EJsonValue _toEJson(Product value) => value.toEJson();
  static Product _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'description': EJsonValue description,
        'taxId': EJsonValue taxId,
        'color': EJsonValue color,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
        'supplierId': EJsonValue supplierId,
        'categoryId': EJsonValue categoryId,
        'createdAt': EJsonValue createdAt,
        'unit': EJsonValue unit,
        'imageUrl': EJsonValue imageUrl,
        'expiryDate': EJsonValue expiryDate,
        'barCode': EJsonValue barCode,
        'nfcEnabled': EJsonValue nfcEnabled,
        'bindedToTenantId': EJsonValue bindedToTenantId,
        'isFavorite': EJsonValue isFavorite,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
        'spplrNm': EJsonValue spplrNm,
        'isComposite': EJsonValue isComposite,
        'composites': EJsonValue composites,
      } =>
        Product(
          fromEJson(realmId),
          id: fromEJson(id),
          name: fromEJson(name),
          description: fromEJson(description),
          taxId: fromEJson(taxId),
          color: fromEJson(color),
          businessId: fromEJson(businessId),
          branchId: fromEJson(branchId),
          supplierId: fromEJson(supplierId),
          categoryId: fromEJson(categoryId),
          createdAt: fromEJson(createdAt),
          unit: fromEJson(unit),
          imageUrl: fromEJson(imageUrl),
          expiryDate: fromEJson(expiryDate),
          barCode: fromEJson(barCode),
          nfcEnabled: fromEJson(nfcEnabled),
          bindedToTenantId: fromEJson(bindedToTenantId),
          isFavorite: fromEJson(isFavorite),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
          spplrNm: fromEJson(spplrNm),
          isComposite: fromEJson(isComposite),
          composites: fromEJson(composites),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Product._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Product, 'Product', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('taxId', RealmPropertyType.string, optional: true),
      SchemaProperty('color', RealmPropertyType.string),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('supplierId', RealmPropertyType.string, optional: true),
      SchemaProperty('categoryId', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('unit', RealmPropertyType.string, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('expiryDate', RealmPropertyType.string, optional: true),
      SchemaProperty('barCode', RealmPropertyType.string, optional: true),
      SchemaProperty('nfcEnabled', RealmPropertyType.bool),
      SchemaProperty('bindedToTenantId', RealmPropertyType.int, optional: true),
      SchemaProperty('isFavorite', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('spplrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('isComposite', RealmPropertyType.bool, optional: true),
      SchemaProperty('composites', RealmPropertyType.object,
          linkTarget: 'Composite', collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Receipt extends _Receipt with RealmEntity, RealmObjectBase, RealmObject {
  Receipt(
    ObjectId realmId, {
    int? id,
    String? resultCd,
    String? resultMsg,
    String? resultDt,
    int? rcptNo,
    String? intrlData,
    String? rcptSign,
    int? totRcptNo,
    String? vsdcRcptPbctDate,
    String? sdcId,
    String? mrcNo,
    String? qrCode,
    String? receiptType,
    int? branchId,
    int? transactionId,
    DateTime? lastTouched,
    String? action,
    int? invcNo,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'resultCd', resultCd);
    RealmObjectBase.set(this, 'resultMsg', resultMsg);
    RealmObjectBase.set(this, 'resultDt', resultDt);
    RealmObjectBase.set(this, 'rcptNo', rcptNo);
    RealmObjectBase.set(this, 'intrlData', intrlData);
    RealmObjectBase.set(this, 'rcptSign', rcptSign);
    RealmObjectBase.set(this, 'totRcptNo', totRcptNo);
    RealmObjectBase.set(this, 'vsdcRcptPbctDate', vsdcRcptPbctDate);
    RealmObjectBase.set(this, 'sdcId', sdcId);
    RealmObjectBase.set(this, 'mrcNo', mrcNo);
    RealmObjectBase.set(this, 'qrCode', qrCode);
    RealmObjectBase.set(this, 'receiptType', receiptType);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'transactionId', transactionId);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'invcNo', invcNo);
  }

  Receipt._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get resultCd =>
      RealmObjectBase.get<String>(this, 'resultCd') as String?;
  @override
  set resultCd(String? value) => RealmObjectBase.set(this, 'resultCd', value);

  @override
  String? get resultMsg =>
      RealmObjectBase.get<String>(this, 'resultMsg') as String?;
  @override
  set resultMsg(String? value) => RealmObjectBase.set(this, 'resultMsg', value);

  @override
  String? get resultDt =>
      RealmObjectBase.get<String>(this, 'resultDt') as String?;
  @override
  set resultDt(String? value) => RealmObjectBase.set(this, 'resultDt', value);

  @override
  int? get rcptNo => RealmObjectBase.get<int>(this, 'rcptNo') as int?;
  @override
  set rcptNo(int? value) => RealmObjectBase.set(this, 'rcptNo', value);

  @override
  String? get intrlData =>
      RealmObjectBase.get<String>(this, 'intrlData') as String?;
  @override
  set intrlData(String? value) => RealmObjectBase.set(this, 'intrlData', value);

  @override
  String? get rcptSign =>
      RealmObjectBase.get<String>(this, 'rcptSign') as String?;
  @override
  set rcptSign(String? value) => RealmObjectBase.set(this, 'rcptSign', value);

  @override
  int? get totRcptNo => RealmObjectBase.get<int>(this, 'totRcptNo') as int?;
  @override
  set totRcptNo(int? value) => RealmObjectBase.set(this, 'totRcptNo', value);

  @override
  String? get vsdcRcptPbctDate =>
      RealmObjectBase.get<String>(this, 'vsdcRcptPbctDate') as String?;
  @override
  set vsdcRcptPbctDate(String? value) =>
      RealmObjectBase.set(this, 'vsdcRcptPbctDate', value);

  @override
  String? get sdcId => RealmObjectBase.get<String>(this, 'sdcId') as String?;
  @override
  set sdcId(String? value) => RealmObjectBase.set(this, 'sdcId', value);

  @override
  String? get mrcNo => RealmObjectBase.get<String>(this, 'mrcNo') as String?;
  @override
  set mrcNo(String? value) => RealmObjectBase.set(this, 'mrcNo', value);

  @override
  String? get qrCode => RealmObjectBase.get<String>(this, 'qrCode') as String?;
  @override
  set qrCode(String? value) => RealmObjectBase.set(this, 'qrCode', value);

  @override
  String? get receiptType =>
      RealmObjectBase.get<String>(this, 'receiptType') as String?;
  @override
  set receiptType(String? value) =>
      RealmObjectBase.set(this, 'receiptType', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get transactionId =>
      RealmObjectBase.get<int>(this, 'transactionId') as int?;
  @override
  set transactionId(int? value) =>
      RealmObjectBase.set(this, 'transactionId', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  int? get invcNo => RealmObjectBase.get<int>(this, 'invcNo') as int?;
  @override
  set invcNo(int? value) => RealmObjectBase.set(this, 'invcNo', value);

  @override
  Stream<RealmObjectChanges<Receipt>> get changes =>
      RealmObjectBase.getChanges<Receipt>(this);

  @override
  Stream<RealmObjectChanges<Receipt>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Receipt>(this, keyPaths);

  @override
  Receipt freeze() => RealmObjectBase.freezeObject<Receipt>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'resultCd': resultCd.toEJson(),
      'resultMsg': resultMsg.toEJson(),
      'resultDt': resultDt.toEJson(),
      'rcptNo': rcptNo.toEJson(),
      'intrlData': intrlData.toEJson(),
      'rcptSign': rcptSign.toEJson(),
      'totRcptNo': totRcptNo.toEJson(),
      'vsdcRcptPbctDate': vsdcRcptPbctDate.toEJson(),
      'sdcId': sdcId.toEJson(),
      'mrcNo': mrcNo.toEJson(),
      'qrCode': qrCode.toEJson(),
      'receiptType': receiptType.toEJson(),
      'branchId': branchId.toEJson(),
      'transactionId': transactionId.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'invcNo': invcNo.toEJson(),
    };
  }

  static EJsonValue _toEJson(Receipt value) => value.toEJson();
  static Receipt _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'resultCd': EJsonValue resultCd,
        'resultMsg': EJsonValue resultMsg,
        'resultDt': EJsonValue resultDt,
        'rcptNo': EJsonValue rcptNo,
        'intrlData': EJsonValue intrlData,
        'rcptSign': EJsonValue rcptSign,
        'totRcptNo': EJsonValue totRcptNo,
        'vsdcRcptPbctDate': EJsonValue vsdcRcptPbctDate,
        'sdcId': EJsonValue sdcId,
        'mrcNo': EJsonValue mrcNo,
        'qrCode': EJsonValue qrCode,
        'receiptType': EJsonValue receiptType,
        'branchId': EJsonValue branchId,
        'transactionId': EJsonValue transactionId,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'invcNo': EJsonValue invcNo,
      } =>
        Receipt(
          fromEJson(realmId),
          id: fromEJson(id),
          resultCd: fromEJson(resultCd),
          resultMsg: fromEJson(resultMsg),
          resultDt: fromEJson(resultDt),
          rcptNo: fromEJson(rcptNo),
          intrlData: fromEJson(intrlData),
          rcptSign: fromEJson(rcptSign),
          totRcptNo: fromEJson(totRcptNo),
          vsdcRcptPbctDate: fromEJson(vsdcRcptPbctDate),
          sdcId: fromEJson(sdcId),
          mrcNo: fromEJson(mrcNo),
          qrCode: fromEJson(qrCode),
          receiptType: fromEJson(receiptType),
          branchId: fromEJson(branchId),
          transactionId: fromEJson(transactionId),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          invcNo: fromEJson(invcNo),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Receipt._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Receipt, 'Receipt', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('resultCd', RealmPropertyType.string, optional: true),
      SchemaProperty('resultMsg', RealmPropertyType.string, optional: true),
      SchemaProperty('resultDt', RealmPropertyType.string, optional: true),
      SchemaProperty('rcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('intrlData', RealmPropertyType.string, optional: true),
      SchemaProperty('rcptSign', RealmPropertyType.string, optional: true),
      SchemaProperty('totRcptNo', RealmPropertyType.int, optional: true),
      SchemaProperty('vsdcRcptPbctDate', RealmPropertyType.string,
          optional: true),
      SchemaProperty('sdcId', RealmPropertyType.string, optional: true),
      SchemaProperty('mrcNo', RealmPropertyType.string, optional: true),
      SchemaProperty('qrCode', RealmPropertyType.string, optional: true),
      SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('transactionId', RealmPropertyType.int, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('invcNo', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Setting extends _Setting with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Setting(
    ObjectId realmId, {
    int? id,
    String? email,
    int? userId,
    bool? openReceiptFileOSaleComplete,
    bool? autoPrint,
    bool? sendDailyReport,
    String? defaultLanguage,
    bool? attendnaceDocCreated,
    bool? isAttendanceEnabled,
    String? type,
    bool? enrolledInBot,
    String? deviceToken,
    String? businessPhoneNumber,
    bool? autoRespond,
    String? token,
    bool hasPin = false,
    int? businessId,
    String? createdAt,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Setting>({
        'hasPin': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(
        this, 'openReceiptFileOSaleComplete', openReceiptFileOSaleComplete);
    RealmObjectBase.set(this, 'autoPrint', autoPrint);
    RealmObjectBase.set(this, 'sendDailyReport', sendDailyReport);
    RealmObjectBase.set(this, 'defaultLanguage', defaultLanguage);
    RealmObjectBase.set(this, 'attendnaceDocCreated', attendnaceDocCreated);
    RealmObjectBase.set(this, 'isAttendanceEnabled', isAttendanceEnabled);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'enrolledInBot', enrolledInBot);
    RealmObjectBase.set(this, 'deviceToken', deviceToken);
    RealmObjectBase.set(this, 'businessPhoneNumber', businessPhoneNumber);
    RealmObjectBase.set(this, 'autoRespond', autoRespond);
    RealmObjectBase.set(this, 'token', token);
    RealmObjectBase.set(this, 'hasPin', hasPin);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'action', action);
  }

  Setting._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  bool? get openReceiptFileOSaleComplete =>
      RealmObjectBase.get<bool>(this, 'openReceiptFileOSaleComplete') as bool?;
  @override
  set openReceiptFileOSaleComplete(bool? value) =>
      RealmObjectBase.set(this, 'openReceiptFileOSaleComplete', value);

  @override
  bool? get autoPrint => RealmObjectBase.get<bool>(this, 'autoPrint') as bool?;
  @override
  set autoPrint(bool? value) => RealmObjectBase.set(this, 'autoPrint', value);

  @override
  bool? get sendDailyReport =>
      RealmObjectBase.get<bool>(this, 'sendDailyReport') as bool?;
  @override
  set sendDailyReport(bool? value) =>
      RealmObjectBase.set(this, 'sendDailyReport', value);

  @override
  String? get defaultLanguage =>
      RealmObjectBase.get<String>(this, 'defaultLanguage') as String?;
  @override
  set defaultLanguage(String? value) =>
      RealmObjectBase.set(this, 'defaultLanguage', value);

  @override
  bool? get attendnaceDocCreated =>
      RealmObjectBase.get<bool>(this, 'attendnaceDocCreated') as bool?;
  @override
  set attendnaceDocCreated(bool? value) =>
      RealmObjectBase.set(this, 'attendnaceDocCreated', value);

  @override
  bool? get isAttendanceEnabled =>
      RealmObjectBase.get<bool>(this, 'isAttendanceEnabled') as bool?;
  @override
  set isAttendanceEnabled(bool? value) =>
      RealmObjectBase.set(this, 'isAttendanceEnabled', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  bool? get enrolledInBot =>
      RealmObjectBase.get<bool>(this, 'enrolledInBot') as bool?;
  @override
  set enrolledInBot(bool? value) =>
      RealmObjectBase.set(this, 'enrolledInBot', value);

  @override
  String? get deviceToken =>
      RealmObjectBase.get<String>(this, 'deviceToken') as String?;
  @override
  set deviceToken(String? value) =>
      RealmObjectBase.set(this, 'deviceToken', value);

  @override
  String? get businessPhoneNumber =>
      RealmObjectBase.get<String>(this, 'businessPhoneNumber') as String?;
  @override
  set businessPhoneNumber(String? value) =>
      RealmObjectBase.set(this, 'businessPhoneNumber', value);

  @override
  bool? get autoRespond =>
      RealmObjectBase.get<bool>(this, 'autoRespond') as bool?;
  @override
  set autoRespond(bool? value) =>
      RealmObjectBase.set(this, 'autoRespond', value);

  @override
  String? get token => RealmObjectBase.get<String>(this, 'token') as String?;
  @override
  set token(String? value) => RealmObjectBase.set(this, 'token', value);

  @override
  bool get hasPin => RealmObjectBase.get<bool>(this, 'hasPin') as bool;
  @override
  set hasPin(bool value) => RealmObjectBase.set(this, 'hasPin', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<Setting>> get changes =>
      RealmObjectBase.getChanges<Setting>(this);

  @override
  Stream<RealmObjectChanges<Setting>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Setting>(this, keyPaths);

  @override
  Setting freeze() => RealmObjectBase.freezeObject<Setting>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'email': email.toEJson(),
      'userId': userId.toEJson(),
      'openReceiptFileOSaleComplete': openReceiptFileOSaleComplete.toEJson(),
      'autoPrint': autoPrint.toEJson(),
      'sendDailyReport': sendDailyReport.toEJson(),
      'defaultLanguage': defaultLanguage.toEJson(),
      'attendnaceDocCreated': attendnaceDocCreated.toEJson(),
      'isAttendanceEnabled': isAttendanceEnabled.toEJson(),
      'type': type.toEJson(),
      'enrolledInBot': enrolledInBot.toEJson(),
      'deviceToken': deviceToken.toEJson(),
      'businessPhoneNumber': businessPhoneNumber.toEJson(),
      'autoRespond': autoRespond.toEJson(),
      'token': token.toEJson(),
      'hasPin': hasPin.toEJson(),
      'businessId': businessId.toEJson(),
      'createdAt': createdAt.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(Setting value) => value.toEJson();
  static Setting _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'email': EJsonValue email,
        'userId': EJsonValue userId,
        'openReceiptFileOSaleComplete': EJsonValue openReceiptFileOSaleComplete,
        'autoPrint': EJsonValue autoPrint,
        'sendDailyReport': EJsonValue sendDailyReport,
        'defaultLanguage': EJsonValue defaultLanguage,
        'attendnaceDocCreated': EJsonValue attendnaceDocCreated,
        'isAttendanceEnabled': EJsonValue isAttendanceEnabled,
        'type': EJsonValue type,
        'enrolledInBot': EJsonValue enrolledInBot,
        'deviceToken': EJsonValue deviceToken,
        'businessPhoneNumber': EJsonValue businessPhoneNumber,
        'autoRespond': EJsonValue autoRespond,
        'token': EJsonValue token,
        'hasPin': EJsonValue hasPin,
        'businessId': EJsonValue businessId,
        'createdAt': EJsonValue createdAt,
        'lastTouched': EJsonValue lastTouched,
        'deletedAt': EJsonValue deletedAt,
        'action': EJsonValue action,
      } =>
        Setting(
          fromEJson(realmId),
          id: fromEJson(id),
          email: fromEJson(email),
          userId: fromEJson(userId),
          openReceiptFileOSaleComplete: fromEJson(openReceiptFileOSaleComplete),
          autoPrint: fromEJson(autoPrint),
          sendDailyReport: fromEJson(sendDailyReport),
          defaultLanguage: fromEJson(defaultLanguage),
          attendnaceDocCreated: fromEJson(attendnaceDocCreated),
          isAttendanceEnabled: fromEJson(isAttendanceEnabled),
          type: fromEJson(type),
          enrolledInBot: fromEJson(enrolledInBot),
          deviceToken: fromEJson(deviceToken),
          businessPhoneNumber: fromEJson(businessPhoneNumber),
          autoRespond: fromEJson(autoRespond),
          token: fromEJson(token),
          hasPin: fromEJson(hasPin),
          businessId: fromEJson(businessId),
          createdAt: fromEJson(createdAt),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
          action: fromEJson(action),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Setting._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Setting, 'Setting', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
      SchemaProperty('openReceiptFileOSaleComplete', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('autoPrint', RealmPropertyType.bool, optional: true),
      SchemaProperty('sendDailyReport', RealmPropertyType.bool, optional: true),
      SchemaProperty('defaultLanguage', RealmPropertyType.string,
          optional: true),
      SchemaProperty('attendnaceDocCreated', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('isAttendanceEnabled', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('enrolledInBot', RealmPropertyType.bool, optional: true),
      SchemaProperty('deviceToken', RealmPropertyType.string, optional: true),
      SchemaProperty('businessPhoneNumber', RealmPropertyType.string,
          optional: true),
      SchemaProperty('autoRespond', RealmPropertyType.bool, optional: true),
      SchemaProperty('token', RealmPropertyType.string, optional: true),
      SchemaProperty('hasPin', RealmPropertyType.bool),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Stock extends _Stock with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Stock(
    ObjectId? realmId, {
    int? id,
    int? tin,
    String? bhfId,
    int? branchId,
    int? variantId,
    double lowStock = 0,
    double currentStock = 0.0,
    bool? canTrackingStock = true,
    bool? showLowStockAlert = true,
    int? productId,
    bool? active,
    double value = 0.0,
    double rsdQty = 0.0,
    double supplyPrice = 0.0,
    double retailPrice = 0.0,
    DateTime? lastTouched,
    String? action,
    DateTime? deletedAt,
    bool ebmSynced = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Stock>({
        'lowStock': 0,
        'currentStock': 0.0,
        'canTrackingStock': true,
        'showLowStockAlert': true,
        'value': 0.0,
        'rsdQty': 0.0,
        'supplyPrice': 0.0,
        'retailPrice': 0.0,
        'ebmSynced': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'variantId', variantId);
    RealmObjectBase.set(this, 'lowStock', lowStock);
    RealmObjectBase.set(this, 'currentStock', currentStock);
    RealmObjectBase.set(this, 'canTrackingStock', canTrackingStock);
    RealmObjectBase.set(this, 'showLowStockAlert', showLowStockAlert);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'rsdQty', rsdQty);
    RealmObjectBase.set(this, 'supplyPrice', supplyPrice);
    RealmObjectBase.set(this, 'retailPrice', retailPrice);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
  }

  Stock._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId? get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get variantId => RealmObjectBase.get<int>(this, 'variantId') as int?;
  @override
  set variantId(int? value) => RealmObjectBase.set(this, 'variantId', value);

  @override
  double get lowStock =>
      RealmObjectBase.get<double>(this, 'lowStock') as double;
  @override
  set lowStock(double value) => RealmObjectBase.set(this, 'lowStock', value);

  @override
  double get currentStock =>
      RealmObjectBase.get<double>(this, 'currentStock') as double;
  @override
  set currentStock(double value) =>
      RealmObjectBase.set(this, 'currentStock', value);

  @override
  bool? get canTrackingStock =>
      RealmObjectBase.get<bool>(this, 'canTrackingStock') as bool?;
  @override
  set canTrackingStock(bool? value) =>
      RealmObjectBase.set(this, 'canTrackingStock', value);

  @override
  bool? get showLowStockAlert =>
      RealmObjectBase.get<bool>(this, 'showLowStockAlert') as bool?;
  @override
  set showLowStockAlert(bool? value) =>
      RealmObjectBase.set(this, 'showLowStockAlert', value);

  @override
  int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
  @override
  set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  double get value => RealmObjectBase.get<double>(this, 'value') as double;
  @override
  set value(double value) => RealmObjectBase.set(this, 'value', value);

  @override
  double get rsdQty => RealmObjectBase.get<double>(this, 'rsdQty') as double;
  @override
  set rsdQty(double value) => RealmObjectBase.set(this, 'rsdQty', value);

  @override
  double get supplyPrice =>
      RealmObjectBase.get<double>(this, 'supplyPrice') as double;
  @override
  set supplyPrice(double value) =>
      RealmObjectBase.set(this, 'supplyPrice', value);

  @override
  double get retailPrice =>
      RealmObjectBase.get<double>(this, 'retailPrice') as double;
  @override
  set retailPrice(double value) =>
      RealmObjectBase.set(this, 'retailPrice', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
  @override
  set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  Stream<RealmObjectChanges<Stock>> get changes =>
      RealmObjectBase.getChanges<Stock>(this);

  @override
  Stream<RealmObjectChanges<Stock>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Stock>(this, keyPaths);

  @override
  Stock freeze() => RealmObjectBase.freezeObject<Stock>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'tin': tin.toEJson(),
      'bhfId': bhfId.toEJson(),
      'branchId': branchId.toEJson(),
      'variantId': variantId.toEJson(),
      'lowStock': lowStock.toEJson(),
      'currentStock': currentStock.toEJson(),
      'canTrackingStock': canTrackingStock.toEJson(),
      'showLowStockAlert': showLowStockAlert.toEJson(),
      'productId': productId.toEJson(),
      'active': active.toEJson(),
      'value': value.toEJson(),
      'rsdQty': rsdQty.toEJson(),
      'supplyPrice': supplyPrice.toEJson(),
      'retailPrice': retailPrice.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
    };
  }

  static EJsonValue _toEJson(Stock value) => value.toEJson();
  static Stock _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'tin': EJsonValue tin,
        'bhfId': EJsonValue bhfId,
        'branchId': EJsonValue branchId,
        'variantId': EJsonValue variantId,
        'lowStock': EJsonValue lowStock,
        'currentStock': EJsonValue currentStock,
        'canTrackingStock': EJsonValue canTrackingStock,
        'showLowStockAlert': EJsonValue showLowStockAlert,
        'productId': EJsonValue productId,
        'active': EJsonValue active,
        'value': EJsonValue value,
        'rsdQty': EJsonValue rsdQty,
        'supplyPrice': EJsonValue supplyPrice,
        'retailPrice': EJsonValue retailPrice,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'deletedAt': EJsonValue deletedAt,
        'ebmSynced': EJsonValue ebmSynced,
      } =>
        Stock(
          fromEJson(realmId),
          id: fromEJson(id),
          tin: fromEJson(tin),
          bhfId: fromEJson(bhfId),
          branchId: fromEJson(branchId),
          variantId: fromEJson(variantId),
          lowStock: fromEJson(lowStock),
          currentStock: fromEJson(currentStock),
          canTrackingStock: fromEJson(canTrackingStock),
          showLowStockAlert: fromEJson(showLowStockAlert),
          productId: fromEJson(productId),
          active: fromEJson(active),
          value: fromEJson(value),
          rsdQty: fromEJson(rsdQty),
          supplyPrice: fromEJson(supplyPrice),
          retailPrice: fromEJson(retailPrice),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          deletedAt: fromEJson(deletedAt),
          ebmSynced: fromEJson(ebmSynced),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Stock._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Stock, 'Stock', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('variantId', RealmPropertyType.int, optional: true),
      SchemaProperty('lowStock', RealmPropertyType.double),
      SchemaProperty('currentStock', RealmPropertyType.double),
      SchemaProperty('canTrackingStock', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('showLowStockAlert', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('productId', RealmPropertyType.int, optional: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('value', RealmPropertyType.double),
      SchemaProperty('rsdQty', RealmPropertyType.double),
      SchemaProperty('supplyPrice', RealmPropertyType.double),
      SchemaProperty('retailPrice', RealmPropertyType.double),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Variant extends _Variant with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Variant(
    ObjectId realmId, {
    int? id,
    DateTime? deletedAt,
    String? name,
    String? color,
    String? sku,
    int? productId,
    String? unit,
    String? productName,
    int? branchId,
    String? taxName = "",
    double taxPercentage = 0.0,
    bool isTaxExempted = false,
    int? itemSeq,
    String? isrccCd = "",
    String? isrccNm = "",
    int? isrcRt = 0,
    int? isrcAmt = 0,
    String? taxTyCd = "B",
    String? bcd = "",
    String? itemClsCd,
    String? itemTyCd,
    String? itemStdNm = "",
    String? orgnNatCd = "",
    String? pkg = "1",
    String? itemCd = "",
    String? pkgUnitCd = "CT",
    String? qtyUnitCd = "BX",
    String? itemNm,
    double qty = 0.0,
    double prc = 0.0,
    double splyAmt = 0.0,
    int? tin,
    String? bhfId,
    double? dftPrc = 0,
    String? addInfo = "",
    String? isrcAplcbYn = "",
    String? useYn = "",
    String? regrId,
    String? regrNm,
    String? modrId,
    String? modrNm,
    double rsdQty = 0.0,
    DateTime? lastTouched,
    double supplyPrice = 0.0,
    double retailPrice = 0.0,
    String? action,
    String? spplrItemClsCd,
    String? spplrItemCd,
    String? spplrItemNm,
    bool ebmSynced = false,
    String taxType = "B",
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Variant>({
        'taxName': "",
        'taxPercentage': 0.0,
        'isTaxExempted': false,
        'isrccCd': "",
        'isrccNm': "",
        'isrcRt': 0,
        'isrcAmt': 0,
        'taxTyCd': "B",
        'bcd': "",
        'itemStdNm': "",
        'orgnNatCd': "",
        'pkg': "1",
        'itemCd': "",
        'pkgUnitCd': "CT",
        'qtyUnitCd': "BX",
        'qty': 0.0,
        'prc': 0.0,
        'splyAmt': 0.0,
        'dftPrc': 0,
        'addInfo': "",
        'isrcAplcbYn': "",
        'useYn': "",
        'rsdQty': 0.0,
        'supplyPrice': 0.0,
        'retailPrice': 0.0,
        'ebmSynced': false,
        'taxType': "B",
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'color', color);
    RealmObjectBase.set(this, 'sku', sku);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'unit', unit);
    RealmObjectBase.set(this, 'productName', productName);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'taxName', taxName);
    RealmObjectBase.set(this, 'taxPercentage', taxPercentage);
    RealmObjectBase.set(this, 'isTaxExempted', isTaxExempted);
    RealmObjectBase.set(this, 'itemSeq', itemSeq);
    RealmObjectBase.set(this, 'isrccCd', isrccCd);
    RealmObjectBase.set(this, 'isrccNm', isrccNm);
    RealmObjectBase.set(this, 'isrcRt', isrcRt);
    RealmObjectBase.set(this, 'isrcAmt', isrcAmt);
    RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
    RealmObjectBase.set(this, 'bcd', bcd);
    RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
    RealmObjectBase.set(this, 'itemTyCd', itemTyCd);
    RealmObjectBase.set(this, 'itemStdNm', itemStdNm);
    RealmObjectBase.set(this, 'orgnNatCd', orgnNatCd);
    RealmObjectBase.set(this, 'pkg', pkg);
    RealmObjectBase.set(this, 'itemCd', itemCd);
    RealmObjectBase.set(this, 'pkgUnitCd', pkgUnitCd);
    RealmObjectBase.set(this, 'qtyUnitCd', qtyUnitCd);
    RealmObjectBase.set(this, 'itemNm', itemNm);
    RealmObjectBase.set(this, 'qty', qty);
    RealmObjectBase.set(this, 'prc', prc);
    RealmObjectBase.set(this, 'splyAmt', splyAmt);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'dftPrc', dftPrc);
    RealmObjectBase.set(this, 'addInfo', addInfo);
    RealmObjectBase.set(this, 'isrcAplcbYn', isrcAplcbYn);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'regrId', regrId);
    RealmObjectBase.set(this, 'regrNm', regrNm);
    RealmObjectBase.set(this, 'modrId', modrId);
    RealmObjectBase.set(this, 'modrNm', modrNm);
    RealmObjectBase.set(this, 'rsdQty', rsdQty);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'supplyPrice', supplyPrice);
    RealmObjectBase.set(this, 'retailPrice', retailPrice);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'spplrItemClsCd', spplrItemClsCd);
    RealmObjectBase.set(this, 'spplrItemCd', spplrItemCd);
    RealmObjectBase.set(this, 'spplrItemNm', spplrItemNm);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
    RealmObjectBase.set(this, 'taxType', taxType);
  }

  Variant._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get color => RealmObjectBase.get<String>(this, 'color') as String?;
  @override
  set color(String? value) => RealmObjectBase.set(this, 'color', value);

  @override
  String? get sku => RealmObjectBase.get<String>(this, 'sku') as String?;
  @override
  set sku(String? value) => RealmObjectBase.set(this, 'sku', value);

  @override
  int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
  @override
  set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

  @override
  String? get unit => RealmObjectBase.get<String>(this, 'unit') as String?;
  @override
  set unit(String? value) => RealmObjectBase.set(this, 'unit', value);

  @override
  String? get productName =>
      RealmObjectBase.get<String>(this, 'productName') as String?;
  @override
  set productName(String? value) =>
      RealmObjectBase.set(this, 'productName', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get taxName =>
      RealmObjectBase.get<String>(this, 'taxName') as String?;
  @override
  set taxName(String? value) => RealmObjectBase.set(this, 'taxName', value);

  @override
  double get taxPercentage =>
      RealmObjectBase.get<double>(this, 'taxPercentage') as double;
  @override
  set taxPercentage(double value) =>
      RealmObjectBase.set(this, 'taxPercentage', value);

  @override
  bool get isTaxExempted =>
      RealmObjectBase.get<bool>(this, 'isTaxExempted') as bool;
  @override
  set isTaxExempted(bool value) =>
      RealmObjectBase.set(this, 'isTaxExempted', value);

  @override
  int? get itemSeq => RealmObjectBase.get<int>(this, 'itemSeq') as int?;
  @override
  set itemSeq(int? value) => RealmObjectBase.set(this, 'itemSeq', value);

  @override
  String? get isrccCd =>
      RealmObjectBase.get<String>(this, 'isrccCd') as String?;
  @override
  set isrccCd(String? value) => RealmObjectBase.set(this, 'isrccCd', value);

  @override
  String? get isrccNm =>
      RealmObjectBase.get<String>(this, 'isrccNm') as String?;
  @override
  set isrccNm(String? value) => RealmObjectBase.set(this, 'isrccNm', value);

  @override
  int? get isrcRt => RealmObjectBase.get<int>(this, 'isrcRt') as int?;
  @override
  set isrcRt(int? value) => RealmObjectBase.set(this, 'isrcRt', value);

  @override
  int? get isrcAmt => RealmObjectBase.get<int>(this, 'isrcAmt') as int?;
  @override
  set isrcAmt(int? value) => RealmObjectBase.set(this, 'isrcAmt', value);

  @override
  String? get taxTyCd =>
      RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
  @override
  set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

  @override
  String? get bcd => RealmObjectBase.get<String>(this, 'bcd') as String?;
  @override
  set bcd(String? value) => RealmObjectBase.set(this, 'bcd', value);

  @override
  String? get itemClsCd =>
      RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
  @override
  set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

  @override
  String? get itemTyCd =>
      RealmObjectBase.get<String>(this, 'itemTyCd') as String?;
  @override
  set itemTyCd(String? value) => RealmObjectBase.set(this, 'itemTyCd', value);

  @override
  String? get itemStdNm =>
      RealmObjectBase.get<String>(this, 'itemStdNm') as String?;
  @override
  set itemStdNm(String? value) => RealmObjectBase.set(this, 'itemStdNm', value);

  @override
  String? get orgnNatCd =>
      RealmObjectBase.get<String>(this, 'orgnNatCd') as String?;
  @override
  set orgnNatCd(String? value) => RealmObjectBase.set(this, 'orgnNatCd', value);

  @override
  String? get pkg => RealmObjectBase.get<String>(this, 'pkg') as String?;
  @override
  set pkg(String? value) => RealmObjectBase.set(this, 'pkg', value);

  @override
  String? get itemCd => RealmObjectBase.get<String>(this, 'itemCd') as String?;
  @override
  set itemCd(String? value) => RealmObjectBase.set(this, 'itemCd', value);

  @override
  String? get pkgUnitCd =>
      RealmObjectBase.get<String>(this, 'pkgUnitCd') as String?;
  @override
  set pkgUnitCd(String? value) => RealmObjectBase.set(this, 'pkgUnitCd', value);

  @override
  String? get qtyUnitCd =>
      RealmObjectBase.get<String>(this, 'qtyUnitCd') as String?;
  @override
  set qtyUnitCd(String? value) => RealmObjectBase.set(this, 'qtyUnitCd', value);

  @override
  String? get itemNm => RealmObjectBase.get<String>(this, 'itemNm') as String?;
  @override
  set itemNm(String? value) => RealmObjectBase.set(this, 'itemNm', value);

  @override
  double get qty => RealmObjectBase.get<double>(this, 'qty') as double;
  @override
  set qty(double value) => RealmObjectBase.set(this, 'qty', value);

  @override
  double get prc => RealmObjectBase.get<double>(this, 'prc') as double;
  @override
  set prc(double value) => RealmObjectBase.set(this, 'prc', value);

  @override
  double get splyAmt => RealmObjectBase.get<double>(this, 'splyAmt') as double;
  @override
  set splyAmt(double value) => RealmObjectBase.set(this, 'splyAmt', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  double? get dftPrc => RealmObjectBase.get<double>(this, 'dftPrc') as double?;
  @override
  set dftPrc(double? value) => RealmObjectBase.set(this, 'dftPrc', value);

  @override
  String? get addInfo =>
      RealmObjectBase.get<String>(this, 'addInfo') as String?;
  @override
  set addInfo(String? value) => RealmObjectBase.set(this, 'addInfo', value);

  @override
  String? get isrcAplcbYn =>
      RealmObjectBase.get<String>(this, 'isrcAplcbYn') as String?;
  @override
  set isrcAplcbYn(String? value) =>
      RealmObjectBase.set(this, 'isrcAplcbYn', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
  @override
  set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

  @override
  String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
  @override
  set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

  @override
  String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
  @override
  set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

  @override
  String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
  @override
  set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

  @override
  double get rsdQty => RealmObjectBase.get<double>(this, 'rsdQty') as double;
  @override
  set rsdQty(double value) => RealmObjectBase.set(this, 'rsdQty', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  double get supplyPrice =>
      RealmObjectBase.get<double>(this, 'supplyPrice') as double;
  @override
  set supplyPrice(double value) =>
      RealmObjectBase.set(this, 'supplyPrice', value);

  @override
  double get retailPrice =>
      RealmObjectBase.get<double>(this, 'retailPrice') as double;
  @override
  set retailPrice(double value) =>
      RealmObjectBase.set(this, 'retailPrice', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  String? get spplrItemClsCd =>
      RealmObjectBase.get<String>(this, 'spplrItemClsCd') as String?;
  @override
  set spplrItemClsCd(String? value) =>
      RealmObjectBase.set(this, 'spplrItemClsCd', value);

  @override
  String? get spplrItemCd =>
      RealmObjectBase.get<String>(this, 'spplrItemCd') as String?;
  @override
  set spplrItemCd(String? value) =>
      RealmObjectBase.set(this, 'spplrItemCd', value);

  @override
  String? get spplrItemNm =>
      RealmObjectBase.get<String>(this, 'spplrItemNm') as String?;
  @override
  set spplrItemNm(String? value) =>
      RealmObjectBase.set(this, 'spplrItemNm', value);

  @override
  bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
  @override
  set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  String get taxType => RealmObjectBase.get<String>(this, 'taxType') as String;
  @override
  set taxType(String value) => RealmObjectBase.set(this, 'taxType', value);

  @override
  Stream<RealmObjectChanges<Variant>> get changes =>
      RealmObjectBase.getChanges<Variant>(this);

  @override
  Stream<RealmObjectChanges<Variant>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Variant>(this, keyPaths);

  @override
  Variant freeze() => RealmObjectBase.freezeObject<Variant>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'name': name.toEJson(),
      'color': color.toEJson(),
      'sku': sku.toEJson(),
      'productId': productId.toEJson(),
      'unit': unit.toEJson(),
      'productName': productName.toEJson(),
      'branchId': branchId.toEJson(),
      'taxName': taxName.toEJson(),
      'taxPercentage': taxPercentage.toEJson(),
      'isTaxExempted': isTaxExempted.toEJson(),
      'itemSeq': itemSeq.toEJson(),
      'isrccCd': isrccCd.toEJson(),
      'isrccNm': isrccNm.toEJson(),
      'isrcRt': isrcRt.toEJson(),
      'isrcAmt': isrcAmt.toEJson(),
      'taxTyCd': taxTyCd.toEJson(),
      'bcd': bcd.toEJson(),
      'itemClsCd': itemClsCd.toEJson(),
      'itemTyCd': itemTyCd.toEJson(),
      'itemStdNm': itemStdNm.toEJson(),
      'orgnNatCd': orgnNatCd.toEJson(),
      'pkg': pkg.toEJson(),
      'itemCd': itemCd.toEJson(),
      'pkgUnitCd': pkgUnitCd.toEJson(),
      'qtyUnitCd': qtyUnitCd.toEJson(),
      'itemNm': itemNm.toEJson(),
      'qty': qty.toEJson(),
      'prc': prc.toEJson(),
      'splyAmt': splyAmt.toEJson(),
      'tin': tin.toEJson(),
      'bhfId': bhfId.toEJson(),
      'dftPrc': dftPrc.toEJson(),
      'addInfo': addInfo.toEJson(),
      'isrcAplcbYn': isrcAplcbYn.toEJson(),
      'useYn': useYn.toEJson(),
      'regrId': regrId.toEJson(),
      'regrNm': regrNm.toEJson(),
      'modrId': modrId.toEJson(),
      'modrNm': modrNm.toEJson(),
      'rsdQty': rsdQty.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'supplyPrice': supplyPrice.toEJson(),
      'retailPrice': retailPrice.toEJson(),
      'action': action.toEJson(),
      'spplrItemClsCd': spplrItemClsCd.toEJson(),
      'spplrItemCd': spplrItemCd.toEJson(),
      'spplrItemNm': spplrItemNm.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
      'taxType': taxType.toEJson(),
    };
  }

  static EJsonValue _toEJson(Variant value) => value.toEJson();
  static Variant _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'deletedAt': EJsonValue deletedAt,
        'name': EJsonValue name,
        'color': EJsonValue color,
        'sku': EJsonValue sku,
        'productId': EJsonValue productId,
        'unit': EJsonValue unit,
        'productName': EJsonValue productName,
        'branchId': EJsonValue branchId,
        'taxName': EJsonValue taxName,
        'taxPercentage': EJsonValue taxPercentage,
        'isTaxExempted': EJsonValue isTaxExempted,
        'itemSeq': EJsonValue itemSeq,
        'isrccCd': EJsonValue isrccCd,
        'isrccNm': EJsonValue isrccNm,
        'isrcRt': EJsonValue isrcRt,
        'isrcAmt': EJsonValue isrcAmt,
        'taxTyCd': EJsonValue taxTyCd,
        'bcd': EJsonValue bcd,
        'itemClsCd': EJsonValue itemClsCd,
        'itemTyCd': EJsonValue itemTyCd,
        'itemStdNm': EJsonValue itemStdNm,
        'orgnNatCd': EJsonValue orgnNatCd,
        'pkg': EJsonValue pkg,
        'itemCd': EJsonValue itemCd,
        'pkgUnitCd': EJsonValue pkgUnitCd,
        'qtyUnitCd': EJsonValue qtyUnitCd,
        'itemNm': EJsonValue itemNm,
        'qty': EJsonValue qty,
        'prc': EJsonValue prc,
        'splyAmt': EJsonValue splyAmt,
        'tin': EJsonValue tin,
        'bhfId': EJsonValue bhfId,
        'dftPrc': EJsonValue dftPrc,
        'addInfo': EJsonValue addInfo,
        'isrcAplcbYn': EJsonValue isrcAplcbYn,
        'useYn': EJsonValue useYn,
        'regrId': EJsonValue regrId,
        'regrNm': EJsonValue regrNm,
        'modrId': EJsonValue modrId,
        'modrNm': EJsonValue modrNm,
        'rsdQty': EJsonValue rsdQty,
        'lastTouched': EJsonValue lastTouched,
        'supplyPrice': EJsonValue supplyPrice,
        'retailPrice': EJsonValue retailPrice,
        'action': EJsonValue action,
        'spplrItemClsCd': EJsonValue spplrItemClsCd,
        'spplrItemCd': EJsonValue spplrItemCd,
        'spplrItemNm': EJsonValue spplrItemNm,
        'ebmSynced': EJsonValue ebmSynced,
        'taxType': EJsonValue taxType,
      } =>
        Variant(
          fromEJson(realmId),
          id: fromEJson(id),
          deletedAt: fromEJson(deletedAt),
          name: fromEJson(name),
          color: fromEJson(color),
          sku: fromEJson(sku),
          productId: fromEJson(productId),
          unit: fromEJson(unit),
          productName: fromEJson(productName),
          branchId: fromEJson(branchId),
          taxName: fromEJson(taxName),
          taxPercentage: fromEJson(taxPercentage),
          isTaxExempted: fromEJson(isTaxExempted),
          itemSeq: fromEJson(itemSeq),
          isrccCd: fromEJson(isrccCd),
          isrccNm: fromEJson(isrccNm),
          isrcRt: fromEJson(isrcRt),
          isrcAmt: fromEJson(isrcAmt),
          taxTyCd: fromEJson(taxTyCd),
          bcd: fromEJson(bcd),
          itemClsCd: fromEJson(itemClsCd),
          itemTyCd: fromEJson(itemTyCd),
          itemStdNm: fromEJson(itemStdNm),
          orgnNatCd: fromEJson(orgnNatCd),
          pkg: fromEJson(pkg),
          itemCd: fromEJson(itemCd),
          pkgUnitCd: fromEJson(pkgUnitCd),
          qtyUnitCd: fromEJson(qtyUnitCd),
          itemNm: fromEJson(itemNm),
          qty: fromEJson(qty),
          prc: fromEJson(prc),
          splyAmt: fromEJson(splyAmt),
          tin: fromEJson(tin),
          bhfId: fromEJson(bhfId),
          dftPrc: fromEJson(dftPrc),
          addInfo: fromEJson(addInfo),
          isrcAplcbYn: fromEJson(isrcAplcbYn),
          useYn: fromEJson(useYn),
          regrId: fromEJson(regrId),
          regrNm: fromEJson(regrNm),
          modrId: fromEJson(modrId),
          modrNm: fromEJson(modrNm),
          rsdQty: fromEJson(rsdQty),
          lastTouched: fromEJson(lastTouched),
          supplyPrice: fromEJson(supplyPrice),
          retailPrice: fromEJson(retailPrice),
          action: fromEJson(action),
          spplrItemClsCd: fromEJson(spplrItemClsCd),
          spplrItemCd: fromEJson(spplrItemCd),
          spplrItemNm: fromEJson(spplrItemNm),
          ebmSynced: fromEJson(ebmSynced),
          taxType: fromEJson(taxType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Variant._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Variant, 'Variant', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('color', RealmPropertyType.string, optional: true),
      SchemaProperty('sku', RealmPropertyType.string, optional: true),
      SchemaProperty('productId', RealmPropertyType.int, optional: true),
      SchemaProperty('unit', RealmPropertyType.string, optional: true),
      SchemaProperty('productName', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('taxName', RealmPropertyType.string, optional: true),
      SchemaProperty('taxPercentage', RealmPropertyType.double),
      SchemaProperty('isTaxExempted', RealmPropertyType.bool),
      SchemaProperty('itemSeq', RealmPropertyType.int, optional: true),
      SchemaProperty('isrccCd', RealmPropertyType.string, optional: true),
      SchemaProperty('isrccNm', RealmPropertyType.string, optional: true),
      SchemaProperty('isrcRt', RealmPropertyType.int, optional: true),
      SchemaProperty('isrcAmt', RealmPropertyType.int, optional: true),
      SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('bcd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemStdNm', RealmPropertyType.string, optional: true),
      SchemaProperty('orgnNatCd', RealmPropertyType.string, optional: true),
      SchemaProperty('pkg', RealmPropertyType.string, optional: true),
      SchemaProperty('itemCd', RealmPropertyType.string, optional: true),
      SchemaProperty('pkgUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('qtyUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemNm', RealmPropertyType.string, optional: true),
      SchemaProperty('qty', RealmPropertyType.double),
      SchemaProperty('prc', RealmPropertyType.double),
      SchemaProperty('splyAmt', RealmPropertyType.double),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('dftPrc', RealmPropertyType.double, optional: true),
      SchemaProperty('addInfo', RealmPropertyType.string, optional: true),
      SchemaProperty('isrcAplcbYn', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('regrId', RealmPropertyType.string, optional: true),
      SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('modrId', RealmPropertyType.string, optional: true),
      SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('rsdQty', RealmPropertyType.double),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('supplyPrice', RealmPropertyType.double),
      SchemaProperty('retailPrice', RealmPropertyType.double),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('spplrItemClsCd', RealmPropertyType.string,
          optional: true),
      SchemaProperty('spplrItemCd', RealmPropertyType.string, optional: true),
      SchemaProperty('spplrItemNm', RealmPropertyType.string, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool),
      SchemaProperty('taxType', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class TransactionItem extends _TransactionItem
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  TransactionItem(
    ObjectId realmId, {
    int? id,
    String? name,
    int? transactionId,
    int? variantId,
    double qty = 0.0,
    double price = 0.0,
    double discount = 0.0,
    String? type,
    double remainingStock = 0.0,
    String? createdAt,
    String? updatedAt,
    bool isTaxExempted = false,
    bool isRefunded = false,
    bool? doneWithTransaction,
    bool? active,
    double dcRt = 0.0,
    double dcAmt = 0.0,
    double taxblAmt = 0.0,
    double taxAmt = 0.0,
    double totAmt = 0.0,
    int? itemSeq,
    String? isrccCd,
    String? isrccNm = "",
    int? isrcRt = 0,
    int? isrcAmt = 0,
    String? taxTyCd,
    String? bcd,
    String? itemClsCd,
    String? itemTyCd,
    String? itemStdNm,
    String? orgnNatCd,
    String? pkg,
    String? itemCd,
    String? pkgUnitCd = "CT",
    String? qtyUnitCd = "BX",
    String? itemNm,
    double prc = 0.0,
    double splyAmt = 0.0,
    int? tin,
    String? bhfId,
    double? dftPrc,
    String? addInfo,
    String? isrcAplcbYn,
    String? useYn,
    String? regrId,
    String? regrNm,
    String? modrId,
    String? modrNm,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
    int? branchId,
    bool ebmSynced = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<TransactionItem>({
        'qty': 0.0,
        'price': 0.0,
        'discount': 0.0,
        'remainingStock': 0.0,
        'isTaxExempted': false,
        'isRefunded': false,
        'dcRt': 0.0,
        'dcAmt': 0.0,
        'taxblAmt': 0.0,
        'taxAmt': 0.0,
        'totAmt': 0.0,
        'isrccNm': "",
        'isrcRt': 0,
        'isrcAmt': 0,
        'pkgUnitCd': "CT",
        'qtyUnitCd': "BX",
        'prc': 0.0,
        'splyAmt': 0.0,
        'ebmSynced': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'transactionId', transactionId);
    RealmObjectBase.set(this, 'variantId', variantId);
    RealmObjectBase.set(this, 'qty', qty);
    RealmObjectBase.set(this, 'price', price);
    RealmObjectBase.set(this, 'discount', discount);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'remainingStock', remainingStock);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'isTaxExempted', isTaxExempted);
    RealmObjectBase.set(this, 'isRefunded', isRefunded);
    RealmObjectBase.set(this, 'doneWithTransaction', doneWithTransaction);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'dcRt', dcRt);
    RealmObjectBase.set(this, 'dcAmt', dcAmt);
    RealmObjectBase.set(this, 'taxblAmt', taxblAmt);
    RealmObjectBase.set(this, 'taxAmt', taxAmt);
    RealmObjectBase.set(this, 'totAmt', totAmt);
    RealmObjectBase.set(this, 'itemSeq', itemSeq);
    RealmObjectBase.set(this, 'isrccCd', isrccCd);
    RealmObjectBase.set(this, 'isrccNm', isrccNm);
    RealmObjectBase.set(this, 'isrcRt', isrcRt);
    RealmObjectBase.set(this, 'isrcAmt', isrcAmt);
    RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
    RealmObjectBase.set(this, 'bcd', bcd);
    RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
    RealmObjectBase.set(this, 'itemTyCd', itemTyCd);
    RealmObjectBase.set(this, 'itemStdNm', itemStdNm);
    RealmObjectBase.set(this, 'orgnNatCd', orgnNatCd);
    RealmObjectBase.set(this, 'pkg', pkg);
    RealmObjectBase.set(this, 'itemCd', itemCd);
    RealmObjectBase.set(this, 'pkgUnitCd', pkgUnitCd);
    RealmObjectBase.set(this, 'qtyUnitCd', qtyUnitCd);
    RealmObjectBase.set(this, 'itemNm', itemNm);
    RealmObjectBase.set(this, 'prc', prc);
    RealmObjectBase.set(this, 'splyAmt', splyAmt);
    RealmObjectBase.set(this, 'tin', tin);
    RealmObjectBase.set(this, 'bhfId', bhfId);
    RealmObjectBase.set(this, 'dftPrc', dftPrc);
    RealmObjectBase.set(this, 'addInfo', addInfo);
    RealmObjectBase.set(this, 'isrcAplcbYn', isrcAplcbYn);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'regrId', regrId);
    RealmObjectBase.set(this, 'regrNm', regrNm);
    RealmObjectBase.set(this, 'modrId', modrId);
    RealmObjectBase.set(this, 'modrNm', modrNm);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
  }

  TransactionItem._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get transactionId =>
      RealmObjectBase.get<int>(this, 'transactionId') as int?;
  @override
  set transactionId(int? value) =>
      RealmObjectBase.set(this, 'transactionId', value);

  @override
  int? get variantId => RealmObjectBase.get<int>(this, 'variantId') as int?;
  @override
  set variantId(int? value) => RealmObjectBase.set(this, 'variantId', value);

  @override
  double get qty => RealmObjectBase.get<double>(this, 'qty') as double;
  @override
  set qty(double value) => RealmObjectBase.set(this, 'qty', value);

  @override
  double get price => RealmObjectBase.get<double>(this, 'price') as double;
  @override
  set price(double value) => RealmObjectBase.set(this, 'price', value);

  @override
  double get discount =>
      RealmObjectBase.get<double>(this, 'discount') as double;
  @override
  set discount(double value) => RealmObjectBase.set(this, 'discount', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  double get remainingStock =>
      RealmObjectBase.get<double>(this, 'remainingStock') as double;
  @override
  set remainingStock(double value) =>
      RealmObjectBase.set(this, 'remainingStock', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get updatedAt =>
      RealmObjectBase.get<String>(this, 'updatedAt') as String?;
  @override
  set updatedAt(String? value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  bool get isTaxExempted =>
      RealmObjectBase.get<bool>(this, 'isTaxExempted') as bool;
  @override
  set isTaxExempted(bool value) =>
      RealmObjectBase.set(this, 'isTaxExempted', value);

  @override
  bool get isRefunded => RealmObjectBase.get<bool>(this, 'isRefunded') as bool;
  @override
  set isRefunded(bool value) => RealmObjectBase.set(this, 'isRefunded', value);

  @override
  bool? get doneWithTransaction =>
      RealmObjectBase.get<bool>(this, 'doneWithTransaction') as bool?;
  @override
  set doneWithTransaction(bool? value) =>
      RealmObjectBase.set(this, 'doneWithTransaction', value);

  @override
  bool? get active => RealmObjectBase.get<bool>(this, 'active') as bool?;
  @override
  set active(bool? value) => RealmObjectBase.set(this, 'active', value);

  @override
  double get dcRt => RealmObjectBase.get<double>(this, 'dcRt') as double;
  @override
  set dcRt(double value) => RealmObjectBase.set(this, 'dcRt', value);

  @override
  double get dcAmt => RealmObjectBase.get<double>(this, 'dcAmt') as double;
  @override
  set dcAmt(double value) => RealmObjectBase.set(this, 'dcAmt', value);

  @override
  double get taxblAmt =>
      RealmObjectBase.get<double>(this, 'taxblAmt') as double;
  @override
  set taxblAmt(double value) => RealmObjectBase.set(this, 'taxblAmt', value);

  @override
  double get taxAmt => RealmObjectBase.get<double>(this, 'taxAmt') as double;
  @override
  set taxAmt(double value) => RealmObjectBase.set(this, 'taxAmt', value);

  @override
  double get totAmt => RealmObjectBase.get<double>(this, 'totAmt') as double;
  @override
  set totAmt(double value) => RealmObjectBase.set(this, 'totAmt', value);

  @override
  int? get itemSeq => RealmObjectBase.get<int>(this, 'itemSeq') as int?;
  @override
  set itemSeq(int? value) => RealmObjectBase.set(this, 'itemSeq', value);

  @override
  String? get isrccCd =>
      RealmObjectBase.get<String>(this, 'isrccCd') as String?;
  @override
  set isrccCd(String? value) => RealmObjectBase.set(this, 'isrccCd', value);

  @override
  String? get isrccNm =>
      RealmObjectBase.get<String>(this, 'isrccNm') as String?;
  @override
  set isrccNm(String? value) => RealmObjectBase.set(this, 'isrccNm', value);

  @override
  int? get isrcRt => RealmObjectBase.get<int>(this, 'isrcRt') as int?;
  @override
  set isrcRt(int? value) => RealmObjectBase.set(this, 'isrcRt', value);

  @override
  int? get isrcAmt => RealmObjectBase.get<int>(this, 'isrcAmt') as int?;
  @override
  set isrcAmt(int? value) => RealmObjectBase.set(this, 'isrcAmt', value);

  @override
  String? get taxTyCd =>
      RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
  @override
  set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

  @override
  String? get bcd => RealmObjectBase.get<String>(this, 'bcd') as String?;
  @override
  set bcd(String? value) => RealmObjectBase.set(this, 'bcd', value);

  @override
  String? get itemClsCd =>
      RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
  @override
  set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

  @override
  String? get itemTyCd =>
      RealmObjectBase.get<String>(this, 'itemTyCd') as String?;
  @override
  set itemTyCd(String? value) => RealmObjectBase.set(this, 'itemTyCd', value);

  @override
  String? get itemStdNm =>
      RealmObjectBase.get<String>(this, 'itemStdNm') as String?;
  @override
  set itemStdNm(String? value) => RealmObjectBase.set(this, 'itemStdNm', value);

  @override
  String? get orgnNatCd =>
      RealmObjectBase.get<String>(this, 'orgnNatCd') as String?;
  @override
  set orgnNatCd(String? value) => RealmObjectBase.set(this, 'orgnNatCd', value);

  @override
  String? get pkg => RealmObjectBase.get<String>(this, 'pkg') as String?;
  @override
  set pkg(String? value) => RealmObjectBase.set(this, 'pkg', value);

  @override
  String? get itemCd => RealmObjectBase.get<String>(this, 'itemCd') as String?;
  @override
  set itemCd(String? value) => RealmObjectBase.set(this, 'itemCd', value);

  @override
  String? get pkgUnitCd =>
      RealmObjectBase.get<String>(this, 'pkgUnitCd') as String?;
  @override
  set pkgUnitCd(String? value) => RealmObjectBase.set(this, 'pkgUnitCd', value);

  @override
  String? get qtyUnitCd =>
      RealmObjectBase.get<String>(this, 'qtyUnitCd') as String?;
  @override
  set qtyUnitCd(String? value) => RealmObjectBase.set(this, 'qtyUnitCd', value);

  @override
  String? get itemNm => RealmObjectBase.get<String>(this, 'itemNm') as String?;
  @override
  set itemNm(String? value) => RealmObjectBase.set(this, 'itemNm', value);

  @override
  double get prc => RealmObjectBase.get<double>(this, 'prc') as double;
  @override
  set prc(double value) => RealmObjectBase.set(this, 'prc', value);

  @override
  double get splyAmt => RealmObjectBase.get<double>(this, 'splyAmt') as double;
  @override
  set splyAmt(double value) => RealmObjectBase.set(this, 'splyAmt', value);

  @override
  int? get tin => RealmObjectBase.get<int>(this, 'tin') as int?;
  @override
  set tin(int? value) => RealmObjectBase.set(this, 'tin', value);

  @override
  String? get bhfId => RealmObjectBase.get<String>(this, 'bhfId') as String?;
  @override
  set bhfId(String? value) => RealmObjectBase.set(this, 'bhfId', value);

  @override
  double? get dftPrc => RealmObjectBase.get<double>(this, 'dftPrc') as double?;
  @override
  set dftPrc(double? value) => RealmObjectBase.set(this, 'dftPrc', value);

  @override
  String? get addInfo =>
      RealmObjectBase.get<String>(this, 'addInfo') as String?;
  @override
  set addInfo(String? value) => RealmObjectBase.set(this, 'addInfo', value);

  @override
  String? get isrcAplcbYn =>
      RealmObjectBase.get<String>(this, 'isrcAplcbYn') as String?;
  @override
  set isrcAplcbYn(String? value) =>
      RealmObjectBase.set(this, 'isrcAplcbYn', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  String? get regrId => RealmObjectBase.get<String>(this, 'regrId') as String?;
  @override
  set regrId(String? value) => RealmObjectBase.set(this, 'regrId', value);

  @override
  String? get regrNm => RealmObjectBase.get<String>(this, 'regrNm') as String?;
  @override
  set regrNm(String? value) => RealmObjectBase.set(this, 'regrNm', value);

  @override
  String? get modrId => RealmObjectBase.get<String>(this, 'modrId') as String?;
  @override
  set modrId(String? value) => RealmObjectBase.set(this, 'modrId', value);

  @override
  String? get modrNm => RealmObjectBase.get<String>(this, 'modrNm') as String?;
  @override
  set modrNm(String? value) => RealmObjectBase.set(this, 'modrNm', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
  @override
  set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  Stream<RealmObjectChanges<TransactionItem>> get changes =>
      RealmObjectBase.getChanges<TransactionItem>(this);

  @override
  Stream<RealmObjectChanges<TransactionItem>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<TransactionItem>(this, keyPaths);

  @override
  TransactionItem freeze() =>
      RealmObjectBase.freezeObject<TransactionItem>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'transactionId': transactionId.toEJson(),
      'variantId': variantId.toEJson(),
      'qty': qty.toEJson(),
      'price': price.toEJson(),
      'discount': discount.toEJson(),
      'type': type.toEJson(),
      'remainingStock': remainingStock.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'isTaxExempted': isTaxExempted.toEJson(),
      'isRefunded': isRefunded.toEJson(),
      'doneWithTransaction': doneWithTransaction.toEJson(),
      'active': active.toEJson(),
      'dcRt': dcRt.toEJson(),
      'dcAmt': dcAmt.toEJson(),
      'taxblAmt': taxblAmt.toEJson(),
      'taxAmt': taxAmt.toEJson(),
      'totAmt': totAmt.toEJson(),
      'itemSeq': itemSeq.toEJson(),
      'isrccCd': isrccCd.toEJson(),
      'isrccNm': isrccNm.toEJson(),
      'isrcRt': isrcRt.toEJson(),
      'isrcAmt': isrcAmt.toEJson(),
      'taxTyCd': taxTyCd.toEJson(),
      'bcd': bcd.toEJson(),
      'itemClsCd': itemClsCd.toEJson(),
      'itemTyCd': itemTyCd.toEJson(),
      'itemStdNm': itemStdNm.toEJson(),
      'orgnNatCd': orgnNatCd.toEJson(),
      'pkg': pkg.toEJson(),
      'itemCd': itemCd.toEJson(),
      'pkgUnitCd': pkgUnitCd.toEJson(),
      'qtyUnitCd': qtyUnitCd.toEJson(),
      'itemNm': itemNm.toEJson(),
      'prc': prc.toEJson(),
      'splyAmt': splyAmt.toEJson(),
      'tin': tin.toEJson(),
      'bhfId': bhfId.toEJson(),
      'dftPrc': dftPrc.toEJson(),
      'addInfo': addInfo.toEJson(),
      'isrcAplcbYn': isrcAplcbYn.toEJson(),
      'useYn': useYn.toEJson(),
      'regrId': regrId.toEJson(),
      'regrNm': regrNm.toEJson(),
      'modrId': modrId.toEJson(),
      'modrNm': modrNm.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'action': action.toEJson(),
      'branchId': branchId.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
    };
  }

  static EJsonValue _toEJson(TransactionItem value) => value.toEJson();
  static TransactionItem _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'transactionId': EJsonValue transactionId,
        'variantId': EJsonValue variantId,
        'qty': EJsonValue qty,
        'price': EJsonValue price,
        'discount': EJsonValue discount,
        'type': EJsonValue type,
        'remainingStock': EJsonValue remainingStock,
        'createdAt': EJsonValue createdAt,
        'updatedAt': EJsonValue updatedAt,
        'isTaxExempted': EJsonValue isTaxExempted,
        'isRefunded': EJsonValue isRefunded,
        'doneWithTransaction': EJsonValue doneWithTransaction,
        'active': EJsonValue active,
        'dcRt': EJsonValue dcRt,
        'dcAmt': EJsonValue dcAmt,
        'taxblAmt': EJsonValue taxblAmt,
        'taxAmt': EJsonValue taxAmt,
        'totAmt': EJsonValue totAmt,
        'itemSeq': EJsonValue itemSeq,
        'isrccCd': EJsonValue isrccCd,
        'isrccNm': EJsonValue isrccNm,
        'isrcRt': EJsonValue isrcRt,
        'isrcAmt': EJsonValue isrcAmt,
        'taxTyCd': EJsonValue taxTyCd,
        'bcd': EJsonValue bcd,
        'itemClsCd': EJsonValue itemClsCd,
        'itemTyCd': EJsonValue itemTyCd,
        'itemStdNm': EJsonValue itemStdNm,
        'orgnNatCd': EJsonValue orgnNatCd,
        'pkg': EJsonValue pkg,
        'itemCd': EJsonValue itemCd,
        'pkgUnitCd': EJsonValue pkgUnitCd,
        'qtyUnitCd': EJsonValue qtyUnitCd,
        'itemNm': EJsonValue itemNm,
        'prc': EJsonValue prc,
        'splyAmt': EJsonValue splyAmt,
        'tin': EJsonValue tin,
        'bhfId': EJsonValue bhfId,
        'dftPrc': EJsonValue dftPrc,
        'addInfo': EJsonValue addInfo,
        'isrcAplcbYn': EJsonValue isrcAplcbYn,
        'useYn': EJsonValue useYn,
        'regrId': EJsonValue regrId,
        'regrNm': EJsonValue regrNm,
        'modrId': EJsonValue modrId,
        'modrNm': EJsonValue modrNm,
        'lastTouched': EJsonValue lastTouched,
        'deletedAt': EJsonValue deletedAt,
        'action': EJsonValue action,
        'branchId': EJsonValue branchId,
        'ebmSynced': EJsonValue ebmSynced,
      } =>
        TransactionItem(
          fromEJson(realmId),
          id: fromEJson(id),
          name: fromEJson(name),
          transactionId: fromEJson(transactionId),
          variantId: fromEJson(variantId),
          qty: fromEJson(qty),
          price: fromEJson(price),
          discount: fromEJson(discount),
          type: fromEJson(type),
          remainingStock: fromEJson(remainingStock),
          createdAt: fromEJson(createdAt),
          updatedAt: fromEJson(updatedAt),
          isTaxExempted: fromEJson(isTaxExempted),
          isRefunded: fromEJson(isRefunded),
          doneWithTransaction: fromEJson(doneWithTransaction),
          active: fromEJson(active),
          dcRt: fromEJson(dcRt),
          dcAmt: fromEJson(dcAmt),
          taxblAmt: fromEJson(taxblAmt),
          taxAmt: fromEJson(taxAmt),
          totAmt: fromEJson(totAmt),
          itemSeq: fromEJson(itemSeq),
          isrccCd: fromEJson(isrccCd),
          isrccNm: fromEJson(isrccNm),
          isrcRt: fromEJson(isrcRt),
          isrcAmt: fromEJson(isrcAmt),
          taxTyCd: fromEJson(taxTyCd),
          bcd: fromEJson(bcd),
          itemClsCd: fromEJson(itemClsCd),
          itemTyCd: fromEJson(itemTyCd),
          itemStdNm: fromEJson(itemStdNm),
          orgnNatCd: fromEJson(orgnNatCd),
          pkg: fromEJson(pkg),
          itemCd: fromEJson(itemCd),
          pkgUnitCd: fromEJson(pkgUnitCd),
          qtyUnitCd: fromEJson(qtyUnitCd),
          itemNm: fromEJson(itemNm),
          prc: fromEJson(prc),
          splyAmt: fromEJson(splyAmt),
          tin: fromEJson(tin),
          bhfId: fromEJson(bhfId),
          dftPrc: fromEJson(dftPrc),
          addInfo: fromEJson(addInfo),
          isrcAplcbYn: fromEJson(isrcAplcbYn),
          useYn: fromEJson(useYn),
          regrId: fromEJson(regrId),
          regrNm: fromEJson(regrNm),
          modrId: fromEJson(modrId),
          modrNm: fromEJson(modrNm),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
          action: fromEJson(action),
          branchId: fromEJson(branchId),
          ebmSynced: fromEJson(ebmSynced),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(TransactionItem._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, TransactionItem, 'TransactionItem', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('transactionId', RealmPropertyType.int, optional: true),
      SchemaProperty('variantId', RealmPropertyType.int, optional: true),
      SchemaProperty('qty', RealmPropertyType.double),
      SchemaProperty('price', RealmPropertyType.double),
      SchemaProperty('discount', RealmPropertyType.double),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('remainingStock', RealmPropertyType.double),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.string, optional: true),
      SchemaProperty('isTaxExempted', RealmPropertyType.bool),
      SchemaProperty('isRefunded', RealmPropertyType.bool),
      SchemaProperty('doneWithTransaction', RealmPropertyType.bool,
          optional: true),
      SchemaProperty('active', RealmPropertyType.bool, optional: true),
      SchemaProperty('dcRt', RealmPropertyType.double),
      SchemaProperty('dcAmt', RealmPropertyType.double),
      SchemaProperty('taxblAmt', RealmPropertyType.double),
      SchemaProperty('taxAmt', RealmPropertyType.double),
      SchemaProperty('totAmt', RealmPropertyType.double),
      SchemaProperty('itemSeq', RealmPropertyType.int, optional: true),
      SchemaProperty('isrccCd', RealmPropertyType.string, optional: true),
      SchemaProperty('isrccNm', RealmPropertyType.string, optional: true),
      SchemaProperty('isrcRt', RealmPropertyType.int, optional: true),
      SchemaProperty('isrcAmt', RealmPropertyType.int, optional: true),
      SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('bcd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemStdNm', RealmPropertyType.string, optional: true),
      SchemaProperty('orgnNatCd', RealmPropertyType.string, optional: true),
      SchemaProperty('pkg', RealmPropertyType.string, optional: true),
      SchemaProperty('itemCd', RealmPropertyType.string, optional: true),
      SchemaProperty('pkgUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('qtyUnitCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemNm', RealmPropertyType.string, optional: true),
      SchemaProperty('prc', RealmPropertyType.double),
      SchemaProperty('splyAmt', RealmPropertyType.double),
      SchemaProperty('tin', RealmPropertyType.int, optional: true),
      SchemaProperty('bhfId', RealmPropertyType.string, optional: true),
      SchemaProperty('dftPrc', RealmPropertyType.double, optional: true),
      SchemaProperty('addInfo', RealmPropertyType.string, optional: true),
      SchemaProperty('isrcAplcbYn', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('regrId', RealmPropertyType.string, optional: true),
      SchemaProperty('regrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('modrId', RealmPropertyType.string, optional: true),
      SchemaProperty('modrNm', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ITransaction extends _ITransaction
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  ITransaction(
    ObjectId realmId, {
    int? id,
    String? reference,
    String? categoryId,
    String? transactionNumber,
    int? branchId,
    String? status,
    String? transactionType,
    double subTotal = 0.0,
    String? paymentType,
    double cashReceived = 0.0,
    double customerChangeDue = 0.0,
    String? createdAt,
    String? receiptType,
    String? updatedAt,
    int? customerId,
    String? customerType,
    String? note,
    DateTime? lastTouched,
    String? action,
    String? ticketName,
    DateTime? deletedAt,
    int? supplierId,
    bool ebmSynced = false,
    bool isIncome = false,
    bool isExpense = false,
    bool isRefunded = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<ITransaction>({
        'subTotal': 0.0,
        'cashReceived': 0.0,
        'customerChangeDue': 0.0,
        'ebmSynced': false,
        'isIncome': false,
        'isExpense': false,
        'isRefunded': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'reference', reference);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'transactionNumber', transactionNumber);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'transactionType', transactionType);
    RealmObjectBase.set(this, 'subTotal', subTotal);
    RealmObjectBase.set(this, 'paymentType', paymentType);
    RealmObjectBase.set(this, 'cashReceived', cashReceived);
    RealmObjectBase.set(this, 'customerChangeDue', customerChangeDue);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'receiptType', receiptType);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'customerId', customerId);
    RealmObjectBase.set(this, 'customerType', customerType);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'ticketName', ticketName);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'supplierId', supplierId);
    RealmObjectBase.set(this, 'ebmSynced', ebmSynced);
    RealmObjectBase.set(this, 'isIncome', isIncome);
    RealmObjectBase.set(this, 'isExpense', isExpense);
    RealmObjectBase.set(this, 'isRefunded', isRefunded);
  }

  ITransaction._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get reference =>
      RealmObjectBase.get<String>(this, 'reference') as String?;
  @override
  set reference(String? value) => RealmObjectBase.set(this, 'reference', value);

  @override
  String? get categoryId =>
      RealmObjectBase.get<String>(this, 'categoryId') as String?;
  @override
  set categoryId(String? value) =>
      RealmObjectBase.set(this, 'categoryId', value);

  @override
  String? get transactionNumber =>
      RealmObjectBase.get<String>(this, 'transactionNumber') as String?;
  @override
  set transactionNumber(String? value) =>
      RealmObjectBase.set(this, 'transactionNumber', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get status => RealmObjectBase.get<String>(this, 'status') as String?;
  @override
  set status(String? value) => RealmObjectBase.set(this, 'status', value);

  @override
  String? get transactionType =>
      RealmObjectBase.get<String>(this, 'transactionType') as String?;
  @override
  set transactionType(String? value) =>
      RealmObjectBase.set(this, 'transactionType', value);

  @override
  double get subTotal =>
      RealmObjectBase.get<double>(this, 'subTotal') as double;
  @override
  set subTotal(double value) => RealmObjectBase.set(this, 'subTotal', value);

  @override
  String? get paymentType =>
      RealmObjectBase.get<String>(this, 'paymentType') as String?;
  @override
  set paymentType(String? value) =>
      RealmObjectBase.set(this, 'paymentType', value);

  @override
  double get cashReceived =>
      RealmObjectBase.get<double>(this, 'cashReceived') as double;
  @override
  set cashReceived(double value) =>
      RealmObjectBase.set(this, 'cashReceived', value);

  @override
  double get customerChangeDue =>
      RealmObjectBase.get<double>(this, 'customerChangeDue') as double;
  @override
  set customerChangeDue(double value) =>
      RealmObjectBase.set(this, 'customerChangeDue', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get receiptType =>
      RealmObjectBase.get<String>(this, 'receiptType') as String?;
  @override
  set receiptType(String? value) =>
      RealmObjectBase.set(this, 'receiptType', value);

  @override
  String? get updatedAt =>
      RealmObjectBase.get<String>(this, 'updatedAt') as String?;
  @override
  set updatedAt(String? value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  int? get customerId => RealmObjectBase.get<int>(this, 'customerId') as int?;
  @override
  set customerId(int? value) => RealmObjectBase.set(this, 'customerId', value);

  @override
  String? get customerType =>
      RealmObjectBase.get<String>(this, 'customerType') as String?;
  @override
  set customerType(String? value) =>
      RealmObjectBase.set(this, 'customerType', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  String? get ticketName =>
      RealmObjectBase.get<String>(this, 'ticketName') as String?;
  @override
  set ticketName(String? value) =>
      RealmObjectBase.set(this, 'ticketName', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  int? get supplierId => RealmObjectBase.get<int>(this, 'supplierId') as int?;
  @override
  set supplierId(int? value) => RealmObjectBase.set(this, 'supplierId', value);

  @override
  bool get ebmSynced => RealmObjectBase.get<bool>(this, 'ebmSynced') as bool;
  @override
  set ebmSynced(bool value) => RealmObjectBase.set(this, 'ebmSynced', value);

  @override
  bool get isIncome => RealmObjectBase.get<bool>(this, 'isIncome') as bool;
  @override
  set isIncome(bool value) => RealmObjectBase.set(this, 'isIncome', value);

  @override
  bool get isExpense => RealmObjectBase.get<bool>(this, 'isExpense') as bool;
  @override
  set isExpense(bool value) => RealmObjectBase.set(this, 'isExpense', value);

  @override
  bool get isRefunded => RealmObjectBase.get<bool>(this, 'isRefunded') as bool;
  @override
  set isRefunded(bool value) => RealmObjectBase.set(this, 'isRefunded', value);

  @override
  Stream<RealmObjectChanges<ITransaction>> get changes =>
      RealmObjectBase.getChanges<ITransaction>(this);

  @override
  Stream<RealmObjectChanges<ITransaction>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ITransaction>(this, keyPaths);

  @override
  ITransaction freeze() => RealmObjectBase.freezeObject<ITransaction>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'reference': reference.toEJson(),
      'categoryId': categoryId.toEJson(),
      'transactionNumber': transactionNumber.toEJson(),
      'branchId': branchId.toEJson(),
      'status': status.toEJson(),
      'transactionType': transactionType.toEJson(),
      'subTotal': subTotal.toEJson(),
      'paymentType': paymentType.toEJson(),
      'cashReceived': cashReceived.toEJson(),
      'customerChangeDue': customerChangeDue.toEJson(),
      'createdAt': createdAt.toEJson(),
      'receiptType': receiptType.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'customerId': customerId.toEJson(),
      'customerType': customerType.toEJson(),
      'note': note.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'ticketName': ticketName.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'supplierId': supplierId.toEJson(),
      'ebmSynced': ebmSynced.toEJson(),
      'isIncome': isIncome.toEJson(),
      'isExpense': isExpense.toEJson(),
      'isRefunded': isRefunded.toEJson(),
    };
  }

  static EJsonValue _toEJson(ITransaction value) => value.toEJson();
  static ITransaction _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'reference': EJsonValue reference,
        'categoryId': EJsonValue categoryId,
        'transactionNumber': EJsonValue transactionNumber,
        'branchId': EJsonValue branchId,
        'status': EJsonValue status,
        'transactionType': EJsonValue transactionType,
        'subTotal': EJsonValue subTotal,
        'paymentType': EJsonValue paymentType,
        'cashReceived': EJsonValue cashReceived,
        'customerChangeDue': EJsonValue customerChangeDue,
        'createdAt': EJsonValue createdAt,
        'receiptType': EJsonValue receiptType,
        'updatedAt': EJsonValue updatedAt,
        'customerId': EJsonValue customerId,
        'customerType': EJsonValue customerType,
        'note': EJsonValue note,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'ticketName': EJsonValue ticketName,
        'deletedAt': EJsonValue deletedAt,
        'supplierId': EJsonValue supplierId,
        'ebmSynced': EJsonValue ebmSynced,
        'isIncome': EJsonValue isIncome,
        'isExpense': EJsonValue isExpense,
        'isRefunded': EJsonValue isRefunded,
      } =>
        ITransaction(
          fromEJson(realmId),
          id: fromEJson(id),
          reference: fromEJson(reference),
          categoryId: fromEJson(categoryId),
          transactionNumber: fromEJson(transactionNumber),
          branchId: fromEJson(branchId),
          status: fromEJson(status),
          transactionType: fromEJson(transactionType),
          subTotal: fromEJson(subTotal),
          paymentType: fromEJson(paymentType),
          cashReceived: fromEJson(cashReceived),
          customerChangeDue: fromEJson(customerChangeDue),
          createdAt: fromEJson(createdAt),
          receiptType: fromEJson(receiptType),
          updatedAt: fromEJson(updatedAt),
          customerId: fromEJson(customerId),
          customerType: fromEJson(customerType),
          note: fromEJson(note),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          ticketName: fromEJson(ticketName),
          deletedAt: fromEJson(deletedAt),
          supplierId: fromEJson(supplierId),
          ebmSynced: fromEJson(ebmSynced),
          isIncome: fromEJson(isIncome),
          isExpense: fromEJson(isExpense),
          isRefunded: fromEJson(isRefunded),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ITransaction._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, ITransaction, 'ITransaction', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('reference', RealmPropertyType.string, optional: true),
      SchemaProperty('categoryId', RealmPropertyType.string, optional: true),
      SchemaProperty('transactionNumber', RealmPropertyType.string,
          optional: true),
      SchemaProperty('branchId', RealmPropertyType.int,
          optional: true, indexType: RealmIndexType.regular),
      SchemaProperty('status', RealmPropertyType.string,
          optional: true, indexType: RealmIndexType.regular),
      SchemaProperty('transactionType', RealmPropertyType.string,
          optional: true, indexType: RealmIndexType.regular),
      SchemaProperty('subTotal', RealmPropertyType.double),
      SchemaProperty('paymentType', RealmPropertyType.string, optional: true),
      SchemaProperty('cashReceived', RealmPropertyType.double),
      SchemaProperty('customerChangeDue', RealmPropertyType.double),
      SchemaProperty('createdAt', RealmPropertyType.string,
          optional: true, indexType: RealmIndexType.regular),
      SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.string, optional: true),
      SchemaProperty('customerId', RealmPropertyType.int,
          optional: true, indexType: RealmIndexType.regular),
      SchemaProperty('customerType', RealmPropertyType.string, optional: true),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('ticketName', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('supplierId', RealmPropertyType.int, optional: true),
      SchemaProperty('ebmSynced', RealmPropertyType.bool),
      SchemaProperty('isIncome', RealmPropertyType.bool),
      SchemaProperty('isExpense', RealmPropertyType.bool),
      SchemaProperty('isRefunded', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class IUnit extends _IUnit with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  IUnit(
    ObjectId realmId, {
    int? id,
    int? branchId,
    String? name,
    String? value,
    bool active = false,
    DateTime? lastTouched,
    String? action,
    String? createdAt,
    DateTime? deletedAt,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<IUnit>({
        'active': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'active', active);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  IUnit._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get value => RealmObjectBase.get<String>(this, 'value') as String?;
  @override
  set value(String? value) => RealmObjectBase.set(this, 'value', value);

  @override
  bool get active => RealmObjectBase.get<bool>(this, 'active') as bool;
  @override
  set active(bool value) => RealmObjectBase.set(this, 'active', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String? get action => RealmObjectBase.get<String>(this, 'action') as String?;
  @override
  set action(String? value) => RealmObjectBase.set(this, 'action', value);

  @override
  String? get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String?;
  @override
  set createdAt(String? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<IUnit>> get changes =>
      RealmObjectBase.getChanges<IUnit>(this);

  @override
  Stream<RealmObjectChanges<IUnit>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<IUnit>(this, keyPaths);

  @override
  IUnit freeze() => RealmObjectBase.freezeObject<IUnit>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'branchId': branchId.toEJson(),
      'name': name.toEJson(),
      'value': value.toEJson(),
      'active': active.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'action': action.toEJson(),
      'createdAt': createdAt.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(IUnit value) => value.toEJson();
  static IUnit _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'branchId': EJsonValue branchId,
        'name': EJsonValue name,
        'value': EJsonValue value,
        'active': EJsonValue active,
        'lastTouched': EJsonValue lastTouched,
        'action': EJsonValue action,
        'createdAt': EJsonValue createdAt,
        'deletedAt': EJsonValue deletedAt,
      } =>
        IUnit(
          fromEJson(realmId),
          id: fromEJson(id),
          branchId: fromEJson(branchId),
          name: fromEJson(name),
          value: fromEJson(value),
          active: fromEJson(active),
          lastTouched: fromEJson(lastTouched),
          action: fromEJson(action),
          createdAt: fromEJson(createdAt),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(IUnit._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, IUnit, 'IUnit', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('value', RealmPropertyType.string, optional: true),
      SchemaProperty('active', RealmPropertyType.bool),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Voucher extends _Voucher with RealmEntity, RealmObjectBase, RealmObject {
  Voucher(
    ObjectId realmId, {
    int? id,
    int? value,
    int? interval,
    bool? used,
    int? createdAt,
    int? usedAt,
    String? descriptor,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'interval', interval);
    RealmObjectBase.set(this, 'used', used);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'usedAt', usedAt);
    RealmObjectBase.set(this, 'descriptor', descriptor);
  }

  Voucher._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get value => RealmObjectBase.get<int>(this, 'value') as int?;
  @override
  set value(int? value) => RealmObjectBase.set(this, 'value', value);

  @override
  int? get interval => RealmObjectBase.get<int>(this, 'interval') as int?;
  @override
  set interval(int? value) => RealmObjectBase.set(this, 'interval', value);

  @override
  bool? get used => RealmObjectBase.get<bool>(this, 'used') as bool?;
  @override
  set used(bool? value) => RealmObjectBase.set(this, 'used', value);

  @override
  int? get createdAt => RealmObjectBase.get<int>(this, 'createdAt') as int?;
  @override
  set createdAt(int? value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  int? get usedAt => RealmObjectBase.get<int>(this, 'usedAt') as int?;
  @override
  set usedAt(int? value) => RealmObjectBase.set(this, 'usedAt', value);

  @override
  String? get descriptor =>
      RealmObjectBase.get<String>(this, 'descriptor') as String?;
  @override
  set descriptor(String? value) =>
      RealmObjectBase.set(this, 'descriptor', value);

  @override
  Stream<RealmObjectChanges<Voucher>> get changes =>
      RealmObjectBase.getChanges<Voucher>(this);

  @override
  Stream<RealmObjectChanges<Voucher>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Voucher>(this, keyPaths);

  @override
  Voucher freeze() => RealmObjectBase.freezeObject<Voucher>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'value': value.toEJson(),
      'interval': interval.toEJson(),
      'used': used.toEJson(),
      'createdAt': createdAt.toEJson(),
      'usedAt': usedAt.toEJson(),
      'descriptor': descriptor.toEJson(),
    };
  }

  static EJsonValue _toEJson(Voucher value) => value.toEJson();
  static Voucher _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'value': EJsonValue value,
        'interval': EJsonValue interval,
        'used': EJsonValue used,
        'createdAt': EJsonValue createdAt,
        'usedAt': EJsonValue usedAt,
        'descriptor': EJsonValue descriptor,
      } =>
        Voucher(
          fromEJson(realmId),
          id: fromEJson(id),
          value: fromEJson(value),
          interval: fromEJson(interval),
          used: fromEJson(used),
          createdAt: fromEJson(createdAt),
          usedAt: fromEJson(usedAt),
          descriptor: fromEJson(descriptor),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Voucher._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Voucher, 'Voucher', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('value', RealmPropertyType.int, optional: true),
      SchemaProperty('interval', RealmPropertyType.int, optional: true),
      SchemaProperty('used', RealmPropertyType.bool, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.int, optional: true),
      SchemaProperty('usedAt', RealmPropertyType.int, optional: true),
      SchemaProperty('descriptor', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Tenant extends _Tenant with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Tenant(
    ObjectId realmId, {
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    bool nfcEnabled = false,
    int? businessId,
    int? userId,
    String? imageUrl,
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? pin,
    bool? sessionActive,
    bool? isDefault,
    bool isLongPressed = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Tenant>({
        'nfcEnabled': false,
        'isLongPressed': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'nfcEnabled', nfcEnabled);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'pin', pin);
    RealmObjectBase.set(this, 'sessionActive', sessionActive);
    RealmObjectBase.set(this, 'isDefault', isDefault);
    RealmObjectBase.set(this, 'isLongPressed', isLongPressed);
  }

  Tenant._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  String? get email => RealmObjectBase.get<String>(this, 'email') as String?;
  @override
  set email(String? value) => RealmObjectBase.set(this, 'email', value);

  @override
  bool get nfcEnabled => RealmObjectBase.get<bool>(this, 'nfcEnabled') as bool;
  @override
  set nfcEnabled(bool value) => RealmObjectBase.set(this, 'nfcEnabled', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;
  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  int? get pin => RealmObjectBase.get<int>(this, 'pin') as int?;
  @override
  set pin(int? value) => RealmObjectBase.set(this, 'pin', value);

  @override
  bool? get sessionActive =>
      RealmObjectBase.get<bool>(this, 'sessionActive') as bool?;
  @override
  set sessionActive(bool? value) =>
      RealmObjectBase.set(this, 'sessionActive', value);

  @override
  bool? get isDefault => RealmObjectBase.get<bool>(this, 'isDefault') as bool?;
  @override
  set isDefault(bool? value) => RealmObjectBase.set(this, 'isDefault', value);

  @override
  bool get isLongPressed =>
      RealmObjectBase.get<bool>(this, 'isLongPressed') as bool;
  @override
  set isLongPressed(bool value) =>
      RealmObjectBase.set(this, 'isLongPressed', value);

  @override
  Stream<RealmObjectChanges<Tenant>> get changes =>
      RealmObjectBase.getChanges<Tenant>(this);

  @override
  Stream<RealmObjectChanges<Tenant>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Tenant>(this, keyPaths);

  @override
  Tenant freeze() => RealmObjectBase.freezeObject<Tenant>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'phoneNumber': phoneNumber.toEJson(),
      'email': email.toEJson(),
      'nfcEnabled': nfcEnabled.toEJson(),
      'businessId': businessId.toEJson(),
      'userId': userId.toEJson(),
      'imageUrl': imageUrl.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'deletedAt': deletedAt.toEJson(),
      'pin': pin.toEJson(),
      'sessionActive': sessionActive.toEJson(),
      'isDefault': isDefault.toEJson(),
      'isLongPressed': isLongPressed.toEJson(),
    };
  }

  static EJsonValue _toEJson(Tenant value) => value.toEJson();
  static Tenant _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'phoneNumber': EJsonValue phoneNumber,
        'email': EJsonValue email,
        'nfcEnabled': EJsonValue nfcEnabled,
        'businessId': EJsonValue businessId,
        'userId': EJsonValue userId,
        'imageUrl': EJsonValue imageUrl,
        'lastTouched': EJsonValue lastTouched,
        'deletedAt': EJsonValue deletedAt,
        'pin': EJsonValue pin,
        'sessionActive': EJsonValue sessionActive,
        'isDefault': EJsonValue isDefault,
        'isLongPressed': EJsonValue isLongPressed,
      } =>
        Tenant(
          fromEJson(realmId),
          id: fromEJson(id),
          name: fromEJson(name),
          phoneNumber: fromEJson(phoneNumber),
          email: fromEJson(email),
          nfcEnabled: fromEJson(nfcEnabled),
          businessId: fromEJson(businessId),
          userId: fromEJson(userId),
          imageUrl: fromEJson(imageUrl),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
          pin: fromEJson(pin),
          sessionActive: fromEJson(sessionActive),
          isDefault: fromEJson(isDefault),
          isLongPressed: fromEJson(isLongPressed),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Tenant._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Tenant, 'Tenant', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('email', RealmPropertyType.string, optional: true),
      SchemaProperty('nfcEnabled', RealmPropertyType.bool),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('pin', RealmPropertyType.int, optional: true),
      SchemaProperty('sessionActive', RealmPropertyType.bool, optional: true),
      SchemaProperty('isDefault', RealmPropertyType.bool, optional: true),
      SchemaProperty('isLongPressed', RealmPropertyType.bool),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Pin extends _Pin with RealmEntity, RealmObjectBase, RealmObject {
  Pin(
    ObjectId? realmId, {
    int? id,
    String? userId,
    String? phoneNumber,
    int? pin,
    int? branchId,
    int? businessId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'phoneNumber', phoneNumber);
    RealmObjectBase.set(this, 'pin', pin);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'businessId', businessId);
  }

  Pin._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId? get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get userId => RealmObjectBase.get<String>(this, 'userId') as String?;
  @override
  set userId(String? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String? get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phoneNumber') as String?;
  @override
  set phoneNumber(String? value) =>
      RealmObjectBase.set(this, 'phoneNumber', value);

  @override
  int? get pin => RealmObjectBase.get<int>(this, 'pin') as int?;
  @override
  set pin(int? value) => RealmObjectBase.set(this, 'pin', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  Stream<RealmObjectChanges<Pin>> get changes =>
      RealmObjectBase.getChanges<Pin>(this);

  @override
  Stream<RealmObjectChanges<Pin>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Pin>(this, keyPaths);

  @override
  Pin freeze() => RealmObjectBase.freezeObject<Pin>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'userId': userId.toEJson(),
      'phoneNumber': phoneNumber.toEJson(),
      'pin': pin.toEJson(),
      'branchId': branchId.toEJson(),
      'businessId': businessId.toEJson(),
    };
  }

  static EJsonValue _toEJson(Pin value) => value.toEJson();
  static Pin _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'userId': EJsonValue userId,
        'phoneNumber': EJsonValue phoneNumber,
        'pin': EJsonValue pin,
        'branchId': EJsonValue branchId,
        'businessId': EJsonValue businessId,
      } =>
        Pin(
          fromEJson(realmId),
          id: fromEJson(id),
          userId: fromEJson(userId),
          phoneNumber: fromEJson(phoneNumber),
          pin: fromEJson(pin),
          branchId: fromEJson(branchId),
          businessId: fromEJson(businessId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Pin._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Pin, 'Pin', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string, optional: true),
      SchemaProperty('phoneNumber', RealmPropertyType.string, optional: true),
      SchemaProperty('pin', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class LPermission extends _LPermission
    with RealmEntity, RealmObjectBase, RealmObject {
  LPermission(
    ObjectId? realmId, {
    int? id,
    String? name,
    int? userId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'userId', userId);
  }

  LPermission._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId? get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get name => RealmObjectBase.get<String>(this, 'name') as String?;
  @override
  set name(String? value) => RealmObjectBase.set(this, 'name', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  Stream<RealmObjectChanges<LPermission>> get changes =>
      RealmObjectBase.getChanges<LPermission>(this);

  @override
  Stream<RealmObjectChanges<LPermission>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<LPermission>(this, keyPaths);

  @override
  LPermission freeze() => RealmObjectBase.freezeObject<LPermission>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'name': name.toEJson(),
      'userId': userId.toEJson(),
    };
  }

  static EJsonValue _toEJson(LPermission value) => value.toEJson();
  static LPermission _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'name': EJsonValue name,
        'userId': EJsonValue userId,
      } =>
        LPermission(
          fromEJson(realmId),
          id: fromEJson(id),
          name: fromEJson(name),
          userId: fromEJson(userId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(LPermission._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, LPermission, 'LPermission', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string, optional: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Token extends _Token with RealmEntity, RealmObjectBase, RealmObject {
  Token(
    ObjectId? realmId, {
    int? id,
    String? type,
    String? token,
    DateTime? validFrom,
    DateTime? validUntil,
    int? businessId,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'token', token);
    RealmObjectBase.set(this, 'validFrom', validFrom);
    RealmObjectBase.set(this, 'validUntil', validUntil);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
  }

  Token._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId? get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set realmId(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get token => RealmObjectBase.get<String>(this, 'token') as String?;
  @override
  set token(String? value) => RealmObjectBase.set(this, 'token', value);

  @override
  DateTime? get validFrom =>
      RealmObjectBase.get<DateTime>(this, 'validFrom') as DateTime?;
  @override
  set validFrom(DateTime? value) =>
      RealmObjectBase.set(this, 'validFrom', value);

  @override
  DateTime? get validUntil =>
      RealmObjectBase.get<DateTime>(this, 'validUntil') as DateTime?;
  @override
  set validUntil(DateTime? value) =>
      RealmObjectBase.set(this, 'validUntil', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  Stream<RealmObjectChanges<Token>> get changes =>
      RealmObjectBase.getChanges<Token>(this);

  @override
  Stream<RealmObjectChanges<Token>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Token>(this, keyPaths);

  @override
  Token freeze() => RealmObjectBase.freezeObject<Token>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'type': type.toEJson(),
      'token': token.toEJson(),
      'validFrom': validFrom.toEJson(),
      'validUntil': validUntil.toEJson(),
      'businessId': businessId.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'deletedAt': deletedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Token value) => value.toEJson();
  static Token _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'type': EJsonValue type,
        'token': EJsonValue token,
        'validFrom': EJsonValue validFrom,
        'validUntil': EJsonValue validUntil,
        'businessId': EJsonValue businessId,
        'lastTouched': EJsonValue lastTouched,
        'deletedAt': EJsonValue deletedAt,
      } =>
        Token(
          fromEJson(realmId),
          id: fromEJson(id),
          type: fromEJson(type),
          token: fromEJson(token),
          validFrom: fromEJson(validFrom),
          validUntil: fromEJson(validUntil),
          businessId: fromEJson(businessId),
          lastTouched: fromEJson(lastTouched),
          deletedAt: fromEJson(deletedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Token._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Token, 'Token', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('token', RealmPropertyType.string, optional: true),
      SchemaProperty('validFrom', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('validUntil', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UserActivity extends _UserActivity
    with RealmEntity, RealmObjectBase, RealmObject {
  UserActivity(
    ObjectId id,
    String action, {
    DateTime? timestamp,
    DateTime? lastTouched,
    int? userId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'timestamp', timestamp);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'action', action);
  }

  UserActivity._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  DateTime? get timestamp =>
      RealmObjectBase.get<DateTime>(this, 'timestamp') as DateTime?;
  @override
  set timestamp(DateTime? value) =>
      RealmObjectBase.set(this, 'timestamp', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  int? get userId => RealmObjectBase.get<int>(this, 'userId') as int?;
  @override
  set userId(int? value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  Stream<RealmObjectChanges<UserActivity>> get changes =>
      RealmObjectBase.getChanges<UserActivity>(this);

  @override
  Stream<RealmObjectChanges<UserActivity>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UserActivity>(this, keyPaths);

  @override
  UserActivity freeze() => RealmObjectBase.freezeObject<UserActivity>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'timestamp': timestamp.toEJson(),
      'lastTouched': lastTouched.toEJson(),
      'userId': userId.toEJson(),
      'action': action.toEJson(),
    };
  }

  static EJsonValue _toEJson(UserActivity value) => value.toEJson();
  static UserActivity _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'timestamp': EJsonValue timestamp,
        'lastTouched': EJsonValue lastTouched,
        'userId': EJsonValue userId,
        'action': EJsonValue action,
      } =>
        UserActivity(
          fromEJson(id),
          fromEJson(action),
          timestamp: fromEJson(timestamp),
          lastTouched: fromEJson(lastTouched),
          userId: fromEJson(userId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UserActivity._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, UserActivity, 'UserActivity', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('timestamp', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('userId', RealmPropertyType.int, optional: true),
      SchemaProperty('action', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class UnversalProduct extends _UnversalProduct
    with RealmEntity, RealmObjectBase, RealmObject {
  UnversalProduct(
    ObjectId realmId, {
    int? id,
    String? itemClsCd,
    String? itemClsNm,
    int? itemClsLvl,
    String? taxTyCd,
    String? mjrTgYn,
    String? useYn,
    int? businessId,
    int? branchId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'itemClsCd', itemClsCd);
    RealmObjectBase.set(this, 'itemClsNm', itemClsNm);
    RealmObjectBase.set(this, 'itemClsLvl', itemClsLvl);
    RealmObjectBase.set(this, 'taxTyCd', taxTyCd);
    RealmObjectBase.set(this, 'mjrTgYn', mjrTgYn);
    RealmObjectBase.set(this, 'useYn', useYn);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
  }

  UnversalProduct._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get itemClsCd =>
      RealmObjectBase.get<String>(this, 'itemClsCd') as String?;
  @override
  set itemClsCd(String? value) => RealmObjectBase.set(this, 'itemClsCd', value);

  @override
  String? get itemClsNm =>
      RealmObjectBase.get<String>(this, 'itemClsNm') as String?;
  @override
  set itemClsNm(String? value) => RealmObjectBase.set(this, 'itemClsNm', value);

  @override
  int? get itemClsLvl => RealmObjectBase.get<int>(this, 'itemClsLvl') as int?;
  @override
  set itemClsLvl(int? value) => RealmObjectBase.set(this, 'itemClsLvl', value);

  @override
  String? get taxTyCd =>
      RealmObjectBase.get<String>(this, 'taxTyCd') as String?;
  @override
  set taxTyCd(String? value) => RealmObjectBase.set(this, 'taxTyCd', value);

  @override
  String? get mjrTgYn =>
      RealmObjectBase.get<String>(this, 'mjrTgYn') as String?;
  @override
  set mjrTgYn(String? value) => RealmObjectBase.set(this, 'mjrTgYn', value);

  @override
  String? get useYn => RealmObjectBase.get<String>(this, 'useYn') as String?;
  @override
  set useYn(String? value) => RealmObjectBase.set(this, 'useYn', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  Stream<RealmObjectChanges<UnversalProduct>> get changes =>
      RealmObjectBase.getChanges<UnversalProduct>(this);

  @override
  Stream<RealmObjectChanges<UnversalProduct>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<UnversalProduct>(this, keyPaths);

  @override
  UnversalProduct freeze() =>
      RealmObjectBase.freezeObject<UnversalProduct>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'itemClsCd': itemClsCd.toEJson(),
      'itemClsNm': itemClsNm.toEJson(),
      'itemClsLvl': itemClsLvl.toEJson(),
      'taxTyCd': taxTyCd.toEJson(),
      'mjrTgYn': mjrTgYn.toEJson(),
      'useYn': useYn.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
    };
  }

  static EJsonValue _toEJson(UnversalProduct value) => value.toEJson();
  static UnversalProduct _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'itemClsCd': EJsonValue itemClsCd,
        'itemClsNm': EJsonValue itemClsNm,
        'itemClsLvl': EJsonValue itemClsLvl,
        'taxTyCd': EJsonValue taxTyCd,
        'mjrTgYn': EJsonValue mjrTgYn,
        'useYn': EJsonValue useYn,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
      } =>
        UnversalProduct(
          fromEJson(realmId),
          id: fromEJson(id),
          itemClsCd: fromEJson(itemClsCd),
          itemClsNm: fromEJson(itemClsNm),
          itemClsLvl: fromEJson(itemClsLvl),
          taxTyCd: fromEJson(taxTyCd),
          mjrTgYn: fromEJson(mjrTgYn),
          useYn: fromEJson(useYn),
          businessId: fromEJson(businessId),
          branchId: fromEJson(branchId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(UnversalProduct._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, UnversalProduct, 'UnversalProduct', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('itemClsCd', RealmPropertyType.string, optional: true),
      SchemaProperty('itemClsNm', RealmPropertyType.string, optional: true),
      SchemaProperty('itemClsLvl', RealmPropertyType.int, optional: true),
      SchemaProperty('taxTyCd', RealmPropertyType.string, optional: true),
      SchemaProperty('mjrTgYn', RealmPropertyType.string, optional: true),
      SchemaProperty('useYn', RealmPropertyType.string, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Configurations extends _Configurations
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Configurations(
    ObjectId realmId, {
    int? id,
    String? taxType = "B",
    double? taxPercentage = 18.0,
    int? businessId,
    int? branchId,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Configurations>({
        'taxType': "B",
        'taxPercentage': 18.0,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'taxType', taxType);
    RealmObjectBase.set(this, 'taxPercentage', taxPercentage);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'branchId', branchId);
  }

  Configurations._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get taxType =>
      RealmObjectBase.get<String>(this, 'taxType') as String?;
  @override
  set taxType(String? value) => RealmObjectBase.set(this, 'taxType', value);

  @override
  double? get taxPercentage =>
      RealmObjectBase.get<double>(this, 'taxPercentage') as double?;
  @override
  set taxPercentage(double? value) =>
      RealmObjectBase.set(this, 'taxPercentage', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  Stream<RealmObjectChanges<Configurations>> get changes =>
      RealmObjectBase.getChanges<Configurations>(this);

  @override
  Stream<RealmObjectChanges<Configurations>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Configurations>(this, keyPaths);

  @override
  Configurations freeze() => RealmObjectBase.freezeObject<Configurations>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'taxType': taxType.toEJson(),
      'taxPercentage': taxPercentage.toEJson(),
      'businessId': businessId.toEJson(),
      'branchId': branchId.toEJson(),
    };
  }

  static EJsonValue _toEJson(Configurations value) => value.toEJson();
  static Configurations _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'taxType': EJsonValue taxType,
        'taxPercentage': EJsonValue taxPercentage,
        'businessId': EJsonValue businessId,
        'branchId': EJsonValue branchId,
      } =>
        Configurations(
          fromEJson(realmId),
          id: fromEJson(id),
          taxType: fromEJson(taxType),
          taxPercentage: fromEJson(taxPercentage),
          businessId: fromEJson(businessId),
          branchId: fromEJson(branchId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Configurations._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, Configurations, 'Configurations', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('taxType', RealmPropertyType.string, optional: true),
      SchemaProperty('taxPercentage', RealmPropertyType.double, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class AppNotification extends _AppNotification
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  AppNotification(
    ObjectId realmId, {
    int? id,
    bool completed = false,
    String? type = 'transaction',
    String? message,
    int? identifier,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<AppNotification>({
        'completed': false,
        'type': 'transaction',
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'completed', completed);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'identifier', identifier);
  }

  AppNotification._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  bool get completed => RealmObjectBase.get<bool>(this, 'completed') as bool;
  @override
  set completed(bool value) => RealmObjectBase.set(this, 'completed', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get message =>
      RealmObjectBase.get<String>(this, 'message') as String?;
  @override
  set message(String? value) => RealmObjectBase.set(this, 'message', value);

  @override
  int? get identifier => RealmObjectBase.get<int>(this, 'identifier') as int?;
  @override
  set identifier(int? value) => RealmObjectBase.set(this, 'identifier', value);

  @override
  Stream<RealmObjectChanges<AppNotification>> get changes =>
      RealmObjectBase.getChanges<AppNotification>(this);

  @override
  Stream<RealmObjectChanges<AppNotification>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<AppNotification>(this, keyPaths);

  @override
  AppNotification freeze() =>
      RealmObjectBase.freezeObject<AppNotification>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'completed': completed.toEJson(),
      'type': type.toEJson(),
      'message': message.toEJson(),
      'identifier': identifier.toEJson(),
    };
  }

  static EJsonValue _toEJson(AppNotification value) => value.toEJson();
  static AppNotification _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'completed': EJsonValue completed,
        'type': EJsonValue type,
        'message': EJsonValue message,
        'identifier': EJsonValue identifier,
      } =>
        AppNotification(
          fromEJson(realmId),
          id: fromEJson(id),
          completed: fromEJson(completed),
          type: fromEJson(type),
          message: fromEJson(message),
          identifier: fromEJson(identifier),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(AppNotification._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, AppNotification, 'AppNotification', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('completed', RealmPropertyType.bool),
      SchemaProperty('type', RealmPropertyType.string, optional: true),
      SchemaProperty('message', RealmPropertyType.string, optional: true),
      SchemaProperty('identifier', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Assets extends _Assets with RealmEntity, RealmObjectBase, RealmObject {
  Assets(
    ObjectId realmId, {
    int? id,
    int? branchId,
    int? businessId,
    String? assetName,
    int? productId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'assetName', assetName);
    RealmObjectBase.set(this, 'productId', productId);
  }

  Assets._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  String? get assetName =>
      RealmObjectBase.get<String>(this, 'assetName') as String?;
  @override
  set assetName(String? value) => RealmObjectBase.set(this, 'assetName', value);

  @override
  int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
  @override
  set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

  @override
  Stream<RealmObjectChanges<Assets>> get changes =>
      RealmObjectBase.getChanges<Assets>(this);

  @override
  Stream<RealmObjectChanges<Assets>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Assets>(this, keyPaths);

  @override
  Assets freeze() => RealmObjectBase.freezeObject<Assets>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'branchId': branchId.toEJson(),
      'businessId': businessId.toEJson(),
      'assetName': assetName.toEJson(),
      'productId': productId.toEJson(),
    };
  }

  static EJsonValue _toEJson(Assets value) => value.toEJson();
  static Assets _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'branchId': EJsonValue branchId,
        'businessId': EJsonValue businessId,
        'assetName': EJsonValue assetName,
        'productId': EJsonValue productId,
      } =>
        Assets(
          fromEJson(realmId),
          id: fromEJson(id),
          branchId: fromEJson(branchId),
          businessId: fromEJson(businessId),
          assetName: fromEJson(assetName),
          productId: fromEJson(productId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Assets._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Assets, 'Assets', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('assetName', RealmPropertyType.string, optional: true),
      SchemaProperty('productId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Composite extends _Composite
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  Composite(
    ObjectId realmId, {
    int? id,
    int? productId,
    int? variantId,
    int? quantity = 1,
    int? branchId,
    int? businessId,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<Composite>({
        'quantity': 1,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'productId', productId);
    RealmObjectBase.set(this, 'variantId', variantId);
    RealmObjectBase.set(this, 'quantity', quantity);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'businessId', businessId);
  }

  Composite._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get productId => RealmObjectBase.get<int>(this, 'productId') as int?;
  @override
  set productId(int? value) => RealmObjectBase.set(this, 'productId', value);

  @override
  int? get variantId => RealmObjectBase.get<int>(this, 'variantId') as int?;
  @override
  set variantId(int? value) => RealmObjectBase.set(this, 'variantId', value);

  @override
  int? get quantity => RealmObjectBase.get<int>(this, 'quantity') as int?;
  @override
  set quantity(int? value) => RealmObjectBase.set(this, 'quantity', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  Stream<RealmObjectChanges<Composite>> get changes =>
      RealmObjectBase.getChanges<Composite>(this);

  @override
  Stream<RealmObjectChanges<Composite>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Composite>(this, keyPaths);

  @override
  Composite freeze() => RealmObjectBase.freezeObject<Composite>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'productId': productId.toEJson(),
      'variantId': variantId.toEJson(),
      'quantity': quantity.toEJson(),
      'branchId': branchId.toEJson(),
      'businessId': businessId.toEJson(),
    };
  }

  static EJsonValue _toEJson(Composite value) => value.toEJson();
  static Composite _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'productId': EJsonValue productId,
        'variantId': EJsonValue variantId,
        'quantity': EJsonValue quantity,
        'branchId': EJsonValue branchId,
        'businessId': EJsonValue businessId,
      } =>
        Composite(
          fromEJson(realmId),
          id: fromEJson(id),
          productId: fromEJson(productId),
          variantId: fromEJson(variantId),
          quantity: fromEJson(quantity),
          branchId: fromEJson(branchId),
          businessId: fromEJson(businessId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Composite._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Composite, 'Composite', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('productId', RealmPropertyType.int, optional: true),
      SchemaProperty('variantId', RealmPropertyType.int, optional: true),
      SchemaProperty('quantity', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class SKU extends _SKU with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  SKU(
    ObjectId realmId, {
    int? id,
    int? sku = 1000,
    int? branchId,
    int? businessId,
    bool? consumed = false,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<SKU>({
        'sku': 1000,
        'consumed': false,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, '_id', realmId);
    RealmObjectBase.set(this, 'sku', sku);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'businessId', businessId);
    RealmObjectBase.set(this, 'consumed', consumed);
  }

  SKU._();

  @override
  int? get id => RealmObjectBase.get<int>(this, 'id') as int?;
  @override
  set id(int? value) => RealmObjectBase.set(this, 'id', value);

  @override
  ObjectId get realmId =>
      RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set realmId(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  int? get sku => RealmObjectBase.get<int>(this, 'sku') as int?;
  @override
  set sku(int? value) => RealmObjectBase.set(this, 'sku', value);

  @override
  int? get branchId => RealmObjectBase.get<int>(this, 'branchId') as int?;
  @override
  set branchId(int? value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  int? get businessId => RealmObjectBase.get<int>(this, 'businessId') as int?;
  @override
  set businessId(int? value) => RealmObjectBase.set(this, 'businessId', value);

  @override
  bool? get consumed => RealmObjectBase.get<bool>(this, 'consumed') as bool?;
  @override
  set consumed(bool? value) => RealmObjectBase.set(this, 'consumed', value);

  @override
  Stream<RealmObjectChanges<SKU>> get changes =>
      RealmObjectBase.getChanges<SKU>(this);

  @override
  Stream<RealmObjectChanges<SKU>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SKU>(this, keyPaths);

  @override
  SKU freeze() => RealmObjectBase.freezeObject<SKU>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      '_id': realmId.toEJson(),
      'sku': sku.toEJson(),
      'branchId': branchId.toEJson(),
      'businessId': businessId.toEJson(),
      'consumed': consumed.toEJson(),
    };
  }

  static EJsonValue _toEJson(SKU value) => value.toEJson();
  static SKU _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        '_id': EJsonValue realmId,
        'sku': EJsonValue sku,
        'branchId': EJsonValue branchId,
        'businessId': EJsonValue businessId,
        'consumed': EJsonValue consumed,
      } =>
        SKU(
          fromEJson(realmId),
          id: fromEJson(id),
          sku: fromEJson(sku),
          branchId: fromEJson(branchId),
          businessId: fromEJson(businessId),
          consumed: fromEJson(consumed),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SKU._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, SKU, 'SKU', [
      SchemaProperty('id', RealmPropertyType.int, optional: true),
      SchemaProperty('realmId', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('sku', RealmPropertyType.int, optional: true),
      SchemaProperty('branchId', RealmPropertyType.int, optional: true),
      SchemaProperty('businessId', RealmPropertyType.int, optional: true),
      SchemaProperty('consumed', RealmPropertyType.bool, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
