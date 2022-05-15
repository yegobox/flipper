// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetUnitCollection on Isar {
  IsarCollection<Unit> get units => getCollection();
}

const UnitSchema = CollectionSchema(
  name: 'Unit',
  schema:
      '{"name":"Unit","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"name","type":"String"},{"name":"value","type":"String"}],"indexes":[{"name":"branchId","unique":false,"replace":false,"properties":[{"name":"branchId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {'active': 0, 'branchId': 1, 'name': 2, 'value': 3},
  listProperties: {},
  indexIds: {'branchId': 0},
  indexValueTypes: {
    'branchId': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _unitGetId,
  setId: _unitSetId,
  getLinks: _unitGetLinks,
  attachLinks: _unitAttachLinks,
  serializeNative: _unitSerializeNative,
  deserializeNative: _unitDeserializeNative,
  deserializePropNative: _unitDeserializePropNative,
  serializeWeb: _unitSerializeWeb,
  deserializeWeb: _unitDeserializeWeb,
  deserializePropWeb: _unitDeserializePropWeb,
  version: 4,
);

int? _unitGetId(Unit object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _unitSetId(Unit object, int id) {
  object.id = id;
}

List<IsarLinkBase> _unitGetLinks(Unit object) {
  return [];
}

void _unitSerializeNative(IsarCollection<Unit> collection, IsarCObject cObj,
    Unit object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.active;
  final _active = value0;
  final value1 = object.branchId;
  final _branchId = value1;
  final value2 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_name.length) as int;
  final value3 = object.value;
  final _value = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_value.length) as int;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _active);
  writer.writeLong(offsets[1], _branchId);
  writer.writeBytes(offsets[2], _name);
  writer.writeBytes(offsets[3], _value);
}

Unit _unitDeserializeNative(IsarCollection<Unit> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Unit();
  object.active = reader.readBool(offsets[0]);
  object.branchId = reader.readLong(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  object.value = reader.readString(offsets[3]);
  return object;
}

P _unitDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _unitSerializeWeb(IsarCollection<Unit> collection, Unit object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'active', object.active);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'value', object.value);
  return jsObj;
}

Unit _unitDeserializeWeb(IsarCollection<Unit> collection, dynamic jsObj) {
  final object = Unit();
  object.active = IsarNative.jsObjectGet(jsObj, 'active') ?? false;
  object.branchId =
      IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
  object.value = IsarNative.jsObjectGet(jsObj, 'value') ?? '';
  return object;
}

P _unitDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'active':
      return (IsarNative.jsObjectGet(jsObj, 'active') ?? false) as P;
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'value':
      return (IsarNative.jsObjectGet(jsObj, 'value') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _unitAttachLinks(IsarCollection col, int id, Unit object) {}

extension UnitQueryWhereSort on QueryBuilder<Unit, Unit, QWhere> {
  QueryBuilder<Unit, Unit, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Unit, Unit, QAfterWhere> anyBranchId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'branchId'));
  }
}

extension UnitQueryWhere on QueryBuilder<Unit, Unit, QWhereClause> {
  QueryBuilder<Unit, Unit, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Unit, Unit, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> idBetween(
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

  QueryBuilder<Unit, Unit, QAfterWhereClause> branchIdEqualTo(int branchId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'branchId',
      value: [branchId],
    ));
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> branchIdNotEqualTo(int branchId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'branchId',
        upper: [branchId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'branchId',
        lower: [branchId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'branchId',
        lower: [branchId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'branchId',
        upper: [branchId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> branchIdGreaterThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'branchId',
      lower: [branchId],
      includeLower: include,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> branchIdLessThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'branchId',
      upper: [branchId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterWhereClause> branchIdBetween(
    int lowerBranchId,
    int upperBranchId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'branchId',
      lower: [lowerBranchId],
      includeLower: includeLower,
      upper: [upperBranchId],
      includeUpper: includeUpper,
    ));
  }
}

extension UnitQueryFilter on QueryBuilder<Unit, Unit, QFilterCondition> {
  QueryBuilder<Unit, Unit, QAfterFilterCondition> activeEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> branchIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'value',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'value',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Unit, Unit, QAfterFilterCondition> valueMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'value',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension UnitQueryLinks on QueryBuilder<Unit, Unit, QFilterCondition> {}

extension UnitQueryWhereSortBy on QueryBuilder<Unit, Unit, QSortBy> {
  QueryBuilder<Unit, Unit, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> sortByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension UnitQueryWhereSortThenBy on QueryBuilder<Unit, Unit, QSortThenBy> {
  QueryBuilder<Unit, Unit, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByValue() {
    return addSortByInternal('value', Sort.asc);
  }

  QueryBuilder<Unit, Unit, QAfterSortBy> thenByValueDesc() {
    return addSortByInternal('value', Sort.desc);
  }
}

extension UnitQueryWhereDistinct on QueryBuilder<Unit, Unit, QDistinct> {
  QueryBuilder<Unit, Unit, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<Unit, Unit, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Unit, Unit, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Unit, Unit, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Unit, Unit, QDistinct> distinctByValue(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('value', caseSensitive: caseSensitive);
  }
}

extension UnitQueryProperty on QueryBuilder<Unit, Unit, QQueryProperty> {
  QueryBuilder<Unit, bool, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<Unit, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Unit, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Unit, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Unit, String, QQueryOperations> valueProperty() {
    return addPropertyNameInternal('value');
  }
}
