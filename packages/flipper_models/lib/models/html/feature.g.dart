// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetFeatureCollection on Isar {
  IsarCollection<Feature> get features {
    return getCollection('Feature');
  }
}

final FeatureSchema = CollectionSchema(
  name: 'Feature',
  schema:
      '{"name":"Feature","idName":"id","properties":[{"name":"name","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _FeatureNativeAdapter(),
  webAdapter: const _FeatureWebAdapter(),
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

class _FeatureWebAdapter extends IsarWebTypeAdapter<Feature> {
  const _FeatureWebAdapter();

  @override
  Object serialize(IsarCollection<Feature> collection, Feature object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    return jsObj;
  }

  @override
  Feature deserialize(IsarCollection<Feature> collection, dynamic jsObj) {
    final object = Feature(
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
  void attachLinks(Isar isar, int id, Feature object) {}
}

class _FeatureNativeAdapter extends IsarNativeTypeAdapter<Feature> {
  const _FeatureNativeAdapter();

  @override
  void serialize(IsarCollection<Feature> collection, IsarRawObject rawObj,
      Feature object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
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
  Feature deserialize(IsarCollection<Feature> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = Feature(
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
  void attachLinks(Isar isar, int id, Feature object) {}
}

extension FeatureQueryWhereSort on QueryBuilder<Feature, Feature, QWhere> {
  QueryBuilder<Feature, Feature, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension FeatureQueryWhere on QueryBuilder<Feature, Feature, QWhereClause> {
  QueryBuilder<Feature, Feature, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<Feature, Feature, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Feature, Feature, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<Feature, Feature, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<Feature, Feature, QAfterWhereClause> idBetween(
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

extension FeatureQueryFilter
    on QueryBuilder<Feature, Feature, QFilterCondition> {
  QueryBuilder<Feature, Feature, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Feature, Feature, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Feature, Feature, QAfterFilterCondition> nameMatches(
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

extension FeatureQueryWhereSortBy on QueryBuilder<Feature, Feature, QSortBy> {
  QueryBuilder<Feature, Feature, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Feature, Feature, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Feature, Feature, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Feature, Feature, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension FeatureQueryWhereSortThenBy
    on QueryBuilder<Feature, Feature, QSortThenBy> {
  QueryBuilder<Feature, Feature, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Feature, Feature, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Feature, Feature, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Feature, Feature, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }
}

extension FeatureQueryWhereDistinct
    on QueryBuilder<Feature, Feature, QDistinct> {
  QueryBuilder<Feature, Feature, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Feature, Feature, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }
}

extension FeatureQueryProperty
    on QueryBuilder<Feature, Feature, QQueryProperty> {
  QueryBuilder<Feature, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Feature, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }
}
