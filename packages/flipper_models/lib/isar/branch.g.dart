// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetBranchCollection on Isar {
  IsarCollection<Branch> get branchs => getCollection();
}

const BranchSchema = CollectionSchema(
  name: 'Branch',
  schema:
      '{"name":"Branch","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"description","type":"String"},{"name":"fbusinessId","type":"Long"},{"name":"latitude","type":"String"},{"name":"longitude","type":"String"},{"name":"name","type":"String"},{"name":"table","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'active': 0,
    'description': 1,
    'fbusinessId': 2,
    'latitude': 3,
    'longitude': 4,
    'name': 5,
    'table': 6
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _branchGetId,
  setId: _branchSetId,
  getLinks: _branchGetLinks,
  attachLinks: _branchAttachLinks,
  serializeNative: _branchSerializeNative,
  deserializeNative: _branchDeserializeNative,
  deserializePropNative: _branchDeserializePropNative,
  serializeWeb: _branchSerializeWeb,
  deserializeWeb: _branchDeserializeWeb,
  deserializePropWeb: _branchDeserializePropWeb,
  version: 4,
);

int? _branchGetId(Branch object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _branchSetId(Branch object, int id) {
  object.id = id;
}

List<IsarLinkBase> _branchGetLinks(Branch object) {
  return [];
}

void _branchSerializeNative(IsarCollection<Branch> collection, IsarCObject cObj,
    Branch object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.active;
  final _active = value0;
  final value1 = object.description;
  IsarUint8List? _description;
  if (value1 != null) {
    _description = IsarBinaryWriter.utf8Encoder.convert(value1);
  }
  dynamicSize += (_description?.length ?? 0) as int;
  final value2 = object.fbusinessId;
  final _fbusinessId = value2;
  final value3 = object.latitude;
  IsarUint8List? _latitude;
  if (value3 != null) {
    _latitude = IsarBinaryWriter.utf8Encoder.convert(value3);
  }
  dynamicSize += (_latitude?.length ?? 0) as int;
  final value4 = object.longitude;
  IsarUint8List? _longitude;
  if (value4 != null) {
    _longitude = IsarBinaryWriter.utf8Encoder.convert(value4);
  }
  dynamicSize += (_longitude?.length ?? 0) as int;
  final value5 = object.name;
  IsarUint8List? _name;
  if (value5 != null) {
    _name = IsarBinaryWriter.utf8Encoder.convert(value5);
  }
  dynamicSize += (_name?.length ?? 0) as int;
  final value6 = object.table;
  IsarUint8List? _table;
  if (value6 != null) {
    _table = IsarBinaryWriter.utf8Encoder.convert(value6);
  }
  dynamicSize += (_table?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _active);
  writer.writeBytes(offsets[1], _description);
  writer.writeLong(offsets[2], _fbusinessId);
  writer.writeBytes(offsets[3], _latitude);
  writer.writeBytes(offsets[4], _longitude);
  writer.writeBytes(offsets[5], _name);
  writer.writeBytes(offsets[6], _table);
}

Branch _branchDeserializeNative(IsarCollection<Branch> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Branch(
    active: reader.readBoolOrNull(offsets[0]),
    description: reader.readStringOrNull(offsets[1]),
    fbusinessId: reader.readLongOrNull(offsets[2]),
    id: id,
    latitude: reader.readStringOrNull(offsets[3]),
    longitude: reader.readStringOrNull(offsets[4]),
    name: reader.readStringOrNull(offsets[5]),
    table: reader.readStringOrNull(offsets[6]),
  );
  return object;
}

P _branchDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _branchSerializeWeb(IsarCollection<Branch> collection, Branch object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'active', object.active);
  IsarNative.jsObjectSet(jsObj, 'description', object.description);
  IsarNative.jsObjectSet(jsObj, 'fbusinessId', object.fbusinessId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'latitude', object.latitude);
  IsarNative.jsObjectSet(jsObj, 'longitude', object.longitude);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'table', object.table);
  return jsObj;
}

Branch _branchDeserializeWeb(IsarCollection<Branch> collection, dynamic jsObj) {
  final object = Branch(
    active: IsarNative.jsObjectGet(jsObj, 'active'),
    description: IsarNative.jsObjectGet(jsObj, 'description'),
    fbusinessId: IsarNative.jsObjectGet(jsObj, 'fbusinessId'),
    id: IsarNative.jsObjectGet(jsObj, 'id'),
    latitude: IsarNative.jsObjectGet(jsObj, 'latitude'),
    longitude: IsarNative.jsObjectGet(jsObj, 'longitude'),
    name: IsarNative.jsObjectGet(jsObj, 'name'),
    table: IsarNative.jsObjectGet(jsObj, 'table'),
  );
  return object;
}

P _branchDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'active':
      return (IsarNative.jsObjectGet(jsObj, 'active')) as P;
    case 'description':
      return (IsarNative.jsObjectGet(jsObj, 'description')) as P;
    case 'fbusinessId':
      return (IsarNative.jsObjectGet(jsObj, 'fbusinessId')) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'latitude':
      return (IsarNative.jsObjectGet(jsObj, 'latitude')) as P;
    case 'longitude':
      return (IsarNative.jsObjectGet(jsObj, 'longitude')) as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name')) as P;
    case 'table':
      return (IsarNative.jsObjectGet(jsObj, 'table')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _branchAttachLinks(IsarCollection col, int id, Branch object) {}

extension BranchQueryWhereSort on QueryBuilder<Branch, Branch, QWhere> {
  QueryBuilder<Branch, Branch, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension BranchQueryWhere on QueryBuilder<Branch, Branch, QWhereClause> {
  QueryBuilder<Branch, Branch, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Branch, Branch, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Branch, Branch, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Branch, Branch, QAfterWhereClause> idBetween(
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

extension BranchQueryFilter on QueryBuilder<Branch, Branch, QFilterCondition> {
  QueryBuilder<Branch, Branch, QAfterFilterCondition> activeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'active',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> activeEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'description',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'description',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'description',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'description',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> fbusinessIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'fbusinessId',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> fbusinessIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'fbusinessId',
      value: value,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> fbusinessIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'fbusinessId',
      value: value,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> fbusinessIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'fbusinessId',
      value: value,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> fbusinessIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'fbusinessId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'latitude',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'latitude',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'latitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> latitudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'latitude',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'longitude',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'longitude',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'longitude',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> longitudeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'longitude',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'name',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'table',
      value: null,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableEqualTo(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableGreaterThan(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableLessThan(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableBetween(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableStartsWith(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableEndsWith(
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

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'table',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Branch, Branch, QAfterFilterCondition> tableMatches(
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

extension BranchQueryLinks on QueryBuilder<Branch, Branch, QFilterCondition> {}

extension BranchQueryWhereSortBy on QueryBuilder<Branch, Branch, QSortBy> {
  QueryBuilder<Branch, Branch, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByDescription() {
    return addSortByInternal('description', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByDescriptionDesc() {
    return addSortByInternal('description', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByFbusinessId() {
    return addSortByInternal('fbusinessId', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByFbusinessIdDesc() {
    return addSortByInternal('fbusinessId', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByLatitude() {
    return addSortByInternal('latitude', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByLatitudeDesc() {
    return addSortByInternal('latitude', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByLongitude() {
    return addSortByInternal('longitude', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByLongitudeDesc() {
    return addSortByInternal('longitude', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> sortByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }
}

extension BranchQueryWhereSortThenBy
    on QueryBuilder<Branch, Branch, QSortThenBy> {
  QueryBuilder<Branch, Branch, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByDescription() {
    return addSortByInternal('description', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByDescriptionDesc() {
    return addSortByInternal('description', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByFbusinessId() {
    return addSortByInternal('fbusinessId', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByFbusinessIdDesc() {
    return addSortByInternal('fbusinessId', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByLatitude() {
    return addSortByInternal('latitude', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByLatitudeDesc() {
    return addSortByInternal('latitude', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByLongitude() {
    return addSortByInternal('longitude', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByLongitudeDesc() {
    return addSortByInternal('longitude', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByTable() {
    return addSortByInternal('table', Sort.asc);
  }

  QueryBuilder<Branch, Branch, QAfterSortBy> thenByTableDesc() {
    return addSortByInternal('table', Sort.desc);
  }
}

extension BranchQueryWhereDistinct on QueryBuilder<Branch, Branch, QDistinct> {
  QueryBuilder<Branch, Branch, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('description', caseSensitive: caseSensitive);
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctByFbusinessId() {
    return addDistinctByInternal('fbusinessId');
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctByLatitude(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('latitude', caseSensitive: caseSensitive);
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctByLongitude(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('longitude', caseSensitive: caseSensitive);
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Branch, Branch, QDistinct> distinctByTable(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('table', caseSensitive: caseSensitive);
  }
}

extension BranchQueryProperty on QueryBuilder<Branch, Branch, QQueryProperty> {
  QueryBuilder<Branch, bool?, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<Branch, String?, QQueryOperations> descriptionProperty() {
    return addPropertyNameInternal('description');
  }

  QueryBuilder<Branch, int?, QQueryOperations> fbusinessIdProperty() {
    return addPropertyNameInternal('fbusinessId');
  }

  QueryBuilder<Branch, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Branch, String?, QQueryOperations> latitudeProperty() {
    return addPropertyNameInternal('latitude');
  }

  QueryBuilder<Branch, String?, QQueryOperations> longitudeProperty() {
    return addPropertyNameInternal('longitude');
  }

  QueryBuilder<Branch, String?, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Branch, String?, QQueryOperations> tableProperty() {
    return addPropertyNameInternal('table');
  }
}
