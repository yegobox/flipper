// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetSubscriptionCollection on Isar {
  IsarCollection<Subscription> get subscriptions => getCollection();
}

const SubscriptionSchema = CollectionSchema(
  name: 'Subscription',
  schema:
      '{"name":"Subscription","idName":"id","properties":[{"name":"descriptor","type":"String"},{"name":"interval","type":"Long"},{"name":"lastBillingDate","type":"String"},{"name":"nextBillingDate","type":"String"},{"name":"recurring","type":"Double"},{"name":"userId","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'descriptor': 0,
    'interval': 1,
    'lastBillingDate': 2,
    'nextBillingDate': 3,
    'recurring': 4,
    'userId': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
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
  version: 3,
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

List<IsarLinkBase> _subscriptionGetLinks(Subscription object) {
  return [];
}

void _subscriptionSerializeNative(
    IsarCollection<Subscription> collection,
    IsarRawObject rawObj,
    Subscription object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.descriptor;
  final _descriptor = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_descriptor.length) as int;
  final value1 = object.interval;
  final _interval = value1;
  final value2 = object.lastBillingDate;
  final _lastBillingDate = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_lastBillingDate.length) as int;
  final value3 = object.nextBillingDate;
  final _nextBillingDate = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_nextBillingDate.length) as int;
  final value4 = object.recurring;
  final _recurring = value4;
  final value5 = object.userId;
  final _userId = value5;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _descriptor);
  writer.writeLong(offsets[1], _interval);
  writer.writeBytes(offsets[2], _lastBillingDate);
  writer.writeBytes(offsets[3], _nextBillingDate);
  writer.writeDouble(offsets[4], _recurring);
  writer.writeLong(offsets[5], _userId);
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
      throw 'Illegal propertyIndex';
  }
}

dynamic _subscriptionSerializeWeb(
    IsarCollection<Subscription> collection, Subscription object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'descriptor', object.descriptor);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'interval', object.interval);
  IsarNative.jsObjectSet(jsObj, 'lastBillingDate', object.lastBillingDate);
  IsarNative.jsObjectSet(jsObj, 'nextBillingDate', object.nextBillingDate);
  IsarNative.jsObjectSet(jsObj, 'recurring', object.recurring);
  IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
  return jsObj;
}

Subscription _subscriptionDeserializeWeb(
    IsarCollection<Subscription> collection, dynamic jsObj) {
  final object = Subscription(
    descriptor: IsarNative.jsObjectGet(jsObj, 'descriptor') ?? '',
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    interval:
        IsarNative.jsObjectGet(jsObj, 'interval') ?? double.negativeInfinity,
    lastBillingDate: IsarNative.jsObjectGet(jsObj, 'lastBillingDate') ?? '',
    nextBillingDate: IsarNative.jsObjectGet(jsObj, 'nextBillingDate') ?? '',
    recurring:
        IsarNative.jsObjectGet(jsObj, 'recurring') ?? double.negativeInfinity,
    userId: IsarNative.jsObjectGet(jsObj, 'userId') ?? double.negativeInfinity,
  );
  return object;
}

P _subscriptionDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'descriptor':
      return (IsarNative.jsObjectGet(jsObj, 'descriptor') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'interval':
      return (IsarNative.jsObjectGet(jsObj, 'interval') ??
          double.negativeInfinity) as P;
    case 'lastBillingDate':
      return (IsarNative.jsObjectGet(jsObj, 'lastBillingDate') ?? '') as P;
    case 'nextBillingDate':
      return (IsarNative.jsObjectGet(jsObj, 'nextBillingDate') ?? '') as P;
    case 'recurring':
      return (IsarNative.jsObjectGet(jsObj, 'recurring') ??
          double.negativeInfinity) as P;
    case 'userId':
      return (IsarNative.jsObjectGet(jsObj, 'userId') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _subscriptionAttachLinks(
    IsarCollection col, int id, Subscription object) {}

extension SubscriptionQueryWhereSort
    on QueryBuilder<Subscription, Subscription, QWhere> {
  QueryBuilder<Subscription, Subscription, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension SubscriptionQueryWhere
    on QueryBuilder<Subscription, Subscription, QWhereClause> {
  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Subscription, Subscription, QAfterWhereClause> idBetween(
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

extension SubscriptionQueryFilter
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {
  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'descriptor',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      descriptorMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'descriptor',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      intervalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'interval',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'lastBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'lastBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'lastBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'lastBillingDate',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'lastBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'lastBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'lastBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      lastBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'lastBillingDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateGreaterThan(
    String value, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateLessThan(
    String value, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
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

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'nextBillingDate',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      nextBillingDateMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'nextBillingDate',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'recurring',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'recurring',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      recurringBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'recurring',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> userIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      userIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition>
      userIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'userId',
      value: value,
    ));
  }

  QueryBuilder<Subscription, Subscription, QAfterFilterCondition> userIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'userId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension SubscriptionQueryLinks
    on QueryBuilder<Subscription, Subscription, QFilterCondition> {}

extension SubscriptionQueryWhereSortBy
    on QueryBuilder<Subscription, Subscription, QSortBy> {
  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByLastBillingDate() {
    return addSortByInternal('lastBillingDate', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByLastBillingDateDesc() {
    return addSortByInternal('lastBillingDate', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByNextBillingDate() {
    return addSortByInternal('nextBillingDate', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      sortByNextBillingDateDesc() {
    return addSortByInternal('nextBillingDate', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByRecurring() {
    return addSortByInternal('recurring', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByRecurringDesc() {
    return addSortByInternal('recurring', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension SubscriptionQueryWhereSortThenBy
    on QueryBuilder<Subscription, Subscription, QSortThenBy> {
  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByLastBillingDate() {
    return addSortByInternal('lastBillingDate', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByLastBillingDateDesc() {
    return addSortByInternal('lastBillingDate', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByNextBillingDate() {
    return addSortByInternal('nextBillingDate', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy>
      thenByNextBillingDateDesc() {
    return addSortByInternal('nextBillingDate', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByRecurring() {
    return addSortByInternal('recurring', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByRecurringDesc() {
    return addSortByInternal('recurring', Sort.desc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Subscription, Subscription, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension SubscriptionQueryWhereDistinct
    on QueryBuilder<Subscription, Subscription, QDistinct> {
  QueryBuilder<Subscription, Subscription, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('descriptor', caseSensitive: caseSensitive);
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByInterval() {
    return addDistinctByInternal('interval');
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByLastBillingDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('lastBillingDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByNextBillingDate(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('nextBillingDate',
        caseSensitive: caseSensitive);
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByRecurring() {
    return addDistinctByInternal('recurring');
  }

  QueryBuilder<Subscription, Subscription, QDistinct> distinctByUserId() {
    return addDistinctByInternal('userId');
  }
}

extension SubscriptionQueryProperty
    on QueryBuilder<Subscription, Subscription, QQueryProperty> {
  QueryBuilder<Subscription, String, QQueryOperations> descriptorProperty() {
    return addPropertyNameInternal('descriptor');
  }

  QueryBuilder<Subscription, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Subscription, int, QQueryOperations> intervalProperty() {
    return addPropertyNameInternal('interval');
  }

  QueryBuilder<Subscription, String, QQueryOperations>
      lastBillingDateProperty() {
    return addPropertyNameInternal('lastBillingDate');
  }

  QueryBuilder<Subscription, String, QQueryOperations>
      nextBillingDateProperty() {
    return addPropertyNameInternal('nextBillingDate');
  }

  QueryBuilder<Subscription, double, QQueryOperations> recurringProperty() {
    return addPropertyNameInternal('recurring');
  }

  QueryBuilder<Subscription, int, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }
}
