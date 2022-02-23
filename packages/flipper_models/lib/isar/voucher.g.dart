// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetVoucherMCollection on Isar {
  IsarCollection<VoucherM> get voucherMs {
    return getCollection('VoucherM');
  }
}

final VoucherMSchema = CollectionSchema(
  name: 'VoucherM',
  schema:
      '{"name":"VoucherM","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"descriptor","type":"String"},{"name":"interval","type":"Long"},{"name":"used","type":"Bool"},{"name":"usedAt","type":"Long"},{"name":"value","type":"Long"}],"indexes":[],"links":[{"name":"features","target":"Feature"}]}',
  nativeAdapter: const _VoucherMNativeAdapter(),
  webAdapter: const _VoucherMWebAdapter(),
  idName: 'id',
  propertyIds: {
    'createdAt': 0,
    'descriptor': 1,
    'interval': 2,
    'used': 3,
    'usedAt': 4,
    'value': 5
  },
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {'features': 0},
  backlinkIds: {},
  linkedCollections: ['Feature'],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.features],
  version: 2,
);

class _VoucherMWebAdapter extends IsarWebTypeAdapter<VoucherM> {
  const _VoucherMWebAdapter();

  @override
  Object serialize(IsarCollection<VoucherM> collection, VoucherM object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(jsObj, 'descriptor', object.descriptor);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'interval', object.interval);
    IsarNative.jsObjectSet(jsObj, 'used', object.used);
    IsarNative.jsObjectSet(jsObj, 'usedAt', object.usedAt);
    IsarNative.jsObjectSet(jsObj, 'value', object.value);
    return jsObj;
  }

  @override
  VoucherM deserialize(IsarCollection<VoucherM> collection, dynamic jsObj) {
    final object = VoucherM(
      createdAt:
          IsarNative.jsObjectGet(jsObj, 'createdAt') ?? double.negativeInfinity,
      descriptor: IsarNative.jsObjectGet(jsObj, 'descriptor') ?? '',
      id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
      interval:
          IsarNative.jsObjectGet(jsObj, 'interval') ?? double.negativeInfinity,
      used: IsarNative.jsObjectGet(jsObj, 'used') ?? false,
      usedAt:
          IsarNative.jsObjectGet(jsObj, 'usedAt') ?? double.negativeInfinity,
      value: IsarNative.jsObjectGet(jsObj, 'value') ?? double.negativeInfinity,
    );
    attachLinks(collection.isar,
        IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'createdAt':
        return (IsarNative.jsObjectGet(jsObj, 'createdAt') ??
            double.negativeInfinity) as P;
      case 'descriptor':
        return (IsarNative.jsObjectGet(jsObj, 'descriptor') ?? '') as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'interval':
        return (IsarNative.jsObjectGet(jsObj, 'interval') ??
            double.negativeInfinity) as P;
      case 'used':
        return (IsarNative.jsObjectGet(jsObj, 'used') ?? false) as P;
      case 'usedAt':
        return (IsarNative.jsObjectGet(jsObj, 'usedAt') ??
            double.negativeInfinity) as P;
      case 'value':
        return (IsarNative.jsObjectGet(jsObj, 'value') ??
            double.negativeInfinity) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, VoucherM object) {
    object.features.attach(
      id,
      isar.voucherMs,
      isar.getCollection<Feature>('Feature'),
      'features',
      false,
    );
  }
}

class _VoucherMNativeAdapter extends IsarNativeTypeAdapter<VoucherM> {
  const _VoucherMNativeAdapter();

  @override
  void serialize(IsarCollection<VoucherM> collection, IsarRawObject rawObj,
      VoucherM object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.createdAt;
    final _createdAt = value0;
    final value1 = object.descriptor;
    final _descriptor = IsarBinaryWriter.utf8Encoder.convert(value1);
    dynamicSize += (_descriptor.length) as int;
    final value2 = object.interval;
    final _interval = value2;
    final value3 = object.used;
    final _used = value3;
    final value4 = object.usedAt;
    final _usedAt = value4;
    final value5 = object.value;
    final _value = value5;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeLong(offsets[0], _createdAt);
    writer.writeBytes(offsets[1], _descriptor);
    writer.writeLong(offsets[2], _interval);
    writer.writeBool(offsets[3], _used);
    writer.writeLong(offsets[4], _usedAt);
    writer.writeLong(offsets[5], _value);
  }

  @override
  VoucherM deserialize(IsarCollection<VoucherM> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = VoucherM(
      createdAt: reader.readLong(offsets[0]),
      descriptor: reader.readString(offsets[1]),
      id: id,
      interval: reader.readLong(offsets[2]),
      used: reader.readBool(offsets[3]),
      usedAt: reader.readLong(offsets[4]),
      value: reader.readLong(offsets[5]),
    );
    attachLinks(collection.isar, id, object);
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
        return (reader.readString(offset)) as P;
      case 2:
        return (reader.readLong(offset)) as P;
      case 3:
        return (reader.readBool(offset)) as P;
      case 4:
        return (reader.readLong(offset)) as P;
      case 5:
        return (reader.readLong(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, VoucherM object) {
    object.features.attach(
      id,
      isar.voucherMs,
      isar.getCollection<Feature>('Feature'),
      'features',
      false,
    );
  }
}

extension VoucherMQueryWhereSort on QueryBuilder<VoucherM, VoucherM, QWhere> {
  QueryBuilder<VoucherM, VoucherM, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension VoucherMQueryWhere on QueryBuilder<VoucherM, VoucherM, QWhereClause> {
  QueryBuilder<VoucherM, VoucherM, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<VoucherM, VoucherM, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterWhereClause> idBetween(
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

extension VoucherMQueryFilter
    on QueryBuilder<VoucherM, VoucherM, QFilterCondition> {
  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> createdAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorEqualTo(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorGreaterThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorLessThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorBetween(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorStartsWith(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorEndsWith(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> descriptorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'descriptor',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> intervalEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> intervalGreaterThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> intervalLessThan(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> intervalBetween(
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

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> usedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'used',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> usedAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> usedAtGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> usedAtLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> usedAtBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'usedAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> valueEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> valueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> valueLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<VoucherM, VoucherM, QAfterFilterCondition> valueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension VoucherMQueryWhereSortBy
    on QueryBuilder<VoucherM, VoucherM, QSortBy> {
  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByUsed() {
    return addSortByInternal('used', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByUsedDesc() {
    return addSortByInternal('used', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByUsedAt() {
    return addSortByInternal('usedAt', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByUsedAtDesc() {
    return addSortByInternal('usedAt', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension VoucherMQueryWhereSortThenBy
    on QueryBuilder<VoucherM, VoucherM, QSortThenBy> {
  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByUsed() {
    return addSortByInternal('used', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByUsedDesc() {
    return addSortByInternal('used', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByUsedAt() {
    return addSortByInternal('usedAt', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByUsedAtDesc() {
    return addSortByInternal('usedAt', Sort.desc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<VoucherM, VoucherM, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension VoucherMQueryWhereDistinct
    on QueryBuilder<VoucherM, VoucherM, QDistinct> {
  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctByCreatedAt() {
    return addDistinctByInternal('createdAt');
  }

  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('descriptor', caseSensitive: caseSensitive);
  }

  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctByInterval() {
    return addDistinctByInternal('interval');
  }

  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctByUsed() {
    return addDistinctByInternal('used');
  }

  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctByUsedAt() {
    return addDistinctByInternal('usedAt');
  }

  QueryBuilder<VoucherM, VoucherM, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }
}

extension VoucherMQueryProperty
    on QueryBuilder<VoucherM, VoucherM, QQueryProperty> {
  QueryBuilder<VoucherM, int, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<VoucherM, String, QQueryOperations> descriptorProperty() {
    return addPropertyNameInternal('descriptor');
  }

  QueryBuilder<VoucherM, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<VoucherM, int, QQueryOperations> intervalProperty() {
    return addPropertyNameInternal('interval');
  }

  QueryBuilder<VoucherM, bool, QQueryOperations> usedProperty() {
    return addPropertyNameInternal('used');
  }

  QueryBuilder<VoucherM, int, QQueryOperations> usedAtProperty() {
    return addPropertyNameInternal('usedAt');
  }

  QueryBuilder<VoucherM, int, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
