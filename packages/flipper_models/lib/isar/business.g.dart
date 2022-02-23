// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetBusinessSyncCollection on Isar {
  IsarCollection<BusinessSync> get businessSyncs {
    return getCollection('BusinessSync');
  }
}

final BusinessSyncSchema = CollectionSchema(
  name: 'BusinessSync',
  schema:
      '{"name":"BusinessSync","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"backUpEnabled","type":"Bool"},{"name":"backupFileId","type":"String"},{"name":"businessUrl","type":"String"},{"name":"channels","type":"StringList"},{"name":"chatUid","type":"String"},{"name":"country","type":"String"},{"name":"createdAt","type":"String"},{"name":"currency","type":"String"},{"name":"deviceToken","type":"String"},{"name":"email","type":"String"},{"name":"fcategoryId","type":"Long"},{"name":"firstName","type":"String"},{"name":"fullName","type":"String"},{"name":"hexColor","type":"String"},{"name":"imageUrl","type":"String"},{"name":"isLastSubscriptionPaymentSucceeded","type":"Bool"},{"name":"lastDbBackup","type":"String"},{"name":"lastName","type":"String"},{"name":"lastSeen","type":"Long"},{"name":"latitude","type":"String"},{"name":"longitude","type":"String"},{"name":"metadata","type":"String"},{"name":"name","type":"String"},{"name":"nextBillingDate","type":"String"},{"name":"previousBillingDate","type":"String"},{"name":"role","type":"String"},{"name":"subscriptionPlan","type":"String"},{"name":"table","type":"String"},{"name":"timeZone","type":"String"},{"name":"type","type":"String"},{"name":"typeId","type":"String"},{"name":"userId","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _BusinessSyncNativeAdapter(),
  webAdapter: const _BusinessSyncWebAdapter(),
  idName: 'id',
  propertyIds: {
    'active': 0,
    'backUpEnabled': 1,
    'backupFileId': 2,
    'businessUrl': 3,
    'channels': 4,
    'chatUid': 5,
    'country': 6,
    'createdAt': 7,
    'currency': 8,
    'deviceToken': 9,
    'email': 10,
    'fcategoryId': 11,
    'firstName': 12,
    'fullName': 13,
    'hexColor': 14,
    'imageUrl': 15,
    'isLastSubscriptionPaymentSucceeded': 16,
    'lastDbBackup': 17,
    'lastName': 18,
    'lastSeen': 19,
    'latitude': 20,
    'longitude': 21,
    'metadata': 22,
    'name': 23,
    'nextBillingDate': 24,
    'previousBillingDate': 25,
    'role': 26,
    'subscriptionPlan': 27,
    'table': 28,
    'timeZone': 29,
    'type': 30,
    'typeId': 31,
    'userId': 32
  },
  listProperties: {'channels'},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

class _BusinessSyncWebAdapter extends IsarWebTypeAdapter<BusinessSync> {
  const _BusinessSyncWebAdapter();

  @override
  Object serialize(
      IsarCollection<BusinessSync> collection, BusinessSync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'active', object.active);
    IsarNative.jsObjectSet(jsObj, 'backUpEnabled', object.backUpEnabled);
    IsarNative.jsObjectSet(jsObj, 'backupFileId', object.backupFileId);
    IsarNative.jsObjectSet(jsObj, 'businessUrl', object.businessUrl);
    IsarNative.jsObjectSet(jsObj, 'channels', object.channels);
    IsarNative.jsObjectSet(jsObj, 'chatUid', object.chatUid);
    IsarNative.jsObjectSet(jsObj, 'country', object.country);
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(jsObj, 'currency', object.currency);
    IsarNative.jsObjectSet(jsObj, 'deviceToken', object.deviceToken);
    IsarNative.jsObjectSet(jsObj, 'email', object.email);
    IsarNative.jsObjectSet(jsObj, 'fcategoryId', object.fcategoryId);
    IsarNative.jsObjectSet(jsObj, 'firstName', object.firstName);
    IsarNative.jsObjectSet(jsObj, 'fullName', object.fullName);
    IsarNative.jsObjectSet(jsObj, 'hexColor', object.hexColor);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'imageUrl', object.imageUrl);
    IsarNative.jsObjectSet(jsObj, 'isLastSubscriptionPaymentSucceeded',
        object.isLastSubscriptionPaymentSucceeded);
    IsarNative.jsObjectSet(jsObj, 'lastDbBackup', object.lastDbBackup);
    IsarNative.jsObjectSet(jsObj, 'lastName', object.lastName);
    IsarNative.jsObjectSet(jsObj, 'lastSeen', object.lastSeen);
    IsarNative.jsObjectSet(jsObj, 'latitude', object.latitude);
    IsarNative.jsObjectSet(jsObj, 'longitude', object.longitude);
    IsarNative.jsObjectSet(jsObj, 'metadata', object.metadata);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'nextBillingDate', object.nextBillingDate);
    IsarNative.jsObjectSet(
        jsObj, 'previousBillingDate', object.previousBillingDate);
    IsarNative.jsObjectSet(jsObj, 'role', object.role);
    IsarNative.jsObjectSet(jsObj, 'subscriptionPlan', object.subscriptionPlan);
    IsarNative.jsObjectSet(jsObj, 'table', object.table);
    IsarNative.jsObjectSet(jsObj, 'timeZone', object.timeZone);
    IsarNative.jsObjectSet(jsObj, 'type', object.type);
    IsarNative.jsObjectSet(jsObj, 'typeId', object.typeId);
    IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
    return jsObj;
  }

  @override
  BusinessSync deserialize(
      IsarCollection<BusinessSync> collection, dynamic jsObj) {
    final object = BusinessSync(
      active: IsarNative.jsObjectGet(jsObj, 'active'),
      backUpEnabled: IsarNative.jsObjectGet(jsObj, 'backUpEnabled'),
      backupFileId: IsarNative.jsObjectGet(jsObj, 'backupFileId'),
      businessUrl: IsarNative.jsObjectGet(jsObj, 'businessUrl'),
      channels: (IsarNative.jsObjectGet(jsObj, 'channels') as List?)
          ?.map((e) => e ?? '')
          .toList()
          .cast<String>(),
      chatUid: IsarNative.jsObjectGet(jsObj, 'chatUid'),
      country: IsarNative.jsObjectGet(jsObj, 'country') ?? '',
      currency: IsarNative.jsObjectGet(jsObj, 'currency'),
      deviceToken: IsarNative.jsObjectGet(jsObj, 'deviceToken'),
      email: IsarNative.jsObjectGet(jsObj, 'email'),
      fcategoryId: IsarNative.jsObjectGet(jsObj, 'fcategoryId'),
      firstName: IsarNative.jsObjectGet(jsObj, 'firstName'),
      fullName: IsarNative.jsObjectGet(jsObj, 'fullName'),
      hexColor: IsarNative.jsObjectGet(jsObj, 'hexColor'),
      imageUrl: IsarNative.jsObjectGet(jsObj, 'imageUrl'),
      isLastSubscriptionPaymentSucceeded:
          IsarNative.jsObjectGet(jsObj, 'isLastSubscriptionPaymentSucceeded'),
      lastDbBackup: IsarNative.jsObjectGet(jsObj, 'lastDbBackup'),
      lastName: IsarNative.jsObjectGet(jsObj, 'lastName'),
      lastSeen: IsarNative.jsObjectGet(jsObj, 'lastSeen'),
      latitude: IsarNative.jsObjectGet(jsObj, 'latitude') ?? '',
      longitude: IsarNative.jsObjectGet(jsObj, 'longitude') ?? '',
      metadata: IsarNative.jsObjectGet(jsObj, 'metadata'),
      name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
      nextBillingDate: IsarNative.jsObjectGet(jsObj, 'nextBillingDate'),
      previousBillingDate: IsarNative.jsObjectGet(jsObj, 'previousBillingDate'),
      role: IsarNative.jsObjectGet(jsObj, 'role'),
      subscriptionPlan: IsarNative.jsObjectGet(jsObj, 'subscriptionPlan'),
      table: IsarNative.jsObjectGet(jsObj, 'table'),
      timeZone: IsarNative.jsObjectGet(jsObj, 'timeZone'),
      type: IsarNative.jsObjectGet(jsObj, 'type') ?? '',
      typeId: IsarNative.jsObjectGet(jsObj, 'typeId'),
      userId: IsarNative.jsObjectGet(jsObj, 'userId'),
    );
    object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt');
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'active':
        return (IsarNative.jsObjectGet(jsObj, 'active')) as P;
      case 'backUpEnabled':
        return (IsarNative.jsObjectGet(jsObj, 'backUpEnabled')) as P;
      case 'backupFileId':
        return (IsarNative.jsObjectGet(jsObj, 'backupFileId')) as P;
      case 'businessUrl':
        return (IsarNative.jsObjectGet(jsObj, 'businessUrl')) as P;
      case 'channels':
        return ((IsarNative.jsObjectGet(jsObj, 'channels') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>()) as P;
      case 'chatUid':
        return (IsarNative.jsObjectGet(jsObj, 'chatUid')) as P;
      case 'country':
        return (IsarNative.jsObjectGet(jsObj, 'country') ?? '') as P;
      case 'createdAt':
        return (IsarNative.jsObjectGet(jsObj, 'createdAt')) as P;
      case 'currency':
        return (IsarNative.jsObjectGet(jsObj, 'currency')) as P;
      case 'deviceToken':
        return (IsarNative.jsObjectGet(jsObj, 'deviceToken')) as P;
      case 'email':
        return (IsarNative.jsObjectGet(jsObj, 'email')) as P;
      case 'fcategoryId':
        return (IsarNative.jsObjectGet(jsObj, 'fcategoryId')) as P;
      case 'firstName':
        return (IsarNative.jsObjectGet(jsObj, 'firstName')) as P;
      case 'fullName':
        return (IsarNative.jsObjectGet(jsObj, 'fullName')) as P;
      case 'hexColor':
        return (IsarNative.jsObjectGet(jsObj, 'hexColor')) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'imageUrl':
        return (IsarNative.jsObjectGet(jsObj, 'imageUrl')) as P;
      case 'isLastSubscriptionPaymentSucceeded':
        return (IsarNative.jsObjectGet(
            jsObj, 'isLastSubscriptionPaymentSucceeded')) as P;
      case 'lastDbBackup':
        return (IsarNative.jsObjectGet(jsObj, 'lastDbBackup')) as P;
      case 'lastName':
        return (IsarNative.jsObjectGet(jsObj, 'lastName')) as P;
      case 'lastSeen':
        return (IsarNative.jsObjectGet(jsObj, 'lastSeen')) as P;
      case 'latitude':
        return (IsarNative.jsObjectGet(jsObj, 'latitude') ?? '') as P;
      case 'longitude':
        return (IsarNative.jsObjectGet(jsObj, 'longitude') ?? '') as P;
      case 'metadata':
        return (IsarNative.jsObjectGet(jsObj, 'metadata')) as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      case 'nextBillingDate':
        return (IsarNative.jsObjectGet(jsObj, 'nextBillingDate')) as P;
      case 'previousBillingDate':
        return (IsarNative.jsObjectGet(jsObj, 'previousBillingDate')) as P;
      case 'role':
        return (IsarNative.jsObjectGet(jsObj, 'role')) as P;
      case 'subscriptionPlan':
        return (IsarNative.jsObjectGet(jsObj, 'subscriptionPlan')) as P;
      case 'table':
        return (IsarNative.jsObjectGet(jsObj, 'table')) as P;
      case 'timeZone':
        return (IsarNative.jsObjectGet(jsObj, 'timeZone')) as P;
      case 'type':
        return (IsarNative.jsObjectGet(jsObj, 'type') ?? '') as P;
      case 'typeId':
        return (IsarNative.jsObjectGet(jsObj, 'typeId')) as P;
      case 'userId':
        return (IsarNative.jsObjectGet(jsObj, 'userId')) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, BusinessSync object) {}
}

class _BusinessSyncNativeAdapter extends IsarNativeTypeAdapter<BusinessSync> {
  const _BusinessSyncNativeAdapter();

  @override
  void serialize(
      IsarCollection<BusinessSync> collection,
      IsarRawObject rawObj,
      BusinessSync object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.active;
    final _active = value0;
    final value1 = object.backUpEnabled;
    final _backUpEnabled = value1;
    final value2 = object.backupFileId;
    IsarUint8List? _backupFileId;
    if (value2 != null) {
      _backupFileId = IsarBinaryWriter.utf8Encoder.convert(value2);
    }
    dynamicSize += (_backupFileId?.length ?? 0) as int;
    final value3 = object.businessUrl;
    IsarUint8List? _businessUrl;
    if (value3 != null) {
      _businessUrl = IsarBinaryWriter.utf8Encoder.convert(value3);
    }
    dynamicSize += (_businessUrl?.length ?? 0) as int;
    final value4 = object.channels;
    dynamicSize += (value4?.length ?? 0) * 8;
    List<IsarUint8List?>? bytesList4;
    if (value4 != null) {
      bytesList4 = [];
      for (var str in value4) {
        final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
        bytesList4.add(bytes);
        dynamicSize += bytes.length as int;
      }
    }
    final _channels = bytesList4;
    final value5 = object.chatUid;
    IsarUint8List? _chatUid;
    if (value5 != null) {
      _chatUid = IsarBinaryWriter.utf8Encoder.convert(value5);
    }
    dynamicSize += (_chatUid?.length ?? 0) as int;
    final value6 = object.country;
    final _country = IsarBinaryWriter.utf8Encoder.convert(value6);
    dynamicSize += (_country.length) as int;
    final value7 = object.createdAt;
    IsarUint8List? _createdAt;
    if (value7 != null) {
      _createdAt = IsarBinaryWriter.utf8Encoder.convert(value7);
    }
    dynamicSize += (_createdAt?.length ?? 0) as int;
    final value8 = object.currency;
    IsarUint8List? _currency;
    if (value8 != null) {
      _currency = IsarBinaryWriter.utf8Encoder.convert(value8);
    }
    dynamicSize += (_currency?.length ?? 0) as int;
    final value9 = object.deviceToken;
    IsarUint8List? _deviceToken;
    if (value9 != null) {
      _deviceToken = IsarBinaryWriter.utf8Encoder.convert(value9);
    }
    dynamicSize += (_deviceToken?.length ?? 0) as int;
    final value10 = object.email;
    IsarUint8List? _email;
    if (value10 != null) {
      _email = IsarBinaryWriter.utf8Encoder.convert(value10);
    }
    dynamicSize += (_email?.length ?? 0) as int;
    final value11 = object.fcategoryId;
    final _fcategoryId = value11;
    final value12 = object.firstName;
    IsarUint8List? _firstName;
    if (value12 != null) {
      _firstName = IsarBinaryWriter.utf8Encoder.convert(value12);
    }
    dynamicSize += (_firstName?.length ?? 0) as int;
    final value13 = object.fullName;
    IsarUint8List? _fullName;
    if (value13 != null) {
      _fullName = IsarBinaryWriter.utf8Encoder.convert(value13);
    }
    dynamicSize += (_fullName?.length ?? 0) as int;
    final value14 = object.hexColor;
    IsarUint8List? _hexColor;
    if (value14 != null) {
      _hexColor = IsarBinaryWriter.utf8Encoder.convert(value14);
    }
    dynamicSize += (_hexColor?.length ?? 0) as int;
    final value15 = object.imageUrl;
    IsarUint8List? _imageUrl;
    if (value15 != null) {
      _imageUrl = IsarBinaryWriter.utf8Encoder.convert(value15);
    }
    dynamicSize += (_imageUrl?.length ?? 0) as int;
    final value16 = object.isLastSubscriptionPaymentSucceeded;
    final _isLastSubscriptionPaymentSucceeded = value16;
    final value17 = object.lastDbBackup;
    IsarUint8List? _lastDbBackup;
    if (value17 != null) {
      _lastDbBackup = IsarBinaryWriter.utf8Encoder.convert(value17);
    }
    dynamicSize += (_lastDbBackup?.length ?? 0) as int;
    final value18 = object.lastName;
    IsarUint8List? _lastName;
    if (value18 != null) {
      _lastName = IsarBinaryWriter.utf8Encoder.convert(value18);
    }
    dynamicSize += (_lastName?.length ?? 0) as int;
    final value19 = object.lastSeen;
    final _lastSeen = value19;
    final value20 = object.latitude;
    final _latitude = IsarBinaryWriter.utf8Encoder.convert(value20);
    dynamicSize += (_latitude.length) as int;
    final value21 = object.longitude;
    final _longitude = IsarBinaryWriter.utf8Encoder.convert(value21);
    dynamicSize += (_longitude.length) as int;
    final value22 = object.metadata;
    IsarUint8List? _metadata;
    if (value22 != null) {
      _metadata = IsarBinaryWriter.utf8Encoder.convert(value22);
    }
    dynamicSize += (_metadata?.length ?? 0) as int;
    final value23 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value23);
    dynamicSize += (_name.length) as int;
    final value24 = object.nextBillingDate;
    IsarUint8List? _nextBillingDate;
    if (value24 != null) {
      _nextBillingDate = IsarBinaryWriter.utf8Encoder.convert(value24);
    }
    dynamicSize += (_nextBillingDate?.length ?? 0) as int;
    final value25 = object.previousBillingDate;
    IsarUint8List? _previousBillingDate;
    if (value25 != null) {
      _previousBillingDate = IsarBinaryWriter.utf8Encoder.convert(value25);
    }
    dynamicSize += (_previousBillingDate?.length ?? 0) as int;
    final value26 = object.role;
    IsarUint8List? _role;
    if (value26 != null) {
      _role = IsarBinaryWriter.utf8Encoder.convert(value26);
    }
    dynamicSize += (_role?.length ?? 0) as int;
    final value27 = object.subscriptionPlan;
    IsarUint8List? _subscriptionPlan;
    if (value27 != null) {
      _subscriptionPlan = IsarBinaryWriter.utf8Encoder.convert(value27);
    }
    dynamicSize += (_subscriptionPlan?.length ?? 0) as int;
    final value28 = object.table;
    IsarUint8List? _table;
    if (value28 != null) {
      _table = IsarBinaryWriter.utf8Encoder.convert(value28);
    }
    dynamicSize += (_table?.length ?? 0) as int;
    final value29 = object.timeZone;
    IsarUint8List? _timeZone;
    if (value29 != null) {
      _timeZone = IsarBinaryWriter.utf8Encoder.convert(value29);
    }
    dynamicSize += (_timeZone?.length ?? 0) as int;
    final value30 = object.type;
    final _type = IsarBinaryWriter.utf8Encoder.convert(value30);
    dynamicSize += (_type.length) as int;
    final value31 = object.typeId;
    IsarUint8List? _typeId;
    if (value31 != null) {
      _typeId = IsarBinaryWriter.utf8Encoder.convert(value31);
    }
    dynamicSize += (_typeId?.length ?? 0) as int;
    final value32 = object.userId;
    IsarUint8List? _userId;
    if (value32 != null) {
      _userId = IsarBinaryWriter.utf8Encoder.convert(value32);
    }
    dynamicSize += (_userId?.length ?? 0) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBool(offsets[0], _active);
    writer.writeBool(offsets[1], _backUpEnabled);
    writer.writeBytes(offsets[2], _backupFileId);
    writer.writeBytes(offsets[3], _businessUrl);
    writer.writeStringList(offsets[4], _channels);
    writer.writeBytes(offsets[5], _chatUid);
    writer.writeBytes(offsets[6], _country);
    writer.writeBytes(offsets[7], _createdAt);
    writer.writeBytes(offsets[8], _currency);
    writer.writeBytes(offsets[9], _deviceToken);
    writer.writeBytes(offsets[10], _email);
    writer.writeLong(offsets[11], _fcategoryId);
    writer.writeBytes(offsets[12], _firstName);
    writer.writeBytes(offsets[13], _fullName);
    writer.writeBytes(offsets[14], _hexColor);
    writer.writeBytes(offsets[15], _imageUrl);
    writer.writeBool(offsets[16], _isLastSubscriptionPaymentSucceeded);
    writer.writeBytes(offsets[17], _lastDbBackup);
    writer.writeBytes(offsets[18], _lastName);
    writer.writeLong(offsets[19], _lastSeen);
    writer.writeBytes(offsets[20], _latitude);
    writer.writeBytes(offsets[21], _longitude);
    writer.writeBytes(offsets[22], _metadata);
    writer.writeBytes(offsets[23], _name);
    writer.writeBytes(offsets[24], _nextBillingDate);
    writer.writeBytes(offsets[25], _previousBillingDate);
    writer.writeBytes(offsets[26], _role);
    writer.writeBytes(offsets[27], _subscriptionPlan);
    writer.writeBytes(offsets[28], _table);
    writer.writeBytes(offsets[29], _timeZone);
    writer.writeBytes(offsets[30], _type);
    writer.writeBytes(offsets[31], _typeId);
    writer.writeBytes(offsets[32], _userId);
  }

  @override
  BusinessSync deserialize(IsarCollection<BusinessSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = BusinessSync(
      active: reader.readBoolOrNull(offsets[0]),
      backUpEnabled: reader.readBoolOrNull(offsets[1]),
      backupFileId: reader.readStringOrNull(offsets[2]),
      businessUrl: reader.readStringOrNull(offsets[3]),
      channels: reader.readStringList(offsets[4]),
      chatUid: reader.readStringOrNull(offsets[5]),
      country: reader.readString(offsets[6]),
      currency: reader.readStringOrNull(offsets[8]),
      deviceToken: reader.readStringOrNull(offsets[9]),
      email: reader.readStringOrNull(offsets[10]),
      fcategoryId: reader.readLongOrNull(offsets[11]),
      firstName: reader.readStringOrNull(offsets[12]),
      fullName: reader.readStringOrNull(offsets[13]),
      hexColor: reader.readStringOrNull(offsets[14]),
      imageUrl: reader.readStringOrNull(offsets[15]),
      isLastSubscriptionPaymentSucceeded: reader.readBoolOrNull(offsets[16]),
      lastDbBackup: reader.readStringOrNull(offsets[17]),
      lastName: reader.readStringOrNull(offsets[18]),
      lastSeen: reader.readLongOrNull(offsets[19]),
      latitude: reader.readString(offsets[20]),
      longitude: reader.readString(offsets[21]),
      metadata: reader.readStringOrNull(offsets[22]),
      name: reader.readString(offsets[23]),
      nextBillingDate: reader.readStringOrNull(offsets[24]),
      previousBillingDate: reader.readStringOrNull(offsets[25]),
      role: reader.readStringOrNull(offsets[26]),
      subscriptionPlan: reader.readStringOrNull(offsets[27]),
      table: reader.readStringOrNull(offsets[28]),
      timeZone: reader.readStringOrNull(offsets[29]),
      type: reader.readString(offsets[30]),
      typeId: reader.readStringOrNull(offsets[31]),
      userId: reader.readStringOrNull(offsets[32]),
    );
    object.createdAt = reader.readStringOrNull(offsets[7]);
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readBoolOrNull(offset)) as P;
      case 1:
        return (reader.readBoolOrNull(offset)) as P;
      case 2:
        return (reader.readStringOrNull(offset)) as P;
      case 3:
        return (reader.readStringOrNull(offset)) as P;
      case 4:
        return (reader.readStringList(offset)) as P;
      case 5:
        return (reader.readStringOrNull(offset)) as P;
      case 6:
        return (reader.readString(offset)) as P;
      case 7:
        return (reader.readStringOrNull(offset)) as P;
      case 8:
        return (reader.readStringOrNull(offset)) as P;
      case 9:
        return (reader.readStringOrNull(offset)) as P;
      case 10:
        return (reader.readStringOrNull(offset)) as P;
      case 11:
        return (reader.readLongOrNull(offset)) as P;
      case 12:
        return (reader.readStringOrNull(offset)) as P;
      case 13:
        return (reader.readStringOrNull(offset)) as P;
      case 14:
        return (reader.readStringOrNull(offset)) as P;
      case 15:
        return (reader.readStringOrNull(offset)) as P;
      case 16:
        return (reader.readBoolOrNull(offset)) as P;
      case 17:
        return (reader.readStringOrNull(offset)) as P;
      case 18:
        return (reader.readStringOrNull(offset)) as P;
      case 19:
        return (reader.readLongOrNull(offset)) as P;
      case 20:
        return (reader.readString(offset)) as P;
      case 21:
        return (reader.readString(offset)) as P;
      case 22:
        return (reader.readStringOrNull(offset)) as P;
      case 23:
        return (reader.readString(offset)) as P;
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
        return (reader.readString(offset)) as P;
      case 31:
        return (reader.readStringOrNull(offset)) as P;
      case 32:
        return (reader.readStringOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, BusinessSync object) {}
}

extension BusinessSyncQueryWhereSort
    on QueryBuilder<BusinessSync, BusinessSync, QWhere> {
  QueryBuilder<BusinessSync, BusinessSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension BusinessSyncQueryWhere
    on QueryBuilder<BusinessSync, BusinessSync, QWhereClause> {
  QueryBuilder<BusinessSync, BusinessSync, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterWhereClause> idNotEqualTo(
      int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension BusinessSyncQueryFilter
    on QueryBuilder<BusinessSync, BusinessSync, QFilterCondition> {
  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      activeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'active',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> activeEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backUpEnabledIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'backUpEnabled',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backUpEnabledEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'backUpEnabled',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'backupFileId',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'backupFileId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      backupFileIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'backupFileId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'businessUrl',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'businessUrl',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      businessUrlMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'businessUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'channels',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      channelsAnyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'channels',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'chatUid',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'chatUid',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      chatUidMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'chatUid',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'country',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      countryMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'country',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'createdAt',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'currency',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'currency',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'currency',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'deviceToken',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'deviceToken',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      deviceTokenMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'deviceToken',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      emailIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'email',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      emailGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> emailLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'email',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'email',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fcategoryIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fcategoryId',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fcategoryIdEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fcategoryId',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fcategoryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fcategoryId',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fcategoryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fcategoryId',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fcategoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fcategoryId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'firstName',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'firstName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      firstNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'firstName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fullName',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fullName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      fullNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fullName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'hexColor',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'hexColor',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      hexColorMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'hexColor',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'imageUrl',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'imageUrl',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'imageUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      isLastSubscriptionPaymentSucceededIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isLastSubscriptionPaymentSucceeded',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      isLastSubscriptionPaymentSucceededEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isLastSubscriptionPaymentSucceeded',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastDbBackup',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastDbBackup',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastDbBackupMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastDbBackup',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastName',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastSeenIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastSeen',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastSeenEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastSeen',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastSeenGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastSeen',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastSeenLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastSeen',
      value: value,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      lastSeenBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastSeen',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'latitude',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      latitudeMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'latitude',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'longitude',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      longitudeMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'longitude',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'metadata',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'metadata',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      metadataMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'metadata',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'nextBillingDate',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'nextBillingDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      nextBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'nextBillingDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'previousBillingDate',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'previousBillingDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      previousBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'previousBillingDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'role',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      roleGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'role',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      roleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> roleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'role',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'subscriptionPlan',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'subscriptionPlan',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      subscriptionPlanMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'subscriptionPlan',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> tableEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      tableGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> tableLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> tableBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'table',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'timeZone',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'timeZone',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      timeZoneMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'timeZone',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'type',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'typeId',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'typeId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      typeIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> typeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'typeId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      userIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'userId',
      value: null,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'userId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'userId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension BusinessSyncQueryWhereSortBy
    on QueryBuilder<BusinessSync, BusinessSync, QSortBy> {
  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByBackUpEnabled() {
    return addSortByInternal('backUpEnabled', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByBackUpEnabledDesc() {
    return addSortByInternal('backUpEnabled', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByBackupFileId() {
    return addSortByInternal('backupFileId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByBackupFileIdDesc() {
    return addSortByInternal('backupFileId', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByBusinessUrl() {
    return addSortByInternal('businessUrl', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByBusinessUrlDesc() {
    return addSortByInternal('businessUrl', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByChatUid() {
    return addSortByInternal('chatUid', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByChatUidDesc() {
    return addSortByInternal('chatUid', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByCountry() {
    return addSortByInternal('country', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByCountryDesc() {
    return addSortByInternal('country', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByCurrency() {
    return addSortByInternal('currency', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByCurrencyDesc() {
    return addSortByInternal('currency', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByDeviceToken() {
    return addSortByInternal('deviceToken', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByDeviceTokenDesc() {
    return addSortByInternal('deviceToken', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByFcategoryId() {
    return addSortByInternal('fcategoryId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByFcategoryIdDesc() {
    return addSortByInternal('fcategoryId', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByHexColor() {
    return addSortByInternal('hexColor', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByHexColorDesc() {
    return addSortByInternal('hexColor', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByIsLastSubscriptionPaymentSucceeded() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByIsLastSubscriptionPaymentSucceededDesc() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLastDbBackup() {
    return addSortByInternal('lastDbBackup', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByLastDbBackupDesc() {
    return addSortByInternal('lastDbBackup', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLastSeen() {
    return addSortByInternal('lastSeen', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLastSeenDesc() {
    return addSortByInternal('lastSeen', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLatitude() {
    return addSortByInternal('latitude', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLatitudeDesc() {
    return addSortByInternal('latitude', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLongitude() {
    return addSortByInternal('longitude', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByLongitudeDesc() {
    return addSortByInternal('longitude', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByMetadata() {
    return addSortByInternal('metadata', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByMetadataDesc() {
    return addSortByInternal('metadata', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByNextBillingDate() {
    return addSortByInternal('nextBillingDate', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByNextBillingDateDesc() {
    return addSortByInternal('nextBillingDate', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByPreviousBillingDate() {
    return addSortByInternal('previousBillingDate', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortByPreviousBillingDateDesc() {
    return addSortByInternal('previousBillingDate', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByRole() {
    return addSortByInternal('role', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByRoleDesc() {
    return addSortByInternal('role', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortBySubscriptionPlan() {
    return addSortByInternal('subscriptionPlan', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      sortBySubscriptionPlanDesc() {
    return addSortByInternal('subscriptionPlan', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTimeZone() {
    return addSortByInternal('timeZone', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTimeZoneDesc() {
    return addSortByInternal('timeZone', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTypeId() {
    return addSortByInternal('typeId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByTypeIdDesc() {
    return addSortByInternal('typeId', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension BusinessSyncQueryWhereSortThenBy
    on QueryBuilder<BusinessSync, BusinessSync, QSortThenBy> {
  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByBackUpEnabled() {
    return addSortByInternal('backUpEnabled', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByBackUpEnabledDesc() {
    return addSortByInternal('backUpEnabled', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByBackupFileId() {
    return addSortByInternal('backupFileId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByBackupFileIdDesc() {
    return addSortByInternal('backupFileId', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByBusinessUrl() {
    return addSortByInternal('businessUrl', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByBusinessUrlDesc() {
    return addSortByInternal('businessUrl', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByChatUid() {
    return addSortByInternal('chatUid', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByChatUidDesc() {
    return addSortByInternal('chatUid', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByCountry() {
    return addSortByInternal('country', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByCountryDesc() {
    return addSortByInternal('country', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByCurrency() {
    return addSortByInternal('currency', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByCurrencyDesc() {
    return addSortByInternal('currency', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByDeviceToken() {
    return addSortByInternal('deviceToken', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByDeviceTokenDesc() {
    return addSortByInternal('deviceToken', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByFcategoryId() {
    return addSortByInternal('fcategoryId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByFcategoryIdDesc() {
    return addSortByInternal('fcategoryId', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByHexColor() {
    return addSortByInternal('hexColor', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByHexColorDesc() {
    return addSortByInternal('hexColor', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByIsLastSubscriptionPaymentSucceeded() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByIsLastSubscriptionPaymentSucceededDesc() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLastDbBackup() {
    return addSortByInternal('lastDbBackup', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByLastDbBackupDesc() {
    return addSortByInternal('lastDbBackup', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLastSeen() {
    return addSortByInternal('lastSeen', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLastSeenDesc() {
    return addSortByInternal('lastSeen', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLatitude() {
    return addSortByInternal('latitude', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLatitudeDesc() {
    return addSortByInternal('latitude', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLongitude() {
    return addSortByInternal('longitude', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByLongitudeDesc() {
    return addSortByInternal('longitude', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByMetadata() {
    return addSortByInternal('metadata', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByMetadataDesc() {
    return addSortByInternal('metadata', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByNextBillingDate() {
    return addSortByInternal('nextBillingDate', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByNextBillingDateDesc() {
    return addSortByInternal('nextBillingDate', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByPreviousBillingDate() {
    return addSortByInternal('previousBillingDate', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenByPreviousBillingDateDesc() {
    return addSortByInternal('previousBillingDate', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByRole() {
    return addSortByInternal('role', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByRoleDesc() {
    return addSortByInternal('role', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenBySubscriptionPlan() {
    return addSortByInternal('subscriptionPlan', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy>
      thenBySubscriptionPlanDesc() {
    return addSortByInternal('subscriptionPlan', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTimeZone() {
    return addSortByInternal('timeZone', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTimeZoneDesc() {
    return addSortByInternal('timeZone', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTypeId() {
    return addSortByInternal('typeId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByTypeIdDesc() {
    return addSortByInternal('typeId', Sort.desc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<BusinessSync, BusinessSync, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension BusinessSyncQueryWhereDistinct
    on QueryBuilder<BusinessSync, BusinessSync, QDistinct> {
  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct>
      distinctByBackUpEnabled() {
    return addDistinctByInternal('backUpEnabled');
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByBackupFileId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('backupFileId', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByBusinessUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('businessUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByChatUid(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('chatUid', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByCountry(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('country', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('currency', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByDeviceToken(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('deviceToken', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('email', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByFcategoryId() {
    return addDistinctByInternal('fcategoryId');
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByFirstName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('firstName', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fullName', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByHexColor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('hexColor', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('imageUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct>
      distinctByIsLastSubscriptionPaymentSucceeded() {
    return addDistinctByInternal('isLastSubscriptionPaymentSucceeded');
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByLastDbBackup(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastDbBackup', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByLastName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastName', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByLastSeen() {
    return addDistinctByInternal('lastSeen');
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByLatitude(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('latitude', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByLongitude(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('longitude', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByMetadata(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('metadata', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByNextBillingDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('nextBillingDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct>
      distinctByPreviousBillingDate({bool caseSensitive = true}) {
    return addDistinctByInternal('previousBillingDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByRole(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('role', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct>
      distinctBySubscriptionPlan({bool caseSensitive = true}) {
    return addDistinctByInternal('subscriptionPlan',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByTimeZone(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('timeZone', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByTypeId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('typeId', caseSensitive: caseSensitive);
  }

  QueryBuilder<BusinessSync, BusinessSync, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('userId', caseSensitive: caseSensitive);
  }
}

extension BusinessSyncQueryProperty
    on QueryBuilder<BusinessSync, BusinessSync, QQueryProperty> {
  QueryBuilder<BusinessSync, bool?, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<BusinessSync, bool?, QQueryOperations> backUpEnabledProperty() {
    return addPropertyNameInternal('backUpEnabled');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> backupFileIdProperty() {
    return addPropertyNameInternal('backupFileId');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> businessUrlProperty() {
    return addPropertyNameInternal('businessUrl');
  }

  QueryBuilder<BusinessSync, List<String>?, QQueryOperations>
      channelsProperty() {
    return addPropertyNameInternal('channels');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> chatUidProperty() {
    return addPropertyNameInternal('chatUid');
  }

  QueryBuilder<BusinessSync, String, QQueryOperations> countryProperty() {
    return addPropertyNameInternal('country');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> currencyProperty() {
    return addPropertyNameInternal('currency');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> deviceTokenProperty() {
    return addPropertyNameInternal('deviceToken');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> emailProperty() {
    return addPropertyNameInternal('email');
  }

  QueryBuilder<BusinessSync, int?, QQueryOperations> fcategoryIdProperty() {
    return addPropertyNameInternal('fcategoryId');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> firstNameProperty() {
    return addPropertyNameInternal('firstName');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> fullNameProperty() {
    return addPropertyNameInternal('fullName');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> hexColorProperty() {
    return addPropertyNameInternal('hexColor');
  }

  QueryBuilder<BusinessSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> imageUrlProperty() {
    return addPropertyNameInternal('imageUrl');
  }

  QueryBuilder<BusinessSync, bool?, QQueryOperations>
      isLastSubscriptionPaymentSucceededProperty() {
    return addPropertyNameInternal('isLastSubscriptionPaymentSucceeded');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> lastDbBackupProperty() {
    return addPropertyNameInternal('lastDbBackup');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> lastNameProperty() {
    return addPropertyNameInternal('lastName');
  }

  QueryBuilder<BusinessSync, int?, QQueryOperations> lastSeenProperty() {
    return addPropertyNameInternal('lastSeen');
  }

  QueryBuilder<BusinessSync, String, QQueryOperations> latitudeProperty() {
    return addPropertyNameInternal('latitude');
  }

  QueryBuilder<BusinessSync, String, QQueryOperations> longitudeProperty() {
    return addPropertyNameInternal('longitude');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> metadataProperty() {
    return addPropertyNameInternal('metadata');
  }

  QueryBuilder<BusinessSync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations>
      nextBillingDateProperty() {
    return addPropertyNameInternal('nextBillingDate');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations>
      previousBillingDateProperty() {
    return addPropertyNameInternal('previousBillingDate');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> roleProperty() {
    return addPropertyNameInternal('role');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations>
      subscriptionPlanProperty() {
    return addPropertyNameInternal('subscriptionPlan');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> timeZoneProperty() {
    return addPropertyNameInternal('timeZone');
  }

  QueryBuilder<BusinessSync, String, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> typeIdProperty() {
    return addPropertyNameInternal('typeId');
  }

  QueryBuilder<BusinessSync, String?, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }
}
