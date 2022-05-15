// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetConversationCollection on Isar {
  IsarCollection<Conversation> get conversations => getCollection();
}

const ConversationSchema = CollectionSchema(
  name: 'Conversation',
  schema:
      '{"name":"Conversation","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"dbAvatars","type":"String"},{"name":"delivered","type":"Bool"},{"name":"lastMessage","type":"String"},{"name":"receiverId","type":"Long"},{"name":"senderId","type":"Long"},{"name":"senderName","type":"String"},{"name":"status","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'createdAt': 0,
    'dbAvatars': 1,
    'delivered': 2,
    'lastMessage': 3,
    'receiverId': 4,
    'senderId': 5,
    'senderName': 6,
    'status': 7
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _conversationGetId,
  setId: _conversationSetId,
  getLinks: _conversationGetLinks,
  attachLinks: _conversationAttachLinks,
  serializeNative: _conversationSerializeNative,
  deserializeNative: _conversationDeserializeNative,
  deserializePropNative: _conversationDeserializePropNative,
  serializeWeb: _conversationSerializeWeb,
  deserializeWeb: _conversationDeserializeWeb,
  deserializePropWeb: _conversationDeserializePropWeb,
  version: 4,
);

int? _conversationGetId(Conversation object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _conversationSetId(Conversation object, int id) {
  object.id = id;
}

List<IsarLinkBase> _conversationGetLinks(Conversation object) {
  return [];
}

void _conversationSerializeNative(
    IsarCollection<Conversation> collection,
    IsarCObject cObj,
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
  final value2 = object.delivered;
  final _delivered = value2;
  final value3 = object.lastMessage;
  IsarUint8List? _lastMessage;
  if (value3 != null) {
    _lastMessage = IsarBinaryWriter.utf8Encoder.convert(value3);
  }
  dynamicSize += (_lastMessage?.length ?? 0) as int;
  final value4 = object.receiverId;
  final _receiverId = value4;
  final value5 = object.senderId;
  final _senderId = value5;
  final value6 = object.senderName;
  final _senderName = IsarBinaryWriter.utf8Encoder.convert(value6);
  dynamicSize += (_senderName.length) as int;
  final value7 = object.status;
  final _status = IsarBinaryWriter.utf8Encoder.convert(value7);
  dynamicSize += (_status.length) as int;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _createdAt);
  writer.writeBytes(offsets[1], _dbAvatars);
  writer.writeBool(offsets[2], _delivered);
  writer.writeBytes(offsets[3], _lastMessage);
  writer.writeLong(offsets[4], _receiverId);
  writer.writeLong(offsets[5], _senderId);
  writer.writeBytes(offsets[6], _senderName);
  writer.writeBytes(offsets[7], _status);
}

Conversation _conversationDeserializeNative(
    IsarCollection<Conversation> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = Conversation();
  object.createdAt = reader.readLong(offsets[0]);
  object.delivered = reader.readBool(offsets[2]);
  object.id = id;
  object.lastMessage = reader.readStringOrNull(offsets[3]);
  object.receiverId = reader.readLong(offsets[4]);
  object.senderId = reader.readLong(offsets[5]);
  object.senderName = reader.readString(offsets[6]);
  object.status = reader.readString(offsets[7]);
  return object;
}

P _conversationDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _conversationSerializeWeb(
    IsarCollection<Conversation> collection, Conversation object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'dbAvatars', object.dbAvatars);
  IsarNative.jsObjectSet(jsObj, 'delivered', object.delivered);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'lastMessage', object.lastMessage);
  IsarNative.jsObjectSet(jsObj, 'receiverId', object.receiverId);
  IsarNative.jsObjectSet(jsObj, 'senderId', object.senderId);
  IsarNative.jsObjectSet(jsObj, 'senderName', object.senderName);
  IsarNative.jsObjectSet(jsObj, 'status', object.status);
  return jsObj;
}

Conversation _conversationDeserializeWeb(
    IsarCollection<Conversation> collection, dynamic jsObj) {
  final object = Conversation();
  object.createdAt =
      IsarNative.jsObjectGet(jsObj, 'createdAt') ?? double.negativeInfinity;
  object.delivered = IsarNative.jsObjectGet(jsObj, 'delivered') ?? false;
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.lastMessage = IsarNative.jsObjectGet(jsObj, 'lastMessage');
  object.receiverId =
      IsarNative.jsObjectGet(jsObj, 'receiverId') ?? double.negativeInfinity;
  object.senderId =
      IsarNative.jsObjectGet(jsObj, 'senderId') ?? double.negativeInfinity;
  object.senderName = IsarNative.jsObjectGet(jsObj, 'senderName') ?? '';
  object.status = IsarNative.jsObjectGet(jsObj, 'status') ?? '';
  return object;
}

P _conversationDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'createdAt':
      return (IsarNative.jsObjectGet(jsObj, 'createdAt') ??
          double.negativeInfinity) as P;
    case 'dbAvatars':
      return (IsarNative.jsObjectGet(jsObj, 'dbAvatars')) as P;
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

void _conversationAttachLinks(
    IsarCollection col, int id, Conversation object) {}

extension ConversationQueryWhereSort
    on QueryBuilder<Conversation, Conversation, QWhere> {
  QueryBuilder<Conversation, Conversation, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension ConversationQueryWhere
    on QueryBuilder<Conversation, Conversation, QWhereClause> {
  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idNotEqualTo(
      int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
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

extension ConversationQueryLinks
    on QueryBuilder<Conversation, Conversation, QFilterCondition> {}

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
