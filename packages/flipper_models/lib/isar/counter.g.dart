// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetCounterCollection on Isar {
  IsarCollection<Counter> get counters => collection();
}

const CounterSchema = CollectionSchema(
  name: r'Counter',
  schema:
      r'{"name":"Counter","idName":"id","properties":[{"name":"backed","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"businessId","type":"Long"},{"name":"curRcptNo","type":"Long"},{"name":"receiptType","type":"String"},{"name":"totRcptNo","type":"Long"}],"indexes":[],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'backed': 0,
    r'branchId': 1,
    r'businessId': 2,
    r'curRcptNo': 3,
    r'receiptType': 4,
    r'totRcptNo': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _counterGetId,
  setId: _counterSetId,
  getLinks: _counterGetLinks,
  attachLinks: _counterAttachLinks,
  serializeNative: _counterSerializeNative,
  deserializeNative: _counterDeserializeNative,
  deserializePropNative: _counterDeserializePropNative,
  serializeWeb: _counterSerializeWeb,
  deserializeWeb: _counterDeserializeWeb,
  deserializePropWeb: _counterDeserializePropWeb,
  version: 4,
);

int? _counterGetId(Counter object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _counterSetId(Counter object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _counterGetLinks(Counter object) {
  return [];
}

void _counterSerializeNative(
    IsarCollection<Counter> collection,
    IsarCObject cObj,
    Counter object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final receiptType$Bytes =
      IsarBinaryWriter.utf8Encoder.convert(object.receiptType);
  final size = (staticSize + 3 + (receiptType$Bytes.length)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeBool(offsets[0], object.backed);
  writer.writeLong(offsets[1], object.branchId);
  writer.writeLong(offsets[2], object.businessId);
  writer.writeLong(offsets[3], object.curRcptNo);
  writer.writeByteList(offsets[4], receiptType$Bytes);
  writer.writeLong(offsets[5], object.totRcptNo);
}

Counter _counterDeserializeNative(IsarCollection<Counter> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Counter(
    backed: reader.readBoolOrNull(offsets[0]),
    id: id,
  );
  object.branchId = reader.readLong(offsets[1]);
  object.businessId = reader.readLong(offsets[2]);
  object.curRcptNo = reader.readLong(offsets[3]);
  object.receiptType = reader.readString(offsets[4]);
  object.totRcptNo = reader.readLong(offsets[5]);
  return object;
}

P _counterDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _counterSerializeWeb(
    IsarCollection<Counter> collection, Counter object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'backed', object.backed);
  IsarNative.jsObjectSet(jsObj, r'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, r'businessId', object.businessId);
  IsarNative.jsObjectSet(jsObj, r'curRcptNo', object.curRcptNo);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'receiptType', object.receiptType);
  IsarNative.jsObjectSet(jsObj, r'totRcptNo', object.totRcptNo);
  return jsObj;
}

Counter _counterDeserializeWeb(
    IsarCollection<Counter> collection, Object jsObj) {
  final object = Counter(
    backed: IsarNative.jsObjectGet(jsObj, r'backed'),
    id: IsarNative.jsObjectGet(jsObj, r'id'),
  );
  object.branchId = IsarNative.jsObjectGet(jsObj, r'branchId') ??
      (double.negativeInfinity as int);
  object.businessId = IsarNative.jsObjectGet(jsObj, r'businessId') ??
      (double.negativeInfinity as int);
  object.curRcptNo = IsarNative.jsObjectGet(jsObj, r'curRcptNo') ??
      (double.negativeInfinity as int);
  object.receiptType = IsarNative.jsObjectGet(jsObj, r'receiptType') ?? '';
  object.totRcptNo = IsarNative.jsObjectGet(jsObj, r'totRcptNo') ??
      (double.negativeInfinity as int);
  return object;
}

P _counterDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'backed':
      return (IsarNative.jsObjectGet(jsObj, r'backed')) as P;
    case r'branchId':
      return (IsarNative.jsObjectGet(jsObj, r'branchId') ??
          (double.negativeInfinity as int)) as P;
    case r'businessId':
      return (IsarNative.jsObjectGet(jsObj, r'businessId') ??
          (double.negativeInfinity as int)) as P;
    case r'curRcptNo':
      return (IsarNative.jsObjectGet(jsObj, r'curRcptNo') ??
          (double.negativeInfinity as int)) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'receiptType':
      return (IsarNative.jsObjectGet(jsObj, r'receiptType') ?? '') as P;
    case r'totRcptNo':
      return (IsarNative.jsObjectGet(jsObj, r'totRcptNo') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _counterAttachLinks(IsarCollection<dynamic> col, int id, Counter object) {}

extension CounterQueryWhereSort on QueryBuilder<Counter, Counter, QWhere> {
  QueryBuilder<Counter, Counter, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CounterQueryWhere on QueryBuilder<Counter, Counter, QWhereClause> {
  QueryBuilder<Counter, Counter, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Counter, Counter, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Counter, Counter, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Counter, Counter, QAfterWhereClause> idBetween(
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

extension CounterQueryFilter
    on QueryBuilder<Counter, Counter, QFilterCondition> {
  QueryBuilder<Counter, Counter, QAfterFilterCondition> backedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'backed',
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> backedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'backed',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> branchIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> branchIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'branchId',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'branchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> businessIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> businessIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> businessIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessId',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> businessIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> curRcptNoEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'curRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> curRcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'curRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> curRcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'curRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> curRcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'curRcptNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Counter, Counter, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Counter, Counter, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiptType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiptType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> receiptTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiptType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> totRcptNoEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> totRcptNoGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> totRcptNoLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totRcptNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Counter, Counter, QAfterFilterCondition> totRcptNoBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totRcptNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CounterQueryLinks
    on QueryBuilder<Counter, Counter, QFilterCondition> {}

extension CounterQueryWhereSortBy on QueryBuilder<Counter, Counter, QSortBy> {
  QueryBuilder<Counter, Counter, QAfterSortBy> sortByBacked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backed', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByBackedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backed', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByCurRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByCurRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByReceiptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByReceiptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> sortByTotRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.desc);
    });
  }
}

extension CounterQueryWhereSortThenBy
    on QueryBuilder<Counter, Counter, QSortThenBy> {
  QueryBuilder<Counter, Counter, QAfterSortBy> thenByBacked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backed', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByBackedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'backed', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branchId', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByBusinessIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessId', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByCurRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByCurRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'curRcptNo', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByReceiptType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByReceiptTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptType', Sort.desc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.asc);
    });
  }

  QueryBuilder<Counter, Counter, QAfterSortBy> thenByTotRcptNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totRcptNo', Sort.desc);
    });
  }
}

extension CounterQueryWhereDistinct
    on QueryBuilder<Counter, Counter, QDistinct> {
  QueryBuilder<Counter, Counter, QDistinct> distinctByBacked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'backed');
    });
  }

  QueryBuilder<Counter, Counter, QDistinct> distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branchId');
    });
  }

  QueryBuilder<Counter, Counter, QDistinct> distinctByBusinessId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessId');
    });
  }

  QueryBuilder<Counter, Counter, QDistinct> distinctByCurRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'curRcptNo');
    });
  }

  QueryBuilder<Counter, Counter, QDistinct> distinctByReceiptType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Counter, Counter, QDistinct> distinctByTotRcptNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totRcptNo');
    });
  }
}

extension CounterQueryProperty
    on QueryBuilder<Counter, Counter, QQueryProperty> {
  QueryBuilder<Counter, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Counter, bool?, QQueryOperations> backedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'backed');
    });
  }

  QueryBuilder<Counter, int, QQueryOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branchId');
    });
  }

  QueryBuilder<Counter, int, QQueryOperations> businessIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessId');
    });
  }

  QueryBuilder<Counter, int, QQueryOperations> curRcptNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'curRcptNo');
    });
  }

  QueryBuilder<Counter, String, QQueryOperations> receiptTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptType');
    });
  }

  QueryBuilder<Counter, int, QQueryOperations> totRcptNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totRcptNo');
    });
  }
}
