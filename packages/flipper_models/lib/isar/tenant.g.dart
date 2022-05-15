// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetTenantSyncCollection on Isar {
  IsarCollection<TenantSync> get tenantSyncs => getCollection();
}

const TenantSyncSchema = CollectionSchema(
  name: 'TenantSync',
  schema:
      '{"name":"TenantSync","idName":"id","properties":[{"name":"email","type":"String"},{"name":"name","type":"String"},{"name":"phoneNumber","type":"String"}],"indexes":[],"links":[{"name":"branches","target":"Branch"},{"name":"permissions","target":"Permissionsync"}]}',
  idName: 'id',
  propertyIds: {'email': 0, 'name': 1, 'phoneNumber': 2},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {'branches': 0, 'permissions': 1},
  backlinkLinkNames: {},
  getId: _tenantSyncGetId,
  setId: _tenantSyncSetId,
  getLinks: _tenantSyncGetLinks,
  attachLinks: _tenantSyncAttachLinks,
  serializeNative: _tenantSyncSerializeNative,
  deserializeNative: _tenantSyncDeserializeNative,
  deserializePropNative: _tenantSyncDeserializePropNative,
  serializeWeb: _tenantSyncSerializeWeb,
  deserializeWeb: _tenantSyncDeserializeWeb,
  deserializePropWeb: _tenantSyncDeserializePropWeb,
  version: 4,
);

int? _tenantSyncGetId(TenantSync object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _tenantSyncSetId(TenantSync object, int id) {
  object.id = id;
}

List<IsarLinkBase> _tenantSyncGetLinks(TenantSync object) {
  return [object.branches, object.permissions];
}

void _tenantSyncSerializeNative(
    IsarCollection<TenantSync> collection,
    IsarCObject cObj,
    TenantSync object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.email;
  final _email = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_email.length) as int;
  final value1 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value1);
  dynamicSize += (_name.length) as int;
  final value2 = object.phoneNumber;
  final _phoneNumber = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_phoneNumber.length) as int;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _email);
  writer.writeBytes(offsets[1], _name);
  writer.writeBytes(offsets[2], _phoneNumber);
}

TenantSync _tenantSyncDeserializeNative(IsarCollection<TenantSync> collection,
    int id, IsarBinaryReader reader, List<int> offsets) {
  final object = TenantSync(
    email: reader.readString(offsets[0]),
    id: id,
    name: reader.readString(offsets[1]),
    phoneNumber: reader.readString(offsets[2]),
  );
  _tenantSyncAttachLinks(collection, id, object);
  return object;
}

P _tenantSyncDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _tenantSyncSerializeWeb(
    IsarCollection<TenantSync> collection, TenantSync object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'email', object.email);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'phoneNumber', object.phoneNumber);
  return jsObj;
}

TenantSync _tenantSyncDeserializeWeb(
    IsarCollection<TenantSync> collection, dynamic jsObj) {
  final object = TenantSync(
    email: IsarNative.jsObjectGet(jsObj, 'email') ?? '',
    id: IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity,
    name: IsarNative.jsObjectGet(jsObj, 'name') ?? '',
    phoneNumber: IsarNative.jsObjectGet(jsObj, 'phoneNumber') ?? '',
  );
  _tenantSyncAttachLinks(collection,
      IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
  return object;
}

P _tenantSyncDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'email':
      return (IsarNative.jsObjectGet(jsObj, 'email') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'phoneNumber':
      return (IsarNative.jsObjectGet(jsObj, 'phoneNumber') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _tenantSyncAttachLinks(IsarCollection col, int id, TenantSync object) {
  object.branches.attach(col, col.isar.branchs, 'branches', id);
  object.permissions.attach(col, col.isar.permissionsyncs, 'permissions', id);
}

extension TenantSyncQueryWhereSort
    on QueryBuilder<TenantSync, TenantSync, QWhere> {
  QueryBuilder<TenantSync, TenantSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension TenantSyncQueryWhere
    on QueryBuilder<TenantSync, TenantSync, QWhereClause> {
  QueryBuilder<TenantSync, TenantSync, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<TenantSync, TenantSync, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<TenantSync, TenantSync, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<TenantSync, TenantSync, QAfterWhereClause> idBetween(
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

extension TenantSyncQueryFilter
    on QueryBuilder<TenantSync, TenantSync, QFilterCondition> {
  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'email',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'email',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'phoneNumber',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition>
      phoneNumberMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'phoneNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension TenantSyncQueryLinks
    on QueryBuilder<TenantSync, TenantSync, QFilterCondition> {
  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> branches(
      FilterQuery<Branch> q) {
    return linkInternal(
      isar.branchs,
      q,
      'branches',
    );
  }

  QueryBuilder<TenantSync, TenantSync, QAfterFilterCondition> permissions(
      FilterQuery<Permissionsync> q) {
    return linkInternal(
      isar.permissionsyncs,
      q,
      'permissions',
    );
  }
}

extension TenantSyncQueryWhereSortBy
    on QueryBuilder<TenantSync, TenantSync, QSortBy> {
  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByPhoneNumber() {
    return addSortByInternal('phoneNumber', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> sortByPhoneNumberDesc() {
    return addSortByInternal('phoneNumber', Sort.desc);
  }
}

extension TenantSyncQueryWhereSortThenBy
    on QueryBuilder<TenantSync, TenantSync, QSortThenBy> {
  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByPhoneNumber() {
    return addSortByInternal('phoneNumber', Sort.asc);
  }

  QueryBuilder<TenantSync, TenantSync, QAfterSortBy> thenByPhoneNumberDesc() {
    return addSortByInternal('phoneNumber', Sort.desc);
  }
}

extension TenantSyncQueryWhereDistinct
    on QueryBuilder<TenantSync, TenantSync, QDistinct> {
  QueryBuilder<TenantSync, TenantSync, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('email', caseSensitive: caseSensitive);
  }

  QueryBuilder<TenantSync, TenantSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<TenantSync, TenantSync, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<TenantSync, TenantSync, QDistinct> distinctByPhoneNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('phoneNumber', caseSensitive: caseSensitive);
  }
}

extension TenantSyncQueryProperty
    on QueryBuilder<TenantSync, TenantSync, QQueryProperty> {
  QueryBuilder<TenantSync, String, QQueryOperations> emailProperty() {
    return addPropertyNameInternal('email');
  }

  QueryBuilder<TenantSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<TenantSync, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<TenantSync, String, QQueryOperations> phoneNumberProperty() {
    return addPropertyNameInternal('phoneNumber');
  }
}
