// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetPColorCollection on Isar {
  IsarCollection<PColor> get pColors {
    return getCollection('PColor');
  }
}

final PColorSchema = CollectionSchema(
  name: 'PColor',
  schema:
      '{"name":"PColor","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"channels","type":"StringList"},{"name":"colors","type":"StringList"},{"name":"name","type":"String"},{"name":"table","type":"String"}],"indexes":[],"links":[]}',
  nativeAdapter: const _PColorNativeAdapter(),
  webAdapter: const _PColorWebAdapter(),
  idName: 'id',
  propertyIds: {
    'active': 0,
    'branchId': 1,
    'channels': 2,
    'colors': 3,
    'name': 4,
    'table': 5
  },
  listProperties: {'channels', 'colors'},
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

class _PColorWebAdapter extends IsarWebTypeAdapter<PColor> {
  const _PColorWebAdapter();

  @override
  Object serialize(IsarCollection<PColor> collection, PColor object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'active', object.active);
    IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
    IsarNative.jsObjectSet(jsObj, 'channels', object.channels);
    IsarNative.jsObjectSet(jsObj, 'colors', object.colors);
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'table', object.table);
    return jsObj;
  }

  @override
  PColor deserialize(IsarCollection<PColor> collection, dynamic jsObj) {
    final object = PColor();
    object.active = IsarNative.jsObjectGet(jsObj, 'active') ?? false;
    object.branchId = IsarNative.jsObjectGet(jsObj, 'branchId');
    object.channels = (IsarNative.jsObjectGet(jsObj, 'channels') as List?)
        ?.map((e) => e ?? '')
        .toList()
        .cast<String>();
    object.colors = (IsarNative.jsObjectGet(jsObj, 'colors') as List?)
        ?.map((e) => e ?? '')
        .toList()
        .cast<String>();
    object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
    object.name = IsarNative.jsObjectGet(jsObj, 'name');
    object.table = IsarNative.jsObjectGet(jsObj, 'table');
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'active':
        return (IsarNative.jsObjectGet(jsObj, 'active') ?? false) as P;
      case 'branchId':
        return (IsarNative.jsObjectGet(jsObj, 'branchId')) as P;
      case 'channels':
        return ((IsarNative.jsObjectGet(jsObj, 'channels') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>()) as P;
      case 'colors':
        return ((IsarNative.jsObjectGet(jsObj, 'colors') as List?)
            ?.map((e) => e ?? '')
            .toList()
            .cast<String>()) as P;
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
            as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name')) as P;
      case 'table':
        return (IsarNative.jsObjectGet(jsObj, 'table')) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, PColor object) {}
}

class _PColorNativeAdapter extends IsarNativeTypeAdapter<PColor> {
  const _PColorNativeAdapter();

  @override
  void serialize(IsarCollection<PColor> collection, IsarRawObject rawObj,
      PColor object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.active;
    final _active = value0;
    final value1 = object.branchId;
    final _branchId = value1;
    final value2 = object.channels;
    dynamicSize += (value2?.length ?? 0) * 8;
    List<IsarUint8List?>? bytesList2;
    if (value2 != null) {
      bytesList2 = [];
      for (var str in value2) {
        final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
        bytesList2.add(bytes);
        dynamicSize += bytes.length as int;
      }
    }
    final _channels = bytesList2;
    final value3 = object.colors;
    dynamicSize += (value3?.length ?? 0) * 8;
    List<IsarUint8List?>? bytesList3;
    if (value3 != null) {
      bytesList3 = [];
      for (var str in value3) {
        final bytes = IsarBinaryWriter.utf8Encoder.convert(str);
        bytesList3.add(bytes);
        dynamicSize += bytes.length as int;
      }
    }
    final _colors = bytesList3;
    final value4 = object.name;
    IsarUint8List? _name;
    if (value4 != null) {
      _name = IsarBinaryWriter.utf8Encoder.convert(value4);
    }
    dynamicSize += (_name?.length ?? 0) as int;
    final value5 = object.table;
    IsarUint8List? _table;
    if (value5 != null) {
      _table = IsarBinaryWriter.utf8Encoder.convert(value5);
    }
    dynamicSize += (_table?.length ?? 0) as int;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBool(offsets[0], _active);
    writer.writeLong(offsets[1], _branchId);
    writer.writeStringList(offsets[2], _channels);
    writer.writeStringList(offsets[3], _colors);
    writer.writeBytes(offsets[4], _name);
    writer.writeBytes(offsets[5], _table);
  }

  @override
  PColor deserialize(IsarCollection<PColor> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = PColor();
    object.active = reader.readBool(offsets[0]);
    object.branchId = reader.readLongOrNull(offsets[1]);
    object.channels = reader.readStringList(offsets[2]);
    object.colors = reader.readStringList(offsets[3]);
    object.id = id;
    object.name = reader.readStringOrNull(offsets[4]);
    object.table = reader.readStringOrNull(offsets[5]);
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readBool(offset)) as P;
      case 1:
        return (reader.readLongOrNull(offset)) as P;
      case 2:
        return (reader.readStringList(offset)) as P;
      case 3:
        return (reader.readStringList(offset)) as P;
      case 4:
        return (reader.readStringOrNull(offset)) as P;
      case 5:
        return (reader.readStringOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, PColor object) {}
}

extension PColorQueryWhereSort on QueryBuilder<PColor, PColor, QWhere> {
  QueryBuilder<PColor, PColor, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension PColorQueryWhere on QueryBuilder<PColor, PColor, QWhereClause> {
  QueryBuilder<PColor, PColor, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<PColor, PColor, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterWhereClause> idBetween(
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

extension PColorQueryFilter on QueryBuilder<PColor, PColor, QFilterCondition> {
  QueryBuilder<PColor, PColor, QAfterFilterCondition> activeEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> branchIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'branchId',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> branchIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> branchIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> branchIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> branchIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'channels',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'channels',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> channelsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'channels',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'colors',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'colors',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'colors',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'colors',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'colors',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'colors',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'colors',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'colors',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'colors',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> colorsAnyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'colors',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'name',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameGreaterThan(
    String? value, {
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameLessThan(
    String? value, {
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'table',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<PColor, PColor, QAfterFilterCondition> tableMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'table',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension PColorQueryWhereSortBy on QueryBuilder<PColor, PColor, QSortBy> {
  QueryBuilder<PColor, PColor, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }
}

extension PColorQueryWhereSortThenBy
    on QueryBuilder<PColor, PColor, QSortThenBy> {
  QueryBuilder<PColor, PColor, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<PColor, PColor, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }
}

extension PColorQueryWhereDistinct on QueryBuilder<PColor, PColor, QDistinct> {
  QueryBuilder<PColor, PColor, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<PColor, PColor, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<PColor, PColor, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<PColor, PColor, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<PColor, PColor, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }
}

extension PColorQueryProperty on QueryBuilder<PColor, PColor, QQueryProperty> {
  QueryBuilder<PColor, bool, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<PColor, int?, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<PColor, List<String>?, QQueryOperations> channelsProperty() {
    return addPropertyNameInternal('channels');
  }

  QueryBuilder<PColor, List<String>?, QQueryOperations> colorsProperty() {
    return addPropertyNameInternal('colors');
  }

  QueryBuilder<PColor, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<PColor, String?, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<PColor, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }
}
