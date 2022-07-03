// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetSubscriptionCollection on Isar {
  IsarCollection<Subscription> get subscriptions => getCollection();
}

const SubscriptionSchema = CollectionSchema(
  name: r'Subscription',
  schema:
      r'{"name":"Subscription","idName":"id","properties":[{"name":"descriptor","type":"String"},{"name":"interval","type":"Long"},{"name":"lastBillingDate","type":"String"},{"name":"nextBillingDate","type":"String"},{"name":"recurring","type":"Double"},{"name":"userId","type":"Long"}],"indexes":[{"name":"userId","unique":false,"replace":false,"properties":[{"name":"userId","type":"Value","caseSensitive":false}]}],"links":[{"name":"features","target":"Feature"}]}',
  idName: r'id',
  propertyIds: {
    r'descriptor': 0,
    r'interval': 1,
    r'lastBillingDate': 2,
    r'nextBillingDate': 3,
    r'recurring': 4,
    r'userId': 5
  },
  listProperties: {},
  indexIds: {r'userId': 0},
  indexValueTypes: {
    r'userId': [
      IndexValueType.long,
    ]
  },
  linkIds: {r'features': 0},
  backlinkLinkNames: {},
  getId: _subscriptionGetId,
  setId: _subscriptionSetId,
  getLinks: _subscriptionGetLinks,
  attachLinks: _subscriptionAttachLinks,
  serializeNative: _subscriptionSerializeNative,
  deserializeNative: _subscriptionDeserializeNative,
  deserializePropNative: _subscriptionDeserializePropNative,
  serializeWeb: _subscriptionSerializeWeb,
  deserializeWeb: _subscriptionDeserializeWeb,
  deserializePropWeb: _subscriptionDeserializePropWeb,
  version: 4,
);

int? _subscriptionGetId(Subscription object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _subscriptionSetId(Subscription object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _subscriptionGetLinks(Subscription object) {
  return [object.features];
}

void _subscriptionSerializeNative(
    IsarCollection<Subscription> collection,
    IsarCObject cObj,
    Subscription object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final descriptor$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.descriptor);
  final lastBillingDate$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.lastBillingDate);
  final nextBillingDate$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.nextBillingDate);
  final size = (staticSize +
      (descriptor$Bytes.length) +
      (lastBillingDate$Bytes.length) +
      (nextBillingDate$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeBytes(offsets[0], descriptor$Bytes);
  writer.writeLong(offsets[1], object.interval);
  writer.writeBytes(offsets[2], lastBillingDate$Bytes);
  writer.writeBytes(offsets[3], nextBillingDate$Bytes);
  writer.writeDouble(offsets[4], object.recurring);
  writer.writeLong(offsets[5], object.userId);
}

Subscription _subscriptionDeserializeNative(
    IsarCollection<Subscription> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = Subscription(
    descriptor: reader.readString(offsets[0]),
    id: id,
    interval: reader.readLong(offsets[1]),
    lastBillingDate: reader.readString(offsets[2]),
    nextBillingDate: reader.readString(offsets[3]),
    recurring: reader.readDouble(offsets[4]),
    userId: reader.readLong(offsets[5]),
  );
  _subscriptionAttachLinks(collection, id, object);
  return object;
}

P _subscriptionDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _subscriptionSerializeWeb(
    IsarCollection<Subscription> collection, Subscription object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'descriptor', object.descriptor);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'interval', object.interval);
  IsarNative.jsObjectSet(jsObj, r'lastBillingDate', object.lastBillingDate);
  IsarNative.jsObjectSet(jsObj, r'nextBillingDate', object.nextBillingDate);
  IsarNative.jsObjectSet(jsObj, r'recurring', object.recurring);
  IsarNative.jsObjectSet(jsObj, r'userId', object.userId);
  return jsObj;
}

Subscription _subscriptionDeserializeWeb(
    IsarCollection<Subscription> collection, Object jsObj) {
  final object = Subscription(
    descriptor: IsarNative.jsObjectGet(jsObj, r'descriptor') ?? '',
    id: IsarNative.jsObjectGet(jsObj, r'id') ??
        (double.negativeInfinity as int),
    interval: IsarNative.jsObjectGet(jsObj, r'interval') ??
        (double.negativeInfinity as int),
    lastBillingDate: IsarNative.jsObjectGet(jsObj, r'lastBillingDate') ?? '',
    nextBillingDate: IsarNative.jsObjectGet(jsObj, r'nextBillingDate') ?? '',
    recurring:
        IsarNative.jsObjectGet(jsObj, r'recurring') ?? double.negativeInfinity,
    userId: IsarNative.jsObjectGet(jsObj, r'userId') ??
        (double.negativeInfinity as int),
  );
  _subscriptionAttachLinks(
      collection,
      IsarNative.jsObjectGet(jsObj, r'id') ?? (double.negativeInfinity as int),
      object);
  return object;
}

P _subscriptionDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'descriptor':
      return (IsarNative.jsObjectGet(jsObj, r'descriptor') ?? '') as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id') ??
          (double.negativeInfinity as int)) as P;
    case r'interval':
      return (IsarNative.jsObjectGet(jsObj, r'interval') ??
          (double.negativeInfinity as int)) as P;
    case r'lastBillingDate':
      return (IsarNative.jsObjectGet(jsObj, r'lastBillingDate') ?? '') as P;
    case r'nextBillingDate':
      return (IsarNative.jsObjectGet(jsObj, r'nextBillingDate') ?? '') as P;
    case r'recurring':
      return (IsarNative.jsObjectGet(jsObj, r'recurring') ??
          double.negativeInfinity) as P;
    case r'userId':
      return (IsarNative.jsObjectGet(jsObj, r'userId') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _subscriptionAttachLinks(
    IsarCollection<dynamic> col, int id, Subscription object) {
  object.features.attach(col, col.isar.features, r'features', id);
}

extension SubscriptionQueryWhereSort
    on QueryBuilder<Subscription, Subscription, QWhere> {
  QueryBuilder<Subscription, Subscription, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhere> anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension SubscriptionQueryWhere
    on QueryBuilder<Subscription, Subscription, QWhereClause> {
  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idEqualTo(
      int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdEqualTo(
      int userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdNotEqualTo(
      int userId) {
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

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdGreaterThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [userId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdLessThan(
    int userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [],
        upper: [userId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> userIdBetween(
    int lowerUserId,
    int upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [lowerUserId],
        includeLower: includeLower,
        upper: [upperUserId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SubscriptionQueryFilter
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {
  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descriptor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descriptor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descriptor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interval',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interval',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastBillingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastBillingDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateEqualTo(
    String value, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateGreaterThan(
    String value, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateLessThan(
    String value, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nextBillingDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nextBillingDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recurring',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringLessThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'recurring',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringBetween(double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurring',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> userIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
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
      ));
    });
  }
}

extension SubscriptionQueryLinks
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {
  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> features(
      FilterQuery<Feature> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(
        query.collection.isar.features,
        q,
        r'features',
      );
    });
  }
}

extension SubscriptionQueryWhereSortBy
    on QueryBuilder<Subscription, Subscription, QSortBy> {
  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByDescriptor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByDescriptorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByLastBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByLastBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByNextBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByNextBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SubscriptionQueryWhereSortThenBy
    on QueryBuilder<Subscription, Subscription, QSortThenBy> {
  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByDescriptor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByDescriptorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descriptor', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByIntervalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interval', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByLastBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByLastBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByNextBillingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByNextBillingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextBillingDate', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByRecurringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurring', Sort.desc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension SubscriptionQueryWhereDistinct
    on QueryBuilder<Subscription, Subscription, QDistinct> {
  QueryBuilder<Subscription, Subscription, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descriptor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByInterval() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interval');
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByLastBillingDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastBillingDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByNextBillingDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextBillingDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByRecurring() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurring');
    });
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId');
    });
  }
}

extension SubscriptionQueryProperty
    on QueryBuilder<Subscription, Subscription, QQueryProperty> {
  QueryBuilder<Subscription, String, QQueryOperations> descriptorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descriptor');
    });
  }

  QueryBuilder<Subscription, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Subscription, int, QQueryOperations> intervalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interval');
    });
  }

  QueryBuilder<Subscription, String, QQueryOperations>
      lastBillingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastBillingDate');
    });
  }

  QueryBuilder<Subscription, String, QQueryOperations>
      nextBillingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextBillingDate');
    });
  }

  QueryBuilder<Subscription, double, QQueryOperations> recurringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurring');
    });
  }

  QueryBuilder<Subscription, int, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
