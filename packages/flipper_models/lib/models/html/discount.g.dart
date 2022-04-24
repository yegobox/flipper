// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetDiscountSyncCollection on Isar {
  IsarCollection<DiscountSync> get discountSyncs => getCollection();
}

const DiscountSyncSchema = CollectionSchema(
  name: 'DiscountSync',
  schema:
      '{"name":"DiscountSync","idName":"id","properties":[{"name":"amount","type":"Long"},{"name":"branchId","type":"Long"},{"name":"name","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {'amount': 0, 'branchId': 1, 'name': 2},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _discountSyncGetId,
  setId: _discountSyncSetId,
  getLinks: _discountSyncGetLinks,
  attachLinks: _discountSyncAttachLinks,
  serializeNative: _discountSyncSerializeNative,
  deserializeNative: _discountSyncDeserializeNative,
  deserializePropNative: _discountSyncDeserializePropNative,
  serializeWeb: _discountSyncSerializeWeb,
  deserializeWeb: _discountSyncDeserializeWeb,
  deserializePropWeb: _discountSyncDeserializePropWeb,
  version: 3,
);

int? _discountSyncGetId(DiscountSync object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _discountSyncSetId(DiscountSync object, int id) {
  object.id = id;
}

List<IsarLinkBase> _discountSyncGetLinks(DiscountSync object) {
  return [];
}

void _discountSyncSerializeNative(
    IsarCollection<DiscountSync> collection,
    IsarRawObject rawObj,
    DiscountSync object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.amount;
  final _amount = value0;
  final value1 = object.branchId;
  final _branchId = value1;
  final value2 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_name.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _amount);
  writer.writeLong(offsets[1], _branchId);
  writer.writeBytes(offsets[2], _name);
}

DiscountSync _discountSyncDeserializeNative(
    IsarCollection<DiscountSync> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = DiscountSync(
    amount: reader.readLongOrNull(offsets[0]),
    branchId: reader.readLong(offsets[1]),
    id: id,
    name: reader.readString(offsets[2]),
  );
  return object;
}

P _discountSyncDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _discountSyncSerializeWeb(
    IsarCollection<DiscountSync> collection, DiscountSync object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'amount', object.amount);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  return jsObj;
}

DiscountSync _discountSyncDeserializeWeb(
    IsarCollection<DiscountSync> collection, dynamic jsObj) {
  final object = DiscountSync(
    amount: IsarNative.jsObjectGet(jsObj, 'amount'),
    branchId:
        IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity,
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
  );
  return object;
}

P _discountSyncDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'amount':
      return (IsarNative.jsObjectGet(jsObj, 'amount')) as P;
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _discountSyncAttachLinks(
    IsarCollection col, int id, DiscountSync object) {}

extension DiscountSyncQueryWhereSort
    on QueryBuilder<DiscountSync, DiscountSync, QWhere> {
  QueryBuilder<DiscountSync, DiscountSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension DiscountSyncQueryWhere
    on QueryBuilder<DiscountSync, DiscountSync, QWhereClause> {
  QueryBuilder<DiscountSync, DiscountSync, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterWhereClause> idBetween(
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

extension DiscountSyncQueryFilter
    on QueryBuilder<DiscountSync, DiscountSync, QFilterCondition> {
  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      amountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'amount',
      value: null,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> amountEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      amountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      amountLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> amountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'amount',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      branchIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
      branchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'branchId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition>
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension DiscountSyncQueryLinks
    on QueryBuilder<DiscountSync, DiscountSync, QFilterCondition> {}

extension DiscountSyncQueryWhereSortBy
    on QueryBuilder<DiscountSync, DiscountSync, QSortBy> {
  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByAmount() {
    return addSortByInternal('amount', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByAmountDesc() {
    return addSortByInternal('amount', Sort.desc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension DiscountSyncQueryWhereSortThenBy
    on QueryBuilder<DiscountSync, DiscountSync, QSortThenBy> {
  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByAmount() {
    return addSortByInternal('amount', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByAmountDesc() {
    return addSortByInternal('amount', Sort.desc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<DiscountSync, DiscountSync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension DiscountSyncQueryWhereDistinct
    on QueryBuilder<DiscountSync, DiscountSync, QDistinct> {
  QueryBuilder<DiscountSync, DiscountSync, QDistinct> distinctByAmount() {
    return addDistinctByInternal('amount');
  }

  QueryBuilder<DiscountSync, DiscountSync, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<DiscountSync, DiscountSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<DiscountSync, DiscountSync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }
}

extension DiscountSyncQueryProperty
    on QueryBuilder<DiscountSync, DiscountSync, QQueryProperty> {
  QueryBuilder<DiscountSync, int?, QQueryOperations> amountProperty() {
    return addPropertyNameInternal('amount');
  }

  QueryBuilder<DiscountSync, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<DiscountSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<DiscountSync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }
}
