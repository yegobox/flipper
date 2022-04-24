// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetPinCollection on Isar {
  IsarCollection<Pin> get pins => getCollection();
}

const PinSchema = CollectionSchema(
  name: 'Pin',
  schema:
      '{"name":"Pin","idName":"id","properties":[{"name":"branchId","type":"Long"},{"name":"businessId","type":"Long"},{"name":"phoneNumber","type":"String"},{"name":"pin","type":"Long"},{"name":"userId","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'branchId': 0,
    'businessId': 1,
    'phoneNumber': 2,
    'pin': 3,
    'userId': 4
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _pinGetId,
  setId: _pinSetId,
  getLinks: _pinGetLinks,
  attachLinks: _pinAttachLinks,
  serializeNative: _pinSerializeNative,
  deserializeNative: _pinDeserializeNative,
  deserializePropNative: _pinDeserializePropNative,
  serializeWeb: _pinSerializeWeb,
  deserializeWeb: _pinDeserializeWeb,
  deserializePropWeb: _pinDeserializePropWeb,
  version: 3,
);

int? _pinGetId(Pin object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _pinSetId(Pin object, int id) {
  object.id = id;
}

List<IsarLinkBase> _pinGetLinks(Pin object) {
  return [];
}

void _pinSerializeNative(IsarCollection<Pin> collection, IsarRawObject rawObj,
    Pin object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.branchId;
  final _branchId = value0;
  final value1 = object.businessId;
  final _businessId = value1;
  final value2 = object.phoneNumber;
  final _phoneNumber = IsarBinaryWriter.utf8Encoder.convert(value2);
  dynamicSize += (_phoneNumber.length) as int;
  final value3 = object.pin;
  final _pin = value3;
  final value4 = object.userId;
  final _userId = IsarBinaryWriter.utf8Encoder.convert(value4);
  dynamicSize += (_userId.length) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeLong(offsets[0], _branchId);
  writer.writeLong(offsets[1], _businessId);
  writer.writeBytes(offsets[2], _phoneNumber);
  writer.writeLong(offsets[3], _pin);
  writer.writeBytes(offsets[4], _userId);
}

Pin _pinDeserializeNative(IsarCollection<Pin> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Pin(
    branchId: reader.readLong(offsets[0]),
    businessId: reader.readLong(offsets[1]),
    phoneNumber: reader.readString(offsets[2]),
    pin: reader.readLong(offsets[3]),
    userId: reader.readString(offsets[4]),
  );
  object.id = id;
  return object;
}

P _pinDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _pinSerializeWeb(IsarCollection<Pin> collection, Pin object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'businessId', object.businessId);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'phoneNumber', object.phoneNumber);
  IsarNative.jsObjectSet(jsObj, 'pin', object.pin);
  IsarNative.jsObjectSet(jsObj, 'userId', object.userId);
  return jsObj;
}

Pin _pinDeserializeWeb(IsarCollection<Pin> collection, dynamic jsObj) {
  final object = Pin(
    branchId:
        IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity,
    businessId:
        IsarNative.jsObjectGet(jsObj, 'businessId') ?? double.negativeInfinity,
    phoneNumber: IsarNative.jsObjectGet(jsObj, 'phoneNumber') ?? '',
    pin: IsarNative.jsObjectGet(jsObj, 'pin') ?? double.negativeInfinity,
    userId: IsarNative.jsObjectGet(jsObj, 'userId') ?? '',
  );
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  return object;
}

P _pinDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
    case 'businessId':
      return (IsarNative.jsObjectGet(jsObj, 'businessId') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'phoneNumber':
      return (IsarNative.jsObjectGet(jsObj, 'phoneNumber') ?? '') as P;
    case 'pin':
      return (IsarNative.jsObjectGet(jsObj, 'pin') ?? double.negativeInfinity)
          as P;
    case 'userId':
      return (IsarNative.jsObjectGet(jsObj, 'userId') ?? '') as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _pinAttachLinks(IsarCollection col, int id, Pin object) {}

extension PinQueryWhereSort on QueryBuilder<Pin, Pin, QWhere> {
  QueryBuilder<Pin, Pin, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension PinQueryWhere on QueryBuilder<Pin, Pin, QWhereClause> {
  QueryBuilder<Pin, Pin, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Pin, Pin, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Pin, Pin, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Pin, Pin, QAfterWhereClause> idBetween(
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

extension PinQueryFilter on QueryBuilder<Pin, Pin, QFilterCondition> {
  QueryBuilder<Pin, Pin, QAfterFilterCondition> branchIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> businessIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> businessIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> businessIdLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'businessId',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> businessIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'businessId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberEqualTo(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberGreaterThan(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberLessThan(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberBetween(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberStartsWith(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberEndsWith(
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

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'phoneNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> phoneNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'phoneNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> pinEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'pin',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> pinGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'pin',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> pinLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'pin',
      value: value,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> pinBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'pin',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'userId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'userId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Pin, Pin, QAfterFilterCondition> userIdMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'userId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension PinQueryLinks on QueryBuilder<Pin, Pin, QFilterCondition> {}

extension PinQueryWhereSortBy on QueryBuilder<Pin, Pin, QSortBy> {
  QueryBuilder<Pin, Pin, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByBusinessId() {
    return addSortByInternal('businessId', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByBusinessIdDesc() {
    return addSortByInternal('businessId', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByPhoneNumber() {
    return addSortByInternal('phoneNumber', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByPhoneNumberDesc() {
    return addSortByInternal('phoneNumber', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByPin() {
    return addSortByInternal('pin', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByPinDesc() {
    return addSortByInternal('pin', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> sortByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension PinQueryWhereSortThenBy on QueryBuilder<Pin, Pin, QSortThenBy> {
  QueryBuilder<Pin, Pin, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByBusinessId() {
    return addSortByInternal('businessId', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByBusinessIdDesc() {
    return addSortByInternal('businessId', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByPhoneNumber() {
    return addSortByInternal('phoneNumber', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByPhoneNumberDesc() {
    return addSortByInternal('phoneNumber', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByPin() {
    return addSortByInternal('pin', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByPinDesc() {
    return addSortByInternal('pin', Sort.desc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByUserId() {
    return addSortByInternal('userId', Sort.asc);
  }

  QueryBuilder<Pin, Pin, QAfterSortBy> thenByUserIdDesc() {
    return addSortByInternal('userId', Sort.desc);
  }
}

extension PinQueryWhereDistinct on QueryBuilder<Pin, Pin, QDistinct> {
  QueryBuilder<Pin, Pin, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Pin, Pin, QDistinct> distinctByBusinessId() {
    return addDistinctByInternal('businessId');
  }

  QueryBuilder<Pin, Pin, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Pin, Pin, QDistinct> distinctByPhoneNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('phoneNumber', caseSensitive: caseSensitive);
  }

  QueryBuilder<Pin, Pin, QDistinct> distinctByPin() {
    return addDistinctByInternal('pin');
  }

  QueryBuilder<Pin, Pin, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('userId', caseSensitive: caseSensitive);
  }
}

extension PinQueryProperty on QueryBuilder<Pin, Pin, QQueryProperty> {
  QueryBuilder<Pin, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Pin, int, QQueryOperations> businessIdProperty() {
    return addPropertyNameInternal('businessId');
  }

  QueryBuilder<Pin, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Pin, String, QQueryOperations> phoneNumberProperty() {
    return addPropertyNameInternal('phoneNumber');
  }

  QueryBuilder<Pin, int, QQueryOperations> pinProperty() {
    return addPropertyNameInternal('pin');
  }

  QueryBuilder<Pin, String, QQueryOperations> userIdProperty() {
    return addPropertyNameInternal('userId');
  }
}
