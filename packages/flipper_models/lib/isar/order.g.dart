// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetOrderFSyncCollection on Isar {
  IsarCollection<OrderFSync> get orderFSyncs {
    return getCollection('OrderFSync');
  }
}

final OrderFSyncSchema = CollectionSchema(
  name: 'OrderFSync',
  schema:
      '{"name":"OrderFSync","idName":"id","properties":[{"name":"active","type":"Bool"},{"name":"branchId","type":"Long"},{"name":"cashReceived","type":"Double"},{"name":"createdAt","type":"String"},{"name":"customerChangeDue","type":"Double"},{"name":"customerId","type":"Long"},{"name":"draft","type":"Bool"},{"name":"note","type":"String"},{"name":"orderNumber","type":"String"},{"name":"orderType","type":"String"},{"name":"paymentType","type":"String"},{"name":"reference","type":"String"},{"name":"reported","type":"Bool"},{"name":"status","type":"String"},{"name":"subTotal","type":"Double"},{"name":"updatedAt","type":"String"}],"indexes":[],"links":[{"name":"orderItems","target":"OrderItemSync"}]}',
  nativeAdapter: const _OrderFSyncNativeAdapter(),
  webAdapter: const _OrderFSyncWebAdapter(),
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
  indexIds: {},
  indexTypes: {},
  linkIds: {'orderItems': 0},
  backlinkIds: {},
  linkedCollections: ['OrderItemSync'],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [obj.orderItems],
  version: 2,
);

class _OrderFSyncWebAdapter extends IsarWebTypeAdapter<OrderFSync> {
  const _OrderFSyncWebAdapter();

  @override
  Object serialize(IsarCollection<OrderFSync> collection, OrderFSync object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'active', object.active);
    IsarNative.jsObjectSet(jsObj, 'branchId', object.branchId);
    IsarNative.jsObjectSet(jsObj, 'cashReceived', object.cashReceived);
    IsarNative.jsObjectSet(jsObj, 'createdAt', object.createdAt);
    IsarNative.jsObjectSet(
        jsObj, 'customerChangeDue', object.customerChangeDue);
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

  @override
  OrderFSync deserialize(IsarCollection<OrderFSync> collection, dynamic jsObj) {
    final object = OrderFSync();
    object.active = IsarNative.jsObjectGet(jsObj, 'active') ?? false;
    object.branchId =
        IsarNative.jsObjectGet(jsObj, 'branchId') ?? double.negativeInfinity;
    object.cashReceived = IsarNative.jsObjectGet(jsObj, 'cashReceived') ??
        double.negativeInfinity;
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
    attachLinks(collection.isar,
        IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity, object);
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
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

  @override
  void attachLinks(Isar isar, int id, OrderFSync object) {
    object.orderItems.attach(
      id,
      isar.orderFSyncs,
      isar.getCollection<OrderItemSync>('OrderItemSync'),
      'orderItems',
      false,
    );
  }
}

class _OrderFSyncNativeAdapter extends IsarNativeTypeAdapter<OrderFSync> {
  const _OrderFSyncNativeAdapter();

  @override
  void serialize(
      IsarCollection<OrderFSync> collection,
      IsarRawObject rawObj,
      OrderFSync object,
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

  @override
  OrderFSync deserialize(IsarCollection<OrderFSync> collection, int id,
      IsarBinaryReader reader, List<int> offsets) {
    final object = OrderFSync();
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
    attachLinks(collection.isar, id, object);
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

  @override
  void attachLinks(Isar isar, int id, OrderFSync object) {
    object.orderItems.attach(
      id,
      isar.orderFSyncs,
      isar.getCollection<OrderItemSync>('OrderItemSync'),
      'orderItems',
      false,
    );
  }
}

extension OrderFSyncQueryWhereSort
    on QueryBuilder<OrderFSync, OrderFSync, QWhere> {
  QueryBuilder<OrderFSync, OrderFSync, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension OrderFSyncQueryWhere
    on QueryBuilder<OrderFSync, OrderFSync, QWhereClause> {
  QueryBuilder<OrderFSync, OrderFSync, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterWhereClause> idGreaterThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterWhereClause> idLessThan(
    int id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterWhereClause> idBetween(
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

extension OrderFSyncQueryFilter
    on QueryBuilder<OrderFSync, OrderFSync, QFilterCondition> {
  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> activeEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'active',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> branchIdEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'branchId',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      branchIdGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> branchIdLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> branchIdBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      cashReceivedGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'cashReceived',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      cashReceivedLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'cashReceived',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      cashReceivedBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'cashReceived',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> createdAtEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      createdAtStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> createdAtEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'createdAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'createdAt',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      customerChangeDueGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'customerChangeDue',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      customerChangeDueLessThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'customerChangeDue',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      customerChangeDueBetween(double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'customerChangeDue',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      customerIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'customerId',
      value: null,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> customerIdEqualTo(
      int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'customerId',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      customerIdGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      customerIdLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> customerIdBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> draftEqualTo(
      bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'draft',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> idBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'note',
      value: null,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'note',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> noteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'note',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'orderNumber',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderNumberMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'orderNumber',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> orderTypeEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderTypeGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> orderTypeLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> orderTypeBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      orderTypeStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> orderTypeEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> orderTypeContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'orderType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> orderTypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'orderType',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'paymentType',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      paymentTypeMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'paymentType',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> referenceEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      referenceGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> referenceLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> referenceBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      referenceStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> referenceEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> referenceContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'reference',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> referenceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'reference',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> reportedIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'reported',
      value: null,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> reportedEqualTo(
      bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'reported',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'status',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'status',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      subTotalGreaterThan(double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: false,
      property: 'subTotal',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> subTotalLessThan(
      double value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: false,
      property: 'subTotal',
      value: value,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> subTotalBetween(
      double lower, double upper) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'subTotal',
      lower: lower,
      includeLower: false,
      upper: upper,
      includeUpper: false,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      updatedAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'updatedAt',
      value: null,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> updatedAtEqualTo(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition>
      updatedAtStartsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> updatedAtEndsWith(
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

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> updatedAtContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'updatedAt',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterFilterCondition> updatedAtMatches(
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

extension OrderFSyncQueryWhereSortBy
    on QueryBuilder<OrderFSync, OrderFSync, QSortBy> {
  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCashReceived() {
    return addSortByInternal('cashReceived', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCashReceivedDesc() {
    return addSortByInternal('cashReceived', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCustomerChangeDue() {
    return addSortByInternal('customerChangeDue', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy>
      sortByCustomerChangeDueDesc() {
    return addSortByInternal('customerChangeDue', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCustomerId() {
    return addSortByInternal('customerId', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByCustomerIdDesc() {
    return addSortByInternal('customerId', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByOrderNumber() {
    return addSortByInternal('orderNumber', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByOrderNumberDesc() {
    return addSortByInternal('orderNumber', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByOrderType() {
    return addSortByInternal('orderType', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByOrderTypeDesc() {
    return addSortByInternal('orderType', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByPaymentType() {
    return addSortByInternal('paymentType', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByPaymentTypeDesc() {
    return addSortByInternal('paymentType', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByReference() {
    return addSortByInternal('reference', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByReferenceDesc() {
    return addSortByInternal('reference', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByStatus() {
    return addSortByInternal('status', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByStatusDesc() {
    return addSortByInternal('status', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortBySubTotal() {
    return addSortByInternal('subTotal', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortBySubTotalDesc() {
    return addSortByInternal('subTotal', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> sortByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension OrderFSyncQueryWhereSortThenBy
    on QueryBuilder<OrderFSync, OrderFSync, QSortThenBy> {
  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByActive() {
    return addSortByInternal('active', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByActiveDesc() {
    return addSortByInternal('active', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByBranchId() {
    return addSortByInternal('branchId', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByBranchIdDesc() {
    return addSortByInternal('branchId', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCashReceived() {
    return addSortByInternal('cashReceived', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCashReceivedDesc() {
    return addSortByInternal('cashReceived', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCreatedAt() {
    return addSortByInternal('createdAt', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCreatedAtDesc() {
    return addSortByInternal('createdAt', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCustomerChangeDue() {
    return addSortByInternal('customerChangeDue', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy>
      thenByCustomerChangeDueDesc() {
    return addSortByInternal('customerChangeDue', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCustomerId() {
    return addSortByInternal('customerId', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByCustomerIdDesc() {
    return addSortByInternal('customerId', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByDraft() {
    return addSortByInternal('draft', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByDraftDesc() {
    return addSortByInternal('draft', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByNote() {
    return addSortByInternal('note', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByNoteDesc() {
    return addSortByInternal('note', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByOrderNumber() {
    return addSortByInternal('orderNumber', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByOrderNumberDesc() {
    return addSortByInternal('orderNumber', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByOrderType() {
    return addSortByInternal('orderType', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByOrderTypeDesc() {
    return addSortByInternal('orderType', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByPaymentType() {
    return addSortByInternal('paymentType', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByPaymentTypeDesc() {
    return addSortByInternal('paymentType', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByReference() {
    return addSortByInternal('reference', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByReferenceDesc() {
    return addSortByInternal('reference', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByReported() {
    return addSortByInternal('reported', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByReportedDesc() {
    return addSortByInternal('reported', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByStatus() {
    return addSortByInternal('status', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByStatusDesc() {
    return addSortByInternal('status', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenBySubTotal() {
    return addSortByInternal('subTotal', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenBySubTotalDesc() {
    return addSortByInternal('subTotal', Sort.desc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByUpdatedAt() {
    return addSortByInternal('updatedAt', Sort.asc);
  }

  QueryBuilder<OrderFSync, OrderFSync, QAfterSortBy> thenByUpdatedAtDesc() {
    return addSortByInternal('updatedAt', Sort.desc);
  }
}

extension OrderFSyncQueryWhereDistinct
    on QueryBuilder<OrderFSync, OrderFSync, QDistinct> {
  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByActive() {
    return addDistinctByInternal('active');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByBranchId() {
    return addDistinctByInternal('branchId');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByCashReceived() {
    return addDistinctByInternal('cashReceived');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('createdAt', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct>
      distinctByCustomerChangeDue() {
    return addDistinctByInternal('customerChangeDue');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByCustomerId() {
    return addDistinctByInternal('customerId');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByDraft() {
    return addDistinctByInternal('draft');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('note', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByOrderNumber(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('orderNumber', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByOrderType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('orderType', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByPaymentType(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('paymentType', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByReference(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('reference', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByReported() {
    return addDistinctByInternal('reported');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('status', caseSensitive: caseSensitive);
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctBySubTotal() {
    return addDistinctByInternal('subTotal');
  }

  QueryBuilder<OrderFSync, OrderFSync, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('updatedAt', caseSensitive: caseSensitive);
  }
}

extension OrderFSyncQueryProperty
    on QueryBuilder<OrderFSync, OrderFSync, QQueryProperty> {
  QueryBuilder<OrderFSync, bool, QQueryOperations> activeProperty() {
    return addPropertyNameInternal('active');
  }

  QueryBuilder<OrderFSync, int, QQueryOperations> branchIdProperty() {
    return addPropertyNameInternal('branchId');
  }

  QueryBuilder<OrderFSync, double, QQueryOperations> cashReceivedProperty() {
    return addPropertyNameInternal('cashReceived');
  }

  QueryBuilder<OrderFSync, String, QQueryOperations> createdAtProperty() {
    return addPropertyNameInternal('createdAt');
  }

  QueryBuilder<OrderFSync, double, QQueryOperations>
      customerChangeDueProperty() {
    return addPropertyNameInternal('customerChangeDue');
  }

  QueryBuilder<OrderFSync, int?, QQueryOperations> customerIdProperty() {
    return addPropertyNameInternal('customerId');
  }

  QueryBuilder<OrderFSync, bool, QQueryOperations> draftProperty() {
    return addPropertyNameInternal('draft');
  }

  QueryBuilder<OrderFSync, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<OrderFSync, String?, QQueryOperations> noteProperty() {
    return addPropertyNameInternal('note');
  }

  QueryBuilder<OrderFSync, String, QQueryOperations> orderNumberProperty() {
    return addPropertyNameInternal('orderNumber');
  }

  QueryBuilder<OrderFSync, String, QQueryOperations> orderTypeProperty() {
    return addPropertyNameInternal('orderType');
  }

  QueryBuilder<OrderFSync, String, QQueryOperations> paymentTypeProperty() {
    return addPropertyNameInternal('paymentType');
  }

  QueryBuilder<OrderFSync, String, QQueryOperations> referenceProperty() {
    return addPropertyNameInternal('reference');
  }

  QueryBuilder<OrderFSync, bool?, QQueryOperations> reportedProperty() {
    return addPropertyNameInternal('reported');
  }

  QueryBuilder<OrderFSync, String, QQueryOperations> statusProperty() {
    return addPropertyNameInternal('status');
  }

  QueryBuilder<OrderFSync, double, QQueryOperations> subTotalProperty() {
    return addPropertyNameInternal('subTotal');
  }

  QueryBuilder<OrderFSync, String?, QQueryOperations> updatedAtProperty() {
    return addPropertyNameInternal('updatedAt');
  }
}
