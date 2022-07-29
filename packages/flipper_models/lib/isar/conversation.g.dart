// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetConversationCollection on Isar {
  IsarCollection<Conversation> get conversations => collection();
}

const ConversationSchema = CollectionSchema(
  name: r'Conversation',
  schema:
      r'{"name":"Conversation","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"dbAvatars","type":"String"},{"name":"delivered","type":"Bool"},{"name":"lastMessage","type":"String"},{"name":"receiverId","type":"Long"},{"name":"senderId","type":"Long"},{"name":"senderName","type":"String"},{"name":"status","type":"String"}],"indexes":[],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'createdAt': 0,
    r'dbAvatars': 1,
    r'delivered': 2,
    r'lastMessage': 3,
    r'receiverId': 4,
    r'senderId': 5,
    r'senderName': 6,
    r'status': 7
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

List<IsarLinkBase<dynamic>> _conversationGetLinks(Conversation object) {
  return [];
}

void _conversationSerializeNative(
    IsarCollection<Conversation> collection,
    IsarCObject cObj,
    Conversation object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  IsarUint8List? dbAvatars$Bytes;
  final dbAvatars$Value = object.dbAvatars;
  if (dbAvatars$Value != null) {
    dbAvatars$Bytes = IsarBinaryWriter.utf8Encoder.convert(dbAvatars$Value);
  }
  IsarUint8List? lastMessage$Bytes;
  final lastMessage$Value = object.lastMessage;
  if (lastMessage$Value != null) {
    lastMessage$Bytes = IsarBinaryWriter.utf8Encoder.convert(lastMessage$Value);
  }
  final senderName$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.senderName);
  final status$Bytes = IsarBinaryWriter.utf8Encoder.convert(object.status);
  final size = (staticSize +
      3 +
      (dbAvatars$Bytes?.length ?? 0) +
      3 +
      (lastMessage$Bytes?.length ?? 0) +
      3 +
      (senderName$Bytes.length) +
      3 +
      (status$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeLong(offsets[0], object.createdAt);
  writer.writeByteList(offsets[1], dbAvatars$Bytes);
  writer.writeBool(offsets[2], object.delivered);
  writer.writeByteList(offsets[3], lastMessage$Bytes);
  writer.writeLong(offsets[4], object.receiverId);
  writer.writeLong(offsets[5], object.senderId);
  writer.writeByteList(offsets[6], senderName$Bytes);
  writer.writeByteList(offsets[7], status$Bytes);
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
      throw IsarError('Illegal propertyIndex');
  }
}

Object _conversationSerializeWeb(
    IsarCollection<Conversation> collection, Conversation object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, r'dbAvatars', object.dbAvatars);
  IsarNative.jsObjectSet(jsObj, r'delivered', object.delivered);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'lastMessage', object.lastMessage);
  IsarNative.jsObjectSet(jsObj, r'receiverId', object.receiverId);
  IsarNative.jsObjectSet(jsObj, r'senderId', object.senderId);
  IsarNative.jsObjectSet(jsObj, r'senderName', object.senderName);
  IsarNative.jsObjectSet(jsObj, r'status', object.status);
  return jsObj;
}

Conversation _conversationDeserializeWeb(
    IsarCollection<Conversation> collection, Object jsObj) {
  final object = Conversation();
  object.createdAt = IsarNative.jsObjectGet(jsObj, r'createdAt') ??
      (double.negativeInfinity as int);
  object.delivered = IsarNative.jsObjectGet(jsObj, r'delivered') ?? false;
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.lastMessage = IsarNative.jsObjectGet(jsObj, r'lastMessage');
  object.receiverId = IsarNative.jsObjectGet(jsObj, r'receiverId') ??
      (double.negativeInfinity as int);
  object.senderId = IsarNative.jsObjectGet(jsObj, r'senderId') ??
      (double.negativeInfinity as int);
  object.senderName = IsarNative.jsObjectGet(jsObj, r'senderName') ?? '';
  object.status = IsarNative.jsObjectGet(jsObj, r'status') ?? '';
  return object;
}

P _conversationDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'createdAt':
      return (IsarNative.jsObjectGet(jsObj, r'createdAt') ??
          (double.negativeInfinity as int)) as P;
    case r'dbAvatars':
      return (IsarNative.jsObjectGet(jsObj, r'dbAvatars')) as P;
    case r'delivered':
      return (IsarNative.jsObjectGet(jsObj, r'delivered') ?? false) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'lastMessage':
      return (IsarNative.jsObjectGet(jsObj, r'lastMessage')) as P;
    case r'receiverId':
      return (IsarNative.jsObjectGet(jsObj, r'receiverId') ??
          (double.negativeInfinity as int)) as P;
    case r'senderId':
      return (IsarNative.jsObjectGet(jsObj, r'senderId') ??
          (double.negativeInfinity as int)) as P;
    case r'senderName':
      return (IsarNative.jsObjectGet(jsObj, r'senderName') ?? '') as P;
    case r'status':
      return (IsarNative.jsObjectGet(jsObj, r'status') ?? '') as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _conversationAttachLinks(
    IsarCollection<dynamic> col, int id, Conversation object) {}

extension ConversationQueryWhereSort
    on QueryBuilder<Conversation, Conversation, QWhere> {
  QueryBuilder<Conversation, Conversation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ConversationQueryWhere
    on QueryBuilder<Conversation, Conversation, QWhereClause> {
  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idNotEqualTo(
      int id) {
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

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterWhereClause> idBetween(
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
}

extension ConversationQueryFilter
    on QueryBuilder<Conversation, Conversation, QFilterCondition> {
  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      createdAtBetween(
    int lower,
    int upper, {
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
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dbAvatars',
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dbAvatars',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dbAvatars',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dbAvatars',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dbAvatars',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dbAvatars',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dbAvatars',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dbAvatars',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      dbAvatarsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dbAvatars',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      deliveredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'delivered',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMessage',
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      lastMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiverId',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiverId',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiverId',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      receiverIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiverId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderId',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'senderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'senderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'senderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'senderName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'senderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'senderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'senderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      senderNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'senderName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension ConversationQueryLinks
    on QueryBuilder<Conversation, Conversation, QFilterCondition> {}

extension ConversationQueryWhereSortBy
    on QueryBuilder<Conversation, Conversation, QSortBy> {
  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDbAvatars() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbAvatars', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDbAvatarsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbAvatars', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByDeliveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByLastMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortByLastMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortByReceiverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortBySenderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortBySenderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderName', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      sortBySenderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderName', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ConversationQueryWhereSortThenBy
    on QueryBuilder<Conversation, Conversation, QSortThenBy> {
  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDbAvatars() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbAvatars', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDbAvatarsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dbAvatars', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByDeliveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'delivered', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByLastMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenByLastMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessage', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenByReceiverIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiverId', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenBySenderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderId', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenBySenderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderName', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy>
      thenBySenderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'senderName', Sort.desc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Conversation, Conversation, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ConversationQueryWhereDistinct
    on QueryBuilder<Conversation, Conversation, QDistinct> {
  QueryBuilder<Conversation, Conversation, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByDbAvatars(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dbAvatars', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByDelivered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'delivered');
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByLastMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByReceiverId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiverId');
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctBySenderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderId');
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctBySenderName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'senderName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Conversation, Conversation, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension ConversationQueryProperty
    on QueryBuilder<Conversation, Conversation, QQueryProperty> {
  QueryBuilder<Conversation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Conversation, int, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Conversation, String?, QQueryOperations> dbAvatarsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dbAvatars');
    });
  }

  QueryBuilder<Conversation, bool, QQueryOperations> deliveredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'delivered');
    });
  }

  QueryBuilder<Conversation, String?, QQueryOperations> lastMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessage');
    });
  }

  QueryBuilder<Conversation, int, QQueryOperations> receiverIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiverId');
    });
  }

  QueryBuilder<Conversation, int, QQueryOperations> senderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderId');
    });
  }

  QueryBuilder<Conversation, String, QQueryOperations> senderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'senderName');
    });
  }

  QueryBuilder<Conversation, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
