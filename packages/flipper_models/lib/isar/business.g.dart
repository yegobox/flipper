// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetBusinessCollection on Isar {
  IsarCollection<Business> get businesss {
    return getCollection('Business');
  }
}

final BusinessSchema = CollectionSchema(
  name: 'Business',
  schema:
      '{"name":"Business","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"backUpEnabled","type":"Bool"},{"name":"backupFileId","type":"String"},{"name":"bhfId","type":"String"},{"name":"businessUrl","type":"String"},{"name":"channels","type":"StringList"},{"name":"chatUid","type":"String"},{"name":"country","type":"String"},{"name":"createdAt","type":"String"},{"name":"currency","type":"String"},{"name":"deviceToken","type":"String"},{"name":"dvcSrlNo","type":"String"},{"name":"email","type":"String"},{"name":"fcategoryId","type":"Long"},{"name":"firstName","type":"String"},{"name":"fullName","type":"String"},{"name":"hexColor","type":"String"},{"name":"imageUrl","type":"String"},{"name":"isLastSubscriptionPaymentSucceeded","type":"Bool"},{"name":"lastDbBackup","type":"String"},{"name":"lastName","type":"String"},{"name":"lastSeen","type":"Long"},{"name":"latitude","type":"String"},{"name":"longitude","type":"String"},{"name":"metadata","type":"String"},{"name":"name","type":"String"},{"name":"nextBillingDate","type":"String"},{"name":"previousBillingDate","type":"String"},{"name":"role","type":"String"},{"name":"subscriptionPlan","type":"String"},{"name":"table","type":"String"},{"name":"timeZone","type":"String"},{"name":"tinNumber","type":"String"},{"name":"type","type":"String"},{"name":"typeId","type":"String"},{"name":"userId","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _BusinessNativeAdapter(),
  webAdapter: const _BusinessWebAdapter(),
  idName: 'id',
  propertyIds: {
    'active': 0,
    'backUpEnabled': 1,
    'backupFileId': 2,
    'bhfId': 3,
    'businessUrl': 4,
    'channels': 5,
    'chatUid': 6,
    'country': 7,
    'createdAt': 8,
    'currency': 9,
    'deviceToken': 10,
    'dvcSrlNo': 11,
    'email': 12,
    'fcategoryId': 13,
    'firstName': 14,
    'fullName': 15,
    'hexColor': 16,
    'imageUrl': 17,
    'isLastSubscriptionPaymentSucceeded': 18,
    'lastDbBackup': 19,
    'lastName': 20,
    'lastSeen': 21,
    'latitude': 22,
    'longitude': 23,
    'metadata': 24,
    'name': 25,
    'nextBillingDate': 26,
    'previousBillingDate': 27,
    'role': 28,
    'subscriptionPlan': 29,
    'table': 30,
    'timeZone': 31,
    'tinNumber': 32,
    'type': 33,
    'typeId': 34,
    'userId': 35
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

class _BusinessWebAdapter extends IsarWebTypeAdapter<Business> {
  const _BusinessWebAdapter();

  @override
  Object serialize(IsarCollection<Business> collection, Business object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'active', object.active);
    IsarNative.jsObjectSet(jsObj, 'backUpEnabled', object.backUpEnabled);
    IsarNative.jsObjectSet(jsObj, 'backupFileId', object.backupFileId);
    IsarNative.jsObjectSet(jsObj, 'bhfId', object.bhfId);
    IsarNative.jsObjectSet(jsObj, 'businessUrl', object.businessUrl);
    IsarNative.jsObjectSet(jsObj, 'channels', object.channels);
    IsarNative.jsObjectSet(jsObj, 'chatUid', object.chatUid);
    IsarNative.jsObjectSet(jsObj, 'country', object.country);
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(jsObj, 'currency', object.currency);
    IsarNative.jsObjectSet(jsObj, 'deviceToken', object.deviceToken);
    IsarNative.jsObjectSet(jsObj, 'dvcSrlNo', object.dvcSrlNo);
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
    IsarNative.jsObjectSet(jsObj, 'tinNumber', object.tinNumber);
    IsarNative.jsObjectSet(jsObj, 'type', object.type);
    IsarNative.jsObjectSet(jsObj, 'typeId', object.typeId);
    IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
    return jsObj;
  }

  @override
  Business deserialize(IsarCollection<Business> collection, dynamic jsObj) {
    final object = Business();
    object.active = IsarNative.jsObjectGet(jsObj, 'active');
    object.backUpEnabled = IsarNative.jsObjectGet(jsObj, 'backUpEnabled');
    object.backupFileId = IsarNative.jsObjectGet(jsObj, 'backupFileId');
    object.bhfId = IsarNative.jsObjectGet(jsObj, 'bhfId');
    object.businessUrl = IsarNative.jsObjectGet(jsObj, 'businessUrl');
    object.channels = (IsarNative.jsObjectGet(jsObj, 'channels') as List?)
        ?.map((e) => e ?? '')
        .toList()
        .cast<String>();
    object.chatUid = IsarNative.jsObjectGet(jsObj, 'chatUid');
    object.country = IsarNative.jsObjectGet(jsObj, 'country');
    object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt');
    object.currency = IsarNative.jsObjectGet(jsObj, 'currency');
    object.deviceToken = IsarNative.jsObjectGet(jsObj, 'deviceToken');
    object.dvcSrlNo = IsarNative.jsObjectGet(jsObj, 'dvcSrlNo');
    object.email = IsarNative.jsObjectGet(jsObj, 'email');
    object.fcategoryId = IsarNative.jsObjectGet(jsObj, 'fcategoryId');
    object.firstName = IsarNative.jsObjectGet(jsObj, 'firstName');
    object.fullName = IsarNative.jsObjectGet(jsObj, 'fullName');
    object.hexColor = IsarNative.jsObjectGet(jsObj, 'hexColor');
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.imageUrl = IsarNative.jsObjectGet(jsObj, 'imageUrl');
    object.isLastSubscriptionPaymentSucceeded =
        IsarNative.jsObjectGet(jsObj, 'isLastSubscriptionPaymentSucceeded');
    object.lastDbBackup = IsarNative.jsObjectGet(jsObj, 'lastDbBackup');
    object.lastName = IsarNative.jsObjectGet(jsObj, 'lastName');
    object.lastSeen = IsarNative.jsObjectGet(jsObj, 'lastSeen');
    object.latitude = IsarNative.jsObjectGet(jsObj, 'latitude');
    object.longitude = IsarNative.jsObjectGet(jsObj, 'longitude');
    object.metadata = IsarNative.jsObjectGet(jsObj, 'metadata');
    object.name = IsarNative.jsObjectGet(jsObj, 'name');
    object.nextBillingDate = IsarNative.jsObjectGet(jsObj, 'nextBillingDate');
    object.previousBillingDate =
        IsarNative.jsObjectGet(jsObj, 'previousBillingDate');
    object.role = IsarNative.jsObjectGet(jsObj, 'role');
    object.subscriptionPlan = IsarNative.jsObjectGet(jsObj, 'subscriptionPlan');
    object.table = IsarNative.jsObjectGet(jsObj, 'table');
    object.timeZone = IsarNative.jsObjectGet(jsObj, 'timeZone');
    object.tinNumber = IsarNative.jsObjectGet(jsObj, 'tinNumber');
    object.type = IsarNative.jsObjectGet(jsObj, 'type');
    object.typeId = IsarNative.jsObjectGet(jsObj, 'typeId');
    object.userId = IsarNative.jsObjectGet(jsObj, 'userId');
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
      case 'bhfId':
        return (IsarNative.jsObjectGet(jsObj, 'bhfId')) as P;
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
        return (IsarNative.jsObjectGet(jsObj, 'country')) as P;
      case 'createdAt':
        return (IsarNative.jsObjectGet(jsObj, 'createdAt')) as P;
      case 'currency':
        return (IsarNative.jsObjectGet(jsObj, 'currency')) as P;
      case 'deviceToken':
        return (IsarNative.jsObjectGet(jsObj, 'deviceToken')) as P;
      case 'dvcSrlNo':
        return (IsarNative.jsObjectGet(jsObj, 'dvcSrlNo')) as P;
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
        return (IsarNative.jsObjectGet(jsObj, 'latitude')) as P;
      case 'longitude':
        return (IsarNative.jsObjectGet(jsObj, 'longitude')) as P;
      case 'metadata':
        return (IsarNative.jsObjectGet(jsObj, 'metadata')) as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name')) as P;
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
      case 'tinNumber':
        return (IsarNative.jsObjectGet(jsObj, 'tinNumber')) as P;
      case 'type':
        return (IsarNative.jsObjectGet(jsObj, 'type')) as P;
      case 'typeId':
        return (IsarNative.jsObjectGet(jsObj, 'typeId')) as P;
      case 'userId':
        return (IsarNative.jsObjectGet(jsObj, 'userId')) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Business object) {}
}

class _BusinessNativeAdapter extends IsarNativeTypeAdapter<Business> {
  const _BusinessNativeAdapter();

  @override
  void serialize(IsarCollection<Business> collection, IsarRawObject rawObj,
      Business object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
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
    final value3 = object.bhfId;
    IsarUint8List? _bhfId;
    if (value3 != null) {
      _bhfId = IsarBinaryWriter.utf8Encoder.convert(value3);
    }
    dynamicSize += (_bhfId?.length ?? 0) as int;
    final value4 = object.businessUrl;
    IsarUint8List? _businessUrl;
    if (value4 != null) {
      _businessUrl = IsarBinaryWriter.utf8Encoder.convert(value4);
    }
    dynamicSize += (_businessUrl?.length ?? 0) as int;
    final value5 = object.channels;
    dynamicSize += (value5?.length ?? 0) * 8;
    List<IsarUint8List?>? bytesList5;
    if (value5 != null) {
      bytesList5 = [];
      for (var str in value5) {
        final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
        bytesList5.add(bytes);
        dynamicSize += bytes.length as int;
      }
    }
    final _channels = bytesList5;
    final value6 = object.chatUid;
    IsarUint8List? _chatUid;
    if (value6 != null) {
      _chatUid = IsarBinaryWriter.utf8Encoder.convert(value6);
    }
    dynamicSize += (_chatUid?.length ?? 0) as int;
    final value7 = object.country;
    IsarUint8List? _country;
    if (value7 != null) {
      _country = IsarBinaryWriter.utf8Encoder.convert(value7);
    }
    dynamicSize += (_country?.length ?? 0) as int;
    final value8 = object.createdAt;
    IsarUint8List? _createdAt;
    if (value8 != null) {
      _createdAt = IsarBinaryWriter.utf8Encoder.convert(value8);
    }
    dynamicSize += (_createdAt?.length ?? 0) as int;
    final value9 = object.currency;
    IsarUint8List? _currency;
    if (value9 != null) {
      _currency = IsarBinaryWriter.utf8Encoder.convert(value9);
    }
    dynamicSize += (_currency?.length ?? 0) as int;
    final value10 = object.deviceToken;
    IsarUint8List? _deviceToken;
    if (value10 != null) {
      _deviceToken = IsarBinaryWriter.utf8Encoder.convert(value10);
    }
    dynamicSize += (_deviceToken?.length ?? 0) as int;
    final value11 = object.dvcSrlNo;
    IsarUint8List? _dvcSrlNo;
    if (value11 != null) {
      _dvcSrlNo = IsarBinaryWriter.utf8Encoder.convert(value11);
    }
    dynamicSize += (_dvcSrlNo?.length ?? 0) as int;
    final value12 = object.email;
    IsarUint8List? _email;
    if (value12 != null) {
      _email = IsarBinaryWriter.utf8Encoder.convert(value12);
    }
    dynamicSize += (_email?.length ?? 0) as int;
    final value13 = object.fcategoryId;
    final _fcategoryId = value13;
    final value14 = object.firstName;
    IsarUint8List? _firstName;
    if (value14 != null) {
      _firstName = IsarBinaryWriter.utf8Encoder.convert(value14);
    }
    dynamicSize += (_firstName?.length ?? 0) as int;
    final value15 = object.fullName;
    IsarUint8List? _fullName;
    if (value15 != null) {
      _fullName = IsarBinaryWriter.utf8Encoder.convert(value15);
    }
    dynamicSize += (_fullName?.length ?? 0) as int;
    final value16 = object.hexColor;
    IsarUint8List? _hexColor;
    if (value16 != null) {
      _hexColor = IsarBinaryWriter.utf8Encoder.convert(value16);
    }
    dynamicSize += (_hexColor?.length ?? 0) as int;
    final value17 = object.imageUrl;
    IsarUint8List? _imageUrl;
    if (value17 != null) {
      _imageUrl = IsarBinaryWriter.utf8Encoder.convert(value17);
    }
    dynamicSize += (_imageUrl?.length ?? 0) as int;
    final value18 = object.isLastSubscriptionPaymentSucceeded;
    final _isLastSubscriptionPaymentSucceeded = value18;
    final value19 = object.lastDbBackup;
    IsarUint8List? _lastDbBackup;
    if (value19 != null) {
      _lastDbBackup = IsarBinaryWriter.utf8Encoder.convert(value19);
    }
    dynamicSize += (_lastDbBackup?.length ?? 0) as int;
    final value20 = object.lastName;
    IsarUint8List? _lastName;
    if (value20 != null) {
      _lastName = IsarBinaryWriter.utf8Encoder.convert(value20);
    }
    dynamicSize += (_lastName?.length ?? 0) as int;
    final value21 = object.lastSeen;
    final _lastSeen = value21;
    final value22 = object.latitude;
    IsarUint8List? _latitude;
    if (value22 != null) {
      _latitude = IsarBinaryWriter.utf8Encoder.convert(value22);
    }
    dynamicSize += (_latitude?.length ?? 0) as int;
    final value23 = object.longitude;
    IsarUint8List? _longitude;
    if (value23 != null) {
      _longitude = IsarBinaryWriter.utf8Encoder.convert(value23);
    }
    dynamicSize += (_longitude?.length ?? 0) as int;
    final value24 = object.metadata;
    IsarUint8List? _metadata;
    if (value24 != null) {
      _metadata = IsarBinaryWriter.utf8Encoder.convert(value24);
    }
    dynamicSize += (_metadata?.length ?? 0) as int;
    final value25 = object.name;
    IsarUint8List? _name;
    if (value25 != null) {
      _name = IsarBinaryWriter.utf8Encoder.convert(value25);
    }
    dynamicSize += (_name?.length ?? 0) as int;
    final value26 = object.nextBillingDate;
    IsarUint8List? _nextBillingDate;
    if (value26 != null) {
      _nextBillingDate = IsarBinaryWriter.utf8Encoder.convert(value26);
    }
    dynamicSize += (_nextBillingDate?.length ?? 0) as int;
    final value27 = object.previousBillingDate;
    IsarUint8List? _previousBillingDate;
    if (value27 != null) {
      _previousBillingDate = IsarBinaryWriter.utf8Encoder.convert(value27);
    }
    dynamicSize += (_previousBillingDate?.length ?? 0) as int;
    final value28 = object.role;
    IsarUint8List? _role;
    if (value28 != null) {
      _role = IsarBinaryWriter.utf8Encoder.convert(value28);
    }
    dynamicSize += (_role?.length ?? 0) as int;
    final value29 = object.subscriptionPlan;
    IsarUint8List? _subscriptionPlan;
    if (value29 != null) {
      _subscriptionPlan = IsarBinaryWriter.utf8Encoder.convert(value29);
    }
    dynamicSize += (_subscriptionPlan?.length ?? 0) as int;
    final value30 = object.table;
    IsarUint8List? _table;
    if (value30 != null) {
      _table = IsarBinaryWriter.utf8Encoder.convert(value30);
    }
    dynamicSize += (_table?.length ?? 0) as int;
    final value31 = object.timeZone;
    IsarUint8List? _timeZone;
    if (value31 != null) {
      _timeZone = IsarBinaryWriter.utf8Encoder.convert(value31);
    }
    dynamicSize += (_timeZone?.length ?? 0) as int;
    final value32 = object.tinNumber;
    IsarUint8List? _tinNumber;
    if (value32 != null) {
      _tinNumber = IsarBinaryWriter.utf8Encoder.convert(value32);
    }
    dynamicSize += (_tinNumber?.length ?? 0) as int;
    final value33 = object.type;
    IsarUint8List? _type;
    if (value33 != null) {
      _type = IsarBinaryWriter.utf8Encoder.convert(value33);
    }
    dynamicSize += (_type?.length ?? 0) as int;
    final value34 = object.typeId;
    IsarUint8List? _typeId;
    if (value34 != null) {
      _typeId = IsarBinaryWriter.utf8Encoder.convert(value34);
    }
    dynamicSize += (_typeId?.length ?? 0) as int;
    final value35 = object.userId;
    IsarUint8List? _userId;
    if (value35 != null) {
      _userId = IsarBinaryWriter.utf8Encoder.convert(value35);
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
    writer.writeBytes(offsets[3], _bhfId);
    writer.writeBytes(offsets[4], _businessUrl);
    writer.writeStringList(offsets[5], _channels);
    writer.writeBytes(offsets[6], _chatUid);
    writer.writeBytes(offsets[7], _country);
    writer.writeBytes(offsets[8], _createdAt);
    writer.writeBytes(offsets[9], _currency);
    writer.writeBytes(offsets[10], _deviceToken);
    writer.writeBytes(offsets[11], _dvcSrlNo);
    writer.writeBytes(offsets[12], _email);
    writer.writeLong(offsets[13], _fcategoryId);
    writer.writeBytes(offsets[14], _firstName);
    writer.writeBytes(offsets[15], _fullName);
    writer.writeBytes(offsets[16], _hexColor);
    writer.writeBytes(offsets[17], _imageUrl);
    writer.writeBool(offsets[18], _isLastSubscriptionPaymentSucceeded);
    writer.writeBytes(offsets[19], _lastDbBackup);
    writer.writeBytes(offsets[20], _lastName);
    writer.writeLong(offsets[21], _lastSeen);
    writer.writeBytes(offsets[22], _latitude);
    writer.writeBytes(offsets[23], _longitude);
    writer.writeBytes(offsets[24], _metadata);
    writer.writeBytes(offsets[25], _name);
    writer.writeBytes(offsets[26], _nextBillingDate);
    writer.writeBytes(offsets[27], _previousBillingDate);
    writer.writeBytes(offsets[28], _role);
    writer.writeBytes(offsets[29], _subscriptionPlan);
    writer.writeBytes(offsets[30], _table);
    writer.writeBytes(offsets[31], _timeZone);
    writer.writeBytes(offsets[32], _tinNumber);
    writer.writeBytes(offsets[33], _type);
    writer.writeBytes(offsets[34], _typeId);
    writer.writeBytes(offsets[35], _userId);
  }

  @override
  Business deserialize(IsarCollection<Business> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Business();
    object.active = reader.readBoolOrNull(offsets[0]);
    object.backUpEnabled = reader.readBoolOrNull(offsets[1]);
    object.backupFileId = reader.readStringOrNull(offsets[2]);
    object.bhfId = reader.readStringOrNull(offsets[3]);
    object.businessUrl = reader.readStringOrNull(offsets[4]);
    object.channels = reader.readStringList(offsets[5]);
    object.chatUid = reader.readStringOrNull(offsets[6]);
    object.country = reader.readStringOrNull(offsets[7]);
    object.createdAt = reader.readStringOrNull(offsets[8]);
    object.currency = reader.readStringOrNull(offsets[9]);
    object.deviceToken = reader.readStringOrNull(offsets[10]);
    object.dvcSrlNo = reader.readStringOrNull(offsets[11]);
    object.email = reader.readStringOrNull(offsets[12]);
    object.fcategoryId = reader.readLongOrNull(offsets[13]);
    object.firstName = reader.readStringOrNull(offsets[14]);
    object.fullName = reader.readStringOrNull(offsets[15]);
    object.hexColor = reader.readStringOrNull(offsets[16]);
    object.id = id;
    object.imageUrl = reader.readStringOrNull(offsets[17]);
    object.isLastSubscriptionPaymentSucceeded =
        reader.readBoolOrNull(offsets[18]);
    object.lastDbBackup = reader.readStringOrNull(offsets[19]);
    object.lastName = reader.readStringOrNull(offsets[20]);
    object.lastSeen = reader.readLongOrNull(offsets[21]);
    object.latitude = reader.readStringOrNull(offsets[22]);
    object.longitude = reader.readStringOrNull(offsets[23]);
    object.metadata = reader.readStringOrNull(offsets[24]);
    object.name = reader.readStringOrNull(offsets[25]);
    object.nextBillingDate = reader.readStringOrNull(offsets[26]);
    object.previousBillingDate = reader.readStringOrNull(offsets[27]);
    object.role = reader.readStringOrNull(offsets[28]);
    object.subscriptionPlan = reader.readStringOrNull(offsets[29]);
    object.table = reader.readStringOrNull(offsets[30]);
    object.timeZone = reader.readStringOrNull(offsets[31]);
    object.tinNumber = reader.readStringOrNull(offsets[32]);
    object.type = reader.readStringOrNull(offsets[33]);
    object.typeId = reader.readStringOrNull(offsets[34]);
    object.userId = reader.readStringOrNull(offsets[35]);
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
        return (reader.readStringOrNull(offset)) as P;
      case 5:
        return (reader.readStringList(offset)) as P;
      case 6:
        return (reader.readStringOrNull(offset)) as P;
      case 7:
        return (reader.readStringOrNull(offset)) as P;
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
        return (reader.readLongOrNull(offset)) as P;
      case 14:
        return (reader.readStringOrNull(offset)) as P;
      case 15:
        return (reader.readStringOrNull(offset)) as P;
      case 16:
        return (reader.readStringOrNull(offset)) as P;
      case 17:
        return (reader.readStringOrNull(offset)) as P;
      case 18:
        return (reader.readBoolOrNull(offset)) as P;
      case 19:
        return (reader.readStringOrNull(offset)) as P;
      case 20:
        return (reader.readStringOrNull(offset)) as P;
      case 21:
        return (reader.readLongOrNull(offset)) as P;
      case 22:
        return (reader.readStringOrNull(offset)) as P;
      case 23:
        return (reader.readStringOrNull(offset)) as P;
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
        return (reader.readStringOrNull(offset)) as P;
      case 34:
        return (reader.readStringOrNull(offset)) as P;
      case 35:
        return (reader.readStringOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Business object) {}
}

extension BusinessQueryWhereSort on QueryBuilder<Business, Business, QWhere> {
  QueryBuilder<Business, Business, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension BusinessQueryWhere on QueryBuilder<Business, Business, QWhereClause> {
  QueryBuilder<Business, Business, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Business, Business, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Business, Business, QAfterWhereClause> idBetween(
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

extension BusinessQueryFilter
    on QueryBuilder<Business, Business, QFilterCondition> {
  QueryBuilder<Business, Business, QAfterFilterCondition> activeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'active',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> activeEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      backUpEnabledIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'backUpEnabled',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backUpEnabledEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'backUpEnabled',
      value: value,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'backupFileId',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'backupFileId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> backupFileIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'backupFileId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'bhfId',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'bhfId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'bhfId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> bhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'bhfId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'businessUrl',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'businessUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> businessUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'businessUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> channelsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'channels',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'chatUid',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'chatUid',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> chatUidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'chatUid',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'country',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryGreaterThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> countryLessThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> countryBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> countryStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> countryEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> countryContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'country',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> countryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'country',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'createdAt',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'currency',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'currency',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> currencyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'currency',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'deviceToken',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'deviceToken',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> deviceTokenMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'deviceToken',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'dvcSrlNo',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'dvcSrlNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'dvcSrlNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'dvcSrlNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dvcSrlNo',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'dvcSrlNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'dvcSrlNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'dvcSrlNo',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> dvcSrlNoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'dvcSrlNo',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'email',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> emailGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> emailLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> emailBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> emailStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> emailEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'email',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fcategoryIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fcategoryId',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fcategoryIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fcategoryId',
      value: value,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fcategoryIdLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fcategoryIdBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'firstName',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'firstName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> firstNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'firstName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fullName',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'fullName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> fullNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'fullName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'hexColor',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'hexColor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> hexColorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'hexColor',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'imageUrl',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'imageUrl',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> imageUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'imageUrl',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      isLastSubscriptionPaymentSucceededIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isLastSubscriptionPaymentSucceeded',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      isLastSubscriptionPaymentSucceededEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isLastSubscriptionPaymentSucceeded',
      value: value,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastDbBackup',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastDbBackup',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastDbBackupMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastDbBackup',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastName',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastSeen',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastSeen',
      value: value,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> lastSeenBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'latitude',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeGreaterThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeLessThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> latitudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'latitude',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'longitude',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeGreaterThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeLessThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> longitudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'longitude',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'metadata',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'metadata',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> metadataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'metadata',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'name',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameGreaterThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> nameLessThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'nextBillingDate',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      nextBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'nextBillingDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'previousBillingDate',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'previousBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      previousBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'previousBillingDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'role',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> roleGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> roleLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> roleBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> roleStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> roleEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> roleContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'role',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> roleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'role',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'subscriptionPlan',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
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

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'subscriptionPlan',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition>
      subscriptionPlanMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'subscriptionPlan',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> tableGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> tableLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> tableBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> tableStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> tableEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'timeZone',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'timeZone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> timeZoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'timeZone',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'tinNumber',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'tinNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'tinNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'tinNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'tinNumber',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'tinNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'tinNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'tinNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> tinNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'tinNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'type',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeGreaterThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeLessThan(
    String? value, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'type',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'type',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'typeId',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'typeId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> typeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'typeId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'userId',
      value: null,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdEqualTo(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdGreaterThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdBetween(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdStartsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdEndsWith(
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

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Business, Business, QAfterFilterCondition> userIdMatches(
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

extension BusinessQueryWhereSortBy
    on QueryBuilder<Business, Business, QSortBy> {
  QueryBuilder<Business, Business, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackUpEnabled() {
    return addSortByInternal('backUpEnabled', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackUpEnabledDesc() {
    return addSortByInternal('backUpEnabled', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackupFileId() {
    return addSortByInternal('backupFileId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBackupFileIdDesc() {
    return addSortByInternal('backupFileId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBhfId() {
    return addSortByInternal('bhfId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBhfIdDesc() {
    return addSortByInternal('bhfId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBusinessUrl() {
    return addSortByInternal('businessUrl', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByBusinessUrlDesc() {
    return addSortByInternal('businessUrl', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByChatUid() {
    return addSortByInternal('chatUid', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByChatUidDesc() {
    return addSortByInternal('chatUid', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCountry() {
    return addSortByInternal('country', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCountryDesc() {
    return addSortByInternal('country', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCurrency() {
    return addSortByInternal('currency', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByCurrencyDesc() {
    return addSortByInternal('currency', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDeviceToken() {
    return addSortByInternal('deviceToken', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDeviceTokenDesc() {
    return addSortByInternal('deviceToken', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDvcSrlNo() {
    return addSortByInternal('dvcSrlNo', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByDvcSrlNoDesc() {
    return addSortByInternal('dvcSrlNo', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFcategoryId() {
    return addSortByInternal('fcategoryId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFcategoryIdDesc() {
    return addSortByInternal('fcategoryId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByHexColor() {
    return addSortByInternal('hexColor', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByHexColorDesc() {
    return addSortByInternal('hexColor', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      sortByIsLastSubscriptionPaymentSucceeded() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      sortByIsLastSubscriptionPaymentSucceededDesc() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastDbBackup() {
    return addSortByInternal('lastDbBackup', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastDbBackupDesc() {
    return addSortByInternal('lastDbBackup', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastSeen() {
    return addSortByInternal('lastSeen', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLastSeenDesc() {
    return addSortByInternal('lastSeen', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLatitude() {
    return addSortByInternal('latitude', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLatitudeDesc() {
    return addSortByInternal('latitude', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLongitude() {
    return addSortByInternal('longitude', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByLongitudeDesc() {
    return addSortByInternal('longitude', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByMetadata() {
    return addSortByInternal('metadata', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByMetadataDesc() {
    return addSortByInternal('metadata', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByNextBillingDate() {
    return addSortByInternal('nextBillingDate', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByNextBillingDateDesc() {
    return addSortByInternal('nextBillingDate', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByPreviousBillingDate() {
    return addSortByInternal('previousBillingDate', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      sortByPreviousBillingDateDesc() {
    return addSortByInternal('previousBillingDate', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByRole() {
    return addSortByInternal('role', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByRoleDesc() {
    return addSortByInternal('role', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortBySubscriptionPlan() {
    return addSortByInternal('subscriptionPlan', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortBySubscriptionPlanDesc() {
    return addSortByInternal('subscriptionPlan', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTimeZone() {
    return addSortByInternal('timeZone', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTimeZoneDesc() {
    return addSortByInternal('timeZone', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTinNumber() {
    return addSortByInternal('tinNumber', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTinNumberDesc() {
    return addSortByInternal('tinNumber', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTypeId() {
    return addSortByInternal('typeId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByTypeIdDesc() {
    return addSortByInternal('typeId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension BusinessQueryWhereSortThenBy
    on QueryBuilder<Business, Business, QSortThenBy> {
  QueryBuilder<Business, Business, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackUpEnabled() {
    return addSortByInternal('backUpEnabled', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackUpEnabledDesc() {
    return addSortByInternal('backUpEnabled', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackupFileId() {
    return addSortByInternal('backupFileId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBackupFileIdDesc() {
    return addSortByInternal('backupFileId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBhfId() {
    return addSortByInternal('bhfId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBhfIdDesc() {
    return addSortByInternal('bhfId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBusinessUrl() {
    return addSortByInternal('businessUrl', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByBusinessUrlDesc() {
    return addSortByInternal('businessUrl', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByChatUid() {
    return addSortByInternal('chatUid', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByChatUidDesc() {
    return addSortByInternal('chatUid', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCountry() {
    return addSortByInternal('country', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCountryDesc() {
    return addSortByInternal('country', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCurrency() {
    return addSortByInternal('currency', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByCurrencyDesc() {
    return addSortByInternal('currency', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDeviceToken() {
    return addSortByInternal('deviceToken', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDeviceTokenDesc() {
    return addSortByInternal('deviceToken', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDvcSrlNo() {
    return addSortByInternal('dvcSrlNo', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByDvcSrlNoDesc() {
    return addSortByInternal('dvcSrlNo', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFcategoryId() {
    return addSortByInternal('fcategoryId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFcategoryIdDesc() {
    return addSortByInternal('fcategoryId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFirstName() {
    return addSortByInternal('firstName', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFirstNameDesc() {
    return addSortByInternal('firstName', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFullName() {
    return addSortByInternal('fullName', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByFullNameDesc() {
    return addSortByInternal('fullName', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByHexColor() {
    return addSortByInternal('hexColor', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByHexColorDesc() {
    return addSortByInternal('hexColor', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByImageUrl() {
    return addSortByInternal('imageUrl', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByImageUrlDesc() {
    return addSortByInternal('imageUrl', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      thenByIsLastSubscriptionPaymentSucceeded() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      thenByIsLastSubscriptionPaymentSucceededDesc() {
    return addSortByInternal('isLastSubscriptionPaymentSucceeded', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastDbBackup() {
    return addSortByInternal('lastDbBackup', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastDbBackupDesc() {
    return addSortByInternal('lastDbBackup', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastName() {
    return addSortByInternal('lastName', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastNameDesc() {
    return addSortByInternal('lastName', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastSeen() {
    return addSortByInternal('lastSeen', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLastSeenDesc() {
    return addSortByInternal('lastSeen', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLatitude() {
    return addSortByInternal('latitude', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLatitudeDesc() {
    return addSortByInternal('latitude', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLongitude() {
    return addSortByInternal('longitude', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByLongitudeDesc() {
    return addSortByInternal('longitude', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByMetadata() {
    return addSortByInternal('metadata', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByMetadataDesc() {
    return addSortByInternal('metadata', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByNextBillingDate() {
    return addSortByInternal('nextBillingDate', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByNextBillingDateDesc() {
    return addSortByInternal('nextBillingDate', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByPreviousBillingDate() {
    return addSortByInternal('previousBillingDate', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy>
      thenByPreviousBillingDateDesc() {
    return addSortByInternal('previousBillingDate', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByRole() {
    return addSortByInternal('role', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByRoleDesc() {
    return addSortByInternal('role', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenBySubscriptionPlan() {
    return addSortByInternal('subscriptionPlan', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenBySubscriptionPlanDesc() {
    return addSortByInternal('subscriptionPlan', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTimeZone() {
    return addSortByInternal('timeZone', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTimeZoneDesc() {
    return addSortByInternal('timeZone', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTinNumber() {
    return addSortByInternal('tinNumber', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTinNumberDesc() {
    return addSortByInternal('tinNumber', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByType() {
    return addSortByInternal('type', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTypeDesc() {
    return addSortByInternal('type', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTypeId() {
    return addSortByInternal('typeId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByTypeIdDesc() {
    return addSortByInternal('typeId', Sort.desc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Business, Business, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension BusinessQueryWhereDistinct
    on QueryBuilder<Business, Business, QDistinct> {
  QueryBuilder<Business, Business, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBackUpEnabled() {
    return addDistinctByInternal('backUpEnabled');
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBackupFileId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('backupFileId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('bhfId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByBusinessUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('businessUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByChatUid(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('chatUid', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCountry(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('country', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('currency', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByDeviceToken(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('deviceToken', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByDvcSrlNo(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('dvcSrlNo', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('email', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByFcategoryId() {
    return addDistinctByInternal('fcategoryId');
  }

  QueryBuilder<Business, Business, QDistinct> distinctByFirstName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('firstName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByFullName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('fullName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByHexColor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('hexColor', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Business, Business, QDistinct> distinctByImageUrl(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('imageUrl', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct>
      distinctByIsLastSubscriptionPaymentSucceeded() {
    return addDistinctByInternal('isLastSubscriptionPaymentSucceeded');
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLastDbBackup(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastDbBackup', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLastName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLastSeen() {
    return addDistinctByInternal('lastSeen');
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLatitude(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('latitude', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByLongitude(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('longitude', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByMetadata(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('metadata', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByNextBillingDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('nextBillingDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByPreviousBillingDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('previousBillingDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByRole(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('role', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctBySubscriptionPlan(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('subscriptionPlan',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTimeZone(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('timeZone', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTinNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('tinNumber', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('type', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByTypeId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('typeId', caseSensitive: caseSensitive);
  }

  QueryBuilder<Business, Business, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('userId', caseSensitive: caseSensitive);
  }
}

extension BusinessQueryProperty
    on QueryBuilder<Business, Business, QQueryProperty> {
  QueryBuilder<Business, bool?, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<Business, bool?, QQueryOperations> backUpEnabledProperty() {
    return addPropertyNameInternal('backUpEnabled');
  }

  QueryBuilder<Business, String?, QQueryOperations> backupFileIdProperty() {
    return addPropertyNameInternal('backupFileId');
  }

  QueryBuilder<Business, String?, QQueryOperations> bhfIdProperty() {
    return addPropertyNameInternal('bhfId');
  }

  QueryBuilder<Business, String?, QQueryOperations> businessUrlProperty() {
    return addPropertyNameInternal('businessUrl');
  }

  QueryBuilder<Business, List<String>?, QQueryOperations> channelsProperty() {
    return addPropertyNameInternal('channels');
  }

  QueryBuilder<Business, String?, QQueryOperations> chatUidProperty() {
    return addPropertyNameInternal('chatUid');
  }

  QueryBuilder<Business, String?, QQueryOperations> countryProperty() {
    return addPropertyNameInternal('country');
  }

  QueryBuilder<Business, String?, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Business, String?, QQueryOperations> currencyProperty() {
    return addPropertyNameInternal('currency');
  }

  QueryBuilder<Business, String?, QQueryOperations> deviceTokenProperty() {
    return addPropertyNameInternal('deviceToken');
  }

  QueryBuilder<Business, String?, QQueryOperations> dvcSrlNoProperty() {
    return addPropertyNameInternal('dvcSrlNo');
  }

  QueryBuilder<Business, String?, QQueryOperations> emailProperty() {
    return addPropertyNameInternal('email');
  }

  QueryBuilder<Business, int?, QQueryOperations> fcategoryIdProperty() {
    return addPropertyNameInternal('fcategoryId');
  }

  QueryBuilder<Business, String?, QQueryOperations> firstNameProperty() {
    return addPropertyNameInternal('firstName');
  }

  QueryBuilder<Business, String?, QQueryOperations> fullNameProperty() {
    return addPropertyNameInternal('fullName');
  }

  QueryBuilder<Business, String?, QQueryOperations> hexColorProperty() {
    return addPropertyNameInternal('hexColor');
  }

  QueryBuilder<Business, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Business, String?, QQueryOperations> imageUrlProperty() {
    return addPropertyNameInternal('imageUrl');
  }

  QueryBuilder<Business, bool?, QQueryOperations>
      isLastSubscriptionPaymentSucceededProperty() {
    return addPropertyNameInternal('isLastSubscriptionPaymentSucceeded');
  }

  QueryBuilder<Business, String?, QQueryOperations> lastDbBackupProperty() {
    return addPropertyNameInternal('lastDbBackup');
  }

  QueryBuilder<Business, String?, QQueryOperations> lastNameProperty() {
    return addPropertyNameInternal('lastName');
  }

  QueryBuilder<Business, int?, QQueryOperations> lastSeenProperty() {
    return addPropertyNameInternal('lastSeen');
  }

  QueryBuilder<Business, String?, QQueryOperations> latitudeProperty() {
    return addPropertyNameInternal('latitude');
  }

  QueryBuilder<Business, String?, QQueryOperations> longitudeProperty() {
    return addPropertyNameInternal('longitude');
  }

  QueryBuilder<Business, String?, QQueryOperations> metadataProperty() {
    return addPropertyNameInternal('metadata');
  }

  QueryBuilder<Business, String?, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Business, String?, QQueryOperations> nextBillingDateProperty() {
    return addPropertyNameInternal('nextBillingDate');
  }

  QueryBuilder<Business, String?, QQueryOperations>
      previousBillingDateProperty() {
    return addPropertyNameInternal('previousBillingDate');
  }

  QueryBuilder<Business, String?, QQueryOperations> roleProperty() {
    return addPropertyNameInternal('role');
  }

  QueryBuilder<Business, String?, QQueryOperations> subscriptionPlanProperty() {
    return addPropertyNameInternal('subscriptionPlan');
  }

  QueryBuilder<Business, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }

  QueryBuilder<Business, String?, QQueryOperations> timeZoneProperty() {
    return addPropertyNameInternal('timeZone');
  }

  QueryBuilder<Business, String?, QQueryOperations> tinNumberProperty() {
    return addPropertyNameInternal('tinNumber');
  }

  QueryBuilder<Business, String?, QQueryOperations> typeProperty() {
    return addPropertyNameInternal('type');
  }

  QueryBuilder<Business, String?, QQueryOperations> typeIdProperty() {
    return addPropertyNameInternal('typeId');
  }

  QueryBuilder<Business, String?, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }
}
