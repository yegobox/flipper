// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetPermissionsyncCollection on Isar {
  IsarCollection<Permissionsync> get permissionsyncs {
    return getCollection('Permissionsync');
  }
}

final PermissionsyncSchema = CollectionSchema(
  name: 'Permissionsync',
  schema:
      '{"name":"Permissionsync","idName":"id","properties":[{"name":"name","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _PermissionsyncNativeAdapter(),
  webAdapter: const _PermissionsyncWebAdapter(),
  idName: 'id',
  propertyIds: {'name': 0},
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

class _PermissionsyncWebAdapter extends IsarWebTypeAdapter<Permissionsync> {
  const _PermissionsyncWebAdapter();

  @override
  Object serialize(
      IsarCollection<Permissionsync> collection, Permissionsync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    return jsObj;
  }

  @override
  Permissionsync deserialize(
      IsarCollection<Permissionsync> collection, dynamic jsObj) {
    final object = Permissionsync(
      id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
      name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
    );
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Permissionsync object) {}
}

class _PermissionsyncNativeAdapter
    extends IsarNativeTypeAdapter<Permissionsync> {
  const _PermissionsyncNativeAdapter();

  @override
  void serialize(
      IsarCollection<Permissionsync> collection,
      IsarRawObject rawObj,
      Permissionsync object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.name;
    final _name = IsarBinaryWriter.utf8Encoder.convert(value0);
    dynamicSize += (_name.length) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _name);
  }

  @override
  Permissionsync deserialize(IsarCollection<Permissionsync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Permissionsync(
      id: id,
      name: reader.readString(offsets[0]),
    );
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readString(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, Permissionsync object) {}
}

extension PermissionsyncQueryWhereSort
    on QueryBuilder<Permissionsync, Permissionsync, QWhere> {
  QueryBuilder<Permissionsync, Permissionsync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension PermissionsyncQueryWhere
    on QueryBuilder<Permissionsync, Permissionsync, QWhereClause> {
  QueryBuilder<Permissionsync, Permissionsync, QAfterWhereClause> idEqualTo(
      int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterWhereClause> idNotEqualTo(
      int id) {
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterWhereClause> idBetween(
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

extension PermissionsyncQueryFilter
    on QueryBuilder<Permissionsync, Permissionsync, QFilterCondition> {
  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension PermissionsyncQueryWhereSortBy
    on QueryBuilder<Permissionsync, Permissionsync, QSortBy> {
  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension PermissionsyncQueryWhereSortThenBy
    on QueryBuilder<Permissionsync, Permissionsync, QSortThenBy> {
  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Permissionsync, Permissionsync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension PermissionsyncQueryWhereDistinct
    on QueryBuilder<Permissionsync, Permissionsync, QDistinct> {
  QueryBuilder<Permissionsync, Permissionsync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Permissionsync, Permissionsync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }
}

extension PermissionsyncQueryProperty
    on QueryBuilder<Permissionsync, Permissionsync, QQueryProperty> {
  QueryBuilder<Permissionsync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Permissionsync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }
}
