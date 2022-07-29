// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetBusinessCollection on Isar {
  IsarCollection<Business> get business => collection();
}

const BusinessSchema = CollectionSchema(
  name: r'Business',
  schema:
      r'{"name":"Business","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"adrs","type":"String"},{"name":"backUpEnabled","type":"Bool"},{"name":"backupFileId","type":"String"},{"name":"bhfId","type":"String"},{"name":"businessUrl","type":"String"},{"name":"categoryId","type":"String"},{"name":"channels","type":"StringList"},{"name":"chatUid","type":"String"},{"name":"country","type":"String"},{"name":"createdAt","type":"String"},{"name":"currency","type":"String"},{"name":"deviceToken","type":"String"},{"name":"dvcSrlNo","type":"String"},{"name":"email","type":"String"},{"name":"firstName","type":"String"},{"name":"fullName","type":"String"},{"name":"hexColor","type":"String"},{"name":"imageUrl","type":"String"},{"name":"isDefault","type":"Bool"},{"name":"isLastSubscriptionPaymentSucceeded","type":"Bool"},{"name":"lastDbBackup","type":"String"},{"name":"lastName","type":"String"},{"name":"lastSeen","type":"Long"},{"name":"latitude","type":"String"},{"name":"longitude","type":"String"},{"name":"metadata","type":"String"},{"name":"name","type":"String"},{"name":"nextBillingDate","type":"String"},{"name":"previousBillingDate","type":"String"},{"name":"role","type":"String"},{"name":"subscriptionPlan","type":"String"},{"name":"table","type":"String"},{"name":"taxEnabled","type":"Bool"},{"name":"taxServerUrl","type":"String"},{"name":"timeZone","type":"String"},{"name":"tinNumber","type":"Long"},{"name":"type","type":"String"},{"name":"typeId","type":"String"},{"name":"userId","type":"String"}],"indexes":[{"name":"userId","unique":false,"replace":false,"properties":[{"name":"userId","type":"Hash","caseSensitive":true}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'active': 0,
    r'adrs': 1,
    r'backUpEnabled': 2,
    r'backupFileId': 3,
    r'bhfId': 4,
    r'businessUrl': 5,
    r'categoryId': 6,
    r'channels': 7,
    r'chatUid': 8,
    r'country': 9,
    r'createdAt': 10,
    r'currency': 11,
    r'deviceToken': 12,
    r'dvcSrlNo': 13,
    r'email': 14,
    r'firstName': 15,
    r'fullName': 16,
    r'hexColor': 17,
    r'imageUrl': 18,
    r'isDefault': 19,
    r'isLastSubscriptionPaymentSucceeded': 20,
    r'lastDbBackup': 21,
    r'lastName': 22,
    r'lastSeen': 23,
    r'latitude': 24,
    r'longitude': 25,
    r'metadata': 26,
    r'name': 27,
    r'nextBillingDate': 28,
    r'previousBillingDate': 29,
    r'role': 30,
    r'subscriptionPlan': 31,
    r'table': 32,
    r'taxEnabled': 33,
    r'taxServerUrl': 34,
    r'timeZone': 35,
    r'tinNumber': 36,
    r'type': 37,
    r'typeId': 38,
    r'userId': 39
  },
  listProperties: {r'channels'},
  indexIds: {r'userId': 0},
  indexValueTypes: {
    r'userId': [
      IndexValueType.stringHash,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _businessGetId,
  setId: _businessSetId,
  getLinks: _businessGetLinks,
  attachLinks: _businessAttachLinks,
  serializeNative: _businessSerializeNative,
  deserializeNative: _businessDeserializeNative,
  deserializePropNative: _businessDeserializePropNative,
  serializeWeb: _businessSerializeWeb,
  deserializeWeb: _businessDeserializeWeb,
  deserializePropWeb: _businessDeserializePropWeb,
  version: 4,
);

int? _businessGetId(Business object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _businessSetId(Business object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _businessGetLinks(Business object) {
  return [];
}

void _businessSerializeNative(
    IsarCollection<Business> collection,
    IsarCObject cObj,
    Business object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  IsarUint8List? adrs$Bytes;
  final adrs$Value = object.adrs;
  if (adrs$Value != null) {
    adrs$Bytes = IsarBinaryWriter.utf8Encoder.convert(adrs$Value);
  }
  IsarUint8List? backupFileId$Bytes;
  final backupFileId$Value = object.backupFileId;
  if (backupFileId$Value != null) {
    backupFileId$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(backupFileId$Value);
  }
  IsarUint8List? bhfId$Bytes;
  final bhfId$Value = object.bhfId;
  if (bhfId$Value != null) {
    bhfId$Bytes = IsarBinaryWriter.utf8Encoder.convert(bhfId$Value);
  }
  IsarUint8List? businessUrl$Bytes;
  final businessUrl$Value = object.businessUrl;
  if (businessUrl$Value != null) {
    businessUrl$Bytes = IsarBinaryWriter.utf8Encoder.convert(businessUrl$Value);
  }
  IsarUint8List? categoryId$Bytes;
  final categoryId$Value = object.categoryId;
  if (categoryId$Value != null) {
    categoryId$Bytes = IsarBinaryWriter.utf8Encoder.convert(categoryId$Value);
  }
  var channels$BytesCount = 3 + (object.channels?.length ?? 0) * 3;
  List<IsarUint8List?>? channels$BytesList;
  final channels$Value = object.channels;
  if (channels$Value != null) {
    channels$BytesList = [];
    for (final str in channels$Value) {
      final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
      channels$BytesList.add(bytes);
      channels$BytesCount += bytes.length as int;
    }
  }
  IsarUint8List? chatUid$Bytes;
  final chatUid$Value = object.chatUid;
  if (chatUid$Value != null) {
    chatUid$Bytes = IsarBinaryWriter.utf8Encoder.convert(chatUid$Value);
  }
  IsarUint8List? country$Bytes;
  final country$Value = object.country;
  if (country$Value != null) {
    country$Bytes = IsarBinaryWriter.utf8Encoder.convert(country$Value);
  }
  IsarUint8List? createdAt$Bytes;
  final createdAt$Value = object.createdAt;
  if (createdAt$Value != null) {
    createdAt$Bytes = IsarBinaryWriter.utf8Encoder.convert(createdAt$Value);
  }
  IsarUint8List? currency$Bytes;
  final currency$Value = object.currency;
  if (currency$Value != null) {
    currency$Bytes = IsarBinaryWriter.utf8Encoder.convert(currency$Value);
  }
  IsarUint8List? deviceToken$Bytes;
  final deviceToken$Value = object.deviceToken;
  if (deviceToken$Value != null) {
    deviceToken$Bytes = IsarBinaryWriter.utf8Encoder.convert(deviceToken$Value);
  }
  IsarUint8List? dvcSrlNo$Bytes;
  final dvcSrlNo$Value = object.dvcSrlNo;
  if (dvcSrlNo$Value != null) {
    dvcSrlNo$Bytes = IsarBinaryWriter.utf8Encoder.convert(dvcSrlNo$Value);
  }
  IsarUint8List? email$Bytes;
  final email$Value = object.email;
  if (email$Value != null) {
    email$Bytes = IsarBinaryWriter.utf8Encoder.convert(email$Value);
  }
  IsarUint8List? firstName$Bytes;
  final firstName$Value = object.firstName;
  if (firstName$Value != null) {
    firstName$Bytes = IsarBinaryWriter.utf8Encoder.convert(firstName$Value);
  }
  IsarUint8List? fullName$Bytes;
  final fullName$Value = object.fullName;
  if (fullName$Value != null) {
    fullName$Bytes = IsarBinaryWriter.utf8Encoder.convert(fullName$Value);
  }
  IsarUint8List? hexColor$Bytes;
  final hexColor$Value = object.hexColor;
  if (hexColor$Value != null) {
    hexColor$Bytes = IsarBinaryWriter.utf8Encoder.convert(hexColor$Value);
  }
  IsarUint8List? imageUrl$Bytes;
  final imageUrl$Value = object.imageUrl;
  if (imageUrl$Value != null) {
    imageUrl$Bytes = IsarBinaryWriter.utf8Encoder.convert(imageUrl$Value);
  }
  IsarUint8List? lastDbBackup$Bytes;
  final lastDbBackup$Value = object.lastDbBackup;
  if (lastDbBackup$Value != null) {
    lastDbBackup$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(lastDbBackup$Value);
  }
  IsarUint8List? lastName$Bytes;
  final lastName$Value = object.lastName;
  if (lastName$Value != null) {
    lastName$Bytes = IsarBinaryWriter.utf8Encoder.convert(lastName$Value);
  }
  IsarUint8List? latitude$Bytes;
  final latitude$Value = object.latitude;
  if (latitude$Value != null) {
    latitude$Bytes = IsarBinaryWriter.utf8Encoder.convert(latitude$Value);
  }
  IsarUint8List? longitude$Bytes;
  final longitude$Value = object.longitude;
  if (longitude$Value != null) {
    longitude$Bytes = IsarBinaryWriter.utf8Encoder.convert(longitude$Value);
  }
  IsarUint8List? metadata$Bytes;
  final metadata$Value = object.metadata;
  if (metadata$Value != null) {
    metadata$Bytes = IsarBinaryWriter.utf8Encoder.convert(metadata$Value);
  }
  IsarUint8List? name$Bytes;
  final name$Value = object.name;
  if (name$Value != null) {
    name$Bytes = IsarBinaryWriter.utf8Encoder.convert(name$Value);
  }
  IsarUint8List? nextBillingDate$Bytes;
  final nextBillingDate$Value = object.nextBillingDate;
  if (nextBillingDate$Value != null) {
    nextBillingDate$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(nextBillingDate$Value);
  }
  IsarUint8List? previousBillingDate$Bytes;
  final previousBillingDate$Value = object.previousBillingDate;
  if (previousBillingDate$Value != null) {
    previousBillingDate$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(previousBillingDate$Value);
  }
  IsarUint8List? role$Bytes;
  final role$Value = object.role;
  if (role$Value != null) {
    role$Bytes = IsarBinaryWriter.utf8Encoder.convert(role$Value);
  }
  IsarUint8List? subscriptionPlan$Bytes;
  final subscriptionPlan$Value = object.subscriptionPlan;
  if (subscriptionPlan$Value != null) {
    subscriptionPlan$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(subscriptionPlan$Value);
  }
  IsarUint8List? table$Bytes;
  final table$Value = object.table;
  if (table$Value != null) {
    table$Bytes = IsarBinaryWriter.utf8Encoder.convert(table$Value);
  }
  IsarUint8List? taxServerUrl$Bytes;
  final taxServerUrl$Value = object.taxServerUrl;
  if (taxServerUrl$Value != null) {
    taxServerUrl$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(taxServerUrl$Value);
  }
  IsarUint8List? timeZone$Bytes;
  final timeZone$Value = object.timeZone;
  if (timeZone$Value != null) {
    timeZone$Bytes = IsarBinaryWriter.utf8Encoder.convert(timeZone$Value);
  }
  IsarUint8List? type$Bytes;
  final type$Value = object.type;
  if (type$Value != null) {
    type$Bytes = IsarBinaryWriter.utf8Encoder.convert(type$Value);
  }
  IsarUint8List? typeId$Bytes;
  final typeId$Value = object.typeId;
  if (typeId$Value != null) {
    typeId$Bytes = IsarBinaryWriter.utf8Encoder.convert(typeId$Value);
  }
  IsarUint8List? userId$Bytes;
  final userId$Value = object.userId;
  if (userId$Value != null) {
    userId$Bytes = IsarBinaryWriter.utf8Encoder.convert(userId$Value);
  }
  final size = (staticSize +
      3 +
      (adrs$Bytes?.length ?? 0) +
      3 +
      (backupFileId$Bytes?.length ?? 0) +
      3 +
      (bhfId$Bytes?.length ?? 0) +
      3 +
      (businessUrl$Bytes?.length ?? 0) +
      3 +
      (categoryId$Bytes?.length ?? 0) +
      channels$BytesCount +
      3 +
      (chatUid$Bytes?.length ?? 0) +
      3 +
      (country$Bytes?.length ?? 0) +
      3 +
      (createdAt$Bytes?.length ?? 0) +
      3 +
      (currency$Bytes?.length ?? 0) +
      3 +
      (deviceToken$Bytes?.length ?? 0) +
      3 +
      (dvcSrlNo$Bytes?.length ?? 0) +
      3 +
      (email$Bytes?.length ?? 0) +
      3 +
      (firstName$Bytes?.length ?? 0) +
      3 +
      (fullName$Bytes?.length ?? 0) +
      3 +
      (hexColor$Bytes?.length ?? 0) +
      3 +
      (imageUrl$Bytes?.length ?? 0) +
      3 +
      (lastDbBackup$Bytes?.length ?? 0) +
      3 +
      (lastName$Bytes?.length ?? 0) +
      3 +
      (latitude$Bytes?.length ?? 0) +
      3 +
      (longitude$Bytes?.length ?? 0) +
      3 +
      (metadata$Bytes?.length ?? 0) +
      3 +
      (name$Bytes?.length ?? 0) +
      3 +
      (nextBillingDate$Bytes?.length ?? 0) +
      3 +
      (previousBillingDate$Bytes?.length ?? 0) +
      3 +
      (role$Bytes?.length ?? 0) +
      3 +
      (subscriptionPlan$Bytes?.length ?? 0) +
      3 +
      (table$Bytes?.length ?? 0) +
      3 +
      (taxServerUrl$Bytes?.length ?? 0) +
      3 +
      (timeZone$Bytes?.length ?? 0) +
      3 +
      (type$Bytes?.length ?? 0) +
      3 +
      (typeId$Bytes?.length ?? 0) +
      3 +
      (userId$Bytes?.length ?? 0)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeBool(offsets[0], object.active);
  writer.writeByteList(offsets[1], adrs$Bytes);
  writer.writeBool(offsets[2], object.backUpEnabled);
  writer.writeByteList(offsets[3], backupFileId$Bytes);
  writer.writeByteList(offsets[4], bhfId$Bytes);
  writer.writeByteList(offsets[5], businessUrl$Bytes);
  writer.writeByteList(offsets[6], categoryId$Bytes);
  writer.writeByteLists(offsets[7], channels$BytesList);
  writer.writeByteList(offsets[8], chatUid$Bytes);
  writer.writeByteList(offsets[9], country$Bytes);
  writer.writeByteList(offsets[10], createdAt$Bytes);
  writer.writeByteList(offsets[11], currency$Bytes);
  writer.writeByteList(offsets[12], deviceToken$Bytes);
  writer.writeByteList(offsets[13], dvcSrlNo$Bytes);
  writer.writeByteList(offsets[14], email$Bytes);
  writer.writeByteList(offsets[15], firstName$Bytes);
  writer.writeByteList(offsets[16], fullName$Bytes);
  writer.writeByteList(offsets[17], hexColor$Bytes);
  writer.writeByteList(offsets[18], imageUrl$Bytes);
  writer.writeBool(offsets[19], object.isDefault);
  writer.writeBool(offsets[20], object.isLastSubscriptionPaymentSucceeded);
  writer.writeByteList(offsets[21], lastDbBackup$Bytes);
  writer.writeByteList(offsets[22], lastName$Bytes);
  writer.writeLong(offsets[23], object.lastSeen);
  writer.writeByteList(offsets[24], latitude$Bytes);
  writer.writeByteList(offsets[25], longitude$Bytes);
  writer.writeByteList(offsets[26], metadata$Bytes);
  writer.writeByteList(offsets[27], name$Bytes);
  writer.writeByteList(offsets[28], nextBillingDate$Bytes);
  writer.writeByteList(offsets[29], previousBillingDate$Bytes);
  writer.writeByteList(offsets[30], role$Bytes);
  writer.writeByteList(offsets[31], subscriptionPlan$Bytes);
  writer.writeByteList(offsets[32], table$Bytes);
  writer.writeBool(offsets[33], object.taxEnabled);
  writer.writeByteList(offsets[34], taxServerUrl$Bytes);
  writer.writeByteList(offsets[35], timeZone$Bytes);
  writer.writeLong(offsets[36], object.tinNumber);
  writer.writeByteList(offsets[37], type$Bytes);
  writer.writeByteList(offsets[38], typeId$Bytes);
  writer.writeByteList(offsets[39], userId$Bytes);
}

Business _businessDeserializeNative(IsarCollection<Business> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Business(
    active: reader.readBoolOrNull(offsets[0]),
    adrs: reader.readStringOrNull(offsets[1]),
    backUpEnabled: reader.readBoolOrNull(offsets[2]),
    backupFileId: reader.readStringOrNull(offsets[3]),
    bhfId: reader.readStringOrNull(offsets[4]),
    businessUrl: reader.readStringOrNull(offsets[5]),
    categoryId: reader.readStringOrNull(offsets[6]),
    channels: reader.readStringList(offsets[7]),
    chatUid: reader.readStringOrNull(offsets[8]),
    country: reader.readStringOrNull(offsets[9]),
    currency: reader.readStringOrNull(offsets[11]),
    deviceToken: reader.readStringOrNull(offsets[12]),
    dvcSrlNo: reader.readStringOrNull(offsets[13]),
    email: reader.readStringOrNull(offsets[14]),
    firstName: reader.readStringOrNull(offsets[15]),
    fullName: reader.readStringOrNull(offsets[16]),
    hexColor: reader.readStringOrNull(offsets[17]),
    id: id,
    imageUrl: reader.readStringOrNull(offsets[18]),
    isDefault: reader.readBoolOrNull(offsets[19]),
    isLastSubscriptionPaymentSucceeded: reader.readBoolOrNull(offsets[20]),
    lastDbBackup: reader.readStringOrNull(offsets[21]),
    lastName: reader.readStringOrNull(offsets[22]),
    lastSeen: reader.readLongOrNull(offsets[23]),
    latitude: reader.readStringOrNull(offsets[24]),
    longitude: reader.readStringOrNull(offsets[25]),
    metadata: reader.readStringOrNull(offsets[26]),
    name: reader.readStringOrNull(offsets[27]),
    nextBillingDate: reader.readStringOrNull(offsets[28]),
    previousBillingDate: reader.readStringOrNull(offsets[29]),
    role: reader.readStringOrNull(offsets[30]),
    subscriptionPlan: reader.readStringOrNull(offsets[31]),
    table: reader.readStringOrNull(offsets[32]),
    taxEnabled: reader.readBoolOrNull(offsets[33]),
    taxServerUrl: reader.readStringOrNull(offsets[34]),
    timeZone: reader.readStringOrNull(offsets[35]),
    tinNumber: reader.readLongOrNull(offsets[36]),
    type: reader.readStringOrNull(offsets[37]),
    typeId: reader.readStringOrNull(offsets[38]),
    userId: reader.readStringOrNull(offsets[39]),
  );
  object.createdAt = reader.readStringOrNull(offsets[10]);
  return object;
}

P _businessDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringList(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readBoolOrNull(offset)) as P;
    case 20:
      return (reader.readBoolOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readStringOrNull(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readStringOrNull(offset)) as P;
    case 33:
      return (reader.readBoolOrNull(offset)) as P;
    case 34:
      return (reader.readStringOrNull(offset)) as P;
    case 35:
      return (reader.readStringOrNull(offset)) as P;
    case 36:
      return (reader.readLongOrNull(offset)) as P;
    case 37:
      return (reader.readStringOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _businessSerializeWeb(
    IsarCollection<Business> collection, Business object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'active', object.active);
  IsarNative.jsObjectSet(jsObj, r'adrs', object.adrs);
  IsarNative.jsObjectSet(jsObj, r'backUpEnabled', object.backUpEnabled);
  IsarNative.jsObjectSet(jsObj, r'backupFileId', object.backupFileId);
  IsarNative.jsObjectSet(jsObj, r'bhfId', object.bhfId);
  IsarNative.jsObjectSet(jsObj, r'businessUrl', object.businessUrl);
  IsarNative.jsObjectSet(jsObj, r'categoryId', object.categoryId);
  IsarNative.jsObjectSet(jsObj, r'channels', object.channels);
  IsarNative.jsObjectSet(jsObj, r'chatUid', object.chatUid);
  IsarNative.jsObjectSet(jsObj, r'country', object.country);
  IsarNative.jsObjectSet(jsObj, r'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, r'currency', object.currency);
  IsarNative.jsObjectSet(jsObj, r'deviceToken', object.deviceToken);
  IsarNative.jsObjectSet(jsObj, r'dvcSrlNo', object.dvcSrlNo);
  IsarNative.jsObjectSet(jsObj, r'email', object.email);
  IsarNative.jsObjectSet(jsObj, r'firstName', object.firstName);
  IsarNative.jsObjectSet(jsObj, r'fullName', object.fullName);
  IsarNative.jsObjectSet(jsObj, r'hexColor', object.hexColor);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'imageUrl', object.imageUrl);
  IsarNative.jsObjectSet(jsObj, r'isDefault', object.isDefault);
  IsarNative.jsObjectSet(jsObj, r'isLastSubscriptionPaymentSucceeded',
      object.isLastSubscriptionPaymentSucceeded);
  IsarNative.jsObjectSet(jsObj, r'lastDbBackup', object.lastDbBackup);
  IsarNative.jsObjectSet(jsObj, r'lastName', object.lastName);
  IsarNative.jsObjectSet(jsObj, r'lastSeen', object.lastSeen);
  IsarNative.jsObjectSet(jsObj, r'latitude', object.latitude);
  IsarNative.jsObjectSet(jsObj, r'longitude', object.longitude);
  IsarNative.jsObjectSet(jsObj, r'metadata', object.metadata);
  IsarNative.jsObjectSet(jsObj, r'name', object.name);
  IsarNative.jsObjectSet(jsObj, r'nextBillingDate', object.nextBillingDate);
  IsarNative.jsObjectSet(
      jsObj, r'previousBillingDate', object.previousBillingDate);
  IsarNative.jsObjectSet(jsObj, r'role', object.role);
  IsarNative.jsObjectSet(jsObj, r'subscriptionPlan', object.subscriptionPlan);
  IsarNative.jsObjectSet(jsObj, r'table', object.table);
  IsarNative.jsObjectSet(jsObj, r'taxEnabled', object.taxEnabled);
  IsarNative.jsObjectSet(jsObj, r'taxServerUrl', object.taxServerUrl);
  IsarNative.jsObjectSet(jsObj, r'timeZone', object.timeZone);
  IsarNative.jsObjectSet(jsObj, r'tinNumber', object.tinNumber);
  IsarNative.jsObjectSet(jsObj, r'type', object.type);
  IsarNative.jsObjectSet(jsObj, r'typeId', object.typeId);
  IsarNative.jsObjectSet(jsObj, r'userId', object.userId);
  return jsObj;
}

Business _businessDeserializeWeb(
    IsarCollection<Business> collection, Object jsObj) {
  final object = Business(
    active: IsarNative.jsObjectGet(jsObj, r'active'),
    adrs: IsarNative.jsObjectGet(jsObj, r'adrs'),
    backUpEnabled: IsarNative.jsObjectGet(jsObj, r'backUpEnabled'),
    backupFileId: IsarNative.jsObjectGet(jsObj, r'backupFileId'),
    bhfId: IsarNative.jsObjectGet(jsObj, r'bhfId'),
    businessUrl: IsarNative.jsObjectGet(jsObj, r'businessUrl'),
    categoryId: IsarNative.jsObjectGet(jsObj, r'categoryId'),
    channels: (IsarNative.jsObjectGet(jsObj, r'channels') as List?)
        ?.map((e) => e ?? '')
        .toList()
        .cast<String>(),
    chatUid: IsarNative.jsObjectGet(jsObj, r'chatUid'),
    country: IsarNative.jsObjectGet(jsObj, r'country'),
    currency: IsarNative.jsObjectGet(jsObj, r'currency'),
    deviceToken: IsarNative.jsObjectGet(jsObj, r'deviceToken'),
    dvcSrlNo: IsarNative.jsObjectGet(jsObj, r'dvcSrlNo'),
    email: IsarNative.jsObjectGet(jsObj, r'email'),
    firstName: IsarNative.jsObjectGet(jsObj, r'firstName'),
    fullName: IsarNative.jsObjectGet(jsObj, r'fullName'),
    hexColor: IsarNative.jsObjectGet(jsObj, r'hexColor'),
    id: IsarNative.jsObjectGet(jsObj, r'id'),
    imageUrl: IsarNative.jsObjectGet(jsObj, r'imageUrl'),
    isDefault: IsarNative.jsObjectGet(jsObj, r'isDefault'),
    isLastSubscriptionPaymentSucceeded:
        IsarNative.jsObjectGet(jsObj, r'isLastSubscriptionPaymentSucceeded'),
    lastDbBackup: IsarNative.jsObjectGet(jsObj, r'lastDbBackup'),
    lastName: IsarNative.jsObjectGet(jsObj, r'lastName'),
    lastSeen: IsarNative.jsObjectGet(jsObj, r'lastSeen'),
    latitude: IsarNative.jsObjectGet(jsObj, r'latitude'),
    longitude: IsarNative.jsObjectGet(jsObj, r'longitude'),
    metadata: IsarNative.jsObjectGet(jsObj, r'metadata'),
    name: IsarNative.jsObjectGet(jsObj, r'name'),
    nextBillingDate: IsarNative.jsObjectGet(jsObj, r'nextBillingDate'),
    previousBillingDate: IsarNative.jsObjectGet(jsObj, r'previousBillingDate'),
    role: IsarNative.jsObjectGet(jsObj, r'role'),
    subscriptionPlan: IsarNative.jsObjectGet(jsObj, r'subscriptionPlan'),
    table: IsarNative.jsObjectGet(jsObj, r'table'),
    taxEnabled: IsarNative.jsObjectGet(jsObj, r'taxEnabled'),
    taxServerUrl: IsarNative.jsObjectGet(jsObj, r'taxServerUrl'),
    timeZone: IsarNative.jsObjectGet(jsObj, r'timeZone'),
    tinNumber: IsarNative.jsObjectGet(jsObj, r'tinNumber'),
    type: IsarNative.jsObjectGet(jsObj, r'type'),
    typeId: IsarNative.jsObjectGet(jsObj, r'typeId'),
    userId: IsarNative.jsObjectGet(jsObj, r'userId'),
  );
  object.createdAt = IsarNative.jsObjectGet(jsObj, r'createdAt');
  return object;
}

P _businessDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'active':
      return (IsarNative.jsObjectGet(jsObj, r'active')) as P;
    case r'adrs':
      return (IsarNative.jsObjectGet(jsObj, r'adrs')) as P;
    case r'backUpEnabled':
      return (IsarNative.jsObjectGet(jsObj, r'backUpEnabled')) as P;
    case r'backupFileId':
      return (IsarNative.jsObjectGet(jsObj, r'backupFileId')) as P;
    case r'bhfId':
      return (IsarNative.jsObjectGet(jsObj, r'bhfId')) as P;
    case r'businessUrl':
      return (IsarNative.jsObjectGet(jsObj, r'businessUrl')) as P;
    case r'categoryId':
      return (IsarNative.jsObjectGet(jsObj, r'categoryId')) as P;
    case r'channels':
      return ((IsarNative.jsObjectGet(jsObj, r'channels') as List?)
          ?.map((e) => e ?? '')
          .toList()
          .cast<String>()) as P;
    case r'chatUid':
      return (IsarNative.jsObjectGet(jsObj, r'chatUid')) as P;
    case r'country':
      return (IsarNative.jsObjectGet(jsObj, r'country')) as P;
    case r'createdAt':
      return (IsarNative.jsObjectGet(jsObj, r'createdAt')) as P;
    case r'currency':
      return (IsarNative.jsObjectGet(jsObj, r'currency')) as P;
    case r'deviceToken':
      return (IsarNative.jsObjectGet(jsObj, r'deviceToken')) as P;
    case r'dvcSrlNo':
      return (IsarNative.jsObjectGet(jsObj, r'dvcSrlNo')) as P;
    case r'email':
      return (IsarNative.jsObjectGet(jsObj, r'email')) as P;
    case r'firstName':
      return (IsarNative.jsObjectGet(jsObj, r'firstName')) as P;
    case r'fullName':
      return (IsarNative.jsObjectGet(jsObj, r'fullName')) as P;
    case r'hexColor':
      return (IsarNative.jsObjectGet(jsObj, r'hexColor')) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'imageUrl':
      return (IsarNative.jsObjectGet(jsObj, r'imageUrl')) as P;
    case r'isDefault':
      return (IsarNative.jsObjectGet(jsObj, r'isDefault')) as P;
    case r'isLastSubscriptionPaymentSucceeded':
      return (IsarNative.jsObjectGet(
          jsObj, r'isLastSubscriptionPaymentSucceeded')) as P;
    case r'lastDbBackup':
      return (IsarNative.jsObjectGet(jsObj, r'lastDbBackup')) as P;
    case r'lastName':
      return (IsarNative.jsObjectGet(jsObj, r'lastName')) as P;
    case r'lastSeen':
      return (IsarNative.jsObjectGet(jsObj, r'lastSeen')) as P;
    case r'latitude':
      return (IsarNative.jsObjectGet(jsObj, r'latitude')) as P;
    case r'longitude':
      return (IsarNative.jsObjectGet(jsObj, r'longitude')) as P;
    case r'metadata':
      return (IsarNative.jsObjectGet(jsObj, r'metadata')) as P;
    case r'name':
      return (IsarNative.jsObjectGet(jsObj, r'name')) as P;
    case r'nextBillingDate':
      return (IsarNative.jsObjectGet(jsObj, r'nextBillingDate')) as P;
    case r'previousBillingDate':
      return (IsarNative.jsObjectGet(jsObj, r'previousBillingDate')) as P;
    case r'role':
      return (IsarNative.jsObjectGet(jsObj, r'role')) as P;
    case r'subscriptionPlan':
      return (IsarNative.jsObjectGet(jsObj, r'subscriptionPlan')) as P;
    case r'table':
      return (IsarNative.jsObjectGet(jsObj, r'table')) as P;
    case r'taxEnabled':
      return (IsarNative.jsObjectGet(jsObj, r'taxEnabled')) as P;
    case r'taxServerUrl':
      return (IsarNative.jsObjectGet(jsObj, r'taxServerUrl')) as P;
    case r'timeZone':
      return (IsarNative.jsObjectGet(jsObj, r'timeZone')) as P;
    case r'tinNumber':
      return (IsarNative.jsObjectGet(jsObj, r'tinNumber')) as P;
    case r'type':
      return (IsarNative.jsObjectGet(jsObj, r'type')) as P;
    case r'typeId':
      return (IsarNative.jsObjectGet(jsObj, r'typeId')) as P;
    case r'userId':
      return (IsarNative.jsObjectGet(jsObj, r'userId')) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _businessAttachLinks(
    IsarCollection<dynamic> col, int id, Business object) {}

extension BusinessQueryWhereSort on QueryBuilder<Business, Business, QWhere> {
  QueryBuilder<Business, Business, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BusinessQueryWhere on QueryBuilder<Business, Business, QWhereClause> {
  QueryBuilder<Business, Business, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> userIdEqualTo(
      String? userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> userIdNotEqualTo(
      String? userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [null],
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterWhereClause> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }
}

extension BusinessQueryFilter
    on QueryBuilder<Business, Business, QFilterCondition> {
  QueryBuilder<Business, Business, QAfterFilterCondition> activeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'active',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> activeEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'active',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adrs',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adrs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adrs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adrs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adrs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adrs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adrs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adrs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> adrsMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adrs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      backUpEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backUpEnabled',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backUpEnabledEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backUpEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backupFileId',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backupFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      backupFileIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'backupFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'backupFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'backupFileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      backupFileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'backupFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'backupFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'backupFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'backupFileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bhfId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bhfId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'businessUrl',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      businessUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> categoryIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channels',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.equalTo(
        property: r'channels',
        value: null,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channels',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channels',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      channelsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channels',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatUid',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatUid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatUid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatUid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'country',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'country',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currency',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deviceToken',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      deviceTokenGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dvcSrlNo',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dvcSrlNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dvcSrlNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dvcSrlNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dvcSrlNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dvcSrlNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dvcSrlNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dvcSrlNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dvcSrlNo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'firstName',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'firstName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'firstName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'firstName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'fullName',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hexColor',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hexColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hexColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hexColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hexColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hexColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hexColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hexColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hexColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> isDefaultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isDefault',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> isDefaultEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDefault',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      isLastSubscriptionPaymentSucceededIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isLastSubscriptionPaymentSucceeded',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      isLastSubscriptionPaymentSucceededEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLastSubscriptionPaymentSucceeded',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDbBackup',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDbBackup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      lastDbBackupGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDbBackup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDbBackup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDbBackup',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      lastDbBackupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastDbBackup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastDbBackup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastDbBackup',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastDbBackup',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastName',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSeen',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeen',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeen',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'latitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'latitude',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'longitude',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'longitude',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'metadata',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextBillingDate',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextBillingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextBillingDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'previousBillingDate',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'previousBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'previousBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'previousBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'previousBillingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'previousBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'previousBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'previousBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'previousBillingDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'role',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'role',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'role',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'role',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'subscriptionPlan',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'subscriptionPlan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'subscriptionPlan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'subscriptionPlan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'table',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'table',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'table',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'table',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxEnabledIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxEnabled',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxEnabledEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxServerUrl',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      taxServerUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxServerUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      taxServerUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxServerUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> taxServerUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxServerUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeZone',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeZone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timeZone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timeZone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tinNumber',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tinNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tinNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tinNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tinNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'typeId',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension BusinessQueryLinks
    on QueryBuilder<Business, Business, QFilterCondition> {}

extension BusinessQueryWhereSortBy
    on QueryBuilder<Business, Business, QSortBy> {
  QueryBuilder<Business, Business, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByAdrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adrs', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByAdrsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adrs', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackUpEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backUpEnabled', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackUpEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backUpEnabled', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackupFileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFileId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackupFileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFileId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBusinessUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessUrl', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBusinessUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessUrl', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByChatUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUid', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByChatUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUid', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDeviceToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceToken', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDeviceTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceToken', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDvcSrlNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dvcSrlNo', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDvcSrlNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dvcSrlNo', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFirstName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFirstNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByHexColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      sortByIsLastSubscriptionPaymentSucceeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLastSubscriptionPaymentSucceeded', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      sortByIsLastSubscriptionPaymentSucceededDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLastSubscriptionPaymentSucceeded', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastDbBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDbBackup', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastDbBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDbBackup', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByNextBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByNextBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByPreviousBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      sortByPreviousBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortBySubscriptionPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortBySubscriptionPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTaxEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTaxEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTaxServerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxServerUrl', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTaxServerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxServerUrl', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTimeZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTimeZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTinNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tinNumber', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTinNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tinNumber', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BusinessQueryWhereSortThenBy
    on QueryBuilder<Business, Business, QSortThenBy> {
  QueryBuilder<Business, Business, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'active', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByAdrs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adrs', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByAdrsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adrs', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackUpEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backUpEnabled', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackUpEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backUpEnabled', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackupFileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFileId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackupFileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backupFileId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBusinessUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessUrl', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBusinessUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessUrl', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByChatUid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUid', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByChatUidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUid', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDeviceToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceToken', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDeviceTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceToken', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDvcSrlNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dvcSrlNo', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDvcSrlNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dvcSrlNo', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFirstName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFirstNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstName', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByHexColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByHexColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hexColor', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByIsDefaultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDefault', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      thenByIsLastSubscriptionPaymentSucceeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLastSubscriptionPaymentSucceeded', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      thenByIsLastSubscriptionPaymentSucceededDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isLastSubscriptionPaymentSucceeded', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastDbBackup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDbBackup', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastDbBackupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDbBackup', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastName', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastSeenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeen', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metadata', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByNextBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByNextBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByPreviousBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      thenByPreviousBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'previousBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'role', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenBySubscriptionPlan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenBySubscriptionPlanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'subscriptionPlan', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'table', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTaxEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTaxEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxEnabled', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTaxServerUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxServerUrl', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTaxServerUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxServerUrl', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTimeZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTimeZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeZone', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTinNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tinNumber', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTinNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tinNumber', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typeId', Sort.desc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BusinessQueryWhereDistinct
    on QueryBuilder<Business, Business, QDistinct> {
  QueryBuilder<Business, Business, QDistinct> distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'active');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByAdrs(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adrs', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBackUpEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backUpEnabled');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBackupFileId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backupFileId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bhfId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBusinessUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCategoryId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByChannels() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channels');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByChatUid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatUid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCountry(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'country', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByDeviceToken(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByDvcSrlNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dvcSrlNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByFirstName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'firstName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByHexColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hexColor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByIsDefault() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDefault');
    });
  }

  QueryBuilder<Business, Business, QDistinct>
      distinctByIsLastSubscriptionPaymentSucceeded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isLastSubscriptionPaymentSucceeded');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLastDbBackup(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDbBackup', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLastName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLastSeen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeen');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLatitude(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLongitude(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByMetadata(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metadata', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByNextBillingDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextBillingDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByPreviousBillingDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'previousBillingDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByRole(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'role', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctBySubscriptionPlan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'subscriptionPlan',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'table', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTaxEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxEnabled');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTaxServerUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxServerUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTimeZone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeZone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTinNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tinNumber');
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTypeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Business, Business, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BusinessQueryProperty
    on QueryBuilder<Business, Business, QQueryProperty> {
  QueryBuilder<Business, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Business, bool?, QQueryOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'active');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> adrsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adrs');
    });
  }

  QueryBuilder<Business, bool?, QQueryOperations> backUpEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backUpEnabled');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> backupFileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backupFileId');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bhfId');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> businessUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessUrl');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<Business, List<String>?, QQueryOperations> channelsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channels');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> chatUidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatUid');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'country');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> deviceTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceToken');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> dvcSrlNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dvcSrlNo');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> firstNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstName');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> hexColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hexColor');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<Business, bool?, QQueryOperations> isDefaultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDefault');
    });
  }

  QueryBuilder<Business, bool?, QQueryOperations>
      isLastSubscriptionPaymentSucceededProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isLastSubscriptionPaymentSucceeded');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> lastDbBackupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDbBackup');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> lastNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastName');
    });
  }

  QueryBuilder<Business, int?, QQueryOperations> lastSeenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeen');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> metadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metadata');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> nextBillingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextBillingDate');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations>
      previousBillingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'previousBillingDate');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> roleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'role');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> subscriptionPlanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'subscriptionPlan');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> tableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'table');
    });
  }

  QueryBuilder<Business, bool?, QQueryOperations> taxEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxEnabled');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> taxServerUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxServerUrl');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> timeZoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeZone');
    });
  }

  QueryBuilder<Business, int?, QQueryOperations> tinNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tinNumber');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> typeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typeId');
    });
  }

  QueryBuilder<Business, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
