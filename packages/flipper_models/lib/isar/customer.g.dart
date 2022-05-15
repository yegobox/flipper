// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable, no_leading_underscores_for_local_identifiers

extension GetCustomerCollection on Isar {
  IsarCollection<Customer> get customers => getCollection();
}

const CustomerSchema = CollectionSchema(
  name: 'Customer',
  schema:
      '{"name":"Customer","idName":"id","properties":[{"name":"address","type":"String"},{"name":"branchId","type":"Long"},{"name":"email","type":"String"},{"name":"name","type":"String"},{"name":"orderId","type":"Long"},{"name":"phone","type":"String"},{"name":"updatedAt","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'address': 0,
    'branchId': 1,
    'email': 2,
    'name': 3,
    'orderId': 4,
    'phone': 5,
    'updatedAt': 6
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _customerGetId,
  setId: _customerSetId,
  getLinks: _customerGetLinks,
  attachLinks: _customerAttachLinks,
  serializeNative: _customerSerializeNative,
  deserializeNative: _customerDeserializeNative,
  deserializePropNative: _customerDeserializePropNative,
  serializeWeb: _customerSerializeWeb,
  deserializeWeb: _customerDeserializeWeb,
  deserializePropWeb: _customerDeserializePropWeb,
  version: 4,
);

int? _customerGetId(Customer object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _customerSetId(Customer object, int id) {
  object.id = id;
}

List<IsarLinkBase> _customerGetLinks(Customer object) {
  return [];
}

void _customerSerializeNative(
    IsarCollection<Customer> collection,
    IsarCObject cObj,
    Customer object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.address;
  IsarUint8List? _address;
  if (value0 != null) {
    _address = IsarBinaryWriter.utf8Encoder.convert(value0);
  }
  dynamicSize += (_address?.length ?? 0) as int;
  final value1 = object.branchId;
  final _branchId = value1;
  final value2 = object.email;
  final _email = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_email.length) as int;
  final value3 = object.name;
  final _name = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_name.length) as int;
  final value4 = object.orderId;
  final _orderId = value4;
  final value5 = object.phone;
  final _phone = IsarBinaryWriter.utf8Encoder.convert(value5);
  dynamicSize += (_phone.length) as int;
  final value6 = object.updatedAt;
  IsarUint8List? _updatedAt;
  if (value6 != null) {
    _updatedAt = IsarBinaryWriter.utf8Encoder.convert(value6);
  }
  dynamicSize += (_updatedAt?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  cObj.buffer = alloc(size);
  cObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _address);
  writer.writeLong(offsets[1], _branchId);
  writer.writeBytes(offsets[2], _email);
  writer.writeBytes(offsets[3], _name);
  writer.writeLong(offsets[4], _orderId);
  writer.writeBytes(offsets[5], _phone);
  writer.writeBytes(offsets[6], _updatedAt);
}

Customer _customerDeserializeNative(IsarCollection<Customer> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Customer();
  object.address = reader.readStringOrNull(offsets[0]);
  object.branchId = reader.readLong(offsets[1]);
  object.email = reader.readString(offsets[2]);
  object.id = id;
  object.name = reader.readString(offsets[3]);
  object.orderId = reader.readLong(offsets[4]);
  object.phone = reader.readString(offsets[5]);
  object.updatedAt = reader.readStringOrNull(offsets[6]);
  return object;
}

P _customerDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _customerSerializeWeb(
    IsarCollection<Customer> collection, Customer object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'address', object.address);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'email', object.email);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'orderId', object.orderId);
  IsarNative.jsObjectSet(jsObj, 'phone', object.phone);
  IsarNative.jsObjectSet(jsObj, 'updatedAt', object.updatedAt);
  return jsObj;
}

Customer _customerDeserializeWeb(
    IsarCollection<Customer> collection, dynamic jsObj) {
  final object = Customer();
  object.address = IsarNative.jsObjectGet(jsObj, 'address');
  object.branchId =
      IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
  object.email = IsarNative.jsObjectGet(jsObj, 'email') ?? '';
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.name = IsarNative.jsObjectGet(jsObj, 'name') ?? '';
  object.orderId =
      IsarNative.jsObjectGet(jsObj, 'orderId') ?? double.negativeInfinity;
  object.phone = IsarNative.jsObjectGet(jsObj, 'phone') ?? '';
  object.updatedAt = IsarNative.jsObjectGet(jsObj, 'updatedAt');
  return object;
}

P _customerDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'address':
      return (IsarNative.jsObjectGet(jsObj, 'address')) as P;
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
    case 'email':
      return (IsarNative.jsObjectGet(jsObj, 'email') ?? '') as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name') ?? '') as P;
    case 'orderId':
      return (IsarNative.jsObjectGet(jsObj, 'orderId') ??
          double.negativeInfinity) as P;
    case 'phone':
      return (IsarNative.jsObjectGet(jsObj, 'phone') ?? '') as P;
    case 'updatedAt':
      return (IsarNative.jsObjectGet(jsObj, 'updatedAt')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _customerAttachLinks(IsarCollection col, int id, Customer object) {}

extension CustomerQueryWhereSort on QueryBuilder<Customer, Customer, QWhere> {
  QueryBuilder<Customer, Customer, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension CustomerQueryWhere on QueryBuilder<Customer, Customer, QWhereClause> {
  QueryBuilder<Customer, Customer, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Customer, Customer, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Customer, Customer, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Customer, Customer, QAfterWhereClause> idBetween(
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

extension CustomerQueryFilter
    on QueryBuilder<Customer, Customer, QFilterCondition> {
  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'address',
      value: null,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'address',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'address',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'address',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'address',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'address',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'address',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'address',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> addressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'address',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailEqualTo(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailGreaterThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailLessThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailBetween(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailStartsWith(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailEndsWith(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'email',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> emailMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'email',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> orderIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> orderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> orderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'orderId',
      value: value,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> orderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'orderId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'phone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'phone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'phone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'phone',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'phone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'phone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'phone',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> phoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'phone',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'updatedAt',
      value: null,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'updatedAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Customer, Customer, QAfterFilterCondition> updatedAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'updatedAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension CustomerQueryLinks
    on QueryBuilder<Customer, Customer, QFilterCondition> {}

extension CustomerQueryWhereSortBy
    on QueryBuilder<Customer, Customer, QSortBy> {
  QueryBuilder<Customer, Customer, QAfterSortBy> sortByAddress() {
    return addSortByInternal('address', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByAddressDesc() {
    return addSortByInternal('address', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByPhone() {
    return addSortByInternal('phone', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByPhoneDesc() {
    return addSortByInternal('phone', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> sortByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension CustomerQueryWhereSortThenBy
    on QueryBuilder<Customer, Customer, QSortThenBy> {
  QueryBuilder<Customer, Customer, QAfterSortBy> thenByAddress() {
    return addSortByInternal('address', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByAddressDesc() {
    return addSortByInternal('address', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByEmail() {
    return addSortByInternal('email', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByEmailDesc() {
    return addSortByInternal('email', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByOrderId() {
    return addSortByInternal('orderId', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByOrderIdDesc() {
    return addSortByInternal('orderId', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByPhone() {
    return addSortByInternal('phone', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByPhoneDesc() {
    return addSortByInternal('phone', Sort.desc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<Customer, Customer, QAfterSortBy> thenByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension CustomerQueryWhereDistinct
    on QueryBuilder<Customer, Customer, QDistinct> {
  QueryBuilder<Customer, Customer, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('address', caseSensitive: caseSensitive);
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctByEmail(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('email', caseSensitive: caseSensitive);
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctByOrderId() {
    return addDistinctByInternal('orderId');
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctByPhone(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('phone', caseSensitive: caseSensitive);
  }

  QueryBuilder<Customer, Customer, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('updatedAt', caseSensitive: caseSensitive);
  }
}

extension CustomerQueryProperty
    on QueryBuilder<Customer, Customer, QQueryProperty> {
  QueryBuilder<Customer, String?, QQueryOperations> addressProperty() {
    return addPropertyNameInternal('address');
  }

  QueryBuilder<Customer, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Customer, String, QQueryOperations> emailProperty() {
    return addPropertyNameInternal('email');
  }

  QueryBuilder<Customer, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Customer, String, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<Customer, int, QQueryOperations> orderIdProperty() {
    return addPropertyNameInternal('orderId');
  }

  QueryBuilder<Customer, String, QQueryOperations> phoneProperty() {
    return addPropertyNameInternal('phone');
  }

  QueryBuilder<Customer, String?, QQueryOperations> updatedAtProperty() {
    return addPropertyNameInternal('updatedAt');
  }
}
