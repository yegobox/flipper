// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetVoucherCollection on Isar {
  IsarCollection<Voucher> get vouchers {
    return getCollection('Voucher');
  }
}

final VoucherSchema = CollectionSchema(
  name: 'Voucher',
  schema:
      '{"name":"Voucher","idName":"id","properties":[{"name":"createdAt","type":"Long"},{"name":"descriptor","type":"String"},{"name":"interval","type":"Long"},{"name":"used","type":"Bool"},{"name":"usedAt","type":"Long"},{"name":"value","type":"Long"}],"indexes":[],"links":[{"name":"features","target":"Feature"}]}',
  nativeAdapter: const _VoucherNativeAdapter(),
  webAdapter: const _VoucherWebAdapter(),
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

class _VoucherWebAdapter extends IsarWebTypeAdapter<Voucher> {
  const _VoucherWebAdapter();

  @override
  Object serialize(IsarCollection<Voucher> collection, Voucher object) {
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
  Voucher deserialize(IsarCollection<Voucher> collection, dynamic jsObj) {
    final object = Voucher(
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
  void attachLinks(Isar isar, int id, Voucher object) {
    object.features.attach(
      id,
      isar.vouchers,
      isar.getCollection<Feature>('Feature'),
      'features',
      false,
    );
  }
}

class _VoucherNativeAdapter extends IsarNativeTypeAdapter<Voucher> {
  const _VoucherNativeAdapter();

  @override
  void serialize(IsarCollection<Voucher> collection, IsarRawObject rawObj,
      Voucher object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
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
  Voucher deserialize(IsarCollection<Voucher> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Voucher(
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
  void attachLinks(Isar isar, int id, Voucher object) {
    object.features.attach(
      id,
      isar.vouchers,
      isar.getCollection<Feature>('Feature'),
      'features',
      false,
    );
  }
}

extension VoucherQueryWhereSort on QueryBuilder<Voucher, Voucher, QWhere> {
  QueryBuilder<Voucher, Voucher, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension VoucherQueryWhere on QueryBuilder<Voucher, Voucher, QWhereClause> {
  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterWhereClause> idBetween(
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

extension VoucherQueryFilter
    on QueryBuilder<Voucher, Voucher, QFilterCondition> {
  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEqualTo(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorStartsWith(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorEndsWith(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'descriptor',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> descriptorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'descriptor',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'interval',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> intervalBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'used',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'usedAt',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> usedAtBetween(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'value',
      value: value,
    ));
  }

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueGreaterThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueLessThan(
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

  QueryBuilder<Voucher, Voucher, QAfterFilterCondition> valueBetween(
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

extension VoucherQueryWhereSortBy on QueryBuilder<Voucher, Voucher, QSortBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsed() {
    return addSortByInternal('used', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedDesc() {
    return addSortByInternal('used', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAt() {
    return addSortByInternal('usedAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByUsedAtDesc() {
    return addSortByInternal('usedAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension VoucherQueryWhereSortThenBy
    on QueryBuilder<Voucher, Voucher, QSortThenBy> {
  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptor() {
    return addSortByInternal('descriptor', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByDescriptorDesc() {
    return addSortByInternal('descriptor', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByInterval() {
    return addSortByInternal('interval', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByIntervalDesc() {
    return addSortByInternal('interval', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsed() {
    return addSortByInternal('used', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedDesc() {
    return addSortByInternal('used', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAt() {
    return addSortByInternal('usedAt', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByUsedAtDesc() {
    return addSortByInternal('usedAt', Sort.desc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Voucher, Voucher, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension VoucherQueryWhereDistinct
    on QueryBuilder<Voucher, Voucher, QDistinct> {
  QueryBuilder<Voucher, Voucher, QDistinct> distinctByCreatedAt() {
    return addDistinctByInternal('createdAt');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByDescriptor(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('descriptor', caseSensitive: caseSensitive);
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByInterval() {
    return addDistinctByInternal('interval');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByUsed() {
    return addDistinctByInternal('used');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByUsedAt() {
    return addDistinctByInternal('usedAt');
  }

  QueryBuilder<Voucher, Voucher, QDistinct> distinctByValue() {
    return addDistinctByInternal('value');
  }
}

extension VoucherQueryProperty
    on QueryBuilder<Voucher, Voucher, QQueryProperty> {
  QueryBuilder<Voucher, int, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Voucher, String, QQueryOperations> descriptorProperty() {
    return addPropertyNameInternal('descriptor');
  }

  QueryBuilder<Voucher, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Voucher, int, QQueryOperations> intervalProperty() {
    return addPropertyNameInternal('interval');
  }

  QueryBuilder<Voucher, bool, QQueryOperations> usedProperty() {
    return addPropertyNameInternal('used');
  }

  QueryBuilder<Voucher, int, QQueryOperations> usedAtProperty() {
    return addPropertyNameInternal('usedAt');
  }

  QueryBuilder<Voucher, int, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
