// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetConversationCollection on Isar {
  IsarCollection<Conversation> get conversations {
    return getCollection('Conversation');
  }
}

final ConversationSchema = CollectionSchema(
  name: 'Conversation',
  schema:
      '{"name":"Conversation","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"dbAvatars","type":"String"},{"name":"dbInitials","type":"String"},{"name":"delivered","type":"Bool"},{"name":"lastMessage","type":"String"},{"name":"receiverId","type":"Long"},{"name":"senderId","type":"Long"},{"name":"senderName","type":"String"},{"name":"status","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _ConversationNativeAdapter(),
  webAdapter: const _ConversationWebAdapter(),
  idName: 'id',
  propertyIds: {
    'createdAt': 0,
    'dbAvatars': 1,
    'dbInitials': 2,
    'delivered': 3,
    'lastMessage': 4,
    'receiverId': 5,
    'senderId': 6,
    'senderName': 7,
    'status': 8
  },
  listProperties: {},
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

class _ConversationWebAdapter extends IsarWebTypeAdapter<Conversation> {
  const _ConversationWebAdapter();

  @override
  Object serialize(
      IsarCollection<Conversation> collection, Conversation object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(jsObj, 'dbAvatars', object.dbAvatars);
    IsarNative.jsObjectSet(jsObj, 'dbInitials', object.dbInitials);
    IsarNative.jsObjectSet(jsObj, 'delivered', object.delivered);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'lastMessage', object.lastMessage);
    IsarNative.jsObjectSet(jsObj, 'receiverId', object.receiverId);
    IsarNative.jsObjectSet(jsObj, 'senderId', object.senderId);
    IsarNative.jsObjectSet(jsObj, 'senderName', object.senderName);
    IsarNative.jsObjectSet(jsObj, 'status', object.status);
    return jsObj;
  }

  @override
  Conversation deserialize(
      IsarCollection<Conversation> collection, dynamic jsObj) {
    final object = Conversation(
      createdAt:
          IsarNative.jsObjectGet(jsObj, 'createdAt') ?? double.negativeInfinity,
      delivered: IsarNative.jsObjectGet(jsObj, 'delivered') ?? false,
      id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
      lastMessage: IsarNative.jsObjectGet(jsObj, 'lastMessage'),
      receiverId: IsarNative.jsObjectGet(jsObj, 'receiverId') ??
          double.negativeInfinity,
      senderId:
          IsarNative.jsObjectGet(jsObj, 'senderId') ?? double.negativeInfinity,
      senderName: IsarNative.jsObjectGet(jsObj, 'senderName') ?? '',
      status: IsarNative.jsObjectGet(jsObj, 'status') ?? '',
    );
    object.dbAvatars = IsarNative.jsObjectGet(jsObj, 'dbAvatars');
    object.dbInitials = IsarNative.jsObjectGet(jsObj, 'dbInitials');
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'createdAt':
        return (IsarNative.jsObjectGet(jsObj, 'createdAt') ??
            double.negativeInfinity) as P;
      case 'dbAvatars':
        return (IsarNative.jsObjectGet(jsObj, 'dbAvatars')) as P;
      case 'dbInitials':
        return (IsarNative.jsObjectGet(jsObj, 'dbInitials')) as P;
      case 'delivered':
        return (IsarNative.jsObjectGet(jsObj, 'delivered') ?? false) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'lastMessage':
        return (IsarNative.jsObjectGet(jsObj, 'lastMessage')) as P;
      case 'receiverId':
        return (IsarNative.jsObjectGet(jsObj, 'receiverId') ??
            double.negativeInfinity) as P;
      case 'senderId':
        return (IsarNative.jsObjectGet(jsObj, 'senderId') ??
            double.negativeInfinity) as P;
      case 'senderName':
        return (IsarNative.jsObjectGet(jsObj, 'senderName') ?? '') as P;
      case 'status':
        return (IsarNative.jsObjectGet(jsObj, 'status') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Conversation object) {}
}

class _ConversationNativeAdapter extends IsarNativeTypeAdapter<Conversation> {
  const _ConversationNativeAdapter();

  @override
  void serialize(
      IsarCollection<Conversation> collection,
      IsarRawObject rawObj,
      Conversation object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.createdAt;
    final _createdAt = value0;
    final value1 = object.dbAvatars;
    IsarUint8List? _dbAvatars;
    if (value1 != null) {
      _dbAvatars = IsarBinaryWriter.utf8Encoder.convert(value1);
    }
    dynamicSize += (_dbAvatars?.length ?? 0) as int;
    final value2 = object.dbInitials;
    IsarUint8List? _dbInitials;
    if (value2 != null) {
      _dbInitials = IsarBinaryWriter.utf8Encoder.convert(value2);
    }
    dynamicSize += (_dbInitials?.length ?? 0) as int;
    final value3 = object.delivered;
    final _delivered = value3;
    final value4 = object.lastMessage;
    IsarUint8List? _lastMessage;
    if (value4 != null) {
      _lastMessage = IsarBinaryWriter.utf8Encoder.convert(value4);
    }
    dynamicSize += (_lastMessage?.length ?? 0) as int;
    final value5 = object.receiverId;
    final _receiverId = value5;
    final value6 = object.senderId;
    final _senderId = value6;
    final value7 = object.senderName;
    final _senderName = IsarBinaryWriter.utf8Encoder.convert(value7);
    dynamicSize += (_senderName.length) as int;
    final value8 = object.status;
    final _status = IsarBinaryWriter.utf8Encoder.convert(value8);
    dynamicSize += (_status.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeLong(offsets[0], _createdAt);
    writer.writeBytes(offsets[1], _dbAvatars);
    writer.writeBytes(offsets[2], _dbInitials);
    writer.writeBool(offsets[3], _delivered);
    writer.writeBytes(offsets[4], _lastMessage);
    writer.writeLong(offsets[5], _receiverId);
    writer.writeLong(offsets[6], _senderId);
    writer.writeBytes(offsets[7], _senderName);
    writer.writeBytes(offsets[8], _status);
  }

  @override
  Conversation deserialize(IsarCollection<Conversation> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Conversation(
      createdAt: reader.readLong(offsets[0]),
      delivered: reader.readBool(offsets[3]),
      id: id,
      lastMessage: reader.readStringOrNull(offsets[4]),
      receiverId: reader.readLong(offsets[5]),
      senderId: reader.readLong(offsets[6]),
      senderName: reader.readString(offsets[7]),
      status: reader.readString(offsets[8]),
    );
    object.dbAvatars = reader.readStringOrNull(offsets[1]);
    object.dbInitials = reader.readStringOrNull(offsets[2]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readLong(offset)) as P;
      case 1:
        return (reader.readStringOrNull(offset)) as P;
      case 2:
        return (reader.readStringOrNull(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readStringOrNull(offset)) as P;
      case 5:
        return (reader.readLong(offset)) as P;
      case 6:
        return (reader.readLong(offset)) as P;
      case 7:
        return (reader.readString(offset)) as P;
      case 8:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Conversation object) {}
}

extension ConversationQueryWhereSort
    on QueryBuilder<Conversation, Conversation, QWhere> {
  QueryBuilder<Conversation, Conversation, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension ConversationQueryWhere
    on QueryBuilder<Conversation, Conversation, QWhereClause> {
  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idBetween(
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

extension ConversationQueryFilter
    on QueryBuilder<Conversation, Conversation, QFilterCondition> {
  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'dbAvatars',
      value: null,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'dbAvatars',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'dbAvatars',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'dbAvatars',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dbAvatars',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'dbAvatars',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'dbAvatars',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'dbAvatars',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'dbAvatars',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'dbInitials',
      value: null,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'dbInitials',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'dbInitials',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'dbInitials',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'dbInitials',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'dbInitials',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'dbInitials',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'dbInitials',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbInitialsMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'dbInitials',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      deliveredEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'delivered',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'lastMessage',
      value: null,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastMessage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastMessage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastMessage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastMessage',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastMessage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastMessage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastMessage',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastMessage',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'receiverId',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'receiverId',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'receiverId',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'receiverId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'senderId',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'senderId',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'senderId',
      value: value,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'senderId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'senderName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'senderName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'senderName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'senderName',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'senderName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'senderName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'senderName',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'senderName',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'status',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'status',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension ConversationQueryWhereSortBy
    on QueryBuilder<Conversation, Conversation, QSortBy> {
  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDbAvatars() {
    return addSortByInternal('dbAvatars', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDbAvatarsDesc() {
    return addSortByInternal('dbAvatars', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDbInitials() {
    return addSortByInternal('dbInitials', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortByDbInitialsDesc() {
    return addSortByInternal('dbInitials', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDelivered() {
    return addSortByInternal('delivered', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDeliveredDesc() {
    return addSortByInternal('delivered', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByLastMessage() {
    return addSortByInternal('lastMessage', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortByLastMessageDesc() {
    return addSortByInternal('lastMessage', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByReceiverId() {
    return addSortByInternal('receiverId', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortByReceiverIdDesc() {
    return addSortByInternal('receiverId', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortBySenderId() {
    return addSortByInternal('senderId', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortBySenderIdDesc() {
    return addSortByInternal('senderId', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortBySenderName() {
    return addSortByInternal('senderName', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortBySenderNameDesc() {
    return addSortByInternal('senderName', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByStatus() {
    return addSortByInternal('status', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByStatusDesc() {
    return addSortByInternal('status', Sort.desc);
  }
}

extension ConversationQueryWhereSortThenBy
    on QueryBuilder<Conversation, Conversation, QSortThenBy> {
  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDbAvatars() {
    return addSortByInternal('dbAvatars', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDbAvatarsDesc() {
    return addSortByInternal('dbAvatars', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDbInitials() {
    return addSortByInternal('dbInitials', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenByDbInitialsDesc() {
    return addSortByInternal('dbInitials', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDelivered() {
    return addSortByInternal('delivered', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDeliveredDesc() {
    return addSortByInternal('delivered', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByLastMessage() {
    return addSortByInternal('lastMessage', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenByLastMessageDesc() {
    return addSortByInternal('lastMessage', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByReceiverId() {
    return addSortByInternal('receiverId', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenByReceiverIdDesc() {
    return addSortByInternal('receiverId', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenBySenderId() {
    return addSortByInternal('senderId', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenBySenderIdDesc() {
    return addSortByInternal('senderId', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenBySenderName() {
    return addSortByInternal('senderName', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenBySenderNameDesc() {
    return addSortByInternal('senderName', Sort.desc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByStatus() {
    return addSortByInternal('status', Sort.asc);
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByStatusDesc() {
    return addSortByInternal('status', Sort.desc);
  }
}

extension ConversationQueryWhereDistinct
    on QueryBuilder<Conversation, Conversation, QDistinct> {
  QueryBuilder<Conversation, Conversation, QDistinct> distinctByCreatedAt() {
    return addDistinctByInternal('createdAt');
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByDbAvatars(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('dbAvatars', caseSensitive: caseSensitive);
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByDbInitials(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('dbInitials', caseSensitive: caseSensitive);
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByDelivered() {
    return addDistinctByInternal('delivered');
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByLastMessage(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastMessage', caseSensitive: caseSensitive);
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByReceiverId() {
    return addDistinctByInternal('receiverId');
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctBySenderId() {
    return addDistinctByInternal('senderId');
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctBySenderName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('senderName', caseSensitive: caseSensitive);
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('status', caseSensitive: caseSensitive);
  }
}

extension ConversationQueryProperty
    on QueryBuilder<Conversation, Conversation, QQueryProperty> {
  QueryBuilder<Conversation, int, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Conversation, String?, QQueryOperations> dbAvatarsProperty() {
    return addPropertyNameInternal('dbAvatars');
  }

  QueryBuilder<Conversation, String?, QQueryOperations> dbInitialsProperty() {
    return addPropertyNameInternal('dbInitials');
  }

  QueryBuilder<Conversation, bool, QQueryOperations> deliveredProperty() {
    return addPropertyNameInternal('delivered');
  }

  QueryBuilder<Conversation, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Conversation, String?, QQueryOperations> lastMessageProperty() {
    return addPropertyNameInternal('lastMessage');
  }

  QueryBuilder<Conversation, int, QQueryOperations> receiverIdProperty() {
    return addPropertyNameInternal('receiverId');
  }

  QueryBuilder<Conversation, int, QQueryOperations> senderIdProperty() {
    return addPropertyNameInternal('senderId');
  }

  QueryBuilder<Conversation, String, QQueryOperations> senderNameProperty() {
    return addPropertyNameInternal('senderName');
  }

  QueryBuilder<Conversation, String, QQueryOperations> statusProperty() {
    return addPropertyNameInternal('status');
  }
}
