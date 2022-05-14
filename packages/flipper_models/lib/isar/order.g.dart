// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetOrderCollection on Isar {
  IsarCollection<Order> get orders => getCollection();
}

const OrderSchema = CollectionSchema(
  name: 'Order',
  schema:
      '{"name":"Order","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"cashReceived","type":"Double"},{"name":"createdAt","type":"String"},{"name":"customerChangeDue","type":"Double"},{"name":"customerId","type":"Long"},{"name":"draft","type":"Bool"},{"name":"note","type":"String"},{"name":"orderNumber","type":"String"},{"name":"orderType","type":"String"},{"name":"paymentType","type":"String"},{"name":"reference","type":"String"},{"name":"reported","type":"Bool"},{"name":"status","type":"String"},{"name":"subTotal","type":"Double"},{"name":"updatedAt","type":"String"}],"indexes":[{"name":"branchId","unique":false,"properties":[{"name":"branchId","type":"Value","caseSensitive":false}]},{"name":"status_branchId","unique":false,"properties":[{"name":"status","type":"Hash","caseSensitive":true},{"name":"branchId","type":"Value","caseSensitive":false}]}],"links":[{"name":"discounts","target":"Discount"},{"name":"orderItems","target":"OrderItem"}]}',
  idName: 'id',
  propertyIds: {
    'active': 0,
    'branchId': 1,
    'cashReceived': 2,
    'createdAt': 3,
    'customerChangeDue': 4,
    'customerId': 5,
    'draft': 6,
    'note': 7,
    'orderNumber': 8,
    'orderType': 9,
    'paymentType': 10,
    'reference': 11,
    'reported': 12,
    'status': 13,
    'subTotal': 14,
    'updatedAt': 15
  },
  listProperties: {},
  indexIds: {'branchId': 0, 'status_branchId': 1},
  indexValueTypes: {
    'branchId': [
      IndexValueType.long,
    ],
    'status_branchId': [
      IndexValueType.stringHash,
      IndexValueType.long,
    ]
  },
  linkIds: {'discounts': 0, 'orderItems': 1},
  backlinkLinkNames: {},
  getId: _orderGetId,
  setId: _orderSetId,
  getLinks: _orderGetLinks,
  attachLinks: _orderAttachLinks,
  serializeNative: _orderSerializeNative,
  deserializeNative: _orderDeserializeNative,
  deserializePropNative: _orderDeserializePropNative,
  serializeWeb: _orderSerializeWeb,
  deserializeWeb: _orderDeserializeWeb,
  deserializePropWeb: _orderDeserializePropWeb,
  version: 3,
);

int? _orderGetId(Order object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _orderSetId(Order object, int id) {
  object.id = id;
}

List<IsarLinkBase> _orderGetLinks(Order object) {
  return [object.discounts, object.orderItems];
}

void _orderSerializeNative(
    IsarCollection<Order> collection,
    IsarRawObject rawObj,
    Order object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.active;
  final _active = value0;
  final value1 = object.branchId;
  final _branchId = value1;
  final value2 = object.cashReceived;
  final _cashReceived = value2;
  final value3 = object.createdAt;
  final _createdAt = IsarBinaryWriter.utf8Encoder.convert(value3);
  dynamicSize += (_createdAt.length) as int;
  final value4 = object.customerChangeDue;
  final _customerChangeDue = value4;
  final value5 = object.customerId;
  final _customerId = value5;
  final value6 = object.draft;
  final _draft = value6;
  final value7 = object.note;
  IsarUint8List? _note;
  if (value7 != null) {
    _note = IsarBinaryWriter.utf8Encoder.convert(value7);
  }
  dynamicSize += (_note?.length ?? 0) as int;
  final value8 = object.orderNumber;
  final _orderNumber = IsarBinaryWriter.utf8Encoder.convert(value8);
  dynamicSize += (_orderNumber.length) as int;
  final value9 = object.orderType;
  final _orderType = IsarBinaryWriter.utf8Encoder.convert(value9);
  dynamicSize += (_orderType.length) as int;
  final value10 = object.paymentType;
  final _paymentType = IsarBinaryWriter.utf8Encoder.convert(value10);
  dynamicSize += (_paymentType.length) as int;
  final value11 = object.reference;
  final _reference = IsarBinaryWriter.utf8Encoder.convert(value11);
  dynamicSize += (_reference.length) as int;
  final value12 = object.reported;
  final _reported = value12;
  final value13 = object.status;
  final _status = IsarBinaryWriter.utf8Encoder.convert(value13);
  dynamicSize += (_status.length) as int;
  final value14 = object.subTotal;
  final _subTotal = value14;
  final value15 = object.updatedAt;
  IsarUint8List? _updatedAt;
  if (value15 != null) {
    _updatedAt = IsarBinaryWriter.utf8Encoder.convert(value15);
  }
  dynamicSize += (_updatedAt?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _active);
  writer.writeLong(offsets[1], _branchId);
  writer.writeDouble(offsets[2], _cashReceived);
  writer.writeBytes(offsets[3], _createdAt);
  writer.writeDouble(offsets[4], _customerChangeDue);
  writer.writeLong(offsets[5], _customerId);
  writer.writeBool(offsets[6], _draft);
  writer.writeBytes(offsets[7], _note);
  writer.writeBytes(offsets[8], _orderNumber);
  writer.writeBytes(offsets[9], _orderType);
  writer.writeBytes(offsets[10], _paymentType);
  writer.writeBytes(offsets[11], _reference);
  writer.writeBool(offsets[12], _reported);
  writer.writeBytes(offsets[13], _status);
  writer.writeDouble(offsets[14], _subTotal);
  writer.writeBytes(offsets[15], _updatedAt);
}

Order _orderDeserializeNative(IsarCollection<Order> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Order();
  object.active = reader.readBool(offsets[0]);
  object.branchId = reader.readLong(offsets[1]);
  object.cashReceived = reader.readDouble(offsets[2]);
  object.createdAt = reader.readString(offsets[3]);
  object.customerChangeDue = reader.readDouble(offsets[4]);
  object.customerId = reader.readLongOrNull(offsets[5]);
  object.draft = reader.readBool(offsets[6]);
  object.id = id;
  object.note = reader.readStringOrNull(offsets[7]);
  object.orderNumber = reader.readString(offsets[8]);
  object.orderType = reader.readString(offsets[9]);
  object.paymentType = reader.readString(offsets[10]);
  object.reference = reader.readString(offsets[11]);
  object.reported = reader.readBoolOrNull(offsets[12]);
  object.status = reader.readString(offsets[13]);
  object.subTotal = reader.readDouble(offsets[14]);
  object.updatedAt = reader.readStringOrNull(offsets[15]);
  _orderAttachLinks(collection, id, object);
  return object;
}

P _orderDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBoolOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _orderSerializeWeb(IsarCollection<Order> collection, Order object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'active', object.active);
  IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
  IsarNative.jsObjectSet(jsObj, 'cashReceived', object.cashReceived);
  IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
  IsarNative.jsObjectSet(jsObj, 'customerChangeDue', object.customerChangeDue);
  IsarNative.jsObjectSet(jsObj, 'customerId', object.customerId);
  IsarNative.jsObjectSet(jsObj, 'draft', object.draft);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'note', object.note);
  IsarNative.jsObjectSet(jsObj, 'orderNumber', object.orderNumber);
  IsarNative.jsObjectSet(jsObj, 'orderType', object.orderType);
  IsarNative.jsObjectSet(jsObj, 'paymentType', object.paymentType);
  IsarNative.jsObjectSet(jsObj, 'reference', object.reference);
  IsarNative.jsObjectSet(jsObj, 'reported', object.reported);
  IsarNative.jsObjectSet(jsObj, 'status', object.status);
  IsarNative.jsObjectSet(jsObj, 'subTotal', object.subTotal);
  IsarNative.jsObjectSet(jsObj, 'updatedAt', object.updatedAt);
  return jsObj;
}

Order _orderDeserializeWeb(IsarCollection<Order> collection, dynamic jsObj) {
  final object = Order();
  object.active = IsarNative.jsObjectGet(jsObj, 'active') ?? false;
  object.branchId =
      IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
  object.cashReceived =
      IsarNative.jsObjectGet(jsObj, 'cashReceived') ?? double.negativeInfinity;
  object.createdAt = IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '';
  object.customerChangeDue =
      IsarNative.jsObjectGet(jsObj, 'customerChangeDue') ??
          double.negativeInfinity;
  object.customerId = IsarNative.jsObjectGet(jsObj, 'customerId');
  object.draft = IsarNative.jsObjectGet(jsObj, 'draft') ?? false;
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.note = IsarNative.jsObjectGet(jsObj, 'note');
  object.orderNumber = IsarNative.jsObjectGet(jsObj, 'orderNumber') ?? '';
  object.orderType = IsarNative.jsObjectGet(jsObj, 'orderType') ?? '';
  object.paymentType = IsarNative.jsObjectGet(jsObj, 'paymentType') ?? '';
  object.reference = IsarNative.jsObjectGet(jsObj, 'reference') ?? '';
  object.reported = IsarNative.jsObjectGet(jsObj, 'reported');
  object.status = IsarNative.jsObjectGet(jsObj, 'status') ?? '';
  object.subTotal =
      IsarNative.jsObjectGet(jsObj, 'subTotal') ?? double.negativeInfinity;
  object.updatedAt = IsarNative.jsObjectGet(jsObj, 'updatedAt');
  _orderAttachLinks(collection,
      IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
  return object;
}

P _orderDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'active':
      return (IsarNative.jsObjectGet(jsObj, 'active') ?? false) as P;
    case 'branchId':
      return (IsarNative.jsObjectGet(jsObj, 'branchId') ??
          double.negativeInfinity) as P;
    case 'cashReceived':
      return (IsarNative.jsObjectGet(jsObj, 'cashReceived') ??
          double.negativeInfinity) as P;
    case 'createdAt':
      return (IsarNative.jsObjectGet(jsObj, 'createdAt') ?? '') as P;
    case 'customerChangeDue':
      return (IsarNative.jsObjectGet(jsObj, 'customerChangeDue') ??
          double.negativeInfinity) as P;
    case 'customerId':
      return (IsarNative.jsObjectGet(jsObj, 'customerId')) as P;
    case 'draft':
      return (IsarNative.jsObjectGet(jsObj, 'draft') ?? false) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'note':
      return (IsarNative.jsObjectGet(jsObj, 'note')) as P;
    case 'orderNumber':
      return (IsarNative.jsObjectGet(jsObj, 'orderNumber') ?? '') as P;
    case 'orderType':
      return (IsarNative.jsObjectGet(jsObj, 'orderType') ?? '') as P;
    case 'paymentType':
      return (IsarNative.jsObjectGet(jsObj, 'paymentType') ?? '') as P;
    case 'reference':
      return (IsarNative.jsObjectGet(jsObj, 'reference') ?? '') as P;
    case 'reported':
      return (IsarNative.jsObjectGet(jsObj, 'reported')) as P;
    case 'status':
      return (IsarNative.jsObjectGet(jsObj, 'status') ?? '') as P;
    case 'subTotal':
      return (IsarNative.jsObjectGet(jsObj, 'subTotal') ??
          double.negativeInfinity) as P;
    case 'updatedAt':
      return (IsarNative.jsObjectGet(jsObj, 'updatedAt')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _orderAttachLinks(IsarCollection col, int id, Order object) {
  object.discounts.attach(col, col.isar.discounts, 'discounts', id);
  object.orderItems.attach(col, col.isar.orderItems, 'orderItems', id);
}

extension OrderQueryWhereSort on QueryBuilder<Order, Order, QWhere> {
  QueryBuilder<Order, Order, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }

  QueryBuilder<Order, Order, QAfterWhere> anyBranchId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'branchId'));
  }

  QueryBuilder<Order, Order, QAfterWhere> anyStatusBranchId() {
    return addWhereClauseInternal(
        const IndexWhereClause.any(indexName: 'status_branchId'));
  }
}

extension OrderQueryWhere on QueryBuilder<Order, Order, QWhereClause> {
  QueryBuilder<Order, Order, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Order, Order, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Order, Order, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Order, Order, QAfterWhereClause> idBetween(
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

  QueryBuilder<Order, Order, QAfterWhereClause> branchIdEqualTo(int branchId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'branchId',
      value: [branchId],
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> branchIdNotEqualTo(
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

  QueryBuilder<Order, Order, QAfterWhereClause> branchIdGreaterThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'branchId',
      lower: [branchId],
      includeLower: include,
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> branchIdLessThan(
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'branchId',
      upper: [branchId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> branchIdBetween(
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

  QueryBuilder<Order, Order, QAfterWhereClause> statusEqualTo(String status) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'status_branchId',
      value: [status],
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> statusNotEqualTo(
      String status) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'status_branchId',
        upper: [status],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'status_branchId',
        lower: [status],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'status_branchId',
        lower: [status],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'status_branchId',
        upper: [status],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Order, Order, QAfterWhereClause> statusBranchIdEqualTo(
      String status, int branchId) {
    return addWhereClauseInternal(IndexWhereClause.equalTo(
      indexName: 'status_branchId',
      value: [status, branchId],
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> statusBranchIdNotEqualTo(
      String status, int branchId) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'status_branchId',
        upper: [status, branchId],
        includeUpper: false,
      )).addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'status_branchId',
        lower: [status, branchId],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(IndexWhereClause.greaterThan(
        indexName: 'status_branchId',
        lower: [status, branchId],
        includeLower: false,
      )).addWhereClauseInternal(IndexWhereClause.lessThan(
        indexName: 'status_branchId',
        upper: [status, branchId],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<Order, Order, QAfterWhereClause>
      statusEqualToBranchIdGreaterThan(
    String status,
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.greaterThan(
      indexName: 'status_branchId',
      lower: [status, branchId],
      includeLower: include,
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> statusEqualToBranchIdLessThan(
    String status,
    int branchId, {
    bool include = false,
  }) {
    return addWhereClauseInternal(IndexWhereClause.lessThan(
      indexName: 'status_branchId',
      upper: [status, branchId],
      includeUpper: include,
    ));
  }

  QueryBuilder<Order, Order, QAfterWhereClause> statusEqualToBranchIdBetween(
    String status,
    int lowerBranchId,
    int upperBranchId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IndexWhereClause.between(
      indexName: 'status_branchId',
      lower: [status, lowerBranchId],
      includeLower: includeLower,
      upper: [status, upperBranchId],
      includeUpper: includeUpper,
    ));
  }
}

extension OrderQueryFilter on QueryBuilder<Order, Order, QFilterCondition> {
  QueryBuilder<Order, Order, QAfterFilterCondition> activeEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> branchIdEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> branchIdGreaterThan(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> cashReceivedGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'cashReceived',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> cashReceivedLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'cashReceived',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> cashReceivedBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'cashReceived',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'createdAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition>
      customerChangeDueGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'customerChangeDue',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerChangeDueLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'customerChangeDue',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerChangeDueBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'customerChangeDue',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'customerId',
      value: null,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'customerId',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'customerId',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'customerId',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> customerIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'customerId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> draftEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'draft',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> noteIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'note',
      value: null,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'note',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> noteMatches(String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'note',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'orderNumber',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderNumberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'orderNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'orderType',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'orderType',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'paymentType',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> paymentTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'paymentType',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'reference',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> referenceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'reference',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> reportedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'reported',
      value: null,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> reportedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reported',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'status',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusContains(String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'status',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> subTotalGreaterThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'subTotal',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> subTotalLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'subTotal',
      value: value,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> subTotalBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'subTotal',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'updatedAt',
      value: null,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtEqualTo(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtStartsWith(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtEndsWith(
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

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> updatedAtMatches(
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

extension OrderQueryLinks on QueryBuilder<Order, Order, QFilterCondition> {
  QueryBuilder<Order, Order, QAfterFilterCondition> discounts(
      FilterQuery<Discount> q) {
    return linkInternal(
      isar.discounts,
      q,
      'discounts',
    );
  }

  QueryBuilder<Order, Order, QAfterFilterCondition> orderItems(
      FilterQuery<OrderItem> q) {
    return linkInternal(
      isar.orderItems,
      q,
      'orderItems',
    );
  }
}

extension OrderQueryWhereSortBy on QueryBuilder<Order, Order, QSortBy> {
  QueryBuilder<Order, Order, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCashReceived() {
    return addSortByInternal('cashReceived', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCashReceivedDesc() {
    return addSortByInternal('cashReceived', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCustomerChangeDue() {
    return addSortByInternal('customerChangeDue', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCustomerChangeDueDesc() {
    return addSortByInternal('customerChangeDue', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCustomerId() {
    return addSortByInternal('customerId', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByCustomerIdDesc() {
    return addSortByInternal('customerId', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByOrderNumber() {
    return addSortByInternal('orderNumber', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByOrderNumberDesc() {
    return addSortByInternal('orderNumber', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByOrderType() {
    return addSortByInternal('orderType', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByOrderTypeDesc() {
    return addSortByInternal('orderType', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByPaymentType() {
    return addSortByInternal('paymentType', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByPaymentTypeDesc() {
    return addSortByInternal('paymentType', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByReference() {
    return addSortByInternal('reference', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByReferenceDesc() {
    return addSortByInternal('reference', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByStatus() {
    return addSortByInternal('status', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByStatusDesc() {
    return addSortByInternal('status', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortBySubTotal() {
    return addSortByInternal('subTotal', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortBySubTotalDesc() {
    return addSortByInternal('subTotal', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> sortByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension OrderQueryWhereSortThenBy on QueryBuilder<Order, Order, QSortThenBy> {
  QueryBuilder<Order, Order, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCashReceived() {
    return addSortByInternal('cashReceived', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCashReceivedDesc() {
    return addSortByInternal('cashReceived', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCustomerChangeDue() {
    return addSortByInternal('customerChangeDue', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCustomerChangeDueDesc() {
    return addSortByInternal('customerChangeDue', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCustomerId() {
    return addSortByInternal('customerId', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByCustomerIdDesc() {
    return addSortByInternal('customerId', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByOrderNumber() {
    return addSortByInternal('orderNumber', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByOrderNumberDesc() {
    return addSortByInternal('orderNumber', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByOrderType() {
    return addSortByInternal('orderType', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByOrderTypeDesc() {
    return addSortByInternal('orderType', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByPaymentType() {
    return addSortByInternal('paymentType', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByPaymentTypeDesc() {
    return addSortByInternal('paymentType', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByReference() {
    return addSortByInternal('reference', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByReferenceDesc() {
    return addSortByInternal('reference', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByStatus() {
    return addSortByInternal('status', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByStatusDesc() {
    return addSortByInternal('status', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenBySubTotal() {
    return addSortByInternal('subTotal', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenBySubTotalDesc() {
    return addSortByInternal('subTotal', Sort.desc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<Order, Order, QAfterSortBy> thenByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension OrderQueryWhereDistinct on QueryBuilder<Order, Order, QDistinct> {
  QueryBuilder<Order, Order, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByCashReceived() {
    return addDistinctByInternal('cashReceived');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctByCustomerChangeDue() {
    return addDistinctByInternal('customerChangeDue');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByCustomerId() {
    return addDistinctByInternal('customerId');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByDraft() {
    return addDistinctByInternal('draft');
  }

  QueryBuilder<Order, Order, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('note', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctByOrderNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('orderNumber', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctByOrderType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('orderType', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctByPaymentType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('paymentType', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctByReference(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('reference', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctByReported() {
    return addDistinctByInternal('reported');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('status', caseSensitive: caseSensitive);
  }

  QueryBuilder<Order, Order, QDistinct> distinctBySubTotal() {
    return addDistinctByInternal('subTotal');
  }

  QueryBuilder<Order, Order, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('updatedAt', caseSensitive: caseSensitive);
  }
}

extension OrderQueryProperty on QueryBuilder<Order, Order, QQueryProperty> {
  QueryBuilder<Order, bool, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<Order, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<Order, double, QQueryOperations> cashReceivedProperty() {
    return addPropertyNameInternal('cashReceived');
  }

  QueryBuilder<Order, String, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<Order, double, QQueryOperations> customerChangeDueProperty() {
    return addPropertyNameInternal('customerChangeDue');
  }

  QueryBuilder<Order, int?, QQueryOperations> customerIdProperty() {
    return addPropertyNameInternal('customerId');
  }

  QueryBuilder<Order, bool, QQueryOperations> draftProperty() {
    return addPropertyNameInternal('draft');
  }

  QueryBuilder<Order, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Order, String?, QQueryOperations> noteProperty() {
    return addPropertyNameInternal('note');
  }

  QueryBuilder<Order, String, QQueryOperations> orderNumberProperty() {
    return addPropertyNameInternal('orderNumber');
  }

  QueryBuilder<Order, String, QQueryOperations> orderTypeProperty() {
    return addPropertyNameInternal('orderType');
  }

  QueryBuilder<Order, String, QQueryOperations> paymentTypeProperty() {
    return addPropertyNameInternal('paymentType');
  }

  QueryBuilder<Order, String, QQueryOperations> referenceProperty() {
    return addPropertyNameInternal('reference');
  }

  QueryBuilder<Order, bool?, QQueryOperations> reportedProperty() {
    return addPropertyNameInternal('reported');
  }

  QueryBuilder<Order, String, QQueryOperations> statusProperty() {
    return addPropertyNameInternal('status');
  }

  QueryBuilder<Order, double, QQueryOperations> subTotalProperty() {
    return addPropertyNameInternal('subTotal');
  }

  QueryBuilder<Order, String?, QQueryOperations> updatedAtProperty() {
    return addPropertyNameInternal('updatedAt');
  }
}
