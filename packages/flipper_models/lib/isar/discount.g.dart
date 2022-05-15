// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetDiscountCollection on Isar {
  IsarCollection<Discount> get discounts => getCollection();
}

const DiscountSchema = CollectionSchema(
  name: 'Discount',
  schema:
      '{"name":"Discount","idName":"id","properties":[{"name":"amount","type":"Double"},{"name":"branchId","type":"Long"},{"name":"name","type":"String"}],"indexes":[{"name":"branchId","unique":false,"replace":false,"properties":[{"name":"branchId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: 'id',
  propertyIds: {'amount': 0, 'branchId': 1, 'name': 2},
  listProperties: {},
  indexIds: {'branchId': 0},
  indexValueTypes: {
    'branchId': [
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _discountGetId,
  setId: _discountSetId,
  getLinks: _discountGetLinks,
  attachLinks: _discountAttachLinks,
  serializeNative: _discountSerializeNative,
  deserializeNative: _discountDeserializeNative,
  deserializePropNative: _discountDeserializePropNative,
  serializeWeb: _discountSerializeWeb,
  deserializeWeb: _discountDeserializeWeb,
  deserializePropWeb: _discountDeserializePropWeb,
  version: 4,
);

int? _discountGetId(Discount object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _discountSetId(Discount object, int id) {
  object.id = id;
}

List<IsarLinkBase> _discountGetLinks(Discount object) {
  return [];
}

void _discountSerializeNative(
    IsarCollection<Discount> collection,
    IsarCObject cObj,
    Discount object,
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

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeDouble(offsets[0], _amount);
  writer.writeLong(offsets[1], _branchId);
  writer.writeBytes(offsets[2], _name);
}

Discount _discountDeserializeNative(IsarCollection<Discount> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Discount(
    amount: reader.readDoubleOrNull(offsets[0]),
    branchId: reader.readLong(offsets[1]),
    id: id,
    name: reader.readString(offsets[2]),
  );
  return object;
}

P _discountDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _discountSerializeWeb(
    IsarCollection<Discount> collection, Discount object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'amount', object.amount);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  return jsObj;
}

Discount _discountDeserializeWeb(
    IsarCollection<Discount> collection, dynamic jsObj) {
  final object = Discount(
    amount: IsarNative.jsObjectGet(jsObj, 'amount'),
    branchId:
        IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity,
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
  );
  return object;
}

P _discountDeserializePropWeb<P>(Object jsObj, String propertyName) {
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

void _discountAttachLinks(IsarCollection col, int id, Discount object) {}

extension DiscountQueryWhereSort on QueryBuilder<Discount, Discount, QWhere> {
  QueryBuilder<Discount, Discount, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Discount, Discount, QAfterWhere> anyBranchId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'branchId'));
  }
}

extension DiscountQueryWhere on QueryBuilder<Discount, Discount, QWhereClause> {
  QueryBuilder<Discount, Discount, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Discount, Discount, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Discount, Discount, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Discount, Discount, QAfterWhereClause> idBetween(
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

  QueryBuilder<Discount, Discount, QAfterWhereClause> branchIdEqualTo(
      int branchId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'branchId',
      value: [branchId],
    ));
  }

  QueryBuilder<Discount, Discount, QAfterWhereClause> branchIdNotEqualTo(
      int branchId) {
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

  QueryBuilder<Discount, Discount, QAfterWhereClause> branchIdGreaterThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'branchId',
      lower: [branchId],
      includeLower: include,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterWhereClause> branchIdLessThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'branchId',
      upper: [branchId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterWhereClause> branchIdBetween(
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

extension DiscountQueryFilter
    on QueryBuilder<Discount, Discount, QFilterCondition> {
  QueryBuilder<Discount, Discount, QAfterFilterCondition> amountIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'amount',
      value: null,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> amountGreaterThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> amountLessThan(
      double? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'amount',
      value: value,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> amountBetween(
      double? lower, double? upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'amount',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Discount, Discount, QAfterFilterCondition> nameMatches(
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

extension DiscountQueryLinks
    on QueryBuilder<Discount, Discount, QFilterCondition> {}

extension DiscountQueryWhereSortBy
    on QueryBuilder<Discount, Discount, QSortBy> {
  QueryBuilder<Discount, Discount, QAfterSortBy> sortByAmount() {
    return addSortByInternal('amount', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortByAmountDesc() {
    return addSortByInternal('amount', Sort.desc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension DiscountQueryWhereSortThenBy
    on QueryBuilder<Discount, Discount, QSortThenBy> {
  QueryBuilder<Discount, Discount, QAfterSortBy> thenByAmount() {
    return addSortByInternal('amount', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenByAmountDesc() {
    return addSortByInternal('amount', Sort.desc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Discount, Discount, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension DiscountQueryWhereDistinct
    on QueryBuilder<Discount, Discount, QDistinct> {
  QueryBuilder<Discount, Discount, QDistinct> distinctByAmount() {
    return addDistinctByInternal('amount');
  }

  QueryBuilder<Discount, Discount, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Discount, Discount, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Discount, Discount, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }
}

extension DiscountQueryProperty
    on QueryBuilder<Discount, Discount, QQueryProperty> {
  QueryBuilder<Discount, double?, QQueryOperations> amountProperty() {
    return addPropertyNameInternal('amount');
  }

  QueryBuilder<Discount, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Discount, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Discount, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }
}
